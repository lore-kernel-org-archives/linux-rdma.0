From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH v2 10/17] IB/mlx4: Delete an unnecessary variable in
 __mlx4_ib_query_gid()
Date: Fri, 21 Apr 2017 20:42:14 +0200
Message-ID: <823e7d21-4d14-dbab-0499-80ca965dee31@users.sourceforge.net>
References: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>
 <1492720654.3041.16.camel@redhat.com>
 <a56f9301-e116-c59c-681a-9108519920e5@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a56f9301-e116-c59c-681a-9108519920e5@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leonro@mellanox.com>, Majd Dibbiny <majd@mellanox.com>, Matan Barak <matanb@mellanox.com>, Sean Hefty <sean.hefty@intel.com>, Yishai Hadas <yishaih@mellanox.com>, linux-rdma@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 21 Apr 2017 18:22:42 +0200

* Call the function "memset" directly in an if branch without using
  an intermediate variable.

* Delete the local variable "clear" which became unnecessary with
  this refactoring.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/mlx4/main.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index e18e46a68809..a54e2f04929b 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -780,7 +780,6 @@ int __mlx4_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
 	struct ib_smp *out_mad;
 	int err;
 	struct mlx4_ib_dev *dev = to_mdev(ibdev);
-	int clear = 0;
 	int mad_ifc_flags = MLX4_MAD_IFC_IGNORE_KEYS;
 
 	in_mad  = kzalloc(sizeof(*in_mad), GFP_KERNEL);
@@ -809,8 +808,8 @@ int __mlx4_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
 	if (mlx4_is_mfunc(dev->dev) && !netw_view) {
 		if (index) {
 			/* For any index > 0, return the null guid */
+			memset(gid->raw + 8, 0, 8);
 			err = 0;
-			clear = 1;
 			goto out;
 		}
 	}
@@ -827,8 +826,6 @@ int __mlx4_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
 	memcpy(gid->raw + 8, out_mad->data + (index % 8) * 8, 8);
 
 out:
-	if (clear)
-		memset(gid->raw + 8, 0, 8);
 	kfree(out_mad);
 free_in_mad:
 	kfree(in_mad);
-- 
2.12.2
