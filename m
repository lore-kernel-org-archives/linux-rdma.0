From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 0/8] Endpoint timeout fix, SQ flush and other misc. fixes for iw_cxgb4
Date: Wed, 26 Mar 2014 18:53:51 +0530
Message-ID: <1395840239-4368-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi All,

This patch series provides fixes related to endpoint timeout, one fix related to
SQ flushing and other miscelleneous fixes for Chelsio T4/T5 adapters on iw_cxgb4.

The patches series is created against 'infiniband' tree, 'for-next' branch.
And includes patches on iw_cxgb4 driver. 

These patches were part of a bigger patch-series posted initially on netdev:
https://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg19052.html
Based on suggestion from David Miller, we have split above patch-series into
several smaller patch-series.
This is the last of the smaller patch-series on iw-cxgb4.

Since this patch-series contains purely iw_cxgb4 patches, we would like to
request this patch series to get merged via Roland's 'infiniband' tree.

We have included all the maintainers of respective drivers. Kindly review the
change and let us know in case of any review comments.

Thanks

Hariprasad Shenai (1):
  iw_cxgb4: Use pr_warn_ratelimited

Steve Wise (7):
  iw_cxgb4: endpoint timeout fixes
  iw_cxgb4: rmb() after reading valid gen bit
  iw_cxgb4: SQ flush fix
  iw_cxgb4: Max fastreg depth depends on DSGL support
  iw_cxgb4: Initialize reserved fields in a FW work request
  iw_cxgb4: Add missing debug stats
  iw_cxgb4: Use uninitialized_var()

 drivers/infiniband/hw/cxgb4/cm.c       | 89 +++++++++++++++++++++-------------
 drivers/infiniband/hw/cxgb4/cq.c       | 24 ++++-----
 drivers/infiniband/hw/cxgb4/mem.c      |  6 ++-
 drivers/infiniband/hw/cxgb4/provider.c |  2 +-
 drivers/infiniband/hw/cxgb4/qp.c       | 11 +++--
 drivers/infiniband/hw/cxgb4/resource.c | 10 ++--
 drivers/infiniband/hw/cxgb4/t4.h       | 11 ++++-
 7 files changed, 95 insertions(+), 58 deletions(-)

-- 
1.8.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
