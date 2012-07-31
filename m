From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH][TRIVIAL] opensm/osm_congestion_control.c: Fix
	initialization hex string
Date: Tue, 31 Jul 2012 10:18:19 -0700
Message-ID: <1343755099.18615.421.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Use something more professional.

Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_congestion_control.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_congestion_control.c b/opensm/osm_congestion_control.c
index 640f3fa..f3ba431 100644
--- a/opensm/osm_congestion_control.c
+++ b/opensm/osm_congestion_control.c
@@ -56,7 +56,7 @@
 #include <opensm/osm_subnet.h>
 #include <opensm/osm_congestion_control.h>
 
-#define CONGESTION_CONTROL_INITIAL_TID_VALUE 0xbabe
+#define CONGESTION_CONTROL_INITIAL_TID_VALUE 0x7A93
 
 static void cc_mad_post(osm_congestion_control_t *p_cc,
 			osm_madw_t *p_madw,
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
