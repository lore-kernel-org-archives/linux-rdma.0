From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 22/25] RDMA/nes: fix error return code
Date: Sun, 29 Dec 2013 23:47:37 +0100
Message-ID: <1388357260-4843-23-git-send-email-Julia.Lawall@lip6.fr>
References: <1388357260-4843-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1388357260-4843-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Faisal Latif <faisal.latif@intel.com>
Cc: kernel-janitors@vger.kernel.org, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
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

 drivers/infiniband/hw/nes/nes.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
index 4291410..353c7b0 100644
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -675,8 +675,11 @@ static int nes_probe(struct pci_dev *pcidev, const struct pci_device_id *ent)
 	INIT_DELAYED_WORK(&nesdev->work, nes_recheck_link_status);
 
 	/* Initialize network devices */
-	if ((netdev = nes_netdev_init(nesdev, mmio_regs)) == NULL)
+	netdev = nes_netdev_init(nesdev, mmio_regs);
+	if (netdev == NULL) {
+		ret = -ENOMEM;
 		goto bail7;
+	}
 
 	/* Register network device */
 	ret = register_netdev(netdev);
