From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 10/27] drivers/infiniband/core: Use memdup_user
Date: Sat, 22 May 2010 10:21:27 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1005221021030.13021@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-jani
List-Id: linux-rdma@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use memdup_user when user data is immediately copied into the
allocated region.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression from,to,size,flag;
position p;
identifier l1,l2;
@@

-  to = \(kmalloc@p\|kzalloc@p\)(size,flag);
+  to = memdup_user(from,size);
   if (
-      to==NULL
+      IS_ERR(to)
                 || ...) {
   <+... when != goto l1;
-  -ENOMEM
+  PTR_ERR(to)
   ...+>
   }
-  if (copy_from_user(to, from, size) != 0) {
-    <+... when != goto l2;
-    -EFAULT
-    ...+>
-  }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/infiniband/core/ucm.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index 4647484..08f948d 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -706,14 +706,9 @@ static int ib_ucm_alloc_data(const void **dest, u64 src, u32 len)
 	if (!len)
 		return 0;
 
-	data = kmalloc(len, GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
-	if (copy_from_user(data, (void __user *)(unsigned long)src, len)) {
-		kfree(data);
-		return -EFAULT;
-	}
+	data = memdup_user((void __user *)(unsigned long)src, len);
+	if (IS_ERR(data))
+		return PTR_ERR(data);
 
 	*dest = data;
 	return 0;
