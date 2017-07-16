From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 2/3] infiniband: nes: constify pci_device_id.
Date: Sun, 16 Jul 2017 12:00:45 +0530
Message-ID: <1500186646-28815-3-git-send-email-arvind.yadav.cs@gmail.com>
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
  10429	    780	     33	  11242	   2bea	drivers/infiniband/hw/nes/nes.o

File size After adding 'const':
   text	   data	    bss	    dec	    hex	filename
  10541	    668	     33	  11242	   2bea	drivers/infiniband/hw/nes/nes.o

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/infiniband/hw/nes/nes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
index a30aa65..a47595c 100644
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -102,7 +102,7 @@ static unsigned int ee_flsh_adapter;
 static unsigned int sysfs_nonidx_addr;
 static unsigned int sysfs_idx_addr;
 
-static struct pci_device_id nes_pci_table[] = {
+static const struct pci_device_id nes_pci_table[] = {
 	{ PCI_VDEVICE(NETEFFECT, PCI_DEVICE_ID_NETEFFECT_NE020), },
 	{ PCI_VDEVICE(NETEFFECT, PCI_DEVICE_ID_NETEFFECT_NE020_KR), },
 	{0}
-- 
2.7.4
