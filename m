From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RDMA PATCH 01/16] RDMA/i40iw: Fix overflow of region length
Date: Wed, 13 Apr 2016 09:30:37 -0500
Message-ID: <1460557852-10824-2-git-send-email-mustafa.ismail@intel.com>
References: <1460557852-10824-1-git-send-email-mustafa.ismail@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460557852-10824-1-git-send-email-mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Change region_length to u64 as a region can be > 4GB.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_user.h  | 2 ++
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 8 +++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_user.h b/drivers/infiniband/hw/i40iw/i40iw_user.h
index 5cd971b..eac9524 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_user.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_user.h
@@ -102,6 +102,8 @@ enum i40iw_device_capabilities_const {
 
 #define I40IW_STAG_INDEX_FROM_STAG(stag)    (((stag) && 0xFFFFFF00) >> 8)
 
+#define	I40IW_MAX_MR_SIZE	0x10000000000L
+
 struct i40iw_qp_uk;
 struct i40iw_cq_uk;
 struct i40iw_srq_uk;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 1fe3b84..d7c4dd1 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -1526,14 +1526,16 @@ static struct ib_mr *i40iw_reg_user_mr(struct ib_pd *pd,
 	struct i40iw_mr *iwmr;
 	struct ib_umem *region;
 	struct i40iw_mem_reg_req req;
-	u32 pbl_depth = 0;
+	u64 pbl_depth = 0;
 	u32 stag = 0;
 	u16 access;
-	u32 region_length;
+	u64 region_length;
 	bool use_pbles = false;
 	unsigned long flags;
 	int err = -ENOSYS;
 
+	if (length > I40IW_MAX_MR_SIZE)
+		return ERR_PTR(-EINVAL);
 	region = ib_umem_get(pd->uobject->context, start, length, acc, 0);
 	if (IS_ERR(region))
 		return (struct ib_mr *)region;
@@ -1564,7 +1566,7 @@ static struct ib_mr *i40iw_reg_user_mr(struct ib_pd *pd,
 	palloc = &iwpbl->pble_alloc;
 
 	iwmr->type = req.reg_type;
-	iwmr->page_cnt = pbl_depth;
+	iwmr->page_cnt = (u32)pbl_depth;
 
 	switch (req.reg_type) {
 	case IW_MEMREG_TYPE_QP:
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
