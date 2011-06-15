From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 7/9] ib/pma: add include file for IBA performance counters
 definitions
Date: Wed, 15 Jun 2011 17:48:25 +0300
Message-ID: <alpine.LRH.2.00.1106151747390.15844@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1106151733410.15844@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1106151733410.15844-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Move the various definitions and mad structures needed for software
implementation of IBA PM agent from the ipath and qib drivers into
a single include file, which in turn could be used by more consumers.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/hw/ipath/ipath_mad.c |  134 --------------------
 drivers/infiniband/hw/qib/qib_mad.h     |  176 --------------------------
 include/rdma/ib_pma.h                   |  212 ++++++++++++++++++++++++++++++++
 3 files changed, 215 insertions(+), 307 deletions(-)

Index: b/drivers/infiniband/hw/ipath/ipath_mad.c
===================================================================
--- a/drivers/infiniband/hw/ipath/ipath_mad.c
+++ b/drivers/infiniband/hw/ipath/ipath_mad.c
@@ -32,6 +32,7 @@
  */

 #include <rdma/ib_smi.h>
+#include <rdma/ib_pma.h>

 #include "ipath_kernel.h"
 #include "ipath_verbs.h"
@@ -789,139 +790,6 @@ static int recv_subn_set_pkeytable(struc
 	return recv_subn_get_pkeytable(smp, ibdev);
 }

-#define IB_PMA_CLASS_PORT_INFO		cpu_to_be16(0x0001)
-#define IB_PMA_PORT_SAMPLES_CONTROL	cpu_to_be16(0x0010)
-#define IB_PMA_PORT_SAMPLES_RESULT	cpu_to_be16(0x0011)
-#define IB_PMA_PORT_COUNTERS		cpu_to_be16(0x0012)
-#define IB_PMA_PORT_COUNTERS_EXT	cpu_to_be16(0x001D)
-#define IB_PMA_PORT_SAMPLES_RESULT_EXT	cpu_to_be16(0x001E)
-
-struct ib_perf {
-	u8 base_version;
-	u8 mgmt_class;
-	u8 class_version;
-	u8 method;
-	__be16 status;
-	__be16 unused;
-	__be64 tid;
-	__be16 attr_id;
-	__be16 resv;
-	__be32 attr_mod;
-	u8 reserved[40];
-	u8 data[192];
-} __attribute__ ((packed));
-
-struct ib_pma_classportinfo {
-	u8 base_version;
-	u8 class_version;
-	__be16 cap_mask;
-	u8 reserved[3];
-	u8 resp_time_value;	/* only lower 5 bits */
-	union ib_gid redirect_gid;
-	__be32 redirect_tc_sl_fl;	/* 8, 4, 20 bits respectively */
-	__be16 redirect_lid;
-	__be16 redirect_pkey;
-	__be32 redirect_qp;	/* only lower 24 bits */
-	__be32 redirect_qkey;
-	union ib_gid trap_gid;
-	__be32 trap_tc_sl_fl;	/* 8, 4, 20 bits respectively */
-	__be16 trap_lid;
-	__be16 trap_pkey;
-	__be32 trap_hl_qp;	/* 8, 24 bits respectively */
-	__be32 trap_qkey;
-} __attribute__ ((packed));
-
-struct ib_pma_portsamplescontrol {
-	u8 opcode;
-	u8 port_select;
-	u8 tick;
-	u8 counter_width;	/* only lower 3 bits */
-	__be32 counter_mask0_9;	/* 2, 10 * 3, bits */
-	__be16 counter_mask10_14;	/* 1, 5 * 3, bits */
-	u8 sample_mechanisms;
-	u8 sample_status;	/* only lower 2 bits */
-	__be64 option_mask;
-	__be64 vendor_mask;
-	__be32 sample_start;
-	__be32 sample_interval;
-	__be16 tag;
-	__be16 counter_select[15];
-} __attribute__ ((packed));
-
-struct ib_pma_portsamplesresult {
-	__be16 tag;
-	__be16 sample_status;	/* only lower 2 bits */
-	__be32 counter[15];
-} __attribute__ ((packed));
-
-struct ib_pma_portsamplesresult_ext {
-	__be16 tag;
-	__be16 sample_status;	/* only lower 2 bits */
-	__be32 extended_width;	/* only upper 2 bits */
-	__be64 counter[15];
-} __attribute__ ((packed));
-
-struct ib_pma_portcounters {
-	u8 reserved;
-	u8 port_select;
-	__be16 counter_select;
-	__be16 symbol_error_counter;
-	u8 link_error_recovery_counter;
-	u8 link_downed_counter;
-	__be16 port_rcv_errors;
-	__be16 port_rcv_remphys_errors;
-	__be16 port_rcv_switch_relay_errors;
-	__be16 port_xmit_discards;
-	u8 port_xmit_constraint_errors;
-	u8 port_rcv_constraint_errors;
-	u8 reserved1;
-	u8 lli_ebor_errors;	/* 4, 4, bits */
-	__be16 reserved2;
-	__be16 vl15_dropped;
-	__be32 port_xmit_data;
-	__be32 port_rcv_data;
-	__be32 port_xmit_packets;
-	__be32 port_rcv_packets;
-} __attribute__ ((packed));
-
-#define IB_PMA_SEL_SYMBOL_ERROR			cpu_to_be16(0x0001)
-#define IB_PMA_SEL_LINK_ERROR_RECOVERY		cpu_to_be16(0x0002)
-#define IB_PMA_SEL_LINK_DOWNED			cpu_to_be16(0x0004)
-#define IB_PMA_SEL_PORT_RCV_ERRORS		cpu_to_be16(0x0008)
-#define IB_PMA_SEL_PORT_RCV_REMPHYS_ERRORS	cpu_to_be16(0x0010)
-#define IB_PMA_SEL_PORT_XMIT_DISCARDS		cpu_to_be16(0x0040)
-#define IB_PMA_SEL_LOCAL_LINK_INTEGRITY_ERRORS	cpu_to_be16(0x0200)
-#define IB_PMA_SEL_EXCESSIVE_BUFFER_OVERRUNS	cpu_to_be16(0x0400)
-#define IB_PMA_SEL_PORT_VL15_DROPPED		cpu_to_be16(0x0800)
-#define IB_PMA_SEL_PORT_XMIT_DATA		cpu_to_be16(0x1000)
-#define IB_PMA_SEL_PORT_RCV_DATA		cpu_to_be16(0x2000)
-#define IB_PMA_SEL_PORT_XMIT_PACKETS		cpu_to_be16(0x4000)
-#define IB_PMA_SEL_PORT_RCV_PACKETS		cpu_to_be16(0x8000)
-
-struct ib_pma_portcounters_ext {
-	u8 reserved;
-	u8 port_select;
-	__be16 counter_select;
-	__be32 reserved1;
-	__be64 port_xmit_data;
-	__be64 port_rcv_data;
-	__be64 port_xmit_packets;
-	__be64 port_rcv_packets;
-	__be64 port_unicast_xmit_packets;
-	__be64 port_unicast_rcv_packets;
-	__be64 port_multicast_xmit_packets;
-	__be64 port_multicast_rcv_packets;
-} __attribute__ ((packed));
-
-#define IB_PMA_SELX_PORT_XMIT_DATA		cpu_to_be16(0x0001)
-#define IB_PMA_SELX_PORT_RCV_DATA		cpu_to_be16(0x0002)
-#define IB_PMA_SELX_PORT_XMIT_PACKETS		cpu_to_be16(0x0004)
-#define IB_PMA_SELX_PORT_RCV_PACKETS		cpu_to_be16(0x0008)
-#define IB_PMA_SELX_PORT_UNI_XMIT_PACKETS	cpu_to_be16(0x0010)
-#define IB_PMA_SELX_PORT_UNI_RCV_PACKETS	cpu_to_be16(0x0020)
-#define IB_PMA_SELX_PORT_MULTI_XMIT_PACKETS	cpu_to_be16(0x0040)
-#define IB_PMA_SELX_PORT_MULTI_RCV_PACKETS	cpu_to_be16(0x0080)
-
 static int recv_pma_get_classportinfo(struct ib_perf *pmp)
 {
 	struct ib_pma_classportinfo *p =
Index: b/drivers/infiniband/hw/qib/qib_mad.h
===================================================================
--- a/drivers/infiniband/hw/qib/qib_mad.h
+++ b/drivers/infiniband/hw/qib/qib_mad.h
@@ -32,6 +32,8 @@
  * SOFTWARE.
  */

+#include <rdma/ib_pma.h>
+
 #define IB_SMP_UNSUP_VERSION    cpu_to_be16(0x0004)
 #define IB_SMP_UNSUP_METHOD     cpu_to_be16(0x0008)
 #define IB_SMP_UNSUP_METH_ATTR  cpu_to_be16(0x000C)
@@ -180,185 +182,11 @@ struct ib_vl_weight_elem {
 #define IB_VLARB_HIGHPRI_0_31   3
 #define IB_VLARB_HIGHPRI_32_63  4

-/*
- * PMA class portinfo capability mask bits
- */
-#define IB_PMA_CLASS_CAP_ALLPORTSELECT  cpu_to_be16(1 << 8)
-#define IB_PMA_CLASS_CAP_EXT_WIDTH      cpu_to_be16(1 << 9)
-#define IB_PMA_CLASS_CAP_XMIT_WAIT      cpu_to_be16(1 << 12)
-
-#define IB_PMA_CLASS_PORT_INFO          cpu_to_be16(0x0001)
-#define IB_PMA_PORT_SAMPLES_CONTROL     cpu_to_be16(0x0010)
-#define IB_PMA_PORT_SAMPLES_RESULT      cpu_to_be16(0x0011)
-#define IB_PMA_PORT_COUNTERS            cpu_to_be16(0x0012)
-#define IB_PMA_PORT_COUNTERS_EXT        cpu_to_be16(0x001D)
-#define IB_PMA_PORT_SAMPLES_RESULT_EXT  cpu_to_be16(0x001E)
-#define IB_PMA_PORT_COUNTERS_CONG       cpu_to_be16(0xFF00)
-
-struct ib_perf {
-	u8 base_version;
-	u8 mgmt_class;
-	u8 class_version;
-	u8 method;
-	__be16 status;
-	__be16 unused;
-	__be64 tid;
-	__be16 attr_id;
-	__be16 resv;
-	__be32 attr_mod;
-	u8 reserved[40];
-	u8 data[192];
-} __attribute__ ((packed));
-
-struct ib_pma_classportinfo {
-	u8 base_version;
-	u8 class_version;
-	__be16 cap_mask;
-	u8 reserved[3];
-	u8 resp_time_value;     /* only lower 5 bits */
-	union ib_gid redirect_gid;
-	__be32 redirect_tc_sl_fl;       /* 8, 4, 20 bits respectively */
-	__be16 redirect_lid;
-	__be16 redirect_pkey;
-	__be32 redirect_qp;     /* only lower 24 bits */
-	__be32 redirect_qkey;
-	union ib_gid trap_gid;
-	__be32 trap_tc_sl_fl;   /* 8, 4, 20 bits respectively */
-	__be16 trap_lid;
-	__be16 trap_pkey;
-	__be32 trap_hl_qp;      /* 8, 24 bits respectively */
-	__be32 trap_qkey;
-} __attribute__ ((packed));
-
-struct ib_pma_portsamplescontrol {
-	u8 opcode;
-	u8 port_select;
-	u8 tick;
-	u8 counter_width;       /* only lower 3 bits */
-	__be32 counter_mask0_9; /* 2, 10 * 3, bits */
-	__be16 counter_mask10_14;       /* 1, 5 * 3, bits */
-	u8 sample_mechanisms;
-	u8 sample_status;       /* only lower 2 bits */
-	__be64 option_mask;
-	__be64 vendor_mask;
-	__be32 sample_start;
-	__be32 sample_interval;
-	__be16 tag;
-	__be16 counter_select[15];
-} __attribute__ ((packed));
-
-struct ib_pma_portsamplesresult {
-	__be16 tag;
-	__be16 sample_status;   /* only lower 2 bits */
-	__be32 counter[15];
-} __attribute__ ((packed));
-
-struct ib_pma_portsamplesresult_ext {
-	__be16 tag;
-	__be16 sample_status;   /* only lower 2 bits */
-	__be32 extended_width;  /* only upper 2 bits */
-	__be64 counter[15];
-} __attribute__ ((packed));
-
-struct ib_pma_portcounters {
-	u8 reserved;
-	u8 port_select;
-	__be16 counter_select;
-	__be16 symbol_error_counter;
-	u8 link_error_recovery_counter;
-	u8 link_downed_counter;
-	__be16 port_rcv_errors;
-	__be16 port_rcv_remphys_errors;
-	__be16 port_rcv_switch_relay_errors;
-	__be16 port_xmit_discards;
-	u8 port_xmit_constraint_errors;
-	u8 port_rcv_constraint_errors;
-	u8 reserved1;
-	u8 lli_ebor_errors;     /* 4, 4, bits */
-	__be16 reserved2;
-	__be16 vl15_dropped;
-	__be32 port_xmit_data;
-	__be32 port_rcv_data;
-	__be32 port_xmit_packets;
-	__be32 port_rcv_packets;
-} __attribute__ ((packed));
-
-struct ib_pma_portcounters_cong {
-	u8 reserved;
-	u8 reserved1;
-	__be16 port_check_rate;
-	__be16 symbol_error_counter;
-	u8 link_error_recovery_counter;
-	u8 link_downed_counter;
-	__be16 port_rcv_errors;
-	__be16 port_rcv_remphys_errors;
-	__be16 port_rcv_switch_relay_errors;
-	__be16 port_xmit_discards;
-	u8 port_xmit_constraint_errors;
-	u8 port_rcv_constraint_errors;
-	u8 reserved2;
-	u8 lli_ebor_errors;    /* 4, 4, bits */
-	__be16 reserved3;
-	__be16 vl15_dropped;
-	__be64 port_xmit_data;
-	__be64 port_rcv_data;
-	__be64 port_xmit_packets;
-	__be64 port_rcv_packets;
-	__be64 port_xmit_wait;
-	__be64 port_adr_events;
-} __attribute__ ((packed));
-
-#define IB_PMA_CONG_HW_CONTROL_TIMER            0x00
-#define IB_PMA_CONG_HW_CONTROL_SAMPLE           0x01
-
 #define QIB_XMIT_RATE_UNSUPPORTED               0x0
 #define QIB_XMIT_RATE_PICO                      0x7
 /* number of 4nsec cycles equaling 2secs */
 #define QIB_CONG_TIMER_PSINTERVAL               0x1DCD64EC

-#define IB_PMA_SEL_SYMBOL_ERROR                 cpu_to_be16(0x0001)
-#define IB_PMA_SEL_LINK_ERROR_RECOVERY          cpu_to_be16(0x0002)
-#define IB_PMA_SEL_LINK_DOWNED                  cpu_to_be16(0x0004)
-#define IB_PMA_SEL_PORT_RCV_ERRORS              cpu_to_be16(0x0008)
-#define IB_PMA_SEL_PORT_RCV_REMPHYS_ERRORS      cpu_to_be16(0x0010)
-#define IB_PMA_SEL_PORT_XMIT_DISCARDS           cpu_to_be16(0x0040)
-#define IB_PMA_SEL_LOCAL_LINK_INTEGRITY_ERRORS  cpu_to_be16(0x0200)
-#define IB_PMA_SEL_EXCESSIVE_BUFFER_OVERRUNS    cpu_to_be16(0x0400)
-#define IB_PMA_SEL_PORT_VL15_DROPPED            cpu_to_be16(0x0800)
-#define IB_PMA_SEL_PORT_XMIT_DATA               cpu_to_be16(0x1000)
-#define IB_PMA_SEL_PORT_RCV_DATA                cpu_to_be16(0x2000)
-#define IB_PMA_SEL_PORT_XMIT_PACKETS            cpu_to_be16(0x4000)
-#define IB_PMA_SEL_PORT_RCV_PACKETS             cpu_to_be16(0x8000)
-
-#define IB_PMA_SEL_CONG_ALL                     0x01
-#define IB_PMA_SEL_CONG_PORT_DATA               0x02
-#define IB_PMA_SEL_CONG_XMIT                    0x04
-#define IB_PMA_SEL_CONG_ROUTING                 0x08
-
-struct ib_pma_portcounters_ext {
-	u8 reserved;
-	u8 port_select;
-	__be16 counter_select;
-	__be32 reserved1;
-	__be64 port_xmit_data;
-	__be64 port_rcv_data;
-	__be64 port_xmit_packets;
-	__be64 port_rcv_packets;
-	__be64 port_unicast_xmit_packets;
-	__be64 port_unicast_rcv_packets;
-	__be64 port_multicast_xmit_packets;
-	__be64 port_multicast_rcv_packets;
-} __attribute__ ((packed));
-
-#define IB_PMA_SELX_PORT_XMIT_DATA              cpu_to_be16(0x0001)
-#define IB_PMA_SELX_PORT_RCV_DATA               cpu_to_be16(0x0002)
-#define IB_PMA_SELX_PORT_XMIT_PACKETS           cpu_to_be16(0x0004)
-#define IB_PMA_SELX_PORT_RCV_PACKETS            cpu_to_be16(0x0008)
-#define IB_PMA_SELX_PORT_UNI_XMIT_PACKETS       cpu_to_be16(0x0010)
-#define IB_PMA_SELX_PORT_UNI_RCV_PACKETS        cpu_to_be16(0x0020)
-#define IB_PMA_SELX_PORT_MULTI_XMIT_PACKETS     cpu_to_be16(0x0040)
-#define IB_PMA_SELX_PORT_MULTI_RCV_PACKETS      cpu_to_be16(0x0080)
-
 /*
  * The PortSamplesControl.CounterMasks field is an array of 3 bit fields
  * which specify the N'th counter's capabilities. See ch. 16.1.3.2.
Index: b/include/rdma/ib_pma.h
===================================================================
--- /dev/null
+++ b/include/rdma/ib_pma.h
@@ -0,0 +1,212 @@
+/*
+ * Copyright (c) 2006, 2007, 2008, 2009, 2010 QLogic Corporation.
+ * All rights reserved.
+ * Copyright (c) 2005, 2006 PathScale, Inc. All rights reserved.
+ *
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
+ */
+
+#if !defined(IB_PMA_H)
+#define IB_PMA_H
+
+/*
+ * PMA class portinfo capability mask bits
+ */
+#define IB_PMA_CLASS_CAP_ALLPORTSELECT  cpu_to_be16(1 << 8)
+#define IB_PMA_CLASS_CAP_EXT_WIDTH      cpu_to_be16(1 << 9)
+#define IB_PMA_CLASS_CAP_XMIT_WAIT      cpu_to_be16(1 << 12)
+
+#define IB_PMA_CLASS_PORT_INFO          cpu_to_be16(0x0001)
+#define IB_PMA_PORT_SAMPLES_CONTROL     cpu_to_be16(0x0010)
+#define IB_PMA_PORT_SAMPLES_RESULT      cpu_to_be16(0x0011)
+#define IB_PMA_PORT_COUNTERS            cpu_to_be16(0x0012)
+#define IB_PMA_PORT_COUNTERS_EXT        cpu_to_be16(0x001D)
+#define IB_PMA_PORT_SAMPLES_RESULT_EXT  cpu_to_be16(0x001E)
+#define IB_PMA_PORT_COUNTERS_CONG       cpu_to_be16(0xFF00)
+
+struct ib_perf {
+	u8 base_version;
+	u8 mgmt_class;
+	u8 class_version;
+	u8 method;
+	__be16 status;
+	__be16 unused;
+	__be64 tid;
+	__be16 attr_id;
+	__be16 resv;
+	__be32 attr_mod;
+	u8 reserved[40];
+	u8 data[192];
+} __attribute__ ((packed));
+
+struct ib_pma_classportinfo {
+	u8 base_version;
+	u8 class_version;
+	__be16 cap_mask;
+	u8 reserved[3];
+	u8 resp_time_value;     /* only lower 5 bits */
+	union ib_gid redirect_gid;
+	__be32 redirect_tc_sl_fl;       /* 8, 4, 20 bits respectively */
+	__be16 redirect_lid;
+	__be16 redirect_pkey;
+	__be32 redirect_qp;     /* only lower 24 bits */
+	__be32 redirect_qkey;
+	union ib_gid trap_gid;
+	__be32 trap_tc_sl_fl;   /* 8, 4, 20 bits respectively */
+	__be16 trap_lid;
+	__be16 trap_pkey;
+	__be32 trap_hl_qp;      /* 8, 24 bits respectively */
+	__be32 trap_qkey;
+} __attribute__ ((packed));
+
+struct ib_pma_portsamplescontrol {
+	u8 opcode;
+	u8 port_select;
+	u8 tick;
+	u8 counter_width;       /* only lower 3 bits */
+	__be32 counter_mask0_9; /* 2, 10 * 3, bits */
+	__be16 counter_mask10_14;       /* 1, 5 * 3, bits */
+	u8 sample_mechanisms;
+	u8 sample_status;       /* only lower 2 bits */
+	__be64 option_mask;
+	__be64 vendor_mask;
+	__be32 sample_start;
+	__be32 sample_interval;
+	__be16 tag;
+	__be16 counter_select[15];
+} __attribute__ ((packed));
+
+struct ib_pma_portsamplesresult {
+	__be16 tag;
+	__be16 sample_status;   /* only lower 2 bits */
+	__be32 counter[15];
+} __attribute__ ((packed));
+
+struct ib_pma_portsamplesresult_ext {
+	__be16 tag;
+	__be16 sample_status;   /* only lower 2 bits */
+	__be32 extended_width;  /* only upper 2 bits */
+	__be64 counter[15];
+} __attribute__ ((packed));
+
+struct ib_pma_portcounters {
+	u8 reserved;
+	u8 port_select;
+	__be16 counter_select;
+	__be16 symbol_error_counter;
+	u8 link_error_recovery_counter;
+	u8 link_downed_counter;
+	__be16 port_rcv_errors;
+	__be16 port_rcv_remphys_errors;
+	__be16 port_rcv_switch_relay_errors;
+	__be16 port_xmit_discards;
+	u8 port_xmit_constraint_errors;
+	u8 port_rcv_constraint_errors;
+	u8 reserved1;
+	u8 lli_ebor_errors;     /* 4, 4, bits */
+	__be16 reserved2;
+	__be16 vl15_dropped;
+	__be32 port_xmit_data;
+	__be32 port_rcv_data;
+	__be32 port_xmit_packets;
+	__be32 port_rcv_packets;
+} __attribute__ ((packed));
+
+struct ib_pma_portcounters_cong {
+	u8 reserved;
+	u8 reserved1;
+	__be16 port_check_rate;
+	__be16 symbol_error_counter;
+	u8 link_error_recovery_counter;
+	u8 link_downed_counter;
+	__be16 port_rcv_errors;
+	__be16 port_rcv_remphys_errors;
+	__be16 port_rcv_switch_relay_errors;
+	__be16 port_xmit_discards;
+	u8 port_xmit_constraint_errors;
+	u8 port_rcv_constraint_errors;
+	u8 reserved2;
+	u8 lli_ebor_errors;    /* 4, 4, bits */
+	__be16 reserved3;
+	__be16 vl15_dropped;
+	__be64 port_xmit_data;
+	__be64 port_rcv_data;
+	__be64 port_xmit_packets;
+	__be64 port_rcv_packets;
+	__be64 port_xmit_wait;
+	__be64 port_adr_events;
+} __attribute__ ((packed));
+
+#define IB_PMA_CONG_HW_CONTROL_TIMER            0x00
+#define IB_PMA_CONG_HW_CONTROL_SAMPLE           0x01
+
+#define IB_PMA_SEL_SYMBOL_ERROR                 cpu_to_be16(0x0001)
+#define IB_PMA_SEL_LINK_ERROR_RECOVERY          cpu_to_be16(0x0002)
+#define IB_PMA_SEL_LINK_DOWNED                  cpu_to_be16(0x0004)
+#define IB_PMA_SEL_PORT_RCV_ERRORS              cpu_to_be16(0x0008)
+#define IB_PMA_SEL_PORT_RCV_REMPHYS_ERRORS      cpu_to_be16(0x0010)
+#define IB_PMA_SEL_PORT_XMIT_DISCARDS           cpu_to_be16(0x0040)
+#define IB_PMA_SEL_LOCAL_LINK_INTEGRITY_ERRORS  cpu_to_be16(0x0200)
+#define IB_PMA_SEL_EXCESSIVE_BUFFER_OVERRUNS    cpu_to_be16(0x0400)
+#define IB_PMA_SEL_PORT_VL15_DROPPED            cpu_to_be16(0x0800)
+#define IB_PMA_SEL_PORT_XMIT_DATA               cpu_to_be16(0x1000)
+#define IB_PMA_SEL_PORT_RCV_DATA                cpu_to_be16(0x2000)
+#define IB_PMA_SEL_PORT_XMIT_PACKETS            cpu_to_be16(0x4000)
+#define IB_PMA_SEL_PORT_RCV_PACKETS             cpu_to_be16(0x8000)
+
+#define IB_PMA_SEL_CONG_ALL                     0x01
+#define IB_PMA_SEL_CONG_PORT_DATA               0x02
+#define IB_PMA_SEL_CONG_XMIT                    0x04
+#define IB_PMA_SEL_CONG_ROUTING                 0x08
+
+struct ib_pma_portcounters_ext {
+	u8 reserved;
+	u8 port_select;
+	__be16 counter_select;
+	__be32 reserved1;
+	__be64 port_xmit_data;
+	__be64 port_rcv_data;
+	__be64 port_xmit_packets;
+	__be64 port_rcv_packets;
+	__be64 port_unicast_xmit_packets;
+	__be64 port_unicast_rcv_packets;
+	__be64 port_multicast_xmit_packets;
+	__be64 port_multicast_rcv_packets;
+} __attribute__ ((packed));
+
+#define IB_PMA_SELX_PORT_XMIT_DATA              cpu_to_be16(0x0001)
+#define IB_PMA_SELX_PORT_RCV_DATA               cpu_to_be16(0x0002)
+#define IB_PMA_SELX_PORT_XMIT_PACKETS           cpu_to_be16(0x0004)
+#define IB_PMA_SELX_PORT_RCV_PACKETS            cpu_to_be16(0x0008)
+#define IB_PMA_SELX_PORT_UNI_XMIT_PACKETS       cpu_to_be16(0x0010)
+#define IB_PMA_SELX_PORT_UNI_RCV_PACKETS        cpu_to_be16(0x0020)
+#define IB_PMA_SELX_PORT_MULTI_XMIT_PACKETS     cpu_to_be16(0x0040)
+#define IB_PMA_SELX_PORT_MULTI_RCV_PACKETS      cpu_to_be16(0x0080)
+
+#endif /* IB_PMA_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
