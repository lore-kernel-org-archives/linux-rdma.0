From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] IB/mlx5: remove duplicated include from mlx5_ib.h
Date: Mon, 10 Dec 2018 15:27:59 +0800
Message-ID: <20181210072759.26128-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: leon@kernel.org, dledford@redhat.com, jgg@ziepe.ca
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>
List-Id: linux-rdma@vger.kernel.org

Remove duplicated include.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 484a080..64fbf45 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -41,7 +41,6 @@
 #include <linux/mlx5/cq.h>
 #include <linux/mlx5/fs.h>
 #include <linux/mlx5/qp.h>
-#include <linux/mlx5/fs.h>
 #include <linux/types.h>
 #include <linux/mlx5/transobj.h>
 #include <rdma/ib_user_verbs.h>
-- 
2.7.0
