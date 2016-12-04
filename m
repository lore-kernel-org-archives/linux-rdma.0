From: Pan Bian <bianpan201603@163.com>
Subject: [PATCH 1/1] infiniband: hw: mlx4: fix improper return value
Date: Sun,  4 Dec 2016 14:45:38 +0800
Message-ID: <1480833938-6284-1-git-send-email-bianpan201603@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
List-Id: linux-rdma@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

If uhw->inlen is non-zero, the value of variable err is 0 if the copy
succeeds. Then, if kzalloc() or kmalloc() returns a NULL pointer, it
will return 0 to the callers. As a result, the callers cannot detect the
errors. This patch fixes the bug, assign "-ENOMEM" to err before the
NULL pointer checks, and remove the initialization of err at the
beginning.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=189031
Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 drivers/infiniband/hw/mlx4/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index b597e82..a87c395 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -430,7 +430,7 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 	struct mlx4_ib_dev *dev = to_mdev(ibdev);
 	struct ib_smp *in_mad  = NULL;
 	struct ib_smp *out_mad = NULL;
-	int err = -ENOMEM;
+	int err;
 	int have_ib_ports;
 	struct mlx4_uverbs_ex_query_device cmd;
 	struct mlx4_uverbs_ex_query_device_resp resp = {.comp_mask = 0};
@@ -455,6 +455,7 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 		sizeof(resp.response_length);
 	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
 	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
+	err = -ENOMEM;
 	if (!in_mad || !out_mad)
 		goto out;
 
-- 
1.9.1
