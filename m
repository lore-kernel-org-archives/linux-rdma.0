From: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [infiniband-diags] [PATCH] [1/3] remove unnecessary casting in
	libibnetdiscover
Date: Tue, 17 Nov 2009 10:16:14 -0800
Message-ID: <1258481774.1335.95.camel@auk31.llnl.gov>
Reply-To: chu11-i2BcT+NCU+M@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-KgfjuL+uR9OFApIIWHt1"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-KgfjuL+uR9OFApIIWHt1
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hey Sasha,

I noticed a bunch of unnecessary casting.  The typing is done correctly
throughout the code, so I assume the casting was done due to legacy
reasons.

Al

-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--=-KgfjuL+uR9OFApIIWHt1
Content-Disposition: attachment; filename=0001-remove-unnecessary-casting-in-libibnetdiscover.patch
Content-Type: text/plain; name=0001-remove-unnecessary-casting-in-libibnetdiscover.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Mon, 16 Nov 2009 17:14:34 -0800
Subject: [PATCH] remove unnecessary casting in libibnetdiscover


Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 infiniband-diags/libibnetdisc/src/chassis.c |   28 ++++++++++----------------
 1 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/src/chassis.c b/infiniband-diags/libibnetdisc/src/chassis.c
index 3bd0108..a8b6767 100644
--- a/infiniband-diags/libibnetdisc/src/chassis.c
+++ b/infiniband-diags/libibnetdisc/src/chassis.c
@@ -346,30 +346,28 @@ char anafa_spine4_slot_2_slb[25] = {
 
 /*	reference                     { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 }; */
 
-static int get_sfb_slot(ibnd_node_t * node, ibnd_port_t * lineport)
+static int get_sfb_slot(ibnd_node_t * n, ibnd_port_t * lineport)
 {
-	ibnd_node_t *n = (ibnd_node_t *) node;
-
 	n->ch_slot = SPINE_CS;
-	if (is_spine_9096(node)) {
+	if (is_spine_9096(n)) {
 		n->ch_type = ISR9096_CT;
 		n->ch_slotnum = spine4_slot_2_slb[lineport->portnum];
 		n->ch_anafanum = anafa_spine4_slot_2_slb[lineport->portnum];
-	} else if (is_spine_9288(node)) {
+	} else if (is_spine_9288(n)) {
 		n->ch_type = ISR9288_CT;
 		n->ch_slotnum = spine12_slot_2_slb[lineport->portnum];
 		n->ch_anafanum = anafa_spine12_slot_2_slb[lineport->portnum];
-	} else if (is_spine_2012(node)) {
+	} else if (is_spine_2012(n)) {
 		n->ch_type = ISR2012_CT;
 		n->ch_slotnum = spine12_slot_2_slb[lineport->portnum];
 		n->ch_anafanum = anafa_spine12_slot_2_slb[lineport->portnum];
-	} else if (is_spine_2004(node)) {
+	} else if (is_spine_2004(n)) {
 		n->ch_type = ISR2004_CT;
 		n->ch_slotnum = spine4_slot_2_slb[lineport->portnum];
 		n->ch_anafanum = anafa_spine4_slot_2_slb[lineport->portnum];
 	} else {
 		IBND_ERROR("Unexpected node found: guid 0x%016" PRIx64,
-			   node->guid);
+			   n->guid);
 		return -1;
 	}
 	return 0;
@@ -653,7 +651,7 @@ static int build_chassis(ibnd_node_t * node, ibnd_chassis_t * chassis)
 	ibnd_port_t *port = 0;
 
 	/* we get here with node = chassis_spine */
-	if (insert_spine((ibnd_node_t *) node, chassis))
+	if (insert_spine(node, chassis))
 		return -1;
 
 	/* loop: pass on all ports of node */
@@ -874,8 +872,7 @@ int group_nodes(ibnd_fabric_t * fabric, ibnd_scan_t *scan)
 			if (mad_get_field64(node->info, 0,
 					    IB_NODE_SYSTEM_GUID_F)) {
 				chassis =
-				    find_chassisguid(fabric,
-						     (ibnd_node_t *) node);
+				    find_chassisguid(fabric, node);
 				if (chassis)
 					chassis->nodecount++;
 				else {
@@ -883,8 +880,7 @@ int group_nodes(ibnd_fabric_t * fabric, ibnd_scan_t *scan)
 					if (add_chassis(scan))
 						goto cleanup;
 					scan->current_chassis->chassisguid =
-					    get_chassisguid((ibnd_node_t *)
-							    node);
+					    get_chassisguid(node);
 					scan->current_chassis->nodecount = 1;
 				}
 			}
@@ -902,8 +898,7 @@ int group_nodes(ibnd_fabric_t * fabric, ibnd_scan_t *scan)
 			if (mad_get_field64(node->info, 0,
 					    IB_NODE_SYSTEM_GUID_F)) {
 				chassis =
-				    find_chassisguid(fabric,
-						     (ibnd_node_t *) node);
+				    find_chassisguid(fabric, node);
 				if (chassis && chassis->nodecount > 1) {
 					if (!chassis->chassisnum)
 						chassis->chassisnum =
@@ -911,8 +906,7 @@ int group_nodes(ibnd_fabric_t * fabric, ibnd_scan_t *scan)
 					if (!node->ch_found) {
 						node->ch_found = 1;
 						add_node_to_chassis(chassis,
-								    (ibnd_node_t
-								     *) node);
+								    node);
 					}
 				}
 			}
-- 
1.5.4.5


--=-KgfjuL+uR9OFApIIWHt1--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
