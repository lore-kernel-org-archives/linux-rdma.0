From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 8/11] opensm/osm_prtn.c: Cosmetic formatting change
Date: Fri, 01 Apr 2011 14:38:15 -0400
Message-ID: <4D961B97.2010906@dev.mellanox.co.il>
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
diff --git a/opensm/osm_prtn.c b/opensm/osm_prtn.c
index 6a23c76..3fd4fc0 100644
--- a/opensm/osm_prtn.c
+++ b/opensm/osm_prtn.c
@@ -253,7 +253,6 @@ osm_prtn_t *osm_prtn_make_new(osm_log_t * p_log,
osm_subn_t * p_subn,
 	osm_prtn_t *p = NULL, *p_check;

 	pkey &= cl_hton16((uint16_t) ~ 0x8000);
-
 	if (!pkey) {
 		if (name && (p = osm_prtn_find_by_name(p_subn, name)))
 			return p;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
