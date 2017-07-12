From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 8/8] vmw_pvrdma: Add sparse annotations
Date: Wed, 12 Jul 2017 15:17:42 -0600
Message-ID: <1499894262-10761-9-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1499894262-10761-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1499894262-10761-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt                | 2 +-
 providers/vmw_pvrdma/pvrdma.h | 6 +++---
 providers/vmw_pvrdma/verbs.c  | 7 +------
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index c2d6618ebd4601..1e9b1a363b7436 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -422,7 +422,7 @@ add_subdirectory(providers/mthca)
 add_subdirectory(providers/nes) # NO SPARSE
 add_subdirectory(providers/ocrdma)
 add_subdirectory(providers/qedr)
-add_subdirectory(providers/vmw_pvrdma) # NO SPARSE
+add_subdirectory(providers/vmw_pvrdma)
 endif()
 
 add_subdirectory(providers/hfi1verbs)
diff --git a/providers/vmw_pvrdma/pvrdma.h b/providers/vmw_pvrdma/pvrdma.h
index d4acefcedde154..7840e11ee7266c 100644
--- a/providers/vmw_pvrdma/pvrdma.h
+++ b/providers/vmw_pvrdma/pvrdma.h
@@ -152,7 +152,7 @@ struct pvrdma_qp {
 	struct pvrdma_buf		sbuf;
 	int				max_inline_data;
 	int				buf_size;
-	uint32_t			sq_signal_bits;
+	__be32				sq_signal_bits;
 	int				sq_spare_wqes;
 	struct pvrdma_wq		sq;
 	struct pvrdma_wq		rq;
@@ -210,12 +210,12 @@ static inline struct pvrdma_ah *to_vah(struct ibv_ah *ibah)
 
 static inline void pvrdma_write_uar_qp(void *uar, unsigned value)
 {
-	*(uint32_t *)(uar + PVRDMA_UAR_QP_OFFSET) = htole32(value);
+	*(__le32 *)(uar + PVRDMA_UAR_QP_OFFSET) = htole32(value);
 }
 
 static inline void pvrdma_write_uar_cq(void *uar, unsigned value)
 {
-	*(uint32_t *)(uar + PVRDMA_UAR_CQ_OFFSET) = htole32(value);
+	*(__le32 *)(uar + PVRDMA_UAR_CQ_OFFSET) = htole32(value);
 }
 
 static inline int ibv_send_flags_to_pvrdma(int flags)
diff --git a/providers/vmw_pvrdma/verbs.c b/providers/vmw_pvrdma/verbs.c
index 0a07748da513aa..1bb1634863a6e9 100644
--- a/providers/vmw_pvrdma/verbs.c
+++ b/providers/vmw_pvrdma/verbs.c
@@ -154,12 +154,7 @@ static int is_multicast_gid(const union ibv_gid *gid)
 
 static int is_link_local_gid(const union ibv_gid *gid)
 {
-	uint32_t *hi = (uint32_t *)(gid->raw);
-	uint32_t *lo = (uint32_t *)(gid->raw + 4);
-	if (hi[0] == htobe32(0xfe800000) && lo[0] == 0)
-		return 1;
-
-	return 0;
+	return gid->global.subnet_prefix == htobe64(0xfe80000000000000ULL);
 }
 
 static int is_ipv6_addr_v4mapped(const struct in6_addr *a)
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
