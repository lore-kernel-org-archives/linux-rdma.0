From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RESEND V2 for-next 5/5] IB/core: Fix deadlock on uverbs modify_qp error flow
Date: Thu,  5 Feb 2015 13:35:44 +0200
Message-ID: <1423136144-12784-6-git-send-email-ogerlitz@mellanox.com>
References: <1423136144-12784-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423136144-12784-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The deadlock occurs on __uverbs_modify_qp, we take a lock (idr_read_qp)
and in case of failure in ib_resolve_eth_l2_attrs we don't release
it (put_qp_read). Fix that.

Issue: 355606
Fixes: ed4c54e5b4ba ("IB/core: Resolve Ethernet L2 addresses when modifying QP")
Signed-off-by: Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index ecb6430..a602ce9 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2097,20 +2097,21 @@ ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
 	if (qp->real_qp == qp) {
 		ret = ib_resolve_eth_l2_attrs(qp, attr, &cmd.attr_mask);
 		if (ret)
-			goto out;
+			goto release_qp;
 		ret = qp->device->modify_qp(qp, attr,
 			modify_qp_mask(qp->qp_type, cmd.attr_mask), &udata);
 	} else {
 		ret = ib_modify_qp(qp, attr, modify_qp_mask(qp->qp_type, cmd.attr_mask));
 	}
 
-	put_qp_read(qp);
-
 	if (ret)
-		goto out;
+		goto release_qp;
 
 	ret = in_len;
 
+release_qp:
+	put_qp_read(qp);
+
 out:
 	kfree(attr);
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
