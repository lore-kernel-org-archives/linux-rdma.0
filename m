From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 12/17] umad: Flatten libibumad/src,include into libibumad/
Date: Thu,  6 Oct 2016 14:51:38 -0600
Message-ID: <1475787103-13283-13-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1475787103-13283-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475787103-13283-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The top level dir produces the library and test/ produces
the test programs.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt                                  |  2 +-
 libibumad/CMakeLists.txt                        | 16 ++++++++++++++++
 libibumad/{src => }/libibumad.map               |  0
 libibumad/src/CMakeLists.txt                    | 16 ----------------
 libibumad/{src => }/sysfs.c                     |  0
 libibumad/{src => }/umad.c                      |  0
 libibumad/{include/infiniband => }/umad.h       |  0
 libibumad/{include/infiniband => }/umad_cm.h    |  0
 libibumad/{include/infiniband => }/umad_sa.h    |  0
 libibumad/{include/infiniband => }/umad_sm.h    |  0
 libibumad/{src => }/umad_str.c                  |  0
 libibumad/{include/infiniband => }/umad_str.h   |  0
 libibumad/{include/infiniband => }/umad_types.h |  0
 13 files changed, 17 insertions(+), 17 deletions(-)
 create mode 100644 libibumad/CMakeLists.txt
 rename libibumad/{src => }/libibumad.map (100%)
 delete mode 100644 libibumad/src/CMakeLists.txt
 rename libibumad/{src => }/sysfs.c (100%)
 rename libibumad/{src => }/umad.c (100%)
 rename libibumad/{include/infiniband => }/umad.h (100%)
 rename libibumad/{include/infiniband => }/umad_cm.h (100%)
 rename libibumad/{include/infiniband => }/umad_sa.h (100%)
 rename libibumad/{include/infiniband => }/umad_sm.h (100%)
 rename libibumad/{src => }/umad_str.c (100%)
 rename libibumad/{include/infiniband => }/umad_str.h (100%)
 rename libibumad/{include/infiniband => }/umad_types.h (100%)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index f857f9118a11..88eb968d45ba 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -251,7 +251,7 @@ configure_file("${BUILDLIB}/config.h.in" "${BUILD_INCLUDE}/config.h" ESCAPE_QUOT
 # Sub-directories
 add_subdirectory(ccan)
 # Libraries
-add_subdirectory(libibumad/src)
+add_subdirectory(libibumad)
 add_subdirectory(libibumad/man)
 add_subdirectory(libibverbs/src)
 add_subdirectory(libibverbs/man)
diff --git a/libibumad/CMakeLists.txt b/libibumad/CMakeLists.txt
new file mode 100644
index 000000000000..7036aa35d36a
--- /dev/null
+++ b/libibumad/CMakeLists.txt
@@ -0,0 +1,16 @@
+publish_headers(infiniband
+  umad.h
+  umad_cm.h
+  umad_sa.h
+  umad_sm.h
+  umad_str.h
+  umad_types.h
+  )
+
+rdma_library(ibumad libibumad.map
+  # See Documentation/versioning.md
+  3 3.1.${PACKAGE_VERSION}
+  sysfs.c
+  umad.c
+  umad_str.c
+  )
diff --git a/libibumad/src/libibumad.map b/libibumad/libibumad.map
similarity index 100%
rename from libibumad/src/libibumad.map
rename to libibumad/libibumad.map
diff --git a/libibumad/src/CMakeLists.txt b/libibumad/src/CMakeLists.txt
deleted file mode 100644
index fbd15893d973..000000000000
diff --git a/libibumad/src/sysfs.c b/libibumad/sysfs.c
similarity index 100%
rename from libibumad/src/sysfs.c
rename to libibumad/sysfs.c
diff --git a/libibumad/src/umad.c b/libibumad/umad.c
similarity index 100%
rename from libibumad/src/umad.c
rename to libibumad/umad.c
diff --git a/libibumad/include/infiniband/umad.h b/libibumad/umad.h
similarity index 100%
rename from libibumad/include/infiniband/umad.h
rename to libibumad/umad.h
diff --git a/libibumad/include/infiniband/umad_cm.h b/libibumad/umad_cm.h
similarity index 100%
rename from libibumad/include/infiniband/umad_cm.h
rename to libibumad/umad_cm.h
diff --git a/libibumad/include/infiniband/umad_sa.h b/libibumad/umad_sa.h
similarity index 100%
rename from libibumad/include/infiniband/umad_sa.h
rename to libibumad/umad_sa.h
diff --git a/libibumad/include/infiniband/umad_sm.h b/libibumad/umad_sm.h
similarity index 100%
rename from libibumad/include/infiniband/umad_sm.h
rename to libibumad/umad_sm.h
diff --git a/libibumad/src/umad_str.c b/libibumad/umad_str.c
similarity index 100%
rename from libibumad/src/umad_str.c
rename to libibumad/umad_str.c
diff --git a/libibumad/include/infiniband/umad_str.h b/libibumad/umad_str.h
similarity index 100%
rename from libibumad/include/infiniband/umad_str.h
rename to libibumad/umad_str.h
diff --git a/libibumad/include/infiniband/umad_types.h b/libibumad/umad_types.h
similarity index 100%
rename from libibumad/include/infiniband/umad_types.h
rename to libibumad/umad_types.h
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
