From: Qing Huang <qing.huang@oracle.com>
Subject: [PATCH v2] IB/mlx5: avoid excessive warning msgs when creating VFs on 2nd port
Date: Mon, 23 Jul 2018 14:15:08 -0700
Message-ID: <20180723211508.7078-1-qing.huang@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: jgg@ziepe.ca, dledford@redhat.com, leon@kernel.org, gerald.gibson@oracle.com, qing.huang@oracle.com, danielj@mellanox.com, sharon.s.liu@oracle.com
List-Id: linux-rdma@vger.kernel.org

When a CX5 device is configured in dual-port RoCE mode, after creating
many VFs against port 1, creating the same number of VFs against port 2
will flood kernel/syslog with something like
"mlx5_*:mlx5_ib_bind_slave_port:4266:(pid 5269): port 2 already
affiliated."

So basically, when traversing mlx5_ib_dev_list, mlx5_ib_add_slave_port()
repeatedly attempts to bind the new mpi structure to every device
on the list until it finds an unbound device.

Change the log level from warn to dbg to avoid log flooding as the warning
should be harmless.

Signed-off-by: Qing Huang <qing.huang@oracle.com>
---
  v1 -> v2: change the log level instead

 drivers/infiniband/hw/mlx5/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index b3ba9a2..f57b8f7 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5127,8 +5127,8 @@ static bool mlx5_ib_bind_slave_port(struct mlx5_ib_dev *ibdev,
 
 	spin_lock(&ibdev->port[port_num].mp.mpi_lock);
 	if (ibdev->port[port_num].mp.mpi) {
-		mlx5_ib_warn(ibdev, "port %d already affiliated.\n",
-			     port_num + 1);
+		mlx5_ib_dbg(ibdev, "port %d already affiliated.\n",
+			    port_num + 1);
 		spin_unlock(&ibdev->port[port_num].mp.mpi_lock);
 		return false;
 	}
-- 
2.9.3
