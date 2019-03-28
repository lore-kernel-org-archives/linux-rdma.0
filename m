From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 06/12] RDMA/mlx5: Use correct size for device resources
Date: Thu, 28 Mar 2019 15:27:36 +0200
Message-ID: <20190328132742.12070-7-leon@kernel.org>
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

On allocation we use the array size and on destruction num_ports,
use the array size of destruction as well, in this context the array
corresponds to the native/actual ports on the NIC so no need to adjust
this logic for representors.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index e3483ecc2f98..14cc4c56e2b1 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4862,8 +4862,6 @@ static int create_dev_resources(struct mlx5_ib_resources *devr)
 
 static void destroy_dev_resources(struct mlx5_ib_resources *devr)
 {
-	struct mlx5_ib_dev *dev =
-		container_of(devr, struct mlx5_ib_dev, devr);
 	int port;
 
 	mlx5_ib_destroy_srq(devr->s1);
@@ -4877,7 +4875,7 @@ static void destroy_dev_resources(struct mlx5_ib_resources *devr)
 	kfree(devr->p0);
 
 	/* Make sure no change P_Key work items are still executing */
-	for (port = 0; port < dev->num_ports; ++port)
+	for (port = 0; port < ARRAY_SIZE(devr->ports); ++port)
 		cancel_work_sync(&devr->ports[port].pkey_change_work);
 }
 
-- 
2.20.1
