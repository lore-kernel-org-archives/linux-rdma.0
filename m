From: Alice Ferrazzi <alice.ferrazzi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] Infiniband: core: change <asm/uaccess.h> to <linux/uaccess.h>
Date: Mon, 25 Mar 2013 04:24:44 +0900
Message-ID: <1364153084-8911-1-git-send-email-alice.ferrazzi@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alice Ferrazzi <alice.ferrazzi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch replaces <asm/uaccess.h> with <linux/uaccess.h>
to comply with the checkpatch.pl hint.

Signed-off-by: Alice Ferrazzi <alice.ferrazzi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/ucm.c         |    2 +-
 drivers/infiniband/core/user_mad.c    |    2 +-
 drivers/infiniband/core/uverbs_cmd.c  |    2 +-
 drivers/infiniband/core/uverbs_main.c |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index f2f6393..224a7c9 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -46,7 +46,7 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include <rdma/ib_cm.h>
 #include <rdma/ib_user_cm.h>
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index f0d588f..ad414f1 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -48,7 +48,7 @@
 #include <linux/semaphore.h>
 #include <linux/slab.h>
 
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include <rdma/ib_mad.h>
 #include <rdma/ib_user_mad.h>
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index a7d00f6..62ff7f3 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -37,7 +37,7 @@
 #include <linux/fs.h>
 #include <linux/slab.h>
 
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include "uverbs.h"
 
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 2c6f0f2..dfee66f 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -46,7 +46,7 @@
 #include <linux/anon_inodes.h>
 #include <linux/slab.h>
 
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include "uverbs.h"
 
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
