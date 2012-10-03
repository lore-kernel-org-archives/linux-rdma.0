From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][MINOR] opensm/osm_helper.c: Add some missing new lines to
 log message output
Date: Wed, 03 Oct 2012 19:57:54 -0400
Message-ID: <506CD102.4010403@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Accidentally removed when _v2 routines added with _to_buf routines

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_helper.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/opensm/osm_helper.c b/opensm/osm_helper.c
index 6803777..9ddf19d 100644
--- a/opensm/osm_helper.c
+++ b/opensm/osm_helper.c
@@ -2814,7 +2814,7 @@ void osm_dump_dr_path(IN osm_log_t * p_log, IN const osm_dr_path_t * p_path,
 
 		osm_dump_dr_path_to_buf(p_path, buf);
 
-		osm_log(p_log, log_level, buf);
+		osm_log(p_log, log_level, "%s\n", buf);
 	}
 }
 
@@ -2826,7 +2826,7 @@ void osm_dump_dr_path_v2(IN osm_log_t * p_log, IN const osm_dr_path_t * p_path,
 
 		osm_dump_dr_path_to_buf(p_path, buf);
 
-		osm_log_v2(p_log, log_level, file_id, buf);
+		osm_log_v2(p_log, log_level, file_id, "%s\n", buf);
 	}
 }
 
@@ -2858,7 +2858,7 @@ void osm_dump_smp_dr_path(IN osm_log_t * p_log, IN const ib_smp_t * p_smp,
 
 		osm_dump_smp_dr_path_to_buf(p_smp, buf);
 
-		osm_log(p_log, log_level, buf);
+		osm_log(p_log, log_level, "%s\n", buf);
 	}
 }
 
@@ -2870,7 +2870,7 @@ void osm_dump_smp_dr_path_v2(IN osm_log_t * p_log, IN const ib_smp_t * p_smp,
 
 		osm_dump_smp_dr_path_to_buf(p_smp, buf);
 
-		osm_log_v2(p_log, log_level, file_id, buf);
+		osm_log_v2(p_log, log_level, file_id, "%s\n", buf);
 	}
 }
 
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
