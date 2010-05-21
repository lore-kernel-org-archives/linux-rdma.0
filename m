From: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDMA/nes: ethtool read hardware registers for rx/tx stats
Date: Fri, 21 May 2010 16:54:57 -0500
Message-ID: <20100521215457.GA4404@flatif-MOBL1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Enhance ethtool to read hardware registers for rcv/tx error stats. Also
added support for free pbl resources and remove cq depth stats which are not
used.

Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_nic.c |   72 ++++++++++++++++++++++++++--------
 1 files changed, 55 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_nic.c b/drivers/infiniband/hw/nes/nes_nic.c
index 3d550dc..812a448 100644
--- a/drivers/infiniband/hw/nes/nes_nic.c
+++ b/drivers/infiniband/hw/nes/nes_nic.c
@@ -988,6 +988,7 @@ static int nes_netdev_change_mtu(struct net_device *netdev, int new_mtu)
 	return ret;
 }
 
+
 static const char nes_ethtool_stringset[][ETH_GSTRING_LEN] = {
 	"Link Change Interrupts",
 	"Linearized SKBs",
@@ -1002,11 +1003,15 @@ static const char nes_ethtool_stringset[][ETH_GSTRING_LEN] = {
 	"Rx Jabber Errors",
 	"Rx Oversized Frames",
 	"Rx Short Frames",
+	"Rx Length Errors",
+	"Rx CRC Errors",
+	"Rx Port Discard",
 	"Endnode Rx Discards",
 	"Endnode Rx Octets",
 	"Endnode Rx Frames",
 	"Endnode Tx Octets",
 	"Endnode Tx Frames",
+	"Tx Errors",
 	"mh detected",
 	"mh pauses",
 	"Retransmission Count",
@@ -1035,19 +1040,13 @@ static const char nes_ethtool_stringset[][ETH_GSTRING_LEN] = {
 	"CM Nodes Destroyed",
 	"CM Accel Drops",
 	"CM Resets Received",
+	"Free 4Kpbls",
+	"Free 256pbls",
 	"Timer Inits",
-	"CQ Depth 1",
-	"CQ Depth 4",
-	"CQ Depth 16",
-	"CQ Depth 24",
-	"CQ Depth 32",
-	"CQ Depth 128",
-	"CQ Depth 256",
 	"LRO aggregated",
 	"LRO flushed",
 	"LRO no_desc",
 };
-
 #define NES_ETHTOOL_STAT_COUNT  ARRAY_SIZE(nes_ethtool_stringset)
 
 /**
@@ -1107,12 +1106,14 @@ static void nes_netdev_get_strings(struct net_device *netdev, u32 stringset,
 /**
  * nes_netdev_get_ethtool_stats
  */
+
 static void nes_netdev_get_ethtool_stats(struct net_device *netdev,
 		struct ethtool_stats *target_ethtool_stats, u64 *target_stat_values)
 {
 	u64 u64temp;
 	struct nes_vnic *nesvnic = netdev_priv(netdev);
 	struct nes_device *nesdev = nesvnic->nesdev;
+	struct nes_adapter *nesadapter = nesdev->nesadapter;
 	u32 nic_count;
 	u32 u32temp;
 	u32 index = 0;
@@ -1141,6 +1142,46 @@ static void nes_netdev_get_ethtool_stats(struct net_device *netdev,
 	nesvnic->nesdev->port_tx_discards += u32temp;
 	nesvnic->netstats.tx_dropped += u32temp;
 
+	u32temp = nes_read_indexed(nesdev,
+			NES_IDX_MAC_RX_SHORT_FRAMES + (nesvnic->nesdev->mac_index*0x200));
+	nesvnic->netstats.rx_dropped += u32temp;
+	nesvnic->nesdev->mac_rx_errors += u32temp;
+	nesvnic->nesdev->mac_rx_short_frames += u32temp;
+
+	u32temp = nes_read_indexed(nesdev,
+			NES_IDX_MAC_RX_OVERSIZED_FRAMES + (nesvnic->nesdev->mac_index*0x200));
+	nesvnic->netstats.rx_dropped += u32temp;
+	nesvnic->nesdev->mac_rx_errors += u32temp;
+	nesvnic->nesdev->mac_rx_oversized_frames += u32temp;
+
+	u32temp = nes_read_indexed(nesdev,
+			NES_IDX_MAC_RX_JABBER_FRAMES + (nesvnic->nesdev->mac_index*0x200));
+	nesvnic->netstats.rx_dropped += u32temp;
+	nesvnic->nesdev->mac_rx_errors += u32temp;
+	nesvnic->nesdev->mac_rx_jabber_frames += u32temp;
+
+	u32temp = nes_read_indexed(nesdev,
+			NES_IDX_MAC_RX_SYMBOL_ERR_FRAMES + (nesvnic->nesdev->mac_index*0x200));
+	nesvnic->netstats.rx_dropped += u32temp;
+	nesvnic->nesdev->mac_rx_errors += u32temp;
+	nesvnic->nesdev->mac_rx_symbol_err_frames += u32temp;
+
+	u32temp = nes_read_indexed(nesdev,
+			NES_IDX_MAC_RX_LENGTH_ERR_FRAMES + (nesvnic->nesdev->mac_index*0x200));
+	nesvnic->netstats.rx_length_errors += u32temp;
+	nesvnic->nesdev->mac_rx_errors += u32temp;
+
+	u32temp = nes_read_indexed(nesdev,
+			NES_IDX_MAC_RX_CRC_ERR_FRAMES + (nesvnic->nesdev->mac_index*0x200));
+	nesvnic->nesdev->mac_rx_errors += u32temp;
+	nesvnic->nesdev->mac_rx_crc_errors += u32temp;
+	nesvnic->netstats.rx_crc_errors += u32temp;
+
+	u32temp = nes_read_indexed(nesdev,
+			NES_IDX_MAC_TX_ERRORS + (nesvnic->nesdev->mac_index*0x200));
+	nesvnic->nesdev->mac_tx_errors += u32temp;
+	nesvnic->netstats.tx_errors += u32temp;
+
 	for (nic_count = 0; nic_count < NES_MAX_PORT_COUNT; nic_count++) {
 		if (nesvnic->qp_nic_index[nic_count] == 0xf)
 			break;
@@ -1205,11 +1246,15 @@ static void nes_netdev_get_ethtool_stats(struct net_device *netdev,
 	target_stat_values[++index] = nesvnic->nesdev->mac_rx_jabber_frames;
 	target_stat_values[++index] = nesvnic->nesdev->mac_rx_oversized_frames;
 	target_stat_values[++index] = nesvnic->nesdev->mac_rx_short_frames;
+	target_stat_values[++index] = nesvnic->netstats.rx_length_errors;
+	target_stat_values[++index] = nesvnic->nesdev->mac_rx_crc_errors;
+	target_stat_values[++index] = nesvnic->nesdev->port_rx_discards;
 	target_stat_values[++index] = nesvnic->endnode_nstat_rx_discard;
 	target_stat_values[++index] = nesvnic->endnode_nstat_rx_octets;
 	target_stat_values[++index] = nesvnic->endnode_nstat_rx_frames;
 	target_stat_values[++index] = nesvnic->endnode_nstat_tx_octets;
 	target_stat_values[++index] = nesvnic->endnode_nstat_tx_frames;
+	target_stat_values[++index] = nesvnic->nesdev->mac_tx_errors;
 	target_stat_values[++index] = mh_detected;
 	target_stat_values[++index] = mh_pauses_sent;
 	target_stat_values[++index] = nesvnic->endnode_ipv4_tcp_retransmits;
@@ -1238,21 +1283,14 @@ static void nes_netdev_get_ethtool_stats(struct net_device *netdev,
 	target_stat_values[++index] = atomic_read(&cm_nodes_destroyed);
 	target_stat_values[++index] = atomic_read(&cm_accel_dropped_pkts);
 	target_stat_values[++index] = atomic_read(&cm_resets_recvd);
+	target_stat_values[++index] = nesadapter->free_4kpbl;
+	target_stat_values[++index] = nesadapter->free_256pbl;
 	target_stat_values[++index] = int_mod_timer_init;
-	target_stat_values[++index] = int_mod_cq_depth_1;
-	target_stat_values[++index] = int_mod_cq_depth_4;
-	target_stat_values[++index] = int_mod_cq_depth_16;
-	target_stat_values[++index] = int_mod_cq_depth_24;
-	target_stat_values[++index] = int_mod_cq_depth_32;
-	target_stat_values[++index] = int_mod_cq_depth_128;
-	target_stat_values[++index] = int_mod_cq_depth_256;
 	target_stat_values[++index] = nesvnic->lro_mgr.stats.aggregated;
 	target_stat_values[++index] = nesvnic->lro_mgr.stats.flushed;
 	target_stat_values[++index] = nesvnic->lro_mgr.stats.no_desc;
-
 }
 
-
 /**
  * nes_netdev_get_drvinfo
  */
-- 
1.6.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
