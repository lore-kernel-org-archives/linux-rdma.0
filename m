From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH rdma-next] RDMA/qedr: remove set but not used variable 'ctx'
Date: Sat, 1 Sep 2018 03:53:46 +0000
Message-ID: <1535774026-160694-1-git-send-email-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Kalderon <Michal.Kalderon@cavium.com>, Ariel Elior <Ariel.Elior@cavium.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: YueHaibing <yuehaibing@huawei.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/infiniband/hw/qedr/verbs.c: In function 'qedr_create_srq':
drivers/infiniband/hw/qedr/verbs.c:1450:24: warning:
 variable 'ctx' set but not used [-Wunused-but-set-variable]

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/infiniband/hw/qedr/verbs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 8cc3df2..9d4d165 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -1447,7 +1447,6 @@ struct ib_srq *qedr_create_srq(struct ib_pd *ibpd,
 	u64 pbl_base_addr, phy_prod_pair_addr;
 	struct ib_ucontext *ib_ctx = NULL;
 	struct qedr_srq_hwq_info *hw_srq;
-	struct qedr_ucontext *ctx = NULL;
 	u32 page_cnt, page_size;
 	struct qedr_srq *srq;
 	int rc = 0;
@@ -1473,7 +1472,6 @@ struct ib_srq *qedr_create_srq(struct ib_pd *ibpd,
 
 	if (udata && ibpd->uobject && ibpd->uobject->context) {
 		ib_ctx = ibpd->uobject->context;
-		ctx = get_qedr_ucontext(ib_ctx);
 
 		if (ib_copy_from_udata(&ureq, udata, sizeof(ureq))) {
 			DP_ERR(dev,
