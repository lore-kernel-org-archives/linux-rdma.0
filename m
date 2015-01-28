From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCHv2 infiniband-diags] ibtracert.c: Remove checking the port
 0 state for base switch port 0
Date: Wed, 28 Jan 2015 17:58:29 -0500
Message-ID: <54C96995.6070404@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dan Ben-Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The port 0 state check needed to be only for HCA/Routers and
EnhancedPort0 switches.
For BasePort0 switches, the PortState field, in PortInfo arrtibute, for port0 is
undefined.

Signed-off-by: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Changes since v1:
Changed is_route_inactive_port0 to is_port_inactive
Moved description from above use of routine to above routine (is_port_inactive)

diff --git a/src/ibtracert.c b/src/ibtracert.c
index d32968b..9414618 100644
--- a/src/ibtracert.c
+++ b/src/ibtracert.c
@@ -92,6 +92,7 @@ struct Switch {
 	int mccap;
 	int linearFDBtop;
 	int fdb_base;
+	int enhsp0;
 	int8_t fdb[64];
 	char switchinfo[64];
 };
@@ -114,6 +115,24 @@ struct Node {
 Node *nodesdist[MAXHOPS];
 uint64_t target_portguid;
 
+/*
+ * is_port_inactive
+ * Checks whether or not the port state is other than active.
+ * The "sw" argument is only relevant when the port is on a
+ * switch; for HCAs and routers, this argument is ignored.
+ * Returns 1 when port is not active and 0 when active.
+ * Base switch port 0 is considered always active.
+ */
+static int is_port_inactive(Node * node, Port * port, Switch * sw)
+{
+	int res = 0;
+	if (port->state != 4 &&
+	    (node->type != IB_NODE_SWITCH ||
+	     (node->type == IB_NODE_SWITCH && sw->enhsp0)))
+		res = 1;
+	return res;
+}
+
 static int get_node(Node * node, Port * port, ib_portid_t * portid)
 {
 	void *pi = port->portinfo, *ni = node->nodeinfo, *nd = node->nodedesc;
@@ -164,6 +183,7 @@ static int switch_lookup(Switch * sw, ib_portid_t * portid, int lid)
 
 	mad_decode_field(si, IB_SW_LINEAR_FDB_CAP_F, &sw->linearcap);
 	mad_decode_field(si, IB_SW_LINEAR_FDB_TOP_F, &sw->linearFDBtop);
+	mad_decode_field(si, IB_SW_ENHANCED_PORT0_F, &sw->enhsp0);
 
 	if (lid >= sw->linearcap && lid > sw->linearFDBtop)
 		return -1;
@@ -248,7 +268,7 @@ static int find_route(ib_portid_t * from, ib_portid_t * to, int dump)
 	Port *port, fromport, toport, nextport;
 	Switch sw;
 	int maxhops = MAXHOPS;
-	int portnum, outport;
+	int portnum, outport = 255, next_sw_outport = 255;
 
 	memset(&fromnode,0,sizeof(Node));
 	memset(&tonode,0,sizeof(Node));
@@ -274,20 +294,25 @@ static int find_route(ib_portid_t * from, ib_portid_t * to, int dump)
 	portnum = port->portnum;
 
 	dump_endnode(dump, "From", node, port);
+	if (node->type == IB_NODE_SWITCH) {
+		next_sw_outport = switch_lookup(&sw, from, to->lid);
+		if (next_sw_outport < 0 || next_sw_outport > node->numports) {
+			/* needed to print the port in badtbl */
+			outport = next_sw_outport;
+			goto badtbl;
+		}
+	}
 
 	while (maxhops--) {
-		if (port->state != 4)
+		if (is_port_inactive(node, port, &sw))
 			goto badport;
 
 		if (sameport(port, &toport))
 			break;	/* found */
 
-		outport = portnum;
 		if (node->type == IB_NODE_SWITCH) {
 			DEBUG("switch node");
-			if ((outport = switch_lookup(&sw, from, to->lid)) < 0 ||
-			    outport > node->numports)
-				goto badtbl;
+			outport = next_sw_outport;
 
 			if (extend_dpath(&from->drpath, outport) < 0)
 				goto badpath;
@@ -307,6 +332,7 @@ static int find_route(ib_portid_t * from, ib_portid_t * to, int dump)
 			   (node->type == IB_NODE_ROUTER)) {
 			int ca_src = 0;
 
+			outport = portnum;
 			DEBUG("ca or router node");
 			if (!sameport(port, &fromport)) {
 				IBWARN
@@ -335,8 +361,19 @@ static int find_route(ib_portid_t * from, ib_portid_t * to, int dump)
 				nextport.portnum =
 				    from->drpath.p[from->drpath.cnt + 1];
 		}
+		/* only if the next node is a switch, get switch info */
+		if (nextnode.type == IB_NODE_SWITCH) {
+			next_sw_outport = switch_lookup(&sw, from, to->lid);
+			if (next_sw_outport < 0 ||
+			    next_sw_outport > nextnode.numports) {
+				/* needed to print the port in badtbl */
+				outport = next_sw_outport;
+				goto badtbl;
+			}
+		}
+
 		port = &nextport;
-		if (port->state != 4)
+		if (is_port_inactive(&nextnode, port, &sw))
 			goto badoutport;
 		node = &nextnode;
 		portnum = port->portnum;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
