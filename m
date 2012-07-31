From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCHv2] opensm: Add per module logging FILE_ID define to
 osm_congestion_control.c
Date: Tue, 31 Jul 2012 12:33:34 +0300
Message-ID: <20120731093334.GC2077@calypso>
References: <20120731082451.GB2077@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120731082451.GB2077@calypso>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Changes since v1:
	Updated module_name_str array

 include/opensm/osm_file_ids.h   | 1 +
 opensm/osm_congestion_control.c | 3 ++-
 opensm/osm_subnet.c             | 3 ++-
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/opensm/osm_file_ids.h b/include/opensm/osm_file_ids.h
index 713a0f9..e23710c 100644
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
index 640f3fa..960b728 100644
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
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 2358140..3dded18 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -182,9 +182,10 @@ static const char *module_name_str[] = {
 	"osm_vl_arb_rcv.c",
 	"st.c",
 	"osm_ucast_dfsssp.c",
+	"osm_congestion_control.c"
 	/* Add new module names here ... */
 	/* FILE_ID define in those modules must be identical to index here */
-	/* last FILE_ID is currently 88 */
+	/* last FILE_ID is currently 89 */
 };
 
 #define MOD_NAME_STR_UNKNOWN_VAL (ARR_SIZE(module_name_str))
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
