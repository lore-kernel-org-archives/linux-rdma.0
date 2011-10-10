From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH] libmlx4: Fix a compiler warning
Date: Mon, 10 Oct 2011 19:47:33 +0200
Message-ID: <201110101947.34035.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid that link_local_gid() triggers the following compiler warning:
dereferencing type-punned pointer will break strict-aliasing rules

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>

---
 src/verbs.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/src/verbs.c b/src/verbs.c
index 199d107..28d8585 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -616,12 +616,10 @@ int mlx4_destroy_qp(struct ibv_qp *ibqp)
 
 static int link_local_gid(const union ibv_gid *gid)
 {
-	uint32_t hi = *(uint32_t *)(gid->raw);
-	uint32_t lo = *(uint32_t *)(gid->raw + 4);
-	if (hi == htonl(0xfe800000) && lo == 0)
-		return 1;
+	uint32_t hi = gid->u32[0];
+	uint32_t lo = gid->u32[1];
 
-	return 0;
+	return hi == htonl(0xfe800000) && lo == 0;
 }
 
 static uint16_t get_vlan_id(union ibv_gid *gid)
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
