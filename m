From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/12] IB/cma: pass the port number to ib_create_qp
Date: Mon, 11 Apr 2016 14:32:30 -0700
Message-ID: <1460410360-13104-3-git-send-email-hch@lst.de>
References: <1460410360-13104-1-git-send-email-hch@lst.de>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1460410360-13104-1-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: bart.vanassche@sandisk.com, swise@opengridcomputing.com, sagi@grimberg.me, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The new RW API will need this.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
Tested-by: Steve Wise <swise@opengridcomputing.com>
---
 drivers/infiniband/core/cma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 93ab0ae..6ebaf20 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -800,6 +800,7 @@ int rdma_create_qp(struct rdma_cm_id *id, struct ib_pd *pd,
 	if (id->device != pd->device)
 		return -EINVAL;
 
+	qp_init_attr->port_num = id->port_num;
 	qp = ib_create_qp(pd, qp_init_attr);
 	if (IS_ERR(qp))
 		return PTR_ERR(qp);
-- 
2.1.4
