From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 10/12] RDMA/mlx5: Move SMI caps logic
Date: Thu, 28 Mar 2019 15:27:40 +0200
Message-ID: <20190328132742.12070-11-leon@kernel.org>
References: <20190328132742.12070-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190328132742.12070-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Maor Gottlieb <maorg@mellanox.com>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

We store the SMI information in the core device's struct, make sure
we set that information only once (and not per port), while here make
the for loop based on the actual size of the array.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 9ce8ae5565a3..7eca3978c50c 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4534,7 +4534,7 @@ static int set_has_smi_cap(struct mlx5_ib_dev *dev)
 	int err;
 	int port;
 
-	for (port = 1; port <= dev->num_ports; port++) {
+	for (port = 1; port <= ARRAY_SIZE(dev->mdev->port_caps); port++) {
 		dev->mdev->port_caps[port - 1].has_smi = false;
 		if (MLX5_CAP_GEN(dev->mdev, port_type) ==
 		    MLX5_CAP_PORT_TYPE_IB) {
@@ -4580,10 +4580,6 @@ static int get_port_caps(struct mlx5_ib_dev *dev, u8 port)
 	if (!dprops)
 		goto out;
 
-	err = set_has_smi_cap(dev);
-	if (err)
-		goto out;
-
 	err = mlx5_ib_query_device(&dev->ib_dev, dprops, &uhw);
 	if (err) {
 		mlx5_ib_warn(dev, "query_device failed %d\n", err);
@@ -5960,6 +5956,10 @@ int mlx5_ib_stage_init_init(struct mlx5_ib_dev *dev)
 	if (err)
 		return err;
 
+	err = set_has_smi_cap(dev);
+	if (err)
+		return err;
+
 	if (!mlx5_core_mp_enabled(mdev)) {
 		for (i = 1; i <= dev->num_ports; i++) {
 			err = get_port_caps(dev, i);
-- 
2.20.1
