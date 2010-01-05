From: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCHv7 2/9] ib_core: RoCEE support only QP1
Date: Tue, 5 Jan 2010 12:32:37 +0200
Message-ID: <20100105103237.GD31480@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Since RoCEE is using Ethernet as its link layer, there is no need for QP0.  QP1
is still needed since it handles communications between CM agents. This patch
will create only QP1 for RoCEE ports.

    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/core/agent.c     |   37 ++++++++++++-------
 drivers/infiniband/core/mad.c       |   66 ++++++++++++++++++++++++-----------
 drivers/infiniband/core/multicast.c |   25 +++++++++++--
 drivers/infiniband/core/sa_query.c  |   39 +++++++++++++-------
 4 files changed, 114 insertions(+), 53 deletions(-)

diff --git a/drivers/infiniband/core/agent.c b/drivers/infiniband/core/agent.c
index ae7c288..964f4fb 100644
--- a/drivers/infiniband/core/agent.c
+++ b/drivers/infiniband/core/agent.c
@@ -48,6 +48,8 @@
 struct ib_agent_port_private {
 	struct list_head port_list;
 	struct ib_mad_agent *agent[2];
+	struct ib_device    *device;
+	u8		     port_num;
 };
 
 static DEFINE_SPINLOCK(ib_agent_port_list_lock);
@@ -58,11 +60,10 @@ __ib_get_agent_port(struct ib_device *device, int port_num)
 {
 	struct ib_agent_port_private *entry;
 
-	list_for_each_entry(entry, &ib_agent_port_list, port_list) {
-		if (entry->agent[0]->device == device &&
-		    entry->agent[0]->port_num == port_num)
+	list_for_each_entry(entry, &ib_agent_port_list, port_list)
+		if (entry->device == device && entry->port_num == port_num)
 			return entry;
-	}
+
 	return NULL;
 }
 
@@ -155,14 +156,16 @@ int ib_agent_port_open(struct ib_device *device, int port_num)
 		goto error1;
 	}
 
-	/* Obtain send only MAD agent for SMI QP */
-	port_priv->agent[0] = ib_register_mad_agent(device, port_num,
-						    IB_QPT_SMI, NULL, 0,
-						    &agent_send_handler,
-						    NULL, NULL);
-	if (IS_ERR(port_priv->agent[0])) {
-		ret = PTR_ERR(port_priv->agent[0]);
-		goto error2;
+	if (rdma_port_link_layer(device, port_num) == IB_LINK_LAYER_INFINIBAND) {
+		/* Obtain send only MAD agent for SMI QP */
+		port_priv->agent[0] = ib_register_mad_agent(device, port_num,
+							    IB_QPT_SMI, NULL, 0,
+							    &agent_send_handler,
+							    NULL, NULL);
+		if (IS_ERR(port_priv->agent[0])) {
+			ret = PTR_ERR(port_priv->agent[0]);
+			goto error2;
+		}
 	}
 
 	/* Obtain send only MAD agent for GSI QP */
@@ -175,6 +178,9 @@ int ib_agent_port_open(struct ib_device *device, int port_num)
 		goto error3;
 	}
 
+	port_priv->device = device;
+	port_priv->port_num = port_num;
+
 	spin_lock_irqsave(&ib_agent_port_list_lock, flags);
 	list_add_tail(&port_priv->port_list, &ib_agent_port_list);
 	spin_unlock_irqrestore(&ib_agent_port_list_lock, flags);
@@ -182,7 +188,8 @@ int ib_agent_port_open(struct ib_device *device, int port_num)
 	return 0;
 
 error3:
-	ib_unregister_mad_agent(port_priv->agent[0]);
+	if (rdma_port_link_layer(device, port_num) == IB_LINK_LAYER_INFINIBAND)
+		ib_unregister_mad_agent(port_priv->agent[0]);
 error2:
 	kfree(port_priv);
 error1:
@@ -205,7 +212,9 @@ int ib_agent_port_close(struct ib_device *device, int port_num)
 	spin_unlock_irqrestore(&ib_agent_port_list_lock, flags);
 
 	ib_unregister_mad_agent(port_priv->agent[1]);
-	ib_unregister_mad_agent(port_priv->agent[0]);
+	if (rdma_port_link_layer(device, port_num) == IB_LINK_LAYER_INFINIBAND)
+		ib_unregister_mad_agent(port_priv->agent[0]);
+
 	kfree(port_priv);
 	return 0;
 }
diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 7522008..47d27a3 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -2610,6 +2610,9 @@ static void cleanup_recv_queue(struct ib_mad_qp_info *qp_info)
 	struct ib_mad_private *recv;
 	struct ib_mad_list_head *mad_list;
 
+	if (!qp_info->qp)
+		return;
+
 	while (!list_empty(&qp_info->recv_queue.list)) {
 
 		mad_list = list_entry(qp_info->recv_queue.list.next,
@@ -2651,6 +2654,9 @@ static int ib_mad_port_start(struct ib_mad_port_private *port_priv)
 
 	for (i = 0; i < IB_MAD_QPS_CORE; i++) {
 		qp = port_priv->qp_info[i].qp;
+		if (!qp)
+			continue;
+
 		/*
 		 * PKey index for QP1 is irrelevant but
 		 * one is needed for the Reset to Init transition
@@ -2692,6 +2698,9 @@ static int ib_mad_port_start(struct ib_mad_port_private *port_priv)
 	}
 
 	for (i = 0; i < IB_MAD_QPS_CORE; i++) {
+		if (!port_priv->qp_info[i].qp)
+			continue;
+
 		ret = ib_mad_post_receive_mads(&port_priv->qp_info[i], NULL);
 		if (ret) {
 			printk(KERN_ERR PFX "Couldn't post receive WRs\n");
@@ -2770,6 +2779,9 @@ error:
 
 static void destroy_mad_qp(struct ib_mad_qp_info *qp_info)
 {
+	if (!qp_info->qp)
+		return;
+
 	ib_destroy_qp(qp_info->qp);
 	kfree(qp_info->snoop_table);
 }
@@ -2785,6 +2797,7 @@ static int ib_mad_port_open(struct ib_device *device,
 	struct ib_mad_port_private *port_priv;
 	unsigned long flags;
 	char name[sizeof "ib_mad123"];
+	int has_smi;
 
 	/* Create new device info */
 	port_priv = kzalloc(sizeof *port_priv, GFP_KERNEL);
@@ -2800,7 +2813,11 @@ static int ib_mad_port_open(struct ib_device *device,
 	init_mad_qp(port_priv, &port_priv->qp_info[0]);
 	init_mad_qp(port_priv, &port_priv->qp_info[1]);
 
-	cq_size = (mad_sendq_size + mad_recvq_size) * 2;
+	cq_size = mad_sendq_size + mad_recvq_size;
+	has_smi = rdma_port_link_layer(device, port_num) == IB_LINK_LAYER_INFINIBAND;
+	if (has_smi)
+		cq_size *= 2;
+
 	port_priv->cq = ib_create_cq(port_priv->device,
 				     ib_mad_thread_completion_handler,
 				     NULL, port_priv, cq_size, 0);
@@ -2824,9 +2841,11 @@ static int ib_mad_port_open(struct ib_device *device,
 		goto error5;
 	}
 
-	ret = create_mad_qp(&port_priv->qp_info[0], IB_QPT_SMI);
-	if (ret)
-		goto error6;
+	if (has_smi) {
+		ret = create_mad_qp(&port_priv->qp_info[0], IB_QPT_SMI);
+		if (ret)
+			goto error6;
+	}
 	ret = create_mad_qp(&port_priv->qp_info[1], IB_QPT_GSI);
 	if (ret)
 		goto error7;
@@ -2941,21 +2960,24 @@ static void ib_mad_init_device(struct ib_device *device)
 	return;
 
 error_agent:
-	if (ib_mad_port_close(device, i))
-		printk(KERN_ERR PFX "Couldn't close %s port %d\n",
-		       device->name, i);
+	if (rdma_node_get_transport(device->node_type) == RDMA_TRANSPORT_IB)
+		if (ib_mad_port_close(device, i))
+			printk(KERN_ERR PFX "Couldn't close %s port %d\n",
+			       device->name, i);
 
 error:
 	i--;
 
 	while (i >= start) {
-		if (ib_agent_port_close(device, i))
-			printk(KERN_ERR PFX "Couldn't close %s port %d "
-			       "for agents\n",
-			       device->name, i);
-		if (ib_mad_port_close(device, i))
-			printk(KERN_ERR PFX "Couldn't close %s port %d\n",
-			       device->name, i);
+		if (rdma_node_get_transport(device->node_type) == RDMA_TRANSPORT_IB) {
+			if (ib_agent_port_close(device, i))
+				printk(KERN_ERR PFX "Couldn't close %s port %d "
+				       "for agents\n",
+				       device->name, i);
+			if (ib_mad_port_close(device, i))
+				printk(KERN_ERR PFX "Couldn't close %s port %d\n",
+				       device->name, i);
+		}
 		i--;
 	}
 }
@@ -2972,13 +2994,15 @@ static void ib_mad_remove_device(struct ib_device *device)
 		cur_port = 1;
 	}
 	for (i = 0; i < num_ports; i++, cur_port++) {
-		if (ib_agent_port_close(device, cur_port))
-			printk(KERN_ERR PFX "Couldn't close %s port %d "
-			       "for agents\n",
-			       device->name, cur_port);
-		if (ib_mad_port_close(device, cur_port))
-			printk(KERN_ERR PFX "Couldn't close %s port %d\n",
-			       device->name, cur_port);
+		if (rdma_node_get_transport(device->node_type) == RDMA_TRANSPORT_IB) {
+			if (ib_agent_port_close(device, cur_port))
+				printk(KERN_ERR PFX "Couldn't close %s port %d "
+				       "for agents\n",
+				       device->name, cur_port);
+			if (ib_mad_port_close(device, cur_port))
+				printk(KERN_ERR PFX "Couldn't close %s port %d\n",
+				       device->name, cur_port);
+		}
 	}
 }
 
diff --git a/drivers/infiniband/core/multicast.c b/drivers/infiniband/core/multicast.c
index 8d82ba1..55f24ff 100644
--- a/drivers/infiniband/core/multicast.c
+++ b/drivers/infiniband/core/multicast.c
@@ -773,6 +773,10 @@ static void mcast_event_handler(struct ib_event_handler *handler,
 	int index;
 
 	dev = container_of(handler, struct mcast_device, event_handler);
+	if (rdma_port_link_layer(dev->device, event->element.port_num) !=
+	    IB_LINK_LAYER_INFINIBAND)
+		return;
+
 	index = event->element.port_num - dev->start_port;
 
 	switch (event->event) {
@@ -795,11 +799,12 @@ static void mcast_add_one(struct ib_device *device)
 	struct mcast_device *dev;
 	struct mcast_port *port;
 	int i;
+	int count = 0;
 
 	if (rdma_node_get_transport(device->node_type) != RDMA_TRANSPORT_IB)
 		return;
 
-	dev = kmalloc(sizeof *dev + device->phys_port_cnt * sizeof *port,
+	dev = kzalloc(sizeof *dev + device->phys_port_cnt * sizeof *port,
 		      GFP_KERNEL);
 	if (!dev)
 		return;
@@ -812,6 +817,9 @@ static void mcast_add_one(struct ib_device *device)
 	}
 
 	for (i = 0; i <= dev->end_port - dev->start_port; i++) {
+		if (rdma_port_link_layer(device, dev->start_port + i) !=
+		    IB_LINK_LAYER_INFINIBAND)
+			continue;
 		port = &dev->port[i];
 		port->dev = dev;
 		port->port_num = dev->start_port + i;
@@ -819,6 +827,12 @@ static void mcast_add_one(struct ib_device *device)
 		port->table = RB_ROOT;
 		init_completion(&port->comp);
 		atomic_set(&port->refcount, 1);
+		++count;
+	}
+
+	if (!count) {
+		kfree(dev);
+		return;
 	}
 
 	dev->device = device;
@@ -842,9 +856,12 @@ static void mcast_remove_one(struct ib_device *device)
 	flush_workqueue(mcast_wq);
 
 	for (i = 0; i <= dev->end_port - dev->start_port; i++) {
-		port = &dev->port[i];
-		deref_port(port);
-		wait_for_completion(&port->comp);
+		if (rdma_port_link_layer(device, dev->start_port + i) ==
+		    IB_LINK_LAYER_INFINIBAND) {
+			port = &dev->port[i];
+			deref_port(port);
+			wait_for_completion(&port->comp);
+		}
 	}
 
 	kfree(dev);
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 7e1ffd8..824e29b 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -416,14 +416,17 @@ static void ib_sa_event(struct ib_event_handler *handler, struct ib_event *event
 		struct ib_sa_port *port =
 			&sa_dev->port[event->element.port_num - sa_dev->start_port];
 
-		spin_lock_irqsave(&port->ah_lock, flags);
-		if (port->sm_ah)
-			kref_put(&port->sm_ah->ref, free_sm_ah);
-		port->sm_ah = NULL;
-		spin_unlock_irqrestore(&port->ah_lock, flags);
-
-		schedule_work(&sa_dev->port[event->element.port_num -
-					    sa_dev->start_port].update_task);
+		if (rdma_port_link_layer(handler->device, port->port_num) == IB_LINK_LAYER_INFINIBAND) {
+			spin_lock_irqsave(&port->ah_lock, flags);
+			if (port->sm_ah)
+				kref_put(&port->sm_ah->ref, free_sm_ah);
+			port->sm_ah = NULL;
+			spin_unlock_irqrestore(&port->ah_lock, flags);
+
+			schedule_work(&sa_dev->port[event->element.port_num -
+				      sa_dev->start_port].update_task);
+		}
+
 	}
 }
 
@@ -1007,7 +1010,7 @@ static void ib_sa_add_one(struct ib_device *device)
 		e = device->phys_port_cnt;
 	}
 
-	sa_dev = kmalloc(sizeof *sa_dev +
+	sa_dev = kzalloc(sizeof *sa_dev +
 			 (e - s + 1) * sizeof (struct ib_sa_port),
 			 GFP_KERNEL);
 	if (!sa_dev)
@@ -1017,6 +1020,9 @@ static void ib_sa_add_one(struct ib_device *device)
 	sa_dev->end_port   = e;
 
 	for (i = 0; i <= e - s; ++i) {
+		if (rdma_port_link_layer(device, i + 1) != IB_LINK_LAYER_INFINIBAND)
+			continue;
+
 		sa_dev->port[i].sm_ah    = NULL;
 		sa_dev->port[i].port_num = i + s;
 		spin_lock_init(&sa_dev->port[i].ah_lock);
@@ -1045,13 +1051,15 @@ static void ib_sa_add_one(struct ib_device *device)
 		goto err;
 
 	for (i = 0; i <= e - s; ++i)
-		update_sm_ah(&sa_dev->port[i].update_task);
+		if (rdma_port_link_layer(device, i + 1) == IB_LINK_LAYER_INFINIBAND)
+			update_sm_ah(&sa_dev->port[i].update_task);
 
 	return;
 
 err:
 	while (--i >= 0)
-		ib_unregister_mad_agent(sa_dev->port[i].agent);
+		if (rdma_port_link_layer(device, i + 1) == IB_LINK_LAYER_INFINIBAND)
+			ib_unregister_mad_agent(sa_dev->port[i].agent);
 
 	kfree(sa_dev);
 
@@ -1071,9 +1079,12 @@ static void ib_sa_remove_one(struct ib_device *device)
 	flush_scheduled_work();
 
 	for (i = 0; i <= sa_dev->end_port - sa_dev->start_port; ++i) {
-		ib_unregister_mad_agent(sa_dev->port[i].agent);
-		if (sa_dev->port[i].sm_ah)
-			kref_put(&sa_dev->port[i].sm_ah->ref, free_sm_ah);
+		if (rdma_port_link_layer(device, i + 1) == IB_LINK_LAYER_INFINIBAND) {
+			ib_unregister_mad_agent(sa_dev->port[i].agent);
+			if (sa_dev->port[i].sm_ah)
+				kref_put(&sa_dev->port[i].sm_ah->ref, free_sm_ah);
+		}
+
 	}
 
 	kfree(sa_dev);
-- 
1.6.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
