From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next 5/5] iw_cxgb4: set the default MPA version to 2
Date: Tue,  8 Sep 2015 09:57:01 +0530
Message-ID: <1441686421-5899-6-git-send-email-hariprasad@chelsio.com>
References: <1441686421-5899-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441686421-5899-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This enables ORD/IRD negotiation and its about time to enable it by
default

Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 0e2741b..79d6855 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -115,11 +115,11 @@ module_param(ep_timeout_secs, int, 0644);
 MODULE_PARM_DESC(ep_timeout_secs, "CM Endpoint operation timeout "
 				   "in seconds (default=60)");
 
-static int mpa_rev = 1;
+static int mpa_rev = 2;
 module_param(mpa_rev, int, 0644);
 MODULE_PARM_DESC(mpa_rev, "MPA Revision, 0 supports amso1100, "
 		"1 is RFC0544 spec compliant, 2 is IETF MPA Peer Connect Draft"
-		" compliant (default=1)");
+		" compliant (default=2)");
 
 static int markers_enabled;
 module_param(markers_enabled, int, 0644);
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
