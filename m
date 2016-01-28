From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: [PATCH 1/4] RDMA/ocrdma: Export udp encapsulation capability
Date: Thu, 28 Jan 2016 08:59:56 -0500
Message-ID: <1453989599-21307-2-git-send-email-devesh.sharma@avagotech.com>
References: <1453989599-21307-1-git-send-email-devesh.sharma@avagotech.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453989599-21307-1-git-send-email-devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Somnath Kotur <somnath.kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Somnath Kotur <somnath.kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>

Add support to read device configuration and initialize port-immutables
to report UDP-Encap flag during port query.

Signed-off-by: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h      | 7 +++++++
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c   | 3 +++
 drivers/infiniband/hw/ocrdma/ocrdma_main.c | 4 ++++
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h  | 9 +++++++--
 4 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index 040bb8b..3ef0b52 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -114,6 +114,7 @@ struct ocrdma_dev_attr {
 	u8 local_ca_ack_delay;
 	u8 ird;
 	u8 num_ird_pages;
+	u8 udp_encap;
 };
 
 struct ocrdma_dma_mem {
@@ -601,4 +602,10 @@ static inline u8 ocrdma_get_ae_link_state(u32 ae_state)
 	return ((ae_state & OCRDMA_AE_LSC_LS_MASK) >> OCRDMA_AE_LSC_LS_SHIFT);
 }
 
+static inline bool ocrdma_is_udp_encap_supported(struct ocrdma_dev *dev)
+{
+	return (dev->attr.udp_encap & OCRDMA_L3_TYPE_IPV4) ||
+	       (dev->attr.udp_encap & OCRDMA_L3_TYPE_IPV6);
+}
+
 #endif
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 283ca84..aea7f17 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -1144,6 +1144,9 @@ static void ocrdma_get_attr(struct ocrdma_dev *dev,
 	attr->max_pd =
 	    (rsp->max_pd_ca_ack_delay & OCRDMA_MBX_QUERY_CFG_MAX_PD_MASK) >>
 	    OCRDMA_MBX_QUERY_CFG_MAX_PD_SHIFT;
+	attr->udp_encap = (rsp->max_pd_ca_ack_delay &
+			   OCRDMA_MBX_QUERY_CFG_L3_TYPE_MASK) >>
+			   OCRDMA_MBX_QUERY_CFG_L3_TYPE_SHIFT;
 	attr->max_dpp_pds =
 	   (rsp->max_dpp_pds_credits & OCRDMA_MBX_QUERY_CFG_MAX_DPP_PDS_MASK) >>
 	    OCRDMA_MBX_QUERY_CFG_MAX_DPP_PDS_OFFSET;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 5738493..f1f610b 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -89,8 +89,10 @@ static int ocrdma_port_immutable(struct ib_device *ibdev, u8 port_num,
 			         struct ib_port_immutable *immutable)
 {
 	struct ib_port_attr attr;
+	struct ocrdma_dev *dev;
 	int err;
 
+	dev = get_ocrdma_dev(ibdev);
 	err = ocrdma_query_port(ibdev, port_num, &attr);
 	if (err)
 		return err;
@@ -98,6 +100,8 @@ static int ocrdma_port_immutable(struct ib_device *ibdev, u8 port_num,
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
 	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_ROCE;
+	if (ocrdma_is_udp_encap_supported(dev))
+		immutable->core_cap_flags |= RDMA_CORE_CAP_PROT_ROCE_UDP_ENCAP;
 	immutable->max_mad_size = IB_MGMT_MAD_SIZE;
 
 	return 0;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
index 99dd6fd..8d75bd4 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
@@ -140,7 +140,11 @@ enum {
 	OCRDMA_DB_RQ_SHIFT		= 24
 };
 
-#define OCRDMA_ROUDP_FLAGS_SHIFT	0x03
+enum {
+	OCRDMA_L3_TYPE_IB_GRH   = 0x00,
+	OCRDMA_L3_TYPE_IPV4     = 0x01,
+	OCRDMA_L3_TYPE_IPV6     = 0x02
+};
 
 #define OCRDMA_DB_CQ_RING_ID_MASK       0x3FF	/* bits 0 - 9 */
 #define OCRDMA_DB_CQ_RING_ID_EXT_MASK  0x0C00	/* bits 10-11 of qid at 12-11 */
@@ -546,7 +550,8 @@ enum {
 	OCRDMA_MBX_QUERY_CFG_CA_ACK_DELAY_SHIFT		= 8,
 	OCRDMA_MBX_QUERY_CFG_CA_ACK_DELAY_MASK		= 0xFF <<
 				OCRDMA_MBX_QUERY_CFG_CA_ACK_DELAY_SHIFT,
-
+	OCRDMA_MBX_QUERY_CFG_L3_TYPE_SHIFT		= 3,
+	OCRDMA_MBX_QUERY_CFG_L3_TYPE_MASK		= 0x18,
 	OCRDMA_MBX_QUERY_CFG_MAX_SEND_SGE_SHIFT		= 0,
 	OCRDMA_MBX_QUERY_CFG_MAX_SEND_SGE_MASK		= 0xFFFF,
 	OCRDMA_MBX_QUERY_CFG_MAX_WRITE_SGE_SHIFT	= 16,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
