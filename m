From: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] opensm: bug in trap report for MC create(66) and delete(67)
 traps
Date: Tue, 02 Feb 2010 16:13:12 +0200
Message-ID: <4B6832F8.9090200@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Koushnir <vladimirk-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


In this case the GID in the data details is the MGID and
not the source gid. So the SM gid should be taken as the source gid.
There was also an error in comparing the subnet prefix and guid due to
host/network order mismatch.

Signed-off-by: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_inform.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/opensm/opensm/osm_inform.c b/opensm/opensm/osm_inform.c
index 8108213..5f48376 100644
--- a/opensm/opensm/osm_inform.c
+++ b/opensm/opensm/osm_inform.c
@@ -460,18 +460,16 @@ static void match_notice_to_inf_rec(IN cl_list_item_t * p_list_item,
 		}
 	}
 
-	/* Check if there is a pkey match. o13-17.1.1 */
-	/* Check if the issuer of the trap is the SM. If it is, then the gid
+	/* In case of GID IN(64) or GID OUT(65) traps the source gid
 	   comparison should be done on the trap source (saved as the gid in the
 	   data details field).
-	   If the issuer gid is not the SM - then it is the guid of the trap
-	   source */
-	if ((cl_ntoh64(p_ntc->issuer_gid.unicast.prefix) ==
-	     p_subn->opt.subnet_prefix)
-	    && (cl_ntoh64(p_ntc->issuer_gid.unicast.interface_id) ==
-		p_subn->sm_port_guid))
-		/* The issuer is the SM then this is trap 64-67 - compare the gid
-		   with the gid saved on the data details */
+	   In all other cases the issuer gis is the trap source.
+	   This is also the case for MC CREATE(66) and MC DELETE(67) where the
+	   data details gid is MGID */
+	if (p_ntc->g_or_v.generic.trap_num == 64 ||
+	    p_ntc->g_or_v.generic.trap_num == 65 )
+		/* The issuer of these traps is the SM so source_gid 
+		   is the gid saved on the data details */
 		source_gid = p_ntc->data_details.ntc_64_67.gid;
 	else
 		source_gid = p_ntc->issuer_gid;
@@ -495,6 +493,7 @@ static void match_notice_to_inf_rec(IN cl_list_item_t * p_list_item,
 		goto Exit;
 	}
 
+	/* Check if there is a pkey match. o13-17.1.1 */
 	if (osm_port_share_pkey(p_log, p_src_port, p_dest_port) == FALSE) {
 		OSM_LOG(p_log, OSM_LOG_DEBUG, "Mismatch by Pkey\n");
 		/* According to o13-17.1.2 - If this informInfo does not have
-- 
1.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
