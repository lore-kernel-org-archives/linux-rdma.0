From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH  2/3] IB/mlx4: Add support for extended counters over RoCE ports
Date: Thu, 11 Feb 2016 10:24:43 +0200
Message-ID: <1455179084-4778-3-git-send-email-matanb@mellanox.com>
References: <1455179084-4778-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455179084-4778-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When attribute IB_PMA_PORT_COUNTERS_EXT is set, we now return 64 bit
values for the counters.

Signed-off-by: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mad.c | 50 +++++++++++++++++++++++++++++-----------
 1 file changed, 37 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 870e56b..db37782 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -806,17 +806,39 @@ static int ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 	return IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_REPLY;
 }
 
-static void edit_counter(struct mlx4_counter *cnt,
-					struct ib_pma_portcounters *pma_cnt)
+static void edit_counter(struct mlx4_counter *cnt, void *counters,
+			 __be16 attr_id)
 {
-	ASSIGN_32BIT_COUNTER(pma_cnt->port_xmit_data,
-			     (be64_to_cpu(cnt->tx_bytes) >> 2));
-	ASSIGN_32BIT_COUNTER(pma_cnt->port_rcv_data,
-			     (be64_to_cpu(cnt->rx_bytes) >> 2));
-	ASSIGN_32BIT_COUNTER(pma_cnt->port_xmit_packets,
-			     be64_to_cpu(cnt->tx_frames));
-	ASSIGN_32BIT_COUNTER(pma_cnt->port_rcv_packets,
-			     be64_to_cpu(cnt->rx_frames));
+	switch (attr_id) {
+	case IB_PMA_PORT_COUNTERS:
+	{
+		struct ib_pma_portcounters *pma_cnt =
+			(struct ib_pma_portcounters *)counters;
+
+		ASSIGN_32BIT_COUNTER(pma_cnt->port_xmit_data,
+				     (be64_to_cpu(cnt->tx_bytes) >> 2));
+		ASSIGN_32BIT_COUNTER(pma_cnt->port_rcv_data,
+				     (be64_to_cpu(cnt->rx_bytes) >> 2));
+		ASSIGN_32BIT_COUNTER(pma_cnt->port_xmit_packets,
+				     be64_to_cpu(cnt->tx_frames));
+		ASSIGN_32BIT_COUNTER(pma_cnt->port_rcv_packets,
+				     be64_to_cpu(cnt->rx_frames));
+		break;
+	}
+	case IB_PMA_PORT_COUNTERS_EXT:
+	{
+		struct ib_pma_portcounters_ext *pma_cnt_ext =
+			(struct ib_pma_portcounters_ext *)counters;
+
+		pma_cnt_ext->port_xmit_data =
+			cpu_to_be64(be64_to_cpu(cnt->tx_bytes) >> 2);
+		pma_cnt_ext->port_rcv_data =
+			cpu_to_be64(be64_to_cpu(cnt->rx_bytes) >> 2);
+		pma_cnt_ext->port_xmit_packets = cnt->tx_frames;
+		pma_cnt_ext->port_rcv_packets = cnt->rx_frames;
+		break;
+	}
+	}
 }
 
 static int iboe_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
@@ -852,7 +874,8 @@ static int iboe_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 		switch (counter_stats.counter_mode & 0xf) {
 		case 0:
 			edit_counter(&counter_stats,
-				     (void *)(out_mad->data + 40));
+				     (void *)(out_mad->data + 40),
+				     in_mad->mad_hdr.attr_id);
 			err = IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_REPLY;
 			break;
 		default:
@@ -883,8 +906,9 @@ int mlx4_ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 	 */
 	if (link == IB_LINK_LAYER_INFINIBAND) {
 		if (mlx4_is_slave(dev->dev) &&
-		    in_mad->mad_hdr.mgmt_class == IB_MGMT_CLASS_PERF_MGMT &&
-		    in_mad->mad_hdr.attr_id == IB_PMA_PORT_COUNTERS)
+		    (in_mad->mad_hdr.mgmt_class == IB_MGMT_CLASS_PERF_MGMT &&
+		     (in_mad->mad_hdr.attr_id == IB_PMA_PORT_COUNTERS ||
+		      in_mad->mad_hdr.attr_id == IB_PMA_PORT_COUNTERS_EXT)))
 			return iboe_process_mad(ibdev, mad_flags, port_num, in_wc,
 						in_grh, in_mad, out_mad);
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
