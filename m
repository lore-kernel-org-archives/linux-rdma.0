From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH] libibverbs: Make it easy to interpret struct ibv_gid as four 32-bit words
Date: Mon, 10 Oct 2011 19:43:48 +0200
Message-ID: <201110101943.48642.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>

---
 include/infiniband/verbs.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index ad9d524..656abb8 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -57,6 +57,7 @@ BEGIN_C_DECLS
 
 union ibv_gid {
 	uint8_t			raw[16];
+	uint32_t		u32[4];
 	struct {
 		uint64_t	subnet_prefix;
 		uint64_t	interface_id;
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
