From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] Fix the creation of empty multicast groups from SADB
Date: Sun, 04 May 2014 03:21:43 -0400
Message-ID: <5365EA87.1050308@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Daniel Klein <danielk-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Mon, 17 Mar 2014 13:10:01 +0200

Modified OpenSM behavior when parsing multicast groups from SADB file:
1. Ignore "well known" flag - only groups defined in partition.conf are
   considered as "well known".
2. Avoid creating groups that are not "well known" without any full
   members.

Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sa.c |   67 ++++++++++++++++++++++++++++++++++++++----------------
 1 files changed, 47 insertions(+), 20 deletions(-)

diff --git a/opensm/osm_sa.c b/opensm/osm_sa.c
index bb82de7..9b7cb61 100644
--- a/opensm/osm_sa.c
+++ b/opensm/osm_sa.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2012 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2014 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2008 Xsigo Systems Inc.  All rights reserved.
  *
@@ -801,8 +801,7 @@ int osm_sa_db_file_dump(osm_opensm_t * p_osm)
  *  SA DB Loader
  */
 static osm_mgrp_t *load_mcgroup(osm_opensm_t * p_osm, ib_net16_t mlid,
-				ib_member_rec_t * p_mcm_rec,
-				unsigned well_known)
+				ib_member_rec_t * p_mcm_rec)
 {
 	ib_net64_t comp_mask;
 	osm_mgrp_t *p_mgrp;
@@ -835,8 +834,7 @@ static osm_mgrp_t *load_mcgroup(osm_opensm_t * p_osm, ib_net16_t mlid,
 			cl_ntoh64(p_mcm_rec->mgid.unicast.prefix),
 			cl_ntoh64(p_mcm_rec->mgid.unicast.interface_id));
 		p_mgrp = NULL;
-	} else if (well_known)
-		p_mgrp->well_known = TRUE;
+	}
 
 _out:
 	cl_plock_release(&p_osm->lock);
@@ -1058,13 +1056,29 @@ static int unpack_string64(char *p, uint8_t * buf)
 	p += _ret; \
 }
 
+static void sa_db_file_load_handle_mgrp(osm_opensm_t * p_osm,
+					osm_mgrp_t * p_mgrp)
+{
+	/* decide whether to delete the mgrp object or not */
+	if (p_mgrp->full_members == 0 && !p_mgrp->well_known) {
+		OSM_LOG(&p_osm->log, OSM_LOG_VERBOSE,
+			"Closing MC group 0x%016" PRIx64 ":0x%016" PRIx64
+			" - no full members were added to not well known "
+			"group\n",
+			cl_ntoh64(p_mgrp->mcmember_rec.mgid.unicast.prefix),
+			cl_ntoh64(p_mgrp->mcmember_rec.mgid.unicast.interface_id));
+		osm_mgrp_cleanup(&p_osm->subn, p_mgrp);
+	}
+}
+
 int osm_sa_db_file_load(osm_opensm_t * p_osm)
 {
 	char line[1024];
 	char *file_name;
 	FILE *file;
 	int ret = 0;
-	osm_mgrp_t *p_mgrp = NULL;
+	osm_mgrp_t *p_next_mgrp = NULL;
+	osm_mgrp_t *p_prev_mgrp = NULL;
 	unsigned rereg_clients = 0;
 	unsigned lineno;
 
@@ -1111,14 +1125,11 @@ int osm_sa_db_file_load(osm_opensm_t * p_osm)
 		if (!strncmp(p, "MC Group", 8)) {
 			ib_member_rec_t mcm_rec;
 			ib_net16_t mlid;
-			unsigned well_known = 0;
 
-			p_mgrp = NULL;
+			p_next_mgrp = NULL;
 			memset(&mcm_rec, 0, sizeof(mcm_rec));
 
 			PARSE_AHEAD(p, net16, " 0x", &mlid);
-			if (strstr(p, "well known"))
-				well_known = 1;
 			PARSE_AHEAD(p, net64, " mgid=0x",
 				    &mcm_rec.mgid.unicast.prefix);
 			PARSE_AHEAD(p, net64, ":0x",
@@ -1141,13 +1152,12 @@ int osm_sa_db_file_load(osm_opensm_t * p_osm)
 			PARSE_AHEAD(p, net8, " proxy_join=0x", &val);
 			mcm_rec.proxy_join = val;
 
-			p_mgrp = load_mcgroup(p_osm, mlid, &mcm_rec,
-					      well_known);
-			if (!p_mgrp)
+			p_next_mgrp = load_mcgroup(p_osm, mlid, &mcm_rec);
+			if (!p_next_mgrp)
 				rereg_clients = 1;
 			if (cl_ntoh16(mlid) > p_osm->sm.mlids_init_max)
 				p_osm->sm.mlids_init_max = cl_ntoh16(mlid);
-		} else if (p_mgrp && !strncmp(p, "mcm_port", 8)) {
+		} else if (p_next_mgrp && !strncmp(p, "mcm_port", 8)) {
 			ib_member_rec_t mcmr;
 			ib_net64_t guid;
 			osm_port_t *port;
@@ -1164,16 +1174,16 @@ int osm_sa_db_file_load(osm_opensm_t * p_osm)
 			guid = mcmr.port_gid.unicast.interface_id;
 			port = osm_get_port_by_alias_guid(&p_osm->subn, guid);
 			if (port &&
-			    cl_qmap_get(&p_mgrp->mcm_port_tbl, guid) ==
-			    cl_qmap_end(&p_mgrp->mcm_port_tbl) &&
+			    cl_qmap_get(&p_next_mgrp->mcm_port_tbl, guid) ==
+			    cl_qmap_end(&p_next_mgrp->mcm_port_tbl) &&
 			    !osm_mgrp_add_port(&p_osm->subn, &p_osm->log,
-						p_mgrp, port, &mcmr, proxy))
+						p_next_mgrp, port, &mcmr, proxy))
 				rereg_clients = 1;
 		} else if (!strncmp(p, "Service Record:", 15)) {
 			ib_service_record_t s_rec;
 			uint32_t modified_time, lease_period;
 
-			p_mgrp = NULL;
+			p_next_mgrp = NULL;
 			memset(&s_rec, 0, sizeof(s_rec));
 
 			PARSE_AHEAD(p, net64, " id=0x", &s_rec.service_id);
@@ -1217,7 +1227,7 @@ int osm_sa_db_file_load(osm_opensm_t * p_osm)
 			osm_mad_addr_t rep_addr;
 			ib_net16_t val16;
 
-			p_mgrp = NULL;
+			p_next_mgrp = NULL;
 			memset(&i_rec, 0, sizeof(i_rec));
 			memset(&rep_addr, 0, sizeof(rep_addr));
 
@@ -1272,7 +1282,7 @@ int osm_sa_db_file_load(osm_opensm_t * p_osm)
 			ib_guidinfo_record_t gi_rec;
 			ib_net64_t base_guid;
 
-			p_mgrp = NULL;
+			p_next_mgrp = NULL;
 			memset(&gi_rec, 0, sizeof(gi_rec));
 
 			PARSE_AHEAD(p, net64, " base_guid=0x", &base_guid);
@@ -1299,8 +1309,25 @@ int osm_sa_db_file_load(osm_opensm_t * p_osm)
 			if (load_guidinfo(p_osm, base_guid, &gi_rec))
 				rereg_clients = 1;
 		}
+
+		/*
+		 * p_next_mgrp points to the multicast group now being parsed.
+		 * p_prev_mgrp points to the last multicast group we parsed.
+		 * We decide whether to keep or delete each multicast group
+		 * only when we finish parsing it's member records. if the
+		 * group has full members, or it is a "well known group" we
+		 * keep it.
+		 */
+		if (p_prev_mgrp != p_next_mgrp) {
+			if (p_prev_mgrp)
+				sa_db_file_load_handle_mgrp(p_osm, p_prev_mgrp);
+			p_prev_mgrp = p_next_mgrp;
+		}
 	}
 
+	if (p_next_mgrp)
+		sa_db_file_load_handle_mgrp(p_osm, p_prev_mgrp);
+
 	/*
 	 * If loading succeeded, do whatever 'no_clients_rereg' says.
 	 * If loading failed at some point, turn off the 'no_clients_rereg'
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
