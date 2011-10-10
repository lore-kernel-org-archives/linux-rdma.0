From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 5/5] ib/mlx4: added support for extended PMA counters under
 IBoE
Date: Mon, 10 Oct 2011 10:57:25 +0200
Message-ID: <alpine.LRH.2.00.1110101056510.11243@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1110101047420.10901@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1110101047420.10901-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

With the HW counters being 64bit ones, use the existing IBoE
PMA counters to support also extended counters.

Signed-off-by: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mad.c |   49 ++++++++++++++++++++++++++++++++-----
 1 files changed, 42 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index f36da99..7ccc9a0 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -303,13 +303,44 @@ static int ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 	return IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_REPLY;
 }

-static void edit_counter(struct mlx4_counter *cnt,
-					struct ib_pma_portcounters *pma_cnt)
+static int pma_get_classportinfo(struct ib_mad *out_mad)
 {
-	pma_cnt->port_xmit_data = cpu_to_be32((be64_to_cpu(cnt->tx_bytes)>>2));
-	pma_cnt->port_rcv_data  = cpu_to_be32((be64_to_cpu(cnt->rx_bytes)>>2));
-	pma_cnt->port_xmit_packets = cpu_to_be32(be64_to_cpu(cnt->tx_frames));
-	pma_cnt->port_rcv_packets  = cpu_to_be32(be64_to_cpu(cnt->rx_frames));
+	struct ib_class_port_info *cpi =
+		(struct ib_class_port_info *)(out_mad->data + 40);
+
+	memset(cpi, 0, sizeof(cpi));
+
+	cpi->capability_mask = IB_PMA_CLASS_CAP_EXT_WIDTH_NOIETF ;
+
+	return IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_REPLY;
+}
+
+static void edit_counter(struct mlx4_counter *cnt, void *counters,
+			 __be16	attr_id)
+{
+	if (attr_id == IB_PMA_PORT_COUNTERS) {
+		struct ib_pma_portcounters *pma_cnt =
+				(struct ib_pma_portcounters *) counters;
+
+		pma_cnt->port_xmit_data =
+			cpu_to_be32((be64_to_cpu(cnt->tx_bytes)>>2));
+		pma_cnt->port_rcv_data  =
+			cpu_to_be32((be64_to_cpu(cnt->rx_bytes)>>2));
+		pma_cnt->port_xmit_packets =
+			cpu_to_be32(be64_to_cpu(cnt->tx_frames));
+		pma_cnt->port_rcv_packets  =
+			cpu_to_be32(be64_to_cpu(cnt->rx_frames));
+	} else {
+		struct ib_pma_portcounters_ext *pma_cnt_ext =
+				(struct ib_pma_portcounters_ext *) counters;
+
+		pma_cnt_ext->port_xmit_data =
+			cpu_to_be64((be64_to_cpu(cnt->tx_bytes)>>2));
+		pma_cnt_ext->port_rcv_data  =
+			cpu_to_be64((be64_to_cpu(cnt->rx_bytes)>>2));
+		pma_cnt_ext->port_xmit_packets = cnt->tx_frames;
+		pma_cnt_ext->port_rcv_packets  = cnt->rx_frames;
+	}
 }

 static int iboe_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
@@ -325,6 +356,9 @@ static int iboe_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 	if (in_mad->mad_hdr.mgmt_class != IB_MGMT_CLASS_PERF_MGMT)
 		return -EINVAL;

+	if (in_mad->mad_hdr.attr_id == IB_PMA_CLASS_PORT_INFO)
+		return pma_get_classportinfo(out_mad);
+
 	mailbox = mlx4_alloc_cmd_mailbox(dev->dev);
 	if (IS_ERR(mailbox))
 		return IB_MAD_RESULT_FAILURE;
@@ -339,7 +373,8 @@ static int iboe_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 		switch (mode & 0xf) {
 		case 0:
 			edit_counter(mailbox->buf,
-						(void *)(out_mad->data + 40));
+				     (void *)(out_mad->data + 40),
+				     in_mad->mad_hdr.attr_id);
 			err = IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_REPLY;
 			break;
 		default:
-- 
1.7.4.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
