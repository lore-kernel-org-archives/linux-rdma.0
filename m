From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 1/6] rxe: Use libc's IN6_IS_ADDR_V4MAPPED
Date: Thu,  6 Apr 2017 16:42:20 -0600
Message-ID: <1491518545-14746-2-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1491518545-14746-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1491518545-14746-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Instead of the open coded version, makes sparse work.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt      | 4 ++--
 providers/rxe/rxe.c | 3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 7a05c3602bca2d..e5074f6e100637 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -392,8 +392,8 @@ endif()
 
 add_subdirectory(providers/hfi1verbs) # NO SPARSE
 add_subdirectory(providers/ipathverbs) # NO SPARSE
-add_subdirectory(providers/rxe) # NO SPARSE
-add_subdirectory(providers/rxe/man) # NO SPARSE
+add_subdirectory(providers/rxe)
+add_subdirectory(providers/rxe/man)
 
 # Binaries
 add_subdirectory(ibacm) # NO SPARSE
diff --git a/providers/rxe/rxe.c b/providers/rxe/rxe.c
index 438f7c30505dd1..775caf0e185148 100644
--- a/providers/rxe/rxe.c
+++ b/providers/rxe/rxe.c
@@ -753,8 +753,7 @@ static int rxe_post_recv(struct ibv_qp *ibqp,
 
 static inline int ipv6_addr_v4mapped(const struct in6_addr *a)
 {
-	 return ((unsigned long)(a->s6_addr32[0] | a->s6_addr32[1]) |
-		 (unsigned long)(a->s6_addr32[2] ^ htobe32(0x0000ffff))) == 0UL;
+	return IN6_IS_ADDR_V4MAPPED(a);
 }
 
 static inline int rdma_gid2ip(struct sockaddr *out, union ibv_gid *gid)
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
