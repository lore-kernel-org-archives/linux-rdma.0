From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_db_files.c: Fix issue introduced in commit, aaa7b1e67ec6e5fc2a10accf46d538f9d47c6323
Date: Sat, 04 Jan 2014 11:47:25 -0500
Message-ID: <52C83B1D.3060909@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

osm_db_files.c: Some minor fixes/improvements to osm_db_store

when handling malloc failure, no need to release lock

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_db_files.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_db_files.c b/opensm/osm_db_files.c
index b43b5e6..07d30dc 100644
--- a/opensm/osm_db_files.c
+++ b/opensm/osm_db_files.c
@@ -480,7 +480,7 @@ int osm_db_store(IN osm_db_domain_t * p_domain,
 	if (!p_tmp_file_name) {
 		OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 6113: "
 			"Failed to allocate memory for temporary file name\n");
-		goto Exit;
+		goto Exit2;
 	}
 	strcpy(p_tmp_file_name, p_domain_imp->file_name);
 	strcat(p_tmp_file_name, ".tmp");
@@ -533,6 +533,7 @@ int osm_db_store(IN osm_db_domain_t * p_domain,
 	p_domain_imp->dirty = FALSE;
 Exit:
 	cl_spinlock_release(&p_domain_imp->lock);
 	free(p_tmp_file_name);
+Exit2:
 	OSM_LOG_EXIT(p_log);
 	return status;
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
