From: Pan Bian <bianpan201603@163.com>
Subject: [PATCH 1/1] infiniband: hw: mlx4: fix improper return value
Date: Sun,  4 Dec 2016 13:49:04 +0800
Message-ID: <1480830544-5002-1-git-send-email-bianpan201603@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Yishai Hadas <yishaih@mellanox.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
List-Id: linux-rdma@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

If uhw->inlen is non-zero, the value of variable err is 0 if the copy
succeeds. Then, if kzalloc() or kmalloc() returns a NULL pointer, it
will return 0 to the callers. As a result, the callers cannot detect the
errors. This patch fixes the bug, assigning "-ENOMEM" to err before
the NULL pointer checks.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=189031

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 drivers/infiniband/hw/mlx4/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index b597e82..f6c5158 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -455,6 +455,7 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 		sizeof(resp.response_length);
 	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
 	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
+	err = -ENOMEM;
 	if (!in_mad || !out_mad)
 		goto out;
 
-- 
1.9.1
