From: Doug Ledford <dledford@redhat.com>
Subject: [PATCH] uapi/rdma_user_cm.h: include socket.h
Date: Thu, 17 Jul 2014 09:57:07 -0400
Message-ID: <2d5b6d400d1845a52798d4a7655c8fc3ef68e580.1405605235.git.dledford@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, roland@kernel.org, stable@vger.kernel.org
Cc: Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

Commit ee7aed4528f (RDMA/ucma: Support querying for AF_IB addresses)
added struct sockaddr_storage to rdma_user_cm.h without also adding an
include for linux/socket.h to make sure it is defined.  As systemtap
needs the header files to build standalone and not rely on the code
files to pre-include other headers, add linux/socket.h to the list of
includes in this file.

This patch resolves Red Hat bugzilla #1072645.

The above referenced commit was added during the 3.11 release cycle, so
this fix is suitable for any stable kernels from that point on.

Signed-off-by: Doug Ledford <dledford@redhat.com>
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
