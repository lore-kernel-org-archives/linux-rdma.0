From: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 2/7] IB/core: Allow setting create flags in QP init attribute
Date: Sun, 16 Aug 2015 19:05:28 +0300
Message-ID: <1439741133-30145-3-git-send-email-eranbe@mellanox.com>
References: <1439741133-30145-1-git-send-email-eranbe@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1439741133-30145-1-git-send-email-eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Allow setting IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK at create_flags in
ib_uverbs_create_qp_ex.

Signed-off-by: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 2bac2f1..f3ea3ed 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1823,7 +1823,7 @@ static int create_qp(struct ib_uverbs_file *file,
 		      sizeof(cmd->create_flags))
 		attr.create_flags = cmd->create_flags;
 
-	if (attr.create_flags) {
+	if (attr.create_flags & ~IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK) {
 		ret = -EINVAL;
 		goto err_put;
 	}
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
