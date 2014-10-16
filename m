From: Pramod Kumar <pramod-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 2/2] cxgb4/rdma: configure 0B MRs to match HW implementation
Date: Thu, 16 Oct 2014 15:06:29 +0530
Message-ID: <1413452189-5427-3-git-send-email-pramod@chelsio.com>
References: <1413452189-5427-1-git-send-email-pramod@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1413452189-5427-1-git-send-email-pramod-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Pramod Kumar <pramod-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

0B MRs need some tweaks to work correctly with HW.
So when writing the TPTE, if the MR length is zero we now do:

1) turn off all permissions
2) set the length to -1

While functionality/capabilities of the MR is the same with these
changes, it resolves a dapltest 0B RDMA Read test failure
Based on original work by Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Signed-off-by: Pramod Kumar <pramod-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/mem.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index ec7a298..a299ba8 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -369,9 +369,11 @@ static int register_mem(struct c4iw_dev *rhp, struct c4iw_pd *php,
 	int ret;
 
 	ret = write_tpt_entry(&rhp->rdev, 0, &stag, 1, mhp->attr.pdid,
-			      FW_RI_STAG_NSMR, mhp->attr.perms,
+			      FW_RI_STAG_NSMR, mhp->attr.len ?
+			      mhp->attr.perms : 0,
 			      mhp->attr.mw_bind_enable, mhp->attr.zbva,
-			      mhp->attr.va_fbo, mhp->attr.len, shift - 12,
+			      mhp->attr.va_fbo, mhp->attr.len ?
+			      mhp->attr.len : -1, shift - 12,
 			      mhp->attr.pbl_size, mhp->attr.pbl_addr);
 	if (ret)
 		return ret;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
