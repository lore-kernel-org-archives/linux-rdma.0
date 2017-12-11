From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] IB/mlx5: revisit -Wmaybe-uninitialized warning
Date: Mon, 11 Dec 2017 12:45:44 +0100
Message-ID: <20171211114600.3636211-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matan Barak <matanb@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Arnd Bergmann <arnd@arndb.de>, Artemy Kovalyov <artemyko@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, "David S. Miller" <davem@davemloft.net>, Ilya Lesokhin <ilyal@mellanox.com>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

A warning that I thought I had fixed before occasionally comes
back in rare randconfig builds (I found 7 instances in the last
100000 builds, originally it was much more frequent):

drivers/infiniband/hw/mlx5/mr.c: In function 'mlx5_ib_reg_user_mr':
drivers/infiniband/hw/mlx5/mr.c:1229:5: error: 'order' may be used uninitialized in this function [-Werror=maybe-uninitialized]
  if (order <= mr_cache_max_order(dev)) {
     ^
drivers/infiniband/hw/mlx5/mr.c:1247:8: error: 'ncont' may be used uninitialized in this function [-Werror=maybe-uninitialized]
drivers/infiniband/hw/mlx5/mr.c:1247:8: error: 'page_shift' may be used uninitialized in this function [-Werror=maybe-uninitialized]
drivers/infiniband/hw/mlx5/mr.c:1260:2: error: 'npages' may be used uninitialized in this function [-Werror=maybe-uninitialized]

I've looked at all those findings again and noticed that they are all
with CONFIG_INFINIBAND_USER_MEM=n, which means ib_umem_get() returns
an error unconditionally and we never initialize or use those variables.
This triggers a condition in gcc iff mr_umem_get() is partially but not
entirely inlined, which in turn depends on the exact combination of
optimization settings. This is a known problem with gcc, with no
easy solution in the compiler, so this adds another workaround that
should be more reliable than my previous attempt.

Returning an error from mlx5_ib_reg_user_mr() earlier means that we
can completely bypass the logic that caused the warning, the compiler
can now see that the variable is never accessed.

Fixes: 14ab8896f5d9 ("IB/mlx5: avoid bogus -Wmaybe-uninitialized warning")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/infiniband/hw/mlx5/mr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index ee0ee1f9994b..ad37d8441fa2 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1206,6 +1206,9 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	int err;
 	bool use_umr = true;
 
+	if (!IS_ENABLED(CONFIG_INFINIBAND_USER_MEM))
+		return ERR_PTR(-EINVAL);
+
 	mlx5_ib_dbg(dev, "start 0x%llx, virt_addr 0x%llx, length 0x%llx, access_flags 0x%x\n",
 		    start, virt_addr, length, access_flags);
 
-- 
2.9.0
