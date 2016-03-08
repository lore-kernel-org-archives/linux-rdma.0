From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH v4 1/9] IB/cma: pass the port number to ib_create_qp
Date: Tue,  8 Mar 2016 19:16:32 +0100
Message-ID: <1457461000-24088-2-git-send-email-hch@lst.de>
References: <1457461000-24088-1-git-send-email-hch@lst.de>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1457461000-24088-1-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: dledford@redhat.com, bart.vanassche@sandisk.com
Cc: sagig@mellanox.com, swise@opengridcomputing.com, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The new RW API will need this.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Steve Wise <swise@opengridcomputing.com>
---
 drivers/infiniband/core/cma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 9729639..a791522 100644
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
