From: Qing Huang <qing.huang@oracle.com>
Subject: [PATCH] IB/mlx5: avoid binding a new mpi unit to the same devices repeatedly
Date: Fri, 13 Jul 2018 16:50:21 -0700
Message-ID: <20180713235021.18141-1-qing.huang@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: jgg@ziepe.ca, dledford@redhat.com, leon@kernel.org, gerald.gibson@oracle.com, qing.huang@oracle.com
List-Id: linux-rdma@vger.kernel.org

When a CX5 device is configured in dual-port RoCE mode, after creating
many VFs against port 1, creating the same number of VFs against port 2
will flood kernel/syslog with something like
"mlx5_*:mlx5_ib_bind_slave_port:4266:(pid 5269): port 2 already
affiliated."

So basically, when traversing mlx5_ib_dev_list, mlx5_ib_add_slave_port()
shouldn't repeatedly attempt to bind the new mpi data unit to every device
on the list until it finds an unbound device.

Reported-by: Gerald Gibson <gerald.gibson@oracle.com>
Signed-off-by: Qing Huang <qing.huang@oracle.com>
---
 drivers/infiniband/hw/mlx5/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index b3ba9a2..1ddd1d3 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -6068,7 +6068,8 @@ static void *mlx5_ib_add_slave_port(struct mlx5_core_dev *mdev, u8 port_num)
 
 	mutex_lock(&mlx5_ib_multiport_mutex);
 	list_for_each_entry(dev, &mlx5_ib_dev_list, ib_dev_list) {
-		if (dev->sys_image_guid == mpi->sys_image_guid)
+		if (dev->sys_image_guid == mpi->sys_image_guid &&
+		    !dev->port[mlx5_core_native_port_num(mdev) - 1].mp.mpi)
 			bound = mlx5_ib_bind_slave_port(dev, mpi);
 
 		if (bound) {
-- 
2.9.3
