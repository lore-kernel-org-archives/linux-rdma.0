From: =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>
Subject: [PATCH] RDMA/mlx4: Spread completion vectors for proxy CQs
Date: Mon, 18 Feb 2019 19:33:02 +0100
Message-ID: <20190218183302.1242676-1-haakon.bugge@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Yishai Hadas <yishaih@mellanox.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, jackm@dev.mellanox.co.il, majd@mellanox.com
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

MAD packet sending/receiving is not properly virtualized in
CX-3. Hence, these are proxied through the PF driver. The proxying
uses UD QPs. The associated CQs are created with completion vector
zero.

This leads to great imbalance in CPU processing, in particular during
heavy RDMA CM traffic.

Solved by selecting the completion vector on a round-robin base.

The imbalance can be demonstrated in a bare-metal environment, where
two nodes have instantiated 8 VFs each. This using dual ported HCAs,
so we have 16 vPorts per physical server.

64 processes are associated with each vPort and creates and destroys
one QP for each of the remote 64 processes. That is, 1024 QPs per
vPort, all in all 16K QPs. The QPs are created/destroyed using the
CM.

Before this commit, we have (excluding all completion IRQs with zero
interrupts):

396: mlx4-1@0000:94:00.0 199126
397: mlx4-2@0000:94:00.0 1

With this commit:

396: mlx4-1@0000:94:00.0 12568
397: mlx4-2@0000:94:00.0 50772
398: mlx4-3@0000:94:00.0 10063
399: mlx4-4@0000:94:00.0 50753
400: mlx4-5@0000:94:00.0 6127
401: mlx4-6@0000:94:00.0 6114
[]
414: mlx4-19@0000:94:00.0 6122
415: mlx4-20@0000:94:00.0 6117

The added pr_info shows:

create_pv_resources: slave:0 port:1, vector:0, num_comp_vectors:62
create_pv_resources: slave:0 port:1, vector:1, num_comp_vectors:62
create_pv_resources: slave:0 port:2, vector:2, num_comp_vectors:62
create_pv_resources: slave:0 port:2, vector:3, num_comp_vectors:62
create_pv_resources: slave:1 port:1, vector:4, num_comp_vectors:62
create_pv_resources: slave:1 port:2, vector:5, num_comp_vectors:62
[]
create_pv_resources: slave:8 port:2, vector:18, num_comp_vectors:62
create_pv_resources: slave:8 port:1, vector:19, num_comp_vectors:62

Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
---
 drivers/infiniband/hw/mlx4/mad.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 936ee1314bcd..300839e7f519 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -1973,6 +1973,7 @@ static int create_pv_resources(struct ib_device *ibdev, int slave, int port,
 {
 	int ret, cq_size;
 	struct ib_cq_init_attr cq_attr = {};
+	static atomic_t comp_vect = ATOMIC_INIT(-1);
 
 	if (ctx->state != DEMUX_PV_STATE_DOWN)
 		return -EEXIST;
@@ -2002,6 +2003,9 @@ static int create_pv_resources(struct ib_device *ibdev, int slave, int port,
 		cq_size *= 2;
 
 	cq_attr.cqe = cq_size;
+	cq_attr.comp_vector = atomic_inc_return(&comp_vect) % ibdev->num_comp_vectors;
+	pr_info("slave:%d port:%d, vector:%d, num_comp_vectors:%d\n",
+		slave, port, cq_attr.comp_vector, ibdev->num_comp_vectors);
 	ctx->cq = ib_create_cq(ctx->ib_dev, mlx4_ib_tunnel_comp_handler,
 			       NULL, ctx, &cq_attr);
 	if (IS_ERR(ctx->cq)) {
-- 
2.20.1
