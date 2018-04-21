#!/bin/bash
#. _DEBUG.sh
#
# One-line description of what this script does
#
#
# Usage:    $0  PARM1  PARM2  --[no]parm3  PARM4  \
#               --parm5[=do_this_once]  --parm6=do_this_often  \
#               [ PARMNm1 ]  PARMN
#
########################################################################

########################################################################
#
# 0        Success
# 1        Fail, MOST Unix utilities
# 2        Shell script syntax error
# 3-9      Typically never used
#
# 9        Fatal error processing include directives or special environ
#            conditions
#
# 10       Usage
# 11-99    Shell include file errors (common to all including scripts)
# 100-124  Script errors (****************)
# 125-127  Reserved for shell
# 128-159  Unix process signals 0-31  (32-63 real-time signals are
#            almost NEVER used, code 160-191)
# 160-199  Script errors (****************)
# 200-254  Remote (ssh-based) script errors
# 255      Reserved for shell (e.g. ssh socket closures)
#
########################################################################
#
# Script setup
#
PGM=`basename $0 .sh`
PGMSH=`basename $0`
PGMDIR=`cd \`dirname $0\`;         pwd`  # No symlink dereference
### PGMDIR=`cd \`dirname $0\`; /bin/csh -c pwd`  # Has symlink dereference
PGMFULL="$PGMDIR/$PGMSH"
PGMDATE=`date +%y%m%d-%H%M%S`
PGMDATE_STRING=`date`

####################################
#
# Set up Usage() function suite
#
Usage()
{
    Usage_short
#NOTREACHED
}

Usage_short()
{
(
    set +x
    echo ""
    echo "Usage:  $PGMSH   AWSKEYID \\"
    echo "                 AWSACCESSKEY \\"
    echo "                 [  --aws-ec2-instance-type=AWS_EC2_INSTANCE_TYPE   ]\\"
    echo "                 [  --aws-security-group=AWS_SECURITY_GROUP  ] \\"
    echo "                 [  --aws-image=AWS_IMAGE_ID   ] \\"
    echo "                 [  --aws-keypair=AWS_KEYPAir   ] \\"
    echo "                 [  --aws-region=AWS_REGION   ] \\"
    echo "                 [  --aws-count=AWS_COUNT   ] \\"

    echo ""

    echo \
"also:   $PGMSH  { -h | -H | --help }    Short/long/long help message"
    echo ""
) 1>&2

    exit 10
}

Usage_long()
{
    set +x
    (Usage_short)
(
    echo ""
    echo "Where:      AWSKEYID                 aws access key id."
    echo "            AWSACCESSKEY             aws access key."
    echo "Options:    --aws-ec2-instance-type  aws ec2 instance type."
    echo "            --aws-security-group     aws security group."
    echo "            --aws-image              aws ami image id."
    echo "            --aws-keypair            aws keypair pem file name."
    echo "            --aws-region             aws region."
    echo "            --aws-count              number of ec2 instances."
    echo ""
    echo "This script boostraps web server on aws."
    echo ""
) 1>&2
    exit 10
}

foundation_posix_duplicate_ignore()
{
   (
    echo ""
    echo "$PGM:  Duplicate specification ignored:  $1"
    echo ""
   ) 1>&2
}

foundation_posix_duplicate_error()
{
   (
    echo ""
    echo "$PGM:  Duplicate specification error:  $1"
    echo ""
   ) 1>&2

    exit 10
}

########################################################################
#
# Parse command line parameters
#

# Minimum number of positional parameters (NOT including Posix parms)
MIN_PARM_COUNT=2

# One optional positional specified here, 'PARMNm1'
MAX_PARM_COUNT=2

####################################
#
# Positional parameters, pass:  Parse Posix options,
# reconstitute $* with positionals only.
#

# Default value for --aws-ec2-instance-type
DASH_DASH_EC2_INSTANCE_TYPE_DEFAULT="t2.micro"
DASH_DASH_EC2_INSTANCE_TYPE_PARSED_ALREADY="false"
DASH_DASH_EC2_INSTANCE_TYPE_VALUE="$DASH_DASH_EC2_INSTANCE_TYPE_DEFAULT"
# Default value for --aws-security-group
DASH_DASH_AWS_SECURITY_GROUP_DEFAULT="demo-server2"
DASH_DASH_AWS_SECURITY_GROUP_PARSED_ALREADY="false"
DASH_DASH_AWS_SECURITY_GROUP_VALUE="$DASH_DASH_AWS_SECURITY_GROUP_DEFAULT"
# Default value for --aws-image
DASH_DASH_AWS_IMAGE_DEFAULT="ami-3959dc5d"
DASH_DASH_AWS_IMAGE_PARSED_ALREADY="false"
DASH_DASH_AWS_IMAGE_VALUE="$DASH_DASH_AWS_IMAGE_DEFAULT"
# Default value for --aws-keypair
DASH_DASH_AWS_KEYPAIR_DEFAULT="demo-webserver"
DASH_DASH_AWS_KEYPAIR_PARSED_ALREADY="false"
DASH_DASH_AWS_KEYPAIR_VALUE="$DASH_DASH_AWS_KEYPAIR_DEFAULT"
# Default value for --aws-region
DASH_DASH_AWS_REGION_DEFAULT="ca-central-1"
DASH_DASH_AWS_REGION_PARSED_ALREADY="false"
DASH_DASH_AWS_REGION_VALUE="$DASH_DASH_AWS_REGION_DEFAULT"
# Parsing info for --aws-count
DASH_DASH_AWS_COUNT_DEFAULT=1
DASH_DASH_AWS_COUNT_PARSED_ALREADY="false"
DASH_DASH_AWS_COUNT_VALUE="$DASH_DASH_AWS_COUNT_DEFAULT"


# Separate POSIX parameters and process them.  Create new list of
# positional parameters in NEW_PARMS.
NEW_POSITIONAL_PARMS=""
for parm in $*
do
    case "$parm" in  # ((((((((
        # Parm 3 is a boolean, can only parse once
        --aws-ec2-instance-type= | --aws-ec2-instance-type=* )
            # Can only supply once
            if test "false" == "$DASH_DASH_EC2_INSTANCE_TYPE_PARSED_ALREADY"
            then
                DASH_DASH_EC2_INSTANCE_TYPE_PARSED_ALREADY="true"
				DASH_DASH_EC2_INSTANCE_TYPE_VALUE = "${parm:24}"
            else
                Posix_duplicate_error  "$parm"
            fi
            ;;

         --aws-security-group= | --aws-security-group=* )
            # Can only supply once
            if test "false" == "$DASH_DASH_AWS_SECURITY_GROUP_PARSED_ALREADY"
            then
                DASH_DASH_AWS_SECURITY_GROUP_PARSED_ALREADY="true"
				DASH_DASH_AWS_SECURITY_GROUP_VALUE = "${parm:21}"
            else
                Posix_duplicate_error  "$parm"
            fi
            ;;
          --aws-image= | --aws-image=* )
            # Can only supply once
            if test "false" == "$DASH_DASH_AWS_IMAGE_PARSED_ALREADY"
            then
                DASH_DASH_AWS_IMAGE_PARSED_ALREADY="true"
				DASH_DASH_AWS_IMAGE_VALUE = "${parm:12}"
            else
                Posix_duplicate_error  "$parm"
            fi
            ;;

          --aws-keypair= | --aws-keypair=* )
            # Can only supply once
            if test "false" == "$DASH_DASH_AWS_KEYPAIR_PARSED_ALREADY"
            then
                DASH_DASH_AWS_KEYPAIR_PARSED_ALREADY="true"
				DASH_DASH_AWS_KEYPAIR_VALUE = "${parm:14}"
            else
                Posix_duplicate_error  "$parm"
            fi
            ;;

          --aws-region= | --aws-region=* )
            # Can only supply once
            if test "false" == "$DASH_DASH_AWS_REGION_PARSED_ALREADY"
            then
                DASH_DASH_AWS_REGION_PARSED_ALREADY="true"
				DASH_DASH_AWS_REGION_PARSED_VALUE = "${parm:13}"
            else
                Posix_duplicate_error  "$parm"
            fi
            ;;
        --aws-count= | --aws-count=* )
            # Can only supply once
            if test "false" == "$DASH_DASH_AWS_COUNT_PARSED_ALREADY"
            then
                DASH_DASH_AWS_COUNT_PARSED_ALREADY="true"
				DASH_DASH_AWS_COUNT_VALUE = "${parm:12}"
            else
                Posix_duplicate_error  "$parm"
            fi
            ;;
        -h )
            Usage_short;;
#NOTREACHED

        -H | --help )
            Usage_long;;
#NOTREACHED

        # Everything else gets passed through to pass 3
        *)  NEW_PARMS="$NEW_PARMS $parm"
            ;;
    esac
done

# Capture all positional parameters as if they were on
# the command line without any Posix parameters.
set -- $NEW_PARMS
NEW_PARM_COUNT=$#


####################################
#
# Parse command line parameters, pass 2:  Preprocess any pass 1 data
# in preparation for pass 3
#

####################################
#
# Parse command line parameters, pass 3:  Process positional parameters
#

# Die if minimum number of positional parameters are not suppied
if test $NEW_PARM_COUNT -lt $MIN_PARM_COUNT; then Usage_short; fi

# Die if maximum number of positional parameters exceeded
if test $NEW_PARM_COUNT -gt $MAX_PARM_COUNT; then Usage_short; fi

# Extract positional parameters, process optional vs. required parms
ACCESSKEYID="$1"
ACCESSKEY="$2"


####################################
#
# Parse command line parameters, pass 4:  Postprocess any pass 3 data
#

########################################################################
#
# Script logic
#
if /bin/true
then
    ####################################
    #
    # Subsection 0.1
    #
    : # Fill with ':' null command to reserve the space
fi

####################################
#
# Prepare AWS Varables
#

export AWS_ACCESS_KEY_ID=$ACCESSKEYID
export AWS_SECRET_ACCESS_KEY=$ACCESSKEY
export ANSIBLE_HOST_KEY_CHECKING=false
cp hosts.template hosts
####################################
#
# Create Ansible playbook yaml file from template
#

PLAYBOOKFILENAME='simpleWebServer.yml'

REPLACEINSTANCETYPE="s/EC2_INSTANCE_TYPE/$DASH_DASH_EC2_INSTANCE_TYPE_VALUE/g;"
REPLACESECURITYGROUPD="s/DEMO_SERVER_SECURITY_GROUP/$DASH_DASH_AWS_SECURITY_GROUP_VALUE/g;"
REPLACEIMAGEID="s/AWS_IMAGE_ID/$DASH_DASH_AWS_IMAGE_VALUE/g;"
REPLACEKEYPAIR="s/AWS_KEYPAIR_NAME/$DASH_DASH_AWS_KEYPAIR_VALUE/g;"
REPLACEREGION="s/AWS_REGION_NAME/$DASH_DASH_AWS_REGION_VALUE/g;"
REPLACECOUNT="s/EC2_INSTANCE_COUNT/$DASH_DASH_AWS_COUNT_VALUE/g"
DEPLOYFILE=`cat ec2-webserver-template.yml | sed $REPLACEINSTANCETYPE$REPLACESECURITYGROUPD$REPLACEIMAGEID$REPLACEKEYPAIR$REPLACEREGION$REPLACECOUNT`
echo "$DEPLOYFILE" > $PLAYBOOKFILENAME

##################
#
# Ansible create aws instance
#

ansible-playbook -i ./hosts $PLAYBOOKFILENAME

##################
# TODO setup listner to check the status of the vm to make sure
#      the vm has fully booted before next task.
# Ansible install apache and deploy index.html to www root folder
#
sleep 180
eval `ssh-agent`
ssh-add ~/.ssh/$DASH_DASH_AWS_KEYPAIR_VALUE.pem

ansible-playbook -i ./hosts site.yml


##################
#
# Test the zone
#

IPADDRESS=`cat hosts | sed -e '1,/webserver/d' | head -n 1`

wget $IPADDRESS

cmp --silent index.html roles/webserver/templates/index.html.j2 && echo '### SUCCESS: Files Are Successfully deployed to web server! ###' || echo '### WARNING: Files Are Different! ###'

####################################
#
# Subsection 3
#

########################################################################
#
# EOF
