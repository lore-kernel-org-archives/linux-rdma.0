From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] RDS: IB: fix 'passing zero to ERR_PTR()' warning
Date: Tue, 7 Aug 2018 19:34:16 +0800
Message-ID: <20180807113416.12680-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: santosh.shilimkar@oracle.com, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, YueHaibing <yuehaibing@huawei.com>
List-Id: linux-rdma@vger.kernel.org

Fix a static code checker warning:
 net/rds/ib_frmr.c:82 rds_ib_alloc_frmr() warn: passing zero to 'ERR_PTR'

The error path for ib_alloc_mr failure should set err to PTR_ERR.

Fixes: 1659185fb4d0 ("RDS: IB: Support Fastreg MR (FRMR) memory registration mode") 
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/rds/ib_frmr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/rds/ib_frmr.c b/net/rds/ib_frmr.c
index b371cf0..6431a02 100644
--- a/net/rds/ib_frmr.c
+++ b/net/rds/ib_frmr.c
@@ -61,6 +61,7 @@ static struct rds_ib_mr *rds_ib_alloc_frmr(struct rds_ib_device *rds_ibdev,
 			 pool->fmr_attr.max_pages);
 	if (IS_ERR(frmr->mr)) {
 		pr_warn("RDS/IB: %s failed to allocate MR", __func__);
+		err = PTR_ERR(frmr->mr);
 		goto out_no_cigar;
 	}
 
-- 
2.7.0
