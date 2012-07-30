From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_sa_path_record.c: Restore osm_get_path_params
 functionality
Date: Mon, 30 Jul 2012 07:34:47 -0400
Message-ID: <50167157.9080301@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


based on alias GUID support which caused change to internal
pr_rcv_get_path_parms API

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_sa_path_record.c b/opensm/osm_sa_path_record.c
index 70e7b61..dd15046 100644
--- a/opensm/osm_sa_path_record.c
+++ b/opensm/osm_sa_path_record.c
@@ -854,7 +854,17 @@ ib_api_status_t osm_get_path_params(IN osm_sa_t * sa,
 				    IN const uint16_t dlid_ho,
 				    OUT osm_path_parms_t * p_parms)
 {
-	return 1;
+	osm_alias_guid_t *p_src_alias_guid, *p_dest_alias_guid;
+	ib_path_rec_t pr;
+
+	memset(&pr, 0, sizeof(ib_path_rec_t));
+	p_src_alias_guid = osm_get_alias_guid_by_guid(sa->p_subn,
+						      osm_port_get_guid(p_src_port));
+	p_dest_alias_guid = osm_get_alias_guid_by_guid(sa->p_subn,
+						       osm_port_get_guid(p_dest_port));
+	return pr_rcv_get_path_parms(sa, &pr,
+				     p_src_alias_guid, slid_ho,
+				     p_dest_alias_guid, dlid_ho, 0, p_parms);
 }
 
 static void pr_rcv_build_pr(IN osm_sa_t * sa,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
