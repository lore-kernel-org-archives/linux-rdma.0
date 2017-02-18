From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 21/29] IB/mlx4: Delete unnecessary braces in mlx4_ib_add()
Date: Sat, 18 Feb 2017 22:11:22 +0100
Message-ID: <6abe0f08-b308-08ac-9f84-868887c0218c@users.sourceforge.net>
References: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leonro@mellanox.com>, Matan Barak <matanb@mellanox.com>, Sean Hefty <sean.hefty@intel.com>, Yishai Hadas <yishaih@mellanox.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 18 Feb 2017 16:32:41 +0100

Do not use curly brackets at one source code place
where a single statement should be sufficient.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/mlx4/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 33b46c463ffa..b950538e036e 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2898,9 +2898,8 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 		}
 		if (dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_ROCE_V1_V2) {
 			err = mlx4_config_roce_v2_port(dev, ROCE_V2_UDP_DPORT);
-			if (err) {
+			if (err)
 				goto err_notif;
-			}
 		}
 	}
 
-- 
2.11.1
