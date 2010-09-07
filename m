From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] opensm/osm_db_files.c: fix small memory leak
Date: Tue, 7 Sep 2010 18:05:36 +0300
Message-ID: <4C8654C0.7020208@mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/osm_db_files.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/opensm/opensm/osm_db_files.c b/opensm/opensm/osm_db_files.c
index c475004..603bcf2 100644
--- a/opensm/opensm/osm_db_files.c
+++ b/opensm/opensm/osm_db_files.c
@@ -175,6 +175,7 @@ int osm_db_init(IN osm_db_t * p_db, IN osm_log_t * p_log)
 			OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 6101: "
 				"Failed to create the db directory:%s\n",
 				p_db_imp->db_dir_name);
+			free(p_db_imp);
 			OSM_LOG_EXIT(p_log);
 			return 1;
 		}
-- 
1.6.2.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
