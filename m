From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 1/5] i40iw: Allocate a sdbuf per CQP WQE
Date: Tue, 21 Nov 2017 16:18:30 -0600
Message-ID: <20171121221834.12524-2-henry.orosco@intel.com>
References: <20171121221834.12524-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171121221834.12524-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Currently there is only one sdbuf per Control QP (CQP) for
programming Segment Descriptor (SD). If multiple SD work
requests are posted simultaneously, the sdbuf is reused
by all WQEs and new WQEs can corrupt previous WQEs sdbuf
leading to incorrect SD programming.

Fix this by allocating one sdbuf per CQP SQ WQE. When an
SD command is posted, it will use the corresponding sdbuf
for the WQE.

Fixes: 86dbcd0f12e9 ("i40iw: add file to handle cqp calls")
Signed-off-by: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c | 41 ++++++++++++++++++++++----------
 drivers/infiniband/hw/i40iw/i40iw_d.h    |  4 +++-
 2 files changed, 31 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
index d88c6cf..db922d4 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
@@ -513,7 +513,7 @@ static enum i40iw_status_code i40iw_sc_cqp_create(struct i40iw_sc_cqp *cqp,
 
 	ret_code = i40iw_allocate_dma_mem(cqp->dev->hw,
 					  &cqp->sdbuf,
-					  128,
+					  I40IW_UPDATE_SD_BUF_SIZE * cqp->sq_size,
 					  I40IW_SD_BUF_ALIGNMENT);
 
 	if (ret_code)
@@ -596,14 +596,14 @@ void i40iw_sc_cqp_post_sq(struct i40iw_sc_cqp *cqp)
 }
 
 /**
- * i40iw_sc_cqp_get_next_send_wqe - get next wqe on cqp sq
- * @cqp: struct for cqp hw
- * @wqe_idx: we index of cqp ring
+ * i40iw_sc_cqp_get_next_send_wqe_idx - get next WQE on CQP SQ and pass back the index
+ * @cqp: pointer to CQP structure
+ * @scratch: private data for CQP WQE
+ * @wqe_idx: WQE index for next WQE on CQP SQ
  */
-u64 *i40iw_sc_cqp_get_next_send_wqe(struct i40iw_sc_cqp *cqp, u64 scratch)
+static u64 *i40iw_sc_cqp_get_next_send_wqe_idx(struct i40iw_sc_cqp *cqp, u64 scratch, u32 *wqe_idx)
 {
 	u64 *wqe = NULL;
-	u32	wqe_idx;
 	enum i40iw_status_code ret_code;
 
 	if (I40IW_RING_FULL_ERR(cqp->sq_ring)) {
@@ -616,21 +616,33 @@ u64 *i40iw_sc_cqp_get_next_send_wqe(struct i40iw_sc_cqp *cqp, u64 scratch)
 			    cqp->sq_ring.size);
 		return NULL;
 	}
-	I40IW_ATOMIC_RING_MOVE_HEAD(cqp->sq_ring, wqe_idx, ret_code);
+	I40IW_ATOMIC_RING_MOVE_HEAD(cqp->sq_ring, *wqe_idx, ret_code);
 	cqp->dev->cqp_cmd_stats[OP_REQUESTED_COMMANDS]++;
 	if (ret_code)
 		return NULL;
-	if (!wqe_idx)
+	if (!*wqe_idx)
 		cqp->polarity = !cqp->polarity;
 
-	wqe = cqp->sq_base[wqe_idx].elem;
-	cqp->scratch_array[wqe_idx] = scratch;
+	wqe = cqp->sq_base[*wqe_idx].elem;
+	cqp->scratch_array[*wqe_idx] = scratch;
 	I40IW_CQP_INIT_WQE(wqe);
 
 	return wqe;
 }
 
 /**
+ * i40iw_sc_cqp_get_next_send_wqe - get next wqe on cqp sq
+ * @cqp: struct for cqp hw
+ * @scratch: private data for CQP WQE
+ */
+u64 *i40iw_sc_cqp_get_next_send_wqe(struct i40iw_sc_cqp *cqp, u64 scratch)
+{
+	u32 wqe_idx;
+
+	return i40iw_sc_cqp_get_next_send_wqe_idx(cqp, scratch, &wqe_idx);
+}
+
+/**
  * i40iw_sc_cqp_destroy - destroy cqp during close
  * @cqp: struct for cqp hw
  */
@@ -3587,8 +3599,10 @@ static enum i40iw_status_code cqp_sds_wqe_fill(struct i40iw_sc_cqp *cqp,
 	u64 *wqe;
 	int mem_entries, wqe_entries;
 	struct i40iw_dma_mem *sdbuf = &cqp->sdbuf;
+	u64 offset;
+	u32 wqe_idx;
 
-	wqe = i40iw_sc_cqp_get_next_send_wqe(cqp, scratch);
+	wqe = i40iw_sc_cqp_get_next_send_wqe_idx(cqp, scratch, &wqe_idx);
 	if (!wqe)
 		return I40IW_ERR_RING_FULL;
 
@@ -3601,8 +3615,9 @@ static enum i40iw_status_code cqp_sds_wqe_fill(struct i40iw_sc_cqp *cqp,
 		 LS_64(mem_entries, I40IW_CQPSQ_UPESD_ENTRY_COUNT);
 
 	if (mem_entries) {
-		memcpy(sdbuf->va, &info->entry[3], (mem_entries << 4));
-		data = sdbuf->pa;
+		offset = wqe_idx * I40IW_UPDATE_SD_BUF_SIZE;
+		memcpy((char *)sdbuf->va + offset, &info->entry[3], mem_entries << 4);
+		data = (u64)sdbuf->pa + offset;
 	} else {
 		data = 0;
 	}
diff --git a/drivers/infiniband/hw/i40iw/i40iw_d.h b/drivers/infiniband/hw/i40iw/i40iw_d.h
index 65ec39e..1077b78 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_d.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_d.h
@@ -1526,7 +1526,7 @@ enum i40iw_alignment {
 	I40IW_AEQ_ALIGNMENT =		0x100,
 	I40IW_CEQ_ALIGNMENT =		0x100,
 	I40IW_CQ0_ALIGNMENT =		0x100,
-	I40IW_SD_BUF_ALIGNMENT =	0x100
+	I40IW_SD_BUF_ALIGNMENT =	0x80
 };
 
 #define I40IW_WQE_SIZE_64	64
@@ -1534,6 +1534,8 @@ enum i40iw_alignment {
 #define I40IW_QP_WQE_MIN_SIZE	32
 #define I40IW_QP_WQE_MAX_SIZE	128
 
+#define I40IW_UPDATE_SD_BUF_SIZE 128
+
 #define I40IW_CQE_QTYPE_RQ 0
 #define I40IW_CQE_QTYPE_SQ 1
 
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
