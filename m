From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 7/9] ib/pma: add include file for IBA performance counters
 definitions
Date: Thu, 16 Jun 2011 11:20:34 +0300
Message-ID: <alpine.LRH.2.00.1106161119120.12552@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1106151733410.15844@ogerlitz.voltaire.com> <alpine.LRH.2.00.1106151747390.15844@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1106151747390.15844-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Move the various definitions and mad structures needed for software
implementation of IBA PM agent from the ipath and qib drivers into
a single include file, which in turn could be used by more consumers.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---

changes from V0 - applied feedback from Sean and Hal

 - renamed struct ib_perf to be ib_pma_mad which now starts with struct ib_mad_hdr
 - removed struct ib_pma_classportinfo, use struct ib_class_port_info from ib_mad.h
 - clarified comments for bit fields, adding missing fields for ib_pma_portsamplescontrol
 - removed packing from struct ib_pma_portsamples{control, result, result_ext}
 - changed struct ib_pma_portcounters :: lli_ebor_errors to be link_overrun_errors
 - added xmit wait to struct ib_pma_portcounters
 - left proprietary defs in the qib code

 drivers/infiniband/hw/ipath/ipath_mad.c |  198 +++++---------------------------
 drivers/infiniband/hw/qib/qib_mad.h     |  151 ------------------------
 include/rdma/ib_pma.h                   |  164 ++++++++++++++++++++++++++
 3 files changed, 200 insertions(+), 313 deletions(-)

Index: linux-2.6.39-rc/drivers/infiniband/hw/ipath/ipath_mad.c
===================================================================
--- linux-2.6.39-rc.orig/drivers/infiniband/hw/ipath/ipath_mad.c
+++ linux-2.6.39-rc/drivers/infiniband/hw/ipath/ipath_mad.c
@@ -32,6 +32,7 @@
  */

 #include <rdma/ib_smi.h>
+#include <rdma/ib_pma.h>

 #include "ipath_kernel.h"
 #include "ipath_verbs.h"
@@ -789,151 +790,18 @@ static int recv_subn_set_pkeytable(struc
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
-static int recv_pma_get_classportinfo(struct ib_perf *pmp)
+static int recv_pma_get_classportinfo(struct ib_pma_mad *pmp)
 {
-	struct ib_pma_classportinfo *p =
-		(struct ib_pma_classportinfo *)pmp->data;
+	struct ib_class_port_info *p =
+		(struct ib_class_port_info *)pmp->data;

 	memset(pmp->data, 0, sizeof(pmp->data));

-	if (pmp->attr_mod != 0)
-		pmp->status |= IB_SMP_INVALID_FIELD;
+	if (pmp->mad_hdr.attr_mod != 0)
+		pmp->mad_hdr.status |= IB_SMP_INVALID_FIELD;

 	/* Indicate AllPortSelect is valid (only one port anyway) */
-	p->cap_mask = cpu_to_be16(1 << 8);
+	p->capability_mask = cpu_to_be16(1 << 8);
 	p->base_version = 1;
 	p->class_version = 1;
 	/*
@@ -957,7 +825,7 @@ static int recv_pma_get_classportinfo(st
 				    COUNTER_MASK(1, 3) | \
 				    COUNTER_MASK(1, 4))

-static int recv_pma_get_portsamplescontrol(struct ib_perf *pmp,
+static int recv_pma_get_portsamplescontrol(struct ib_pma_mad *pmp,
 					   struct ib_device *ibdev, u8 port)
 {
 	struct ib_pma_portsamplescontrol *p =
@@ -970,9 +838,9 @@ static int recv_pma_get_portsamplescontr
 	memset(pmp->data, 0, sizeof(pmp->data));

 	p->port_select = port_select;
-	if (pmp->attr_mod != 0 ||
+	if (pmp->mad_hdr.attr_mod != 0 ||
 	    (port_select != port && port_select != 0xFF))
-		pmp->status |= IB_SMP_INVALID_FIELD;
+		pmp->mad_hdr.status |= IB_SMP_INVALID_FIELD;
 	/*
 	 * Ticks are 10x the link transfer period which for 2.5Gbs is 4
 	 * nsec.  0 == 4 nsec., 1 == 8 nsec., ..., 255 == 1020 nsec.  Sample
@@ -1006,7 +874,7 @@ static int recv_pma_get_portsamplescontr
 	return reply((struct ib_smp *) pmp);
 }

-static int recv_pma_set_portsamplescontrol(struct ib_perf *pmp,
+static int recv_pma_set_portsamplescontrol(struct ib_pma_mad *pmp,
 					   struct ib_device *ibdev, u8 port)
 {
 	struct ib_pma_portsamplescontrol *p =
@@ -1017,9 +885,9 @@ static int recv_pma_set_portsamplescontr
 	u8 status;
 	int ret;

-	if (pmp->attr_mod != 0 ||
+	if (pmp->mad_hdr.attr_mod != 0 ||
 	    (p->port_select != port && p->port_select != 0xFF)) {
-		pmp->status |= IB_SMP_INVALID_FIELD;
+		pmp->mad_hdr.status |= IB_SMP_INVALID_FIELD;
 		ret = reply((struct ib_smp *) pmp);
 		goto bail;
 	}
@@ -1093,7 +961,7 @@ static u64 get_counter(struct ipath_ibde
 	return ret;
 }

-static int recv_pma_get_portsamplesresult(struct ib_perf *pmp,
+static int recv_pma_get_portsamplesresult(struct ib_pma_mad *pmp,
 					  struct ib_device *ibdev)
 {
 	struct ib_pma_portsamplesresult *p =
@@ -1118,7 +986,7 @@ static int recv_pma_get_portsamplesresul
 	return reply((struct ib_smp *) pmp);
 }

-static int recv_pma_get_portsamplesresult_ext(struct ib_perf *pmp,
+static int recv_pma_get_portsamplesresult_ext(struct ib_pma_mad *pmp,
 					      struct ib_device *ibdev)
 {
 	struct ib_pma_portsamplesresult_ext *p =
@@ -1145,7 +1013,7 @@ static int recv_pma_get_portsamplesresul
 	return reply((struct ib_smp *) pmp);
 }

-static int recv_pma_get_portcounters(struct ib_perf *pmp,
+static int recv_pma_get_portcounters(struct ib_pma_mad *pmp,
 				     struct ib_device *ibdev, u8 port)
 {
 	struct ib_pma_portcounters *p = (struct ib_pma_portcounters *)
@@ -1179,9 +1047,9 @@ static int recv_pma_get_portcounters(str
 	memset(pmp->data, 0, sizeof(pmp->data));

 	p->port_select = port_select;
-	if (pmp->attr_mod != 0 ||
+	if (pmp->mad_hdr.attr_mod != 0 ||
 	    (port_select != port && port_select != 0xFF))
-		pmp->status |= IB_SMP_INVALID_FIELD;
+		pmp->mad_hdr.status |= IB_SMP_INVALID_FIELD;

 	if (cntrs.symbol_error_counter > 0xFFFFUL)
 		p->symbol_error_counter = cpu_to_be16(0xFFFF);
@@ -1216,7 +1084,7 @@ static int recv_pma_get_portcounters(str
 		cntrs.local_link_integrity_errors = 0xFUL;
 	if (cntrs.excessive_buffer_overrun_errors > 0xFUL)
 		cntrs.excessive_buffer_overrun_errors = 0xFUL;
-	p->lli_ebor_errors = (cntrs.local_link_integrity_errors << 4) |
+	p->link_overrun_errors = (cntrs.local_link_integrity_errors << 4) |
 		cntrs.excessive_buffer_overrun_errors;
 	if (cntrs.vl15_dropped > 0xFFFFUL)
 		p->vl15_dropped = cpu_to_be16(0xFFFF);
@@ -1244,7 +1112,7 @@ static int recv_pma_get_portcounters(str
 	return reply((struct ib_smp *) pmp);
 }

-static int recv_pma_get_portcounters_ext(struct ib_perf *pmp,
+static int recv_pma_get_portcounters_ext(struct ib_pma_mad *pmp,
 					 struct ib_device *ibdev, u8 port)
 {
 	struct ib_pma_portcounters_ext *p =
@@ -1265,9 +1133,9 @@ static int recv_pma_get_portcounters_ext
 	memset(pmp->data, 0, sizeof(pmp->data));

 	p->port_select = port_select;
-	if (pmp->attr_mod != 0 ||
+	if (pmp->mad_hdr.attr_mod != 0 ||
 	    (port_select != port && port_select != 0xFF))
-		pmp->status |= IB_SMP_INVALID_FIELD;
+		pmp->mad_hdr.status |= IB_SMP_INVALID_FIELD;

 	p->port_xmit_data = cpu_to_be64(swords);
 	p->port_rcv_data = cpu_to_be64(rwords);
@@ -1281,7 +1149,7 @@ static int recv_pma_get_portcounters_ext
 	return reply((struct ib_smp *) pmp);
 }

-static int recv_pma_set_portcounters(struct ib_perf *pmp,
+static int recv_pma_set_portcounters(struct ib_pma_mad *pmp,
 				     struct ib_device *ibdev, u8 port)
 {
 	struct ib_pma_portcounters *p = (struct ib_pma_portcounters *)
@@ -1344,7 +1212,7 @@ static int recv_pma_set_portcounters(str
 	return recv_pma_get_portcounters(pmp, ibdev, port);
 }

-static int recv_pma_set_portcounters_ext(struct ib_perf *pmp,
+static int recv_pma_set_portcounters_ext(struct ib_pma_mad *pmp,
 					 struct ib_device *ibdev, u8 port)
 {
 	struct ib_pma_portcounters *p = (struct ib_pma_portcounters *)
@@ -1518,19 +1386,19 @@ static int process_perf(struct ib_device
 			struct ib_mad *in_mad,
 			struct ib_mad *out_mad)
 {
-	struct ib_perf *pmp = (struct ib_perf *)out_mad;
+	struct ib_pma_mad *pmp = (struct ib_pma_mad *)out_mad;
 	int ret;

 	*out_mad = *in_mad;
-	if (pmp->class_version != 1) {
-		pmp->status |= IB_SMP_UNSUP_VERSION;
+	if (pmp->mad_hdr.class_version != 1) {
+		pmp->mad_hdr.status |= IB_SMP_UNSUP_VERSION;
 		ret = reply((struct ib_smp *) pmp);
 		goto bail;
 	}

-	switch (pmp->method) {
+	switch (pmp->mad_hdr.method) {
 	case IB_MGMT_METHOD_GET:
-		switch (pmp->attr_id) {
+		switch (pmp->mad_hdr.attr_id) {
 		case IB_PMA_CLASS_PORT_INFO:
 			ret = recv_pma_get_classportinfo(pmp);
 			goto bail;
@@ -1554,13 +1422,13 @@ static int process_perf(struct ib_device
 							    port_num);
 			goto bail;
 		default:
-			pmp->status |= IB_SMP_UNSUP_METH_ATTR;
+			pmp->mad_hdr.status |= IB_SMP_UNSUP_METH_ATTR;
 			ret = reply((struct ib_smp *) pmp);
 			goto bail;
 		}

 	case IB_MGMT_METHOD_SET:
-		switch (pmp->attr_id) {
+		switch (pmp->mad_hdr.attr_id) {
 		case IB_PMA_PORT_SAMPLES_CONTROL:
 			ret = recv_pma_set_portsamplescontrol(pmp, ibdev,
 							      port_num);
@@ -1574,7 +1442,7 @@ static int process_perf(struct ib_device
 							    port_num);
 			goto bail;
 		default:
-			pmp->status |= IB_SMP_UNSUP_METH_ATTR;
+			pmp->mad_hdr.status |= IB_SMP_UNSUP_METH_ATTR;
 			ret = reply((struct ib_smp *) pmp);
 			goto bail;
 		}
@@ -1588,7 +1456,7 @@ static int process_perf(struct ib_device
 		ret = IB_MAD_RESULT_SUCCESS;
 		goto bail;
 	default:
-		pmp->status |= IB_SMP_UNSUP_METHOD;
+		pmp->mad_hdr.status |= IB_SMP_UNSUP_METHOD;
 		ret = reply((struct ib_smp *) pmp);
 	}

Index: linux-2.6.39-rc/drivers/infiniband/hw/qib/qib_mad.h
===================================================================
--- linux-2.6.39-rc.orig/drivers/infiniband/hw/qib/qib_mad.h
+++ linux-2.6.39-rc/drivers/infiniband/hw/qib/qib_mad.h
@@ -32,6 +32,8 @@
  * SOFTWARE.
  */

+#include <rdma/ib_pma.h>
+
 #define IB_SMP_UNSUP_VERSION    cpu_to_be16(0x0004)
 #define IB_SMP_UNSUP_METHOD     cpu_to_be16(0x0008)
 #define IB_SMP_UNSUP_METH_ATTR  cpu_to_be16(0x000C)
@@ -180,109 +182,8 @@ struct ib_vl_weight_elem {
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
 #define IB_PMA_PORT_COUNTERS_CONG       cpu_to_be16(0xFF00)

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
 struct ib_pma_portcounters_cong {
 	u8 reserved;
 	u8 reserved1;
@@ -297,7 +198,7 @@ struct ib_pma_portcounters_cong {
 	u8 port_xmit_constraint_errors;
 	u8 port_rcv_constraint_errors;
 	u8 reserved2;
-	u8 lli_ebor_errors;    /* 4, 4, bits */
+	u8 link_overrun_errors; /* LocalLink: 7:4, BufferOverrun: 3:0 */
 	__be16 reserved3;
 	__be16 vl15_dropped;
 	__be64 port_xmit_data;
@@ -316,49 +217,11 @@ struct ib_pma_portcounters_cong {
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
 #define IB_PMA_SEL_CONG_ALL                     0x01
 #define IB_PMA_SEL_CONG_PORT_DATA               0x02
 #define IB_PMA_SEL_CONG_XMIT                    0x04
 #define IB_PMA_SEL_CONG_ROUTING                 0x08

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
Index: linux-2.6.39-rc/include/rdma/ib_pma.h
===================================================================
--- /dev/null
+++ linux-2.6.39-rc/include/rdma/ib_pma.h
@@ -0,0 +1,156 @@
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
+#include <rdma/ib_mad.h>
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
+
+struct ib_pma_mad {
+	struct ib_mad_hdr mad_hdr;
+	u8 reserved[40];
+	u8 data[192];
+} __attribute__ ((packed));
+
+struct ib_pma_portsamplescontrol {
+	u8 opcode;
+	u8 port_select;
+	u8 tick;
+	u8 counter_width;		/* resv: 7:3, counter width: 2:0 */
+	__be32 counter_mask0_9;		/* 2, 10 3-bit fields */
+	__be16 counter_mask10_14;	/* 1, 5 3-bit fields */
+	u8 sample_mechanisms;
+	u8 sample_status;		/* only lower 2 bits */
+	__be64 option_mask;
+	__be64 vendor_mask;
+	__be32 sample_start;
+	__be32 sample_interval;
+	__be16 tag;
+	__be16 counter_select[15];
+	__be32 reserved1;
+	__be64 samples_only_option_mask;
+	__be32 reserved2[28];
+};
+
+struct ib_pma_portsamplesresult {
+	__be16 tag;
+	__be16 sample_status;   /* only lower 2 bits */
+	__be32 counter[15];
+};
+
+struct ib_pma_portsamplesresult_ext {
+	__be16 tag;
+	__be16 sample_status;   /* only lower 2 bits */
+	__be32 extended_width;  /* only upper 2 bits */
+	__be64 counter[15];
+};
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
+	u8 link_overrun_errors; /* LocalLink: 7:4, BufferOverrun: 3:0 */
+	__be16 reserved2;
+	__be16 vl15_dropped;
+	__be32 port_xmit_data;
+	__be32 port_rcv_data;
+	__be32 port_xmit_packets;
+	__be32 port_rcv_packets;
+	__be32 port_xmit_wait;
+} __attribute__ ((packed));
+
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
