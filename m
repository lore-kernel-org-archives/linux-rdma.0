From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 10/17] srp_deamon: Flatten srp_daemon/src,etc into srp_daemon/
Date: Thu,  6 Oct 2016 14:51:36 -0600
Message-ID: <1475787103-13283-11-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1475787103-13283-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475787103-13283-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Since the directory only produces one program.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt                                      | 3 +--
 srp_daemon/{srp_daemon => }/CMakeLists.txt          | 5 +++++
 srp_daemon/{man => }/ibsrpdm.1                      | 0
 srp_daemon/{srp_daemon => }/logrotate-srp_daemon    | 0
 srp_daemon/man/CMakeLists.txt                       | 4 ----
 srp_daemon/{srp_daemon => }/rsyslog-srp_daemon.conf | 0
 srp_daemon/{man => }/srp_daemon.1.in                | 0
 srp_daemon/{srp_daemon => }/srp_daemon.c            | 0
 srp_daemon/{srp_daemon => }/srp_daemon.conf         | 0
 srp_daemon/{srp_daemon => }/srp_daemon.h            | 0
 srp_daemon/{srp_daemon => }/srp_daemon.sh.in        | 0
 srp_daemon/{srp_daemon => }/srp_handle_traps.c      | 0
 srp_daemon/{srp_daemon => }/srp_ib_types.h          | 0
 srp_daemon/{srp_daemon => }/srp_sync.c              | 0
 srp_daemon/{srp_daemon => }/srpd.in                 | 0
 15 files changed, 6 insertions(+), 6 deletions(-)
 rename srp_daemon/{srp_daemon => }/CMakeLists.txt (96%)
 rename srp_daemon/{man => }/ibsrpdm.1 (100%)
 rename srp_daemon/{srp_daemon => }/logrotate-srp_daemon (100%)
 delete mode 100644 srp_daemon/man/CMakeLists.txt
 rename srp_daemon/{srp_daemon => }/rsyslog-srp_daemon.conf (100%)
 rename srp_daemon/{man => }/srp_daemon.1.in (100%)
 rename srp_daemon/{srp_daemon => }/srp_daemon.c (100%)
 rename srp_daemon/{srp_daemon => }/srp_daemon.conf (100%)
 rename srp_daemon/{srp_daemon => }/srp_daemon.h (100%)
 rename srp_daemon/{srp_daemon => }/srp_daemon.sh.in (100%)
 rename srp_daemon/{srp_daemon => }/srp_handle_traps.c (100%)
 rename srp_daemon/{srp_daemon => }/srp_ib_types.h (100%)
 rename srp_daemon/{srp_daemon => }/srp_sync.c (100%)
 rename srp_daemon/{srp_daemon => }/srpd.in (100%)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index b3c4589f4d5b..ae6b5ed5eb0b 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -282,8 +282,7 @@ add_subdirectory(libibcm/examples)
 add_subdirectory(libibumad/tests)
 add_subdirectory(libibverbs/examples)
 add_subdirectory(librdmacm/examples)
-add_subdirectory(srp_daemon/srp_daemon)
-add_subdirectory(srp_daemon/man)
+add_subdirectory(srp_daemon)
 
 rdma_finalize_libs()
 
diff --git a/srp_daemon/srp_daemon/CMakeLists.txt b/srp_daemon/CMakeLists.txt
similarity index 96%
rename from srp_daemon/srp_daemon/CMakeLists.txt
rename to srp_daemon/CMakeLists.txt
index 9ca58acdc33a..48497bcd6009 100644
--- a/srp_daemon/srp_daemon/CMakeLists.txt
+++ b/srp_daemon/CMakeLists.txt
@@ -1,5 +1,10 @@
 set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${NO_STRICT_ALIASING_FLAGS}")
 
+rdma_man_pages(
+  ibsrpdm.1
+  srp_daemon.1.in
+  )
+
 rdma_sbin_executable(srp_daemon
   srp_daemon.c
   srp_handle_traps.c
diff --git a/srp_daemon/man/ibsrpdm.1 b/srp_daemon/ibsrpdm.1
similarity index 100%
rename from srp_daemon/man/ibsrpdm.1
rename to srp_daemon/ibsrpdm.1
diff --git a/srp_daemon/srp_daemon/logrotate-srp_daemon b/srp_daemon/logrotate-srp_daemon
similarity index 100%
rename from srp_daemon/srp_daemon/logrotate-srp_daemon
rename to srp_daemon/logrotate-srp_daemon
diff --git a/srp_daemon/man/CMakeLists.txt b/srp_daemon/man/CMakeLists.txt
deleted file mode 100644
index cd644a6bd836..000000000000
diff --git a/srp_daemon/srp_daemon/rsyslog-srp_daemon.conf b/srp_daemon/rsyslog-srp_daemon.conf
similarity index 100%
rename from srp_daemon/srp_daemon/rsyslog-srp_daemon.conf
rename to srp_daemon/rsyslog-srp_daemon.conf
diff --git a/srp_daemon/man/srp_daemon.1.in b/srp_daemon/srp_daemon.1.in
similarity index 100%
rename from srp_daemon/man/srp_daemon.1.in
rename to srp_daemon/srp_daemon.1.in
diff --git a/srp_daemon/srp_daemon/srp_daemon.c b/srp_daemon/srp_daemon.c
similarity index 100%
rename from srp_daemon/srp_daemon/srp_daemon.c
rename to srp_daemon/srp_daemon.c
diff --git a/srp_daemon/srp_daemon/srp_daemon.conf b/srp_daemon/srp_daemon.conf
similarity index 100%
rename from srp_daemon/srp_daemon/srp_daemon.conf
rename to srp_daemon/srp_daemon.conf
diff --git a/srp_daemon/srp_daemon/srp_daemon.h b/srp_daemon/srp_daemon.h
similarity index 100%
rename from srp_daemon/srp_daemon/srp_daemon.h
rename to srp_daemon/srp_daemon.h
diff --git a/srp_daemon/srp_daemon/srp_daemon.sh.in b/srp_daemon/srp_daemon.sh.in
similarity index 100%
rename from srp_daemon/srp_daemon/srp_daemon.sh.in
rename to srp_daemon/srp_daemon.sh.in
diff --git a/srp_daemon/srp_daemon/srp_handle_traps.c b/srp_daemon/srp_handle_traps.c
similarity index 100%
rename from srp_daemon/srp_daemon/srp_handle_traps.c
rename to srp_daemon/srp_handle_traps.c
diff --git a/srp_daemon/srp_daemon/srp_ib_types.h b/srp_daemon/srp_ib_types.h
similarity index 100%
rename from srp_daemon/srp_daemon/srp_ib_types.h
rename to srp_daemon/srp_ib_types.h
diff --git a/srp_daemon/srp_daemon/srp_sync.c b/srp_daemon/srp_sync.c
similarity index 100%
rename from srp_daemon/srp_daemon/srp_sync.c
rename to srp_daemon/srp_sync.c
diff --git a/srp_daemon/srp_daemon/srpd.in b/srp_daemon/srpd.in
similarity index 100%
rename from srp_daemon/srp_daemon/srpd.in
rename to srp_daemon/srpd.in
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
