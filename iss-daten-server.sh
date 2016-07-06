#! /bin/bash
#XML Datei aus dem Internet holen
cd /home/karl/bin
wget -O iss-data.xml "https://spotthestation.nasa.gov/sightings/indexrss.cfm?country=Germany&region=None&city=Ludwigshafen" 
#warte 1 Sekunde
sleep 1
# Gibt es in XML <descrition> , gibt ers auch einen Überflug
#Hole die Zeile , die mit date begint, und die nächsten 5 Zeilen (1mal)
#HTML- Klammern entfernen
#Grad-Symbol einfügen
#TABs am Zeilenanfang enfernen
#Übersetzen deutsch
#Speichern als Text

if grep -q  \<description\>  iss-data.xml
then  grep -A5 -m1 Date:  iss-data.xml | sed  -e 's/^[ \t]*//' | sed '{
s/&lt;br\/&gt;//
s/&#176/°/
s/Date/Am/
s/AM/früh/
s/PM/abends/
s/Time/Um/
s/Duration/Dauer/
s/less than/weniger als/
s/minut/Minut/
s/Maximum Elevation/Max. über Horizont/
s/Approach/Geht auf/
s/above/über/
s/Departure/Geht unter/
s/Monday/Montag/
s/Tuesday/Dienstag/
s/Wendsday/Mittwoch/
s/Tursday/Donnerstag/
s/Friday/Freitag/
s/Saturday/Samstag/
s/Sunday/Sonntag/
}' > iss-daten.txt 
else echo "Gerade kein sichtbarer Überflug" > iss-daten.txt
fi

#Erzeuge aus Textdatei png-Grafik 400*400 px
#convert -crop 200x200 -draw 'text 20,65 "@/home/karl/bin/iss-daten.txt"' iss-photo1.png iss-daten.png
cat iss-daten.txt | convert iss-photo1.png -fill white -stroke black -pointsize 20 -gravity center -annotate 10 '@-' iss-daten.png

sleep 3
#ftp-upload

HOST='domain.de'
USER='user'
PASSWD='secret'
FILE='iss-daten.png'
REMOTEPATH='/joomla/images/XML2png'

ftp -n -p  $HOST <<END_SCRIPT
quote USER $USER
quote PASS $PASSWD
binary
cd $REMOTEPATH
put $FILE
bye
quit
END_SCRIPT
#exit 0

#twittern
/usr/bin/perl /home/user/bin/ttytter.pl -status="Der nächste sichtbare ISS Überflug in Worms ist am: 
http://www.domain.de/home/xml2png.html"

exit