function Clear-Docker-Objects
{
    docker image prune -f
    docker container prune -f
}