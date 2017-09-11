From: Colin King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH] RDMA/cxgb3: remove redundant first assignement of sqp
Date: Mon, 11 Sep 2017 12:42:31 +0100
Message-ID: <20170911114231.22893-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

sqp is being initialised when it is being declared and then updated
a little later on making the first initialization redundant. Clean
this up by initializing ptr and sqp at their declaration.

Cleans up warning: "warning: Value stored to 'sqp' during its
initialization is never read"

Fixes: a58e58fafdff ("RDMA/cxgb3: Wrap the software send queue pointer as needed on flush")
Signed-off-by: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 drivers/infiniband/hw/cxgb3/cxio_hal.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.c b/drivers/infiniband/hw/cxgb3/cxio_hal.c
index 3eff6541bd6f..b42e81ab5fa8 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_hal.c
+++ b/drivers/infiniband/hw/cxgb3/cxio_hal.c
@@ -404,12 +404,10 @@ static void insert_sq_cqe(struct t3_wq *wq, struct t3_cq *cq,
 
 int cxio_flush_sq(struct t3_wq *wq, struct t3_cq *cq, int count)
 {
-	__u32 ptr;
+	__u32 ptr = wq->sq_rptr + count;
 	int flushed = 0;
-	struct t3_swsq *sqp = wq->sq + Q_PTR2IDX(wq->sq_rptr, wq->sq_size_log2);
+	struct t3_swsq *sqp = wq->sq + Q_PTR2IDX(ptr, wq->sq_size_log2);
 
-	ptr = wq->sq_rptr + count;
-	sqp = wq->sq + Q_PTR2IDX(ptr, wq->sq_size_log2);
 	while (ptr != wq->sq_wptr) {
 		sqp->signaled = 0;
 		insert_sq_cqe(wq, cq, sqp);
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
