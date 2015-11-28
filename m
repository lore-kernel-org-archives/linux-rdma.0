From: Julia Lawall <Julia.Lawall-L2FTfq7BK8M@public.gmane.org>
Subject: [PATCH] IB/iser: constify iser_reg_ops structure
Date: Sat, 28 Nov 2015 16:52:04 +0100
Message-ID: <1448725924-26376-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The iser_reg_ops structures are never modified, so declare them as const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall-L2FTfq7BK8M@public.gmane.org>

---
 drivers/infiniband/ulp/iser/iscsi_iser.h  |    2 +-
 drivers/infiniband/ulp/iser/iser_memory.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 8a5998e..08d0926 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -400,7 +400,7 @@ struct iser_device {
 	int                          refcount;
 	int			     comps_used;
 	struct iser_comp	     *comps;
-	struct iser_reg_ops          *reg_ops;
+	const struct iser_reg_ops    *reg_ops;
 };
 
 #define ISER_CHECK_GUARD	0xc0
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index ea765fb..b137d6d 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -49,7 +49,7 @@ int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 		     struct iser_reg_resources *rsc,
 		     struct iser_mem_reg *mem_reg);
 
-static struct iser_reg_ops fastreg_ops = {
+static const struct iser_reg_ops fastreg_ops = {
 	.alloc_reg_res	= iser_alloc_fastreg_pool,
 	.free_reg_res	= iser_free_fastreg_pool,
 	.reg_mem	= iser_fast_reg_mr,
@@ -58,7 +58,7 @@ static struct iser_reg_ops fastreg_ops = {
 	.reg_desc_put	= iser_reg_desc_put_fr,
 };
 
-static struct iser_reg_ops fmr_ops = {
+static const struct iser_reg_ops fmr_ops = {
 	.alloc_reg_res	= iser_alloc_fmr_pool,
 	.free_reg_res	= iser_free_fmr_pool,
 	.reg_mem	= iser_fast_reg_fmr,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
