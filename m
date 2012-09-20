From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs 0/3] add raw packet QP, new helper and examples cleanups
Date: Thu, 20 Sep 2012 23:30:31 +0300
Message-ID: <1348173034-11929-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

This batch of libibverbs patches include the raw packet QP which
was submitted long ago, with new change-log, taken from the kernel,
also a helper verbs from Dotan and Hal related to the new IB link speeds,
and cleanup patch from Dotan for the examples.

Or.

Dotan Barak (2):
  Add helpers to deal with new InfiniBand link speeds
  Fix resource leaks in the pingpong examples present in the failure/error flows.

Or Gerlitz (1):
  Add raw packet QP type

 Makefile.am                |    6 +++-
 examples/rc_pingpong.c     |   43 ++++++++++++++++++++++++++++++-------
 examples/srq_pingpong.c    |   51 ++++++++++++++++++++++++++++++++++++-------
 examples/uc_pingpong.c     |   43 ++++++++++++++++++++++++++++++-------
 examples/ud_pingpong.c     |   43 ++++++++++++++++++++++++++++++-------
 include/infiniband/verbs.h |   26 ++++++++++++++++++++-
 man/ibv_create_qp.3        |    2 +-
 man/ibv_modify_qp.3        |   10 ++++++++
 man/ibv_rate_to_mbps.3     |   45 ++++++++++++++++++++++++++++++++++++++
 src/libibverbs.map         |    3 ++
 src/verbs.c                |   48 +++++++++++++++++++++++++++++++++++++++++
 11 files changed, 282 insertions(+), 38 deletions(-)
 create mode 100644 man/ibv_rate_to_mbps.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
