From: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCHv8 05/11] ib_core: IBoE UD packet packing support
Date: Thu, 18 Feb 2010 19:24:11 +0200
Message-ID: <20100218172411.GF12286@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add support functions to aid in packing IBoE packets.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/core/ud_header.c |  100 ++++++++++++++++++++++------------
 include/rdma/ib_pack.h              |   29 +++++++++-
 2 files changed, 92 insertions(+), 37 deletions(-)

Changes from v7:

1. Re-work the changes so they extend the original idea behind these functions.
2. Fix wrong implementation of ib_ud_header_init(). A different patch was sent
   to Roland.


diff --git a/drivers/infiniband/core/ud_header.c b/drivers/infiniband/core/ud_header.c
index 8ec7876..7650313 100644
--- a/drivers/infiniband/core/ud_header.c
+++ b/drivers/infiniband/core/ud_header.c
@@ -80,6 +80,29 @@ static const struct ib_field lrh_table[]  = {
 	  .size_bits    = 16 }
 };
 
+static const struct ib_field eth_table[]  = {
+	{ STRUCT_FIELD(eth, dmac_h),
+	  .offset_words = 0,
+	  .offset_bits  = 0,
+	  .size_bits    = 32 },
+	{ STRUCT_FIELD(eth, dmac_l),
+	  .offset_words = 1,
+	  .offset_bits  = 0,
+	  .size_bits    = 16 },
+	{ STRUCT_FIELD(eth, smac_h),
+	  .offset_words = 1,
+	  .offset_bits  = 16,
+	  .size_bits    = 16 },
+	{ STRUCT_FIELD(eth, smac_l),
+	  .offset_words = 2,
+	  .offset_bits  = 0,
+	  .size_bits    = 32 },
+	{ STRUCT_FIELD(eth, type),
+	  .offset_words = 3,
+	  .offset_bits  = 0,
+	  .size_bits    = 16 }
+};
+
 static const struct ib_field grh_table[]  = {
 	{ STRUCT_FIELD(grh, ip_version),
 	  .offset_words = 0,
@@ -180,56 +203,51 @@ static const struct ib_field deth_table[] = {
 /**
  * ib_ud_header_init - Initialize UD header structure
  * @payload_bytes:Length of packet payload
+ * @lrh_present: specify if LRH is present
+ * @eth_present: specify if Eth header is present
  * @grh_present:GRH flag (if non-zero, GRH will be included)
+ * @immediate_present: specify if immediate data is present
  * @header:Structure to initialize
- *
- * ib_ud_header_init() initializes the lrh.link_version, lrh.link_next_header,
- * lrh.packet_length, grh.ip_version, grh.payload_length,
- * grh.next_header, bth.opcode, bth.pad_count and
- * bth.transport_header_version fields of a &struct ib_ud_header given
- * the payload length and whether a GRH will be included.
  */
 void ib_ud_header_init(int     		    payload_bytes,
+		       int		    lrh_present,
+		       int		    eth_present,
 		       int    		    grh_present,
+		       int		    immediate_present,
 		       struct ib_ud_header *header)
 {
-	int header_len;
 	u16 packet_length;
 
 	memset(header, 0, sizeof *header);
 
-	header_len =
-		IB_LRH_BYTES  +
-		IB_BTH_BYTES  +
-		IB_DETH_BYTES;
-	if (grh_present) {
-		header_len += IB_GRH_BYTES;
+	if (lrh_present) {
+		header->lrh.link_version     = 0;
+		header->lrh.link_next_header =
+			grh_present ? IB_LNH_IBA_GLOBAL : IB_LNH_IBA_LOCAL;
+		packet_length = IB_LRH_BYTES;
 	}
 
-	header->lrh.link_version     = 0;
-	header->lrh.link_next_header =
-		grh_present ? IB_LNH_IBA_GLOBAL : IB_LNH_IBA_LOCAL;
-	packet_length		     = (IB_LRH_BYTES     +
-					IB_BTH_BYTES     +
-					IB_DETH_BYTES    +
-					payload_bytes    +
-					4                + /* ICRC     */
-					3) / 4;            /* round up */
-
-	header->grh_present          = grh_present;
+	if (eth_present)
+		packet_length = IB_ETH_BYTES;
+
+	packet_length += IB_BTH_BYTES + IB_DETH_BYTES + payload_bytes +
+		4       + /* ICRC     */
+		3;        /* round up */
+	packet_length /= 4;
 	if (grh_present) {
-		packet_length		   += IB_GRH_BYTES / 4;
-		header->grh.ip_version      = 6;
-		header->grh.payload_length  =
-			cpu_to_be16((IB_BTH_BYTES     +
-				     IB_DETH_BYTES    +
-				     payload_bytes    +
-				     4                + /* ICRC     */
-				     3) & ~3);          /* round up */
+		packet_length += IB_GRH_BYTES / 4;
+		header->grh.ip_version = 6;
+		header->grh.payload_length =
+			cpu_to_be16((IB_BTH_BYTES  +
+				     IB_DETH_BYTES +
+				     payload_bytes +
+				     4             + /* ICRC     */
+				     3) & ~3);       /* round up */
 		header->grh.next_header     = 0x1b;
 	}
 
-	header->lrh.packet_length = cpu_to_be16(packet_length);
+	if (lrh_present)
+		header->lrh.packet_length = cpu_to_be16(packet_length);
 
 	if (header->immediate_present)
 		header->bth.opcode           = IB_OPCODE_UD_SEND_ONLY_WITH_IMMEDIATE;
@@ -237,6 +255,11 @@ void ib_ud_header_init(int     		    payload_bytes,
 		header->bth.opcode           = IB_OPCODE_UD_SEND_ONLY;
 	header->bth.pad_count                = (4 - payload_bytes) & 3;
 	header->bth.transport_header_version = 0;
+
+	header->lrh_present = lrh_present;
+	header->eth_present = eth_present;
+	header->grh_present = grh_present;
+	header->immediate_present = immediate_present;
 }
 EXPORT_SYMBOL(ib_ud_header_init);
 
@@ -253,9 +276,16 @@ int ib_ud_header_pack(struct ib_ud_header *header,
 {
 	int len = 0;
 
-	ib_pack(lrh_table, ARRAY_SIZE(lrh_table),
-		&header->lrh, buf);
-	len += IB_LRH_BYTES;
+	if (header->lrh_present) {
+		ib_pack(lrh_table, ARRAY_SIZE(lrh_table),
+			&header->lrh, buf + len);
+		len += IB_LRH_BYTES;
+	}
+	if (header->eth_present) {
+		ib_pack(eth_table, ARRAY_SIZE(eth_table),
+			&header->eth, buf + len);
+		len += IB_ETH_BYTES;
+	}
 
 	if (header->grh_present) {
 		ib_pack(grh_table, ARRAY_SIZE(grh_table),
diff --git a/include/rdma/ib_pack.h b/include/rdma/ib_pack.h
index d7fc45c..67a85f3 100644
--- a/include/rdma/ib_pack.h
+++ b/include/rdma/ib_pack.h
@@ -37,6 +37,7 @@
 
 enum {
 	IB_LRH_BYTES  = 8,
+	IB_ETH_BYTES  = 14,
 	IB_GRH_BYTES  = 40,
 	IB_BTH_BYTES  = 12,
 	IB_DETH_BYTES = 8
@@ -210,8 +211,29 @@ struct ib_unpacked_deth {
 	__be32       source_qpn;
 };
 
+struct ib_unpacked_eth {
+	u8	dmac_h[4];
+	u8	dmac_l[2];
+	u8	smac_h[2];
+	u8	smac_l[4];
+	__be16	type;
+};
+
 struct ib_ud_header {
+	int                     lrh_present;
 	struct ib_unpacked_lrh  lrh;
+	int                     eth_present;
+	struct ib_unpacked_eth  eth;
+	int                     grh_present;
+	struct ib_unpacked_grh  grh;
+	struct ib_unpacked_bth  bth;
+	struct ib_unpacked_deth deth;
+	int            		immediate_present;
+	__be32         		immediate_data;
+};
+
+struct eth_ud_header {
+	struct ib_unpacked_eth  eth;
 	int                     grh_present;
 	struct ib_unpacked_grh  grh;
 	struct ib_unpacked_bth  bth;
@@ -230,8 +252,11 @@ void ib_unpack(const struct ib_field        *desc,
 	       void                         *buf,
 	       void                         *structure);
 
-void ib_ud_header_init(int     		   payload_bytes,
-		       int    		   grh_present,
+void ib_ud_header_init(int     		    payload_bytes,
+		       int		    lrh_present,
+		       int		    eth_present,
+		       int    		    grh_present,
+		       int		    immediate_present,
 		       struct ib_ud_header *header);
 
 int ib_ud_header_pack(struct ib_ud_header *header,
-- 
1.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
