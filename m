From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs V4 2/5] Extend create_ah in order to pass L2 parameters to the provider
Date: Sun, 18 May 2014 12:38:46 +0300
Message-ID: <1400405929-14313-3-git-send-email-ogerlitz@r-vnc04.mtr.labs.mlnx>
References: <1400405929-14313-1-git-send-email-ogerlitz@r-vnc04.mtr.labs.mlnx>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1400405929-14313-1-git-send-email-ogerlitz-lZu6o6FoHf8DyJZ7l8Lk7nI+JuX82XLG@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In order to support IP based addressing, one needs to pass the L2
parameters to the provider drive. This is done through a new extendable
interface between libibverbs and the provider library.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/verbs.h |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 71adf2a..ab497b1 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -40,6 +40,7 @@
 #include <pthread.h>
 #include <stddef.h>
 #include <errno.h>
+#include <sys/socket.h>
 
 #ifdef __cplusplus
 #  define BEGIN_C_DECLS extern "C" {
@@ -467,6 +468,28 @@ struct ibv_ah_attr {
 	uint8_t			port_num;
 };
 
+enum ibv_ah_attr_ex_attr_mask {
+	IBV_AH_ATTR_EX_LL = 1UL << 0,
+	IBV_AH_ATTR_EX_VID = 1UL << 1,
+};
+
+struct ibv_ah_attr_ex {
+	struct ibv_global_route	grh;
+	uint16_t		dlid;
+	uint8_t			sl;
+	uint8_t			src_path_bits;
+	uint8_t			static_rate;
+	uint8_t			is_global;
+	uint8_t			port_num;
+	uint32_t		comp_mask;
+	union {
+		struct sockaddr		sa;
+		struct sockaddr_storage _s;
+	} ll;
+	uint16_t		vid;
+};
+
+
 enum ibv_srq_attr_mask {
 	IBV_SRQ_MAX_WR	= 1 << 0,
 	IBV_SRQ_LIMIT	= 1 << 1
@@ -975,6 +998,8 @@ enum verbs_context_mask {
 
 struct verbs_context {
 	/*  "grows up" - new fields go here */
+	struct ibv_ah * (*create_ah_ex)(struct ibv_pd *pd,
+					struct ibv_ah_attr_ex *attr);
 	void (*_reserved_2)(void);
 	int (*destroy_flow)(struct ibv_flow *flow);
 	void (*_reserved_1)(void);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
