From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/hfi1: Support ib_alloc_mr verb
Date: Fri, 07 Aug 2015 10:51:25 -0400
Message-ID: <20150807145125.27568.22379.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Ported from upstream qib commit
68c02e232b8a ("qib: Support ib_alloc_mr verb")

Tested-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/hfi1/mr.c    |    9 +++++++--
 drivers/staging/hfi1/verbs.c |    1 +
 drivers/staging/hfi1/verbs.h |    4 +++-
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hfi1/mr.c b/drivers/staging/hfi1/mr.c
index 23567f8..bd64e4f 100644
--- a/drivers/staging/hfi1/mr.c
+++ b/drivers/staging/hfi1/mr.c
@@ -348,11 +348,16 @@ out:
  *
  * Return the memory region on success, otherwise return an errno.
  */
-struct ib_mr *hfi1_alloc_fast_reg_mr(struct ib_pd *pd, int max_page_list_len)
+struct ib_mr *hfi1_alloc_mr(struct ib_pd *pd,
+			    enum ib_mr_type mr_type,
+			    u32 max_num_sg)
 {
 	struct hfi1_mr *mr;
 
-	mr = alloc_mr(max_page_list_len, pd);
+	if (mr_type != IB_MR_TYPE_MEM_REG)
+		return ERR_PTR(-EINVAL);
+
+	mr = alloc_mr(max_num_sg, pd);
 	if (IS_ERR(mr))
 		return (struct ib_mr *)mr;
 
diff --git a/drivers/staging/hfi1/verbs.c b/drivers/staging/hfi1/verbs.c
index 5f4b661..53ac214 100644
--- a/drivers/staging/hfi1/verbs.c
+++ b/drivers/staging/hfi1/verbs.c
@@ -2045,6 +2045,7 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	ibdev->reg_phys_mr = hfi1_reg_phys_mr;
 	ibdev->reg_user_mr = hfi1_reg_user_mr;
 	ibdev->dereg_mr = hfi1_dereg_mr;
+	ibdev->alloc_mr = hfi1_alloc_mr;
 	ibdev->alloc_fast_reg_page_list = hfi1_alloc_fast_reg_page_list;
 	ibdev->free_fast_reg_page_list = hfi1_free_fast_reg_page_list;
 	ibdev->alloc_fmr = hfi1_alloc_fmr;
diff --git a/drivers/staging/hfi1/verbs.h b/drivers/staging/hfi1/verbs.h
index 8125361..ed903a9 100644
--- a/drivers/staging/hfi1/verbs.h
+++ b/drivers/staging/hfi1/verbs.h
@@ -1016,7 +1016,9 @@ struct ib_mr *hfi1_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 
 int hfi1_dereg_mr(struct ib_mr *ibmr);
 
-struct ib_mr *hfi1_alloc_fast_reg_mr(struct ib_pd *pd, int max_page_list_len);
+struct ib_mr *hfi1_alloc_mr(struct ib_pd *pd,
+			    enum ib_mr_type mr_type,
+			    u32 max_entries);
 
 struct ib_fast_reg_page_list *hfi1_alloc_fast_reg_page_list(
 				struct ib_device *ibdev, int page_list_len);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
