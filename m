From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_opensm.c: Conditionalize sa_db_file_dump on sa_db_dump
 option
Date: Sat, 26 Mar 2011 00:10:35 +0200
Message-ID: <4D8D12DB.2060805@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

in osm_opensm_destroy

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/opensm/osm_opensm.c b/opensm/opensm/osm_opensm.c
index 0de5fa4..5007dd2 100644
--- a/opensm/opensm/osm_opensm.c
+++ b/opensm/opensm/osm_opensm.c
@@ -273,7 +273,8 @@ void osm_opensm_destroy(IN osm_opensm_t * p_osm)
      cl_disp_shutdown(&p_osm->disp);

      /* dump SA DB */
-    osm_sa_db_file_dump(p_osm);
+    if (p_osm->subn.opt.sa_db_dump)
+        osm_sa_db_file_dump(p_osm);

      /* do the destruction in reverse order as init */
      destroy_plugins(p_osm);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
