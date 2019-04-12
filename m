From: Colin King <colin.king@canonical.com>
Subject: [PATCH][next] RDMA/mlx5: check for error return in flow_rule rather than err
Date: Fri, 12 Apr 2019 11:40:17 +0100
Message-ID: <20190412104017.25507-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently when the call to create_flow_rule_vport_sq fails, the error
check is being performed on err rather than on the return pointer
flow_rule.  The return flow_rule maybe NULL (which is not considered
an error) or an error code, so check for the error on flow_rule.

Addresses-Coverity: ("Uninitialized scalar variable")
Fixes: d5ed8ac34cef ("RDMA/mlx5: Move default representors SQ steering to rule to modify QP")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 99ed77e7d7af..98c3241547fd 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3276,7 +3276,7 @@ static int modify_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 		flow_rule = create_flow_rule_vport_sq(dev, sq,
 						      raw_qp_param->port);
 		if (IS_ERR(flow_rule))
-			return err;
+			return PTR_ERR(flow_rule);
 
 		err = modify_raw_packet_qp_sq(dev->mdev, sq, sq_state,
 					      raw_qp_param, qp->ibqp.pd);
-- 
2.20.1
