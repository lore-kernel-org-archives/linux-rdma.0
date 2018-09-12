From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: [PATCH] ucma: fix a use-after-free in ucma_resolve_ip()
Date: Wed, 12 Sep 2018 16:27:44 -0700
Message-ID: <20180912232744.12693-1-xiyou.wangcong@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-rdma@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>, Jason Gunthorpe <jgg@mellanox.com>, Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leon@kernel.org>
List-Id: linux-rdma@vger.kernel.org

There is a race condition between ucma_close() and ucma_resolve_ip():

CPU0				CPU1
ucma_resolve_ip():		ucma_close():

ctx = ucma_get_ctx(file, cmd.id);

        list_for_each_entry_safe(ctx, tmp, &file->ctx_list, list) {
                mutex_lock(&mut);
                idr_remove(&ctx_idr, ctx->id);
                mutex_unlock(&mut);
		...
                mutex_lock(&mut);
                if (!ctx->closing) {
                        mutex_unlock(&mut);
                        rdma_destroy_id(ctx->cm_id);
		...
                ucma_free_ctx(ctx);

ret = rdma_resolve_addr();
ucma_put_ctx(ctx);

Before idr_remove(), ucma_get_ctx() could still find the ctx
and after rdma_destroy_id(), rdma_resolve_addr() may still
access id_priv pointer. Also, ucma_put_ctx() may use ctx after
ucma_free_ctx() too.

ucma_close() should call ucma_put_ctx() too which tests the
refcnt and waits for the last one releasing it. The similar
pattern is already used by ucma_destroy_id().

Reported-and-tested-by: syzbot+da2591e115d57a9cbb8b@syzkaller.appspotmail.com
Reported-by: syzbot+cfe3c1e8ef634ba8964b@syzkaller.appspotmail.com
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 drivers/infiniband/core/ucma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 5f437d1570fb..21863ddde63e 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -1759,6 +1759,8 @@ static int ucma_close(struct inode *inode, struct file *filp)
 		mutex_lock(&mut);
 		if (!ctx->closing) {
 			mutex_unlock(&mut);
+			ucma_put_ctx(ctx);
+			wait_for_completion(&ctx->comp);
 			/* rdma_destroy_id ensures that no event handlers are
 			 * inflight for that id before releasing it.
 			 */
-- 
2.14.4
