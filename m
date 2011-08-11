From: Rolf Manderscheid <rvm-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH v2] ibsim: support LID portions of directed-route SMPs
Date: Thu, 11 Aug 2011 15:31:50 -0600
Message-ID: <E1Qrcr0-0007qO-3V@rvml.edm.orcorp.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Heed the DRSLID and DRDLID fields in DR SMPs.

Signed-off-by: Rolf Manderscheid <rvm-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---

changes from v1:
- pass a NULL path for LID-routed MADs at both call sites

 ibsim/sim_mad.c |   38 +++++++++++++++++++++++++++-----------
 1 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/ibsim/sim_mad.c b/ibsim/sim_mad.c
index 61d4866..27670a8 100644
--- a/ibsim/sim_mad.c
+++ b/ibsim/sim_mad.c
@@ -152,11 +152,8 @@ static int decode_sim_MAD(Client * cl, struct sim_request * r, ib_rpc_t * rpc,
 
 	if (rpc->mgtclass == 0x81) {	// direct route
 		// word 9
-		if (mad_get_field(buf, 0, IB_DRSMP_DRDLID_F) != 0xffff ||
-		    mad_get_field(buf, 0, IB_DRSMP_DRSLID_F) != 0xffff) {
-			IBWARN("dr[ds]lids are used (not supported)");
-			return -1;
-		}
+		path->drslid = mad_get_field(buf, 0, IB_DRSMP_DRSLID_F);
+		path->drdlid = mad_get_field(buf, 0, IB_DRSMP_DRDLID_F);
 		// bytes 128 - 256
 		if (!response)
 			mad_get_array(buf, 0, IB_DRSMP_PATH_F, path->p);
@@ -1113,11 +1110,27 @@ static Port *direct_route_out_MAD(Port * port, ib_dr_path_t * path)
 
 static Port *route_MAD(Port * port, int response, int lid, ib_dr_path_t * path)
 {
-	if (lid >= 0 && lid < 0xffff)
-		return lid_route_MAD(port, lid);
+	if (lid >= 0 && lid < 0xffff) {
+		port = lid_route_MAD(port, lid);
+		if (!port)
+			return NULL;
+		if (!path)
+			return port;
+	} else if (!path)
+		return NULL; // permissive LID with no DR
+
+	if (response) {
+		port = direct_route_in_MAD(port, path);
+		lid = path->drslid;
+	} else {
+		port = direct_route_out_MAD(port, path);
+		lid = path->drdlid;
+	}
 
-	return response ? direct_route_in_MAD(port, path) :
-	    direct_route_out_MAD(port, path);
+	if (port && lid >= 0 && lid < 0xffff)
+		port = lid_route_MAD(port, lid);
+
+	return port;
 }
 
 static Smpfn *get_handle_fn(ib_rpc_t rpc, int response)
@@ -1176,7 +1189,9 @@ int process_packet(Client * cl, void *p, int size, Client ** dcl)
 		return 0;
 	}
 
-	if (!(port = route_MAD(cl->port, response, ntohs(r->dlid), &path))) {
+	port = route_MAD(cl->port, response, ntohs(r->dlid),
+			 rpc.mgtclass == 0x81 ? &path : NULL);
+	if (!port) {
 		IBWARN("routing failed: no route to dest lid %u path %s",
 		       ntohs(r->dlid), pathstr(0, &path));
 		goto _dropped;
@@ -1220,7 +1235,8 @@ int process_packet(Client * cl, void *p, int size, Client ** dcl)
 
 	r->status = 0;
 
-	port = route_MAD(port, 1, ntohs(r->dlid), &path);
+	port = route_MAD(port, 1, ntohs(r->dlid),
+			 rpc.mgtclass == 0x81 ? &path : NULL);
 	if (!port || cl->port->node != port->node) {
 		VERB("PKT roll back did not succeed");
 		goto _dropped;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
