From: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 0/9] SELinux support for Infiniband RDMA
Date: Fri, 15 Jul 2016 01:56:42 +0300
Message-ID: <1468537011-20407-1-git-send-email-danielj@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The selinux next tree is missing some patches for IB/core.  This series
applies cleanly to ib-next, and should apply cleanly to selinux-next once
the IB patches are merged.

Currently there is no way to provide granular access control to an
Infiniband fabric. By providing an ability to restrict user access to
specific virtual subfabrics, administrators can limit access to bandwidth
and isolate users on the fabric.

The approach for controlling access for Infiniband is to control access to
partitions. A partition is similar in concept to a VLAN where each data
packet carries the partition key (PKey) in its header and isolation is
enforced by the hardware. The partition key is not a cryptographic key,
it's a 16 bit number identifying the partition. By controlling access to
PKeys, users can be isolated on the fabric.

Every Infiniband fabric must have a subnet manager. The subnet manager
provisions the partitions and configures the end nodes. Each end port has
a PKey table containing the partitions it can access. In order to enforce
access to partitions, the subnet management interface (SMI) must also be
controlled to prevent unauthorized changes to the fabric configuration. 

In order to support this there must be a capability to provide security
contexts for two new types of objects - PKeys and IB ports.

A PKey label consists of a subnet prefix and a range of PKey values and is
similar to the labeling mechanism for netports. Each Infiniband port can
reside on a different subnet, labeling the PKey values for specific subnet
prefixes provides the user maximum flexibility. There is a single access
vector for PKeys called "access".

An Infiniband port is labeled by name and port number. There is a single
access vector for IB ports called "manage_subnet".

Because RDMA allows kernel bypass, enforcement must be done during
connection setup. Communication over RDMA requires a send and receive
queue called a  queue pair (QP). During the creation of a QP it is
initialized before it can be used to send or receive data. During
initialization the user must provide the PKey and port the QP will use, at
this time access can be enforced.

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
- Squash MAD agent PKey and SMI patches. Dan Jurgens
- Changed ib_end_port to ib_port. Paul Moore
- Changed ib_port access vector from smp to manage_subnet. Paul Moore
- Added pkey and ib_port details to the audit log. Paul Moore
- See individual patches for more detail.

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

 drivers/infiniband/core/Makefile     |    3 +-
 drivers/infiniband/core/cache.c      |   57 +++-
 drivers/infiniband/core/core_priv.h  |  115 ++++++
 drivers/infiniband/core/device.c     |   79 ++++
 drivers/infiniband/core/mad.c        |   52 +++-
 drivers/infiniband/core/security.c   |  707 ++++++++++++++++++++++++++++++++++
 drivers/infiniband/core/uverbs_cmd.c |   20 +-
 drivers/infiniband/core/verbs.c      |   27 ++-
 include/linux/lsm_audit.h            |   37 ++-
 include/linux/lsm_hooks.h            |   34 ++
 include/linux/security.h             |   37 ++
 include/rdma/ib_mad.h                |    4 +
 include/rdma/ib_verbs.h              |   49 +++
 security/Kconfig                     |    9 +
 security/lsm_audit.c                 |   18 +
 security/security.c                  |   97 +++++
 security/selinux/Makefile            |    2 +-
 security/selinux/hooks.c             |   79 ++++-
 security/selinux/ibpkey.c            |  245 ++++++++++++
 security/selinux/include/classmap.h  |    4 +
 security/selinux/include/ibpkey.h    |   31 ++
 security/selinux/include/objsec.h    |   11 +
 security/selinux/include/security.h  |    7 +-
 security/selinux/selinuxfs.c         |    2 +
 security/selinux/ss/policydb.c       |  130 ++++++-
 security/selinux/ss/policydb.h       |   27 +-
 security/selinux/ss/services.c       |   83 ++++
 27 files changed, 1908 insertions(+), 58 deletions(-)
 create mode 100644 drivers/infiniband/core/security.c
 create mode 100644 security/selinux/ibpkey.c
 create mode 100644 security/selinux/include/ibpkey.h

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
