From: Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH] RDMA/nes: Use kcalloc instead of kzalloc to allocate array
Date: Tue, 29 Nov 2011 22:08:00 +0100
Message-ID: <1322600880.1534.305.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The advantage of kcalloc is, that will prevent integer overflows which could
result from the multiplication of number of elements and size and it is also
a bit nicer to read.

The semantic patch that makes this change is available
in https://lkml.org/lkml/2011/11/25/107

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
--- a/drivers/infiniband/hw/nes/nes_verbs.c 2011-11-13 11:07:26.680158626 +0100
+++ b/drivers/infiniband/hw/nes/nes_verbs.c 2011-11-28 19:51:27.201653445 +0100
@@ -2156,7 +2156,9 @@ static struct ib_mr *nes_reg_phys_mr(str
 					kfree(nesmr);
 					return ERR_PTR(-ENOMEM);
 				}
-				root_vpbl.leaf_vpbl = kzalloc(sizeof(*root_vpbl.leaf_vpbl)*1024, GFP_KERNEL);
+				root_vpbl.leaf_vpbl = kcalloc(1024,
+							      sizeof(*root_vpbl.leaf_vpbl),
+							      GFP_KERNEL);
 				if (!root_vpbl.leaf_vpbl) {
 					pci_free_consistent(nesdev->pcidev, 8192, root_vpbl.pbl_vbase,
 							root_vpbl.pbl_pbase);
@@ -2429,8 +2431,9 @@ static struct ib_mr *nes_reg_user_mr(str
 									ibmr = ERR_PTR(-ENOMEM);
 									goto reg_user_mr_err;
 								}
-								root_vpbl.leaf_vpbl = kzalloc(sizeof(*root_vpbl.leaf_vpbl)*1024,
-										GFP_KERNEL);
+								root_vpbl.leaf_vpbl = kcalloc(1024,
+											      sizeof(*root_vpbl.leaf_vpbl),
+											      GFP_KERNEL);
 								if (!root_vpbl.leaf_vpbl) {
 									ib_umem_release(region);
 									pci_free_consistent(nesdev->pcidev, 8192, root_vpbl.pbl_vbase,
