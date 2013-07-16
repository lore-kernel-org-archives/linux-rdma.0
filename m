From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH librdmacm 6/8] Add .gitignore rules
Date: Tue, 16 Jul 2013 23:59:50 +0200
Message-ID: <a8b2d85df2639fdfc2b4fcb892d08755fc2ebab8.1374011243.git.ydroneaud@opteya.com>
References: <cover.1374011243.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1374011243.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add the list of files/patterns to be exclueded from git status output.
Additionally it will prevent such files/patterns to be added and committed.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 .gitignore          | 64 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 examples/.gitignore | 22 ++++++++++++++++++
 src/.gitignore      |  9 ++++++++
 3 files changed, 95 insertions(+)
 create mode 100644 .gitignore
 create mode 100644 examples/.gitignore
 create mode 100644 src/.gitignore

diff --git a/.gitignore b/.gitignore
new file mode 100644
index 0000000..cea1f71
--- /dev/null
+++ b/.gitignore
@@ -0,0 +1,64 @@
+# - see gitignore(5)
+#
+# http://www.kernel.org/pub/software/scm/git/docs/gitignore.html
+# http://git-scm.com/docs/gitignore.html
+#
+# - ignore files in this current directory with a leading /
+# so that files with the same name is a subdirectory
+# would not be ignored by mistake.
+#
+# per directory .gitignore would be used to ignore specific
+# files/patterns
+#
+# - more examples can be found at
+#
+# https://github.com/github/gitignore
+# http://git-scm.com/book/en/Git-Basics-Recording-Changes-to-the-Repository#Ignoring-Files
+#
+
+# global ignore rules:
+#
+# backup files
+#
+*~
+
+# local (eg. current directory) rules:
+#
+# /<pattern>
+
+#
+# files created by autoreconf (autoconf, automake, libtool)
+#
+
+/INSTALL
+/config.guess
+/config.sub
+/missing
+/depcomp
+/install-sh
+/configure
+/aclocal.m4
+/autom4te.cache/
+/config.h.in
+/Makefile.in
+/compile
+/config
+
+#
+# files created by autoscan
+#
+
+/autoscan.log
+/configure.scan
+
+#
+# files created by ./configure
+#
+
+/config.h
+/config.status
+/config.log
+/Makefile
+/stamp-h1
+/libtool
+/librdmacm.spec
diff --git a/examples/.gitignore b/examples/.gitignore
new file mode 100644
index 0000000..ed17494
--- /dev/null
+++ b/examples/.gitignore
@@ -0,0 +1,22 @@
+# files produced by ./configure
+/.deps
+
+# files produced by make (libtool)
+/*.o
+/*.lo
+/*.la
+/.libs
+/.dirstamp
+
+/mckey
+/rcopy
+/rdma_client
+/rdma_server
+/rdma_xclient
+/rdma_xserver
+/riostream
+/rping
+/rstream
+/ucmatose
+/udaddy
+/udpong
diff --git a/src/.gitignore b/src/.gitignore
new file mode 100644
index 0000000..139417a
--- /dev/null
+++ b/src/.gitignore
@@ -0,0 +1,9 @@
+# files produced by ./configure
+/.deps
+
+# files produced by make (libtool)
+/*.o
+/*.lo
+/*.la
+/.libs
+/.dirstamp
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
