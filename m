From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: Add per module logging FILE_ID define to
 osm_congestion_control.c
Date: Tue, 31 Jul 2012 11:24:51 +0300
Message-ID: <20120731082451.GB2077@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_file_ids.h   | 1 +
 opensm/osm_congestion_control.c | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/opensm/osm_file_ids.h b/include/opensm/osm_file_ids.h
index 713a0f9..7c45082 100644
--- a/include/opensm/osm_file_ids.h
+++ b/include/opensm/osm_file_ids.h
@@ -149,6 +149,7 @@ typedef enum _osm_file_ids_enum {
 	OSM_FILE_VL_ARB_RCV_C,
 	OSM_FILE_ST_C,
 	OSM_FILE_UCAST_DFSSSP_C,
+	OSM_FILE_CONGESTION_CONTROL_C,
 } osm_file_ids_enum;
 /***********/
 
diff --git a/opensm/osm_congestion_control.c b/opensm/osm_congestion_control.c
index 640f3fa..0aa72fd 100644
--- a/opensm/osm_congestion_control.c
+++ b/opensm/osm_congestion_control.c
@@ -47,7 +47,8 @@
 
 #include <stdlib.h>
 #include <string.h>
-
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_CONGESTION_CONTROL_C
 #include <iba/ib_types.h>
 #include <complib/cl_debug.h>
 #include <opensm/osm_subnet.h>
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
