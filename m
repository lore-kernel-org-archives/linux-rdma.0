From: Allen Pais <allen.pais-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] infiniband: use setup_timer() helper function.
Date: Mon,  2 Oct 2017 16:45:51 +0530
Message-ID: <1506942951-10917-1-git-send-email-allen.pais@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-Kuom3nnY0e0@public.gmane.org, Allen Pais <allen.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Allen Pais <allen.pais-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Allen Pais <allen.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

This series uses setup_timer() helper function. The series
addresses the files under drivers/infiniband/hw/*.

Signed-off-by: Allen Pais <allen.pais-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/mthca/mthca_catas.c | 4 +---
 drivers/infiniband/hw/nes/nes_cm.c        | 3 +--
 drivers/infiniband/hw/nes/nes_hw.c        | 9 +++------
 drivers/infiniband/hw/nes/nes_nic.c       | 3 +--
 drivers/infiniband/hw/qib/qib_driver.c    | 5 ++---
 drivers/infiniband/hw/qib/qib_iba7220.c   | 5 ++---
 drivers/infiniband/hw/qib/qib_mad.c       | 7 +++----
 drivers/infiniband/hw/qib/qib_sd7220.c    | 5 ++---
 8 files changed, 15 insertions(+), 26 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_catas.c b/drivers/infiniband/hw/mthca/mthca_catas.c
index f6474c2..23cc08d 100644
--- a/drivers/infiniband/hw/mthca/mthca_catas.c
+++ b/drivers/infiniband/hw/mthca/mthca_catas.c
@@ -149,7 +149,7 @@ void mthca_start_catas_poll(struct mthca_dev *dev)
 {
 	phys_addr_t addr;
 
-	init_timer(&dev->catas_err.timer);
+	setup_timer(&dev->catas_err.timer, poll_catas, (unsigned long)dev);
 	dev->catas_err.map  = NULL;
 
 	addr = pci_resource_start(dev->pdev, 0) +
@@ -164,8 +164,6 @@ void mthca_start_catas_poll(struct mthca_dev *dev)
 		return;
 	}
 
-	dev->catas_err.timer.data     = (unsigned long) dev;
-	dev->catas_err.timer.function = poll_catas;
 	dev->catas_err.timer.expires  = jiffies + MTHCA_CATAS_POLL_INTERVAL;
 	INIT_LIST_HEAD(&dev->catas_err.list);
 	add_timer(&dev->catas_err.timer);
diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index de4025d..b1de123 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -2670,8 +2670,7 @@ static struct nes_cm_core *nes_cm_alloc_core(void)
 		return NULL;
 
 	INIT_LIST_HEAD(&cm_core->connected_nodes);
-	init_timer(&cm_core->tcp_timer);
-	cm_core->tcp_timer.function = nes_cm_timer_tick;
+	setup_timer(&cm_core->tcp_timer, nes_cm_timer_tick, 0UL);
 
 	cm_core->mtu = NES_CM_DEFAULT_MTU;
 	cm_core->state = NES_CM_STATE_INITED;
diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index b0adf65..248505f 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -598,19 +598,16 @@ struct nes_adapter *nes_init_adapter(struct nes_device *nesdev, u8 hw_rev) {
 	}
 
 	if (nesadapter->hw_rev == NE020_REV) {
-		init_timer(&nesadapter->mh_timer);
-		nesadapter->mh_timer.function = nes_mh_fix;
+		setup_timer(&nesadapter->mh_timer, nes_mh_fix,
+			    (unsigned long)nesdev);
 		nesadapter->mh_timer.expires = jiffies + (HZ/5);  /* 1 second */
-		nesadapter->mh_timer.data = (unsigned long)nesdev;
 		add_timer(&nesadapter->mh_timer);
 	} else {
 		nes_write32(nesdev->regs+NES_INTF_INT_STAT, 0x0f000000);
 	}
 
-	init_timer(&nesadapter->lc_timer);
-	nesadapter->lc_timer.function = nes_clc;
+	setup_timer(&nesadapter->lc_timer, nes_clc, (unsigned long)nesdev);
 	nesadapter->lc_timer.expires = jiffies + 3600 * HZ;  /* 1 hour */
-	nesadapter->lc_timer.data = (unsigned long)nesdev;
 	add_timer(&nesadapter->lc_timer);
 
 	list_add_tail(&nesadapter->list, &nes_adapter_list);
diff --git a/drivers/infiniband/hw/nes/nes_nic.c b/drivers/infiniband/hw/nes/nes_nic.c
index 5921ea3..e4fb0ad 100644
--- a/drivers/infiniband/hw/nes/nes_nic.c
+++ b/drivers/infiniband/hw/nes/nes_nic.c
@@ -1746,8 +1746,7 @@ struct net_device *nes_netdev_init(struct nes_device *nesdev,
 		nesvnic->rdma_enabled = 0;
 	}
 	nesvnic->nic_cq.cq_number = nesvnic->nic.qp_id;
-	init_timer(&nesvnic->event_timer);
-	nesvnic->event_timer.function = NULL;
+	setup_timer(&nesvnic->event_timer, NULL, 0UL);
 	spin_lock_init(&nesvnic->tx_lock);
 	spin_lock_init(&nesvnic->port_ibevent_lock);
 	nesdev->netdev[nesdev->netdev_count] = netdev;
diff --git a/drivers/infiniband/hw/qib/qib_driver.c b/drivers/infiniband/hw/qib/qib_driver.c
index 719906a..6dfcc4f 100644
--- a/drivers/infiniband/hw/qib/qib_driver.c
+++ b/drivers/infiniband/hw/qib/qib_driver.c
@@ -735,9 +735,8 @@ void qib_set_led_override(struct qib_pportdata *ppd, unsigned int val)
 	 */
 	if (atomic_inc_return(&ppd->led_override_timer_active) == 1) {
 		/* Need to start timer */
-		init_timer(&ppd->led_override_timer);
-		ppd->led_override_timer.function = qib_run_led_override;
-		ppd->led_override_timer.data = (unsigned long) ppd;
+		setup_timer(&ppd->led_override_timer, qib_run_led_override,
+			    (unsigned long)ppd);
 		ppd->led_override_timer.expires = jiffies + 1;
 		add_timer(&ppd->led_override_timer);
 	} else {
diff --git a/drivers/infiniband/hw/qib/qib_iba7220.c b/drivers/infiniband/hw/qib/qib_iba7220.c
index 04bdd3d..51a9266 100644
--- a/drivers/infiniband/hw/qib/qib_iba7220.c
+++ b/drivers/infiniband/hw/qib/qib_iba7220.c
@@ -4095,9 +4095,8 @@ static int qib_init_7220_variables(struct qib_devdata *dd)
 	dd->rhdrhead_intr_off = 1ULL << 32;
 
 	/* setup the stats timer; the add_timer is done at end of init */
-	init_timer(&dd->stats_timer);
-	dd->stats_timer.function = qib_get_7220_faststats;
-	dd->stats_timer.data = (unsigned long) dd;
+	setup_timer(&dd->stats_timer, qib_get_7220_faststats,
+		    (unsigned long)dd);
 	dd->stats_timer.expires = jiffies + ACTIVITY_TIMER * HZ;
 
 	/*
diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index 82d9da9..f3d4511 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -2478,10 +2478,9 @@ void qib_notify_create_mad_agent(struct rvt_dev_info *rdi, int port_idx)
 
 	/* Initialize xmit_wait structure */
 	dd->pport[port_idx].cong_stats.counter = 0;
-	init_timer(&dd->pport[port_idx].cong_stats.timer);
-	dd->pport[port_idx].cong_stats.timer.function = xmit_wait_timer_func;
-	dd->pport[port_idx].cong_stats.timer.data =
-		(unsigned long)(&dd->pport[port_idx]);
+	setup_timer(&dd->pport[port_idx].cong_stats.timer,
+		    xmit_wait_timer_func,
+		    (unsigned long)(&dd->pport[port_idx]));
 	dd->pport[port_idx].cong_stats.timer.expires = 0;
 	add_timer(&dd->pport[port_idx].cong_stats.timer);
 }
diff --git a/drivers/infiniband/hw/qib/qib_sd7220.c b/drivers/infiniband/hw/qib/qib_sd7220.c
index c72775f..525b516 100644
--- a/drivers/infiniband/hw/qib/qib_sd7220.c
+++ b/drivers/infiniband/hw/qib/qib_sd7220.c
@@ -1440,9 +1440,8 @@ void set_7220_relock_poll(struct qib_devdata *dd, int ibup)
 		/* If timer has not yet been started, do so. */
 		if (!cs->relock_timer_active) {
 			cs->relock_timer_active = 1;
-			init_timer(&cs->relock_timer);
-			cs->relock_timer.function = qib_run_relock;
-			cs->relock_timer.data = (unsigned long) dd;
+			setup_timer(&cs->relock_timer, qib_run_relock,
+				    (unsigned long)dd);
 			cs->relock_interval = timeout;
 			cs->relock_timer.expires = jiffies + timeout;
 			add_timer(&cs->relock_timer);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
