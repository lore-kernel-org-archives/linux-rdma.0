From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] IB/mlx4: Potential uninitialized variable in
 bringup_rss_rwqs()
Date: Tue, 1 Aug 2017 13:57:55 +0300
Message-ID: <20170801105755.vy4tqnmvtdtrbbo5@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Yishai Hadas <yishaih@mellanox.com>, Guy Levi <guyle@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

My static checker complains "err" can be used uninitialized.  I don't
know the subsystem well, but to an outside observer it seems like a
potential bug.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index e42acfb20588..03896e3af67f 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -2035,7 +2035,7 @@ static u8 gid_type_to_qpc(enum ib_gid_type gid_type)
 static int bringup_rss_rwqs(struct ib_rwq_ind_table *ind_tbl, u8 port_num)
 {
 	int i;
-	int err;
+	int err = 0;
 
 	for (i = 0; i < (1 << ind_tbl->log_ind_tbl_size); i++) {
 		struct ib_wq *ibwq = ind_tbl->ind_tbl[i];
