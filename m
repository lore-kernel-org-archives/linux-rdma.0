From: Geliang Tang <geliangtang-9Onoh4P/yGk@public.gmane.org>
Subject: [PATCH] IB/mlx4: use list_for_each_entry_safe in search_relocate_mgid0_group
Date: Mon,  7 Dec 2015 23:04:43 +0800
Message-ID: <dada9ed857f53514519bbf57828380fdc72c827f.1449500617.git.geliangtang@163.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Geliang Tang <geliangtang-9Onoh4P/yGk@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Simplify the code with list_for_each_entry_safe().

Signed-off-by: Geliang Tang <geliangtang-9Onoh4P/yGk@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mcg.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mcg.c b/drivers/infiniband/hw/mlx4/mcg.c
index 99451d8..ebdca2b 100644
--- a/drivers/infiniband/hw/mlx4/mcg.c
+++ b/drivers/infiniband/hw/mlx4/mcg.c
@@ -747,14 +747,11 @@ static struct mcast_group *search_relocate_mgid0_group(struct mlx4_ib_demux_ctx
 						       __be64 tid,
 						       union ib_gid *new_mgid)
 {
-	struct mcast_group *group = NULL, *cur_group;
+	struct mcast_group *group = NULL, *cur_group, *n;
 	struct mcast_req *req;
-	struct list_head *pos;
-	struct list_head *n;
 
 	mutex_lock(&ctx->mcg_table_lock);
-	list_for_each_safe(pos, n, &ctx->mcg_mgid0_list) {
-		group = list_entry(pos, struct mcast_group, mgid0_list);
+	list_for_each_entry_safe(group, n, &ctx->mcg_mgid0_list, mgid0_list) {
 		mutex_lock(&group->lock);
 		if (group->last_req_tid == tid) {
 			if (memcmp(new_mgid, &mgid0, sizeof mgid0)) {
-- 
2.5.0


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
