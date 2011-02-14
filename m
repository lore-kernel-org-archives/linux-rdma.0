From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] Fix compile warning introduced by patch
 "fixed getline pointer allocation free in osm_console_io"
Date: Mon, 14 Feb 2011 15:32:29 -0800
Message-ID: <20110214153229.1eba1f18.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Mon, 14 Feb 2011 15:25:36 -0800
Subject: [PATCH] Fix compile warning introduced by patch "fixed getline pointer allocation free in osm_console_io"


Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_console_io.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_console_io.c b/opensm/osm_console_io.c
index 1205a5f..0614c7f 100644
--- a/opensm/osm_console_io.c
+++ b/opensm/osm_console_io.c
@@ -56,6 +56,7 @@
 #include <errno.h>
 #include <signal.h>
 #include <opensm/osm_console_io.h>
+#include <stdlib.h>
 
 static int is_local(char *str)
 {
-- 
1.5.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
