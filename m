From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH V1] libmlx5: Add gitignore file to the project
Date: Sun, 20 Dec 2015 11:03:50 +0200
Message-ID: <1450602230-14059-1-git-send-email-leon@leon.nu>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add gitignore file to the libmlx5 project.

Changes from v0:
 * Add temporary files created by etags/ctags/gtags/cscope.
 * Add Reviewed-by signature

Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 .gitignore | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)
 create mode 100644 .gitignore

diff --git a/.gitignore b/.gitignore
new file mode 100644
index 000000000000..7878db2d068e
--- /dev/null
+++ b/.gitignore
@@ -0,0 +1,33 @@
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
+TAGS
+.TAGS
+!TAGS/
+tags
+.tags
+!tags/
+gtags.files
+GTAGS
+GRTAGS
+GPATH
+cscope.files
+cscope.out
+cscope.in.out
+cscope.po.out
-- 
1.7.12.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
