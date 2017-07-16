From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 3/3] infiniband: pvrdma: constify pci_device_id.
Date: Sun, 16 Jul 2017 12:00:46 +0530
Message-ID: <1500186646-28815-4-git-send-email-arvind.yadav.cs@gmail.com>
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
  10774	   1872	      8	  12654	   316e infiniband/hw/vmw_pvrdma/pvrdma_main.o

File size After adding 'const':
   text	   data	    bss	    dec	    hex	filename
  10838	   1808	      8	  12654	   316e infiniband/hw/vmw_pvrdma/pvrdma_main.o

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
index 34ebc76..2b83530 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
@@ -1078,7 +1078,7 @@ static void pvrdma_pci_remove(struct pci_dev *pdev)
 	pci_set_drvdata(pdev, NULL);
 }
 
-static struct pci_device_id pvrdma_pci_table[] = {
+static const struct pci_device_id pvrdma_pci_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_VMWARE, PCI_DEVICE_ID_VMWARE_PVRDMA), },
 	{ 0 },
 };
-- 
2.7.4
