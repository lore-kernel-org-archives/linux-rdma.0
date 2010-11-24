From: Maciej Sosnowski <maciej.sosnowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/4] RDMA/nes: fix SFP link down detection issue with switch
	port disable
Date: Wed, 24 Nov 2010 18:29:46 +0100
Message-ID: <20101124172946.14764.44598.stgit@linux.site>
References: <20101124172930.14764.20947.stgit@linux.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101124172930.14764.20947.stgit-YbU/o29LwNHN0uC3ymp8PA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In case of SFP phy link status check at interrupt processing
happen to give false results. For proper link status change detection
delayed recheck is needed to give nes registers time to settle.
Add periodic link status recheck scheduled at interrupt
to detect potential delayed registers state changes.

This patch fixes openfabrics bugzilla #2117:
http://bugs.openfabrics.org/bugzilla/show_bug.cgi?id=2117

Signed-off-by: Maciej Sosnowski <maciej.sosnowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/infiniband/hw/nes/nes.c    |   11 +++++
 drivers/infiniband/hw/nes/nes.h    |    4 ++
 drivers/infiniband/hw/nes/nes_hw.c |   81 ++++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/nes/nes_hw.h |    4 ++
 4 files changed, 100 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
index e17f52c..3b4ec32 100644
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -674,6 +674,8 @@ static int __devinit nes_probe(struct pc
 	}
 	nes_notifiers_registered++;
 
+	INIT_DELAYED_WORK(&nesdev->work, nes_recheck_link_status);
+
 	/* Initialize network devices */
 	if ((netdev = nes_netdev_init(nesdev, mmio_regs)) == NULL)
 		goto bail7;
@@ -756,6 +758,7 @@ static void __devexit nes_remove(struct 
 	struct nes_device *nesdev = pci_get_drvdata(pcidev);
 	struct net_device *netdev;
 	int netdev_index = 0;
+	unsigned long flags;
 
 		if (nesdev->netdev_count) {
 			netdev = nesdev->netdev[netdev_index];
@@ -782,6 +785,14 @@ static void __devexit nes_remove(struct 
 	free_irq(pcidev->irq, nesdev);
 	tasklet_kill(&nesdev->dpc_tasklet);
 
+	spin_lock_irqsave(&nesdev->nesadapter->phy_lock, flags);
+	if (nesdev->link_recheck) {
+		spin_unlock_irqrestore(&nesdev->nesadapter->phy_lock, flags);
+		cancel_delayed_work_sync(&nesdev->work);
+	} else {
+		spin_unlock_irqrestore(&nesdev->nesadapter->phy_lock, flags);
+	}
+
 	/* Deallocate the Adapter Structure */
 	nes_destroy_adapter(nesdev->nesadapter);
 
diff --git a/drivers/infiniband/hw/nes/nes.h b/drivers/infiniband/hw/nes/nes.h
index b3d145e..6fe7987 100644
--- a/drivers/infiniband/hw/nes/nes.h
+++ b/drivers/infiniband/hw/nes/nes.h
@@ -268,6 +268,9 @@ struct nes_device {
 	u8                     napi_isr_ran;
 	u8                     disable_rx_flow_control;
 	u8                     disable_tx_flow_control;
+
+	struct delayed_work    work;
+	u8                     link_recheck;
 };
 
 
@@ -507,6 +510,7 @@ void nes_nic_ce_handler(struct nes_devic
 void nes_iwarp_ce_handler(struct nes_device *, struct nes_hw_cq *);
 int nes_destroy_cqp(struct nes_device *);
 int nes_nic_cm_xmit(struct sk_buff *, struct net_device *);
+void nes_recheck_link_status(struct work_struct *work);
 
 /* nes_nic.c */
 struct net_device *nes_netdev_init(struct nes_device *, void __iomem *);
diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index 2b89b06..8b606fd 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -2650,6 +2650,13 @@ static void nes_process_mac_intr(struct 
 				}
 			}
 		}
+		if (nesadapter->phy_type[mac_index] == NES_PHY_TYPE_SFP_D) {
+			if (nesdev->link_recheck)
+				cancel_delayed_work(&nesdev->work);
+			nesdev->link_recheck = 1;
+			schedule_delayed_work(&nesdev->work,
+					      NES_LINK_RECHECK_DELAY);
+		}
 	}
 
 	spin_unlock_irqrestore(&nesadapter->phy_lock, flags);
@@ -2657,6 +2664,80 @@ static void nes_process_mac_intr(struct 
 	nesadapter->mac_sw_state[mac_number] = NES_MAC_SW_IDLE;
 }
 
+void nes_recheck_link_status(struct work_struct *work)
+{
+	unsigned long flags;
+	struct nes_device *nesdev = container_of(work, struct nes_device, work.work);
+	struct nes_adapter *nesadapter = nesdev->nesadapter;
+	struct nes_vnic *nesvnic;
+	u32 mac_index = nesdev->mac_index;
+	u16 phy_data;
+	u16 temp_phy_data;
+
+	spin_lock_irqsave(&nesadapter->phy_lock, flags);
+
+	/* check link status */
+	nes_read_10G_phy_reg(nesdev, nesadapter->phy_index[mac_index], 1, 0x9003);
+	temp_phy_data = (u16)nes_read_indexed(nesdev, NES_IDX_MAC_MDIO_CONTROL);
+
+	nes_read_10G_phy_reg(nesdev, nesadapter->phy_index[mac_index], 3, 0x0021);
+	nes_read_indexed(nesdev, NES_IDX_MAC_MDIO_CONTROL);
+	nes_read_10G_phy_reg(nesdev, nesadapter->phy_index[mac_index], 3, 0x0021);
+	phy_data = (u16)nes_read_indexed(nesdev, NES_IDX_MAC_MDIO_CONTROL);
+
+	phy_data = (!temp_phy_data && (phy_data == 0x8000)) ? 0x4 : 0x0;
+
+	nes_debug(NES_DBG_PHY, "%s: Phy data = 0x%04X, link was %s.\n",
+		__func__, phy_data,
+		nesadapter->mac_link_down[mac_index] ? "DOWN" : "UP");
+
+	if (phy_data & 0x0004) {
+		nesadapter->mac_link_down[mac_index] = 0;
+		list_for_each_entry(nesvnic, &nesadapter->nesvnic_list[mac_index], list) {
+			if (nesvnic->linkup == 0) {
+				printk(PFX "The Link is now up for port %s, netdev %p.\n",
+						nesvnic->netdev->name, nesvnic->netdev);
+				if (netif_queue_stopped(nesvnic->netdev))
+					netif_start_queue(nesvnic->netdev);
+				nesvnic->linkup = 1;
+				netif_carrier_on(nesvnic->netdev);
+
+				spin_lock(&nesvnic->port_ibevent_lock);
+				if (nesdev->iw_status == 0) {
+					nesdev->iw_status = 1;
+					nes_port_ibevent(nesvnic);
+				}
+				spin_unlock(&nesvnic->port_ibevent_lock);
+			}
+		}
+
+	} else {
+		nesadapter->mac_link_down[mac_index] = 1;
+		list_for_each_entry(nesvnic, &nesadapter->nesvnic_list[mac_index], list) {
+			if (nesvnic->linkup == 1) {
+				printk(PFX "The Link is now down for port %s, netdev %p.\n",
+						nesvnic->netdev->name, nesvnic->netdev);
+				if (!(netif_queue_stopped(nesvnic->netdev)))
+					netif_stop_queue(nesvnic->netdev);
+				nesvnic->linkup = 0;
+				netif_carrier_off(nesvnic->netdev);
+
+				spin_lock(&nesvnic->port_ibevent_lock);
+				if (nesdev->iw_status == 1) {
+					nesdev->iw_status = 0;
+					nes_port_ibevent(nesvnic);
+				}
+				spin_unlock(&nesvnic->port_ibevent_lock);
+			}
+		}
+	}
+	if (nesdev->link_recheck++ < NES_LINK_RECHECK_MAX)
+		schedule_delayed_work(&nesdev->work, NES_LINK_RECHECK_DELAY);
+	else
+		nesdev->link_recheck = 0;
+
+	spin_unlock_irqrestore(&nesadapter->phy_lock, flags);
+}
 
 
 static void nes_nic_napi_ce_handler(struct nes_device *nesdev, struct nes_hw_nic_cq *cq)
diff --git a/drivers/infiniband/hw/nes/nes_hw.h b/drivers/infiniband/hw/nes/nes_hw.h
index 8a9ea9a..d2abe07 100644
--- a/drivers/infiniband/hw/nes/nes_hw.h
+++ b/drivers/infiniband/hw/nes/nes_hw.h
@@ -1354,6 +1354,10 @@ #define RDMA_READ_REQ_OPCODE	1
 #define BAD_FRAME_OFFSET	64
 #define CQE_MAJOR_DRV		0x8000
 
+/* Used for link status recheck after interrupt processing */
+#define NES_LINK_RECHECK_DELAY	msecs_to_jiffies(50)
+#define NES_LINK_RECHECK_MAX	60
+
 #define nes_vlan_rx vlan_hwaccel_receive_skb
 #define nes_netif_rx netif_receive_skb
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
