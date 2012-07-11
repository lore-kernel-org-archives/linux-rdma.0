From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libibverbs] memory: use SCNxPTR format to read uintptr_t values
Date: Wed, 11 Jul 2012 17:10:35 +0200
Message-ID: <1342019435-10041-1-git-send-email-ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

SCNxPTR is the correct format to parse uintptr_t hexadecimal values,
whatever the width of uintptr_t type.

This fix a warning when building on a 32bits system.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 src/memory.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/src/memory.c b/src/memory.c
index ea9e712..7d97e55 100644
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
1.7.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
