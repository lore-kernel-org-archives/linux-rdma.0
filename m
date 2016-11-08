From: Dan Jurgens <danielj@mellanox.com>
Subject: [PATCH v4 0/9] SELinux support for Infiniband RDMA
Date: Tue,  8 Nov 2016 23:06:16 +0200
Message-ID: <1478639185-47521-1-git-send-email-danielj@mellanox.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: chrisw@sous-sol.org, paul@paul-moore.com, sds@tycho.nsa.gov, eparis@parisplace.org, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org, linux-rdma@vger.kernel.org, yevgenyp@mellanox.com, liranl@mellanox.com, leonro@mellanox.com, Daniel Jurgens <danielj@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj@mellanox.com>

Infiniband applications access HW from user-space -- traffic is generated
directly by HW, bypassing the kernel. Consequently, Infiniband Partitions,
which are associated directly with HW transport endpoints, are a natural
choice for enforcing granular mandatory access control for Infiniband. QPs may
only send or receives packets tagged with the corresponding partition key
(PKey). The PKey is not a cryptographic key; it's a 16 bit number identifying
the partition.

Every Infiniband fabric is controlled by a central Subnet Manager (SM). The SM
provisions the partitions by assigning each port with the partitions it can
access. In addition, the SM tags each port with a subnet prefix, which
identifies the subnet. Determining which users are allowed to access which
partition keys on a given subnet forms an effective policy for isolating users
on the fabric. Any application that attempts to send traffic on a given subnet
is automatically subject to the policy, regardless of which device and port it
uses. SM software configures the subnet through a privileged Subnet Management
Interface (SMI), which is presented by each Infiniband port. Thus, the SMI must
also be controlled to prevent unauthorized changes to fabric configuration and
partitioning. 

To support access control for IB partitions and subnet management, security
contexts must be provided for two new types of objects - PKeys and IB ports.

A PKey label consists of a subnet prefix and a range of PKey values and is
similar to the labeling mechanism for netports. Each Infiniband port can reside
on a different subnet. So labeling the PKey values for specific subnet prefixes
provides the user maximum flexibility, as PKey values may be determined
independently for different subnets. There is a single access vector for PKeys
called "access".

An Infiniband port is labeled by device name and port number. There is a single
access vector for IB ports called "manage_subnet".

Because RDMA allows kernel bypass, enforcement must be done during connection
setup. Communication over RDMA requires a send and receive queue, collectively
known as a Queue Pair (QP). A QP must be initialized by privileged system calls
before it can be used to send or receive data. During initialization the user
must provide the PKey and port the QP will use; at this time access control can
be enforced.

Because there is a possibility that the enforcement settings or security
policy can change, a means of notifying the ib_core module of such changes
is required. To facilitate this a generic notification callback mechanism
is added to the LSM. One callback is registered for checking the QP PKey
associations when the policy changes. Mad agents also register a callback,
they cache the permission to send and receive SMPs to avoid another per
packet call to the LSM.

Because frequent accesses to the same PKey's SID is expected a cache is
implemented which is very similar to the netport cache.

In order to properly enforce security when changes to the PKey table or
security policy or enforcement occur ib_core must track which QPs are
using which port, pkey index, and alternate path for every IB device.
This makes operations that used to be atomic transactional.

When modifying a QP, ib_core must associate it with the PKey index, port,
and alternate path specified. If the QP was already associated with
different settings, the QP is added to the new list prior to the
modification. If the modify succeeds then the old listing is removed. If
the modify fails the new listing is removed and the old listing remains
unchanged.

When destroying a QP the ib_qp structure is freed by the decive specific
driver (i.e. mlx4_ib) if the 'destroy' is successful. This requires storing
security related information in a separate structure. When a 'destroy'
request is in process the ib_qp structure is in an undefined state so if
there are changes to the security policy or PKey table, the security checks
cannot reset the QP if it doesn't have permission for the new setting. If
the 'destroy' fails, security for that QP must be enforced again and its
status in the list is restored. If the 'destroy' succeeds the security info
can be cleaned up and freed.

There are a number of locks required to protect the QP security structure
and the QP to device/port/pkey index lists. If multiple locks are required,
the safe locking order is: QP security structure mutex first, followed by
any list locks needed, which are sorted first by port followed by pkey
index.

---
v2:
- Use void* blobs in the LSM hooks. Paul Moore
- Make the policy change callback generic. Yuval Shaia, Paul Moore
- Squash LSM changes into the patches where the calls are added. Paul Moore
- Don't add new initial SIDs. Stephen Smalley
- Squash MAD agent PKey and SMI patches and move logic to IB security. Dan Jurgens
- Changed ib_end_port to ib_port. Paul Moore
- Changed ib_port access vector from smp to manage_subnet. Paul Moore
- Added pkey and ib_port details to the audit log. Paul Moore
- See individual patches for more detail.

v3:
- ib_port -> ib_endport. Paul Moore
- use notifier chains for LSM notifications. Paul Moore
- reorder parameters in hooks to put security blob first. Paul Moore
- Don't treat device name as untrusted string in audit log. Paul Moore

v4:
- Added seperate AVC callback for LSM notifier. Paul Moore
- Removed unneeded braces in ocontext_read. Paul Moore

Daniel Jurgens (9):
  IB/core: IB cache enhancements to support Infiniband security
  IB/core: Enforce PKey security on QPs
  selinux lsm IB/core: Implement LSM notification system
  IB/core: Enforce security on management datagrams
  selinux: Create policydb version for Infiniband support
  selinux: Allocate and free infiniband security hooks
  selinux: Implement Infiniband PKey "Access" access vector
  selinux: Add IB Port SMP access vector
  selinux: Add a cache for quicker retreival of PKey SIDs

 drivers/infiniband/core/Makefile     |   3 +-
 drivers/infiniband/core/cache.c      |  57 ++-
 drivers/infiniband/core/core_priv.h  | 115 ++++++
 drivers/infiniband/core/device.c     |  86 +++++
 drivers/infiniband/core/mad.c        |  52 ++-
 drivers/infiniband/core/security.c   | 709 +++++++++++++++++++++++++++++++++++
 drivers/infiniband/core/uverbs_cmd.c |  20 +-
 drivers/infiniband/core/verbs.c      |  27 +-
 include/linux/lsm_audit.h            |  15 +
 include/linux/lsm_hooks.h            |  35 ++
 include/linux/security.h             |  35 ++
 include/rdma/ib_mad.h                |   4 +
 include/rdma/ib_verbs.h              |  49 +++
 security/Kconfig                     |   9 +
 security/lsm_audit.c                 |  18 +
 security/security.c                  |  59 +++
 security/selinux/Makefile            |   2 +-
 security/selinux/hooks.c             |  86 ++++-
 security/selinux/ibpkey.c            | 245 ++++++++++++
 security/selinux/include/classmap.h  |   4 +
 security/selinux/include/ibpkey.h    |  31 ++
 security/selinux/include/objsec.h    |  11 +
 security/selinux/include/security.h  |   7 +-
 security/selinux/selinuxfs.c         |   2 +
 security/selinux/ss/policydb.c       | 129 ++++++-
 security/selinux/ss/policydb.h       |  27 +-
 security/selinux/ss/services.c       |  83 ++++
 27 files changed, 1875 insertions(+), 45 deletions(-)
 create mode 100644 drivers/infiniband/core/security.c
 create mode 100644 security/selinux/ibpkey.c
 create mode 100644 security/selinux/include/ibpkey.h

-- 
1.8.3.1

