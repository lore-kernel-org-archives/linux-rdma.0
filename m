From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_sa.c: Fix commentary typo
Date: Mon, 04 Apr 2011 14:45:52 -0400
Message-ID: <4D9A11E0.2000802@dev.mellanox.co.il>
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
diff --git a/opensm/osm_sa.c b/opensm/osm_sa.c
index 8076160..bbd1a56 100644
--- a/opensm/osm_sa.c
+++ b/opensm/osm_sa.c
@@ -1113,7 +1113,7 @@ int osm_sa_db_file_load(osm_opensm_t * p_osm)
 	/*
 	 * If loading succeeded, do whatever 'no_clients_rereg' says.
 	 * If loading failed at some point, turn off the 'no_clients_rereg'
-	 * option (turn on re-registartion requests).
+	 * option (turn on re-registration requests).
 	 */
 	if (rereg_clients)
 		p_osm->subn.opt.no_clients_rereg = FALSE;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
