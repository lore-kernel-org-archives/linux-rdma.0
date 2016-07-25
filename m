From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 04/28] IB/rdmavt: Add support for ib_map_mr_sg
Date: Mon, 25 Jul 2016 13:38:13 -0700
Message-ID: <20160725203812.4800.50880.stgit@scvm10.sc.intel.com>
References: <20160725203554.4800.37248.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160725203554.4800.37248.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This implements the device specific function needed by the verbs
API function ib_map_mr_sg().

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/mr.c |   51 +++++++++++++++++++++++++++++++++++++
 drivers/infiniband/sw/rdmavt/mr.h |    2 +
 drivers/infiniband/sw/rdmavt/vt.c |    7 +++++
 3 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/mr.c b/drivers/infiniband/sw/rdmavt/mr.c
index 0f4d450..75f158a 100644
--- a/drivers/infiniband/sw/rdmavt/mr.c
+++ b/drivers/infiniband/sw/rdmavt/mr.c
@@ -480,6 +480,57 @@ struct ib_mr *rvt_alloc_mr(struct ib_pd *pd,
 }
 
 /**
+ * rvt_set_page - page assignment function called by ib_sg_to_pages
+ * @ibmr: memory region
+ * @addr: dma address of mapped page
+ *
+ * Return: 0 on success
+ */
+static int rvt_set_page(struct ib_mr *ibmr, u64 addr)
+{
+	struct rvt_mr *mr = to_imr(ibmr);
+	u32 ps = 1 << mr->mr.page_shift;
+	u32 mapped_segs = mr->mr.length >> mr->mr.page_shift;
+	int m, n;
+
+	if (unlikely(mapped_segs == mr->mr.max_segs))
+		return -ENOMEM;
+
+	if (mr->mr.length == 0) {
+		mr->mr.user_base = addr;
+		mr->mr.iova = addr;
+	}
+
+	m = mapped_segs / RVT_SEGSZ;
+	n = mapped_segs % RVT_SEGSZ;
+	mr->mr.map[m]->segs[n].vaddr = (void *)addr;
+	mr->mr.map[m]->segs[n].length = ps;
+	mr->mr.length += ps;
+
+	return 0;
+}
+
+/**
+ * rvt_map_mr_sg - map sg list and set it the memory region
+ * @ibmr: memory region
+ * @sg: dma mapped scatterlist
+ * @sg_nents: number of entries in sg
+ * @sg_offset: offset in bytes into sg
+ *
+ * Return: number of sg elements mapped to the memory region
+ */
+int rvt_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg,
+		  int sg_nents, unsigned int *sg_offset)
+{
+	struct rvt_mr *mr = to_imr(ibmr);
+
+	mr->mr.length = 0;
+	mr->mr.page_shift = PAGE_SHIFT;
+	return ib_sg_to_pages(ibmr, sg, sg_nents, sg_offset,
+			      rvt_set_page);
+}
+
+/**
  * rvt_alloc_fmr - allocate a fast memory region
  * @pd: the protection domain for this memory region
  * @mr_access_flags: access flags for this memory region
diff --git a/drivers/infiniband/sw/rdmavt/mr.h b/drivers/infiniband/sw/rdmavt/mr.h
index 6938051..132800e 100644
--- a/drivers/infiniband/sw/rdmavt/mr.h
+++ b/drivers/infiniband/sw/rdmavt/mr.h
@@ -82,6 +82,8 @@ int rvt_dereg_mr(struct ib_mr *ibmr);
 struct ib_mr *rvt_alloc_mr(struct ib_pd *pd,
 			   enum ib_mr_type mr_type,
 			   u32 max_num_sg);
+int rvt_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg,
+		  int sg_nents, unsigned int *sg_offset);
 struct ib_fmr *rvt_alloc_fmr(struct ib_pd *pd, int mr_access_flags,
 			     struct ib_fmr_attr *fmr_attr);
 int rvt_map_phys_fmr(struct ib_fmr *ibfmr, u64 *page_list,
diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index 89fe967..d430c2f 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -370,6 +370,7 @@ enum {
 	REG_USER_MR,
 	DEREG_MR,
 	ALLOC_MR,
+	MAP_MR_SG,
 	ALLOC_FMR,
 	MAP_PHYS_FMR,
 	UNMAP_FMR,
@@ -634,6 +635,12 @@ static noinline int check_support(struct rvt_dev_info *rdi, int verb)
 				      rvt_alloc_mr);
 		break;
 
+	case MAP_MR_SG:
+		check_driver_override(rdi, offsetof(struct ib_device,
+						    map_mr_sg),
+				      rvt_map_mr_sg);
+		break;
+
 	case MAP_PHYS_FMR:
 		check_driver_override(rdi, offsetof(struct ib_device,
 						    map_phys_fmr),

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
