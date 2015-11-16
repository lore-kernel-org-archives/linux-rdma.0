From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH for-next 02/10] IB/iser: Default to fastreg instead of fmr
Date: Mon, 16 Nov 2015 18:37:33 +0200
Message-ID: <1447691861-3796-3-git-send-email-sagig@mellanox.com>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Or Gerlitz <ogerlitz@mellanox.com>, Steve Wise <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org

This is a pre-step before adding remote invalidate
support. Also, every ULP should prefer fastreg over
fmr.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/iser/iser_memory.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index ea765fb9664d..1103aa6e8d00 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -71,15 +71,14 @@ int iser_assign_reg_ops(struct iser_device *device)
 {
 	struct ib_device_attr *dev_attr = &device->dev_attr;
 
-	/* Assign function handles  - based on FMR support */
+	if (dev_attr->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS) {
+		iser_info("FastReg supported, using FastReg for registration\n");
+		device->reg_ops = &fastreg_ops;
+	} else
 	if (device->ib_device->alloc_fmr && device->ib_device->dealloc_fmr &&
 	    device->ib_device->map_phys_fmr && device->ib_device->unmap_fmr) {
 		iser_info("FMR supported, using FMR for registration\n");
 		device->reg_ops = &fmr_ops;
-	} else
-	if (dev_attr->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS) {
-		iser_info("FastReg supported, using FastReg for registration\n");
-		device->reg_ops = &fastreg_ops;
 	} else {
 		iser_err("IB device does not support FMRs nor FastRegs, can't register memory\n");
 		return -1;
-- 
1.8.4.3
