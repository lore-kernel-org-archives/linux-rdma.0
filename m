From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH librdmacm 1/4] rsocket: Check max inline data after creating QP
Date: Fri, 18 Apr 2014 14:55:40 -0700
Message-ID: <1397858143-22402-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The ipath provider will ignore the max_inline_size
specified as input into ibv_create_qp and instead
return the size that it supports (which is 0) on
output.

Update the actual inline size returned from create QP,
and check that it meets the minimum requirement for
rsockets.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/rsocket.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/src/rsocket.c b/src/rsocket.c
index 30ea55d..7c5083c 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -860,6 +860,10 @@ static int rs_create_ep(struct rsocket *rs)
 	if (ret)
 		return ret;
 
+	rs->sq_inline = qp_attr.cap.max_inline_data;
+	if (rs->sq_inline < RS_MIN_INLINE)
+		return ERR(EINVAL);
+
 	for (i = 0; i < rs->rq_size; i++) {
 		ret = rs_post_recv(rs);
 		if (ret)
@@ -1491,6 +1495,12 @@ static int ds_create_qp(struct rsocket *rs, union socket_addr *src_addr,
 	if (ret)
 		goto err;
 
+	rs->sq_inline = qp_attr.cap.max_inline_data;
+	if (rs->sq_inline < RS_MIN_INLINE) {
+		ret = ERR(ENOMEM);
+		goto err;
+	}
+
 	ret = ds_add_qp_dest(qp, src_addr, addrlen);
 	if (ret)
 		goto err;
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
