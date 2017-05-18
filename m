From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc v1] IB/uverbs: Declare local function to be static and add brackets to sizeof
Date: Thu, 18 May 2017 07:40:33 +0300
Message-ID: <20170518044033.8637-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Commit 57520751445b ("IB/SA: Add OPA path record type") introduced
new local function __ib_copy_path_rec_to_user, but didn't limit its
scope. This produces the following sparse warning:

	drivers/infiniband/core/uverbs_marshall.c:99:6: warning:
	symbol '__ib_copy_path_rec_to_user' was not declared. Should it be
	static?

In addition, it used sizeof ... notations instead of sizeof(...), which
is correct in C, but a little bit misleading. Let's change it too.

Fixes: 57520751445b ("IB/SA: Add OPA path record type")
Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 Changelog from v0:
 * Add Yuval's ROB
 * Add change from sizeof ... to sizeof(...) to commit message
 * Update subject line to reflect the change
---
 drivers/infiniband/core/uverbs_marshall.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_marshall.c b/drivers/infiniband/core/uverbs_marshall.c
index 8b9587fe2303..94fd989c9060 100644
--- a/drivers/infiniband/core/uverbs_marshall.c
+++ b/drivers/infiniband/core/uverbs_marshall.c
@@ -96,11 +96,11 @@ void ib_copy_qp_attr_to_user(struct ib_uverbs_qp_attr *dst,
 }
 EXPORT_SYMBOL(ib_copy_qp_attr_to_user);

-void __ib_copy_path_rec_to_user(struct ib_user_path_rec *dst,
-				struct sa_path_rec *src)
+static void __ib_copy_path_rec_to_user(struct ib_user_path_rec *dst,
+				       struct sa_path_rec *src)
 {
-	memcpy(dst->dgid, src->dgid.raw, sizeof src->dgid);
-	memcpy(dst->sgid, src->sgid.raw, sizeof src->sgid);
+	memcpy(dst->dgid, src->dgid.raw, sizeof(src->dgid));
+	memcpy(dst->sgid, src->sgid.raw, sizeof(src->sgid));

 	dst->dlid		= htons(ntohl(sa_path_get_dlid(src)));
 	dst->slid		= htons(ntohl(sa_path_get_slid(src)));
--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
