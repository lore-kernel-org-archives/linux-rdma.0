From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 09/17] iwpmd: Flatten iwpmd/src into iwpmd/
Date: Thu,  6 Oct 2016 14:51:35 -0600
Message-ID: <1475787103-13283-10-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1475787103-13283-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475787103-13283-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Since the directory only produces one program.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt                    |  1 -
 iwpmd/CMakeLists.txt              | 17 +++++++++++++++++
 iwpmd/{src => }/iwarp_pm.h        |  0
 iwpmd/{src => }/iwarp_pm_common.c |  0
 iwpmd/{src => }/iwarp_pm_helper.c |  0
 iwpmd/{src => }/iwarp_pm_server.c |  0
 iwpmd/{src => }/iwpm_netlink.h    |  0
 iwpmd/src/CMakeLists.txt          | 16 ----------------
 8 files changed, 17 insertions(+), 17 deletions(-)
 rename iwpmd/{src => }/iwarp_pm.h (100%)
 rename iwpmd/{src => }/iwarp_pm_common.c (100%)
 rename iwpmd/{src => }/iwarp_pm_helper.c (100%)
 rename iwpmd/{src => }/iwarp_pm_server.c (100%)
 rename iwpmd/{src => }/iwpm_netlink.h (100%)
 delete mode 100644 iwpmd/src/CMakeLists.txt

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 45a857085832..b3c4589f4d5b 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -277,7 +277,6 @@ add_subdirectory(providers/rxe/man)
 add_subdirectory(ibacm)
 if (NOT NL_KIND EQUAL 0)
   add_subdirectory(iwpmd)
-  add_subdirectory(iwpmd/src)
 endif()
 add_subdirectory(libibcm/examples)
 add_subdirectory(libibumad/tests)
diff --git a/iwpmd/CMakeLists.txt b/iwpmd/CMakeLists.txt
index 89a715128076..ee9e5a3dfeb2 100644
--- a/iwpmd/CMakeLists.txt
+++ b/iwpmd/CMakeLists.txt
@@ -1,4 +1,21 @@
+rdma_executable(iwpmd
+  iwarp_pm_common.c
+  iwarp_pm_helper.c
+  iwarp_pm_server.c
+  )
+target_link_libraries(iwpmd LINK_PRIVATE
+  ${NL_LIBRARIES}
+  ${CMAKE_THREAD_LIBS_INIT}
+  )
+
 rdma_man_pages(
   iwpmd.1.in
   iwpmd.conf.5.in
   )
+
+install(FILES "iwpmd.service" DESTINATION "${CMAKE_INSTALL_SYSTEMD_SERVICEDIR}")
+install(FILES "iwpmd_init"
+  DESTINATION "${CMAKE_INSTALL_INITDDIR}"
+  RENAME "iwpmd"
+  PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ OWNER_EXECUTE GROUP_EXECUTE WORLD_EXECUTE)
+install(FILES "iwpmd.conf" DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}")
diff --git a/iwpmd/src/iwarp_pm.h b/iwpmd/iwarp_pm.h
similarity index 100%
rename from iwpmd/src/iwarp_pm.h
rename to iwpmd/iwarp_pm.h
diff --git a/iwpmd/src/iwarp_pm_common.c b/iwpmd/iwarp_pm_common.c
similarity index 100%
rename from iwpmd/src/iwarp_pm_common.c
rename to iwpmd/iwarp_pm_common.c
diff --git a/iwpmd/src/iwarp_pm_helper.c b/iwpmd/iwarp_pm_helper.c
similarity index 100%
rename from iwpmd/src/iwarp_pm_helper.c
rename to iwpmd/iwarp_pm_helper.c
diff --git a/iwpmd/src/iwarp_pm_server.c b/iwpmd/iwarp_pm_server.c
similarity index 100%
rename from iwpmd/src/iwarp_pm_server.c
rename to iwpmd/iwarp_pm_server.c
diff --git a/iwpmd/src/iwpm_netlink.h b/iwpmd/iwpm_netlink.h
similarity index 100%
rename from iwpmd/src/iwpm_netlink.h
rename to iwpmd/iwpm_netlink.h
diff --git a/iwpmd/src/CMakeLists.txt b/iwpmd/src/CMakeLists.txt
deleted file mode 100644
index 727db7eff744..000000000000
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
