From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 07/10] rdmacm: Remove dangling cpu_to_be64 definitions
Date: Thu,  9 Feb 2017 14:53:29 -0700
Message-ID: <1486677212-3188-8-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1486677212-3188-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1486677212-3188-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

No users.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 librdmacm/examples/common.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/librdmacm/examples/common.h b/librdmacm/examples/common.h
index 28b977a075e6f1..1e69f5091ad078 100644
--- a/librdmacm/examples/common.h
+++ b/librdmacm/examples/common.h
@@ -41,9 +41,6 @@
 #include <rdma/rsocket.h>
 #include <infiniband/ib.h>
 
-static inline uint64_t cpu_to_be64(uint64_t x) { return htobe64(x); }
-static inline uint32_t cpu_to_be32(uint32_t x) { return htobe32(x); }
-
 extern int use_rs;
 
 #define rs_socket(f,t,p)  use_rs ? rsocket(f,t,p)  : socket(f,t,p)
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
