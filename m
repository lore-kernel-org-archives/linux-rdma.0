From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 7/11] opensm/osm_pkey.c: Cosmetic formatting change
Date: Fri, 01 Apr 2011 14:38:10 -0400
Message-ID: <4D961B92.8080201@dev.mellanox.co.il>
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
index 4c5a852..1032317 100644
--- a/opensm/osm_pkey.c
+++ b/opensm/osm_pkey.c
@@ -380,7 +380,6 @@ Exit:
 boolean_t osm_physp_has_pkey(IN osm_log_t * p_log, IN ib_net16_t pkey,
 			     IN const osm_physp_t * p_physp)
 {
-
 	ib_net16_t *p_pkey, pkey_base;
 	const osm_pkey_tbl_t *pkey_tbl;
 	boolean_t res = FALSE;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
