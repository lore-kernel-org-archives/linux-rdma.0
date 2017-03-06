From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 2/5] IB/nes: Use kcalloc() in nes_reg_user_mr()
Date: Mon, 6 Mar 2017 18:41:40 +0100
Message-ID: <192fcb99-eef6-8820-9260-b6ad0ee60165@users.sourceforge.net>
References: <502a5a6f-ee91-dd2f-cdc7-63f396059529@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <502a5a6f-ee91-dd2f-cdc7-63f396059529@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Faisal Latif <faisal.latif@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 6 Mar 2017 16:26:25 +0100

A multiplication for the size determination of a memory allocation
indicated that an array data structure should be processed.
Thus reuse the corresponding function "kcalloc".

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/nes/nes_verbs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index d3eae2f3e9f5..a28dfeaa1f45 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -2260,8 +2260,9 @@ static struct ib_mr *nes_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 								ibmr = ERR_PTR(-ENOMEM);
 								goto reg_user_mr_err;
 							}
-							root_vpbl.leaf_vpbl = kzalloc(sizeof(*root_vpbl.leaf_vpbl)*1024,
-									GFP_KERNEL);
+							root_vpbl.leaf_vpbl = kcalloc(1024,
+										      sizeof(*root_vpbl.leaf_vpbl),
+										      GFP_KERNEL);
 							if (!root_vpbl.leaf_vpbl) {
 								ib_umem_release(region);
 								pci_free_consistent(nesdev->pcidev, 8192, root_vpbl.pbl_vbase,
-- 
2.12.0

