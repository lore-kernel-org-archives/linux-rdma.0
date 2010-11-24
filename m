From: Maciej Sosnowski <maciej.sosnowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/4] RDMA/nes: send IB_EVENT_PORT_ERR/PORT_ACTIVE event on
	link state interrupt
Date: Wed, 24 Nov 2010 18:29:38 +0100
Message-ID: <20101124172938.14764.49859.stgit@linux.site>
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

Depending on link state change IB_EVENT_PORT_ERR or IB_EVENT_PORT_ACTIVE
should be dispatched in processing of mac interrupt.
Plug in the cable happen to result in series of interrupts
changing driver's link state for a number of times before finally
staying at link up (e.g. link up, link down, link up, link down, ..., link up).
To prevent sending series of redundant IB_EVENT_PORT_ACTIVE
and IB_EVENT_PORT_ERR events they get filtered out by timer based
nes_port_ibevent() routine.

Signed-off-by: Maciej Sosnowski <maciej.sosnowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/infiniband/hw/nes/nes_hw.c    |   14 ++++++++++++
 drivers/infiniband/hw/nes/nes_hw.h    |    6 +++++
 drivers/infiniband/hw/nes/nes_nic.c   |   35 ++++++++++++++++++++++++-------
 drivers/infiniband/hw/nes/nes_verbs.c |   37 ++++++++++++++++++++++++++++++++-
 4 files changed, 83 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index 1980a46..2b89b06 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -2608,6 +2608,13 @@ static void nes_process_mac_intr(struct 
 						netif_start_queue(nesvnic->netdev);
 					nesvnic->linkup = 1;
 					netif_carrier_on(nesvnic->netdev);
+
+					spin_lock(&nesvnic->port_ibevent_lock);
+					if (nesdev->iw_status == 0) {
+						nesdev->iw_status = 1;
+						nes_port_ibevent(nesvnic);
+					}
+					spin_unlock(&nesvnic->port_ibevent_lock);
 				}
 			}
 		} else {
@@ -2633,6 +2640,13 @@ static void nes_process_mac_intr(struct 
 						netif_stop_queue(nesvnic->netdev);
 					nesvnic->linkup = 0;
 					netif_carrier_off(nesvnic->netdev);
+
+					spin_lock(&nesvnic->port_ibevent_lock);
+					if (nesdev->iw_status == 1) {
+						nesdev->iw_status = 0;
+						nes_port_ibevent(nesvnic);
+					}
+					spin_unlock(&nesvnic->port_ibevent_lock);
 				}
 			}
 		}
diff --git a/drivers/infiniband/hw/nes/nes_hw.h b/drivers/infiniband/hw/nes/nes_hw.h
index 1204c34..8a9ea9a 100644
--- a/drivers/infiniband/hw/nes/nes_hw.h
+++ b/drivers/infiniband/hw/nes/nes_hw.h
@@ -1193,6 +1193,8 @@ struct nes_listener {
 
 struct nes_ib_device;
 
+#define NES_EVENT_DELAY msecs_to_jiffies(100)
+
 struct nes_vnic {
 	struct nes_ib_device *nesibdev;
 	u64 sq_full;
@@ -1247,6 +1249,10 @@ struct nes_vnic {
 	u32 lro_max_aggr;
 	struct net_lro_mgr lro_mgr;
 	struct net_lro_desc lro_desc[NES_MAX_LRO_DESCRIPTORS];
+	struct timer_list event_timer;
+	enum ib_event_type delayed_event;
+	enum ib_event_type last_dispatched_event;
+	spinlock_t port_ibevent_lock;
 };
 
 struct nes_ib_device {
diff --git a/drivers/infiniband/hw/nes/nes_nic.c b/drivers/infiniband/hw/nes/nes_nic.c
index 3892e2c..b2101bc 100644
--- a/drivers/infiniband/hw/nes/nes_nic.c
+++ b/drivers/infiniband/hw/nes/nes_nic.c
@@ -144,6 +144,7 @@ static int nes_netdev_open(struct net_de
 	u32 nic_active_bit;
 	u32 nic_active;
 	struct list_head *list_pos, *list_temp;
+	unsigned long flags;
 
 	assert(nesdev != NULL);
 
@@ -233,18 +234,27 @@ static int nes_netdev_open(struct net_de
 		first_nesvnic = nesvnic;
 	}
 
-	if (nesvnic->of_device_registered) {
-		nesdev->iw_status = 1;
-		nesdev->nesadapter->send_term_ok = 1;
-		nes_port_ibevent(nesvnic);
-	}
-
 	if (first_nesvnic->linkup) {
 		/* Enable network packets */
 		nesvnic->linkup = 1;
 		netif_start_queue(netdev);
 		netif_carrier_on(netdev);
 	}
+
+	spin_lock_irqsave(&nesvnic->port_ibevent_lock, flags);
+	if (nesvnic->of_device_registered) {
+		nesdev->nesadapter->send_term_ok = 1;
+		if (nesvnic->linkup == 1) {
+			if (nesdev->iw_status == 0) {
+				nesdev->iw_status = 1;
+				nes_port_ibevent(nesvnic);
+			}
+		} else {
+			nesdev->iw_status = 0;
+		}
+	}
+	spin_unlock_irqrestore(&nesvnic->port_ibevent_lock, flags);
+
 	napi_enable(&nesvnic->napi);
 	nesvnic->netdev_open = 1;
 
@@ -263,6 +273,7 @@ static int nes_netdev_stop(struct net_de
 	u32 nic_active;
 	struct nes_vnic *first_nesvnic = NULL;
 	struct list_head *list_pos, *list_temp;
+	unsigned long flags;
 
 	nes_debug(NES_DBG_SHUTDOWN, "nesvnic=%p, nesdev=%p, netdev=%p %s\n",
 			nesvnic, nesdev, netdev, netdev->name);
@@ -315,12 +326,17 @@ static int nes_netdev_stop(struct net_de
 	nic_active &= nic_active_mask;
 	nes_write_indexed(nesdev, NES_IDX_NIC_BROADCAST_ON, nic_active);
 
-
+	spin_lock_irqsave(&nesvnic->port_ibevent_lock, flags);
 	if (nesvnic->of_device_registered) {
 		nesdev->nesadapter->send_term_ok = 0;
 		nesdev->iw_status = 0;
-		nes_port_ibevent(nesvnic);
+		if (nesvnic->linkup == 1)
+			nes_port_ibevent(nesvnic);
 	}
+	del_timer_sync(&nesvnic->event_timer);
+	nesvnic->event_timer.function = NULL;
+	spin_unlock_irqrestore(&nesvnic->port_ibevent_lock, flags);
+
 	nes_destroy_nic_qp(nesvnic);
 
 	nesvnic->netdev_open = 0;
@@ -1750,7 +1766,10 @@ struct net_device *nes_netdev_init(struc
 		nesvnic->rdma_enabled = 0;
 	}
 	nesvnic->nic_cq.cq_number = nesvnic->nic.qp_id;
+	init_timer(&nesvnic->event_timer);
+	nesvnic->event_timer.function = NULL;
 	spin_lock_init(&nesvnic->tx_lock);
+	spin_lock_init(&nesvnic->port_ibevent_lock);
 	nesdev->netdev[nesdev->netdev_count] = netdev;
 
 	nes_debug(NES_DBG_INIT, "Adding nesvnic (%p) to the adapters nesvnic_list for MAC%d.\n",
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 99933e4..26d8018 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -3936,6 +3936,30 @@ struct nes_ib_device *nes_init_ofa_devic
 	return nesibdev;
 }
 
+
+/**
+ * nes_handle_delayed_event
+ */
+static void nes_handle_delayed_event(unsigned long data)
+{
+	struct nes_vnic *nesvnic = (void *) data;
+
+	if (nesvnic->delayed_event != nesvnic->last_dispatched_event) {
+		struct ib_event event;
+
+		event.device = &nesvnic->nesibdev->ibdev;
+		if (!event.device)
+			goto stop_timer;
+		event.event = nesvnic->delayed_event;
+		event.element.port_num = nesvnic->logical_port + 1;
+		ib_dispatch_event(&event);
+	}
+
+stop_timer:
+	nesvnic->event_timer.function = NULL;
+}
+
+
 void  nes_port_ibevent(struct nes_vnic *nesvnic)
 {
 	struct nes_ib_device *nesibdev = nesvnic->nesibdev;
@@ -3944,7 +3968,18 @@ void  nes_port_ibevent(struct nes_vnic *
 	event.device = &nesibdev->ibdev;
 	event.element.port_num = nesvnic->logical_port + 1;
 	event.event = nesdev->iw_status ? IB_EVENT_PORT_ACTIVE : IB_EVENT_PORT_ERR;
-	ib_dispatch_event(&event);
+
+	if (!nesvnic->event_timer.function) {
+		ib_dispatch_event(&event);
+		nesvnic->last_dispatched_event = event.event;
+		nesvnic->event_timer.function = nes_handle_delayed_event;
+		nesvnic->event_timer.data = (unsigned long) nesvnic;
+		nesvnic->event_timer.expires = jiffies + NES_EVENT_DELAY;
+		add_timer(&nesvnic->event_timer);
+	} else {
+		mod_timer(&nesvnic->event_timer, jiffies + NES_EVENT_DELAY);
+	}
+	nesvnic->delayed_event = event.event;
 }
 
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
