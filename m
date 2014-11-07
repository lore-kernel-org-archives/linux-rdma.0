From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 0/2] iw_cxgb4: Fixes locking issue and MR limit for T4/T5 adapter
Date: Fri,  7 Nov 2014 10:20:30 +0530
Message-ID: <1415335832-11413-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi, 

This patch series fixes a lock issue and limit MR's to 8 Gb for Chelsio T4/T5
adapter.

The patches series is created against 'infiniband' tree.
And includes patches on iw_cxgb4 driver.

We have included all the maintainers of respective drivers. Kindly review the
change and let us know in case of any review comments.

Thanks

Hariprasad Shenai (2):
  iw_cxgb4: Fixes locking issue in process_mpa_request
  iw_cxgb4: limit MRs to < 8GB for T4/T5 devices

 drivers/infiniband/hw/cxgb4/cm.c  |    3 ++-
 drivers/infiniband/hw/cxgb4/mem.c |   22 ++++++++++++++++++++++
 2 files changed, 24 insertions(+), 1 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
