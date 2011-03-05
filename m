From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 7/7] ibacm: Handle port down events
Date: Fri, 4 Mar 2011 16:01:07 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CC92EAC4@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Process port down or error events.  While a port is down, the
ibacm service will fail all requests to endpoints on that port.
Cached data is not invalidated however, under the assumption
that the port state is temporary.  (A future enhancement can
optimize the cleanup.)

Since a port can now transition between up and down, we need
to fixup a couple of places to avoid initializing structures
multiple times.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |   84 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 81 insertions(+), 3 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 2570fdc..15f2631 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -378,6 +378,27 @@ acm_acquire_dest(struct acm_ep *ep, uint8_t addr_type, uint8_t *addr)
 	return dest;
 }
 
+static struct acm_dest *
+acm_acquire_sa_dest(struct acm_port *port)
+{
+	struct acm_dest *dest;
+
+	lock_acquire(&port->lock);
+	if (port->state == IBV_PORT_ACTIVE) {
+		dest = &port->sa_dest;
+		atomic_inc(&port->sa_dest.refcnt);
+	} else {
+		dest = NULL;
+	}
+	lock_release(&port->lock);
+	return dest;
+}
+
+static void acm_release_sa_dest(struct acm_dest *dest)
+{
+	atomic_dec(&dest->refcnt);
+}
+
 /* Caller must hold ep lock. */
 //static void
 //acm_remove_dest(struct acm_ep *ep, struct acm_dest *dest)
@@ -843,13 +864,21 @@ static uint8_t acm_resolve_path(struct acm_ep *ep, struct acm_dest *dest,
 {
 	struct acm_send_msg *msg;
 	struct ib_sa_mad *mad;
+	uint8_t ret;
 
 	acm_log(2, "%s\n", dest->name);
+	if (!acm_acquire_sa_dest(ep->port)) {
+		acm_log(1, "cannot acquire SA destination\n");
+		ret = ACM_STATUS_EINVAL;
+		goto err;
+	}
+
 	msg = acm_alloc_send(ep, &ep->port->sa_dest, sizeof(*mad));
+	acm_release_sa_dest(&ep->port->sa_dest);
 	if (!msg) {
 		acm_log(0, "ERROR - cannot allocate send msg\n");
-		dest->state = ACM_INIT;
-		return ACM_STATUS_ENOMEM;
+		ret = ACM_STATUS_ENOMEM;
+		goto err;
 	}
 
 	(void) atomic_inc(&dest->refcnt);
@@ -863,6 +892,9 @@ static uint8_t acm_resolve_path(struct acm_ep *ep, struct acm_dest *dest,
 	dest->state = ACM_QUERY_ROUTE;
 	acm_post_send(&ep->sa_queue, msg);
 	return ACM_STATUS_SUCCESS;
+err:
+	dest->state = ACM_INIT;
+	return ret;
 }
 
 static uint8_t
@@ -1463,7 +1495,7 @@ static void acm_join_group(struct acm_ep *ep, union ibv_gid *port_gid,
 	mad = (struct ib_sa_mad *) umad->data;
 	acm_init_join(mad, port_gid, ep->pkey, tos, tclass, sl, rate, mtu);
 	mc_rec = (struct ib_mc_member_rec *) mad->data;
-	acm_init_dest(&ep->mc_dest[ep->mc_cnt++], ACM_ADDRESS_GID,
+	acm_set_dest_addr(&ep->mc_dest[ep->mc_cnt++], ACM_ADDRESS_GID,
 		mc_rec->mgid.raw, sizeof(mc_rec->mgid));
 
 	ret = umad_send(port->mad_portid, port->mad_agentid, (void *) umad,
@@ -1508,6 +1540,7 @@ static void acm_port_join(struct acm_port *port)
 		 ep_entry = ep_entry->Next) {
 
 		ep = container_of(ep_entry, struct acm_ep, entry);
+		ep->mc_cnt = 0;
 		acm_join_group(ep, &port_gid, 0, 0, 0, min_rate, min_mtu);
 
 		if ((ep->state = ep->mc_dest[0].state) != ACM_READY)
@@ -1799,7 +1832,14 @@ acm_svr_query_path(struct acm_client *client, struct acm_resolve_msg *msg)
 		goto resp;
 	}
 
+	if (!acm_acquire_sa_dest(ep->port)) {
+		acm_log(1, "cannot acquire SA destination\n");
+		status = ACM_STATUS_EINVAL;
+		goto free;
+	}
+
 	sa_msg = acm_alloc_send(ep, &ep->port->sa_dest, sizeof(*mad));
+	acm_release_sa_dest(&ep->port->sa_dest);
 	if (!sa_msg) {
 		acm_log(0, "ERROR - cannot allocate send msg\n");
 		status = ACM_STATUS_ENOMEM;
@@ -2522,6 +2562,7 @@ static struct acm_ep *
 acm_alloc_ep(struct acm_port *port, uint16_t pkey, uint16_t pkey_index)
 {
 	struct acm_ep *ep;
+	int i;
 
 	acm_log(1, "\n");
 	ep = calloc(1, sizeof *ep);
@@ -2540,6 +2581,10 @@ acm_alloc_ep(struct acm_port *port, uint16_t pkey, uint16_t pkey_index)
 	DListInit(&ep->active_queue);
 	DListInit(&ep->wait_queue);
 	lock_init(&ep->lock);
+
+	for (i = 0; i < MAX_EP_MC; i++)
+		acm_init_dest(&ep->mc_dest[i], ACM_ADDRESS_GID, NULL, 0);
+
 	return ep;
 }
 
@@ -2698,6 +2743,7 @@ static void acm_port_up(struct acm_port *port)
 	if (!port->sa_dest.ah)
 		return;
 
+	atomic_set(&port->sa_dest.refcnt, 1);
 	for (i = 0; i < port->pkey_cnt; i++)
 		 acm_ep_up(port, (uint16_t) i);
 
@@ -2706,6 +2752,32 @@ static void acm_port_up(struct acm_port *port)
 	acm_log(1, "%s %d is up\n", port->dev->verbs->device->name, port->port_num);
 }
 
+static void acm_port_down(struct acm_port *port)
+{
+	struct ibv_port_attr attr;
+	int ret;
+
+	acm_log(1, "%s %d\n", port->dev->verbs->device->name, port->port_num);
+	ret = ibv_query_port(port->dev->verbs, port->port_num, &attr);
+	if (!ret && attr.state == IBV_PORT_ACTIVE) {
+		acm_log(1, "port active\n");
+		return;
+	}
+
+	port->state = attr.state;
+
+	/*
+	 * We wait for the SA destination to be released.  We could use an
+	 * event instead of a sleep loop, but it's not worth it given how
+	 * infrequently we should be processing a port down event in practice.
+	 */
+	atomic_dec(&port->sa_dest.refcnt);
+	while (atomic_get(&port->sa_dest.refcnt))
+		sleep(0);
+	ibv_destroy_ah(port->sa_dest.ah);
+	acm_log(1, "%s %d is down\n", port->dev->verbs->device->name, port->port_num);
+}
+
 /*
  * There is one event handler thread per device.  This is the only thread that
  * modifies the port state or a port endpoint list.  Other threads which access
@@ -2728,12 +2800,18 @@ static void CDECL_FUNC acm_event_handler(void *context)
 		if (ret)
 			continue;
 
+		acm_log(2, "processing async event %s\n",
+			ibv_event_type_str(event.event_type));
 		i = event.element.port_num - 1;
 		switch (event.event_type) {
 		case IBV_EVENT_PORT_ACTIVE:
 			if (dev->port[i].state != IBV_PORT_ACTIVE)
 				acm_port_up(&dev->port[i]);
 			break;
+		case IBV_EVENT_PORT_ERR:
+			if (dev->port[i].state == IBV_PORT_ACTIVE)
+				acm_port_down(&dev->port[i]);
+			break;
 		default:
 			break;
 		}


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
