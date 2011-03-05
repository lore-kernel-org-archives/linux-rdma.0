From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 6/7] ibacm: Handle port up events
Date: Fri, 4 Mar 2011 16:05:50 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CC92EACE@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Handle port up events.  The IB ACM service only checks once
during initialization for active ports to use.  If a port later
becomes available, the service will not be able to use it. 

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |  114 ++++++++++++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 83 insertions(+), 31 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 3590c16..2570fdc 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -2499,14 +2499,37 @@ static int acm_init_ep_loopback(struct acm_ep *ep)
 	return 0;
 }
 
-static int acm_ep_up(struct acm_port *port, struct acm_ep *ep, uint16_t pkey_index)
+static struct acm_ep *acm_find_ep(struct acm_port *port, uint16_t pkey)
 {
-	struct ibv_qp_init_attr init_attr;
-	struct ibv_qp_attr attr;
-	int ret, sq_size;
+	struct acm_ep *ep, *res = NULL;
+	DLIST_ENTRY *entry;
+
+	acm_log(2, "pkey 0x%x\n", pkey);
+
+	lock_acquire(&port->lock);
+	for (entry = port->ep_list.Next; entry != &port->ep_list; entry = entry->Next) {
+		ep = container_of(entry, struct acm_ep, entry);
+		if (ep->pkey == pkey) {
+			res = ep;
+			break;
+		}
+	}
+	lock_release(&port->lock);
+	return res;
+}
+
+static struct acm_ep *
+acm_alloc_ep(struct acm_port *port, uint16_t pkey, uint16_t pkey_index)
+{
+	struct acm_ep *ep;
 
 	acm_log(1, "\n");
+	ep = calloc(1, sizeof *ep);
+	if (!ep)
+		return NULL;
+
 	ep->port = port;
+	ep->pkey = pkey;
 	ep->pkey_index = pkey_index;
 	ep->resolve_queue.credits = resolve_depth;
 	ep->sa_queue.credits = sa_depth;
@@ -2517,15 +2540,36 @@ static int acm_ep_up(struct acm_port *port, struct acm_ep *ep, uint16_t pkey_ind
 	DListInit(&ep->active_queue);
 	DListInit(&ep->wait_queue);
 	lock_init(&ep->lock);
+	return ep;
+}
 
-	ret = ibv_query_pkey(port->dev->verbs, port->port_num, pkey_index, &ep->pkey);
+static void acm_ep_up(struct acm_port *port, uint16_t pkey_index)
+{
+	struct acm_ep *ep;
+	struct ibv_qp_init_attr init_attr;
+	struct ibv_qp_attr attr;
+	int ret, sq_size;
+	uint16_t pkey;
+
+	acm_log(1, "\n");
+	ret = ibv_query_pkey(port->dev->verbs, port->port_num, pkey_index, &pkey);
 	if (ret)
-		return ACM_STATUS_EINVAL;
+		return;
+
+	if (acm_find_ep(port, pkey)) {
+		acm_log(2, "endpoint for pkey 0x%x already exists\n", pkey);
+		return;
+	}
+
+	acm_log(2, "creating endpoint for pkey 0x%x\n", pkey);
+	ep = acm_alloc_ep(port, pkey, pkey_index);
+	if (!ep)
+		return;
 
 	ret = acm_assign_ep_names(ep);
 	if (ret) {
 		acm_log(0, "ERROR - unable to assign EP name\n");
-		return ret;
+		goto err0;
 	}
 
 	sq_size = resolve_depth + sa_depth + send_depth;
@@ -2533,7 +2577,7 @@ static int acm_ep_up(struct acm_port *port, struct acm_ep *ep, uint16_t pkey_ind
 		ep, port->dev->channel, 0);
 	if (!ep->cq) {
 		acm_log(0, "ERROR - failed to create CQ\n");
-		return -1;
+		goto err0;
 	}
 
 	ret = ibv_req_notify_cq(ep->cq, 0);
@@ -2593,13 +2637,17 @@ static int acm_ep_up(struct acm_port *port, struct acm_ep *ep, uint16_t pkey_ind
 		acm_log(0, "ERROR - unable to init loopback\n");
 		goto err2;
 	}
-	return 0;
+	lock_acquire(&port->lock);
+	DListInsertHead(&ep->entry, &port->ep_list);
+	lock_release(&port->lock);
+	return;
 
 err2:
 	ibv_destroy_qp(ep->qp);
 err1:
 	ibv_destroy_cq(ep->cq);
-	return -1;
+err0:
+	free(ep);
 }
 
 static void acm_port_up(struct acm_port *port)
@@ -2607,7 +2655,6 @@ static void acm_port_up(struct acm_port *port)
 	struct ibv_port_attr attr;
 	union ibv_gid gid;
 	uint16_t pkey;
-	struct acm_ep *ep;
 	int i, ret;
 
 	acm_log(1, "%s %d\n", port->dev->verbs->device->name, port->port_num);
@@ -2624,13 +2671,13 @@ static void acm_port_up(struct acm_port *port)
 	port->mtu = attr.active_mtu;
 	port->rate = acm_get_rate(attr.active_width, attr.active_speed);
 	port->subnet_timeout = 1 << (attr.subnet_timeout - 8);
-	for (;; port->gid_cnt++) {
+	for (port->gid_cnt = 0;; port->gid_cnt++) {
 		ret = ibv_query_gid(port->dev->verbs, port->port_num, port->gid_cnt, &gid);
 		if (ret || !gid.global.interface_id)
 			break;
 	}
 
-	for (;; port->pkey_cnt++) {
+	for (port->pkey_cnt = 0;; port->pkey_cnt++) {
 		ret = ibv_query_pkey(port->dev->verbs, port->port_num, port->pkey_cnt, &pkey);
 		if (ret || !pkey)
 			break;
@@ -2651,25 +2698,12 @@ static void acm_port_up(struct acm_port *port)
 	if (!port->sa_dest.ah)
 		return;
 
-	for (i = 0; i < port->pkey_cnt; i++) {
-		/* TODO: Check if endpoint already exists in port list */
-		ep = calloc(1, sizeof *ep);
-		if (!ep)
-			break;
-
-		ret = acm_ep_up(port, ep, (uint16_t) i);
-		if (!ret) {
-			DListInsertHead(&ep->entry, &port->ep_list);
-		} else {
-			acm_log(0, "ERROR - failed to activate EP\n");
-			free(ep);
-		}
-	}
+	for (i = 0; i < port->pkey_cnt; i++)
+		 acm_ep_up(port, (uint16_t) i);
 
 	acm_port_join(port);
-	lock_acquire(&port->lock);
 	port->state = IBV_PORT_ACTIVE;
-	lock_release(&port->lock);
+	acm_log(1, "%s %d is up\n", port->dev->verbs->device->name, port->port_num);
 }
 
 /*
@@ -2681,13 +2715,31 @@ static void acm_port_up(struct acm_port *port)
 static void CDECL_FUNC acm_event_handler(void *context)
 {
 	struct acm_device *dev = (struct acm_device *) context;
-	int i;
+	struct ibv_async_event event;
+	int i, ret;
 
 	acm_log(1, "started\n");
 	for (i = 0; i < dev->port_cnt; i++) {
 		acm_port_up(&dev->port[i]);
 	}
-	/* TODO: wait for port up/down events */
+
+	for (;;) {
+		ret = ibv_get_async_event(dev->verbs, &event);
+		if (ret)
+			continue;
+
+		i = event.element.port_num - 1;
+		switch (event.event_type) {
+		case IBV_EVENT_PORT_ACTIVE:
+			if (dev->port[i].state != IBV_PORT_ACTIVE)
+				acm_port_up(&dev->port[i]);
+			break;
+		default:
+			break;
+		}
+
+		ibv_ack_async_event(&event);
+	}
 }
 
 static void acm_activate_devices()


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
