From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/3] ib/iser: add event handler
Date: Wed, 5 May 2010 17:30:10 +0300 (IDT)
Message-ID: <Pine.LNX.4.64.1005051729300.29957@zuben.voltaire.com>
References: <Pine.LNX.4.64.1005051726110.29957@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.1005051726110.29957-aDiYczhfhVLdX2U7gxhm1tBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add handler to mark events such as port up and down, this is useful
when testing high-availability schemes such as multi-pathing

Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>

---
 drivers/infiniband/ulp/iser/iscsi_iser.h |    1 +
 drivers/infiniband/ulp/iser/iser_verbs.c |   16 +++++++++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

Index: linux-2.6.34-rc6/drivers/infiniband/ulp/iser/iscsi_iser.h
===================================================================
--- linux-2.6.34-rc6.orig/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ linux-2.6.34-rc6/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -232,6 +232,7 @@ struct iser_device {
 	struct ib_cq	             *tx_cq;
 	struct ib_mr	             *mr;
 	struct tasklet_struct	     cq_tasklet;
+	struct ib_event_handler      event_handler;
 	struct list_head             ig_list; /* entry in ig devices list */
 	int                          refcount;
 };
Index: linux-2.6.34-rc6/drivers/infiniband/ulp/iser/iser_verbs.c
===================================================================
--- linux-2.6.34-rc6.orig/drivers/infiniband/ulp/iser/iser_verbs.c
+++ linux-2.6.34-rc6/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -54,6 +54,13 @@ static void iser_qp_event_callback(struc
 	iser_err("got qp event %d\n",cause->event);
 }

+static void iser_event_handler(struct ib_event_handler *handler,
+				struct ib_event *event)
+{
+	iser_err("async event %d on device %s port %d\n", event->event,
+		event->device->name, event->element.port_num);
+}
+
 /**
  * iser_create_device_ib_res - creates Protection Domain (PD), Completion
  * Queue (CQ), DMA Memory Region (DMA MR) with the device associated with
@@ -96,8 +103,15 @@ static int iser_create_device_ib_res(str
 	if (IS_ERR(device->mr))
 		goto dma_mr_err;

+	INIT_IB_EVENT_HANDLER(&device->event_handler, device->ib_device,
+				iser_event_handler);
+	if (ib_register_event_handler(&device->event_handler))
+		goto handler_err;
+
 	return 0;

+handler_err:
+	ib_dereg_mr(device->mr);
 dma_mr_err:
 	tasklet_kill(&device->cq_tasklet);
 cq_arm_err:
@@ -120,7 +134,7 @@ static void iser_free_device_ib_res(stru
 	BUG_ON(device->mr == NULL);

 	tasklet_kill(&device->cq_tasklet);
-
+	(void)ib_unregister_event_handler(&device->event_handler);
 	(void)ib_dereg_mr(device->mr);
 	(void)ib_destroy_cq(device->tx_cq);
 	(void)ib_destroy_cq(device->rx_cq);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
