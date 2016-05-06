From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V2 0/5] Trivial fixes for 4.7
Date: Fri,  6 May 2016 22:45:23 +0300
Message-ID: <1462563928-29164-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

I'm sending to you small collection of trivial fixes to core code.

It fixes forgotten skb release call, potential overrun in CMA/SA, integration of
ib_addr.ko into ib_core.ko and one code simplifications which doesn't introduce
any code change behavior.

Available in the "topic/fix-core" topic branch of this git repo:

git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git

Or for browsing:

https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/fix-core

Changes since v2:
 * Removed iwcm_nl_cb_table size initialization

Changes since v1:
 * Added Reviewed-by tags
 * Revisited titles
 * Removed RDMA_NL_RDMA_CM_NUM_OPS and RDMA_NL_LS_NUM_OPS
 * Removed useless enumeration value
 * Converted ib_addr module to be integral part of ib_core module

Leon Romanovsky (1):
  IB/core: Integrate IB address resolution module into core

Mark Bloch (4):
  IB/IWPM: Fix a potential skb leak
  IB/core: Remove unnecessary check in ibnl_rcv_msg
  IB/core: Fix a potential array overrun in CMA and SA agent
  IB/SA: Use correct free function

 drivers/infiniband/core/Makefile    |  6 ++----
 drivers/infiniband/core/addr.c      | 11 ++---------
 drivers/infiniband/core/cma.c       |  3 ++-
 drivers/infiniband/core/device.c    | 11 ++++++++++-
 drivers/infiniband/core/iwcm.c      |  2 +-
 drivers/infiniband/core/iwpm_util.c |  1 +
 drivers/infiniband/core/netlink.c   |  5 ++---
 drivers/infiniband/core/sa_query.c  |  4 ++--
 include/rdma/ib_addr.h              |  3 +++
 9 files changed, 25 insertions(+), 21 deletions(-)

-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
