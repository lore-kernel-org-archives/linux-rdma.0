From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 0/8] Misc. fixes for iw_cxgb4
Date: Wed, 19 Mar 2014 17:44:37 +0530
Message-ID: <1395231285-4495-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi All,

This patch series provides miscelleneous fixes for Chelsio T4/T5 adapters
related to iw_cxgb4. 

The patches series is created against 'linux-next' tree.
And includes patches on iw_cxgb4 driver. Also, these patches are dependent on 
following two commits present in linux-next tree:
05eb238 ("cxgb4/iw_cxgb4: Doorbell Drop Avoidance Bug Fixes")
7a2cea2 ("cxgb4/iw_cxgb4: Treat CPL_ERR_KEEPALV_NEG_ADVICE as negative advice")

These patches were part of a bigger patch-series posted initially on netdev:
https://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg19052.html
Based on suggestion from David Miller, we have split above patch-series into
several smaller patch-series.

Since this patch-series contains purely iw_cxgb4 patches, we would like to request
this patch series to get merged via Roland's 'infiniband' tree.

We have included all the maintainers of respective drivers. Kindly review the
change and let us know in case of any review comments.

Thanks

Steve Wise (8):
  iw_cxgb4: cap CQ size at T4_MAX_IQ_SIZE
  iw_cxgb4: Allow loopback connections
  iw_cxgb4: release neigh entry
  iw_cxgb4: use the BAR2/WC path for kernel QPs and T5 devices
  iw_cxgb4: Fix incorrect BUG_ON conditions
  iw_cxgb4: Mind the sq_sig_all/sq_sig_type QP attributes
  iw_cxgb4: default peer2peer mode to 1
  iw_cxgb4: save the correct map length for fast_reg_page_lists

 drivers/infiniband/hw/cxgb4/cm.c       |  9 ++---
 drivers/infiniband/hw/cxgb4/cq.c       |  6 ++--
 drivers/infiniband/hw/cxgb4/device.c   | 41 ++++++++++++++++++-----
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |  4 +++
 drivers/infiniband/hw/cxgb4/mem.c      | 12 +++++--
 drivers/infiniband/hw/cxgb4/qp.c       | 61 ++++++++++++++++++++++------------
 drivers/infiniband/hw/cxgb4/t4.h       | 58 +++++++++++++++++++++++++++++---
 7 files changed, 148 insertions(+), 43 deletions(-)

-- 
1.8.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
