From: Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 12/13] IB/usnic: Use sychronized interface of the IOMMU-API
Date: Thu, 17 Aug 2017 14:56:35 +0200
Message-ID: <1502974596-23835-13-git-send-email-joro@8bytes.org>
References: <1502974596-23835-1-git-send-email-joro@8bytes.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502974596-23835-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>, Joerg Roedel <jroedel@suse.de>, Christian Benvenuti <benve@cisco.com>, Dave Goodell <dgoodell@cisco.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

The map and unmap functions of the IOMMU-API changed their
semantics: They do no longer guarantee that the hardware
TLBs are synchronized with the page-table updates they made.

To make conversion easier, new synchronized functions have
been introduced which give these guarantees again until the
code is converted to use the new TLB-flush interface of the
IOMMU-API, which allows certain optimizations.

But for now, just convert this code to use the synchronized
functions so that it will behave as before.

Cc: Christian Benvenuti <benve@cisco.com>
Cc: Dave Goodell <dgoodell@cisco.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/infiniband/hw/usnic/usnic_uiom.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
index c49db7c..e53dc38 100644
--- a/drivers/infiniband/hw/usnic/usnic_uiom.c
+++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
@@ -205,7 +205,7 @@ static void usnic_uiom_unmap_sorted_intervals(struct list_head *intervals,
 		while (size > 0) {
 			/* Workaround for RH 970401 */
 			usnic_dbg("va 0x%lx size 0x%lx", va, PAGE_SIZE);
-			iommu_unmap(pd->domain, va, PAGE_SIZE);
+			iommu_unmap_sync(pd->domain, va, PAGE_SIZE);
 			va += PAGE_SIZE;
 			size -= PAGE_SIZE;
 		}
@@ -282,8 +282,8 @@ static int usnic_uiom_map_sorted_intervals(struct list_head *intervals,
 				size = pa_end - pa_start + PAGE_SIZE;
 				usnic_dbg("va 0x%lx pa %pa size 0x%zx flags 0x%x",
 					va_start, &pa_start, size, flags);
-				err = iommu_map(pd->domain, va_start, pa_start,
-							size, flags);
+				err = iommu_map_sync(pd->domain, va_start,
+						     pa_start, size, flags);
 				if (err) {
 					usnic_err("Failed to map va 0x%lx pa %pa size 0x%zx with err %d\n",
 						va_start, &pa_start, size, err);
@@ -299,8 +299,8 @@ static int usnic_uiom_map_sorted_intervals(struct list_head *intervals,
 				size = pa - pa_start + PAGE_SIZE;
 				usnic_dbg("va 0x%lx pa %pa size 0x%zx flags 0x%x\n",
 					va_start, &pa_start, size, flags);
-				err = iommu_map(pd->domain, va_start, pa_start,
-						size, flags);
+				err = iommu_map_sync(pd->domain, va_start,
+						     pa_start, size, flags);
 				if (err) {
 					usnic_err("Failed to map va 0x%lx pa %pa size 0x%zx with err %d\n",
 						va_start, &pa_start, size, err);
-- 
2.7.4
