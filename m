From: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 0/8] Critical bug fixes for RDMA/cxgb4
Date: Tue,  6 Aug 2013 21:04:32 +0530
Message-ID: <1375803280-7916-1-git-send-email-vipul@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch series fixes critical bugs for RDMA/cxgb4. It fixes bugs in QP flush
path, handles newer firmware changes, deals with wrap around issue of the queue,
sets arp error handler etc.

The patch-series is based on Roland's infiniband tree for-next branch.

This series is on top of previously submitted series "Add IPv6 support for
iWARP" which can be found at following location:
http://comments.gmane.org/gmane.linux.network/272124
We request Roland to merge above series first and then apply this series on top
of it.

Please review the series and let us know in case of any review comments.

Thanks,
Vipul Pandya

Steve Wise (8):
  RDMA/cxgb4: Use correct bit shift macros for vlan filter tuples
  RDMA/cxgb4: Handle newer firmware changes
  RDMA/cxgb4: Fix QP flush logic
  RDMA/cxgb4: Account for unsignled SQ WRs that fails to deal with wrap
  RDMA/cxgb4: Set arp error handler for PASS_ACCEPT_RPL messages.
  RDMA/cxgb4: Always do GTS write if cidx_inc == CIDXINC_MASK.
  RDMA/cxgb4: Advertise ~0ULL as max MR size.
  RDMA/cxgb4: Issue RI.FINI before closing when entering TERM

 drivers/infiniband/hw/cxgb4/cm.c       |   9 +-
 drivers/infiniband/hw/cxgb4/cq.c       | 329 +++++++++++++++++++++------------
 drivers/infiniband/hw/cxgb4/ev.c       |  10 -
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |   5 +-
 drivers/infiniband/hw/cxgb4/qp.c       |  41 ++--
 drivers/infiniband/hw/cxgb4/t4.h       |  29 ++-
 6 files changed, 270 insertions(+), 153 deletions(-)

-- 
1.8.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
