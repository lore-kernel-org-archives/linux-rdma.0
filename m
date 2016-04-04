From: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH 0/7] SELinux support for Infiniband RDMA
Date: Tue,  5 Apr 2016 00:48:17 +0300
Message-ID: <1459806504-16135-1-git-send-email-danielj@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Currently there is no way to provide granular access control to an Infiniband
fabric.  By providing an ability to restrict user access to specific virtual
subfabrics administrators can limit access to bandwidth and isolate users on
the fabric.

The approach for controlling access for Infiniband is to control access to
partitions.  A partition is similar in concept to a VLAN where each data packet
carries the partition key (PKey) in its header and isolation is enforced by
the hardware.  The partition key is not a cryptographic key, it's a 16 bit
number identifying the partition.  By controlling access to PKeys users can be
isolated on the fabric.

All Infiniband fabrics must have a subnet manager.  The subnet manager
provisions the partitions and configures the end nodes.  Each end port has a
PKey table containing all the partitions it can access.  In order to enforce
access to partitions the subnet management interface (SMI) must also be
controlled to prevent unauthorized changes to the fabric configuration. 

In order to support this there must be a capability to provide security
contexts for two new types of objects - PKeys and SMIs.

A PKey label consists of a subnet prefix and a range of PKey values and is
similar to the labeling mechanism for netports.  Each port of an infiniband
device can reside on a different subnet, labeling the PKey values for specific
subnet prefixes provides the user maximum flexibility. There is a single access
vector for PKeys, called "access".

An Infiniband device (ibdev) is labeled by name and port number.  There is a
single access vector for ibdevs as well, called "smi".

Because RDMA allows for kernel bypass all enforcement must be done during
connection setup.  To communicate over RDMA requires a send and receive queue
called a queue pair (QP).  During the creation of a QP it is initialized
before it can be used to send or receive data.  During initialization the user
must provide the PKey and port the QP will use, at this time access can be
enforced.

Because there is a possibility that the enforcement settings or security
policy can change, a means of notifying the ib_core module of such changes is
required.  To facilitate this a single LSM hook is provided, ib_core will
register for this hook and when called will recheck the PKey access for all
existing QPs.

Because frequent accesses to the same PKey's SID is expected a cache is
implemented which is very similar to the netport cache.

Daniel Jurgens (7):
  security: Add LSM hooks for Infiniband security
  selinux: Create policydb version for Infiniband support
  selinux: Call infiniband_flush LSM hook on AVC reset
  selinux: Allocate and free infiniband security hooks
  selinux: Implement Infiniband PKey "Access" access vector
  selinux: Implement IB Device SMI access vector
  selinux: Add a cache for quicker retreival of PKey SIDs

 include/linux/lsm_audit.h                        |   15 ++
 include/linux/lsm_hooks.h                        |   43 ++++-
 include/linux/security.h                         |   37 ++++
 security/Kconfig                                 |    9 +
 security/security.c                              |   52 +++++
 security/selinux/Makefile                        |    2 +-
 security/selinux/hooks.c                         |   87 +++++++++-
 security/selinux/include/classmap.h              |    4 +
 security/selinux/include/initial_sid_to_string.h |    2 +
 security/selinux/include/objsec.h                |   12 ++
 security/selinux/include/pkey.h                  |   33 ++++
 security/selinux/include/security.h              |    7 +-
 security/selinux/pkey.c                          |  220 ++++++++++++++++++++++
 security/selinux/ss/policydb.c                   |  129 +++++++++++--
 security/selinux/ss/policydb.h                   |   13 ++-
 security/selinux/ss/services.c                   |   84 ++++++++
 16 files changed, 723 insertions(+), 26 deletions(-)
 create mode 100644 security/selinux/include/pkey.h
 create mode 100644 security/selinux/pkey.c

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
