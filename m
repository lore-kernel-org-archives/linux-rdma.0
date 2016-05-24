From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC ABI 0/8] Netlink-based IOCTLs RDMA ABI
Date: Tue, 24 May 2016 17:35:18 +0300
Message-ID: <1464100526-31730-1-git-send-email-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The following patch set comes to enrich security model as a follow up
to commit e6bd18f57aad ('IB/security: Restrict use of the write() interface').

This patch series add ioctl() interface to the existing write() interface and
provide an easy route to backport this change to legacy supported systems.

The proposed code was initially tested with ibv_devinfo application
and supplementary part of libibverbs, which will be posted next.

In a response to the ABI discussion [1] and the summary posted [2], two ioctl()
calls were introduced: IB_IOCTL_VERBS and IB_IOCTL_DIRECT.

* IB_IOCTL_VERBS command will perform all validation and parsing
  supplied by IB CORE logic, before serving the request.
* IB_IOCTL_DIRECT command will bypass IB core logic and it
  is intended for vendor specific channel operations.

Such separation will simplify the user space development by working with
limited and constant number of ioctl numbers without limiting the
ability to expand the vendor's interface in the future.

In order to fully utilize such opportunity to extend ABI while converting
write() to ioctl() interfaces, the community decision was to introduce
netlink-based ABI for ioctl() data [3].

IB_IOCTL_VERBS commands start with generic header:

struct ib_uverbs_ioctl_hdr {
	__u32 length;
	__u16 flags;
	__u16 object_type;
	__u16 reserved;
	/* First 8 actions are common to all objects */
	__u16 action;
	__u32 user_handler;
	/*
	 * These fields represent core response only,
	 * provider's response is given as a netlink attribute.
	 */
	struct ib_uverbs_uptr resp;
};

struct ib_uverbs_uptr {
	__u64 ptr;
	__u32 len;
};

After the header, a stream of netlink attributes (TLVs) are given. These
attributes represent the command itself.

Every command validates its attributes using a generic way by ensure:
1. Attributes are known
2. Attributes' sizes are correct
3. Mandatory attributes exist

The actual uverbs implementation get an array of pointers to
netlink attributes represents the core command, a udata attribute
which the response will be written to (the response starts with a
header identical to netlink nested attribute header) and a udata
represents the vendor data.

Commands and responses are now extensible by nature, as new netlink
attributes could be added when required.

Vendor commands and responses which have udata will use pointers to a
different buffer (using a new netlink uptr attribute). Such separation
will allow to retain backward compatibility with current user-space vendor
drivers.

Thanks,
	Matan, Haggai and Leon.

[1] http://www.spinics.net/lists/linux-rdma/msg36295.html
[2] http://marc.info/?l=linux-rdma&m=146403269100691&w=2
[3] http://lists.openfabrics.org/pipermail/ofvwg/attachments/20160517/0ddbded9/attachment-0002.pdf

Leon Romanovsky (2):
  IB/core: Export RDMA IOCTL declarations
  IB/core: Add DIRECT ioctl call to vendor

Matan Barak (6):
  lib/nlattr: Add parsing netlink and validate using callback
  IB/core: Adding netlink based udata
  IB/core: Add new ioctl for VERBS commands with netlink style parsing
  IB/core: Add outptr to udata in order to track the output size
  IB/core: Refactor idr to a shared file
  IB/core: Implement device_create with the new ABI

 drivers/infiniband/core/Makefile            |   3 +-
 drivers/infiniband/core/user_mad.c          |   2 +-
 drivers/infiniband/core/uverbs.h            |  64 +++-
 drivers/infiniband/core/uverbs_cmd.c        | 558 ++++++++--------------------
 drivers/infiniband/core/uverbs_cmd_common.c | 280 ++++++++++++++
 drivers/infiniband/core/uverbs_cmd_nl.c     | 151 ++++++++
 drivers/infiniband/core/uverbs_main.c       | 322 +++++++++++++++-
 drivers/infiniband/core/uverbs_nl.c         |  92 +++++
 include/linux/netlink.h                     |   1 -
 include/net/netlink.h                       |   5 +
 include/rdma/ib_ioctl.h                     |  49 +++
 include/rdma/ib_verbs.h                     |  10 +-
 include/uapi/rdma/Kbuild                    |   1 +
 include/uapi/rdma/ib_user_ioctl.h           | 126 +++++++
 include/uapi/rdma/ib_user_mad.h             |  12 -
 lib/nlattr.c                                |  43 ++-
 16 files changed, 1290 insertions(+), 429 deletions(-)
 create mode 100644 drivers/infiniband/core/uverbs_cmd_common.c
 create mode 100644 drivers/infiniband/core/uverbs_cmd_nl.c
 create mode 100644 drivers/infiniband/core/uverbs_nl.c
 create mode 100644 include/rdma/ib_ioctl.h
 create mode 100644 include/uapi/rdma/ib_user_ioctl.h

-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
