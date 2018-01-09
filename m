From: Colin King <colin.king@canonical.com>
Subject: [PATCH][next] IB/mlx5: remove redundant assignment of mdev
Date: Tue,  9 Jan 2018 15:55:43 +0000
Message-ID: <20180109155543.15027-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matan Barak <matanb@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The initial assignment to mdev is redundant as mdev is re-assigned
later and the first assigned value is never read. Remove this
redundant assignment.

Cleans up clang warning:
drivers/infiniband/hw/mlx5/main.c:359:24: warning: Value stored
to 'mdev' during its initialization is never read

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/infiniband/hw/mlx5/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 5d6fba986fa5..91e6b42798e5 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -356,7 +356,7 @@ static int mlx5_query_port_roce(struct ib_device *device, u8 port_num,
 				struct ib_port_attr *props)
 {
 	struct mlx5_ib_dev *dev = to_mdev(device);
-	struct mlx5_core_dev *mdev = dev->mdev;
+	struct mlx5_core_dev *mdev;
 	struct net_device *ndev, *upper;
 	enum ib_mtu ndev_ib_mtu;
 	bool put_mdev = true;
-- 
2.15.1
