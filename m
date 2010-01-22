From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Found one reason libibnetdisc is slower than subnet_discover
Date: Thu, 21 Jan 2010 18:14:18 -0800
Message-ID: <20100121181418.a9e955bb.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sasha,

Here is a patch which speeds up libibnetdisc by about 17%.  I am not going to pursue this much because I think a major rework of the library is necessary and I like your algorithm.  I see a couple of minor issues but I think they can be worked out.

Anyway here is the data for the patch below.  This is on Hyperion the test cluster I was using before.

17:38:26 > time ibnetdiscover --node-name-map=/etc/opensm/ib-node-name-map > old

real    0m3.174s
user    0m0.049s
sys     0m0.834s

18:15:42 > time ./ibnetdiscover --node-name-map=/etc/opensm/ib-node-name-map > new

real    0m2.625s
user    0m0.057s
sys     0m0.570s

18:15:49 > diff old new
2c2
< # Topology file: generated on Thu Jan 21 18:15:42 2010
---
> # Topology file: generated on Thu Jan 21 18:15:49 2010


Ira


>From 53a3f1936e0ec954a3c470cc5436ce4fd6be3b3e Mon Sep 17 00:00:00 2001
From: Ira Weiny <weiny2-ig7AzVSIIG5IWGcSWN6Auu1ftBKYq+Ku@public.gmane.org>
Date: Thu, 21 Jan 2010 17:13:37 -0800
Subject: [PATCH] optimize query_node

   recognize when we have found a switch we have already processed and skip the
   SwitchInfo and NodeDescription queries.

Signed-off-by: Ira Weiny <weiny2-ig7AzVSIIG5IWGcSWN6Auu1ftBKYq+Ku@public.gmane.org>
---
 infiniband-diags/libibnetdisc/src/ibnetdisc.c |   45 +++++++++++++++----------
 1 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc.c b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
index d0c97a1..fa0dbe4 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
@@ -101,19 +101,30 @@ static int query_node_info(struct ibmad_port *ibmad_port,
 	return 0;
 }
 
+static ibnd_node_t *find_existing_node(ibnd_fabric_t * fabric,
+				       uint64_t guid)
+{
+	int hash = HASHGUID(guid) % HTSZ;
+	ibnd_node_t *node;
+
+	for (node = fabric->nodestbl[hash]; node; node = node->htnext)
+		if (node->guid == guid)
+			return node;
+
+	return NULL;
+}
+
 static int query_node(struct ibmad_port *ibmad_port, ibnd_fabric_t * fabric,
 		      ibnd_node_t * node, ibnd_port_t * port,
 		      ib_portid_t * portid)
 {
 	int rc = 0;
 	void *nd = node->nodedesc;
+	ibnd_node_t *existing;
 
 	if ((rc = query_node_info(ibmad_port, fabric, node, portid)) != 0)
 		return rc;
 
-	if (!smp_query_via(nd, portid, IB_ATTR_NODE_DESC, 0, 0, ibmad_port))
-		return -1;
-
 	if ((rc = query_port_info(ibmad_port, portid, 0, port)) != 0)
 		return rc;
 
@@ -121,7 +132,7 @@ static int query_node(struct ibmad_port *ibmad_port, ibnd_fabric_t * fabric,
 	port->guid = mad_get_field64(node->info, 0, IB_NODE_PORT_GUID_F);
 
 	if (node->type != IB_NODE_SWITCH)
-		return 0;
+		goto query_nd;
 
 	node->smalid = port->base_lid;
 	node->smalmc = port->lmc;
@@ -135,6 +146,12 @@ static int query_node(struct ibmad_port *ibmad_port, ibnd_fabric_t * fabric,
 	port->base_lid = (uint16_t) node->smalid;	/* LID is still defined by port 0 */
 	port->lmc = (uint8_t) node->smalmc;
 
+	if ((existing = find_existing_node(fabric, node->guid)) != NULL) {
+		/* probably don't even need this memcpy */
+		memcpy(node, existing, sizeof *node);
+		return (0);
+	}
+
 	if (!smp_query_via(node->switchinfo, portid, IB_ATTR_SWITCH_INFO, 0, 0,
 			   ibmad_port))
 		node->smaenhsp0 = 0;	/* assume base SP0 */
@@ -144,6 +161,11 @@ static int query_node(struct ibmad_port *ibmad_port, ibnd_fabric_t * fabric,
 
 	IBND_DEBUG("portid %s: got switch node %" PRIx64 " '%s'\n",
 		   portid2str(portid), node->guid, node->nodedesc);
+
+query_nd:
+	if (!smp_query_via(nd, portid, IB_ATTR_NODE_DESC, 0, 0, ibmad_port))
+		return -1;
+
 	return 0;
 }
 
@@ -208,19 +230,6 @@ static void dump_endnode(ib_portid_t * path, char *prompt,
 	       port->base_lid + (1 << port->lmc) - 1, node->nodedesc);
 }
 
-static ibnd_node_t *find_existing_node(ibnd_fabric_t * fabric,
-				       ibnd_node_t * new)
-{
-	int hash = HASHGUID(new->guid) % HTSZ;
-	ibnd_node_t *node;
-
-	for (node = fabric->nodestbl[hash]; node; node = node->htnext)
-		if (node->guid == new->guid)
-			return node;
-
-	return NULL;
-}
-
 ibnd_node_t *ibnd_find_node_guid(ibnd_fabric_t * fabric, uint64_t guid)
 {
 	int hash = HASHGUID(guid) % HTSZ;
@@ -459,7 +468,7 @@ static int get_remote_node(struct ibmad_port *ibmad_port,
 		return 1;	/* positive == non-fatal error */
 	}
 
-	oldnode = find_existing_node(fabric, &node_buf);
+	oldnode = find_existing_node(fabric, node_buf.guid);
 	if (oldnode)
 		remotenode = oldnode;
 	else if (!(remotenode = create_node(fabric, scan, &node_buf, path,
-- 
1.5.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
