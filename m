From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH v2 01/17] IB/mlx4: Use kcalloc() in mlx4_ib_alloc_pv_bufs()
Date: Fri, 21 Apr 2017 20:21:12 +0200
Message-ID: <4ab0af63-1ea3-acd5-75ba-1992d8ae9924@users.sourceforge.net>
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
Date: Fri, 21 Apr 2017 10:21:01 +0200

* A multiplication for the size determination of a memory allocation
  indicated that an array data structure should be processed.
  Thus use the corresponding function "kcalloc".

  This issue was detected by using the Coccinelle software.

* Replace the specification of a data structure by a pointer dereference
  to make the corresponding size determination a bit safer according to
  the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
---
 drivers/infiniband/hw/mlx4/mad.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index db564ccc0f92..61bd81baeb29 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -1600,8 +1600,8 @@ static int mlx4_ib_alloc_pv_bufs(struct mlx4_ib_demux_pv_ctx *ctx,
 		return -EINVAL;
 
 	tun_qp = &ctx->qp[qp_type];
-
-	tun_qp->ring = kzalloc(sizeof (struct mlx4_ib_buf) * MLX4_NUM_TUNNEL_BUFS,
+	tun_qp->ring = kcalloc(MLX4_NUM_TUNNEL_BUFS,
+			       sizeof(*tun_qp->ring),
 			       GFP_KERNEL);
 	if (!tun_qp->ring)
 		return -ENOMEM;
-- 
2.12.2
