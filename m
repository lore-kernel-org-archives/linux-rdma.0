From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH/ibsim] SMPs traveling through links in INIT should be
 forwarded
Date: Thu, 15 Sep 2011 11:57:01 -0600
Message-ID: <20110915175701.GA6020@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

See 7.2.2 and other places in the IBA.

Pass if the current routing is for a SMP through to link_valid
---
 ibsim/sim_mad.c |   25 ++++++++++++++-----------
 1 files changed, 14 insertions(+), 11 deletions(-)

This applies on top of Rolf's patch to fix combind DR/LID routed SMPs

diff --git a/ibsim/sim_mad.c b/ibsim/sim_mad.c
index 27670a8..83d4e3b 100644
--- a/ibsim/sim_mad.c
+++ b/ibsim/sim_mad.c
@@ -911,7 +911,7 @@ static int is_port_lid(Port * port, int lid)
 	return 1;
 }
 
-static int link_valid(Port * port)
+static int link_valid(Port * port,int is_smp)
 {
 	Node *node = port->node;
 
@@ -921,7 +921,7 @@ static int link_valid(Port * port)
 		      node->nodeid, node->numports);
 		return 0;
 	}
-	if (port->state != 4) {	// Active ?
+	if (!is_smp && port->state != 4) {	// Active ?
 		DEBUG("port 0x%" PRIx64
 		      " %d in not Active (%d)(node %s ports %d)",
 		      port->portguid, port->portnum, port->state, node->nodeid,
@@ -932,7 +932,7 @@ static int link_valid(Port * port)
 	return 1;
 }
 
-static Port *lid_route_MAD(Port * port, int lid)
+static Port *lid_route_MAD(Port * port, int lid, int is_smp)
 {
 	int hop, portnum;
 	Node *node = port->node;
@@ -978,7 +978,7 @@ static Port *lid_route_MAD(Port * port, int lid)
 		DEBUG("outport 0x%" PRIx64 " (%d)", port->portguid,
 		      port->portnum);
 
-		if (!link_valid(port)) {
+		if (!link_valid(port, is_smp)) {
 			pc_add_error_xmitdiscards(port);
 			return 0;
 		}
@@ -997,7 +997,7 @@ static Port *lid_route_MAD(Port * port, int lid)
 		if (!node || !port)	// double check ?...
 			IBPANIC("bad node %p or port %p", node, port);
 
-		if (!link_valid(port)) {
+		if (!link_valid(port, is_smp)) {
 			pc_add_error_xmitdiscards(tport);
 			return 0;
 		}
@@ -1108,10 +1108,11 @@ static Port *direct_route_out_MAD(Port * port, ib_dr_path_t * path)
 	return port;
 }
 
-static Port *route_MAD(Port * port, int response, int lid, ib_dr_path_t * path)
+static Port *route_MAD(Port * port, int response, int lid, ib_dr_path_t * path,
+		       int is_smp)
 {
 	if (lid >= 0 && lid < 0xffff) {
-		port = lid_route_MAD(port, lid);
+		port = lid_route_MAD(port, lid, is_smp);
 		if (!port)
 			return NULL;
 		if (!path)
@@ -1128,7 +1129,7 @@ static Port *route_MAD(Port * port, int response, int lid, ib_dr_path_t * path)
 	}
 
 	if (port && lid >= 0 && lid < 0xffff)
-		port = lid_route_MAD(port, lid);
+		port = lid_route_MAD(port, lid, is_smp);
 
 	return port;
 }
@@ -1190,7 +1191,8 @@ int process_packet(Client * cl, void *p, int size, Client ** dcl)
 	}
 
 	port = route_MAD(cl->port, response, ntohs(r->dlid),
-			 rpc.mgtclass == 0x81 ? &path : NULL);
+			 rpc.mgtclass == 0x81 ? &path : NULL,
+			 rpc.mgtclass == 0x1 || rpc.mgtclass == 0x81);
 	if (!port) {
 		IBWARN("routing failed: no route to dest lid %u path %s",
 		       ntohs(r->dlid), pathstr(0, &path));
@@ -1236,7 +1238,8 @@ int process_packet(Client * cl, void *p, int size, Client ** dcl)
 	r->status = 0;
 
 	port = route_MAD(port, 1, ntohs(r->dlid),
-			 rpc.mgtclass == 0x81 ? &path : NULL);
+			 rpc.mgtclass == 0x81 ? &path : NULL,
+			 rpc.mgtclass == 0x1 || rpc.mgtclass == 0x81);
 	if (!port || cl->port->node != port->node) {
 		VERB("PKT roll back did not succeed");
 		goto _dropped;
@@ -1324,7 +1327,7 @@ int send_trap(Port * port, unsigned trapnum)
 	if (encode_trapfn(port, data) < 0)
 		return -1;
 
-	if (!(destport = lid_route_MAD(port, port->smlid))) {
+	if (!(destport = lid_route_MAD(port, port->smlid, 1))) {
 		IBWARN("routing failed: no route to dest lid %u", port->smlid);
 		return -1;
 	}
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
