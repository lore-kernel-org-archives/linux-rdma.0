From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 05/23] IB/hfi1: Disable header suppression for short packets
Date: Wed, 07 Dec 2016 19:32:41 -0800
Message-ID: <20161208033239.21135.14349.stgit@scvm10.sc.intel.com>
References: <20161208032312.21135.66056.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161208032312.21135.66056.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Pawlak <jakub.pawlak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jakub Pawlak <jakub.pawlak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

For the received packets with payload less or equal 8DWS
RxDmaDataFifoRdUncErr is not reported. There is set RHF.EccErr
if the header is not suppressed. When such packet is detected
on the send side the header suppression mechanism is disabled
by clearing SH bit in the packet header.

Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jakub Pawlak <jakub.pawlak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/user_sdma.c |   60 +++++++++++++++++++++++---------
 include/uapi/rdma/hfi/hfi1_user.h      |    2 +
 2 files changed, 44 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 77697d6..7d22f8e 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -115,6 +115,7 @@
 #define KDETH_HCRC_LOWER_MASK     0xff
 
 #define AHG_KDETH_INTR_SHIFT 12
+#define AHG_KDETH_SH_SHIFT   13
 
 #define PBC2LRH(x) ((((x) & 0xfff) << 2) - 4)
 #define LRH2PBC(x) ((((x) >> 2) + 1) & 0xfff)
@@ -144,8 +145,9 @@
 #define KDETH_OM_LARGE     64
 #define KDETH_OM_MAX_SIZE  (1 << ((KDETH_OM_LARGE / KDETH_OM_SMALL) + 1))
 
-/* Last packet in the request */
-#define TXREQ_FLAGS_REQ_LAST_PKT BIT(0)
+/* Tx request flag bits */
+#define TXREQ_FLAGS_REQ_ACK   BIT(0)      /* Set the ACK bit in the header */
+#define TXREQ_FLAGS_REQ_DISABLE_SH BIT(1) /* Disable header suppression */
 
 /* SDMA request flag bits */
 #define SDMA_REQ_FOR_THREAD 1
@@ -943,8 +945,13 @@ static int user_sdma_send_pkts(struct user_sdma_request *req, unsigned maxpkts)
 		tx->busycount = 0;
 		INIT_LIST_HEAD(&tx->list);
 
+		/*
+		 * For the last packet set the ACK request
+		 * and disable header suppression.
+		 */
 		if (req->seqnum == req->info.npkts - 1)
-			tx->flags |= TXREQ_FLAGS_REQ_LAST_PKT;
+			tx->flags |= (TXREQ_FLAGS_REQ_ACK |
+				      TXREQ_FLAGS_REQ_DISABLE_SH);
 
 		/*
 		 * Calculate the payload size - this is min of the fragment
@@ -963,11 +970,22 @@ static int user_sdma_send_pkts(struct user_sdma_request *req, unsigned maxpkts)
 			}
 
 			datalen = compute_data_length(req, tx);
+
+			/*
+			 * Disable header suppression for the payload <= 8DWS.
+			 * If there is an uncorrectable error in the receive
+			 * data FIFO when the received payload size is less than
+			 * or equal to 8DWS then the RxDmaDataFifoRdUncErr is
+			 * not reported.There is set RHF.EccErr if the header
+			 * is not suppressed.
+			 */
 			if (!datalen) {
 				SDMA_DBG(req,
 					 "Request has data but pkt len is 0");
 				ret = -EFAULT;
 				goto free_tx;
+			} else if (datalen <= 32) {
+				tx->flags |= TXREQ_FLAGS_REQ_DISABLE_SH;
 			}
 		}
 
@@ -990,6 +1008,10 @@ static int user_sdma_send_pkts(struct user_sdma_request *req, unsigned maxpkts)
 						LRH2PBC(lrhlen);
 					tx->hdr.pbc[0] = cpu_to_le16(pbclen);
 				}
+				ret = check_header_template(req, &tx->hdr,
+							    lrhlen, datalen);
+				if (ret)
+					goto free_tx;
 				ret = sdma_txinit_ahg(&tx->txreq,
 						      SDMA_TXREQ_F_AHG_COPY,
 						      sizeof(tx->hdr) + datalen,
@@ -1351,7 +1373,7 @@ static int set_txreq_header(struct user_sdma_request *req,
 				req->seqnum));
 
 	/* Set ACK request on last packet */
-	if (unlikely(tx->flags & TXREQ_FLAGS_REQ_LAST_PKT))
+	if (unlikely(tx->flags & TXREQ_FLAGS_REQ_ACK))
 		hdr->bth[2] |= cpu_to_be32(1UL << 31);
 
 	/* Set the new offset */
@@ -1384,8 +1406,8 @@ static int set_txreq_header(struct user_sdma_request *req,
 		/* Set KDETH.TID based on value for this TID */
 		KDETH_SET(hdr->kdeth.ver_tid_offset, TID,
 			  EXP_TID_GET(tidval, IDX));
-		/* Clear KDETH.SH only on the last packet */
-		if (unlikely(tx->flags & TXREQ_FLAGS_REQ_LAST_PKT))
+		/* Clear KDETH.SH when DISABLE_SH flag is set */
+		if (unlikely(tx->flags & TXREQ_FLAGS_REQ_DISABLE_SH))
 			KDETH_SET(hdr->kdeth.ver_tid_offset, SH, 0);
 		/*
 		 * Set the KDETH.OFFSET and KDETH.OM based on size of
@@ -1429,7 +1451,7 @@ static int set_txreq_header_ahg(struct user_sdma_request *req,
 	/* BTH.PSN and BTH.A */
 	val32 = (be32_to_cpu(hdr->bth[2]) + req->seqnum) &
 		(HFI1_CAP_IS_KSET(EXTENDED_PSN) ? 0x7fffffff : 0xffffff);
-	if (unlikely(tx->flags & TXREQ_FLAGS_REQ_LAST_PKT))
+	if (unlikely(tx->flags & TXREQ_FLAGS_REQ_ACK))
 		val32 |= 1UL << 31;
 	AHG_HEADER_SET(req->ahg, diff, 6, 0, 16, cpu_to_be16(val32 >> 16));
 	AHG_HEADER_SET(req->ahg, diff, 6, 16, 16, cpu_to_be16(val32 & 0xffff));
@@ -1468,19 +1490,23 @@ static int set_txreq_header_ahg(struct user_sdma_request *req,
 		AHG_HEADER_SET(req->ahg, diff, 7, 0, 16,
 			       ((!!(req->omfactor - KDETH_OM_SMALL)) << 15 |
 				((req->tidoffset / req->omfactor) & 0x7fff)));
-		/* KDETH.TIDCtrl, KDETH.TID */
+		/* KDETH.TIDCtrl, KDETH.TID, KDETH.Intr, KDETH.SH */
 		val = cpu_to_le16(((EXP_TID_GET(tidval, CTRL) & 0x3) << 10) |
-					(EXP_TID_GET(tidval, IDX) & 0x3ff));
-		/* Clear KDETH.SH on last packet */
-		if (unlikely(tx->flags & TXREQ_FLAGS_REQ_LAST_PKT)) {
-			val |= cpu_to_le16(KDETH_GET(hdr->kdeth.ver_tid_offset,
-						     INTR) <<
-					   AHG_KDETH_INTR_SHIFT);
-			val &= cpu_to_le16(~(1U << 13));
-			AHG_HEADER_SET(req->ahg, diff, 7, 16, 14, val);
+				   (EXP_TID_GET(tidval, IDX) & 0x3ff));
+
+		if (unlikely(tx->flags & TXREQ_FLAGS_REQ_DISABLE_SH)) {
+			val |= cpu_to_le16((KDETH_GET(hdr->kdeth.ver_tid_offset,
+						      INTR) <<
+					    AHG_KDETH_INTR_SHIFT));
 		} else {
-			AHG_HEADER_SET(req->ahg, diff, 7, 16, 12, val);
+			val |= KDETH_GET(hdr->kdeth.ver_tid_offset, SH) ?
+			       cpu_to_le16(0x1 << AHG_KDETH_SH_SHIFT) :
+			       cpu_to_le16((KDETH_GET(hdr->kdeth.ver_tid_offset,
+						      INTR) <<
+					     AHG_KDETH_INTR_SHIFT));
 		}
+
+		AHG_HEADER_SET(req->ahg, diff, 7, 16, 14, val);
 	}
 
 	trace_hfi1_sdma_user_header_ahg(pq->dd, pq->ctxt, pq->subctxt,
diff --git a/include/uapi/rdma/hfi/hfi1_user.h b/include/uapi/rdma/hfi/hfi1_user.h
index d15e728..587b736 100644
--- a/include/uapi/rdma/hfi/hfi1_user.h
+++ b/include/uapi/rdma/hfi/hfi1_user.h
@@ -75,7 +75,7 @@
  * may not be implemented; the user code must deal with this if it
  * cares, or it must abort after initialization reports the difference.
  */
-#define HFI1_USER_SWMINOR 2
+#define HFI1_USER_SWMINOR 3
 
 /*
  * We will encode the major/minor inside a single 32bit version number.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
