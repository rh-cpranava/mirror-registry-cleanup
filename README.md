# Cleanup Mirror Registry
- Copy the script to your home directory and give it execute privileges
- Enter the image registry to be deleted in image variable in the script
- Run the script specifying the user and password
- Log into the mirror registry using the following command:
```
# podman exec -it mirror-registry sh
```
- Run the garbage collection script in dry-run mode to identify the blobs being deleted
```
# bin/registry garbage-collect --dry-run /etc/docker/registry/config.yml
```
- If the satisfied with the images which are going to be deleted, run the garbage collection script without the dry-run flag 
```
# bin/registry garbage-collect --dry-run /etc/docker/registry/config.yml
```

# Monitor Mirror Registry disk usage
- Ensure you have Python3 installed
```
# yum install -y python3
```
- Create a python3 virtual environment on your root home directory
```
# cd /root
# mkdir registry-du
# python3 -m venv env
```
- Download the registry-du.tgz file located in your repo to your /root/registry-du folder
- Untar the registry-du-pip.tgz in root directory
```
# cd /root/registry-du
# tar xvzf registry-du-pip.tgz
```
- Log into the uncompressed directory and install the pip package along with the dependencies in the virtual environment
```
# source /root/registry-du/env/bin/activate
# cd registry-du-pip/
# pip install registry-du --no-index --find-links .
```
- Run the following command to find out disk size
```
registry-du /repo/registry/data/docker/registry/v2
```
