From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_sa_infrominfo.c: fixes and simplifications in
 lid range check
Date: Thu, 7 Jan 2010 14:20:09 +0200
Message-ID: <20100107122009.GB26089@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


In function validate_ports_access_rights() in case when lid range is
ended by out of range lid value (not allocated by SM) truncate it to
valid one. Check lids for out of range only error once and not in a
loop.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_sa_informinfo.c |   28 ++++++++++++++++------------
 1 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/opensm/opensm/osm_sa_informinfo.c b/opensm/opensm/osm_sa_informinfo.c
index c1ab481..9fb3608 100644
--- a/opensm/opensm/osm_sa_informinfo.c
+++ b/opensm/opensm/osm_sa_informinfo.c
@@ -91,7 +91,6 @@ static boolean_t validate_ports_access_rights(IN osm_sa_t * sa,
 	osm_port_t *p_port;
 	ib_net64_t portguid;
 	uint16_t lid_range_begin, lid_range_end, lid;
-	const cl_ptr_vector_t *p_tbl;
 
 	OSM_LOG_ENTER(sa->p_log);
 
@@ -124,6 +123,8 @@ static boolean_t validate_ports_access_rights(IN osm_sa_t * sa,
 			goto Exit;
 		}
 	} else {
+		size_t lids_size;
+
 		/* gid is zero - check if LID range is defined */
 		lid_range_begin =
 		    cl_ntoh16(p_infr_rec->inform_record.inform_info.
@@ -136,25 +137,28 @@ static boolean_t validate_ports_access_rights(IN osm_sa_t * sa,
 		    cl_ntoh16(p_infr_rec->inform_record.inform_info.
 			      lid_range_end);
 
+		lids_size = cl_ptr_vector_get_size(&sa->p_subn->port_lid_tbl);
+
 		/* lid_range_end is set to zero if no range desired. In this
 		   case - just make it equal to the lid_range_begin. */
 		if (lid_range_end == 0)
 			lid_range_end = lid_range_begin;
+		else if (lid_range_end >= lids_size)
+			lid_range_end = lids_size - 1;
+
+		if (lid_range_begin >= lids_size) {
+			/* requested lids are out of range */
+			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 4302: "
+				"Given LIDs (%u-%u) are out of range (%zu)\n",
+				lid_range_begin, lid_range_end, lids_size);
+			valid = FALSE;
+			goto Exit;
+		}
 
 		/* go over all defined lids within the range and make sure that the
 		   requester port can access them according to current partitioning. */
 		for (lid = lid_range_begin; lid <= lid_range_end; lid++) {
-			p_tbl = &sa->p_subn->port_lid_tbl;
-			if (cl_ptr_vector_get_size(p_tbl) > lid)
-				p_port = cl_ptr_vector_get(p_tbl, lid);
-			else {
-				/* lid requested is out of range */
-				OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 4302: "
-					"Given LID (%u) is out of range:%u\n",
-					lid, cl_ptr_vector_get_size(p_tbl));
-				valid = FALSE;
-				goto Exit;
-			}
+			p_port = osm_get_port_by_lid(sa->p_subn, cl_hton16(lid));
 			if (p_port == NULL)
 				continue;
 
-- 
1.6.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
