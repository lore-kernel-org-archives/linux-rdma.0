From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] RDMA/nes: Convert timers to use timer_setup()
Date: Wed, 4 Oct 2017 17:45:27 -0700
Message-ID: <20171005004527.GA22607@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Faisal Latif <faisal.latif@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-rdma@vger.kernel.org

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly. A pointer from nesadapter back to
nesdev was added.

Cc: Faisal Latif <faisal.latif@intel.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
This requires commit 686fef928bba ("timer: Prepare to change timer
callback argument type") in v4.14-rc3, but should be otherwise
stand-alone.
---
 drivers/infiniband/hw/nes/nes.h       |  6 +++---
 drivers/infiniband/hw/nes/nes_cm.c    |  5 ++---
 drivers/infiniband/hw/nes/nes_hw.c    | 20 ++++++++------------
 drivers/infiniband/hw/nes/nes_hw.h    |  1 +
 drivers/infiniband/hw/nes/nes_mgt.c   |  9 +++++----
 drivers/infiniband/hw/nes/nes_nic.c   |  3 +--
 drivers/infiniband/hw/nes/nes_utils.c | 11 +++++------
 drivers/infiniband/hw/nes/nes_verbs.c | 10 ++++------
 8 files changed, 29 insertions(+), 36 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes.h b/drivers/infiniband/hw/nes/nes.h
index 3f9e56e8b379..00c27291dc26 100644
--- a/drivers/infiniband/hw/nes/nes.h
+++ b/drivers/infiniband/hw/nes/nes.h
@@ -536,7 +536,7 @@ void nes_iwarp_ce_handler(struct nes_device *, struct nes_hw_cq *);
 int nes_destroy_cqp(struct nes_device *);
 int nes_nic_cm_xmit(struct sk_buff *, struct net_device *);
 void nes_recheck_link_status(struct work_struct *work);
-void nes_terminate_timeout(unsigned long context);
+void nes_terminate_timeout(struct timer_list *t);
 
 /* nes_nic.c */
 struct net_device *nes_netdev_init(struct nes_device *, void __iomem *);
@@ -575,8 +575,8 @@ void nes_put_cqp_request(struct nes_device *nesdev,
 			 struct nes_cqp_request *cqp_request);
 void nes_post_cqp_request(struct nes_device *, struct nes_cqp_request *);
 int nes_arp_table(struct nes_device *, u32, u8 *, u32);
-void nes_mh_fix(unsigned long);
-void nes_clc(unsigned long);
+void nes_mh_fix(struct timer_list *t);
+void nes_clc(struct timer_list *t);
 void nes_dump_mem(unsigned int, void *, int);
 u32 nes_crc32(u32, u32, u32, u32, u8 *, u32, u32, u32);
 
diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index de4025deaa4a..4961e80dcf95 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -840,7 +840,7 @@ static void handle_recv_entry(struct nes_cm_node *cm_node, u32 rem_node)
 /**
  * nes_cm_timer_tick
  */
-static void nes_cm_timer_tick(unsigned long pass)
+static void nes_cm_timer_tick(struct timer_list *unused)
 {
 	unsigned long flags;
 	unsigned long nexttimeout = jiffies + NES_LONG_TIME;
@@ -2670,8 +2670,7 @@ static struct nes_cm_core *nes_cm_alloc_core(void)
 		return NULL;
 
 	INIT_LIST_HEAD(&cm_core->connected_nodes);
-	init_timer(&cm_core->tcp_timer);
-	cm_core->tcp_timer.function = nes_cm_timer_tick;
+	timer_setup(&cm_core->tcp_timer, nes_cm_timer_tick, 0);
 
 	cm_core->mtu = NES_CM_DEFAULT_MTU;
 	cm_core->state = NES_CM_STATE_INITED;
diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index b0adf65e4bdb..48398b460d5c 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -381,6 +381,7 @@ struct nes_adapter *nes_init_adapter(struct nes_device *nesdev, u8 hw_rev) {
 	       sizeof nesadapter->pft_mcast_map);
 
 	/* populate the new nesadapter */
+	nesadapter->nesdev = nesdev;
 	nesadapter->devfn = nesdev->pcidev->devfn;
 	nesadapter->bus_number = nesdev->pcidev->bus->number;
 	nesadapter->ref_count = 1;
@@ -598,19 +599,15 @@ struct nes_adapter *nes_init_adapter(struct nes_device *nesdev, u8 hw_rev) {
 	}
 
 	if (nesadapter->hw_rev == NE020_REV) {
-		init_timer(&nesadapter->mh_timer);
-		nesadapter->mh_timer.function = nes_mh_fix;
+		timer_setup(&nesadapter->mh_timer, nes_mh_fix, 0);
 		nesadapter->mh_timer.expires = jiffies + (HZ/5);  /* 1 second */
-		nesadapter->mh_timer.data = (unsigned long)nesdev;
 		add_timer(&nesadapter->mh_timer);
 	} else {
 		nes_write32(nesdev->regs+NES_INTF_INT_STAT, 0x0f000000);
 	}
 
-	init_timer(&nesadapter->lc_timer);
-	nesadapter->lc_timer.function = nes_clc;
+	timer_setup(&nesadapter->lc_timer, nes_clc, 0);
 	nesadapter->lc_timer.expires = jiffies + 3600 * HZ;  /* 1 hour */
-	nesadapter->lc_timer.data = (unsigned long)nesdev;
 	add_timer(&nesadapter->lc_timer);
 
 	list_add_tail(&nesadapter->list, &nes_adapter_list);
@@ -1623,9 +1620,9 @@ static void nes_replenish_nic_rq(struct nes_vnic *nesvnic)
 /**
  * nes_rq_wqes_timeout
  */
-static void nes_rq_wqes_timeout(unsigned long parm)
+static void nes_rq_wqes_timeout(struct timer_list *t)
 {
-	struct nes_vnic *nesvnic = (struct nes_vnic *)parm;
+	struct nes_vnic *nesvnic = from_timer(nesvnic, t, rq_wqes_timer);
 	printk("%s: Timer fired.\n", __func__);
 	atomic_set(&nesvnic->rx_skb_timer_running, 0);
 	if (atomic_read(&nesvnic->rx_skbs_needed))
@@ -1849,8 +1846,7 @@ int nes_init_nic_qp(struct nes_device *nesdev, struct net_device *netdev)
 		wqe_count -= counter;
 		nes_write32(nesdev->regs+NES_WQE_ALLOC, (counter << 24) | nesvnic->nic.qp_id);
 	} while (wqe_count);
-	setup_timer(&nesvnic->rq_wqes_timer, nes_rq_wqes_timeout,
-		    (unsigned long)nesvnic);
+	timer_setup(&nesvnic->rq_wqes_timer, nes_rq_wqes_timeout, 0);
 	nes_debug(NES_DBG_INIT, "NAPI support Enabled\n");
 	if (nesdev->nesadapter->et_use_adaptive_rx_coalesce)
 	{
@@ -3474,9 +3470,9 @@ static void nes_terminate_received(struct nes_device *nesdev,
 }
 
 /* Timeout routine in case terminate fails to complete */
-void nes_terminate_timeout(unsigned long context)
+void nes_terminate_timeout(struct timer_list *t)
 {
-	struct nes_qp *nesqp = (struct nes_qp *)(unsigned long)context;
+	struct nes_qp *nesqp = from_timer(nesqp, t, terminate_timer);
 
 	nes_terminate_done(nesqp, 1);
 }
diff --git a/drivers/infiniband/hw/nes/nes_hw.h b/drivers/infiniband/hw/nes/nes_hw.h
index 1b66ef1e9937..3c56470816a8 100644
--- a/drivers/infiniband/hw/nes/nes_hw.h
+++ b/drivers/infiniband/hw/nes/nes_hw.h
@@ -1164,6 +1164,7 @@ struct nes_adapter {
 	u8  log_port;
 
 	/* PCI information */
+	struct nes_device *nesdev;
 	unsigned int  devfn;
 	unsigned char bus_number;
 	unsigned char OneG_Mode;
diff --git a/drivers/infiniband/hw/nes/nes_mgt.c b/drivers/infiniband/hw/nes/nes_mgt.c
index 77226cf4ea02..21e0ebd39a05 100644
--- a/drivers/infiniband/hw/nes/nes_mgt.c
+++ b/drivers/infiniband/hw/nes/nes_mgt.c
@@ -122,9 +122,10 @@ static void nes_replenish_mgt_rq(struct nes_vnic_mgt *mgtvnic)
 /**
  * nes_mgt_rq_wqes_timeout
  */
-static void nes_mgt_rq_wqes_timeout(unsigned long parm)
+static void nes_mgt_rq_wqes_timeout(struct timer_list *t)
 {
-	struct nes_vnic_mgt *mgtvnic = (struct nes_vnic_mgt *)parm;
+	struct nes_vnic_mgt *mgtvnic = from_timer(mgtvnic, t,
+						       rq_wqes_timer);
 
 	atomic_set(&mgtvnic->rx_skb_timer_running, 0);
 	if (atomic_read(&mgtvnic->rx_skbs_needed))
@@ -1040,8 +1041,8 @@ int nes_init_mgt_qp(struct nes_device *nesdev, struct net_device *netdev, struct
 			mgtvnic->mgt.rx_skb[counter] = skb;
 		}
 
-		setup_timer(&mgtvnic->rq_wqes_timer, nes_mgt_rq_wqes_timeout,
-			    (unsigned long)mgtvnic);
+		timer_setup(&mgtvnic->rq_wqes_timer, nes_mgt_rq_wqes_timeout,
+			    0);
 
 		wqe_count = NES_MGT_WQ_COUNT - 1;
 		mgtvnic->mgt.rq_head = wqe_count;
diff --git a/drivers/infiniband/hw/nes/nes_nic.c b/drivers/infiniband/hw/nes/nes_nic.c
index 5921ea3d50ae..448a8e7d0963 100644
--- a/drivers/infiniband/hw/nes/nes_nic.c
+++ b/drivers/infiniband/hw/nes/nes_nic.c
@@ -1746,8 +1746,7 @@ struct net_device *nes_netdev_init(struct nes_device *nesdev,
 		nesvnic->rdma_enabled = 0;
 	}
 	nesvnic->nic_cq.cq_number = nesvnic->nic.qp_id;
-	init_timer(&nesvnic->event_timer);
-	nesvnic->event_timer.function = NULL;
+	timer_setup(&nesvnic->event_timer, NULL, 0);
 	spin_lock_init(&nesvnic->tx_lock);
 	spin_lock_init(&nesvnic->port_ibevent_lock);
 	nesdev->netdev[nesdev->netdev_count] = netdev;
diff --git a/drivers/infiniband/hw/nes/nes_utils.c b/drivers/infiniband/hw/nes/nes_utils.c
index 37331e2fdc5f..1dc0527e5a05 100644
--- a/drivers/infiniband/hw/nes/nes_utils.c
+++ b/drivers/infiniband/hw/nes/nes_utils.c
@@ -740,11 +740,11 @@ int nes_arp_table(struct nes_device *nesdev, u32 ip_addr, u8 *mac_addr, u32 acti
 /**
  * nes_mh_fix
  */
-void nes_mh_fix(unsigned long parm)
+void nes_mh_fix(struct timer_list *t)
 {
+	struct nes_adapter *nesadapter = from_timer(nesadapter, t, mh_timer);
+	struct nes_device *nesdev = nesadapter->nesdev;
 	unsigned long flags;
-	struct nes_device *nesdev = (struct nes_device *)parm;
-	struct nes_adapter *nesadapter = nesdev->nesadapter;
 	struct nes_vnic *nesvnic;
 	u32 used_chunks_tx;
 	u32 temp_used_chunks_tx;
@@ -881,11 +881,10 @@ void nes_mh_fix(unsigned long parm)
 /**
  * nes_clc
  */
-void nes_clc(unsigned long parm)
+void nes_clc(struct timer_list *t)
 {
+	struct nes_adapter *nesadapter = from_timer(nesadapter, t, lc_timer);
 	unsigned long flags;
-	struct nes_device *nesdev = (struct nes_device *)parm;
-	struct nes_adapter *nesadapter = nesdev->nesadapter;
 
 	spin_lock_irqsave(&nesadapter->phy_lock, flags);
     nesadapter->link_interrupt_count[0] = 0;
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 442b9bdc0f03..fac59cd1db71 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -1304,8 +1304,7 @@ static struct ib_qp *nes_create_qp(struct ib_pd *ibpd,
 	init_completion(&nesqp->rq_drained);
 
 	nesqp->sig_all = (init_attr->sq_sig_type == IB_SIGNAL_ALL_WR);
-	setup_timer(&nesqp->terminate_timer, nes_terminate_timeout,
-		    (unsigned long)nesqp);
+	timer_setup(&nesqp->terminate_timer, nes_terminate_timeout, 0);
 
 	/* update the QP table */
 	nesdev->nesadapter->qp_table[nesqp->hwqp.qp_id-NES_FIRST_QPN] = nesqp;
@@ -3788,9 +3787,9 @@ struct nes_ib_device *nes_init_ofa_device(struct net_device *netdev)
 /**
  * nes_handle_delayed_event
  */
-static void nes_handle_delayed_event(unsigned long data)
+static void nes_handle_delayed_event(struct timer_list *t)
 {
-	struct nes_vnic *nesvnic = (void *) data;
+	struct nes_vnic *nesvnic = from_timer(nesvnic, t, event_timer);
 
 	if (nesvnic->delayed_event != nesvnic->last_dispatched_event) {
 		struct ib_event event;
@@ -3820,8 +3819,7 @@ void  nes_port_ibevent(struct nes_vnic *nesvnic)
 	if (!nesvnic->event_timer.function) {
 		ib_dispatch_event(&event);
 		nesvnic->last_dispatched_event = event.event;
-		nesvnic->event_timer.function = nes_handle_delayed_event;
-		nesvnic->event_timer.data = (unsigned long) nesvnic;
+		nesvnic->event_timer.function = (TIMER_FUNC_TYPE)nes_handle_delayed_event;
 		nesvnic->event_timer.expires = jiffies + NES_EVENT_DELAY;
 		add_timer(&nesvnic->event_timer);
 	} else {
-- 
2.7.4


-- 
Kees Cook
Pixel Security
