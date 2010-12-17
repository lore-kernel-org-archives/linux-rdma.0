From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] ibacm: add support for path lookup by LID/GID
Date: Fri, 17 Dec 2010 15:05:58 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25C1696F08@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Support path record lookup based on DLID or DGID.  This allows
ibacm to be used purely for path record caching, with address
resolution being done by a user.  This is needed to support
clients that exchange LID/GID information out of band before
connecting, or that make use of ipoib for address resolution.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c  |  285 ++++++++++++++++++++++++++++++++++++++++++++----------------
 src/acme.c |    2 
 2 files changed, 211 insertions(+), 76 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index e0f0b94..b4e0632 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -268,8 +268,13 @@ acm_format_name(int level, char *name, size_t name_size,
 		break;
 	case ACM_EP_INFO_PATH:
 		path = (struct ibv_path_record *) addr;
-		sprintf(name, "SLID(%d) DLID(%d)",
-			ntohs(path->slid), ntohs(path->dlid));
+		if (path->dlid) {
+			sprintf(name, "SLID(%d) DLID(%d)",
+				ntohs(path->slid), ntohs(path->dlid));
+		} else {
+			acm_format_name(level, name, name_size, ACM_ADDRESS_GID,
+					path->dgid.raw, sizeof path->dgid);
+		}
 		break;
 	case ACM_ADDRESS_LID:
 		sprintf(name, "LID(%d)", *((uint16_t *) addr));
@@ -280,6 +285,11 @@ acm_format_name(int level, char *name, size_t name_size,
 	}
 }
 
+static int ib_any_gid(union ibv_gid *gid)
+{
+	return ((gid->global.subnet_prefix | gid->global.interface_id) == 0);
+}
+
 static int acm_compare_dest(const void *dest1, const void *dest2)
 {
 	return memcmp(dest1, dest2, ACM_MAX_ADDRESS);
@@ -726,9 +736,23 @@ static int acm_addr_index(struct acm_ep *ep, uint8_t *addr, uint8_t addr_type)
 static uint8_t
 acm_record_acm_route(struct acm_ep *ep, struct acm_dest *dest)
 {
+	int i;
 	uint8_t status;
 
 	acm_log(2, "\n");
+	for (i = 0; i < MAX_EP_MC; i++) {
+		if (!memcmp(&dest->mgid, &ep->mc_dest[i].mgid, sizeof dest->mgid))
+			break;
+	}
+	if (i == MAX_EP_MC) {
+		acm_log(0, "ERROR - cannot match mgid\n");
+		return ACM_STATUS_EINVAL;
+	}
+
+	dest->path = ep->mc_dest[i].path;
+	dest->path.dgid = dest->av.grh.dgid;
+	dest->path.dlid = htons(dest->av.dlid);
+
 	dest->ah = ibv_create_ah(ep->port->dev->pd, &dest->av);
 	if (!dest->ah) {
 		acm_log(0, "ERROR - failed to create ah\n");
@@ -753,6 +777,59 @@ static void acm_init_path_query(struct ib_sa_mad *mad)
 	mad->attr_id = IB_SA_ATTR_PATH_REC;
 }
 
+static uint64_t acm_path_comp_mask(struct ibv_path_record *path)
+{
+	uint32_t fl_hop;
+	uint16_t qos_sl;
+	uint64_t comp_mask = 0;
+
+	acm_log(2, "\n");
+	if (path->service_id)
+		comp_mask |= IB_COMP_MASK_PR_SERVICE_ID;
+	if (!ib_any_gid(&path->dgid))
+		comp_mask |= IB_COMP_MASK_PR_DGID;
+	if (!ib_any_gid(&path->sgid))
+		comp_mask |= IB_COMP_MASK_PR_SGID;
+	if (path->dlid)
+		comp_mask |= IB_COMP_MASK_PR_DLID;
+	if (path->slid)
+		comp_mask |= IB_COMP_MASK_PR_SLID;
+
+	fl_hop = ntohl(path->flowlabel_hoplimit);
+	if (fl_hop >> 8)
+		comp_mask |= IB_COMP_MASK_PR_FLOW_LABEL;
+	if (fl_hop & 0xFF)
+		comp_mask |= IB_COMP_MASK_PR_HOP_LIMIT;
+
+	if (path->tclass)
+		comp_mask |= IB_COMP_MASK_PR_TCLASS;
+	if (path->reversible_numpath & 0x80)
+		comp_mask |= IB_COMP_MASK_PR_REVERSIBLE;
+	if (path->pkey)
+		comp_mask |= IB_COMP_MASK_PR_PKEY;
+
+	qos_sl = ntohs(path->qosclass_sl);
+	if (qos_sl >> 4)
+		comp_mask |= IB_COMP_MASK_PR_QOS_CLASS;
+	if (qos_sl & 0xF)
+		comp_mask |= IB_COMP_MASK_PR_SL;
+
+	if (path->mtu & 0xC0)
+		comp_mask |= IB_COMP_MASK_PR_MTU_SELECTOR;
+	if (path->mtu & 0x3F)
+		comp_mask |= IB_COMP_MASK_PR_MTU;
+	if (path->rate & 0xC0)
+		comp_mask |= IB_COMP_MASK_PR_RATE_SELECTOR;
+	if (path->rate & 0x3F)
+		comp_mask |= IB_COMP_MASK_PR_RATE;
+	if (path->packetlifetime & 0xC0)
+		comp_mask |= IB_COMP_MASK_PR_PACKET_LIFETIME_SELECTOR;
+	if (path->packetlifetime & 0x3F)
+		comp_mask |= IB_COMP_MASK_PR_PACKET_LIFETIME;
+
+	return comp_mask;
+}
+
 /* Caller must hold dest lock */
 static uint8_t acm_resolve_path(struct acm_ep *ep, struct acm_dest *dest,
 	void (*resp_handler)(struct acm_send_msg *req,
@@ -775,8 +852,7 @@ static uint8_t acm_resolve_path(struct acm_ep *ep, struct acm_dest *dest,
 	acm_init_path_query(mad);
 
 	memcpy(mad->data, &dest->path, sizeof(dest->path));
-	mad->comp_mask = IB_COMP_MASK_PR_DGID | IB_COMP_MASK_PR_SGID |
-		IB_COMP_MASK_PR_TCLASS | IB_COMP_MASK_PR_PKEY;
+	mad->comp_mask = acm_path_comp_mask(&dest->path);
 
 	dest->state = ACM_QUERY_ROUTE;
 	acm_post_send(&ep->sa_queue, msg);
@@ -804,16 +880,29 @@ acm_record_acm_addr(struct acm_ep *ep, struct acm_dest *dest, struct ibv_wc *wc,
 	dest->av.grh.dgid = ((struct ibv_grh *) (uintptr_t) wc->wr_id)->sgid;
 	
 	dest->mgid = ep->mc_dest[index].mgid;
-
-	dest->path = ep->mc_dest[index].path;
+	dest->path.sgid = ep->mc_dest[index].path.sgid;
 	dest->path.dgid = dest->av.grh.dgid;
-	dest->path.dlid = htons(dest->av.dlid);
+	dest->path.tclass = ep->mc_dest[index].path.tclass;
+	dest->path.pkey = ep->mc_dest[index].path.pkey;
 	dest->remote_qpn = wc->src_qp;
 
 	dest->state = ACM_ADDR_RESOLVED;
 	return ACM_STATUS_SUCCESS;
 }
 
+static void
+acm_record_path_addr(struct acm_ep *ep, struct acm_dest *dest,
+	struct ibv_path_record *path)
+{
+	acm_log(2, "%s\n", dest->name);
+	dest->path.pkey = htons(ep->pkey);
+	dest->path.sgid = path->sgid;
+	dest->path.dgid = path->dgid;
+	dest->path.slid = path->slid;
+	dest->path.dlid = path->dlid;
+	dest->state = ACM_ADDR_RESOLVED;
+}
+
 static uint8_t acm_validate_addr_req(struct acm_mad *mad)
 {
 	struct acm_resolve_rec *rec;
@@ -959,10 +1048,12 @@ acm_dest_sa_resp(struct acm_send_msg *msg, struct ibv_wc *wc, struct acm_mad *ma
 	if (!status) {
 		memcpy(&dest->path, sa_mad->data, sizeof(dest->path));
 		acm_init_path_av(msg->ep->port, dest);
-		dest->ah = ibv_create_ah(msg->ep->port->dev->pd, &dest->av);
-		if (!dest->ah) {
-			acm_log(0, "ERROR - failed to create ah\n");
-			status = ACM_STATUS_ENOMEM;
+		if (dest->remote_qpn) {
+			dest->ah = ibv_create_ah(msg->ep->port->dev->pd, &dest->av);
+			if (!dest->ah) {
+				acm_log(0, "ERROR - failed to create ah\n");
+				status = ACM_STATUS_ENOMEM;
+			}
 		}
 	}
 	if (!status) {
@@ -1304,59 +1395,6 @@ static void acm_format_mgid(union ibv_gid *mgid, uint16_t pkey, uint8_t tos,
 	mgid->raw[15] = 0;
 }
 
-static uint64_t acm_path_comp_mask(struct ibv_path_record *path)
-{
-	uint32_t fl_hop;
-	uint16_t qos_sl;
-	uint64_t comp_mask = 0;
-
-	acm_log(2, "\n");
-	if (path->service_id)
-		comp_mask |= IB_COMP_MASK_PR_SERVICE_ID;
-	if (path->dgid.global.interface_id || path->dgid.global.subnet_prefix)
-		comp_mask |= IB_COMP_MASK_PR_DGID;
-	if (path->sgid.global.interface_id || path->sgid.global.subnet_prefix)
-		comp_mask |= IB_COMP_MASK_PR_SGID;
-	if (path->dlid)
-		comp_mask |= IB_COMP_MASK_PR_DLID;
-	if (path->slid)
-		comp_mask |= IB_COMP_MASK_PR_SLID;
-
-	fl_hop = ntohl(path->flowlabel_hoplimit);
-	if (fl_hop >> 8)
-		comp_mask |= IB_COMP_MASK_PR_FLOW_LABEL;
-	if (fl_hop & 0xFF)
-		comp_mask |= IB_COMP_MASK_PR_HOP_LIMIT;
-
-	if (path->tclass)
-		comp_mask |= IB_COMP_MASK_PR_TCLASS;
-	if (path->reversible_numpath & 0x80)
-		comp_mask |= IB_COMP_MASK_PR_REVERSIBLE;
-	if (path->pkey)
-		comp_mask |= IB_COMP_MASK_PR_PKEY;
-
-	qos_sl = ntohs(path->qosclass_sl);
-	if (qos_sl >> 4)
-		comp_mask |= IB_COMP_MASK_PR_QOS_CLASS;
-	if (qos_sl & 0xF)
-		comp_mask |= IB_COMP_MASK_PR_SL;
-
-	if (path->mtu & 0xC0)
-		comp_mask |= IB_COMP_MASK_PR_MTU_SELECTOR;
-	if (path->mtu & 0x3F)
-		comp_mask |= IB_COMP_MASK_PR_MTU;
-	if (path->rate & 0xC0)
-		comp_mask |= IB_COMP_MASK_PR_RATE_SELECTOR;
-	if (path->rate & 0x3F)
-		comp_mask |= IB_COMP_MASK_PR_RATE;
-	if (path->packetlifetime & 0xC0)
-		comp_mask |= IB_COMP_MASK_PR_PACKET_LIFETIME_SELECTOR;
-	if (path->packetlifetime & 0x3F)
-		comp_mask |= IB_COMP_MASK_PR_PACKET_LIFETIME;
-
-	return comp_mask;
-}
-
 static void acm_init_join(struct ib_sa_mad *mad, union ibv_gid *port_gid,
 	uint16_t pkey, uint8_t tos, uint8_t tclass, uint8_t sl, uint8_t rate, uint8_t mtu)
 {
@@ -1708,6 +1746,15 @@ static uint8_t acm_svr_query_sa(struct acm_ep *ep, struct acm_request *req)
 	return ACM_STATUS_SUCCESS;
 }
 
+static int
+acm_is_path_from_port(struct acm_port *port, struct ibv_path_record *path)
+{
+	if (ib_any_gid(&path->sgid)) {
+		return (port->lid == (ntohs(path->slid) & port->lid_mask));
+	}
+	return (acm_gid_index(port, &path->sgid) < port->gid_cnt);
+}
+
 static struct acm_ep *
 acm_get_ep(struct acm_ep_addr_data *data)
 {
@@ -1728,7 +1775,7 @@ acm_get_ep(struct acm_ep_addr_data *data)
 			port = &dev->port[i];
 
 			if (data->type == ACM_EP_INFO_PATH &&
-			    port->lid != ntohs(data->info.path.slid))
+			    !acm_is_path_from_port(port, &data->info.path))
 				continue;
 
 			for (ep_entry = port->ep_list.Next; ep_entry != &port->ep_list;
@@ -1738,8 +1785,10 @@ acm_get_ep(struct acm_ep_addr_data *data)
 				if (ep->state != ACM_READY)
 					continue;
 
-				if (data->type == ACM_EP_INFO_PATH)
-					return ep; // TODO: check pkey
+				if ((data->type == ACM_EP_INFO_PATH) &&
+				    (!data->info.path.pkey ||
+				     (ntohs(data->info.path.pkey) == ep->pkey)))
+					return ep;
 
 				if (acm_addr_index(ep, data->info.addr,
 				    (uint8_t) data->type) >= 0)
@@ -1768,12 +1817,6 @@ acm_svr_query(struct acm_client *client, struct acm_resolve_msg *msg)
 		goto resp;
 	}
 
-	if (msg->data[0].type != ACM_EP_INFO_PATH) {
-		acm_log(0, "ERROR - unsupported type: 0x%x\n", msg->data[0].type);
-		status = ACM_STATUS_EINVAL;
-		goto resp;
-	}
-
 	ep = acm_get_ep(&msg->data[0]);
 	if (!ep) {
 		acm_log(1, "notice - could not find local end point\n");
@@ -2060,6 +2103,94 @@ put:
 	return ret;
 }
 
+/*
+ * The message buffer contains extra address data buffers.  We extract the
+ * destination address from the path record into an extra buffer, so we can
+ * lookup the destination by either LID or GID.
+ */
+static int
+acm_svr_resolve_path(struct acm_client *client, struct acm_resolve_msg *msg)
+{
+	struct acm_ep *ep;
+	struct acm_dest *dest;
+	struct ibv_path_record *path;
+	uint8_t *addr;
+	uint8_t status;
+	int ret;
+
+	acm_log(2, "client %d\n", client->index);
+	if (msg->hdr.length < (ACM_MSG_HDR_LENGTH + ACM_MSG_EP_LENGTH)) {
+		acm_log(0, "notice - invalid msg hdr length %d\n", msg->hdr.length);
+		return acm_client_resolve_resp(client, msg, NULL, ACM_STATUS_EINVAL);
+	}
+
+	path = &msg->data[0].info.path;
+	if (!path->dlid && ib_any_gid(&path->dgid)) {
+		acm_log(0, "notice - no destination specified\n");
+		return acm_client_resolve_resp(client, msg, NULL, ACM_STATUS_EDESTADDR);
+	}
+
+	acm_format_name(2, log_data, sizeof log_data,
+			ACM_EP_INFO_PATH, msg->data[0].info.addr, sizeof *path);
+	acm_log(2, "path %s\n", log_data);
+	ep = acm_get_ep(&msg->data[0]);
+	if (!ep) {
+		acm_log(0, "notice - unknown local end point\n");
+		return acm_client_resolve_resp(client, msg, NULL, ACM_STATUS_ESRCADDR);
+	}
+
+	addr = msg->data[1].info.addr;
+	memset(addr, 0, ACM_MAX_ADDRESS);
+	if (path->dlid) {
+		* ((uint16_t *) addr) = path->dlid;
+		dest = acm_acquire_dest(ep, ACM_ADDRESS_LID, addr);
+	} else {
+		memcpy(addr, &path->dgid, sizeof path->dgid);
+		dest = acm_acquire_dest(ep, ACM_ADDRESS_GID, addr);
+	}
+	if (!dest) {
+		acm_log(0, "ERROR - unable to allocate destination in client request\n");
+		return acm_client_resolve_resp(client, msg, NULL, ACM_STATUS_ENOMEM);
+	}
+
+	lock_acquire(&dest->lock);
+	switch (dest->state) {
+	case ACM_READY:
+		acm_log(2, "request satisfied from local cache\n");
+		status = ACM_STATUS_SUCCESS;
+		break;
+	case ACM_INIT:
+		acm_log(2, "have path, bypassing address resolution\n");
+		acm_record_path_addr(ep, dest, path);
+		/* fall through */
+	case ACM_ADDR_RESOLVED:
+		acm_log(2, "have address, resolving route\n");
+		status = acm_resolve_path(ep, dest, acm_dest_sa_resp);
+		if (status) {
+			break;
+		}
+		/* fall through */
+	default:
+		if (msg->data[0].flags & ACM_FLAGS_NODELAY) {
+			acm_log(2, "lookup initiated, but client wants no delay\n");
+			status = ACM_STATUS_ENODATA;
+			break;
+		}
+		status = acm_svr_queue_req(dest, client, msg);
+		if (status) {
+			break;
+		}
+		ret = 0;
+		lock_release(&dest->lock);
+		goto put;
+	}
+	lock_release(&dest->lock);
+	ret = acm_client_resolve_resp(client, msg, dest, status);
+put:
+	acm_put_dest(dest);
+	return ret;
+}
+
 static void acm_svr_receive(struct acm_client *client)
 {
 	struct acm_msg msg;
@@ -2085,7 +2216,11 @@ static void acm_svr_receive(struct acm_client *client)
 	}
 
 	if (resolve_msg->data[0].type == ACM_EP_INFO_PATH) {
-		ret = acm_svr_query(client, resolve_msg);
+		if (resolve_msg->data[0].flags & ACM_FLAGS_QUERY_SA) {
+			ret = acm_svr_query(client, resolve_msg);
+		} else {
+			ret = acm_svr_resolve_path(client, resolve_msg);
+		}
 	} else {
 		ret = acm_svr_resolve(client, resolve_msg);
 	}
@@ -2582,7 +2717,7 @@ static void acm_init_port(struct acm_port *port)
 			break;
 	}
 	port->lid = attr.lid;
-	port->lid_mask = 0xffff - (1 << attr.lmc) - 1;
+	port->lid_mask = 0xffff - ((1 << attr.lmc) - 1);
 
 	acm_init_dest(&port->sa_dest, ACM_ADDRESS_LID,
 		(uint8_t *) &attr.sm_lid, sizeof(attr.sm_lid));
diff --git a/src/acme.c b/src/acme.c
index a7b7413..dd645c1 100644
--- a/src/acme.c
+++ b/src/acme.c
@@ -493,7 +493,7 @@ static int resolve_lid(struct ibv_path_record *path)
 	path->dlid = htons((uint16_t) atoi(dest_addr));
 	path->reversible_numpath = IBV_PATH_RECORD_REVERSIBLE | 1;
 
-	ret = ib_acm_resolve_path(path, 0);
+	ret = ib_acm_resolve_path(path, get_resolve_flags());
 	if (ret)
 		printf("ib_acm_resolve_path failed: %s\n", strerror(errno));
 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
