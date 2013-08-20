From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_db_files.c: Fix memory leak when deleting entries
 from osm db
Date: Tue, 20 Aug 2013 11:43:32 -0400
Message-ID: <52138EA4.7080505@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The key also should be freed.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_db_files.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_db_files.c b/opensm/osm_db_files.c
index 94dc11c..0eef1d4 100644
--- a/opensm/osm_db_files.c
+++ b/opensm/osm_db_files.c
@@ -608,6 +608,7 @@ int osm_db_delete(IN osm_db_domain_t * p_domain, IN char *p_key)
 				p_key, p_domain_imp->file_name, p_prev_val);
 			res = 1;
 		} else {
+			free(p_key);
 			free(p_prev_val);
 			res = 0;
 		}
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
