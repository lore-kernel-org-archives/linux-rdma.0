From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] ibsim: Fix seg-fault on unconnected client
Date: Wed, 19 Jun 2013 14:42:33 -0700
Message-ID: <1371678153.19017.102.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

A segfault would regularly occur if ibsim was restarted but
previously connected clients had not disconnected.  The
previously connected clients would assume their previous
connection was still valid.

Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 ibsim/ibsim.c |   60 ++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 51 insertions(+), 9 deletions(-)

diff --git a/ibsim/ibsim.c b/ibsim/ibsim.c
index 5f86fef..819a66d 100644
--- a/ibsim/ibsim.c
+++ b/ibsim/ibsim.c
@@ -280,10 +280,23 @@ static int sim_ctl_disconnect_client(Client * cl, struct sim_ctl * ctl)
 	return 0;
 }
 
+static int sim_ctl_validate_client(Client * cl, struct sim_ctl * ctl)
+{
+	if (!cl->pid) {
+		ctl->type = SIM_CTL_ERROR;
+		return -1;
+	}
+	return 0;
+}
+
 static int sim_ctl_get_port(Client * cl, struct sim_ctl * ctl)
 {
-	struct sim_port *p = (void *)ctl->data;
+	struct sim_port *p;
+
+	if (sim_ctl_validate_client(cl, ctl) < 0)
+		return -1;
 
+	p = (void *)ctl->data;
 	p->lid = cl->port->lid;
 	p->state = cl->port->state;
 	return 0;
@@ -291,8 +304,12 @@ static int sim_ctl_get_port(Client * cl, struct sim_ctl * ctl)
 
 static int sim_ctl_get_gid(Client * cl, struct sim_ctl * ctl)
 {
-	char *gid = (void *)ctl->data;
+	char *gid;
 
+	if (sim_ctl_validate_client(cl, ctl) < 0)
+		return -1;
+
+	gid = (void *)ctl->data;
 	mad_get_array(cl->port->portinfo, 0, IB_PORT_GID_PREFIX_F, gid);
 	memcpy(gid + 8, &cl->port->node->nodeguid, 8);
 	return 0;
@@ -300,14 +317,21 @@ static int sim_ctl_get_gid(Client * cl, struct sim_ctl * ctl)
 
 static int sim_ctl_get_guid(Client * cl, struct sim_ctl * ctl)
 {
-	char *guid = (void *)ctl->data;
+	char *guid;
+
+	if (sim_ctl_validate_client(cl, ctl) < 0)
+		return -1;
 
+	guid = (void *)ctl->data;
 	memcpy(guid, &cl->port->node->nodeguid, 8);
 	return 0;
 }
 
 static int sim_ctl_get_nodeinfo(Client * cl, struct sim_ctl * ctl)
 {
+	if (sim_ctl_validate_client(cl, ctl) < 0)
+		return -1;
+
 	memcpy(ctl->data, cl->port->node->nodeinfo, sizeof(ctl->data));
 	return 0;
 }
@@ -315,7 +339,12 @@ static int sim_ctl_get_nodeinfo(Client * cl, struct sim_ctl * ctl)
 static int sim_ctl_get_portinfo(Client * cl, struct sim_ctl * ctl)
 {
 	Port *p;
-	uint8_t port_num = ctl->data[0];
+	uint8_t port_num;
+
+	if (sim_ctl_validate_client(cl, ctl) < 0)
+		return -1;
+
+	port_num = ctl->data[0];
 	if (port_num == 0 || port_num > cl->port->node->numports)
 		p = cl->port;
 	else if (cl->port->node->type == SWITCH_NODE)
@@ -345,8 +374,12 @@ static void set_issm(Port *port, unsigned issm)
 
 static int sim_ctl_set_issm(Client * cl, struct sim_ctl * ctl)
 {
-	int issm = *(int *)ctl->data;
+	int issm;
+
+	if (sim_ctl_validate_client(cl, ctl) < 0)
+		return -1;
 
+	issm = *(int *)ctl->data;
 	VERB("set issm %d port %" PRIx64, issm, cl->port->portguid);
 	cl->issm = issm;
 	set_issm(cl->port, issm);
@@ -356,12 +389,17 @@ static int sim_ctl_set_issm(Client * cl, struct sim_ctl * ctl)
 
 static int sim_ctl_get_pkeys(Client * cl, struct sim_ctl * ctl)
 {
-	Port *port = cl->port;
-	unsigned size = (port->node->sw && port->portnum) ?
+	Port *port;
+	unsigned size;
+
+	if (sim_ctl_validate_client(cl, ctl) < 0)
+		return -1;
+
+	port = cl->port;
+	size = (port->node->sw && port->portnum) ?
 	    mad_get_field(port->node->sw->switchinfo, 0,
 			  IB_SW_PARTITION_ENFORCE_CAP_F) :
 	    mad_get_field(port->node->nodeinfo, 0, IB_NODE_PARTITION_CAP_F);
-
 	size *= sizeof(port->pkey_tbl[0]);
 	if (size > sizeof(ctl->data))
 		size = sizeof(ctl->data);
@@ -373,8 +411,12 @@ static int sim_ctl_get_pkeys(Client * cl, struct sim_ctl * ctl)
 
 static int sim_ctl_get_vendor(Client * cl, struct sim_ctl * ctl)
 {
-	struct sim_vendor *v = (void *)ctl->data;
+	struct sim_vendor *v;
+
+	if (sim_ctl_validate_client(cl, ctl) < 0)
+		return -1;
 
+	v = (void *)ctl->data;
 	v->vendor_id =
 	    mad_get_field(cl->port->node->nodeinfo, 0, IB_NODE_VENDORID_F);
 	v->vendor_part_id =
-- 
1.7.1




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
