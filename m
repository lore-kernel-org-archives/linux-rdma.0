From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next 0/4] Misc. fixes and cleanup for iw_cxgb4
Date: Thu, 19 Mar 2015 22:13:26 +0530
Message-ID: <1426783410-5128-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

This patch series changes a macro definition to be consistent with other
register macro defines. Fixes for 32b platform, use BAR2 register for kernel
mode CQ's and enforces qp/cq id requirements.

The patches series is created against 'infiniband' tree for-next branch.
And includes patches on iw_cxgb4 driver.

We have included all the maintainers of respective drivers. Kindly review the
change and let us know in case of any review comments.

Thanks

Hariprasad Shenai (4):
  iw_cxgb4: Cleanup register defines/MACROS
  iw_cxgb4: 32b platform fixes
  iw_cxgb4: use BAR2 GTS register for T5 kernel mode CQs
  iw_cxgb4: enforce qp/cq id requirements

 drivers/infiniband/hw/cxgb4/cm.c          |    6 +++---
 drivers/infiniband/hw/cxgb4/cq.c          |   21 ++++++++++++++-------
 drivers/infiniband/hw/cxgb4/device.c      |   29 ++++++++++++++++++++++++++---
 drivers/infiniband/hw/cxgb4/mem.c         |   10 +++++-----
 drivers/infiniband/hw/cxgb4/qp.c          |   14 +++++++-------
 drivers/infiniband/hw/cxgb4/t4.h          |    7 ++++---
 drivers/infiniband/hw/cxgb4/t4fw_ri_api.h |    4 +++-
 7 files changed, 62 insertions(+), 29 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
