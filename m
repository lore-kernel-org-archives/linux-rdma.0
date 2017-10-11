From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v2 29/45] IB/nes: Remove set-but-not-used variables
Date: Wed, 11 Oct 2017 10:49:11 -0700
Message-ID: <20171011174927.25113-30-bart.vanassche@wdc.com>
References: <20171011174927.25113-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171011174927.25113-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_cm.c    | 8 --------
 drivers/infiniband/hw/nes/nes_utils.c | 5 ++---
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index a5f6dffef07a..bfe2156813b1 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -1389,7 +1389,6 @@ static int nes_addr_resolve_neigh(struct nes_vnic *nesvnic, u32 dst_ip, int arpi
 	struct rtable *rt;
 	struct neighbour *neigh;
 	int rc = arpindex;
-	struct net_device *netdev;
 	struct nes_adapter *nesadapter = nesvnic->nesdev->nesadapter;
 	__be32 dst_ipaddr = htonl(dst_ip);
 
@@ -1400,11 +1399,6 @@ static int nes_addr_resolve_neigh(struct nes_vnic *nesvnic, u32 dst_ip, int arpi
 		return rc;
 	}
 
-	if (netif_is_bond_slave(nesvnic->netdev))
-		netdev = netdev_master_upper_dev_get(nesvnic->netdev);
-	else
-		netdev = nesvnic->netdev;
-
 	neigh = dst_neigh_lookup(&rt->dst, &dst_ipaddr);
 
 	rcu_read_lock();
@@ -3075,7 +3069,6 @@ int nes_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	u32 crc_value;
 	int ret;
 	int passive_state;
-	struct nes_ib_device *nesibdev;
 	struct ib_mr *ibmr = NULL;
 	struct nes_pd *nespd;
 	u64 tagged_offset;
@@ -3158,7 +3151,6 @@ int nes_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 
 	if (raddr->sin_addr.s_addr != laddr->sin_addr.s_addr) {
 		u64temp = (unsigned long)nesqp;
-		nesibdev = nesvnic->nesibdev;
 		nespd = nesqp->nespd;
 		tagged_offset = (u64)(unsigned long)*start_buff;
 		ibmr = nes_reg_phys_mr(&nespd->ibpd,
diff --git a/drivers/infiniband/hw/nes/nes_utils.c b/drivers/infiniband/hw/nes/nes_utils.c
index 7b67e9cb57ed..0613eb5006cc 100644
--- a/drivers/infiniband/hw/nes/nes_utils.c
+++ b/drivers/infiniband/hw/nes/nes_utils.c
@@ -753,7 +753,6 @@ void nes_mh_fix(unsigned long parm)
 	u32 mac_tx_frames_low;
 	u32 mac_tx_frames_high;
 	u32 mac_tx_pauses;
-	u32 serdes_status;
 	u32 reset_value;
 	u32 tx_control;
 	u32 tx_config;
@@ -846,7 +845,7 @@ void nes_mh_fix(unsigned long parm)
 		}
 
 		nes_write_indexed(nesdev, NES_IDX_ETH_SERDES_COMMON_CONTROL0, 0x00000008);
-		serdes_status = nes_read_indexed(nesdev, NES_IDX_ETH_SERDES_COMMON_STATUS0);
+		nes_read_indexed(nesdev, NES_IDX_ETH_SERDES_COMMON_STATUS0);
 
 		nes_write_indexed(nesdev, NES_IDX_ETH_SERDES_TX_EMP0, 0x000bdef7);
 		nes_write_indexed(nesdev, NES_IDX_ETH_SERDES_TX_DRIVE0, 0x9ce73000);
@@ -859,7 +858,7 @@ void nes_mh_fix(unsigned long parm)
 		} else {
 			nes_write_indexed(nesdev, NES_IDX_ETH_SERDES_RX_EQ_CONTROL0, 0xf0042222);
 		}
-		serdes_status = nes_read_indexed(nesdev, NES_IDX_ETH_SERDES_RX_EQ_STATUS0);
+		nes_read_indexed(nesdev, NES_IDX_ETH_SERDES_RX_EQ_STATUS0);
 		nes_write_indexed(nesdev, NES_IDX_ETH_SERDES_CDR_CONTROL0, 0x000000ff);
 
 		nes_write_indexed(nesdev, NES_IDX_MAC_TX_CONTROL, tx_control);
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
