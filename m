From: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] ibsim: Alias GUID support.
Date: Sun, 8 Jan 2012 16:18:16 +0200
Message-ID: <20120108141815.GA2669@UBU02>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

default guids_tbl size for both hosts and switches is 128 guids.
nodes support guidinfo get and set requests.

Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 ibsim/sim.h     |    6 ++++++
 ibsim/sim_mad.c |   35 ++++++++++++++++++++++++++---------
 ibsim/sim_net.c |   17 +++++++++++++++++
 3 files changed, 49 insertions(+), 9 deletions(-)

diff --git a/ibsim/sim.h b/ibsim/sim.h
index 1911bb9..acf346c 100644
--- a/ibsim/sim.h
+++ b/ibsim/sim.h
@@ -81,6 +81,9 @@
 
 #define MAXHOPS 16
 
+#define GUIDS_PER_BLOCK	8
+#define GUIDS_DEFAULT	128
+
 enum NODE_TYPES {
 	NO_NODE,
 	HCA_NODE,
@@ -221,6 +224,9 @@ struct Port {
 	uint8_t extportinfo[64];
 	uint8_t op_vls;
 
+	uint8_t guid_cap;
+	int64_t* guids;
+
 	char remotenodeid[NODEIDLEN];
 	char remotealias[ALIASLEN + 1];
 	char alias[ALIASLEN + 1];
diff --git a/ibsim/sim_mad.c b/ibsim/sim_mad.c
index 8fd1035..6582f7c 100644
--- a/ibsim/sim_mad.c
+++ b/ibsim/sim_mad.c
@@ -441,17 +441,34 @@ static int do_guidinfo(Port * port, unsigned op, uint32_t mod, uint8_t * data)
 {
 	Node *node = port->node;
 	int status = 0;
-	uint64_t portguid = node->nodeguid + port->portnum;
+	int offset;
+	int size;
 
-	if (op != IB_MAD_METHOD_GET)    // only get currently supported (non compliant)
-		status = ERR_METHOD_UNSUPPORTED;
+	if (op != IB_MAD_METHOD_GET && op != IB_MAD_METHOD_SET)
+		return ERR_METHOD_UNSUPPORTED;
 
-	memset(data, 0, IB_SMP_DATA_SIZE);
-	if (mod == 0) {
-		if (node->type == SWITCH_NODE)
-			mad_encode_field(data, IB_GUID_GUID0_F, &node->nodeguid);
-		else
-			mad_encode_field(data, IB_GUID_GUID0_F, &portguid);
+	offset = mod * GUIDS_PER_BLOCK;
+
+	if (offset >= port->guid_cap) // check that block is valid
+		 return ERR_BAD_PARAM;
+
+	if (node->type == SWITCH_NODE)	// if switch then take use port 0
+                port = node_get_port(node, 0);
+
+	size = port->guid_cap - offset;
+	if (size > GUIDS_PER_BLOCK)
+		size = GUIDS_PER_BLOCK;
+
+	if (op == IB_MAD_METHOD_GET) {
+		memset(data, 0, IB_SMP_DATA_SIZE);
+		memcpy(data, &port->guids[offset], size * sizeof(uint64_t));
+	}
+	if (op == IB_MAD_METHOD_SET) {
+		if (offset == 0) { // block 0, index o is read only
+			offset++;
+			size--;
+		}
+		memcpy(&port->guids[offset], data, size * sizeof(uint64_t));
 	}
 
 	return status;
diff --git a/ibsim/sim_net.c b/ibsim/sim_net.c
index 0ee9e31..98ba33c 100644
--- a/ibsim/sim_net.c
+++ b/ibsim/sim_net.c
@@ -621,6 +621,20 @@ static void init_ports(Node * node, int type, int maxports)
 		       sizeof(port->vlarb_high));
 		memcpy(port->vlarb_low, default_vlarb_low,
 		       sizeof(port->vlarb_low));
+
+		if ((port->node->type == SWITCH_NODE && !i) ||
+				(port->node->type == HCA_NODE) ||
+				(port->node->type == ROUTER_NODE)) {
+
+			port->guid_cap = GUIDS_DEFAULT;
+			port->guids = calloc(port->guid_cap, sizeof(uint64_t));
+
+			if (!port->guids)
+				IBPANIC("cannot alloc port's guids table\n");
+
+			memset(port->guids, 0, sizeof(port->guids));
+			port->guids[0] = port->portguid;
+		}
 	}
 }
 
@@ -1232,6 +1246,7 @@ void update_portinfo(Port * p)
 	mad_set_field(pi, 0, IB_PORT_LID_F, p->lid);
 	mad_set_field(pi, 0, IB_PORT_SMLID_F, p->smlid);
 	mad_set_field(pi, 0, IB_PORT_OPER_VLS_F, p->op_vls);
+	mad_set_field(pi, 0, IB_PORT_GUID_CAP_F, p->guid_cap);
 	mad_set_field(pi, 0, IB_PORT_LINK_WIDTH_ENABLED_F, p->linkwidthena);
 	mad_set_field(pi, 0, IB_PORT_LINK_WIDTH_SUPPORTED_F,
 		      LINKWIDTH_1x_4x_12x);
@@ -1524,6 +1539,8 @@ void free_core(void)
 			free(ports[i].pkey_tbl);
 		if (ports[i].sl2vl)
 			free(ports[i].sl2vl);
+		if (ports[i].guids)
+			free(ports[i].guids);
 	}
 	free(ports);
 	for (i = 0; i < maxnetswitches ; i++) {
-- 
1.7.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
