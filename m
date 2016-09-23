From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 05/13] Have cmake run man pages through text substitution
Date: Fri, 23 Sep 2016 13:17:00 -0600
Message-ID: <1474658228-5390-6-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474658228-5390-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474658228-5390-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

rsocket.7 had an errant text substitution that never worked, it is
a good idea to have the man pages use the correct paths, so let
us have cmake run them through.

Any man page ending in '.in' will be substituted automatically.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 buildlib/rdma_functions.cmake             | 13 +++++++++++--
 librdmacm/man/CMakeLists.txt              |  2 +-
 librdmacm/man/{rsocket.7 => rsocket.7.in} |  4 ++--
 3 files changed, 14 insertions(+), 5 deletions(-)
 rename librdmacm/man/{rsocket.7 => rsocket.7.in} (97%)

diff --git a/buildlib/rdma_functions.cmake b/buildlib/rdma_functions.cmake
index a4ecd7d4f2fe..260dd18d78df 100644
--- a/buildlib/rdma_functions.cmake
+++ b/buildlib/rdma_functions.cmake
@@ -135,8 +135,17 @@ endfunction()
 # filename
 function(rdma_man_pages)
   foreach(I ${ARGN})
-    string(REGEX REPLACE "^.+[.](.+)$" "\\1" MAN_SECT ${I})
-    install(FILES ${I} DESTINATION "${CMAKE_INSTALL_MANDIR}/man${MAN_SECT}/")
+    if ("${I}" MATCHES "\\.in$")
+      string(REGEX REPLACE "^.+[.](.+)\\.in$" "\\1" MAN_SECT "${I}")
+      string(REGEX REPLACE "^(.+)\\.in$" "\\1" BASE_NAME "${I}")
+      get_filename_component(BASE_NAME "${BASE_NAME}" NAME)
+      rdma_subst_install(FILES "${I}"
+	DESTINATION "${CMAKE_INSTALL_MANDIR}/man${MAN_SECT}/"
+	RENAME "${BASE_NAME}")
+    else()
+      string(REGEX REPLACE "^.+[.](.+)$" "\\1" MAN_SECT "${I}")
+      install(FILES "${I}" DESTINATION "${CMAKE_INSTALL_MANDIR}/man${MAN_SECT}/")
+    endif()
   endforeach()
 endfunction()
 
diff --git a/librdmacm/man/CMakeLists.txt b/librdmacm/man/CMakeLists.txt
index 791c98265ad0..d6cc106751a4 100644
--- a/librdmacm/man/CMakeLists.txt
+++ b/librdmacm/man/CMakeLists.txt
@@ -58,7 +58,7 @@ rdma_man_pages(
   riostream.1
   rping.1
   # FIXME: rsocket has a text substitution but nothing ever filled it in.
-  rsocket.7
+  rsocket.7.in
   rstream.1
   ucmatose.1
   udaddy.1
diff --git a/librdmacm/man/rsocket.7 b/librdmacm/man/rsocket.7.in
similarity index 97%
rename from librdmacm/man/rsocket.7
rename to librdmacm/man/rsocket.7.in
index dfb9804d849a..6adf156f4062 100644
--- a/librdmacm/man/rsocket.7
+++ b/librdmacm/man/rsocket.7.in
@@ -129,7 +129,7 @@ fork off a process to handle the new connection.
 .P
 rsockets uses configuration files that give an administrator control
 over the default settings used by rsockets.  Use files under
-%sysconfig%/rdma/rsocket as shown:
+@CMAKE_INSTALL_FULL_SYSCONFDIR@/rdma/rsocket as shown:
 .P
 .P
 mem_default - default size of receive buffer(s)
@@ -149,7 +149,7 @@ polling_time - default number of microseconds to poll for data before waiting
 All configuration files should contain a single integer value.  Values may
 be set by issuing a command similar to the following example.
 .P
-echo 1000000 > /etc/rdma/rsocket/mem_default
+echo 1000000 > @CMAKE_INSTALL_FULL_SYSCONFDIR@/rdma/rsocket/mem_default
 .P
 If configuration files are not available, rsockets uses internal defaults.
 Applications can override default values programmatically through the
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
