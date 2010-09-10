From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 2.6.37 06/11] RDMA/cxgb4: log HW lack-of-resource errors.
Date: Fri, 10 Sep 2010 11:15:14 -0500
Message-ID: <20100910161514.6829.86869.stgit@build.ogc.int>
References: <20100910161442.6829.91594.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100910161442.6829.91594.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This helps debug cases where HW resources are depleted.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/resource.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/resource.c b/drivers/infiniband/hw/cxgb4/resource.c
index 83b23df..26365f6 100644
--- a/drivers/infiniband/hw/cxgb4/resource.c
+++ b/drivers/infiniband/hw/cxgb4/resource.c
@@ -311,6 +311,9 @@ u32 c4iw_pblpool_alloc(struct c4iw_rdev *rdev, int size)
 {
 	unsigned long addr = gen_pool_alloc(rdev->pbl_pool, size);
 	PDBG("%s addr 0x%x size %d\n", __func__, (u32)addr, size);
+	if (!addr && printk_ratelimit())
+		printk(KERN_WARNING MOD "%s: Out of PBL memory\n",
+		       pci_name(rdev->lldi.pdev));
 	return (u32)addr;
 }
 
@@ -370,6 +373,9 @@ u32 c4iw_rqtpool_alloc(struct c4iw_rdev *rdev, int size)
 {
 	unsigned long addr = gen_pool_alloc(rdev->rqt_pool, size << 6);
 	PDBG("%s addr 0x%x size %d\n", __func__, (u32)addr, size << 6);
+	if (!addr && printk_ratelimit())
+		printk(KERN_WARNING MOD "%s: Out of RQT memory\n",
+		       pci_name(rdev->lldi.pdev));
 	return (u32)addr;
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
