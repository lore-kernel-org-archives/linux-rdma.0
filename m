From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 8/8] uapi/rdma_user_cm.h: include socket.h
Date: Tue, 12 Aug 2014 19:20:11 -0400
Message-ID: <932b08146888f61e4695aa7986e739de28a1f84e.1407885084.git.dledford@redhat.com>
References: <cover.1407885084.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1407885084.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1407885084.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1407885084.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Commit ee7aed4528f (RDMA/ucma: Support querying for AF_IB addresses)
added struct sockaddr_storage to rdma_user_cm.h without also adding an
include for linux/socket.h to make sure it is defined.  As systemtap
needs the header files to build standalone and not rely on the code
files to pre-include other headers, add linux/socket.h to the list of
includes in this file.

This patch resolves Red Hat bugzilla #1072645.

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/uapi/rdma/rdma_user_cm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/rdma/rdma_user_cm.h b/include/uapi/rdma/rdma_user_cm.h
index 99b80abf360..3066718eb12 100644
--- a/include/uapi/rdma/rdma_user_cm.h
+++ b/include/uapi/rdma/rdma_user_cm.h
@@ -34,6 +34,7 @@
 #define RDMA_USER_CM_H
 
 #include <linux/types.h>
+#include <linux/socket.h>
 #include <linux/in6.h>
 #include <rdma/ib_user_verbs.h>
 #include <rdma/ib_user_sa.h>
-- 
1.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
