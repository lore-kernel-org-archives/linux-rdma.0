From: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Subject: [PATCH] Fix 2.6.3[12] user_mad backports
Date: Mon, 1 Feb 2010 16:24:19 +0100
Message-ID: <20100201162419.443afe03@frecb007965>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


  The ib_umad_port's sm_sem semaphore is initialized as a mutex which
although it builds (with a warning) badly breaks at runtime.

  Fix this by using the proper initialization function sema_init().

  Also fix those DOSish end of lines.

Signed-off-by: Sebastien Dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
---
 .../backport/2.6.31/user_mad_mutex_init.patch      |   30 ++++++++++----------
 .../backport/2.6.32/user_mad_mutex_init.patch      |   30 ++++++++++----------
 2 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/kernel_patches/backport/2.6.31/user_mad_mutex_init.patch b/kernel_patches/backport/2.6.31/user_mad_mutex_init.patch
index 09cb6e6..3054f1e 100644
--- a/kernel_patches/backport/2.6.31/user_mad_mutex_init.patch
+++ b/kernel_patches/backport/2.6.31/user_mad_mutex_init.patch
@@ -1,15 +1,15 @@
-From: Sven-Thorsten Dietrich <sdietrich-l3A5Bk7waGM@public.gmane.org>
-Subject: use updated mutex_init.
-
-Signed-off-by: Sven-Thorsten Dietrich <sdietrich-l3A5Bk7waGM@public.gmane.org>
---- a/drivers/infiniband/core/user_mad.c	2009-11-24 07:52:27.000000000 -0800
-+++ b/drivers/infiniband/core//user_mad.c	2012-09-01 13:06:26.000000000 -0700
-@@ -1003,7 +1003,7 @@
- 
- 	port->ib_dev   = device;
- 	port->port_num = port_num;
--	init_MUTEX(&port->sm_sem);
-+	mutex_init(&port->sm_sem);
- 	mutex_init(&port->file_mutex);
- 	INIT_LIST_HEAD(&port->file_list);
- 
+From: Sven-Thorsten Dietrich <sdietrich-l3A5Bk7waGM@public.gmane.org>
+Subject: use updated mutex_init.
+
+Signed-off-by: Sven-Thorsten Dietrich <sdietrich-l3A5Bk7waGM@public.gmane.org>
+--- a/drivers/infiniband/core/user_mad.c	2009-11-24 07:52:27.000000000 -0800
++++ b/drivers/infiniband/core//user_mad.c	2012-09-01 13:06:26.000000000 -0700
+@@ -1003,7 +1003,7 @@
+ 
+ 	port->ib_dev   = device;
+ 	port->port_num = port_num;
+-	init_MUTEX(&port->sm_sem);
++	sema_init(&port->sm_sem, 1);
+ 	mutex_init(&port->file_mutex);
+ 	INIT_LIST_HEAD(&port->file_list);
+ 
diff --git a/kernel_patches/backport/2.6.32/user_mad_mutex_init.patch b/kernel_patches/backport/2.6.32/user_mad_mutex_init.patch
index 09cb6e6..3054f1e 100644
--- a/kernel_patches/backport/2.6.32/user_mad_mutex_init.patch
+++ b/kernel_patches/backport/2.6.32/user_mad_mutex_init.patch
@@ -1,15 +1,15 @@
-From: Sven-Thorsten Dietrich <sdietrich-l3A5Bk7waGM@public.gmane.org>
-Subject: use updated mutex_init.
-
-Signed-off-by: Sven-Thorsten Dietrich <sdietrich-l3A5Bk7waGM@public.gmane.org>
---- a/drivers/infiniband/core/user_mad.c	2009-11-24 07:52:27.000000000 -0800
-+++ b/drivers/infiniband/core//user_mad.c	2012-09-01 13:06:26.000000000 -0700
-@@ -1003,7 +1003,7 @@
- 
- 	port->ib_dev   = device;
- 	port->port_num = port_num;
--	init_MUTEX(&port->sm_sem);
-+	mutex_init(&port->sm_sem);
- 	mutex_init(&port->file_mutex);
- 	INIT_LIST_HEAD(&port->file_list);
- 
+From: Sven-Thorsten Dietrich <sdietrich-l3A5Bk7waGM@public.gmane.org>
+Subject: use updated mutex_init.
+
+Signed-off-by: Sven-Thorsten Dietrich <sdietrich-l3A5Bk7waGM@public.gmane.org>
+--- a/drivers/infiniband/core/user_mad.c	2009-11-24 07:52:27.000000000 -0800
++++ b/drivers/infiniband/core//user_mad.c	2012-09-01 13:06:26.000000000 -0700
+@@ -1003,7 +1003,7 @@
+ 
+ 	port->ib_dev   = device;
+ 	port->port_num = port_num;
+-	init_MUTEX(&port->sm_sem);
++	sema_init(&port->sm_sem, 1);
+ 	mutex_init(&port->file_mutex);
+ 	INIT_LIST_HEAD(&port->file_list);
+ 
-- 
1.6.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
