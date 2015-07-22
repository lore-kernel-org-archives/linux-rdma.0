From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH WIP 07/43] qib: Support ib_alloc_mr verb
Date: Wed, 22 Jul 2015 09:55:07 +0300
Message-ID: <1437548143-24893-8-git-send-email-sagig@mellanox.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437548143-24893-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_mr.c    | 23 +++++++++++++++++++++++
 drivers/infiniband/hw/qib/qib_verbs.c |  1 +
 drivers/infiniband/hw/qib/qib_verbs.h |  5 +++++
 3 files changed, 29 insertions(+)

diff --git a/drivers/infiniband/hw/qib/qib_mr.c b/drivers/infiniband/hw/qib/qib_mr.c
index c4473db..1522255 100644
--- a/drivers/infiniband/hw/qib/qib_mr.c
+++ b/drivers/infiniband/hw/qib/qib_mr.c
@@ -327,6 +327,29 @@ out:
  *
  * Return the memory region on success, otherwise return an errno.
  */
+struct ib_mr *qib_alloc_mr(struct ib_pd *pd,
+			   enum ib_mr_type mr_type,
+			   u32 max_entries,
+			   u32 flags)
+{
+	struct qib_mr *mr;
+
+	if (mr_type != IB_MR_TYPE_FAST_REG || flags)
+		return ERR_PTR(-EINVAL);
+
+	mr = alloc_mr(max_entries, pd);
+	if (IS_ERR(mr))
+		return (struct ib_mr *)mr;
+
+	return &mr->ibmr;
+}
+
+/*
+ * Allocate a memory region usable with the
+ * IB_WR_FAST_REG_MR send work request.
+ *
+ * Return the memory region on success, otherwise return an errno.
+ */
 struct ib_mr *qib_alloc_fast_reg_mr(struct ib_pd *pd, int max_page_list_len)
 {
 	struct qib_mr *mr;
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index a05d1a3..323666b 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -2235,6 +2235,7 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	ibdev->reg_phys_mr = qib_reg_phys_mr;
 	ibdev->reg_user_mr = qib_reg_user_mr;
 	ibdev->dereg_mr = qib_dereg_mr;
+	ibdev->alloc_mr = qib_alloc_mr;
 	ibdev->alloc_fast_reg_mr = qib_alloc_fast_reg_mr;
 	ibdev->alloc_fast_reg_page_list = qib_alloc_fast_reg_page_list;
 	ibdev->free_fast_reg_page_list = qib_free_fast_reg_page_list;
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index 1635572..034510c 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -1032,6 +1032,11 @@ struct ib_mr *qib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 
 int qib_dereg_mr(struct ib_mr *ibmr);
 
+struct ib_mr *qib_alloc_mr(struct ib_pd *pd,
+			   enum ib_mr_type mr_type,
+			   u32 max_entries,
+			   u32 flags);
+
 struct ib_mr *qib_alloc_fast_reg_mr(struct ib_pd *pd, int max_page_list_len);
 
 struct ib_fast_reg_page_list *qib_alloc_fast_reg_page_list(
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
