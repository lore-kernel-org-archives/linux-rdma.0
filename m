From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 04/29] IB/mlx4: Improve another size determination in
 alloc_pv_object()
Date: Sat, 18 Feb 2017 21:51:43 +0100
Message-ID: <398511b4-2e62-ee7e-69b7-f9a83922332b@users.sourceforge.net>
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
Date: Fri, 17 Feb 2017 20:20:43 +0100

Replace the specification of a data structure by a pointer dereference
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/mlx4/mad.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 284634d36b1c..ea4892b0f39e 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -1948,7 +1948,7 @@ static int alloc_pv_object(struct mlx4_ib_dev *dev, int slave, int port,
 	struct mlx4_ib_demux_pv_ctx *ctx;
 
 	*ret_ctx = NULL;
-	ctx = kzalloc(sizeof (struct mlx4_ib_demux_pv_ctx), GFP_KERNEL);
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
 
-- 
2.11.1
