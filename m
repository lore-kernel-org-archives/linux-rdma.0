From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] RDMA/cxgb4: stack info leak in c4iw_create_qp()
Date: Thu, 25 Jul 2013 19:48:32 +0300
Message-ID: <20130725164832.GA7026@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Steve Wise <swise@chelsio.com>
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

"uresp.ma_sync_key" doesn't get set on this path so we leak 8 bytes of
data.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 2320404..a4975e1 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -1657,6 +1657,8 @@ struct ib_qp *c4iw_create_qp(struct ib_pd *pd, struct ib_qp_init_attr *attrs,
 		if (mm5) {
 			uresp.ma_sync_key = ucontext->key;
 			ucontext->key += PAGE_SIZE;
+		} else {
+			uresp.ma_sync_key =  0;
 		}
 		uresp.sq_key = ucontext->key;
 		ucontext->key += PAGE_SIZE;
