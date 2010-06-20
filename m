From: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] opensm: Fix wrong messages in MC delete flow
Date: Sun, 20 Jun 2010 12:31:55 +0300
Message-ID: <4C1DE00B.3030202@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yossi Etigin <yosefe-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Fix wrong messages in MC delete and update flows.
The requester GID was wrong.

Signed-off-by: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_sa_mcmember_record.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/opensm/opensm/osm_sa_mcmember_record.c b/opensm/opensm/osm_sa_mcmember_record.c
index 07aeb6c..eda2fdd 100644
--- a/opensm/opensm/osm_sa_mcmember_record.c
+++ b/opensm/opensm/osm_sa_mcmember_record.c
@@ -405,8 +405,7 @@ static boolean_t validate_modify(IN osm_sa_t * sa, IN osm_mgrp_t * p_mgrp,
 				"0x%016" PRIx64 " request:0x%016" PRIx64 "\n",
 				cl_ntoh64((*pp_mcm_port)->port_gid.unicast.
 					  interface_id),
-				cl_ntoh64(p_mad_addr->addr_type.gsi.grh_info.
-					  src_gid.unicast.interface_id));
+				cl_ntoh64(request_gid.unicast.interface_id));
 			return FALSE;
 		}
 	} else {
@@ -422,11 +421,9 @@ static boolean_t validate_modify(IN osm_sa_t * sa, IN osm_mgrp_t * p_mgrp,
 					p_request_physp)) {
 			/* the request port is not part of the partition for this mgrp */
 			OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
-				"ProxyJoin but port not in partition. stored:"
-				"0x%016" PRIx64 " request:0x%016" PRIx64 "\n",
-				cl_ntoh64((*pp_mcm_port)->port->guid),
-				cl_ntoh64(p_mad_addr->addr_type.gsi.grh_info.
-					  src_gid.unicast.interface_id));
+				"Requesting port 0x%016" PRIx64 " has no P_Key 0x%04x\n",
+				cl_ntoh64(p_request_physp->port_guid), 
+				cl_ntoh16(p_mgrp->mcmember_rec.pkey));
 			return FALSE;
 		}
 	}
-- 
1.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
