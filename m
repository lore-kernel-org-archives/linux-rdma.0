From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 1/4] drivers/infiniband/hw/qib/qib_iba6120.c: convert GFP_KERNEL to GFP_ATOMIC
Date: Mon,  9 Jan 2012 10:40:47 +0100
Message-ID: <1326102050-30265-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Marciniszyn <infinipath@qlogic.com>
Cc: kernel-janitors@vger.kernel.org, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-rdma@vger.kernel.org

From: Julia Lawall <julia.lawall@lip6.fr>

The function is called with locks held and thus should not use GFP_KERNEL.

The semantic patch that makes this report is available
in scripts/coccinelle/locks/call_kern.cocci.

More information about semantic patching is available at
http://coccinelle.lip6.fr/

Signed-off-by: Julia Lawall <julia.lawall@lip6.fr>

---
 drivers/infiniband/hw/qib/qib_iba6120.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba6120.c b/drivers/infiniband/hw/qib/qib_iba6120.c
index 781a802..84ab49a 100644
--- a/drivers/infiniband/hw/qib/qib_iba6120.c
+++ b/drivers/infiniband/hw/qib/qib_iba6120.c
@@ -2103,7 +2103,7 @@ static void alloc_dummy_hdrq(struct qib_devdata *dd)
 	dd->cspec->dummy_hdrq = dma_alloc_coherent(&dd->pcidev->dev,
 					dd->rcd[0]->rcvhdrq_size,
 					&dd->cspec->dummy_hdrq_phys,
-					GFP_KERNEL | __GFP_COMP);
+					GFP_ATOMIC | __GFP_COMP);
 	if (!dd->cspec->dummy_hdrq) {
 		qib_devinfo(dd->pcidev, "Couldn't allocate dummy hdrq\n");
 		/* fallback to just 0'ing */
