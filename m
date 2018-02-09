From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core 1/7] verbs: Do not export kern-abi.h as a public header
Date: Thu,  8 Feb 2018 20:08:58 -0700
Message-ID: <20180209030904.22370-2-jgg@ziepe.ca>
References: <20180209030904.22370-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180209030904.22370-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

After all the rework to use the kernel headers directly kern-abi.h
is no longer includable by the user (as it relies on a very new kernel
header) and does not have the same content as before.

Stop exporting it as a public header. There is no reason for any user
to have been using this header, if someone was using it then they need
to migrate to the kernel header now.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 debian/libibverbs-dev.install | 1 -
 libibverbs/CMakeLists.txt     | 2 +-
 librdmacm/rdma_cma_abi.h      | 2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/debian/libibverbs-dev.install b/debian/libibverbs-dev.install
index 28995381073186..1bf56dad423a46 100644
--- a/debian/libibverbs-dev.install
+++ b/debian/libibverbs-dev.install
@@ -1,5 +1,4 @@
 usr/include/infiniband/arch.h
-usr/include/infiniband/kern-abi.h
 usr/include/infiniband/mlx4dv.h
 usr/include/infiniband/mlx5dv.h
 usr/include/infiniband/opcode.h
diff --git a/libibverbs/CMakeLists.txt b/libibverbs/CMakeLists.txt
index 6b41b875210cfb..464e074e7df2ba 100644
--- a/libibverbs/CMakeLists.txt
+++ b/libibverbs/CMakeLists.txt
@@ -1,6 +1,5 @@
 publish_headers(infiniband
   arch.h
-  kern-abi.h
   opcode.h
   sa-kern-abi.h
   sa.h
@@ -10,6 +9,7 @@ publish_headers(infiniband
 
 publish_internal_headers(infiniband
   driver.h
+  kern-abi.h
   marshall.h
   )
 
diff --git a/librdmacm/rdma_cma_abi.h b/librdmacm/rdma_cma_abi.h
index 0ebdad96ec484a..ab4adb00d88280 100644
--- a/librdmacm/rdma_cma_abi.h
+++ b/librdmacm/rdma_cma_abi.h
@@ -33,8 +33,8 @@
 #ifndef RDMA_CMA_ABI_H
 #define RDMA_CMA_ABI_H
 
-#include <infiniband/kern-abi.h>
 #include <rdma/ib_user_sa.h>
+#include <rdma/ib_user_verbs.h>
 #include <infiniband/sa.h>
 #include <netinet/in.h>
 
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
