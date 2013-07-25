From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V8 libibverbs 0/7] Add extension and XRC QP support
Date: Thu, 25 Jul 2013 11:38:01 +0300
Message-ID: <1374741488-30895-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Extend XRC support to user space through libibverbs.  Because XRC requires
new verbs and extensions to existing verbs, we first introduce a generic
mechanism for extending verbs in a backward compatible manner.  XRC support
is built on top of that infrastructure.

Changes from v7:
Fix "container_of" macro to enable applications to compile with c99 standard (-std=c99).
Remove place holder for 6 function pointers in verbs_context.
Added an helper macro verbs_set_ctx_op to be used by providers to hook their extended functions.

Changes from v6:
Bug fixes, details in relevant patches.
ABI support with OFED release, added place holder for 6 function pointers
 in verbs_context to enable ABI compatibility with OFED release that already 
 used 6 extended verbs before XRC. 
Man pages were added.


Jay Sternberg (1):
  Add XRC sample application

Sean Hefty (5):
  Introduce XRC domains
  Add support for XRC SRQs
  Add support for XRC QPs
  Add ibv_open_qp
  XRC man pages

Yishai Hadas (1):
  Infrastructure to support verbs extensions

 Makefile.am                   |   12 +-
 examples/xsrq_pingpong.c      |  890 +++++++++++++++++++++++++++++++++++++++++
 include/infiniband/driver.h   |   72 ++++
 include/infiniband/kern-abi.h |  112 ++++--
 include/infiniband/verbs.h    |  256 ++++++++++++-
 man/ibv_create_qp_ex.3        |   83 ++++
 man/ibv_create_srq_ex.3       |   71 ++++
 man/ibv_get_srq_num.3         |   32 ++
 man/ibv_open_qp.3             |   51 +++
 man/ibv_open_xrcd.3           |   76 ++++
 src/cmd.c                     |  391 ++++++++++++------
 src/device.c                  |   53 ++-
 src/init.c                    |   41 ++-
 src/kern_abi.h                |  101 -----
 src/libibverbs.map            |    8 +
 15 files changed, 1953 insertions(+), 296 deletions(-)
 create mode 100644 examples/xsrq_pingpong.c
 create mode 100644 man/ibv_create_qp_ex.3
 create mode 100644 man/ibv_create_srq_ex.3
 create mode 100644 man/ibv_get_srq_num.3
 create mode 100644 man/ibv_open_qp.3
 create mode 100644 man/ibv_open_xrcd.3
 delete mode 100644 src/kern_abi.h

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
