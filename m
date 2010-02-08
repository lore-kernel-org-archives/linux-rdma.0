From: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] ib_core: fix and clean ib_ud_header_init()
Date: Mon, 8 Feb 2010 13:40:37 +0200
Message-ID: <20100208114037.GA12810@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ib_ud_header_init() first clears header and then fills up the various fields.
Later on it references header->immediate_present which it has cleared so the
condition is also false. Fix this by adding an immediate_present field and set
it into header->immediate_present as is the case with grh_present.
Also remove unused calculation of header_len.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/core/ud_header.c    |   14 ++++----------
 drivers/infiniband/hw/mlx4/qp.c        |    3 ++-
 drivers/infiniband/hw/mthca/mthca_qp.c |    1 +
 include/rdma/ib_pack.h                 |    1 +
 4 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/ud_header.c b/drivers/infiniband/core/ud_header.c
index 8ec7876..650b501 100644
--- a/drivers/infiniband/core/ud_header.c
+++ b/drivers/infiniband/core/ud_header.c
@@ -181,6 +181,7 @@ static const struct ib_field deth_table[] = {
  * ib_ud_header_init - Initialize UD header structure
  * @payload_bytes:Length of packet payload
  * @grh_present:GRH flag (if non-zero, GRH will be included)
+ * @immediate_present: specify if immediate data should be used
  * @header:Structure to initialize
  *
  * ib_ud_header_init() initializes the lrh.link_version, lrh.link_next_header,
@@ -191,21 +192,13 @@ static const struct ib_field deth_table[] = {
  */
 void ib_ud_header_init(int     		    payload_bytes,
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
-	}
-
 	header->lrh.link_version     = 0;
 	header->lrh.link_next_header =
 		grh_present ? IB_LNH_IBA_GLOBAL : IB_LNH_IBA_LOCAL;
@@ -231,7 +224,8 @@ void ib_ud_header_init(int     		    payload_bytes,
 
 	header->lrh.packet_length = cpu_to_be16(packet_length);
 
-	if (header->immediate_present)
+	header->immediate_present	     = immediate_present;
+	if (immediate_present)
 		header->bth.opcode           = IB_OPCODE_UD_SEND_ONLY_WITH_IMMEDIATE;
 	else
 		header->bth.opcode           = IB_OPCODE_UD_SEND_ONLY;
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index b377671..e998511 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1228,7 +1228,8 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 	for (i = 0; i < wr->num_sge; ++i)
 		send_size += wr->sg_list[i].length;
 
-	ib_ud_header_init(send_size, mlx4_ib_ah_grh_present(ah), &sqp->ud_header);
+	ib_ud_header_init(send_size, mlx4_ib_ah_grh_present(ah), 0,
+			  &sqp->ud_header);
 
 	sqp->ud_header.lrh.service_level   =
 		be32_to_cpu(ah->av.sl_tclass_flowlabel) >> 28;
diff --git a/drivers/infiniband/hw/mthca/mthca_qp.c b/drivers/infiniband/hw/mthca/mthca_qp.c
index c10576f..a6d49f0 100644
--- a/drivers/infiniband/hw/mthca/mthca_qp.c
+++ b/drivers/infiniband/hw/mthca/mthca_qp.c
@@ -1495,6 +1495,7 @@ static int build_mlx_header(struct mthca_dev *dev, struct mthca_sqp *sqp,
 
 	ib_ud_header_init(256, /* assume a MAD */
 			  mthca_ah_grh_present(to_mah(wr->wr.ud.ah)),
+			  0,
 			  &sqp->ud_header);
 
 	err = mthca_read_ah(dev, to_mah(wr->wr.ud.ah), &sqp->ud_header);
diff --git a/include/rdma/ib_pack.h b/include/rdma/ib_pack.h
index d7fc45c..cbb50f4 100644
--- a/include/rdma/ib_pack.h
+++ b/include/rdma/ib_pack.h
@@ -232,6 +232,7 @@ void ib_unpack(const struct ib_field        *desc,
 
 void ib_ud_header_init(int     		   payload_bytes,
 		       int    		   grh_present,
+		       int		   immediate_present,
 		       struct ib_ud_header *header);
 
 int ib_ud_header_pack(struct ib_ud_header *header,
-- 
1.6.6.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
