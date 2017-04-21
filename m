From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH v2 16/17] IB/mlx4: Add spaces for better code readability
Date: Fri, 21 Apr 2017 20:54:06 +0200
Message-ID: <d7f1064f-a70e-83c4-bf45-0467ffba954f@users.sourceforge.net>
References: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>
 <1492720654.3041.16.camel@redhat.com>
 <a56f9301-e116-c59c-681a-9108519920e5@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a56f9301-e116-c59c-681a-9108519920e5@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leonro@mellanox.com>, Majd Dibbiny <majd@mellanox.com>, Matan Barak <matanb@mellanox.com>, Sean Hefty <sean.hefty@intel.com>, Yishai Hadas <yishaih@mellanox.com>, linux-rdma@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, trivial@kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 21 Apr 2017 19:14:11 +0200

Use space characters at some source code places according to
the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/mlx4/qp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 068abfdc9d01..15240163c399 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1065,7 +1065,7 @@ static void destroy_qp_common(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp,
 	list_del(&qp->cq_recv_list);
 	if (!is_user) {
 		__mlx4_ib_cq_clean(recv_cq, qp->mqp.qpn,
-				 qp->ibqp.srq ? to_msrq(qp->ibqp.srq): NULL);
+				   qp->ibqp.srq ? to_msrq(qp->ibqp.srq) : NULL);
 		if (send_cq != recv_cq)
 			__mlx4_ib_cq_clean(send_cq, qp->mqp.qpn, NULL);
 	}
@@ -2599,7 +2599,7 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_ud_wr *wr,
 		u16 ether_type;
 		u16 pcp = (be32_to_cpu(ah->av.ib.sl_tclass_flowlabel) >> 29) << 13;
 
-		ether_type = (!is_udp) ? ETH_P_IBOE:
+		ether_type = (!is_udp) ? ETH_P_IBOE :
 			(ip_version == 4 ? ETH_P_IP : ETH_P_IPV6);
 
 		mlx->sched_prio = cpu_to_be16(pcp);
-- 
2.12.2
