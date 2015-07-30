From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-4.3 14/15] qib: Support ib_alloc_mr verb
Date: Thu, 30 Jul 2015 10:32:47 +0300
Message-ID: <1438241568-3685-15-git-send-email-sagig@mellanox.com>
References: <1438241568-3685-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438241568-3685-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_mr.c    | 9 +++++++--
 drivers/infiniband/hw/qib/qib_verbs.c | 2 +-
 drivers/infiniband/hw/qib/qib_verbs.h | 4 +++-
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_mr.c b/drivers/infiniband/hw/qib/qib_mr.c
index c4473db..19220dc 100644
--- a/drivers/infiniband/hw/qib/qib_mr.c
+++ b/drivers/infiniband/hw/qib/qib_mr.c
@@ -327,11 +327,16 @@ out:
  *
  * Return the memory region on success, otherwise return an errno.
  */
-struct ib_mr *qib_alloc_fast_reg_mr(struct ib_pd *pd, int max_page_list_len)
+struct ib_mr *qib_alloc_mr(struct ib_pd *pd,
+			   enum ib_mr_type mr_type,
+			   u32 max_num_sg)
 {
 	struct qib_mr *mr;
 
-	mr = alloc_mr(max_page_list_len, pd);
+	if (mr_type != IB_MR_TYPE_MEM_REG)
+		return ERR_PTR(-EINVAL);
+
+	mr = alloc_mr(max_num_sg, pd);
 	if (IS_ERR(mr))
 		return (struct ib_mr *)mr;
 
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index a05d1a3..ef022a1 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -2235,7 +2235,7 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	ibdev->reg_phys_mr = qib_reg_phys_mr;
 	ibdev->reg_user_mr = qib_reg_user_mr;
 	ibdev->dereg_mr = qib_dereg_mr;
-	ibdev->alloc_fast_reg_mr = qib_alloc_fast_reg_mr;
+	ibdev->alloc_mr = qib_alloc_mr;
 	ibdev->alloc_fast_reg_page_list = qib_alloc_fast_reg_page_list;
 	ibdev->free_fast_reg_page_list = qib_free_fast_reg_page_list;
 	ibdev->alloc_fmr = qib_alloc_fmr;
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index 1635572..3bc0caf 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -1032,7 +1032,9 @@ struct ib_mr *qib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 
 int qib_dereg_mr(struct ib_mr *ibmr);
 
-struct ib_mr *qib_alloc_fast_reg_mr(struct ib_pd *pd, int max_page_list_len);
+struct ib_mr *qib_alloc_mr(struct ib_pd *pd,
+			   enum ib_mr_type mr_type,
+			   u32 max_entries);
 
 struct ib_fast_reg_page_list *qib_alloc_fast_reg_page_list(
 				struct ib_device *ibdev, int page_list_len);
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
