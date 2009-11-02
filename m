From: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [infiniband-diags] [PATCH] [1/2] remove ibnd_update_node
Date: Mon, 02 Nov 2009 11:33:17 -0800
Message-ID: <1257190397.580.30.camel@auk31.llnl.gov>
Reply-To: chu11-i2BcT+NCU+M@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-1DysEWaic2ycxJcUxT5y"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-1DysEWaic2ycxJcUxT5y
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hey Sasha,

After talking to Ira about it, we think it's best remove
ibnd_update_node.

A) It's not being used.
B) It probably not implemented properly
C) Some of Ira's original plans for its use require more API functions
to be added, which of course isn't done right now.

So for now, it seems best to just remove it since it's an additional
API function that can lead to confusion.

Al

-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--=-1DysEWaic2ycxJcUxT5y
Content-Disposition: attachment; filename=0001-remove-ibnd_update_node.patch
Content-Type: text/plain; name=0001-remove-ibnd_update_node.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Thu, 29 Oct 2009 18:56:32 -0700
Subject: [PATCH] remove ibnd_update_node


Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 .../libibnetdisc/include/infiniband/ibnetdisc.h    |    3 -
 infiniband-diags/libibnetdisc/src/ibnetdisc.c      |   55 --------------------
 2 files changed, 0 insertions(+), 58 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h b/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
index bb5df02..6120453 100644
--- a/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
+++ b/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
@@ -172,9 +172,6 @@ MAD_EXPORT void ibnd_destroy_fabric(ibnd_fabric_t * fabric);
 MAD_EXPORT ibnd_node_t *ibnd_find_node_guid(ibnd_fabric_t * fabric,
 					    uint64_t guid);
 MAD_EXPORT ibnd_node_t *ibnd_find_node_dr(ibnd_fabric_t * fabric, char *dr_str);
-MAD_EXPORT ibnd_node_t *ibnd_update_node(struct ibmad_port *ibmad_port,
-					 ibnd_fabric_t * fabric,
-					 ibnd_node_t * node);
 
 typedef void (*ibnd_iter_node_func_t) (ibnd_node_t * node, void *user_data);
 MAD_EXPORT void ibnd_iter_nodes(ibnd_fabric_t * fabric,
diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc.c b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
index ebc45ba..ffa35e4 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
@@ -264,61 +264,6 @@ static int _check_ibmad_port(struct ibmad_port *ibmad_port)
 	return 0;
 }
 
-ibnd_node_t *ibnd_update_node(struct ibmad_port * ibmad_port,
-			      ibnd_fabric_t * fabric, ibnd_node_t * node)
-{
-	char portinfo_port0[IB_SMP_DATA_SIZE];
-	void *nd = node->nodedesc;
-	int p = 0;
-
-	if (_check_ibmad_port(ibmad_port) < 0)
-		return NULL;
-
-	if (!fabric) {
-		IBND_DEBUG("fabric parameter NULL\n");
-		return NULL;
-	}
-
-	if (!node) {
-		IBND_DEBUG("node parameter NULL\n");
-		return NULL;
-	}
-
-	if (query_node_info(ibmad_port, fabric, node, &(node->path_portid)))
-		return NULL;
-
-	if (!smp_query_via(nd, &(node->path_portid), IB_ATTR_NODE_DESC, 0, 0,
-			   ibmad_port))
-		return NULL;
-
-	/* update all the port info's */
-	for (p = 1; p >= node->numports; p++) {
-		get_port_info(ibmad_port, fabric, node->ports[p],
-			      p, &(node->path_portid));
-	}
-
-	if (node->type != IB_NODE_SWITCH)
-		goto done;
-
-	if (!smp_query_via
-	    (portinfo_port0, &(node->path_portid), IB_ATTR_PORT_INFO, 0, 0,
-	     ibmad_port))
-		return NULL;
-
-	node->smalid = mad_get_field(portinfo_port0, 0, IB_PORT_LID_F);
-	node->smalmc = mad_get_field(portinfo_port0, 0, IB_PORT_LMC_F);
-
-	if (!smp_query_via(node->switchinfo, &(node->path_portid),
-			   IB_ATTR_SWITCH_INFO, 0, 0, ibmad_port))
-		node->smaenhsp0 = 0;	/* assume base SP0 */
-	else
-		mad_decode_field(node->switchinfo, IB_SW_ENHANCED_PORT0_F,
-				 &node->smaenhsp0);
-
-done:
-	return node;
-}
-
 ibnd_node_t *ibnd_find_node_dr(ibnd_fabric_t * fabric, char *dr_str)
 {
 	int i = 0;
-- 
1.5.4.5


--=-1DysEWaic2ycxJcUxT5y--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
