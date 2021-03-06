Content-Type: multipart/mixed; boundary="==BOUNDARY=="
MIME-Version: 1.0

--==BOUNDARY==
Content-Type: text/cloud-boothook; charset="us-ascii"

# Install nfs-utils.
# Maybe needed to get ecs.capability.secrets.ssm.environment-variables???
cloud-init-per once yum_update yum update -y
cloud-init-per once install_efs_utils yum install -y amazon-efs-utils

# Create /ebs folder
cloud-init-per once mkdir_ebs mkdir -p ${ebs_host_path}

# Format the EBS volume as ext4.  We only want to do this if the volume
# hasn't already been formatted by another EC2 instance.
#
# See https://serverfault.com/a/975257/206273
echo "blkid --match-token TYPE=ext4 ${ebs_volume_id} || mkfs --type ext4 ${ebs_volume_id}" >> format_ebs_volume.sh

# Add /ebs to fstab
cloud-init-per once mount_ebs echo -e '${ebs_volume_id} ${ebs_host_path} ext4 defaults,nofail 0 2' >> /etc/fstab

# Mount all
mount --all

--==BOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash
# Set any ECS agent configuration options
cat << EOF > /etc/ecs/ecs.config

ECS_CLUSTER=${cluster_name}
ECS_INSTANCE_ATTRIBUTES={"ebs.volume":"${ebs_volume_id}"}

EOF
--==BOUNDARY==--
