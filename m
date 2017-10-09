From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 5/7] IB/hfi1: Eliminate allocation while atomic
Date: Mon, 09 Oct 2017 12:38:19 -0700
Message-ID: <20171009193817.6965.44567.stgit@scvm10.sc.intel.com>
References: <20171009161736.6965.75352.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171009161736.6965.75352.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The PIO trailing buffer was being dynamically allocated
but the kcalloc return value was not being checked. Further,
the GFP_KERNEL was being used even though the send engine
might be called with interrupts disabled.

Since the maximum size of the trailing buffer is only 12
bytes (CRC = 4, LT = 1, Pad = 0 to 7 bytes) just statically
allocate the buffer, remove the alloc entirely and share it
with the SDMA engine by making it global.

Reported-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Fixes: 566d53a82644 ("IB/hfi1: Enhance PIO/SDMA send for 16B")
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/common.h |    1 +
 drivers/infiniband/hw/hfi1/verbs.c  |   22 ++++++++--------------
 2 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/common.h b/drivers/infiniband/hw/hfi1/common.h
index 3e27794..7108d4d 100644
--- a/drivers/infiniband/hw/hfi1/common.h
+++ b/drivers/infiniband/hw/hfi1/common.h
@@ -328,6 +328,7 @@ struct diag_pkt {
 #define SC15_PACKET 0xF
 #define SIZE_OF_CRC 1
 #define SIZE_OF_LT 1
+#define MAX_16B_PADDING 12 /* CRC = 4, LT = 1, Pad = 0 to 7 bytes */
 
 #define LIM_MGMT_P_KEY       0x7FFF
 #define FULL_MGMT_P_KEY      0xFFFF
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index e232f3c..726c064 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -146,6 +146,9 @@ static int pio_wait(struct rvt_qp *qp,
 /* Length of buffer to create verbs txreq cache name */
 #define TXREQ_NAME_LEN 24
 
+/* 16B trailing buffer */
+static const u8 trail_buf[MAX_16B_PADDING];
+
 static uint wss_threshold;
 module_param(wss_threshold, uint, S_IRUGO);
 MODULE_PARM_DESC(wss_threshold, "Percentage (1-100) of LLC to use as a threshold for a cacheless copy");
@@ -814,7 +817,6 @@ static int build_verbs_tx_desc(
 	u16 hdrbytes = tx->hdr_dwords << 2;
 	u32 *hdr;
 	u8 extra_bytes = 0;
-	static char trail_buf[12]; /* CRC = 4, LT = 1, Pad = 0 to 7 bytes */
 
 	if (tx->phdr.hdr.hdr_type) {
 		/*
@@ -869,9 +871,9 @@ static int build_verbs_tx_desc(
 	}
 
 	/* add icrc, lt byte, and padding to flit */
-	if (extra_bytes != 0)
+	if (extra_bytes)
 		ret = sdma_txadd_kvaddr(sde->dd, &tx->txreq,
-					trail_buf, extra_bytes);
+					(void *)trail_buf, extra_bytes);
 
 bail_txadd:
 	return ret;
@@ -1128,18 +1130,10 @@ int hfi1_verbs_send_pio(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 				len -= slen;
 			}
 		}
-		/*
-		 * Bypass packet will need to copy additional
-		 * bytes to accommodate for CRC and LT bytes
-		 */
-		if (extra_bytes) {
-			u8 *empty_buf;
+		/* add icrc, lt byte, and padding to flit */
+		if (extra_bytes)
+			seg_pio_copy_mid(pbuf, trail_buf, extra_bytes);
 
-			empty_buf = kcalloc(extra_bytes, sizeof(u8),
-					    GFP_KERNEL);
-			seg_pio_copy_mid(pbuf, empty_buf, extra_bytes);
-			kfree(empty_buf);
-		}
 		seg_pio_copy_end(pbuf);
 	}
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
