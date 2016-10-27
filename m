From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 0/6] IB core fixes for 4.9
Date: Thu, 27 Oct 2016 16:36:25 +0300
Message-ID: <1477575391-20134-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Please find below six different fixes and improvements to IB core.

This patchset was generated against v4.9-rc1.

Available in the "topic/core-fixes-4.9" topic branch of this git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git

Or for browsing:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/core-fixes-4.9

Thanks

Mark Bloch (5):
  IB/cm: Mark stale CM id's whenever the mad agent was unregistered
  IB/core: Set routable RoCE gid type for ipv4/ipv6 networks
  IB/core: Add missing check for addr_resolve callback return value
  IB/core: Save QP in ib_flow structure
  IB/core: Avoid unsigned int overflow in sg_alloc_table

Tariq Toukan (1):
  IB/uverbs: Fix leak of XRC target QPs

 drivers/infiniband/core/addr.c        |  11 ++-
 drivers/infiniband/core/cm.c          | 126 +++++++++++++++++++++++++++++-----
 drivers/infiniband/core/cma.c         |  21 +++++-
 drivers/infiniband/core/umem.c        |   2 +-
 drivers/infiniband/core/uverbs_cmd.c  |   1 -
 drivers/infiniband/core/uverbs_main.c |   7 +-
 drivers/infiniband/core/verbs.c       |   4 +-
 7 files changed, 145 insertions(+), 27 deletions(-)

--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
