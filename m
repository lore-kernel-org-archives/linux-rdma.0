From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] ib-diags: Add cast to fix build on windows
Date: Thu, 22 Sep 2011 18:29:39 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E674F0@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Ira Weiny (weiny2-i2BcT+NCU+M@public.gmane.org)" <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 libibnetdisc/src/ibnetdisc.c |    2 +-
 src/ibportstate.c            |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)
 mode change 100644 => 100755 libibnetdisc/src/ibnetdisc.c
 mode change 100644 => 100755 src/ibportstate.c

diff --git a/libibnetdisc/src/ibnetdisc.c b/libibnetdisc/src/ibnetdisc.c
index 86210eb..c93e7ad
--- a/libibnetdisc/src/ibnetdisc.c
+++ b/libibnetdisc/src/ibnetdisc.c
@@ -201,7 +201,7 @@ static void debug_port(ib_portid_t * portid, ibnd_port_t * port)
 
 static int is_mlnx_ext_port_info_supported(ibnd_port_t * port)
 {
-	uint16_t devid = mad_get_field(port->node->info, 0, IB_NODE_DEVID_F);
+	uint16_t devid = (uint16_t) mad_get_field(port->node->info, 0, IB_NODE_DEVID_F);
 
 	if (devid == 0xc738)
 		return 1;
diff --git a/src/ibportstate.c b/src/ibportstate.c
index 81d5b58..daa8514
--- a/src/ibportstate.c
+++ b/src/ibportstate.c
@@ -462,7 +462,7 @@ int main(int argc, char **argv)
 		port_op = QUERY;
 
 	is_switch = get_node_info(&portid, data);
-	devid = mad_get_field(data, 0, IB_NODE_DEVID_F);
+	devid = (uint16_t) mad_get_field(data, 0, IB_NODE_DEVID_F);
 
 	if (port_op != QUERY || changed)
 		printf("Initial %s PortInfo:\n", is_switch ? "Switch" : "CA");
@@ -591,7 +591,7 @@ int main(int argc, char **argv)
 
 			/* Get peer port NodeInfo to obtain peer port number */
 			is_peer_switch = get_node_info(&peerportid, data);
-			rem_devid = mad_get_field(data, 0, IB_NODE_DEVID_F);
+			rem_devid = (uint16_t) mad_get_field(data, 0, IB_NODE_DEVID_F);
 
 			mad_decode_field(data, IB_NODE_LOCAL_PORT_F,
 					 &peerlocalportnum);


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
