
# Infrastructure ที่ใช้คือ Digital Ocean

Container Jenkins Server
Container Nginx สำหรับ deploy ระบบ web application ที่พัฒนาด้วย React
Container NodeJS สำหรับ deploy ระบบ backend ที่พัฒนาด้วย NodeJS
Container MongoDB สำหรับ database ของระบบ
Container Google Chrome สำหรับการทดสอบ UI testing บน Google Chrome

# มาดูการสร้าง Container Jenkins Server จะใช้ image Jenkins LTS
docker container run -d -p 8080:8080 --name ci jenkins/jenkins:lts

- จากนั้นทำการดึงค่า Admin Password มาใช้ในขั้นตอนติดตั้ง
docker container exec -it ci  cat /var/jenkins_home/secrets/initialAdminPassword

จะได้ cc55be77cbcf41a88c92fbb4f41f2509

# ทำการสร้าง Job หรือขั้นตอนการทำงานแบบอัตโนมัติง่าย ๆ ดังนี้
1. Frontend ที่พัฒนาด้วย React
2. Backend ที่พัฒนาด้วย NodeJS
3. ทำการสร้าง MongoDB Database ขึ้นมาใหม่
4. ทำการทดสอบ UI Test ผ่าน Google Chrome ด้วย Robotframework

- ทำตามลำดับดังนี้
1. ทำการสร้าง MongoDB container ขึ้นมา
docker container run -d --name mongo mongo:3.5.13-jessie
(อย่าไปใช้บน production server นะ !!)

2. ทำการสร้าง Backend container สำหรับ NodeJS
- ใน Dockerfile ได้ดังนี้

ROM node:6.11.3-alpine
RUN mkdir -p /home/web
COPY package.json /home/web/
COPY src /home/web/src/
WORKDIR "/home/web"
RUN npm install
RUN npm test
ENTRYPOINT npm run start

คำอธิบาย
ทำการ copy ไฟล์ package.json ซึ่งเป็นไฟล์ config สำหรับ project
ทำการ copy ไฟล์ต่าง ๆ จาก folder src
ทำการ install library ต่าง ๆ ด้วย npm install
ทำการทดสอบด้วย npm test
ทำการ start ระบบงานแบบง่าย ๆ ถ้างานจริงแนะนำให้ใช้ pm2 นะ

- ทำการสร้าง image ใหม่ชื่อว่า backend และ สร้าง container ดังนี้
docker image build -t backend .

- ทำการสร้าง container
docker container run -d backend --link mongo backend

3. ทำการสร้าง Frontend container สำหรับ ReactJS



