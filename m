From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next 0/5] set MPA revision to 2 and misc. fixes for iw_cxgb4
Date: Tue,  8 Sep 2015 09:56:56 +0530
Message-ID: <1441686421-5899-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

This patch series adds the following.
Detect errors while creating listening servers, pass ird/ord info in
connect reply events, fix misuse of ord for ird calculation and for the
ESTABLISHED event we should have the peer's ord/ird so swap the values in
the event before the upcall. Set default MPA version to 2.

This patch series has been created against Doug's linux tree and includes
patches on iw_cxgb4 driver.

We have included all the maintainers of respective drivers. Kindly review
the change and let us know in case of any review comments.

Thanks


Hariprasad Shenai (5):
  iw_cxgb4: detect fatal errors while creating listening filters
  iw_cxgb4: pass the ord/ird in connect reply events
  iw_cxgb4: fix misuse of ep->ord for minimum ird calculation
  iw_cxgb4: reverse the ord/ird in the ESTABLISHED upcall
  iw_cxgb4: set the default MPA version to 2

 drivers/infiniband/hw/cxgb4/cm.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
