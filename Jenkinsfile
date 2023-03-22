---
- name: Build and deploy Java application
  hosts: jenkins_agent
  become: yes
  gather_facts: no
  tasks:
    - name: Install required packages
      apt:
        pkg:
          - openjdk-11-jdk
          - maven
          - docker.io

    - name: Clone the Java application repository
      git:
        repo: 'https://github.com/vir2ozz/certask.git'
        dest: '/opt/certask'

    - name: Build the Java application
      command: mvn clean package
      args:
        chdir: /opt/certask

    - name: Copy the WAR file to the staging directory
      copy:
        src: '/opt/certask/target/hello-1.0.war'
        dest: '/opt/staging/hello-1.0.war'

    - name: Copy Dockerfile to staging directory
      copy:
        src: 'Dockerfile'
        dest: '/opt/staging/Dockerfile'

    - name: Build Docker image
      command: docker build -t hello:1.0 /opt/staging/

    - name: Run Docker container
      command: docker run -d -p 8080:8080 hello:1.0
