# :video_game: EC2 CloudFormation Gaming Template :cloud:

- [:video\_game: EC2 CloudFormation Gaming Template :cloud:](#video_game-ec2-cloudformation-gaming-template-cloud)
  - [:wrench: How to set it up](#wrench-how-to-set-it-up)
    - [Prerequisite](#prerequisite)
    - [Deploy](#deploy)
    - [Configure](#configure)
    - [Play :video\_game:](#play-video_game)


This is a simple CloudFormation template that provision a g4ad.xlarge instance using the [g4ad graphics-intensive instances](https://aws.amazon.com/marketplace/pp/prodview-fzxvqp2r3vvgc) AMI.

## :wrench: How to set it up 

Be sure that your AWS account got enough quotas to use `G4` appliances. Follow the [AWS documentation](https://docs.aws.amazon.com/general/latest/gr/aws_service_limits.html) to check that up. The `g4ad.xlarge` instance require a minimum of 4 quotas to function.

### Prerequisite

- `awscli` installed and configured
- enough quotas to spin up the `G4` instance

```bash
# Create the KeyPair used to log in into the instance
mkdir ~/.ssh/aws-private-keys && cd ~/.ssh/aws-private-keys
aws ec2 create-key-pair \ 
  --key-name CloudGamingKeyPair \ 
  --query 'KeyMaterial' \ 
  --output text > CloudGamingKeyPair.pem

# Clone the repo
git clone https://github.com/fabienchevalier/ec2-cloudgaming && cd cloudformation
```
### Deploy

Edit `deploy-cloud-gaming-ec2.cfn.yaml` : 

```yaml
- IpProtocol: tcp
          FromPort: 8443 #NICE DVC Server
          ToPort: 8443
          CidrIp: 0.0.0.0/0 #<= Add your own IP address
```

Easy tip to find out your own IP address : `curl ifconfig.me`

Deploy :

```bash
aws cloudformation deploy \
  --template deploy-cloud-gaming-ec2.cfn.yaml \
  --stack-name CloudGamingStack
```

### Configure

Retrieve the instance ID of the instance :

```bash
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=CloudGamingInstance" \
  --query 'Reservations[].Instances[].[InstanceId]' \
  --output text
```

Then :

```bash
aws ec2 get-password-data --instance-id  i-1234567890abcdef0 \
  --priv-launch-key ~/.ssh/aws-private-keys/CloudGamingKeyPair.pem
```

That should give you the Administrator password on a JSON format : 

```json
{
    "InstanceId": "i-1234567890abcdef0",
    "Timestamp": "2013-08-30T23:18:05.000Z",
    "PasswordData": "&ViJ652e*u"
}
```

### Play :video_game:

Download the [latest Nice DCV Client](https://download.nice-dcv.com/) for your OS.

Connect via the public ip-address of your instance using `Administrator` as a login. Password would be the one that you retrieved in the JSON from awscli.

Enjoy

**Watch out**: Don't forget to shut down your instance after your session to avoid any useless costs.