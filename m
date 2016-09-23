From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 10/13] ipathverbs: Move truescale-serdes.cmds to /usr/libexec/
Date: Fri, 23 Sep 2016 13:17:05 -0600
Message-ID: <1474658228-5390-11-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474658228-5390-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474658228-5390-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is the FHS defined place for non-user runnable helper
programs.

Debian forbids the use of /usr/libexec/ so we provide
substitution support to let cmake customize this.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libipathverbs/CMakeLists.txt    | 6 ++++--
 libipathverbs/dracut_install    | 2 +-
 libipathverbs/truescale.conf    | 1 -
 libipathverbs/truescale.conf.in | 1 +
 4 files changed, 6 insertions(+), 4 deletions(-)
 delete mode 100644 libipathverbs/truescale.conf
 create mode 100644 libipathverbs/truescale.conf.in

diff --git a/libipathverbs/CMakeLists.txt b/libipathverbs/CMakeLists.txt
index 359438ef0e49..bde405d0d776 100644
--- a/libipathverbs/CMakeLists.txt
+++ b/libipathverbs/CMakeLists.txt
@@ -1,4 +1,6 @@
-install(FILES truescale.conf DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}/modprobe.d/")
+rdma_subst_install(FILES "truescale.conf.in"
+  DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}/modprobe.d/"
+  RENAME "truescale.conf")
 install(FILES truescale-serdes.cmds
-  DESTINATION "${CMAKE_INSTALL_SBINDIR}"
+  DESTINATION "${CMAKE_INSTALL_LIBEXECDIR}"
   PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ OWNER_EXECUTE GROUP_EXECUTE WORLD_EXECUTE)
diff --git a/libipathverbs/dracut_install b/libipathverbs/dracut_install
index 131adfa036b8..a7ef490ea40f 100644
--- a/libipathverbs/dracut_install
+++ b/libipathverbs/dracut_install
@@ -1,7 +1,7 @@
 #!/bin/bash
 
 inst /etc/modprobe.d/truescale.conf
-inst /usr/sbin/truescale-serdes.cmds
+inst /usr/libexec/truescale-serdes.cmds
 
 # All files needed by truescale-serdes.cmds need to be present here
 inst /sbin/lspci
diff --git a/libipathverbs/truescale.conf b/libipathverbs/truescale.conf
deleted file mode 100644
index 8ed227c91f86..000000000000
diff --git a/libipathverbs/truescale.conf.in b/libipathverbs/truescale.conf.in
new file mode 100644
index 000000000000..e2827d956015
--- /dev/null
+++ b/libipathverbs/truescale.conf.in
@@ -0,0 +1 @@
+install ib_qib modprobe -i ib_qib $CMDLINE_OPTS && @CMAKE_INSTALL_FULL_LIBEXECDIR@/truescale-serdes.cmds start
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
