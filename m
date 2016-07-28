From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/hfi1: Allow for non-double word multiple message sizes for user SDMA
Date: Wed, 27 Jul 2016 21:08:42 -0400
Message-ID: <20160728010842.GC3158@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


The driver pads non-double word multiple message sizes but it doesn't
account for this padding when the packet length is calculated. Also, the
data length is miscalculated for message sizes less than 4 bytes due to
the bit representation in LRH. And there's a check for non-double word
multiple message sizes that prevents these messages from being sent.
This patch fixes length miscalculations and enables the functionality to
send non-double word multiple message sizes.

Reviewed-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/user_sdma.c | 31 ++++++++++++++++++++++---------
 include/uapi/rdma/hfi/hfi1_user.h      |  2 +-
 2 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index d16ed52a2cb1..1e266c95056a 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -793,14 +793,21 @@ static inline u32 compute_data_length(struct user_sdma_request *req,
 	 * The size of the data of the first packet is in the header
 	 * template. However, it includes the header and ICRC, which need
 	 * to be subtracted.
+	 * The minimum representable packet data length in a header is 4 bytes,
+	 * therefore, when the data length request is less than 4 bytes, there's
+	 * only one packet, and the packet data length is equal to that of the
+	 * request data length.
 	 * The size of the remaining packets is the minimum of the frag
 	 * size (MTU) or remaining data in the request.
 	 */
 	u32 len;
 
 	if (!req->seqnum) {
-		len = ((be16_to_cpu(req->hdr.lrh[2]) << 2) -
-		       (sizeof(tx->hdr) - 4));
+		if (req->data_len < sizeof(u32))
+			len = req->data_len;
+		else
+			len = ((be16_to_cpu(req->hdr.lrh[2]) << 2) -
+			       (sizeof(tx->hdr) - 4));
 	} else if (req_opcode(req->info.ctrl) == EXPECTED) {
 		u32 tidlen = EXP_TID_GET(req->tids[req->tididx], LEN) *
 			PAGE_SIZE;
@@ -830,6 +837,13 @@ static inline u32 compute_data_length(struct user_sdma_request *req,
 	return len;
 }
 
+static inline u32 pad_len(u32 len)
+{
+	if (len & (sizeof(u32) - 1))
+		len += sizeof(u32) - (len & (sizeof(u32) - 1));
+	return len;
+}
+
 static inline u32 get_lrh_len(struct hfi1_pkt_header hdr, u32 len)
 {
 	/* (Size of complete header - size of PBC) + 4B ICRC + data length */
@@ -921,7 +935,8 @@ static int user_sdma_send_pkts(struct user_sdma_request *req, unsigned maxpkts)
 		if (test_bit(SDMA_REQ_HAVE_AHG, &req->flags)) {
 			if (!req->seqnum) {
 				u16 pbclen = le16_to_cpu(req->hdr.pbc[0]);
-				u32 lrhlen = get_lrh_len(req->hdr, datalen);
+				u32 lrhlen = get_lrh_len(req->hdr,
+							 pad_len(datalen));
 				/*
 				 * Copy the request header into the tx header
 				 * because the HW needs a cacheline-aligned
@@ -1219,16 +1234,14 @@ static int check_header_template(struct user_sdma_request *req,
 	/*
 	 * Perform safety checks for any type of packet:
 	 *    - transfer size is multiple of 64bytes
-	 *    - packet length is multiple of 4bytes
-	 *    - entire request length is multiple of 4bytes
+	 *    - packet length is multiple of 4 bytes
 	 *    - packet length is not larger than MTU size
 	 *
 	 * These checks are only done for the first packet of the
 	 * transfer since the header is "given" to us by user space.
 	 * For the remainder of the packets we compute the values.
 	 */
-	if (req->info.fragsize % PIO_BLOCK_SIZE ||
-	    lrhlen & 0x3 || req->data_len & 0x3  ||
+	if (req->info.fragsize % PIO_BLOCK_SIZE || lrhlen & 0x3 ||
 	    lrhlen > get_lrh_len(*hdr, req->info.fragsize))
 		return -EINVAL;
 
@@ -1290,7 +1303,7 @@ static int set_txreq_header(struct user_sdma_request *req,
 	struct hfi1_pkt_header *hdr = &tx->hdr;
 	u16 pbclen;
 	int ret;
-	u32 tidval = 0, lrhlen = get_lrh_len(*hdr, datalen);
+	u32 tidval = 0, lrhlen = get_lrh_len(*hdr, pad_len(datalen));
 
 	/* Copy the header template to the request before modification */
 	memcpy(hdr, &req->hdr, sizeof(*hdr));
@@ -1401,7 +1414,7 @@ static int set_txreq_header_ahg(struct user_sdma_request *req,
 	struct hfi1_user_sdma_pkt_q *pq = req->pq;
 	struct hfi1_pkt_header *hdr = &req->hdr;
 	u16 pbclen = le16_to_cpu(hdr->pbc[0]);
-	u32 val32, tidval = 0, lrhlen = get_lrh_len(*hdr, len);
+	u32 val32, tidval = 0, lrhlen = get_lrh_len(*hdr, pad_len(len));
 
 	if (PBC2LRH(pbclen) != lrhlen) {
 		/* PBC.PbcLengthDWs */
diff --git a/include/uapi/rdma/hfi/hfi1_user.h b/include/uapi/rdma/hfi/hfi1_user.h
index 98bebf8bef55..d15e7289d835 100644
--- a/include/uapi/rdma/hfi/hfi1_user.h
+++ b/include/uapi/rdma/hfi/hfi1_user.h
@@ -75,7 +75,7 @@
  * may not be implemented; the user code must deal with this if it
  * cares, or it must abort after initialization reports the difference.
  */
-#define HFI1_USER_SWMINOR 1
+#define HFI1_USER_SWMINOR 2
 
 /*
  * We will encode the major/minor inside a single 32bit version number.
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
