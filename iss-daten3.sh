#! /bin/bash
#XML Datei aus dem Internet holen
#cd /home/karl/bin
cd $HOME/git/XML-2-png
# curl -o iss-data.xml "https://spotthestation.nasa.gov/sightings/indexrss.cfm?country=Germany&region=None&city=Ludwigshafen" 
wget https://spotthestation.nasa.gov/sightings/xml_files/Germany_None_Ludwigshafen.xml -O $HOME/git/XML-2-png/iss-data.xml
#warte 1 Sekunde
sleep 2
# Gibt es in XML <descrition> , gibt ers auch einen Überflug
#Hole die Zeile , die mit date begint, und die nächsten 5 Zeilen (1mal)
#HTML- Klammern entfernen
#Grad-Symbol einfügen
#TABs am Zeilenanfang enfernen
#Übersetzen deutsch
#Speichern als Text
if grep -q  \<description\>  iss-data.xml
then grep  -m3 -A8 `date +"20%y-%m-%d"` iss-data.xml | grep ISS  -A8 |sed '/\<title\>/d'|sed '/\<pubDate\>/d'|sed $"/\description\>/d"| sed  -e 's/^[ \t]*//'| sed '{


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
s/Wednesday/Mittwoch/
s/Thursday/Donnerstag/
s/Friday/Freitag/
s/Saturday/Samstag/
s/Sunday/Sonntag/
}' > iss-daten.txt
else echo "Gerade kein sichtbarer Überflug" > iss-daten.txt
fi

#cat iss-daten.txt
#cat iss-daten.txt | convert iss-photo1.png -fill white -stroke black -pointsize 20 -gravity center -annotate 10 label:@- iss-daten.png
issd=$(cat iss-daten.txt)
#convert iss-photo1.png -fill white -stroke black -pointsize 20 -gravity center -annotate 10 -draw "text 32, 16 \"$issd\"" iss-daten.png
#convert iss-photo1.png -fill black -pointsize 20 -gravity center -draw "text 0,0\"$issd\"" iss-daten.png
magick iss-photo1.png -fill '#00688B' -weight Bold -pointsize 20 -gravity center -annotate 9 "$issd" iss-daten.png




