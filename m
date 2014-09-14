From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 1/2] IB/uverbs: Add QP creation flags, allow blocking UD multicast loopback
Date: Sun, 14 Sep 2014 16:20:01 +0300
Message-ID: <1410700802-27848-2-git-send-email-ogerlitz@mellanox.com>
References: <1410700802-27848-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410700802-27848-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Currently, there's no way for user-space applications to specify
the IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK QP creation flags defined
by commit 47ee1b9 "IB/core: Add support for multicast loopback blocking".

As a result, applications who send and recieve over the same QP to
the same multicast group get all their packets bouncded back to them,
which is terribly bad performance wise.

To fix this long standing issue, add the ability to provide QP
creation flags through uverbs.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c |   35 ++++++++++++++++++++++++++++++++-
 include/uapi/rdma/ib_user_verbs.h    |    2 +-
 2 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 0600c50..1ad489c 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1579,6 +1579,31 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
 	return in_len;
 }
 
+enum ib_uverbs_qp_create_flags {
+	IB_UVERBS_QP_CREATE_LSO	    = 0,
+	IB_UVERBS_QP_CREATE_BLOCK_MULTICAST_LOOPBACK = 1,
+	IB_UVERBS_SUPPORTED_FLAGS
+};
+
+static int ib_uverbs_create_qp_trans(u8 u_flags)
+{
+	int i;
+	int res;
+	static const enum ib_qp_create_flags ib_uverbs_qp_create_flags[IB_UVERBS_SUPPORTED_FLAGS] = {
+		[IB_UVERBS_QP_CREATE_LSO] = IB_QP_CREATE_IPOIB_UD_LSO,
+		[IB_UVERBS_QP_CREATE_BLOCK_MULTICAST_LOOPBACK] = IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK,
+	};
+
+	if (u_flags & ~((1 << IB_UVERBS_SUPPORTED_FLAGS) - 1))
+		return -1;
+
+	for (i = 0; i < IB_UVERBS_SUPPORTED_FLAGS; i++)
+		if (u_flags & (1 << i))
+			res |= ib_uverbs_qp_create_flags[i];
+
+	return res;
+}
+
 ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 			    const char __user *buf, int in_len,
 			    int out_len)
@@ -1595,7 +1620,7 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 	struct ib_srq                  *srq = NULL;
 	struct ib_qp                   *qp;
 	struct ib_qp_init_attr          attr;
-	int ret;
+	int flags, ret;
 
 	if (out_len < sizeof resp)
 		return -ENOSPC;
@@ -1664,7 +1689,13 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 	attr.xrcd	   = xrcd;
 	attr.sq_sig_type   = cmd.sq_sig_all ? IB_SIGNAL_ALL_WR : IB_SIGNAL_REQ_WR;
 	attr.qp_type       = cmd.qp_type;
-	attr.create_flags  = 0;
+
+	flags  = ib_uverbs_create_qp_trans(cmd.create_flags);
+	if (flags < 0) {
+		ret = -EINVAL;
+		goto err_put;
+	}
+	attr.create_flags  = flags;
 
 	attr.cap.max_send_wr     = cmd.max_send_wr;
 	attr.cap.max_recv_wr     = cmd.max_recv_wr;
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 26daf55..fac6975 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -470,7 +470,7 @@ struct ib_uverbs_create_qp {
 	__u8  sq_sig_all;
 	__u8  qp_type;
 	__u8  is_srq;
-	__u8  reserved;
+	__u8  create_flags;
 	__u64 driver_data[0];
 };
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
