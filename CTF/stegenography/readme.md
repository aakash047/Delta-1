There are couple of Techiniques you can do stegenography
And i am using kali linux for the stegenography


method 1: using steghide for jpeg

1) exiftool for viewing metadata
sudo apt-get install exiftool

2) steghide installation
sudo apt-get install steghide


make sure that you have downloaded your mystery.jpeg
I am using jpeg why because png format doesn't supported in steghide

exiftool for viewing the metadata of the image
1) exiftool mystery.jpeg

it will use the mystery.jpeg file as a cover file and secret.txt file as embedding file and secret123 is password for extracting data from the file

2) steghide embed -cf mystery.jpeg -ef secret.txt -p secret123

it will extract the data and overwrite the secret.txt file
3) steghide extract -sf mystery.jpeg -p secret123

summary
the metadata of the mystery.jpeg shows the difference of size between before embedding and after embedding using steghide.
0.5kb was added due to the secret.txt file




method 2: using png image


This is method worked because every png file is end with this "\x00\x00\x00\x00\x49\x45\x4e\x44\xae\x42\x60\x82" bytes. so we can use it as an advantage for stegenography.


first run embed_message and run extract_message



