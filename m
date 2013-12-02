From: Jingoo Han <jg1.han-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 12/39] IB: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:12:11 +0900
Message-ID: <002101ceefb3$ee0ac230$ca204690$%han@samsung.com>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Content-language: ko
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Greg Kroah-Hartman' <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Jingoo Han' <jg1.han-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, 'Roland Dreier' <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Samuel Iglesias Gonsalvez' <siglesias-wEGTBA9jqPzQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
is not preferred.

Signed-off-by: Jingoo Han <jg1.han-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    |    2 +-
 drivers/infiniband/hw/qib/qib_init.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 3065341..8d021f3 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1484,7 +1484,7 @@ static void remove_one(struct pci_dev *pdev)
 	ib_dealloc_device(&dev->ib_dev);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(mlx5_ib_pci_table) = {
+static const struct pci_device_id mlx5_ib_pci_table[] = {
 	{ PCI_VDEVICE(MELLANOX, 4113) }, /* MT4113 Connect-IB */
 	{ 0, }
 };
diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index 24e802f..fcd322c 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -1184,7 +1184,7 @@ static int qib_init_one(struct pci_dev *, const struct pci_device_id *);
 #define DRIVER_LOAD_MSG "Intel " QIB_DRV_NAME " loaded: "
 #define PFX QIB_DRV_NAME ": "
 
-static DEFINE_PCI_DEVICE_TABLE(qib_pci_tbl) = {
+static const struct pci_device_id qib_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_PATHSCALE, PCI_DEVICE_ID_QLOGIC_IB_6120) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_IB_7220) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_IB_7322) },
-- 
1.7.10.4


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
