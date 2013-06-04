From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH libibverbs v6 0/7] Add extension and XRC QP support
Date: Tue,  4 Jun 2013 11:49:44 -0700
Message-ID: <1370371791-15018-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Extend XRC support to user space through libibverbs.  Because XRC requires
new verbs and extensions to existing verbs, we first introduce a generic
mechanism for extending verbs in a backward compatible manner.  XRC support
is built on top of that infrastructure.

Changes from v5:
Updated to latest master branch.

Jay Sternberg (1):
  libibverbs: Add XRC sample application

Sean Hefty (5):
  libibverbs: Introduce XRC domains
  livibverbs: Add support for XRC SRQs
  libibverbs: Add support for XRC QPs
  libibverbs: Add ibv_open_qp
  libibverbs: Add man page for ibv_open_qp

Yishai Hadas (1):
  Infrastructure to support verbs extensions

 Makefile.am                   |    4 +-
 examples/xsrq_pingpong.c      |  885 +++++++++++++++++++++++++++++++++++++++++
 include/infiniband/driver.h   |   64 +++
 include/infiniband/kern-abi.h |  112 ++++--
 include/infiniband/verbs.h    |  249 +++++++++++-
 man/ibv_open_qp.3             |   50 +++
 src/cmd.c                     |  374 ++++++++++++------
 src/device.c                  |   54 ++-
 src/init.c                    |   41 ++-
 src/kern_abi.h                |  101 -----
 src/libibverbs.map            |    8 +
 11 files changed, 1647 insertions(+), 295 deletions(-)
 create mode 100644 examples/xsrq_pingpong.c
 create mode 100644 man/ibv_open_qp.3
 delete mode 100644 src/kern_abi.h

-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
