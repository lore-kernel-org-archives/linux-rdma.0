From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 13/17] verbs: Flatten libibverbs/src,include into libibverbs/
Date: Thu,  6 Oct 2016 14:51:39 -0600
Message-ID: <1475787103-13283-14-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1475787103-13283-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475787103-13283-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The top level dir produces the library and examples/ produces
the example programs.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt                                    |  2 +-
 libibverbs/{src => }/CMakeLists.txt               | 16 ++++++++--------
 libibverbs/{include/infiniband => }/arch.h        |  0
 libibverbs/{src => }/cmd.c                        |  0
 libibverbs/{src => }/compat-1_0.c                 |  0
 libibverbs/{src => }/device.c                     |  0
 libibverbs/{include/infiniband => }/driver.h      |  0
 libibverbs/{src => }/enum_strs.c                  |  0
 libibverbs/{src => }/ibverbs.h                    |  0
 libibverbs/{src => }/init.c                       |  0
 libibverbs/{include/infiniband => }/kern-abi.h    |  0
 libibverbs/{src => }/libibverbs.map               |  0
 libibverbs/{src => }/marshall.c                   |  0
 libibverbs/{include/infiniband => }/marshall.h    |  0
 libibverbs/{src => }/memory.c                     |  0
 libibverbs/{src => }/neigh.c                      |  0
 libibverbs/{src => }/neigh.h                      |  0
 libibverbs/{src => }/nl1_compat.h                 |  0
 libibverbs/{include/infiniband => }/opcode.h      |  0
 libibverbs/{include/infiniband => }/sa-kern-abi.h |  0
 libibverbs/{include/infiniband => }/sa.h          |  0
 libibverbs/{src => }/sysfs.c                      |  0
 libibverbs/{src => }/verbs.c                      |  0
 libibverbs/{include/infiniband => }/verbs.h       |  0
 24 files changed, 9 insertions(+), 9 deletions(-)
 rename libibverbs/{src => }/CMakeLists.txt (62%)
 rename libibverbs/{include/infiniband => }/arch.h (100%)
 rename libibverbs/{src => }/cmd.c (100%)
 rename libibverbs/{src => }/compat-1_0.c (100%)
 rename libibverbs/{src => }/device.c (100%)
 rename libibverbs/{include/infiniband => }/driver.h (100%)
 rename libibverbs/{src => }/enum_strs.c (100%)
 rename libibverbs/{src => }/ibverbs.h (100%)
 rename libibverbs/{src => }/init.c (100%)
 rename libibverbs/{include/infiniband => }/kern-abi.h (100%)
 rename libibverbs/{src => }/libibverbs.map (100%)
 rename libibverbs/{src => }/marshall.c (100%)
 rename libibverbs/{include/infiniband => }/marshall.h (100%)
 rename libibverbs/{src => }/memory.c (100%)
 rename libibverbs/{src => }/neigh.c (100%)
 rename libibverbs/{src => }/neigh.h (100%)
 rename libibverbs/{src => }/nl1_compat.h (100%)
 rename libibverbs/{include/infiniband => }/opcode.h (100%)
 rename libibverbs/{include/infiniband => }/sa-kern-abi.h (100%)
 rename libibverbs/{include/infiniband => }/sa.h (100%)
 rename libibverbs/{src => }/sysfs.c (100%)
 rename libibverbs/{src => }/verbs.c (100%)
 rename libibverbs/{include/infiniband => }/verbs.h (100%)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 88eb968d45ba..a0ec5ecd9da0 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -253,7 +253,7 @@ add_subdirectory(ccan)
 # Libraries
 add_subdirectory(libibumad)
 add_subdirectory(libibumad/man)
-add_subdirectory(libibverbs/src)
+add_subdirectory(libibverbs)
 add_subdirectory(libibverbs/man)
 add_subdirectory(librdmacm/src)
 add_subdirectory(librdmacm/man)
diff --git a/libibverbs/src/CMakeLists.txt b/libibverbs/CMakeLists.txt
similarity index 62%
rename from libibverbs/src/CMakeLists.txt
rename to libibverbs/CMakeLists.txt
index fb69037b869b..3e37afbc6551 100644
--- a/libibverbs/src/CMakeLists.txt
+++ b/libibverbs/CMakeLists.txt
@@ -1,12 +1,12 @@
 publish_headers(infiniband
-  ../include/infiniband/arch.h
-  ../include/infiniband/driver.h
-  ../include/infiniband/kern-abi.h
-  ../include/infiniband/marshall.h
-  ../include/infiniband/opcode.h
-  ../include/infiniband/sa-kern-abi.h
-  ../include/infiniband/sa.h
-  ../include/infiniband/verbs.h
+  arch.h
+  driver.h
+  kern-abi.h
+  marshall.h
+  opcode.h
+  sa-kern-abi.h
+  sa.h
+  verbs.h
   )
 
 if (NOT NL_KIND EQUAL 0)
diff --git a/libibverbs/include/infiniband/arch.h b/libibverbs/arch.h
similarity index 100%
rename from libibverbs/include/infiniband/arch.h
rename to libibverbs/arch.h
diff --git a/libibverbs/src/cmd.c b/libibverbs/cmd.c
similarity index 100%
rename from libibverbs/src/cmd.c
rename to libibverbs/cmd.c
diff --git a/libibverbs/src/compat-1_0.c b/libibverbs/compat-1_0.c
similarity index 100%
rename from libibverbs/src/compat-1_0.c
rename to libibverbs/compat-1_0.c
diff --git a/libibverbs/src/device.c b/libibverbs/device.c
similarity index 100%
rename from libibverbs/src/device.c
rename to libibverbs/device.c
diff --git a/libibverbs/include/infiniband/driver.h b/libibverbs/driver.h
similarity index 100%
rename from libibverbs/include/infiniband/driver.h
rename to libibverbs/driver.h
diff --git a/libibverbs/src/enum_strs.c b/libibverbs/enum_strs.c
similarity index 100%
rename from libibverbs/src/enum_strs.c
rename to libibverbs/enum_strs.c
diff --git a/libibverbs/src/ibverbs.h b/libibverbs/ibverbs.h
similarity index 100%
rename from libibverbs/src/ibverbs.h
rename to libibverbs/ibverbs.h
diff --git a/libibverbs/src/init.c b/libibverbs/init.c
similarity index 100%
rename from libibverbs/src/init.c
rename to libibverbs/init.c
diff --git a/libibverbs/include/infiniband/kern-abi.h b/libibverbs/kern-abi.h
similarity index 100%
rename from libibverbs/include/infiniband/kern-abi.h
rename to libibverbs/kern-abi.h
diff --git a/libibverbs/src/libibverbs.map b/libibverbs/libibverbs.map
similarity index 100%
rename from libibverbs/src/libibverbs.map
rename to libibverbs/libibverbs.map
diff --git a/libibverbs/src/marshall.c b/libibverbs/marshall.c
similarity index 100%
rename from libibverbs/src/marshall.c
rename to libibverbs/marshall.c
diff --git a/libibverbs/include/infiniband/marshall.h b/libibverbs/marshall.h
similarity index 100%
rename from libibverbs/include/infiniband/marshall.h
rename to libibverbs/marshall.h
diff --git a/libibverbs/src/memory.c b/libibverbs/memory.c
similarity index 100%
rename from libibverbs/src/memory.c
rename to libibverbs/memory.c
diff --git a/libibverbs/src/neigh.c b/libibverbs/neigh.c
similarity index 100%
rename from libibverbs/src/neigh.c
rename to libibverbs/neigh.c
diff --git a/libibverbs/src/neigh.h b/libibverbs/neigh.h
similarity index 100%
rename from libibverbs/src/neigh.h
rename to libibverbs/neigh.h
diff --git a/libibverbs/src/nl1_compat.h b/libibverbs/nl1_compat.h
similarity index 100%
rename from libibverbs/src/nl1_compat.h
rename to libibverbs/nl1_compat.h
diff --git a/libibverbs/include/infiniband/opcode.h b/libibverbs/opcode.h
similarity index 100%
rename from libibverbs/include/infiniband/opcode.h
rename to libibverbs/opcode.h
diff --git a/libibverbs/include/infiniband/sa-kern-abi.h b/libibverbs/sa-kern-abi.h
similarity index 100%
rename from libibverbs/include/infiniband/sa-kern-abi.h
rename to libibverbs/sa-kern-abi.h
diff --git a/libibverbs/include/infiniband/sa.h b/libibverbs/sa.h
similarity index 100%
rename from libibverbs/include/infiniband/sa.h
rename to libibverbs/sa.h
diff --git a/libibverbs/src/sysfs.c b/libibverbs/sysfs.c
similarity index 100%
rename from libibverbs/src/sysfs.c
rename to libibverbs/sysfs.c
diff --git a/libibverbs/src/verbs.c b/libibverbs/verbs.c
similarity index 100%
rename from libibverbs/src/verbs.c
rename to libibverbs/verbs.c
diff --git a/libibverbs/include/infiniband/verbs.h b/libibverbs/verbs.h
similarity index 100%
rename from libibverbs/include/infiniband/verbs.h
rename to libibverbs/verbs.h
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
