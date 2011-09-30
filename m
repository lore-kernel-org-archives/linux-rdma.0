From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_sa_path_record.c: Remove unused osm_get_path_params
 routine
Date: Fri, 30 Sep 2011 12:48:17 -0400
Message-ID: <4E85F2D1.2080609@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_sa_path_record.c b/opensm/osm_sa_path_record.c
index 266c5c5..1f36326 100644
--- a/opensm/osm_sa_path_record.c
+++ b/opensm/osm_sa_path_record.c
@@ -836,18 +836,6 @@ Exit:
 	return status;
 }
 
-ib_api_status_t osm_get_path_params(IN osm_sa_t * sa,
-				    IN const osm_port_t * p_src_port,
-				    IN const osm_port_t * p_dest_port,
-				    IN const uint16_t dlid_ho,
-				    OUT osm_path_parms_t * p_parms)
-{
-	ib_path_rec_t pr;
-	memset(&pr, 0, sizeof(ib_path_rec_t));
-	return pr_rcv_get_path_parms(sa, &pr,
-		p_src_port, p_dest_port, dlid_ho, 0, p_parms);
-}
-
 static void pr_rcv_build_pr(IN osm_sa_t * sa, IN const osm_port_t * p_src_port,
 			    IN const osm_port_t * p_dest_port,
 			    IN const ib_gid_t * p_dgid,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
