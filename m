From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 5/7] 32-bit compiler warning fix
Date: Sun, 7 Aug 2011 20:03:47 +0200
Message-ID: <201108072003.47863.bvanassche@acm.org>
References: <201108072000.16383.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201108072000.16383.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid that the code in src/memory.c triggers a compiler warning when compiled
on a 32-bit system.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 src/memory.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/src/memory.c b/src/memory.c
index faa43f3..9f13774 100644
--- a/src/memory.c
+++ b/src/memory.c
@@ -44,6 +44,7 @@
 #include <string.h>
 #include <dirent.h>
 #include <limits.h>
+#include <inttypes.h>
 
 #include "ibverbs.h"
 
@@ -116,7 +117,7 @@ static unsigned long get_page_size(void *base)
 		int n;
 		uintptr_t range_start, range_end;
 
-		n = sscanf(buf, "%lx-%lx", &range_start, &range_end);
+		n = sscanf(buf, "%" SCNxPTR "-%" SCNxPTR, &range_start, &range_end);
 
 		if (n < 2)
 			continue;
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
