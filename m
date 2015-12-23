From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 10/10] IB: remove the write-only usecnt field from struct ib_mr
Date: Wed, 23 Dec 2015 19:12:54 +0100
Message-ID: <1450894374-8241-11-git-send-email-hch@lst.de>
References: <1450894374-8241-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450894374-8241-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Bart Van Assche <bvanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c        | 6 ------
 drivers/infiniband/core/verbs.c             | 8 +-------
 drivers/infiniband/hw/cxgb3/iwch_provider.c | 3 ---
 drivers/infiniband/hw/cxgb4/mem.c           | 3 ---
 drivers/staging/rdma/ehca/ehca_mrmw.c       | 1 -
 include/rdma/ib_verbs.h                     | 1 -
 6 files changed, 1 insertion(+), 21 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 5428ebe..0a84182d 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -993,7 +993,6 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 	mr->pd      = pd;
 	mr->uobject = uobj;
 	atomic_inc(&pd->usecnt);
-	atomic_set(&mr->usecnt, 0);
 
 	uobj->object = mr;
 	ret = idr_add_uobj(&ib_uverbs_mr_idr, uobj);
@@ -1091,11 +1090,6 @@ ssize_t ib_uverbs_rereg_mr(struct ib_uverbs_file *file,
 		}
 	}
 
-	if (atomic_read(&mr->usecnt)) {
-		ret = -EBUSY;
-		goto put_uobj_pd;
-	}
-
 	old_pd = mr->pd;
 	ret = mr->device->rereg_user_mr(mr, cmd.flags, cmd.start,
 					cmd.length, cmd.hca_va,
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index c5e0f07..072b94d 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1345,7 +1345,6 @@ struct ib_mr *ib_get_dma_mr(struct ib_pd *pd, int mr_access_flags)
 		mr->pd      = pd;
 		mr->uobject = NULL;
 		atomic_inc(&pd->usecnt);
-		atomic_set(&mr->usecnt, 0);
 	}
 
 	return mr;
@@ -1354,13 +1353,9 @@ EXPORT_SYMBOL(ib_get_dma_mr);
 
 int ib_dereg_mr(struct ib_mr *mr)
 {
-	struct ib_pd *pd;
+	struct ib_pd *pd = mr->pd;
 	int ret;
 
-	if (atomic_read(&mr->usecnt))
-		return -EBUSY;
-
-	pd = mr->pd;
 	ret = mr->device->dereg_mr(mr);
 	if (!ret)
 		atomic_dec(&pd->usecnt);
@@ -1396,7 +1391,6 @@ struct ib_mr *ib_alloc_mr(struct ib_pd *pd,
 		mr->pd      = pd;
 		mr->uobject = NULL;
 		atomic_inc(&pd->usecnt);
-		atomic_set(&mr->usecnt, 0);
 	}
 
 	return mr;
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 6743e9d..2734820 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -458,9 +458,6 @@ static int iwch_dereg_mr(struct ib_mr *ib_mr)
 	u32 mmid;
 
 	PDBG("%s ib_mr %p\n", __func__, ib_mr);
-	/* There can be no memory windows */
-	if (atomic_read(&ib_mr->usecnt))
-		return -EINVAL;
 
 	mhp = to_iwch_mr(ib_mr);
 	kfree(mhp->pages);
diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index 1eb833a..7849890 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -704,9 +704,6 @@ int c4iw_dereg_mr(struct ib_mr *ib_mr)
 	u32 mmid;
 
 	PDBG("%s ib_mr %p\n", __func__, ib_mr);
-	/* There can be no memory windows */
-	if (atomic_read(&ib_mr->usecnt))
-		return -EINVAL;
 
 	mhp = to_c4iw_mr(ib_mr);
 	rhp = mhp->rhp;
diff --git a/drivers/staging/rdma/ehca/ehca_mrmw.c b/drivers/staging/rdma/ehca/ehca_mrmw.c
index 1814af7..06b832b 100644
--- a/drivers/staging/rdma/ehca/ehca_mrmw.c
+++ b/drivers/staging/rdma/ehca/ehca_mrmw.c
@@ -1339,7 +1339,6 @@ int ehca_reg_internal_maxmr(
 	e_mr->ib.ib_mr.pd = &e_pd->ib_pd;
 	e_mr->ib.ib_mr.uobject = NULL;
 	atomic_inc(&(e_pd->ib_pd.usecnt));
-	atomic_set(&(e_mr->ib.ib_mr.usecnt), 0);
 	*e_maxmr = e_mr;
 	return 0;
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 197b620..36acb30 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1414,7 +1414,6 @@ struct ib_mr {
 	u64		   iova;
 	u32		   length;
 	unsigned int	   page_size;
-	atomic_t	   usecnt; /* count number of MWs */
 };
 
 struct ib_mw {
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
