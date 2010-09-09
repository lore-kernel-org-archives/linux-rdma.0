From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_db_files.c: malloc() return value run-time check
Date: Thu, 9 Sep 2010 17:47:27 +0300
Message-ID: <20100909144727.GF11502@me>
References: <4C8654C0.7020208@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4C8654C0.7020208-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Check a return value of malloc() run-time instead of debug macro.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_db_files.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/opensm/opensm/osm_db_files.c b/opensm/opensm/osm_db_files.c
index 07a9ce0..18ac830 100644
--- a/opensm/opensm/osm_db_files.c
+++ b/opensm/opensm/osm_db_files.c
@@ -157,7 +157,10 @@ int osm_db_init(IN osm_db_t * p_db, IN osm_log_t * p_log)
 	OSM_LOG_ENTER(p_log);
 
 	p_db_imp = malloc(sizeof(osm_db_imp_t));
-	CL_ASSERT(p_db_imp != NULL);
+	if (!p_db_imp) {
+		OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 6100: No memory.\n");
+		return -1;
+	}
 
 	p_db_imp->db_dir_name = getenv("OSM_CACHE_DIR");
 	if (!p_db_imp->db_dir_name || !(*p_db_imp->db_dir_name))
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
