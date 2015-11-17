From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 12/13] staging/rdma/hfi1: Read EFI variable for device description
Date: Mon, 16 Nov 2015 21:59:34 -0500
Message-ID: <1447729175-28745-13-git-send-email-jubin.john@intel.com>
References: <1447729175-28745-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447729175-28745-1-git-send-email-jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Read an EFI variable for the device description.  Create the
infrastructure for additional variable reads.

Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/Makefile |    2 +-
 drivers/staging/rdma/hfi1/chip.c   |   38 +++++++--
 drivers/staging/rdma/hfi1/efivar.c |  169 ++++++++++++++++++++++++++++++++++++
 drivers/staging/rdma/hfi1/efivar.h |   60 +++++++++++++
 4 files changed, 260 insertions(+), 9 deletions(-)
 create mode 100644 drivers/staging/rdma/hfi1/efivar.c
 create mode 100644 drivers/staging/rdma/hfi1/efivar.h

diff --git a/drivers/staging/rdma/hfi1/Makefile b/drivers/staging/rdma/hfi1/Makefile
index 2e5daa6..68c5a31 100644
--- a/drivers/staging/rdma/hfi1/Makefile
+++ b/drivers/staging/rdma/hfi1/Makefile
@@ -7,7 +7,7 @@
 #
 obj-$(CONFIG_INFINIBAND_HFI1) += hfi1.o
 
-hfi1-y := chip.o cq.o device.o diag.o dma.o driver.o eprom.o file_ops.o firmware.o \
+hfi1-y := chip.o cq.o device.o diag.o dma.o driver.o efivar.o eprom.o file_ops.o firmware.o \
 	init.o intr.o keys.o mad.o mmap.o mr.o pcie.o pio.o pio_copy.o \
 	qp.o qsfp.o rc.o ruc.o sdma.o srq.o sysfs.o trace.o twsi.o \
 	uc.o ud.o user_pages.o user_sdma.o verbs_mcast.o verbs.o
diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 812a3bf..c9a4180 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -63,6 +63,7 @@
 #include "pio.h"
 #include "sdma.h"
 #include "eprom.h"
+#include "efivar.h"
 
 #define NUM_IB_PORTS 1
 
@@ -10547,6 +10548,32 @@ static void asic_should_init(struct hfi1_devdata *dd)
 	spin_unlock_irqrestore(&hfi1_devs_lock, flags);
 }
 
+/*
+ * Set dd->boardname.  Use a generic name if a name is not returned from
+ * EFI variable space.
+ *
+ * Return 0 on success, -ENOMEM if space could not be allocated.
+ */
+static int obtain_boardname(struct hfi1_devdata *dd)
+{
+	/* generic board description */
+	const char generic[] =
+		"Intel Omni-Path Host Fabric Interface Adapter 100 Series";
+	unsigned long size;
+	int ret;
+
+	ret = read_hfi1_efi_var(dd, "description", &size,
+				(void **)&dd->boardname);
+	if (ret) {
+		dd_dev_err(dd, "Board description not found\n");
+		/* use generic description */
+		dd->boardname = kstrdup(generic, GFP_KERNEL);
+		if (!dd->boardname)
+			return -ENOMEM;
+	}
+	return 0;
+}
+
 /**
  * Allocate and initialize the device structure for the hfi.
  * @dev: the pci_dev for hfi1_ib device
@@ -10744,18 +10771,13 @@ struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
 
 	parse_platform_config(dd);
 
-	/* add board names as they are defined */
-	dd->boardname = kmalloc(64, GFP_KERNEL);
-	if (!dd->boardname)
+	ret = obtain_boardname(dd);
+	if (ret)
 		goto bail_cleanup;
-	snprintf(dd->boardname, 64, "Board ID 0x%llx",
-		 dd->revision >> CCE_REVISION_BOARD_ID_LOWER_NIBBLE_SHIFT
-		    & CCE_REVISION_BOARD_ID_LOWER_NIBBLE_MASK);
 
 	snprintf(dd->boardversion, BOARD_VERS_MAX,
-		 "ChipABI %u.%u, %s, ChipRev %u.%u, SW Compat %llu\n",
+		 "ChipABI %u.%u, ChipRev %u.%u, SW Compat %llu\n",
 		 HFI1_CHIP_VERS_MAJ, HFI1_CHIP_VERS_MIN,
-		 dd->boardname,
 		 (u32)dd->majrev,
 		 (u32)dd->minrev,
 		 (dd->revision >> CCE_REVISION_SW_SHIFT)
diff --git a/drivers/staging/rdma/hfi1/efivar.c b/drivers/staging/rdma/hfi1/efivar.c
new file mode 100644
index 0000000..7dc5bae
--- /dev/null
+++ b/drivers/staging/rdma/hfi1/efivar.c
@@ -0,0 +1,169 @@
+/*
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2015 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2015 Intel Corporation.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  - Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  - Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  - Neither the name of Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+
+#include "efivar.h"
+
+/* GUID for HFI1 variables in EFI */
+#define HFI1_EFIVAR_GUID EFI_GUID(0xc50a953e, 0xa8b2, 0x42a6, \
+		0xbf, 0x89, 0xd3, 0x33, 0xa6, 0xe9, 0xe6, 0xd4)
+/* largest EFI data size we expect */
+#define EFI_DATA_SIZE 4096
+
+/*
+ * Read the named EFI variable.  Return the size of the actual data in *size
+ * and a kmalloc'ed buffer in *return_data.  The caller must free the
+ * data.  It is guaranteed that *return_data will be NULL and *size = 0
+ * if this routine fails.
+ *
+ * Return 0 on success, -errno on failure.
+ */
+static int read_efi_var(const char *name, unsigned long *size,
+			void **return_data)
+{
+	efi_status_t status;
+	efi_char16_t *uni_name;
+	efi_guid_t guid;
+	unsigned long temp_size;
+	void *temp_buffer;
+	void *data;
+	int i;
+	int ret;
+
+	/* set failure return values */
+	*size = 0;
+	*return_data = NULL;
+
+	if (!efi_enabled(EFI_RUNTIME_SERVICES))
+		return -EOPNOTSUPP;
+
+	uni_name = kzalloc(sizeof(efi_char16_t) * (strlen(name) + 1),
+			   GFP_KERNEL);
+	temp_buffer = kzalloc(EFI_DATA_SIZE, GFP_KERNEL);
+
+	if (!uni_name || !temp_buffer) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	/* input: the size of the buffer */
+	temp_size = EFI_DATA_SIZE;
+
+	/* convert ASCII to unicode - it is a 1:1 mapping */
+	for (i = 0; name[i]; i++)
+		uni_name[i] = name[i];
+
+	/* need a variable for our GUID */
+	guid = HFI1_EFIVAR_GUID;
+
+	/* call into EFI runtime services */
+	status = efi.get_variable(
+			uni_name,
+			&guid,
+			NULL,
+			&temp_size,
+			temp_buffer);
+
+	/*
+	 * It would be nice to call efi_status_to_err() here, but that
+	 * is in the EFIVAR_FS code and may not be compiled in.
+	 * However, even that is insufficient since it does not cover
+	 * EFI_BUFFER_TOO_SMALL which could be an important return.
+	 * For now, just split out succces or not found.
+	 */
+	ret = status == EFI_SUCCESS   ? 0 :
+	      status == EFI_NOT_FOUND ? -ENOENT :
+					-EINVAL;
+	if (ret)
+		goto fail;
+
+	/*
+	 * We have successfully read the EFI variable into our
+	 * temporary buffer.  Now allocate a correctly sized
+	 * buffer.
+	 */
+	data = kmalloc(temp_size, GFP_KERNEL);
+	if (!data) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	memcpy(data, temp_buffer, temp_size);
+	*size = temp_size;
+	*return_data = data;
+
+fail:
+	kfree(uni_name);
+	kfree(temp_buffer);
+
+	return ret;
+}
+
+/*
+ * Read an HFI1 EFI variable of the form:
+ *	<PCIe address>-<kind>
+ * Return an kalloc'ed array and size of the data.
+ *
+ * Returns 0 on success, -errno on failure.
+ */
+int read_hfi1_efi_var(struct hfi1_devdata *dd, const char *kind,
+		      unsigned long *size, void **return_data)
+{
+	char name[64];
+
+	/* create a common prefix */
+	snprintf(name, sizeof(name), "%04x:%02x:%02x.%x-%s",
+		 pci_domain_nr(dd->pcidev->bus),
+		 dd->pcidev->bus->number,
+		 PCI_SLOT(dd->pcidev->devfn),
+		 PCI_FUNC(dd->pcidev->devfn),
+		 kind);
+
+	return read_efi_var(name, size, return_data);
+}
diff --git a/drivers/staging/rdma/hfi1/efivar.h b/drivers/staging/rdma/hfi1/efivar.h
new file mode 100644
index 0000000..0707062
--- /dev/null
+++ b/drivers/staging/rdma/hfi1/efivar.h
@@ -0,0 +1,60 @@
+/*
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2015 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2015 Intel Corporation.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  - Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  - Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  - Neither the name of Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+#ifndef _HFI1_EFIVAR_H
+#define _HFI1_EFIVAR_H
+
+#include <linux/efi.h>
+
+#include "hfi.h"
+
+int read_hfi1_efi_var(struct hfi1_devdata *dd, const char *kind,
+		      unsigned long *size, void **return_data);
+
+#endif /* _HFI1_EFIVAR_H */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
