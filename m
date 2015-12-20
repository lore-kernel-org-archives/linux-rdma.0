From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH] libmlx5: Add gitignore file to the project
Date: Sun, 20 Dec 2015 09:42:41 +0200
Message-ID: <1450597361-11849-1-git-send-email-leon@leon.nu>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add gitignore file to the libmlx5 project.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 .gitignore | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)
 create mode 100644 .gitignore

diff --git a/.gitignore b/.gitignore
new file mode 100644
index 000000000000..be8e0f03eb93
--- /dev/null
+++ b/.gitignore
@@ -0,0 +1,20 @@
+*.o
+*.lo
+*.swp
+configure
+Makefile.in
+autom4te.cache
+aclocal.m4
+stamp-h.in
+config.h.in
+config.h.in~
+config.log
+config.h
+.libs
+.deps
+libmlx5.spec
+Makefile
+config.status
+stamp-h1
+libtool
+tags
-- 
1.7.12.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
