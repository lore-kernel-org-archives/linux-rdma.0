From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 19/23] iwpmd: Install ancillary files for iwpm
Date: Wed, 21 Sep 2016 16:08:45 -0600
Message-ID: <1474495729-17604-20-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474495729-17604-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474495729-17604-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There were installed manually inside the rpm spec file, our
standard is to do them during 'make install'

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 iwpmd/src/CMakeLists.txt | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/iwpmd/src/CMakeLists.txt b/iwpmd/src/CMakeLists.txt
index 5ffc21264ae2..e6255b597733 100644
--- a/iwpmd/src/CMakeLists.txt
+++ b/iwpmd/src/CMakeLists.txt
@@ -7,6 +7,10 @@ target_link_libraries(iwpmd
   ${NL_LIBRARIES}
   ${CMAKE_THREAD_LIBS_INIT}
   )
-# FIXME iwpmd_init init.d file
-# FIXME iwpmd.service systemd file
-# FIXME iwpmd.conf
+
+install(FILES "../iwpmd.service" DESTINATION "${CMAKE_INSTALL_SYSTEMD_SERVICEDIR}")
+install(FILES "../iwpmd_init"
+  DESTINATION "${CMAKE_INSTALL_INITDDIR}"
+  RENAME "iwpmd"
+  PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ OWNER_EXECUTE GROUP_EXECUTE WORLD_EXECUTE)
+install(FILES "../iwpmd.conf" DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}")
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
