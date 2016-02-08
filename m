From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 libibverbs 3/7] Add bind/unbind support for Memory Window type one
Date: Mon,  8 Feb 2016 14:43:18 +0200
Message-ID: <1454935402-15192-4-git-send-email-yishaih@mellanox.com>
References: <1454935402-15192-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454935402-15192-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Type one:
- Bind through a verb.
- The R_key is allocated by the verb.
- To unbind, the bind verb should be used with size of 0.
- Belongs to a PD (no QP association).

Add above functionality by:
- Restructuring struct ibv_mw_bind.
- Expose ibv_bind_mw verb.
- Add an helper API to be used by drivers to increment the tag
  part of the R_key.
- Add IBV_ACCESS_ZERO_BASED to expose the zero based address option.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/verbs.h | 36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 7d67cc8..528bff5 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -383,9 +383,17 @@ enum ibv_access_flags {
 	IBV_ACCESS_REMOTE_READ		= (1<<2),
 	IBV_ACCESS_REMOTE_ATOMIC	= (1<<3),
 	IBV_ACCESS_MW_BIND		= (1<<4),
+	IBV_ACCESS_ZERO_BASED		= (1<<5),
 	IBV_ACCESS_ON_DEMAND		= (1<<6),
 };
 
+struct ibv_mw_bind_info {
+	struct ibv_mr	*mr;
+	uint64_t	 addr;
+	uint64_t	 length;
+	int		 mw_access_flags; /* use ibv_access_flags */
+};
+
 struct ibv_pd {
 	struct ibv_context     *context;
 	uint32_t		handle;
@@ -750,11 +758,8 @@ struct ibv_recv_wr {
 
 struct ibv_mw_bind {
 	uint64_t		wr_id;
-	struct ibv_mr	       *mr;
-	void		       *addr;
-	size_t			length;
 	int			send_flags;
-	int			mw_access_flags;
+	struct ibv_mw_bind_info bind_info;
 };
 
 struct ibv_srq {
@@ -1267,6 +1272,29 @@ static inline int ibv_dealloc_mw(struct ibv_mw *mw)
 }
 
 /**
+ * ibv_inc_rkey - Increase the 8 lsb in the given rkey
+ */
+static inline uint32_t ibv_inc_rkey(uint32_t rkey)
+{
+	const uint32_t mask = 0x000000ff;
+	uint8_t newtag = (uint8_t)((rkey + 1) & mask);
+
+	return (rkey & ~mask) | newtag;
+}
+
+/**
+ * ibv_bind_mw - Bind a memory window to a region
+ */
+static inline int ibv_bind_mw(struct ibv_qp *qp, struct ibv_mw *mw,
+			      struct ibv_mw_bind *mw_bind)
+{
+	if (mw->type != IBV_MW_TYPE_1)
+		return EINVAL;
+
+	return mw->context->ops.bind_mw(qp, mw, mw_bind);
+}
+
+/**
  * ibv_create_comp_channel - Create a completion event channel
  */
 struct ibv_comp_channel *ibv_create_comp_channel(struct ibv_context *context);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
