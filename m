From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 15/29] IB/mlx4: Delete an unnecessary return statement in
 do_slave_init()
Date: Sat, 18 Feb 2017 22:03:52 +0100
Message-ID: <50e213dd-b3b0-5028-a463-b9fbdf6e25cf@users.sourceforge.net>
References: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leonro@mellanox.com>, Matan Barak <matanb@mellanox.com>, Sean Hefty <sean.hefty@intel.com>, Yishai Hadas <yishaih@mellanox.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 18 Feb 2017 15:16:54 +0100

The script "checkpatch.pl" pointed information out like the following.

WARNING: void function return statements are not generally useful

Thus remove such a statement here.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/mlx4/main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 89bbb61d62f5..b2b472977a39 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -3131,7 +3131,6 @@ static void do_slave_init(struct mlx4_ib_dev *ibdev, int slave, int do_init)
 	}
 out:
 	kfree(dm);
-	return;
 }
 
 static void mlx4_ib_handle_catas_error(struct mlx4_ib_dev *ibdev)
-- 
2.11.1

