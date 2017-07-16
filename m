From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 1/3] infiniband: mthca: constify pci_device_id.
Date: Sun, 16 Jul 2017 12:00:44 +0530
Message-ID: <1500186646-28815-2-git-send-email-arvind.yadav.cs@gmail.com>
References: <1500186646-28815-1-git-send-email-arvind.yadav.cs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1500186646-28815-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, aditr@vmware.com, pv-drivers@vmware.com, sean.hefty@intel.com, dledford@redhat.com, hal.rosenstock@gmail.com
List-Id: linux-rdma@vger.kernel.org

pci_device_id are not supposed to change at runtime. All functions
working with pci_device_id provided by <linux/pci.h> work with
const pci_device_id. So mark the non-const structs as const.

File size before:
   text	   data	    bss	    dec	    hex	filename
  13067	    805	      4	  13876	   3634	infiniband/hw/mthca/mthca_main.o

File size After adding 'const':
   text	   data	    bss	    dec	    hex	filename
  13419	    453	      4	  13876	   3634	infiniband/hw/mthca/mthca_main.o

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/infiniband/hw/mthca/mthca_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_main.c b/drivers/infiniband/hw/mthca/mthca_main.c
index c309e5c..5695cda 100644
--- a/drivers/infiniband/hw/mthca/mthca_main.c
+++ b/drivers/infiniband/hw/mthca/mthca_main.c
@@ -1162,7 +1162,7 @@ static void mthca_remove_one(struct pci_dev *pdev)
 	mutex_unlock(&mthca_device_mutex);
 }
 
-static struct pci_device_id mthca_pci_table[] = {
+static const struct pci_device_id mthca_pci_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_MELLANOX, PCI_DEVICE_ID_MELLANOX_TAVOR),
 	  .driver_data = TAVOR },
 	{ PCI_DEVICE(PCI_VENDOR_ID_TOPSPIN, PCI_DEVICE_ID_MELLANOX_TAVOR),
-- 
2.7.4
