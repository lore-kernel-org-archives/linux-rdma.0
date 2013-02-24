From: Syam Sidhardhan <syamsidhardh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] mlx4: Remove redundant NULL check before kfree
Date: Mon, 25 Feb 2013 04:50:05 +0530
Message-ID: <1361748005-29705-1-git-send-email-s.syam@samsung.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: syamsidhardh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

kfree on NULL pointer is a no-op.

Signed-off-by: Syam Sidhardhan <s.syam-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index e7d81c0..3fdd1c1 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1601,8 +1601,7 @@ static void do_slave_init(struct mlx4_ib_dev *ibdev, int slave, int do_init)
 		spin_unlock_irqrestore(&ibdev->sriov.going_down_lock, flags);
 	}
 out:
-	if (dm)
-		kfree(dm);
+	kfree(dm);
 	return;
 }
 
-- 
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
