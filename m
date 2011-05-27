From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_db_files.c: In osm_db_delete, don't free p_key
Date: Fri, 27 May 2011 13:52:12 -0400
Message-ID: <4DDFE4CC.7000501@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


since it's not malloc'd memory

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_db_files.c b/opensm/osm_db_files.c
index 3182da4..e8fd40e 100644
--- a/opensm/osm_db_files.c
+++ b/opensm/osm_db_files.c
@@ -594,7 +594,6 @@ int osm_db_delete(IN osm_db_domain_t * p_domain, IN char *p_key)
 				p_key, p_domain_imp->file_name, p_prev_val);
 			res = 1;
 		} else {
-			free(p_key);
 			free(p_prev_val);
 			res = 0;
 		}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
