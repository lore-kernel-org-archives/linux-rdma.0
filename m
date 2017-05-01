From: Michael Mera <dev-5Y08+B5RRAgbhb6IIWwbbQ@public.gmane.org>
Subject: [PATCH] IB/ocrdma: fix out of bounds access to local buffer
Date: Mon,  1 May 2017 15:41:16 +0900
Message-ID: <20170501064116.3900-1-dev@michaelmera.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: Michael Mera <dev-5Y08+B5RRAgbhb6IIWwbbQ@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In write to debugfs file 'resource_stats' the local buffer 'tmp_str' is
written at index 'count-1' where 'count' is the size of the write, so
potentially 0.

This patch filters odd values for the write size/position to avoid this
type of problem.

Signed-off-by: Michael Mera <dev-5Y08+B5RRAgbhb6IIWwbbQ@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_stats.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
index f8e4b0a6486f..66056f9a9700 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
@@ -643,7 +643,7 @@ static ssize_t ocrdma_dbgfs_ops_write(struct file *filp,
 	struct ocrdma_stats *pstats = filp->private_data;
 	struct ocrdma_dev *dev = pstats->dev;
 
-	if (count > 32)
+	if (*ppos != 0 || count == 0 || count > sizeof(tmp_str))
 		goto err;
 
 	if (copy_from_user(tmp_str, buffer, count))
-- 
2.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
