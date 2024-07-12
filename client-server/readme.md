installing python3 and mysql (followed the documentation)


sudo apt install python3-venv


python3 -m venv myenv


source myenv/bin/activate (for mac and linux)


pip install mysql-connector-python


then run the server.py and client.py in seperate terminal


1st start the server then start client


updated after Dockerizing


docker-compose up --build -d


then run the client.py in new terminal
