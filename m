From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 06/17] umad: Use symlinks instead of a NROFF .so directive
Date: Thu,  6 Oct 2016 14:51:32 -0600
Message-ID: <1475787103-13283-7-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1475787103-13283-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475787103-13283-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is consistent with the rest of tree.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibumad/man/CMakeLists.txt        | 8 ++++----
 libibumad/man/umad_attribute_str.3  | 3 ---
 libibumad/man/umad_mad_status_str.3 | 3 ---
 libibumad/man/umad_method_str.3     | 3 ---
 4 files changed, 4 insertions(+), 13 deletions(-)
 delete mode 100644 libibumad/man/umad_attribute_str.3
 delete mode 100644 libibumad/man/umad_mad_status_str.3
 delete mode 100644 libibumad/man/umad_method_str.3

diff --git a/libibumad/man/CMakeLists.txt b/libibumad/man/CMakeLists.txt
index b7a191261ec0..4831d3b1625c 100644
--- a/libibumad/man/CMakeLists.txt
+++ b/libibumad/man/CMakeLists.txt
@@ -1,7 +1,6 @@
 rdma_man_pages(
   umad_addr_dump.3
   umad_alloc.3
-  umad_attribute_str.3
   umad_class_str.3
   umad_close_port.3
   umad_debug.3
@@ -17,8 +16,6 @@ rdma_man_pages(
   umad_get_pkey.3
   umad_get_port.3
   umad_init.3
-  umad_mad_status_str.3
-  umad_method_str.3
   umad_open_port.3
   umad_poll.3
   umad_recv.3
@@ -36,7 +33,10 @@ rdma_man_pages(
   umad_unregister.3
   )
 rdma_alias_man_pages(
+  umad_class_str.3 umad_attribute_str.3
+  umad_class_str.3 umad_mad_status_str.3
+  umad_class_str.3 umad_method_str.3
   umad_get_ca.3 umad_release_ca.3
   umad_get_port.3 umad_release_port.3
   umad_init.3 umad_done.3
-  )
\ No newline at end of file
+  )
diff --git a/libibumad/man/umad_attribute_str.3 b/libibumad/man/umad_attribute_str.3
deleted file mode 100644
index f5e6b02ca933..000000000000
diff --git a/libibumad/man/umad_mad_status_str.3 b/libibumad/man/umad_mad_status_str.3
deleted file mode 100644
index f5e6b02ca933..000000000000
diff --git a/libibumad/man/umad_method_str.3 b/libibumad/man/umad_method_str.3
deleted file mode 100644
index f5e6b02ca933..000000000000
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
