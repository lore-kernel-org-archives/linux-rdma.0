From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 4/11] opensm/osm_pkey.c: Minor change to comment
Date: Fri, 01 Apr 2011 14:37:44 -0400
Message-ID: <4D961B78.3040308@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_pkey.c b/opensm/osm_pkey.c
index 4c5a852..da36219 100644
--- a/opensm/osm_pkey.c
+++ b/opensm/osm_pkey.c
@@ -137,7 +137,7 @@ ib_api_status_t osm_pkey_tbl_set(IN osm_pkey_tbl_t *
p_pkey_tbl,
 	   tables there is no other way but to refresh the entire keys map.

 	   Moreover, if the same key exists but with full membership it should
-	   have precedence on the key with limited membership !
+	   have precedence over the key with limited membership !
 	 */
 	cl_map_remove_all(&p_pkey_tbl->keys);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
