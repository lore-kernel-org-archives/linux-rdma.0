From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next v1 05/22] RDMA/(core,ulp): Convert register/unregister event handler to be void
Date: Sun, 13 Aug 2017 13:17:59 +0300
Message-ID: <20170813101816.3120-6-leon@kernel.org>
References: <20170813101816.3120-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170813101816.3120-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The functions ib_register_event_handler() and
ib_unregister_event_handler() always returned success and they can't fail.

Let's convert those functions to be void, remove redundant checks and
cleanup tons of goto statements.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cache.c                 | 23 ++++++++---------------
 drivers/infiniband/core/device.c                |  8 ++------
 drivers/infiniband/core/sa_query.c              |  3 +--
 drivers/infiniband/core/uverbs_main.c           | 13 +------------
 drivers/infiniband/ulp/ipoib/ipoib_main.c       | 10 +---------
 drivers/infiniband/ulp/iser/iser_verbs.c        |  6 ++----
 drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c |  7 +------
 drivers/infiniband/ulp/srpt/ib_srpt.c           |  5 ++---
 include/rdma/ib_verbs.h                         |  4 ++--
 9 files changed, 20 insertions(+), 59 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index efc94304dee3..77515638c55c 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -1199,30 +1199,23 @@ int ib_cache_setup_one(struct ib_device *device)
 	device->cache.ports =
 		kzalloc(sizeof(*device->cache.ports) *
 			(rdma_end_port(device) - rdma_start_port(device) + 1), GFP_KERNEL);
-	if (!device->cache.ports) {
-		err = -ENOMEM;
-		goto out;
-	}
+	if (!device->cache.ports)
+		return -ENOMEM;
 
 	err = gid_table_setup_one(device);
-	if (err)
-		goto out;
+	if (err) {
+		kfree(device->cache.ports);
+		device->cache.ports = NULL;
+		return err;
+	}
 
 	for (p = 0; p <= rdma_end_port(device) - rdma_start_port(device); ++p)
 		ib_cache_update(device, p + rdma_start_port(device), true);
 
 	INIT_IB_EVENT_HANDLER(&device->cache.event_handler,
 			      device, ib_cache_event);
-	err = ib_register_event_handler(&device->cache.event_handler);
-	if (err)
-		goto err;
-
+	ib_register_event_handler(&device->cache.event_handler);
 	return 0;
-
-err:
-	gid_table_cleanup_one(device);
-out:
-	return err;
 }
 
 void ib_cache_release_one(struct ib_device *device)
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index fbc92c649be8..475b93d62748 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -746,7 +746,7 @@ EXPORT_SYMBOL(ib_set_client_data);
  * chapter 11 of the InfiniBand Architecture Specification).  This
  * callback may occur in interrupt context.
  */
-int ib_register_event_handler  (struct ib_event_handler *event_handler)
+void ib_register_event_handler(struct ib_event_handler *event_handler)
 {
 	unsigned long flags;
 
@@ -754,8 +754,6 @@ int ib_register_event_handler  (struct ib_event_handler *event_handler)
 	list_add_tail(&event_handler->list,
 		      &event_handler->device->event_handler_list);
 	spin_unlock_irqrestore(&event_handler->device->event_handler_lock, flags);
-
-	return 0;
 }
 EXPORT_SYMBOL(ib_register_event_handler);
 
@@ -766,15 +764,13 @@ EXPORT_SYMBOL(ib_register_event_handler);
  * Unregister an event handler registered with
  * ib_register_event_handler().
  */
-int ib_unregister_event_handler(struct ib_event_handler *event_handler)
+void ib_unregister_event_handler(struct ib_event_handler *event_handler)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&event_handler->device->event_handler_lock, flags);
 	list_del(&event_handler->list);
 	spin_unlock_irqrestore(&event_handler->device->event_handler_lock, flags);
-
-	return 0;
 }
 EXPORT_SYMBOL(ib_unregister_event_handler);
 
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index da29e2863c84..14aef0dd8625 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -2408,8 +2408,7 @@ static void ib_sa_add_one(struct ib_device *device)
 	 */
 
 	INIT_IB_EVENT_HANDLER(&sa_dev->event_handler, device, ib_sa_event);
-	if (ib_register_event_handler(&sa_dev->event_handler))
-		goto err;
+	ib_register_event_handler(&sa_dev->event_handler);
 
 	for (i = 0; i <= e - s; ++i) {
 		if (rdma_cap_ib_sa(device, i + 1))
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 3d2609608f58..1ac99aec3d4e 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -594,7 +594,6 @@ struct file *ib_uverbs_alloc_async_event_file(struct ib_uverbs_file *uverbs_file
 {
 	struct ib_uverbs_async_event_file *ev_file;
 	struct file *filp;
-	int ret;
 
 	ev_file = kzalloc(sizeof(*ev_file), GFP_KERNEL);
 	if (!ev_file)
@@ -620,21 +619,11 @@ struct file *ib_uverbs_alloc_async_event_file(struct ib_uverbs_file *uverbs_file
 	INIT_IB_EVENT_HANDLER(&uverbs_file->event_handler,
 			      ib_dev,
 			      ib_uverbs_event_handler);
-	ret = ib_register_event_handler(&uverbs_file->event_handler);
-	if (ret)
-		goto err_put_file;
-
+	ib_register_event_handler(&uverbs_file->event_handler);
 	/* At that point async file stuff was fully set */
 
 	return filp;
 
-err_put_file:
-	fput(filp);
-	kref_put(&uverbs_file->async_file->ref,
-		 ib_uverbs_release_async_event_file);
-	uverbs_file->async_file = NULL;
-	return ERR_PTR(ret);
-
 err_put_refs:
 	kref_put(&ev_file->uverbs_file->ref, ib_uverbs_release_file);
 	kref_put(&ev_file->ref, ib_uverbs_release_async_event_file);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 7dcdbbacbf46..645217232250 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -2223,13 +2223,7 @@ static struct net_device *ipoib_add_port(const char *format,
 
 	INIT_IB_EVENT_HANDLER(&priv->event_handler,
 			      priv->ca, ipoib_event);
-	result = ib_register_event_handler(&priv->event_handler);
-	if (result < 0) {
-		printk(KERN_WARNING "%s: ib_register_event_handler failed for "
-		       "port %d (ret = %d)\n",
-		       hca->name, port, result);
-		goto event_failed;
-	}
+	ib_register_event_handler(&priv->event_handler);
 
 	result = register_netdev(priv->dev);
 	if (result) {
@@ -2262,8 +2256,6 @@ static struct net_device *ipoib_add_port(const char *format,
 	set_bit(IPOIB_STOP_NEIGH_GC, &priv->flags);
 	cancel_delayed_work(&priv->neigh_reap_task);
 	flush_workqueue(priv->wq);
-
-event_failed:
 	ipoib_dev_cleanup(priv->dev);
 
 device_init_failed:
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 26a004e97ae0..55a73b0ed4c6 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -106,9 +106,7 @@ static int iser_create_device_ib_res(struct iser_device *device)
 
 	INIT_IB_EVENT_HANDLER(&device->event_handler, ib_dev,
 			      iser_event_handler);
-	if (ib_register_event_handler(&device->event_handler))
-		goto cq_err;
-
+	ib_register_event_handler(&device->event_handler);
 	return 0;
 
 cq_err:
@@ -141,7 +139,7 @@ static void iser_free_device_ib_res(struct iser_device *device)
 		comp->cq = NULL;
 	}
 
-	(void)ib_unregister_event_handler(&device->event_handler);
+	ib_unregister_event_handler(&device->event_handler);
 	ib_dealloc_pd(device->pd);
 
 	kfree(device->comps);
diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c b/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
index 57b862b94dca..21f0b481edcc 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
@@ -954,12 +954,7 @@ static int vema_register(struct opa_vnic_ctrl_port *cport)
 
 		INIT_IB_EVENT_HANDLER(&port->event_handler,
 				      cport->ibdev, opa_vnic_event);
-		ret = ib_register_event_handler(&port->event_handler);
-		if (ret) {
-			c_err("port %d: event handler register failed\n", i);
-			vema_unregister(cport);
-			return ret;
-		}
+		ib_register_event_handler(&port->event_handler);
 
 		idr_init(&port->vport_idr);
 		mutex_init(&port->lock);
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 402275be0931..9e8e9220f816 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2238,7 +2238,7 @@ static int srpt_write_pending(struct se_cmd *se_cmd)
 				cqe, first_wr);
 		cqe = NULL;
 	}
-	
+
 	ret = ib_post_send(ch->qp, first_wr, &bad_wr);
 	if (ret) {
 		pr_err("%s: ib_post_send() returned %d for %d (avail: %d)\n",
@@ -2530,8 +2530,7 @@ static void srpt_add_one(struct ib_device *device)
 
 	INIT_IB_EVENT_HANDLER(&sdev->event_handler, sdev->device,
 			      srpt_event_handler);
-	if (ib_register_event_handler(&sdev->event_handler))
-		goto err_cm;
+	ib_register_event_handler(&sdev->event_handler);
 
 	sdev->ioctx_ring = (struct srpt_recv_ioctx **)
 		srpt_alloc_ioctx_ring(sdev, sdev->srq_size,
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 4db4ad56ace6..3c9c514bcd7d 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2411,8 +2411,8 @@ int ib_modify_qp_is_ok(enum ib_qp_state cur_state, enum ib_qp_state next_state,
 		       enum ib_qp_type type, enum ib_qp_attr_mask mask,
 		       enum rdma_link_layer ll);
 
-int ib_register_event_handler  (struct ib_event_handler *event_handler);
-int ib_unregister_event_handler(struct ib_event_handler *event_handler);
+void ib_register_event_handler(struct ib_event_handler *event_handler);
+void ib_unregister_event_handler(struct ib_event_handler *event_handler);
 void ib_dispatch_event(struct ib_event *event);
 
 int ib_query_port(struct ib_device *device,
-- 
2.14.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
