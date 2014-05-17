From: Colin King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH] IB/mlx4: fix unitialised variable is_mcast
Date: Sat, 17 May 2014 23:33:44 +0100
Message-ID: <1400366024-18781-1-git-send-email-colin.king@canonical.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Commit 297e0dad7 introduced a bug where is_mcast is now
no longer initiialised on the non-multicast condition and so
it can be any random value from the stack.  This issue was
detected by cppcheck:

[drivers/infiniband/hw/mlx4/ah.c:103]: (error) Uninitialized
  variable: is_mcast

Simple fix is to initialise is_mcast to zero.

Signed-off-by: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/ah.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/ah.c b/drivers/infiniband/hw/mlx4/ah.c
index 170dca6..2d8c339 100644
--- a/drivers/infiniband/hw/mlx4/ah.c
+++ b/drivers/infiniband/hw/mlx4/ah.c
@@ -73,7 +73,7 @@ static struct ib_ah *create_iboe_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr
 {
 	struct mlx4_ib_dev *ibdev = to_mdev(pd->device);
 	struct mlx4_dev *dev = ibdev->dev;
-	int is_mcast;
+	int is_mcast = 0;
 	struct in6_addr in6;
 	u16 vlan_tag;
 
-- 
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
