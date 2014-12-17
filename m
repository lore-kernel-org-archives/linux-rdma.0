From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next 0/2] iw_cxgb4: Misc fixes for iw_cxgb4
Date: Wed, 17 Dec 2014 14:11:01 +0530
Message-ID: <1418805663-15333-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

This patch series serializes CQ event upcalls with CQ destruction and fixes
hanging of threads forever waiting on work request replies.

This patch series is created on top of infiniband tree, and includes patch on
iw_cxgb4 driver.

We have included all the maintainers of respective drivers. Kindly review the
change and let us know in case of any review comments.

Thanks

Hariprasad Shenai (2):
  iw_cxgb4: serialize CQ event upcalls with CQ destruction
  iw_cxgb4: don't hang threads forever waiting on WR replies

 drivers/infiniband/hw/cxgb4/ev.c       |    9 ++++++++-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |   30 +++++++++++++++---------------
 2 files changed, 23 insertions(+), 16 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
