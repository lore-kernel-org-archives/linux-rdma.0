From: Dan Jurgens <danielj@mellanox.com>
Subject: [RFC PATCH v3 00/12] SELinux support for Infiniband RDMA
Date: Tue, 19 Apr 2016 22:51:17 +0300
Message-ID: <1461095489-18732-1-git-send-email-danielj@mellanox.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: yevgenyp@mellanox.com, Daniel Jurgens <danielj@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj@mellanox.com>

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
similar to the labeling mechanism for netports.  Infiniband end port can
reside on a different subnet, labeling the PKey values for specific subnet
prefixes provides the user maximum flexibility. There is a single access
vector for PKeys, called "access".

An Infiniband end port (ib_end_port) is labeled by name and port number. There
is a single access vector for ib_end_ports as well, called "smp".

Because RDMA allows for kernel bypass all enforcement must be done during
connection setup.  To communicate over RDMA requires a send and receive queue
called a queue pair (QP).  During the creation of a QP it is initialized
before it can be used to send or receive data.  During initialization the user
must provide the PKey and port the QP will use, at this time access can be
enforced.

Because there is a possibility that the enforcement settings or security
policy can change, a means of notifying the ib_core module of such changes is
required.  To facilitate this two LSM hooks are provided, ib_core will
register and unregister a callback function at init and cleanup respectively.
SELinux will call the callback as appropriate if it has been registered.
When the callback is called ib_core will recheck the PKey access for all
existing QPs.

Because frequent accesses to the same PKey's SID is expected a cache is
implemented which is very similar to the netport cache.

In order to properly enforce security when changes to the PKey table or
security policy or enforcement occur ib_core must track which QPs are using
each port, pkey index, and alternate path for every IB device.  This makes
operations that used to be atomic transactional.

When modifying a QP ib_core must associate it with the PKey index, port,
and alternate path specified.  If the QP was already associated with different
settings the QP is added to the new list prior to the modify attempt.  If
the modify succeeds then the old listing is removed.  If the modify fails
the new listing is removed and the old listing remains unchanged.

When destroying a QP the ib_qp structure is freed by the hardware driver
if the destroy is successful.  This requires storing security related
information in a separate structure. When a destroy request is in process
the ib_qp structure is in an undefined state so if there are changes to the
security policy or PKey table the security checks cannot reset the QP if it
doesn't have permission for the new setting.  If the destroy fails security
for that QP must be enforced again, and its status in the list restored. 
 If the destroy succeeds the security info can be cleaned up and freed.

There are a number of locks required to protect the QP security structure and
the QP to device/port/pkey index lists.  If multiple locks are required the
safe locking order is qp security structure mutex first, followed by any list
locks needed, which are sorted first by port followed by pkey index.

---
v2:
1. Added IB core patches. James

2. Changed all hooks to take structure pointers instead of opaque security blobs
for easier security module stacking.  This required adding more specific
hooks. Casey

3. Added 2 new hooks to register and deregister a callback and removed the
infiniband_flush hook that ib_core was registering to avoid having to delete
hooks. Casey

4. Removed my email address in copyright headers. Or

v3:
1. Changed ibdev and smi names to ib_end_port and smp respectively. Jason

2. Squashed QP modify and cache change enforcement into 1 patch.

3. Refactored QP PKey code and added comments to claify locking. Leon

See individual patches for more detailed version history.

Daniel Jurgens (12):
  security: Add LSM hooks for Infiniband security
  selinux: Create policydb version for Infiniband support
  selinux: Implement Infiniband flush callback
  selinux: Allocate and free infiniband security hooks
  selinux: Implement Infiniband PKey "Access" access vector
  selinux: Add IB End Port SMP access vector
  selinux: Add a cache for quicker retreival of PKey SIDs
  ib/core: IB cache enhancements to support Infiniband security
  ib/core: Enforce PKey security on QPs
  ib/core: Enforce PKey security on management datagrams
  ib/core: Enforce Infiniband device SMI security
  ib/core: Implement the Infiniband flush callback.

 drivers/infiniband/core/Makefile                 |    2 +-
 drivers/infiniband/core/cache.c                  |   56 ++-
 drivers/infiniband/core/core_priv.h              |   93 ++++
 drivers/infiniband/core/device.c                 |   59 ++
 drivers/infiniband/core/mad.c                    |  105 ++++-
 drivers/infiniband/core/security.c               |  641 ++++++++++++++++++++++
 drivers/infiniband/core/uverbs_cmd.c             |   20 +-
 drivers/infiniband/core/verbs.c                  |   30 +-
 include/linux/lsm_audit.h                        |   37 +-
 include/linux/lsm_hooks.h                        |   71 +++
 include/linux/security.h                         |   63 +++
 include/rdma/ib_mad.h                            |    1 +
 include/rdma/ib_verbs.h                          |   49 ++
 security/Kconfig                                 |    9 +
 security/security.c                              |   83 +++
 security/selinux/Makefile                        |    2 +-
 security/selinux/hooks.c                         |  160 ++++++-
 security/selinux/include/classmap.h              |    4 +
 security/selinux/include/initial_sid_to_string.h |    2 +
 security/selinux/include/objsec.h                |   11 +
 security/selinux/include/pkey.h                  |   31 +
 security/selinux/include/security.h              |    7 +-
 security/selinux/pkey.c                          |  243 ++++++++
 security/selinux/ss/policydb.c                   |  129 ++++-
 security/selinux/ss/policydb.h                   |   27 +-
 security/selinux/ss/services.c                   |   84 +++
 26 files changed, 1963 insertions(+), 56 deletions(-)
 create mode 100644 drivers/infiniband/core/security.c
 create mode 100644 security/selinux/include/pkey.h
 create mode 100644 security/selinux/pkey.c

