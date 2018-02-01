From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH v1 rdma-next 4/6] iw_cxgb4: initialize ib_mr fields for user
 mrs
Date: Thu, 1 Feb 2018 14:41:45 -0800
Message-ID: <75e14444c5fc4e53bccfbc6c2969c24b3f593dfc.1518552179.git.swise@opengridcomputing.com>
References: <cover.1518552179.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1518552179.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Some of the struct ib_mr fields weren't getting initialized.  This was
benign, but will cause problems when dumping the mr resource via
nldev/restrack.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/mem.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index 7e0eb20..e90f2fd 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -391,6 +391,9 @@ static int finish_mem_reg(struct c4iw_mr *mhp, u32 stag)
 	mhp->attr.stag = stag;
 	mmid = stag >> 8;
 	mhp->ibmr.rkey = mhp->ibmr.lkey = stag;
+	mhp->ibmr.length = mhp->attr.len;
+	mhp->ibmr.iova = mhp->attr.va_fbo;
+	mhp->ibmr.page_size = 1U << (mhp->attr.page_size + 12);
 	pr_debug("mmid 0x%x mhp %p\n", mmid, mhp);
 	return insert_handle(mhp->rhp, &mhp->rhp->mmidr, mhp, mmid);
 }
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
