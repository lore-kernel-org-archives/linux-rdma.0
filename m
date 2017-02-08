From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 11/27] IB/hfi1: Check upper-case EFI variables
Date: Wed, 08 Feb 2017 05:26:55 -0800
Message-ID: <20170208132654.16442.87357.stgit@scvm10.sc.intel.com>
References: <20170208132142.16442.69329.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170208132142.16442.69329.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The EFI variable that provides board ID is named
by the PCI address of the device, which is published
in upper-case, while the HFI1 driver reads the EFI
variable in lower-case.
This prevents returning the correct board id when
queried through sysfs. Read EFI variables in
upper-case if the lower-case read fails.

Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/efivar.c |   26 ++++++++++++++++++++++----
 1 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/efivar.c b/drivers/infiniband/hw/hfi1/efivar.c
index 106349f..d106d23 100644
--- a/drivers/infiniband/hw/hfi1/efivar.c
+++ b/drivers/infiniband/hw/hfi1/efivar.c
@@ -45,6 +45,7 @@
  *
  */
 
+#include <linux/ctype.h>
 #include "efivar.h"
 
 /* GUID for HFI1 variables in EFI */
@@ -150,15 +151,32 @@ static int read_efi_var(const char *name, unsigned long *size,
 int read_hfi1_efi_var(struct hfi1_devdata *dd, const char *kind,
 		      unsigned long *size, void **return_data)
 {
+	char prefix_name[64];
 	char name[64];
+	int result;
+	int i;
 
 	/* create a common prefix */
-	snprintf(name, sizeof(name), "%04x:%02x:%02x.%x-%s",
+	snprintf(prefix_name, sizeof(prefix_name), "%04x:%02x:%02x.%x",
 		 pci_domain_nr(dd->pcidev->bus),
 		 dd->pcidev->bus->number,
 		 PCI_SLOT(dd->pcidev->devfn),
-		 PCI_FUNC(dd->pcidev->devfn),
-		 kind);
+		 PCI_FUNC(dd->pcidev->devfn));
+	snprintf(name, sizeof(name), "%s-%s", prefix_name, kind);
+	result = read_efi_var(name, size, return_data);
+
+	/*
+	 * If reading the lowercase EFI variable fail, read the uppercase
+	 * variable.
+	 */
+	if (result) {
+		/* Converting to uppercase */
+		for (i = 0; prefix_name[i]; i++)
+			if (isalpha(prefix_name[i]))
+				prefix_name[i] = toupper(prefix_name[i]);
+		snprintf(name, sizeof(name), "%s-%s", prefix_name, kind);
+		result = read_efi_var(name, size, return_data);
+	}
 
-	return read_efi_var(name, size, return_data);
+	return result;
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
