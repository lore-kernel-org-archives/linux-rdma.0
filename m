From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 2/6] IB/core: Encorce MR access rights rules on kernel consumers
Date: Thu, 31 Oct 2013 15:26:32 +0200
Message-ID: <1383225996-14828-3-git-send-email-eli@mellanox.com>
References: <1383225996-14828-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383225996-14828-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Enforce the rule that when requesting remote write or atomic permissions, local
write must be indicated as well. See IB spec 11.2.8.2.

Spotted by: Hagay Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

---
 drivers/infiniband/core/uverbs_cmd.c | 10 +++-------
 drivers/infiniband/core/verbs.c      | 14 ++++++++++++++
 include/rdma/ib_verbs.h              | 13 +++++++++++++
 3 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 5bb2a82d..7f671b7 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -939,13 +939,9 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 	if ((cmd.start & ~PAGE_MASK) != (cmd.hca_va & ~PAGE_MASK))
 		return -EINVAL;
 
-	/*
-	 * Local write permission is required if remote write or
-	 * remote atomic permission is also requested.
-	 */
-	if (cmd.access_flags & (IB_ACCESS_REMOTE_ATOMIC | IB_ACCESS_REMOTE_WRITE) &&
-	    !(cmd.access_flags & IB_ACCESS_LOCAL_WRITE))
-		return -EINVAL;
+	ret = ib_check_mr_access(cmd.access_flags);
+	if (ret)
+		return ret;
 
 	uobj = kmalloc(sizeof *uobj, GFP_KERNEL);
 	if (!uobj)
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index a321df2..b7f21d7 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -958,6 +958,11 @@ EXPORT_SYMBOL(ib_resize_cq);
 struct ib_mr *ib_get_dma_mr(struct ib_pd *pd, int mr_access_flags)
 {
 	struct ib_mr *mr;
+	int err;
+
+	err = ib_check_mr_access(mr_access_flags);
+	if (err)
+		return ERR_PTR(err);
 
 	mr = pd->device->get_dma_mr(pd, mr_access_flags);
 
@@ -980,6 +985,11 @@ struct ib_mr *ib_reg_phys_mr(struct ib_pd *pd,
 			     u64 *iova_start)
 {
 	struct ib_mr *mr;
+	int err;
+
+	err = ib_check_mr_access(mr_access_flags);
+	if (err)
+		return ERR_PTR(err);
 
 	if (!pd->device->reg_phys_mr)
 		return ERR_PTR(-ENOSYS);
@@ -1010,6 +1020,10 @@ int ib_rereg_phys_mr(struct ib_mr *mr,
 	struct ib_pd *old_pd;
 	int ret;
 
+	ret = ib_check_mr_access(mr_access_flags);
+	if (ret)
+		return ret;
+
 	if (!mr->device->rereg_phys_mr)
 		return -ENOSYS;
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index e393171..8f462a6 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2384,4 +2384,17 @@ struct ib_flow *ib_create_flow(struct ib_qp *qp,
 			       struct ib_flow_attr *flow_attr, int domain);
 int ib_destroy_flow(struct ib_flow *flow_id);
 
+static inline int ib_check_mr_access(int flags)
+{
+	/*
+	 * Local write permission is required if remote write or
+	 * remote atomic permission is also requested.
+	 */
+	if (flags & (IB_ACCESS_REMOTE_ATOMIC | IB_ACCESS_REMOTE_WRITE) &&
+	    !(flags & IB_ACCESS_LOCAL_WRITE))
+		return -EINVAL;
+
+	return 0;
+}
+
 #endif /* IB_VERBS_H */
-- 
1.8.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
