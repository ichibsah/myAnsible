chmod 777 ./* -R
chown ibrahim:ibrahim ./* -R

#

#
git clone https://github.com/ichibsah/chatbot-ui.git
cd chatbot-ui
#https://github.com/ichibsah/chatbot-ui.git
docker build -t chatgpt-ui .
docker run -d --restart=always -e OPENAI_API_KEY={{OPENAI_API_KEY}} -p 3003:3000 chatgpt-ui