From: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 09/10] i40iw: Use 2M huge pages for CQ/QP memory if available
Date: Fri,  9 Dec 2016 11:55:03 -0600
Message-ID: <1481306104-19352-10-git-send-email-tatyana.e.nikolova@intel.com>
References: <1481306104-19352-1-git-send-email-tatyana.e.nikolova@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1481306104-19352-1-git-send-email-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Attempt to allocate a 2M huge page from the pool
for QP/CQ memory if its size is > 4K and < 2M.
This will lead to physically contiguous QP/CQ memory
and avoid the use of PBLs. The total number of 2M huge
pages available for this feature is controlled by a user
environment variable, I40IW_MAX_HUGEPGCNT, with an upper
limit of 100, and 0 if invalid values are used.

Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 providers/i40iw/i40iw_umain.c  | 10 +++++++++
 providers/i40iw/i40iw_umain.h  |  4 ++++
 providers/i40iw/i40iw_uverbs.c | 46 ++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/providers/i40iw/i40iw_umain.c b/providers/i40iw/i40iw_umain.c
index a204859..b2e6236 100644
--- a/providers/i40iw/i40iw_umain.c
+++ b/providers/i40iw/i40iw_umain.c
@@ -47,6 +47,7 @@
 #include "i40iw-abi.h"
 
 unsigned int i40iw_dbg;
+unsigned int i40iw_max_hugepgcnt;
 
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -241,6 +242,15 @@ found:
 	if (env_val)
 		i40iw_dbg = atoi(env_val);
 
+	env_val = getenv("I40IW_MAX_HUGEPGCNT");
+	if (env_val) {
+		if ((atoi(env_val) < 0) || (atoi(env_val) > 100))
+			fprintf(stderr, PFX "%s: Valid range for Max Huge Page Count is 0 to 100. Setting to 0\n",
+				__func__);
+		else
+			i40iw_max_hugepgcnt = atoi(env_val);
+	}
+
 	dev = malloc(sizeof(*dev));
 	if (!dev) {
 		i40iw_debug("failed to allocate memory for device object\n");
diff --git a/providers/i40iw/i40iw_umain.h b/providers/i40iw/i40iw_umain.h
index 889c006..7bcd197 100644
--- a/providers/i40iw/i40iw_umain.h
+++ b/providers/i40iw/i40iw_umain.h
@@ -72,6 +72,8 @@
 #define I40E_DB_SHADOW_AREA_SIZE 64
 #define I40E_DB_CQ_OFFSET 0x40
 
+#define I40IW_HPAGE_SIZE_2M (2 * 1024 * 1024)
+
 extern unsigned int i40iw_dbg;
 #define i40iw_debug(fmt, args...) \
 do { \
@@ -120,6 +122,7 @@ struct i40iw_ucq {
 	int comp_vector;
 	struct i40iw_uqp *udqp;
 	struct i40iw_cq_uk cq;
+	bool is_hugetlb;
 };
 
 struct i40iw_uqp {
@@ -138,6 +141,7 @@ struct i40iw_uqp {
 	uint32_t wq_size;
 	struct ibv_recv_wr *pend_rx_wr;
 	struct i40iw_qp_uk qp;
+	bool is_hugetlb;
 
 };
 
diff --git a/providers/i40iw/i40iw_uverbs.c b/providers/i40iw/i40iw_uverbs.c
index 464900b..85ed77c 100644
--- a/providers/i40iw/i40iw_uverbs.c
+++ b/providers/i40iw/i40iw_uverbs.c
@@ -51,6 +51,9 @@
 #include "i40iw_umain.h"
 #include "i40iw-abi.h"
 
+unsigned int i40iw_hugepgcnt;
+extern unsigned int i40iw_max_hugepgcnt;
+
 /**
  * i40iw_uquery_device - call driver to query device for max resources
  * @context: user context for the device
@@ -248,11 +251,24 @@ struct ibv_cq *i40iw_ucreate_cq(struct ibv_context *context, int cqe,
 	cq_pages = i40iw_num_of_pages(info.cq_size * cqe_struct_size);
 	totalsize = (cq_pages << 12) + I40E_DB_SHADOW_AREA_SIZE;
 
+	if ((totalsize > I40IW_HW_PAGE_SIZE) && (totalsize <= I40IW_HPAGE_SIZE_2M)) {
+		if (i40iw_hugepgcnt < i40iw_max_hugepgcnt) {
+			info.cq_base = mmap(NULL, I40IW_HPAGE_SIZE_2M, PROT_READ | PROT_WRITE,
+					MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, 0, 0);
+			if (info.cq_base != MAP_FAILED) {
+				iwucq->is_hugetlb = true;
+				i40iw_hugepgcnt++;
+				goto cqmem_alloc_done;
+			}
+		}
+	}
+
 	info.cq_base = memalign(I40IW_HW_PAGE_SIZE, totalsize);
 
 	if (!info.cq_base)
 		goto err;
 
+cqmem_alloc_done:
 	memset(info.cq_base, 0, totalsize);
 	info.shadow_area = (u64 *)((u8 *)info.cq_base + (cq_pages << 12));
 	reg_mr_cmd.reg_type = I40IW_UMEMREG_TYPE_CQ;
@@ -315,7 +331,13 @@ int i40iw_udestroy_cq(struct ibv_cq *cq)
 
 	ibv_cmd_dereg_mr(&iwucq->mr);
 
-	free(iwucq->cq.cq_base);
+	if (iwucq->is_hugetlb) {
+		munmap(iwucq->cq.cq_base, I40IW_HPAGE_SIZE_2M);
+		i40iw_hugepgcnt--;
+	} else {
+		free(iwucq->cq.cq_base);
+	}
+
 	free(iwucq);
 
 	return 0;
@@ -481,7 +503,13 @@ static int i40iw_destroy_vmapped_qp(struct i40iw_uqp *iwuqp,
 		munmap(iwuqp->push_wqe, I40IW_HW_PAGE_SIZE);
 
 	ibv_cmd_dereg_mr(&iwuqp->mr);
-	free((void *)sq_base);
+
+	if (iwuqp->is_hugetlb) {
+		munmap((void *)sq_base, I40IW_HPAGE_SIZE_2M);
+		i40iw_hugepgcnt--;
+	} else {
+		free((void *)sq_base);
+	}
 
 	return 0;
 }
@@ -519,6 +547,19 @@ static int i40iw_vmapped_qp(struct i40iw_uqp *iwuqp, struct ibv_pd *pd,
 	sqsize = sq_pages << 12;
 	rqsize = rq_pages << 12;
 	totalqpsize = rqsize + sqsize + I40E_DB_SHADOW_AREA_SIZE;
+
+	if ((totalqpsize > I40IW_HW_PAGE_SIZE) && (totalqpsize <= I40IW_HPAGE_SIZE_2M)) {
+		if (i40iw_hugepgcnt < i40iw_max_hugepgcnt) {
+			info->sq = mmap(NULL, I40IW_HPAGE_SIZE_2M, PROT_READ | PROT_WRITE,
+					MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, 0, 0);
+			if (info->sq != MAP_FAILED) {
+				iwuqp->is_hugetlb = true;
+				i40iw_hugepgcnt++;
+				goto qpmem_alloc_done;
+			}
+		}
+	}
+
 	info->sq = memalign(I40IW_HW_PAGE_SIZE, totalqpsize);
 
 	if (!info->sq) {
@@ -526,6 +567,7 @@ static int i40iw_vmapped_qp(struct i40iw_uqp *iwuqp, struct ibv_pd *pd,
 		return 0;
 	}
 
+qpmem_alloc_done:
 	memset(info->sq, 0, totalqpsize);
 	info->rq = &info->sq[sqsize / I40IW_QP_WQE_MIN_SIZE];
 	info->shadow_area = info->rq[rqsize / I40IW_QP_WQE_MIN_SIZE].elem;
-- 
1.8.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
