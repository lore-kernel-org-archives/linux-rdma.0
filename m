From: Raju Rangoju <rajur@chelsio.com>
Subject: [rdma-rc PATCH 2/2] iw_cxgb4: cq/qp mask depends on bar2 pages in a host page
Date: Thu, 14 Feb 2019 17:40:54 +0530
Message-ID: <20190214121054.11693-3-rajur@chelsio.com>
References: <20190214121054.11693-1-rajur@chelsio.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190214121054.11693-1-rajur@chelsio.com>
Sender: netdev-owner@vger.kernel.org
To: jgg@mellanox.com, davem@davemloft.net, linux-rdma@vger.kernel.org
Cc: netdev@vger.kernel.org, swise@opengridcomputing.com, rajur@chelsio.com
List-Id: linux-rdma@vger.kernel.org

Adjust the cq/qp mask based on no.of bar2 pages in a host page.

For user-mode rdma, the granularity of the BAR2 memory mapped
to a user rdma process during queue allocation must be based
on the host page size. The lld attributes udb_density and
ucq_density are used to figure out how many sge contexts are
in a bar2 page. So the rdev->qpmask and rdev->cqmask in
iw_cxgb4 need to now be adjusted based on how many sge bar2
pages are in a host page.

Fixes: 2391b0030e ("cxgb4: Remove SGE_HOST_PAGE_SIZE dependency on page size")
Signed-off-by: Raju Rangoju <rajur@chelsio.com>
---
 drivers/infiniband/hw/cxgb4/device.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index c13c0ba30f63..d499cd61c0e8 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -783,6 +783,7 @@ void c4iw_init_dev_ucontext(struct c4iw_rdev *rdev,
 static int c4iw_rdev_open(struct c4iw_rdev *rdev)
 {
 	int err;
+	unsigned int factor;
 
 	c4iw_init_dev_ucontext(rdev, &rdev->uctx);
 
@@ -806,8 +807,18 @@ static int c4iw_rdev_open(struct c4iw_rdev *rdev)
 		return -EINVAL;
 	}
 
-	rdev->qpmask = rdev->lldi.udb_density - 1;
-	rdev->cqmask = rdev->lldi.ucq_density - 1;
+	/* This implementation requires a sge_host_page_size <= PAGE_SIZE. */
+	if (rdev->lldi.sge_host_page_size > PAGE_SIZE) {
+		pr_err("%s: unsupported sge host page size %u\n",
+		       pci_name(rdev->lldi.pdev),
+		       rdev->lldi.sge_host_page_size);
+		return -EINVAL;
+	}
+
+	factor = PAGE_SIZE / rdev->lldi.sge_host_page_size;
+	rdev->qpmask = (rdev->lldi.udb_density * factor) - 1;
+	rdev->cqmask = (rdev->lldi.ucq_density * factor) - 1;
+
 	pr_debug("dev %s stag start 0x%0x size 0x%0x num stags %d pbl start 0x%0x size 0x%0x rq start 0x%0x size 0x%0x qp qid start %u size %u cq qid start %u size %u srq size %u\n",
 		 pci_name(rdev->lldi.pdev), rdev->lldi.vr->stag.start,
 		 rdev->lldi.vr->stag.size, c4iw_num_stags(rdev),
-- 
2.13.0
