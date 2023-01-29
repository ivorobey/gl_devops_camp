Docker

```
Task 1
1. Install docker
2. Prepare a dockerfile based on Apache or Nginx image
3. Added your own index.html page with your name and surname to the docker image
4. Run the docker container at port 8080
5. Open page in Web Browser
6. Report save in GitHub repository
```
```
Task 2
1. Prepare private and public network
2. Prepare one dockerfile based on ubuntu with the ping command
3. One container must have access to the private and public networks the second container
must be in the private network
4. A ) Run a container that has access to the public network and ping some resources (
example: google.com )
B ) The second container ping the first container via a private network
5. Report save in GitHub repository
```

### Task1
docker build -t task1 .
docker run  -d -p 8080:80 task1
![image](https://user-images.githubusercontent.com/42977616/215338200-c619a964-67ad-48c5-8c49-df019f529639.png)


### Task2
docker-compose up -d
![image](https://user-images.githubusercontent.com/42977616/215339353-20710f6c-9bdd-47d4-9f21-72f6c34a4e44.png)
