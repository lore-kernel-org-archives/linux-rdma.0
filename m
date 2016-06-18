From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] ib/rxe: double free on error
Date: Sat, 18 Jun 2016 11:40:21 +0300
Message-ID: <20160618084021.GB21713@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Moni Shoua <monis@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

"goto err1" could probably be remained "goto free_pkey_tbl" since
that's what it does.  This is a double free.

Fixes: 0784481b2f32 ('Add initialization for Soft RoCE driver, pools constants etc.')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/infiniband/hw/rxe/rxe.c b/drivers/infiniband/hw/rxe/rxe.c
index 48c41e00..50e25b0 100644
--- a/drivers/infiniband/hw/rxe/rxe.c
+++ b/drivers/infiniband/hw/rxe/rxe.c
@@ -187,7 +187,6 @@ static int rxe_init_ports(struct rxe_dev *rxe)
 	port->pkey_tbl[0] = 0xffff;
 
 	if (!port->attr.gid_tbl_len) {
-		kfree(port->pkey_tbl);
 		err = -EINVAL;
 		goto err1;
 	}
