From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core 2/7] Enable GNU99 mode if the compiler does not support C11
Date: Thu,  8 Feb 2018 20:08:59 -0700
Message-ID: <20180209030904.22370-3-jgg@ziepe.ca>
References: <20180209030904.22370-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180209030904.22370-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

We have several places now that use C99 features and assume those
are enabled. Very old GCC's default to C89 and need to have C99 mode
enabled by command line, such as Centos 6. Fix building on those old
compilers by forcing C99 mode.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 buildlib/RDMA_EnableCStd.cmake | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/buildlib/RDMA_EnableCStd.cmake b/buildlib/RDMA_EnableCStd.cmake
index c8a8c1f5530c13..c2e170929b7dde 100644
--- a/buildlib/RDMA_EnableCStd.cmake
+++ b/buildlib/RDMA_EnableCStd.cmake
@@ -49,6 +49,8 @@ function(RDMA_EnableCStd)
     CHECK_C_COMPILER_FLAG("-std=gnu11" SUPPORTS_GNU11)
     if (SUPPORTS_GNU11)
       SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=gnu11" PARENT_SCOPE)
+    else()
+      SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=gnu99" PARENT_SCOPE)
     endif()
   else()
     # Newer cmake can do this internally
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
