From: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [infiniband-diags] [PATCH] [3/3] splice out chassis scan specific
	from general scan in libibnetdiscover
Date: Tue, 17 Nov 2009 10:17:30 -0800
Message-ID: <1258481850.1335.98.camel@auk31.llnl.gov>
Reply-To: chu11-i2BcT+NCU+M@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-uJjOgYrumxUbErJY3qpw"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-uJjOgYrumxUbErJY3qpw
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hey Sasha,

With patch 2/3 the chassis code does not depend on the data structures
used in the scan, so we can splice out the chassis specific chunks.

Al

-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--=-uJjOgYrumxUbErJY3qpw
Content-Disposition: attachment; filename=0003-splice-out-chassis-scan-specific-from-general-scan.patch
Content-Type: text/plain; name=0003-splice-out-chassis-scan-specific-from-general-scan.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Mon, 16 Nov 2009 17:20:32 -0800
Subject: [PATCH] splice out chassis scan specific from general scan


Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 infiniband-diags/libibnetdisc/src/chassis.c   |   48 +++++++++++++-----------
 infiniband-diags/libibnetdisc/src/chassis.h   |    2 +-
 infiniband-diags/libibnetdisc/src/ibnetdisc.c |    2 +-
 infiniband-diags/libibnetdisc/src/internal.h  |    3 --
 4 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/src/chassis.c b/infiniband-diags/libibnetdisc/src/chassis.c
index c11fa8d..2ee2935 100644
--- a/infiniband-diags/libibnetdisc/src/chassis.c
+++ b/infiniband-diags/libibnetdisc/src/chassis.c
@@ -53,6 +53,12 @@ static char *ChassisTypeStr[5] =
     { "", "ISR9288", "ISR9096", "ISR2012", "ISR2004" };
 static char *ChassisSlotTypeStr[4] = { "", "Line", "Spine", "SRBD" };
 
+typedef struct chassis_scan {
+	ibnd_chassis_t *first_chassis;
+	ibnd_chassis_t *current_chassis;
+	ibnd_chassis_t *last_chassis;
+} chassis_scan_t;
+
 char *ibnd_get_chassis_type(ibnd_node_t * node)
 {
 	if (!node) {
@@ -777,19 +783,19 @@ static void voltaire_portmap(ibnd_port_t * port)
 		port->ext_portnum = int2ext_map_slb8[chipnum][portnum];
 }
 
-static int add_chassis(ibnd_scan_t *scan)
+static int add_chassis(chassis_scan_t * chassis_scan)
 {
-	if (!(scan->current_chassis = calloc(1, sizeof(ibnd_chassis_t)))) {
+	if (!(chassis_scan->current_chassis = calloc(1, sizeof(ibnd_chassis_t)))) {
 		IBND_ERROR("OOM: failed to allocate chassis object\n");
 		return -1;
 	}
 
-	if (scan->first_chassis == NULL) {
-		scan->first_chassis = scan->current_chassis;
-		scan->last_chassis = scan->current_chassis;
+	if (chassis_scan->first_chassis == NULL) {
+		chassis_scan->first_chassis = chassis_scan->current_chassis;
+		chassis_scan->last_chassis = chassis_scan->current_chassis;
 	} else {
-		scan->last_chassis->next = scan->current_chassis;
-		scan->last_chassis = scan->current_chassis;
+		chassis_scan->last_chassis->next = chassis_scan->current_chassis;
+		chassis_scan->last_chassis = chassis_scan->current_chassis;
 	}
 	return 0;
 }
@@ -813,16 +819,17 @@ static void add_node_to_chassis(ibnd_chassis_t * chassis, ibnd_node_t * node)
 	Returns:
 	0 on success, -1 on failure
 */
-int group_nodes(ibnd_fabric_t * fabric, ibnd_scan_t *scan)
+int group_nodes(ibnd_fabric_t * fabric)
 {
 	ibnd_node_t *node;
 	int chassisnum = 0;
 	ibnd_chassis_t *chassis;
 	ibnd_chassis_t *ch, *ch_next;
+	chassis_scan_t chassis_scan;
 
-	scan->first_chassis = NULL;
-	scan->current_chassis = NULL;
-	scan->last_chassis = NULL;
+	chassis_scan.first_chassis = NULL;
+	chassis_scan.current_chassis = NULL;
+	chassis_scan.last_chassis = NULL;
 
 	/* first pass on switches and build for every Voltaire node */
 	/* an appropriate chassis record (slotnum and position) */
@@ -845,10 +852,10 @@ int group_nodes(ibnd_fabric_t * fabric, ibnd_scan_t *scan)
 		    || (node->chassis && node->chassis->chassisnum)
 		    || !is_spine(node))
 			continue;
-		if (add_chassis(scan))
+		if (add_chassis(&chassis_scan))
 			goto cleanup;
-		scan->current_chassis->chassisnum = ++chassisnum;
-		if (build_chassis(node, scan->current_chassis))
+		chassis_scan.current_chassis->chassisnum = ++chassisnum;
+		if (build_chassis(node, chassis_scan.current_chassis))
 			goto cleanup;
 	}
 
@@ -865,11 +872,11 @@ int group_nodes(ibnd_fabric_t * fabric, ibnd_scan_t *scan)
 				chassis->nodecount++;
 			else {
 				/* Possible new chassis */
-				if (add_chassis(scan))
+				if (add_chassis(&chassis_scan))
 					goto cleanup;
-				scan->current_chassis->chassisguid =
+				chassis_scan.current_chassis->chassisguid =
 				    get_chassisguid(node);
-				scan->current_chassis->nodecount = 1;
+				chassis_scan.current_chassis->nodecount = 1;
 			}
 		}
 	}
@@ -895,18 +902,15 @@ int group_nodes(ibnd_fabric_t * fabric, ibnd_scan_t *scan)
 		}
 	}
 
-	fabric->chassis = scan->first_chassis;
+	fabric->chassis = chassis_scan.first_chassis;
 	return 0;
 
 cleanup:
-	ch = scan->first_chassis;
+	ch = chassis_scan.first_chassis;
 	while (ch) {
 		ch_next = ch->next;
 		free(ch);
 		ch = ch_next;
 	}
-	scan->first_chassis = NULL;
-	scan->current_chassis = NULL;
-	scan->last_chassis = NULL;
 	return -1;
 }
diff --git a/infiniband-diags/libibnetdisc/src/chassis.h b/infiniband-diags/libibnetdisc/src/chassis.h
index 7a96b02..2191046 100644
--- a/infiniband-diags/libibnetdisc/src/chassis.h
+++ b/infiniband-diags/libibnetdisc/src/chassis.h
@@ -82,6 +82,6 @@ enum ibnd_chassis_type {
 };
 enum ibnd_chassis_slot_type { UNRESOLVED_CS, LINE_CS, SPINE_CS, SRBD_CS };
 
-int group_nodes(struct ibnd_fabric *fabric, ibnd_scan_t *ibnd_scan);
+int group_nodes(struct ibnd_fabric *fabric);
 
 #endif				/* _CHASSIS_H_ */
diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc.c b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
index 650362e..9367337 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
@@ -618,7 +618,7 @@ ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port * ibmad_port,
 		}
 	}
 
-	if (group_nodes(fabric, &scan))
+	if (group_nodes(fabric))
 		goto error;
 
 	ibnd_scan_destroy(&scan);
diff --git a/infiniband-diags/libibnetdisc/src/internal.h b/infiniband-diags/libibnetdisc/src/internal.h
index 6776285..5af5f10 100644
--- a/infiniband-diags/libibnetdisc/src/internal.h
+++ b/infiniband-diags/libibnetdisc/src/internal.h
@@ -59,9 +59,6 @@ typedef struct ibnd_node_scan {
 
 typedef struct ibnd_scan {
 	ibnd_node_scan_t *nodesdist[MAXHOPS + 1];
-	ibnd_chassis_t *first_chassis;
-	ibnd_chassis_t *current_chassis;
-	ibnd_chassis_t *last_chassis;
 	ib_portid_t selfportid;
 } ibnd_scan_t;
 
-- 
1.5.4.5


--=-uJjOgYrumxUbErJY3qpw--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
