From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 23/23] srp_daemon: Use SRP_DEFAULT_START/STOP for substitution
Date: Wed, 21 Sep 2016 16:08:49 -0600
Message-ID: <1474495729-17604-24-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474495729-17604-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474495729-17604-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

For clarity.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 srp_daemon/srp_daemon/CMakeLists.txt | 4 ++--
 srp_daemon/srp_daemon/srpd.in        | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/srp_daemon/srp_daemon/CMakeLists.txt b/srp_daemon/srp_daemon/CMakeLists.txt
index 29f6088d2855..84d74044186a 100644
--- a/srp_daemon/srp_daemon/CMakeLists.txt
+++ b/srp_daemon/srp_daemon/CMakeLists.txt
@@ -24,8 +24,8 @@ install(FILES srp_daemon.conf DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}")
 # FIXME: The ib init.d file should really be included in rdma-core as well.
 set(RDMA_SERVICE "openibd" CACHE STRING "init.d file service name to order srpd after")
 # NOTE: These defaults are for CentOS, packagers should override.
-set(DEFAULT_START "2 3 4 5" CACHE STRING "Default-Start service data for srpd")
-set(DEFAULT_STOP "0 1 6" CACHE STRING "Default-Stop service data for srpd")
+set(SRP_DEFAULT_START "2 3 4 5" CACHE STRING "Default-Start service data for srpd")
+set(SRP_DEFAULT_STOP "0 1 6" CACHE STRING "Default-Stop service data for srpd")
 configure_file(srpd.in "${CMAKE_CURRENT_BINARY_DIR}/srpd")
 install(FILES "${CMAKE_CURRENT_BINARY_DIR}/srpd"
   DESTINATION "${CMAKE_INSTALL_INITDDIR}"
diff --git a/srp_daemon/srp_daemon/srpd.in b/srp_daemon/srp_daemon/srpd.in
index 6a5d7d70feae..10692e7e0f05 100755
--- a/srp_daemon/srp_daemon/srpd.in
+++ b/srp_daemon/srp_daemon/srpd.in
@@ -10,8 +10,8 @@
 # Provides:       srpd
 # Required-Start: $syslog @RDMA_SERVICE@
 # Required-Stop: $syslog @RDMA_SERVICE@
-# Default-Start: @DEFAULT_START@
-# Default-Stop: @DEFAULT_STOP@
+# Default-Start: @SRP_DEFAULT_START@
+# Default-Stop: @SRP_DEFAULT_STOP@
 # Should-Start:
 # Should-Stop:
 # Short-Description: Starts and stops the InfiniBand SRP client service
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
