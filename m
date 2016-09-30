From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 1/4] libcxgb4: align header files with upstream kernel
Date: Fri, 30 Sep 2016 09:10:56 -0700
Message-ID: <935f67980b951a356034c2f8d17f5fd22aa76630.1475253317.git.swise@opengridcomputing.com>
References: <cover.1475253317.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1475253317.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Align these files with the upstream kernel:
t4_chip_type.h
t4_pci_id_tbl.h

This also fixes the incorrect copyright headers in the libcxb4 versions
of these files.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 libcxgb4/src/dev.c           |   2 +-
 libcxgb4/src/t4_chip_type.h  |  98 +++++++++++----------------------
 libcxgb4/src/t4_pci_id_tbl.h | 127 +++++++++++++++++--------------------------
 3 files changed, 82 insertions(+), 145 deletions(-)

diff --git a/libcxgb4/src/dev.c b/libcxgb4/src/dev.c
index 8c3ecdd..284238d 100644
--- a/libcxgb4/src/dev.c
+++ b/libcxgb4/src/dev.c
@@ -473,7 +473,7 @@ found:
 
 	pthread_spin_init(&dev->lock, PTHREAD_PROCESS_PRIVATE);
 	dev->ibv_dev.ops = c4iw_dev_ops;
-	dev->chip_version = CHELSIO_PCI_ID_CHIP_VERSION(hca_table[i].device);
+	dev->chip_version = CHELSIO_CHIP_VERSION(hca_table[i].device >> 8);
 	dev->abi_version = abi_version;
 
 	PDBG("%s device claimed\n", __FUNCTION__);
diff --git a/libcxgb4/src/t4_chip_type.h b/libcxgb4/src/t4_chip_type.h
index 59c4a24..54b7181 100644
--- a/libcxgb4/src/t4_chip_type.h
+++ b/libcxgb4/src/t4_chip_type.h
@@ -1,83 +1,53 @@
 /*
- * This file is part of the Chelsio T4/T5/T6 Ethernet driver.
+ * This file is part of the Chelsio T4 Ethernet driver for Linux.
  *
- * Copyright (C) 2003-2016 Chelsio Communications.  All rights reserved.
+ * Copyright (c) 2003-2015 Chelsio Communications, Inc. All rights reserved.
  *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the LICENSE file included in this
- * release for licensing terms and conditions.
- */
-#ifndef __T4_CHIP_TYPE_H__
-#define __T4_CHIP_TYPE_H__
-
-/*
- * All T4 and later chips have their PCI-E Device IDs encoded as 0xVFPP where:
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
  *
- *   V  = "4" for T4; "5" for T5, etc. or
- *      = "a" for T4 FPGA; "b" for T4 FPGA, etc.
- *   F  = "0" for PF 0..3; "4".."7" for PF4..7; and "8" for VFs
- *   PP = adapter product designation
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
  *
- * We use the "version" (V) of the adpater to code the Chip Version above
- * but separate out the FPGA as a separate boolean as per above.
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
  */
-#define CHELSIO_PCI_ID_VER(__DeviceID)	((__DeviceID) >> 12)
-#define CHELSIO_PCI_ID_FUNC(__DeviceID)	(((__DeviceID) >> 8) & 0xf)
-#define CHELSIO_PCI_ID_PROD(__DeviceID)	((__DeviceID) & 0xff)
+#ifndef __T4_CHIP_TYPE_H__
+#define __T4_CHIP_TYPE_H__
 
 #define CHELSIO_T4		0x4
-#define CHELSIO_T4_FPGA		0xa
 #define CHELSIO_T5		0x5
-#define CHELSIO_T5_FPGA		0xb
 #define CHELSIO_T6		0x6
-#define CHELSIO_T6_FPGA		0xc
 
-/*
- * Translate a PCI Device ID to a base Chelsio Chip Version -- CHELSIO_T4,
- * CHELSIO_T5, etc.  If it weren't for the screwed up numbering of the FPGAs
- * we could do this simply as DeviceID >> 12 (because we know the real
- * encoding oc CHELSIO_Tx identifiers).  However, the FPGAs _do_ have weird
- * Device IDs so we need to do this translation here.  Note that only constant
- * arithmetic and comparisons can be done here since this is being used to
- * initialize static tables, etc.
+/* We code the Chelsio T4 Family "Chip Code" as a tuple:
  *
- * Finally: This will of course need to be expanded as future chips are
- * developed.
- */
-static inline unsigned int
-CHELSIO_PCI_ID_CHIP_VERSION(unsigned int DeviceID)
-{
-	switch (CHELSIO_PCI_ID_VER(DeviceID)) {
-	case CHELSIO_T4:
-	case CHELSIO_T4_FPGA:
-	return CHELSIO_T4;
-
-	case CHELSIO_T5:
-	case CHELSIO_T5_FPGA:
-	return CHELSIO_T5;
-
-	case CHELSIO_T6:
-	case CHELSIO_T6_FPGA:
-	return CHELSIO_T6;
-	}
-
-	return 0;
-}
-
-/*
- * Internally we code the Chelsio T4 Family "Chip Code" as a tuple:
- *
- *     (Is FPGA, Chip Version, Chip Revision)
+ *     (Chip Version, Chip Revision)
  *
  * where:
  *
- *     Is FPGA: is 0/1 indicating whether we're working with an FPGA
  *     Chip Version: is T4, T5, etc.
  *     Chip Revision: is the FAB "spin" of the Chip Version.
  */
 #define CHELSIO_CHIP_CODE(version, revision) (((version) << 4) | (revision))
-#define CHELSIO_CHIP_FPGA          0x100
 #define CHELSIO_CHIP_VERSION(code) (((code) >> 4) & 0xf)
 #define CHELSIO_CHIP_RELEASE(code) ((code) & 0xf)
 
@@ -104,7 +74,6 @@ static inline int is_t4(enum chip_type chip)
 
 static inline int is_t5(enum chip_type chip)
 {
-
 	return (CHELSIO_CHIP_VERSION(chip) == CHELSIO_T5);
 }
 
@@ -113,9 +82,4 @@ static inline int is_t6(enum chip_type chip)
 	return (CHELSIO_CHIP_VERSION(chip) == CHELSIO_T6);
 }
 
-static inline int is_fpga(enum chip_type chip)
-{
-	 return chip & CHELSIO_CHIP_FPGA;
-}
-
 #endif /* __T4_CHIP_TYPE_H__ */
diff --git a/libcxgb4/src/t4_pci_id_tbl.h b/libcxgb4/src/t4_pci_id_tbl.h
index 21c0990..50812a1 100644
--- a/libcxgb4/src/t4_pci_id_tbl.h
+++ b/libcxgb4/src/t4_pci_id_tbl.h
@@ -1,21 +1,41 @@
 /*
- * This file is part of the Chelsio T4/T5/T6 Ethernet driver.
+ * This file is part of the Chelsio T4/T5 Ethernet driver for Linux.
  *
- * Copyright (C) 2003-2016 Chelsio Communications.  All rights reserved.
+ * Copyright (c) 2003-2014 Chelsio Communications, Inc. All rights reserved.
  *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the LICENSE file included in this
- * release for licensing terms and conditions.
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
  */
 #ifndef __T4_PCI_ID_TBL_H__
 #define __T4_PCI_ID_TBL_H__
 
-/*
- * The Os-Dependent code can defined cpp macros for creating a PCI Device ID
- * Table.  This is useful because it allows the PCI ID Table to be maintained
- * in a single place and all supporting OSes to get new PCI Device IDs
- * automatically.
+/* The code can defined cpp macros for creating a PCI Device ID Table. This is
+ * useful because it allows the PCI ID Table to be maintained in a single place.
  *
  * The macros are:
  *
@@ -39,14 +59,6 @@
  * CH_PCI_DEVICE_ID_TABLE_DEFINE_END
  *   -- Used to finish the definition of the PCI ID Table.  Note that we
  *   -- will be adding a trailing semi-colon (";") here.
- *
- * CH_PCI_DEVICE_ID_BYPASS_SUPPORTED [optional]
- *   -- If defined, indicates that the OS Driver has support for Bypass
- *   -- Adapters.
- */
-
-/*
- * Some sanity checks ...
  */
 #ifndef CH_PCI_DEVICE_ID_FUNCTION
 #error CH_PCI_DEVICE_ID_FUNCTION not defined!
@@ -58,8 +70,7 @@
 #error CH_PCI_DEVICE_ID_TABLE_DEFINE_END not defined!
 #endif
 
-/*
- * T4 and later ASICs use a PCI Device ID scheme of 0xVFPP where:
+/* T4 and later ASICs use a PCI Device ID scheme of 0xVFPP where:
  *
  *   V  = "4" for T4; "5" for T5, etc.
  *   F  = "0" for PF 0..3; "4".."7" for PF4..7; and "8" for VFs
@@ -69,52 +80,19 @@
  * for the specified CH_PCI_DEVICE_ID_FUNCTION.
  */
 #ifndef CH_PCI_DEVICE_ID_FUNCTION2
-#define CH_PCI_ID_TABLE_FENTRY(__DeviceID) \
-	CH_PCI_ID_TABLE_ENTRY((__DeviceID) | \
+#define CH_PCI_ID_TABLE_FENTRY(devid) \
+	CH_PCI_ID_TABLE_ENTRY((devid) | \
 			      ((CH_PCI_DEVICE_ID_FUNCTION) << 8))
 #else
-#define CH_PCI_ID_TABLE_FENTRY(__DeviceID) \
-	CH_PCI_ID_TABLE_ENTRY((__DeviceID) | \
+#define CH_PCI_ID_TABLE_FENTRY(devid) \
+	CH_PCI_ID_TABLE_ENTRY((devid) | \
 			      ((CH_PCI_DEVICE_ID_FUNCTION) << 8)), \
-	CH_PCI_ID_TABLE_ENTRY((__DeviceID) | \
+	CH_PCI_ID_TABLE_ENTRY((devid) | \
 			      ((CH_PCI_DEVICE_ID_FUNCTION2) << 8))
 #endif
 
-/* Note : The comments against each entry are used by the scripts in the vmware drivers
- * to correctly generate the pciid xml file, do not change the format currently used.
- */
-
 CH_PCI_DEVICE_ID_TABLE_DEFINE_BEGIN
-	/*
-	 * FPGAs:
-	 *
-	 * Unfortunately the FPGA PCI Device IDs don't follow the ASIC PCI
-	 * Device ID numbering convetions for the Physical Functions.
-	 */
-#if CH_PCI_DEVICE_ID_FUNCTION != 8
-	CH_PCI_ID_TABLE_ENTRY(0xa000),	/* PE10K FPGA */
-	CH_PCI_ID_TABLE_ENTRY(0xb000),	/* PF0 T5 PE10K5 FPGA */
-	CH_PCI_ID_TABLE_ENTRY(0xb001),	/* PF0 T5 PE10K FPGA */
-	CH_PCI_ID_TABLE_ENTRY(0xc006),  /* PF0 T6 PE10K6 FPGA */
-#else
-	CH_PCI_ID_TABLE_FENTRY(0xa000),	/* PE10K FPGA */
-	CH_PCI_ID_TABLE_FENTRY(0xb000),	/* PF0 T5 PE10K5 FPGA */
-	CH_PCI_ID_TABLE_FENTRY(0xb001),	/* PF0 T5 PE10K FPGA */
-	CH_PCI_ID_TABLE_FENTRY(0xc006), /* PF0 T6 PE10K6 FPGA */
-	CH_PCI_ID_TABLE_FENTRY(0xc106),  /* PF1 T6 PE10K6 FPGA */
-#endif
-
-	/*
-	 *  These FPGAs seem to be used only by the csiostor driver
-	 */
-#if ((CH_PCI_DEVICE_ID_FUNCTION == 5) || (CH_PCI_DEVICE_ID_FUNCTION == 6))
-	CH_PCI_ID_TABLE_ENTRY(0xa001),	/* PF1 PE10K FPGA FCOE */
-	CH_PCI_ID_TABLE_ENTRY(0xa002),	/* PE10K FPGA iSCSI */
-	CH_PCI_ID_TABLE_ENTRY(0xc106),  /* PF1 T6 PE10K6 FPGA */
-#endif
-
-	/*
-	 * T4 adapters:
+	/* T4 adapters:
 	 */
 	CH_PCI_ID_TABLE_FENTRY(0x4000),	/* T440-dbg */
 	CH_PCI_ID_TABLE_FENTRY(0x4001),	/* T420-cr */
@@ -127,10 +105,8 @@ CH_PCI_DEVICE_ID_TABLE_DEFINE_BEGIN
 	CH_PCI_ID_TABLE_FENTRY(0x4008),	/* T420-cx */
 	CH_PCI_ID_TABLE_FENTRY(0x4009),	/* T420-bt */
 	CH_PCI_ID_TABLE_FENTRY(0x400a),	/* T404-bt */
-#ifdef CH_PCI_DEVICE_ID_BYPASS_SUPPORTED
 	CH_PCI_ID_TABLE_FENTRY(0x400b),	/* B420-sr */
 	CH_PCI_ID_TABLE_FENTRY(0x400c),	/* B404-bt */
-#endif
 	CH_PCI_ID_TABLE_FENTRY(0x400d),	/* T480-cr */
 	CH_PCI_ID_TABLE_FENTRY(0x400e),	/* T440-LP-cr */
 	CH_PCI_ID_TABLE_FENTRY(0x4080),	/* Custom T480-cr */
@@ -143,8 +119,7 @@ CH_PCI_DEVICE_ID_TABLE_DEFINE_BEGIN
 	CH_PCI_ID_TABLE_FENTRY(0x4087),	/* Custom T440-cr */
 	CH_PCI_ID_TABLE_FENTRY(0x4088),	/* Custom T440 2-xaui, 2-xfi */
 
-	/*
-	 * T5 adapters:
+	/* T5 adapters:
 	 */
 	CH_PCI_ID_TABLE_FENTRY(0x5000),	/* T580-dbg */
 	CH_PCI_ID_TABLE_FENTRY(0x5001),	/* T520-cr */
@@ -157,10 +132,8 @@ CH_PCI_DEVICE_ID_TABLE_DEFINE_BEGIN
 	CH_PCI_ID_TABLE_FENTRY(0x5008),	/* T520-cx */
 	CH_PCI_ID_TABLE_FENTRY(0x5009),	/* T520-bt */
 	CH_PCI_ID_TABLE_FENTRY(0x500a),	/* T504-bt */
-#ifdef CH_PCI_DEVICE_ID_BYPASS_SUPPORTED
 	CH_PCI_ID_TABLE_FENTRY(0x500b),	/* B520-sr */
 	CH_PCI_ID_TABLE_FENTRY(0x500c),	/* B504-bt */
-#endif
 	CH_PCI_ID_TABLE_FENTRY(0x500d),	/* T580-cr */
 	CH_PCI_ID_TABLE_FENTRY(0x500e),	/* T540-LP-cr */
 	CH_PCI_ID_TABLE_FENTRY(0x5010),	/* T580-LP-cr */
@@ -175,7 +148,7 @@ CH_PCI_DEVICE_ID_TABLE_DEFINE_BEGIN
 	CH_PCI_ID_TABLE_FENTRY(0x5080),	/* Custom T540-cr */
 	CH_PCI_ID_TABLE_FENTRY(0x5081),	/* Custom T540-LL-cr */
 	CH_PCI_ID_TABLE_FENTRY(0x5082),	/* Custom T504-cr */
-	CH_PCI_ID_TABLE_FENTRY(0x5083),	/* Custom T540-CR */
+	CH_PCI_ID_TABLE_FENTRY(0x5083),	/* Custom T540-LP-CR */
 	CH_PCI_ID_TABLE_FENTRY(0x5084),	/* Custom T580-cr */
 	CH_PCI_ID_TABLE_FENTRY(0x5085),	/* Custom 3x T580-CR */
 	CH_PCI_ID_TABLE_FENTRY(0x5086),	/* Custom 2x T580-CR */
@@ -185,18 +158,19 @@ CH_PCI_DEVICE_ID_TABLE_DEFINE_BEGIN
 	CH_PCI_ID_TABLE_FENTRY(0x5090),	/* Custom T540-CR */
 	CH_PCI_ID_TABLE_FENTRY(0x5091),	/* Custom T522-CR */
 	CH_PCI_ID_TABLE_FENTRY(0x5092),	/* Custom T520-CR */
-	CH_PCI_ID_TABLE_FENTRY(0x5093),	/* Custom SECA */
+	CH_PCI_ID_TABLE_FENTRY(0x5093),	/* Custom T580-LP-CR */
 	CH_PCI_ID_TABLE_FENTRY(0x5094),	/* Custom T540-CR */
 	CH_PCI_ID_TABLE_FENTRY(0x5095),	/* Custom T540-CR-SO */
-	CH_PCI_ID_TABLE_FENTRY(0x5096), /* Custom T580-CR */
-	CH_PCI_ID_TABLE_FENTRY(0x5097), /* Custom T520-KR */
-	CH_PCI_ID_TABLE_FENTRY(0x5098), /* Custom 2x40G QSFP */
-	CH_PCI_ID_TABLE_FENTRY(0x5099), /* Custom 2x40G QSFP */
-	CH_PCI_ID_TABLE_FENTRY(0x509A), /* Custom T520-CR */
-	CH_PCI_ID_TABLE_FENTRY(0x509B), /* Custom T540-CR LOM */
-	CH_PCI_ID_TABLE_FENTRY(0x509B), /* Custom T520 SFP+ LOM */
+	CH_PCI_ID_TABLE_FENTRY(0x5096),	/* Custom T580-CR */
+	CH_PCI_ID_TABLE_FENTRY(0x5097),	/* Custom T520-KR */
+	CH_PCI_ID_TABLE_FENTRY(0x5098),	/* Custom 2x40G QSFP */
+	CH_PCI_ID_TABLE_FENTRY(0x5099),	/* Custom 2x40G QSFP */
+	CH_PCI_ID_TABLE_FENTRY(0x509a),	/* Custom T520-CR */
+	CH_PCI_ID_TABLE_FENTRY(0x509b),	/* Custom T540-CR LOM */
+	CH_PCI_ID_TABLE_FENTRY(0x509c),	/* Custom T520-CR*/
 
-	/* T6 adapter */
+	/* T6 adapters:
+	 */
 	CH_PCI_ID_TABLE_FENTRY(0x6001),
 	CH_PCI_ID_TABLE_FENTRY(0x6002),
 	CH_PCI_ID_TABLE_FENTRY(0x6003),
@@ -204,7 +178,6 @@ CH_PCI_DEVICE_ID_TABLE_DEFINE_BEGIN
 	CH_PCI_ID_TABLE_FENTRY(0x6005),
 	CH_PCI_ID_TABLE_FENTRY(0x6006),
 	CH_PCI_ID_TABLE_FENTRY(0x6007),
-	CH_PCI_ID_TABLE_FENTRY(0x6008),
 	CH_PCI_ID_TABLE_FENTRY(0x6009),
 	CH_PCI_ID_TABLE_FENTRY(0x600d),
 	CH_PCI_ID_TABLE_FENTRY(0x6010),
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
