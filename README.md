# devops-project

This is a Ansible powered aws vm bootstrap script to deploy web page into Apache web server.

## Getting Started

Script ./bootstrap_aws.sh is the entry point of this Ansible depolyment script.

### Prerequisites

Few things needed to be able to run this script,
0) Create your AWS account and get a year free trial account
a) Python 2.7 and pip
c) Ansible 2.5.1
d) Download your .pem key from your amazone aws account and name it to demo-webserver.pem, put it under .ssh folder
e) Get your AWS access key id and access key
f) Run ./boostrap_aws.sh to learn what parameters needed to be able to successfully run through

```
Examples
```
./bootstrap_aws.sh YOUR_AMAZON_KEY_ID YOUR_AMAZON_KEY

### Installing

Just check out this code repo and chmod the .sh files to be executables

## Running the tests

End of the script will compare the deployed index.html to the local copy to do a quick end user test. 


## Authors

* **Peidong Hu** - *Initial work* - [peidong-hu](https://github.com/peidong-hu)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Hat tip to anyone who's code was used
* Inspiration
* etc
