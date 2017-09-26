From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 02/12] IB/hfi1: Convert the macro AHG_HEADER_SET
 into an inline function
Date: Tue, 26 Sep 2017 07:00:11 -0700
Message-ID: <20170926140009.15601.38666.stgit@scvm10.sc.intel.com>
References: <20170926135843.15601.95865.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170926135843.15601.95865.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

AHG_HEADER_SET macro doesn't conform to the coding standards as it can
affect the control flow. Convert the macro AHG_HEADER_SET into an inline
function ahg_header_set().

Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/user_sdma.c |   58 ++++++++++++++++++++++----------
 drivers/infiniband/hw/hfi1/user_sdma.h |   29 +++++++++++-----
 2 files changed, 59 insertions(+), 28 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index c0c0e04..4ea29ed 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -1254,20 +1254,25 @@ static int set_txreq_header_ahg(struct user_sdma_request *req,
 				struct user_sdma_txreq *tx, u32 datalen)
 {
 	u32 ahg[AHG_KDETH_ARRAY_SIZE];
-	int diff = 0;
+	int idx = 0;
 	u8 omfactor; /* KDETH.OM */
 	struct hfi1_user_sdma_pkt_q *pq = req->pq;
 	struct hfi1_pkt_header *hdr = &req->hdr;
 	u16 pbclen = le16_to_cpu(hdr->pbc[0]);
 	u32 val32, tidval = 0, lrhlen = get_lrh_len(*hdr, pad_len(datalen));
+	size_t array_size = ARRAY_SIZE(ahg);
 
 	if (PBC2LRH(pbclen) != lrhlen) {
 		/* PBC.PbcLengthDWs */
-		AHG_HEADER_SET(ahg, diff, 0, 0, 12,
-			       cpu_to_le16(LRH2PBC(lrhlen)));
+		idx = ahg_header_set(ahg, idx, array_size, 0, 0, 12,
+				     (__force u16)cpu_to_le16(LRH2PBC(lrhlen)));
+		if (idx < 0)
+			return idx;
 		/* LRH.PktLen (we need the full 16 bits due to byte swap) */
-		AHG_HEADER_SET(ahg, diff, 3, 0, 16,
-			       cpu_to_be16(lrhlen >> 2));
+		idx = ahg_header_set(ahg, idx, array_size, 3, 0, 16,
+				     (__force u16)cpu_to_be16(lrhlen >> 2));
+		if (idx < 0)
+			return idx;
 	}
 
 	/*
@@ -1278,12 +1283,23 @@ static int set_txreq_header_ahg(struct user_sdma_request *req,
 		(HFI1_CAP_IS_KSET(EXTENDED_PSN) ? 0x7fffffff : 0xffffff);
 	if (unlikely(tx->flags & TXREQ_FLAGS_REQ_ACK))
 		val32 |= 1UL << 31;
-	AHG_HEADER_SET(ahg, diff, 6, 0, 16, cpu_to_be16(val32 >> 16));
-	AHG_HEADER_SET(ahg, diff, 6, 16, 16, cpu_to_be16(val32 & 0xffff));
+	idx = ahg_header_set(ahg, idx, array_size, 6, 0, 16,
+			     (__force u16)cpu_to_be16(val32 >> 16));
+	if (idx < 0)
+		return idx;
+	idx = ahg_header_set(ahg, idx, array_size, 6, 16, 16,
+			     (__force u16)cpu_to_be16(val32 & 0xffff));
+	if (idx < 0)
+		return idx;
 	/* KDETH.Offset */
-	AHG_HEADER_SET(ahg, diff, 15, 0, 16,
-		       cpu_to_le16(req->koffset & 0xffff));
-	AHG_HEADER_SET(ahg, diff, 15, 16, 16, cpu_to_le16(req->koffset >> 16));
+	idx = ahg_header_set(ahg, idx, array_size, 15, 0, 16,
+			     (__force u16)cpu_to_le16(req->koffset & 0xffff));
+	if (idx < 0)
+		return idx;
+	idx = ahg_header_set(ahg, idx, array_size, 15, 16, 16,
+			     (__force u16)cpu_to_le16(req->koffset >> 16));
+	if (idx < 0)
+		return idx;
 	if (req_opcode(req->info.ctrl) == EXPECTED) {
 		__le16 val;
 
@@ -1310,10 +1326,13 @@ static int set_txreq_header_ahg(struct user_sdma_request *req,
 				 KDETH_OM_MAX_SIZE) ? KDETH_OM_LARGE_SHIFT :
 				 KDETH_OM_SMALL_SHIFT;
 		/* KDETH.OM and KDETH.OFFSET (TID) */
-		AHG_HEADER_SET(ahg, diff, 7, 0, 16,
-			       ((!!(omfactor - KDETH_OM_SMALL_SHIFT)) << 15 |
+		idx = ahg_header_set(
+				ahg, idx, array_size, 7, 0, 16,
+				((!!(omfactor - KDETH_OM_SMALL_SHIFT)) << 15 |
 				((req->tidoffset >> omfactor)
-				 & 0x7fff)));
+				& 0x7fff)));
+		if (idx < 0)
+			return idx;
 		/* KDETH.TIDCtrl, KDETH.TID, KDETH.Intr, KDETH.SH */
 		val = cpu_to_le16(((EXP_TID_GET(tidval, CTRL) & 0x3) << 10) |
 				   (EXP_TID_GET(tidval, IDX) & 0x3ff));
@@ -1330,21 +1349,22 @@ static int set_txreq_header_ahg(struct user_sdma_request *req,
 					     AHG_KDETH_INTR_SHIFT));
 		}
 
-		AHG_HEADER_SET(ahg, diff, 7, 16, 14, val);
+		idx = ahg_header_set(ahg, idx, array_size,
+				     7, 16, 14, (__force u16)val);
+		if (idx < 0)
+			return idx;
 	}
-	if (diff < 0)
-		return diff;
 
 	trace_hfi1_sdma_user_header_ahg(pq->dd, pq->ctxt, pq->subctxt,
 					req->info.comp_idx, req->sde->this_idx,
-					req->ahg_idx, ahg, diff, tidval);
+					req->ahg_idx, ahg, idx, tidval);
 	sdma_txinit_ahg(&tx->txreq,
 			SDMA_TXREQ_F_USE_AHG,
-			datalen, req->ahg_idx, diff,
+			datalen, req->ahg_idx, idx,
 			ahg, sizeof(req->hdr),
 			user_sdma_txreq_cb);
 
-	return diff;
+	return idx;
 }
 
 /*
diff --git a/drivers/infiniband/hw/hfi1/user_sdma.h b/drivers/infiniband/hw/hfi1/user_sdma.h
index 9b8bb56..a3d1924 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.h
+++ b/drivers/infiniband/hw/hfi1/user_sdma.h
@@ -80,15 +80,26 @@
 #define PBC2LRH(x) ((((x) & 0xfff) << 2) - 4)
 #define LRH2PBC(x) ((((x) >> 2) + 1) & 0xfff)
 
-#define AHG_HEADER_SET(arr, idx, dw, bit, width, value)			\
-	do {								\
-		if ((idx) < ARRAY_SIZE((arr)))				\
-			(arr)[(idx++)] = sdma_build_ahg_descriptor(	\
-				(__force u16)(value), (dw), (bit),	\
-							(width));	\
-		else							\
-			return -ERANGE;					\
-	} while (0)
+/**
+ * Build an SDMA AHG header update descriptor and save it to an array.
+ * @arr        - Array to save the descriptor to.
+ * @idx        - Index of the array at which the descriptor will be saved.
+ * @array_size - Size of the array arr.
+ * @dw         - Update index into the header in DWs.
+ * @bit        - Start bit.
+ * @width      - Field width.
+ * @value      - 16 bits of immediate data to write into the field.
+ * Returns -ERANGE if idx is invalid. If successful, returns the next index
+ * (idx + 1) of the array to be used for the next descriptor.
+ */
+static inline int ahg_header_set(u32 *arr, int idx, size_t array_size,
+				 u8 dw, u8 bit, u8 width, u16 value)
+{
+	if ((size_t)idx >= array_size)
+		return -ERANGE;
+	arr[idx++] = sdma_build_ahg_descriptor(value, dw, bit, width);
+	return idx;
+}
 
 /* Tx request flag bits */
 #define TXREQ_FLAGS_REQ_ACK   BIT(0)      /* Set the ACK bit in the header */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
