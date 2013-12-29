From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 14/25] RDMA/amso1100: fix error return code
Date: Sun, 29 Dec 2013 23:47:29 +0100
Message-ID: <1388357260-4843-15-git-send-email-Julia.Lawall@lip6.fr>
References: <1388357260-4843-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1388357260-4843-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Tom Tucker <tom@opengridcomputing.com>
Cc: kernel-janitors@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Set the return variable to an error code as done elsewhere in the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}

// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not tested.

 drivers/infiniband/hw/amso1100/c2.c      |    4 +++-
 drivers/infiniband/hw/amso1100/c2_rnic.c |    3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/amso1100/c2.c b/drivers/infiniband/hw/amso1100/c2.c
index d53cf51..00400c3 100644
--- a/drivers/infiniband/hw/amso1100/c2.c
+++ b/drivers/infiniband/hw/amso1100/c2.c
@@ -1082,6 +1082,7 @@ static int c2_probe(struct pci_dev *pcidev, const struct pci_device_id *ent)
 
 	/* Initialize network device */
 	if ((netdev = c2_devinit(c2dev, mmio_regs)) == NULL) {
+		ret = -ENOMEM;
 		iounmap(mmio_regs);
 		goto bail4;
 	}
@@ -1151,7 +1152,8 @@ static int c2_probe(struct pci_dev *pcidev, const struct pci_device_id *ent)
 		goto bail10;
 	}
 
-	if (c2_register_device(c2dev))
+	ret = c2_register_device(c2dev);
+	if (ret)
 		goto bail10;
 
 	return 0;
diff --git a/drivers/infiniband/hw/amso1100/c2_rnic.c b/drivers/infiniband/hw/amso1100/c2_rnic.c
index b7c9869..d2a6d96 100644
--- a/drivers/infiniband/hw/amso1100/c2_rnic.c
+++ b/drivers/infiniband/hw/amso1100/c2_rnic.c
@@ -576,7 +576,8 @@ int c2_rnic_init(struct c2_dev *c2dev)
 		goto bail4;
 
 	/* Initialize cached the adapter limits */
-	if (c2_rnic_query(c2dev, &c2dev->props))
+	err = c2_rnic_query(c2dev, &c2dev->props);
+	if (err)
 		goto bail5;
 
 	/* Initialize the PD pool */
