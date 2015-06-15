From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 01/49] IB/core: Add OPA Port header definitions
Date: Mon, 15 Jun 2015 09:26:03 -0400
Message-ID: <20150615132603.29741.75037.stgit@phlsvslse11.ph.intel.com>
References: <20150615132434.29741.35258.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150615132434.29741.35258.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add common OPA header definitions for driver
build:
- opa_port_info.h
- opa_smi.h
- hfi1_user.sh

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: John, Jubin <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/rdma/opa_port_info.h      |  433 +++++++++++++++++++++++++++++++++++++
 include/rdma/opa_smi.h            |   47 ++++
 include/uapi/rdma/hfi/hfi1_user.h |  427 ++++++++++++++++++++++++++++++++++++
 3 files changed, 907 insertions(+)
 create mode 100644 include/rdma/opa_port_info.h
 create mode 100644 include/uapi/rdma/hfi/hfi1_user.h

diff --git a/include/rdma/opa_port_info.h b/include/rdma/opa_port_info.h
new file mode 100644
index 0000000..391dae1
--- /dev/null
+++ b/include/rdma/opa_port_info.h
@@ -0,0 +1,433 @@
+/*
+ * Copyright (c) 2014 Intel Corporation.  All rights reserved.
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
+#if !defined(OPA_PORT_INFO_H)
+#define OPA_PORT_INFO_H
+
+/* Temporary until HFI driver is updated */
+#ifndef USE_PI_LED_ENABLE
+#define USE_PI_LED_ENABLE 0
+#endif
+
+#define OPA_PORT_LINK_MODE_NOP	0		/* No change */
+#define OPA_PORT_LINK_MODE_OPA	4		/* Port mode is OPA */
+
+#define OPA_PORT_PACKET_FORMAT_NOP	0		/* No change */
+#define OPA_PORT_PACKET_FORMAT_8B	1		/* Format 8B */
+#define OPA_PORT_PACKET_FORMAT_9B	2		/* Format 9B */
+#define OPA_PORT_PACKET_FORMAT_10B	4		/* Format 10B */
+#define OPA_PORT_PACKET_FORMAT_16B	8		/* Format 16B */
+
+#define OPA_PORT_LTP_CRC_MODE_NONE	0	/* No change */
+#define OPA_PORT_LTP_CRC_MODE_14	1	/* 14-bit LTP CRC mode (optional) */
+#define OPA_PORT_LTP_CRC_MODE_16	2	/* 16-bit LTP CRC mode */
+#define OPA_PORT_LTP_CRC_MODE_48	4	/* 48-bit LTP CRC mode (optional) */
+#define OPA_PORT_LTP_CRC_MODE_PER_LANE  8	/* 12/16-bit per lane LTP CRC mode */
+
+/* Link Down / Neighbor Link Down Reason; indicated as follows: */
+#define OPA_LINKDOWN_REASON_NONE				0	/* No specified reason */
+#define OPA_LINKDOWN_REASON_RCV_ERROR_0				1
+#define OPA_LINKDOWN_REASON_BAD_PKT_LEN				2
+#define OPA_LINKDOWN_REASON_PKT_TOO_LONG			3
+#define OPA_LINKDOWN_REASON_PKT_TOO_SHORT			4
+#define OPA_LINKDOWN_REASON_BAD_SLID				5
+#define OPA_LINKDOWN_REASON_BAD_DLID				6
+#define OPA_LINKDOWN_REASON_BAD_L2				7
+#define OPA_LINKDOWN_REASON_BAD_SC				8
+#define OPA_LINKDOWN_REASON_RCV_ERROR_8				9
+#define OPA_LINKDOWN_REASON_BAD_MID_TAIL			10
+#define OPA_LINKDOWN_REASON_RCV_ERROR_10			11
+#define OPA_LINKDOWN_REASON_PREEMPT_ERROR			12
+#define OPA_LINKDOWN_REASON_PREEMPT_VL15			13
+#define OPA_LINKDOWN_REASON_BAD_VL_MARKER			14
+#define OPA_LINKDOWN_REASON_RCV_ERROR_14			15
+#define OPA_LINKDOWN_REASON_RCV_ERROR_15			16
+#define OPA_LINKDOWN_REASON_BAD_HEAD_DIST			17
+#define OPA_LINKDOWN_REASON_BAD_TAIL_DIST			18
+#define OPA_LINKDOWN_REASON_BAD_CTRL_DIST			19
+#define OPA_LINKDOWN_REASON_BAD_CREDIT_ACK			20
+#define OPA_LINKDOWN_REASON_UNSUPPORTED_VL_MARKER		21
+#define OPA_LINKDOWN_REASON_BAD_PREEMPT				22
+#define OPA_LINKDOWN_REASON_BAD_CONTROL_FLIT			23
+#define OPA_LINKDOWN_REASON_EXCEED_MULTICAST_LIMIT		24
+#define OPA_LINKDOWN_REASON_RCV_ERROR_24			25
+#define OPA_LINKDOWN_REASON_RCV_ERROR_25			26
+#define OPA_LINKDOWN_REASON_RCV_ERROR_26			27
+#define OPA_LINKDOWN_REASON_RCV_ERROR_27			28
+#define OPA_LINKDOWN_REASON_RCV_ERROR_28			29
+#define OPA_LINKDOWN_REASON_RCV_ERROR_29			30
+#define OPA_LINKDOWN_REASON_RCV_ERROR_30			31
+#define OPA_LINKDOWN_REASON_EXCESSIVE_BUFFER_OVERRUN		32
+#define OPA_LINKDOWN_REASON_UNKNOWN				33
+/* 34 -reserved */
+#define OPA_LINKDOWN_REASON_REBOOT				35
+#define OPA_LINKDOWN_REASON_NEIGHBOR_UNKNOWN			36
+/* 37-38 reserved */
+#define OPA_LINKDOWN_REASON_FM_BOUNCE				39
+#define OPA_LINKDOWN_REASON_SPEED_POLICY			40
+#define OPA_LINKDOWN_REASON_WIDTH_POLICY			41
+/* 42-48 reserved */
+#define OPA_LINKDOWN_REASON_DISCONNECTED			49
+#define OPA_LINKDOWN_REASONLOCAL_MEDIA_NOT_INSTALLED		50
+#define OPA_LINKDOWN_REASON_NOT_INSTALLED			51
+#define OPA_LINKDOWN_REASON_CHASSIS_CONFIG			52
+/* 53 reserved */
+#define OPA_LINKDOWN_REASON_END_TO_END_NOT_INSTALLED		54
+/* 55 reserved */
+#define OPA_LINKDOWN_REASON_POWER_POLICY			56
+#define OPA_LINKDOWN_REASON_LINKSPEED_POLICY			57
+#define OPA_LINKDOWN_REASON_LINKWIDTH_POLICY			58
+/* 59 reserved */
+#define OPA_LINKDOWN_REASON_SWITCH_MGMT				60
+#define OPA_LINKDOWN_REASON_SMA_DISABLED			61
+/* 62 reserved */
+#define OPA_LINKDOWN_REASON_TRANSIENT				63
+/* 64-255 reserved */
+
+/* OPA Link Init reason; indicated as follows: */
+/* 3-7; 11-15 reserved; 8-15 cleared on Polling->LinkUp */
+#define OPA_LINKINIT_REASON_NOP                 0
+#define OPA_LINKINIT_REASON_LINKUP              (1 << 4)
+#define OPA_LINKINIT_REASON_FLAPPING            (2 << 4)
+#define OPA_LINKINIT_REASON_CLEAR               (8 << 4)
+#define OPA_LINKINIT_OUTSIDE_POLICY             (8 << 4)
+#define OPA_LINKINIT_QUARANTINED                (9 << 4)
+#define OPA_LINKINIT_INSUFIC_CAPABILITY         (10 << 4)
+
+#define OPA_LINK_SPEED_NOP              0x0000  /*  Reserved (1-5 Gbps) */
+#define OPA_LINK_SPEED_12_5G            0x0001  /*  12.5 Gbps */
+#define OPA_LINK_SPEED_25G              0x0002  /*  25.78125?  Gbps (EDR) */
+
+#define OPA_LINK_WIDTH_1X            0x0001
+#define OPA_LINK_WIDTH_2X            0x0002
+#define OPA_LINK_WIDTH_3X            0x0004
+#define OPA_LINK_WIDTH_4X            0x0008
+
+#define OPA_CAP_MASK3_IsSnoopSupported            (1 << 7)
+#define OPA_CAP_MASK3_IsAsyncSC2VLSupported       (1 << 6)
+#define OPA_CAP_MASK3_IsAddrRangeConfigSupported  (1 << 5)
+#define OPA_CAP_MASK3_IsPassThroughSupported      (1 << 4)
+#define OPA_CAP_MASK3_IsSharedSpaceSupported      (1 << 3)
+/* reserved (1 << 2) */
+#define OPA_CAP_MASK3_IsVLMarkerSupported         (1 << 1)
+#define OPA_CAP_MASK3_IsVLrSupported              (1 << 0)
+
+/**
+ * new MTU values
+ */
+enum {
+	OPA_MTU_8192  = 6,
+	OPA_MTU_10240 = 7,
+};
+
+enum {
+	OPA_PORT_PHYS_CONF_DISCONNECTED = 0,
+	OPA_PORT_PHYS_CONF_STANDARD     = 1,
+	OPA_PORT_PHYS_CONF_FIXED        = 2,
+	OPA_PORT_PHYS_CONF_VARIABLE     = 3,
+	OPA_PORT_PHYS_CONF_SI_PHOTO     = 4
+};
+
+enum port_info_field_masks {
+	/* vl.cap */
+	OPA_PI_MASK_VL_CAP                        = 0x1F,
+	/* port_states.ledenable_offlinereason */
+	OPA_PI_MASK_OFFLINE_REASON                = 0x0F,
+	OPA_PI_MASK_LED_ENABLE                    = 0x40,
+	/* port_states.unsleepstate_downdefstate */
+	OPA_PI_MASK_UNSLEEP_STATE                 = 0xF0,
+	OPA_PI_MASK_DOWNDEF_STATE                 = 0x0F,
+	/* port_states.portphysstate_portstate */
+	OPA_PI_MASK_PORT_PHYSICAL_STATE           = 0xF0,
+	OPA_PI_MASK_PORT_STATE                    = 0x0F,
+	/* port_phys_conf */
+	OPA_PI_MASK_PORT_PHYSICAL_CONF            = 0x0F,
+	/* collectivemask_multicastmask */
+	OPA_PI_MASK_COLLECT_MASK                  = 0x38,
+	OPA_PI_MASK_MULTICAST_MASK                = 0x07,
+	/* mkeyprotect_lmc */
+	OPA_PI_MASK_MKEY_PROT_BIT                 = 0xC0,
+	OPA_PI_MASK_LMC                           = 0x0F,
+	/* smsl */
+	OPA_PI_MASK_SMSL                          = 0x1F,
+	/* partenforce_filterraw */
+	/* Filter Raw In/Out bits 1 and 2 were removed */
+	OPA_PI_MASK_LINKINIT_REASON               = 0xF0,
+	OPA_PI_MASK_PARTITION_ENFORCE_IN          = 0x08,
+	OPA_PI_MASK_PARTITION_ENFORCE_OUT         = 0x04,
+	/* operational_vls */
+	OPA_PI_MASK_OPERATIONAL_VL                = 0x1F,
+	/* sa_qp */
+	OPA_PI_MASK_SA_QP                         = 0x00FFFFFF,
+	/* sm_trap_qp */
+	OPA_PI_MASK_SM_TRAP_QP                    = 0x00FFFFFF,
+	/* localphy_overrun_errors */
+	OPA_PI_MASK_LOCAL_PHY_ERRORS              = 0xF0,
+	OPA_PI_MASK_OVERRUN_ERRORS                = 0x0F,
+	/* clientrereg_subnettimeout */
+	OPA_PI_MASK_CLIENT_REREGISTER             = 0x80,
+	OPA_PI_MASK_SUBNET_TIMEOUT                = 0x1F,
+	/* port_link_mode */
+	OPA_PI_MASK_PORT_LINK_SUPPORTED           = (0x001F << 10),
+	OPA_PI_MASK_PORT_LINK_ENABLED             = (0x001F <<  5),
+	OPA_PI_MASK_PORT_LINK_ACTIVE              = (0x001F <<  0),
+	/* port_link_crc_mode */
+	OPA_PI_MASK_PORT_LINK_CRC_SUPPORTED       = 0x0F00,
+	OPA_PI_MASK_PORT_LINK_CRC_ENABLED         = 0x00F0,
+	OPA_PI_MASK_PORT_LINK_CRC_ACTIVE          = 0x000F,
+	/* port_mode */
+	OPA_PI_MASK_PORT_MODE_SECURITY_CHECK      = 0x0001,
+	OPA_PI_MASK_PORT_MODE_16B_TRAP_QUERY      = 0x0002,
+	OPA_PI_MASK_PORT_MODE_PKEY_CONVERT        = 0x0004,
+	OPA_PI_MASK_PORT_MODE_SC2SC_MAPPING       = 0x0008,
+	OPA_PI_MASK_PORT_MODE_VL_MARKER           = 0x0010,
+	OPA_PI_MASK_PORT_PASS_THROUGH             = 0x0020,
+	OPA_PI_MASK_PORT_ACTIVE_OPTOMIZE          = 0x0040,
+	/* flit_control.interleave */
+	OPA_PI_MASK_INTERLEAVE_DIST_SUP           = (0x0003 << 12),
+	OPA_PI_MASK_INTERLEAVE_DIST_ENABLE        = (0x0003 << 10),
+	OPA_PI_MASK_INTERLEAVE_MAX_NEST_TX        = (0x001F <<  5),
+	OPA_PI_MASK_INTERLEAVE_MAX_NEST_RX        = (0x001F <<  0),
+
+	/* port_error_action */
+	OPA_PI_MASK_EX_BUFFER_OVERRUN                  = 0x80000000,
+		/* 7 bits reserved */
+	OPA_PI_MASK_FM_CFG_ERR_EXCEED_MULTICAST_LIMIT  = 0x00800000,
+	OPA_PI_MASK_FM_CFG_BAD_CONTROL_FLIT            = 0x00400000,
+	OPA_PI_MASK_FM_CFG_BAD_PREEMPT                 = 0x00200000,
+	OPA_PI_MASK_FM_CFG_UNSUPPORTED_VL_MARKER       = 0x00100000,
+	OPA_PI_MASK_FM_CFG_BAD_CRDT_ACK                = 0x00080000,
+	OPA_PI_MASK_FM_CFG_BAD_CTRL_DIST               = 0x00040000,
+	OPA_PI_MASK_FM_CFG_BAD_TAIL_DIST               = 0x00020000,
+	OPA_PI_MASK_FM_CFG_BAD_HEAD_DIST               = 0x00010000,
+		/* 2 bits reserved */
+	OPA_PI_MASK_PORT_RCV_BAD_VL_MARKER             = 0x00002000,
+	OPA_PI_MASK_PORT_RCV_PREEMPT_VL15              = 0x00001000,
+	OPA_PI_MASK_PORT_RCV_PREEMPT_ERROR             = 0x00000800,
+		/* 1 bit reserved */
+	OPA_PI_MASK_PORT_RCV_BAD_MidTail               = 0x00000200,
+		/* 1 bit reserved */
+	OPA_PI_MASK_PORT_RCV_BAD_SC                    = 0x00000080,
+	OPA_PI_MASK_PORT_RCV_BAD_L2                    = 0x00000040,
+	OPA_PI_MASK_PORT_RCV_BAD_DLID                  = 0x00000020,
+	OPA_PI_MASK_PORT_RCV_BAD_SLID                  = 0x00000010,
+	OPA_PI_MASK_PORT_RCV_PKTLEN_TOOSHORT           = 0x00000008,
+	OPA_PI_MASK_PORT_RCV_PKTLEN_TOOLONG            = 0x00000004,
+	OPA_PI_MASK_PORT_RCV_BAD_PKTLEN                = 0x00000002,
+	OPA_PI_MASK_PORT_RCV_BAD_LT                    = 0x00000001,
+
+	/* pass_through.res_drctl */
+	OPA_PI_MASK_PASS_THROUGH_DR_CONTROL       = 0x01,
+
+	/* buffer_units */
+	OPA_PI_MASK_BUF_UNIT_VL15_INIT            = (0x00000FFF  << 11),
+	OPA_PI_MASK_BUF_UNIT_VL15_CREDIT_RATE     = (0x0000001F  <<  6),
+	OPA_PI_MASK_BUF_UNIT_CREDIT_ACK           = (0x00000003  <<  3),
+	OPA_PI_MASK_BUF_UNIT_BUF_ALLOC            = (0x00000003  <<  0),
+
+	/* neigh_mtu.pvlx_to_mtu */
+	OPA_PI_MASK_NEIGH_MTU_PVL0                = 0xF0,
+	OPA_PI_MASK_NEIGH_MTU_PVL1                = 0x0F,
+
+	/* neigh_mtu.vlstall_hoq_life */
+	OPA_PI_MASK_VL_STALL                      = (0x03 << 5),
+	OPA_PI_MASK_HOQ_LIFE                      = (0x1F << 0),
+
+	/* port_neigh_mode */
+	OPA_PI_MASK_NEIGH_MGMT_ALLOWED            = (0x01 << 3),
+	OPA_PI_MASK_NEIGH_FW_AUTH_BYPASS          = (0x01 << 2),
+	OPA_PI_MASK_NEIGH_NODE_TYPE               = (0x03 << 0),
+
+	/* resptime_value */
+	OPA_PI_MASK_RESPONSE_TIME_VALUE           = 0x1F,
+
+	/* mtucap */
+	OPA_PI_MASK_MTU_CAP                       = 0x0F,
+};
+
+#if USE_PI_LED_ENABLE
+struct opa_port_states {
+	u8     reserved;
+	u8     ledenable_offlinereason;   /* 1 res, 1 bit, 6 bits */
+	u8     reserved2;
+	u8     portphysstate_portstate;   /* 4 bits, 4 bits */
+};
+#define PI_LED_ENABLE_SUP 1
+#else
+struct opa_port_states {
+	u8     reserved;
+	u8     offline_reason;            /* 2 res, 6 bits */
+	u8     reserved2;
+	u8     portphysstate_portstate;   /* 4 bits, 4 bits */
+};
+#define PI_LED_ENABLE_SUP 0
+#endif
+
+struct opa_port_state_info {
+	struct opa_port_states port_states;
+	u16 link_width_downgrade_tx_active;
+	u16 link_width_downgrade_rx_active;
+};
+
+struct opa_port_info {
+	__be32 lid;
+	__be32 flow_control_mask;
+
+	struct {
+		u8     res;                       /* was inittype */
+		u8     cap;                       /* 3 res, 5 bits */
+		__be16 high_limit;
+		__be16 preempt_limit;
+		u8     arb_high_cap;
+		u8     arb_low_cap;
+	} vl;
+
+	struct opa_port_states  port_states;
+	u8     port_phys_conf;                    /* 4 res, 4 bits */
+	u8     collectivemask_multicastmask;      /* 2 res, 3, 3 */
+	u8     mkeyprotect_lmc;                   /* 2 bits, 2 res, 4 bits */
+	u8     smsl;                              /* 3 res, 5 bits */
+
+	u8     partenforce_filterraw;             /* bit fields */
+	u8     operational_vls;                    /* 3 res, 5 bits */
+	__be16 pkey_8b;
+	__be16 pkey_10b;
+	__be16 mkey_violations;
+
+	__be16 pkey_violations;
+	__be16 qkey_violations;
+	__be32 sm_trap_qp;                        /* 8 bits, 24 bits */
+
+	__be32 sa_qp;                             /* 8 bits, 24 bits */
+	u8     neigh_port_num;
+	u8     link_down_reason;
+	u8     neigh_link_down_reason;
+	u8     clientrereg_subnettimeout;	  /* 1 bit, 2 bits, 5 */
+
+	struct {
+		__be16 supported;
+		__be16 enabled;
+		__be16 active;
+	} link_speed;
+	struct {
+		__be16 supported;
+		__be16 enabled;
+		__be16 active;
+	} link_width;
+	struct {
+		__be16 supported;
+		__be16 enabled;
+		__be16 tx_active;
+		__be16 rx_active;
+	} link_width_downgrade;
+	__be16 port_link_mode;                  /* 1 res, 5 bits, 5 bits, 5 bits */
+	__be16 port_ltp_crc_mode;               /* 4 res, 4 bits, 4 bits, 4 bits */
+
+	__be16 port_mode;                       /* 9 res, bit fields */
+	struct {
+		__be16 supported;
+		__be16 enabled;
+	} port_packet_format;
+	struct {
+		__be16 interleave;  /* 2 res, 2,2,5,5 */
+		struct {
+			__be16 min_initial;
+			__be16 min_tail;
+			u8     large_pkt_limit;
+			u8     small_pkt_limit;
+			u8     max_small_pkt_limit;
+			u8     preemption_limit;
+		} preemption;
+	} flit_control;
+
+	__be32 reserved4;
+	__be32 port_error_action; /* bit field */
+
+	struct {
+		u8 egress_port;
+		u8 res_drctl;                    /* 7 res, 1 */
+	} pass_through;
+	__be16 mkey_lease_period;
+	__be32 buffer_units;                     /* 9 res, 12, 5, 3, 3 */
+
+	__be32 reserved5;
+	__be32 sm_lid;
+
+	__be64 mkey;
+
+	__be64 subnet_prefix;
+
+	struct {
+		u8 pvlx_to_mtu[OPA_MAX_VLS/2]; /* 4 bits, 4 bits */
+	} neigh_mtu;
+
+	struct {
+		u8 vlstall_hoqlife;             /* 3 bits, 5 bits */
+	} xmit_q[OPA_MAX_VLS];
+
+	struct {
+		u8 addr[16];
+	} ipaddr_ipv6;
+
+	struct {
+		u8 addr[4];
+	} ipaddr_ipv4;
+
+	u32    reserved6;
+	u32    reserved7;
+	u32    reserved8;
+
+	__be64 neigh_node_guid;
+
+	__be32 ib_cap_mask;
+	__be16 reserved9;                    /* was ib_cap_mask2 */
+	__be16 opa_cap_mask;
+
+	__be32 reserved10;                   /* was link_roundtrip_latency */
+	__be16 overall_buffer_space;
+	__be16 reserved11;                   /* was max_credit_hint */
+
+	__be16 diag_code;
+	struct {
+		u8 buffer;
+		u8 wire;
+	} replay_depth;
+	u8     port_neigh_mode;
+	u8     mtucap;                          /* 4 res, 4 bits */
+
+	u8     resptimevalue;		        /* 3 res, 5 bits */
+	u8     local_port_num;
+	u8     reserved12;
+	u8     reserved13;                       /* was guid_cap */
+} __attribute__ ((packed));
+
+#endif /* OPA_PORT_INFO_H */
diff --git a/include/rdma/opa_smi.h b/include/rdma/opa_smi.h
index 29063e8..4a529ef 100644
--- a/include/rdma/opa_smi.h
+++ b/include/rdma/opa_smi.h
@@ -40,6 +40,10 @@
 #define OPA_SMP_DR_DATA_SIZE			1872
 #define OPA_SMP_MAX_PATH_HOPS			64
 
+#define OPA_MAX_VLS				32
+#define OPA_MAX_SLS				32
+#define OPA_MAX_SCS				32
+
 #define OPA_SMI_CLASS_VERSION			0x80
 
 #define OPA_LID_PERMISSIVE			cpu_to_be32(0xFFFFFFFF)
@@ -73,6 +77,49 @@ struct opa_smp {
 } __packed;
 
 
+/* Subnet management attributes */
+/* ... */
+#define OPA_ATTRIB_ID_NODE_DESCRIPTION		cpu_to_be16(0x0010)
+#define OPA_ATTRIB_ID_NODE_INFO			cpu_to_be16(0x0011)
+#define OPA_ATTRIB_ID_PORT_INFO			cpu_to_be16(0x0015)
+#define OPA_ATTRIB_ID_PARTITION_TABLE		cpu_to_be16(0x0016)
+#define OPA_ATTRIB_ID_SL_TO_SC_MAP		cpu_to_be16(0x0017)
+#define OPA_ATTRIB_ID_VL_ARBITRATION		cpu_to_be16(0x0018)
+#define OPA_ATTRIB_ID_SM_INFO			cpu_to_be16(0x0020)
+#define OPA_ATTRIB_ID_CABLE_INFO		cpu_to_be16(0x0032)
+#define OPA_ATTRIB_ID_AGGREGATE			cpu_to_be16(0x0080)
+#define OPA_ATTRIB_ID_SC_TO_SL_MAP		cpu_to_be16(0x0082)
+#define OPA_ATTRIB_ID_SC_TO_VLR_MAP		cpu_to_be16(0x0083)
+#define OPA_ATTRIB_ID_SC_TO_VLT_MAP		cpu_to_be16(0x0084)
+#define OPA_ATTRIB_ID_SC_TO_VLNT_MAP		cpu_to_be16(0x0085)
+/* ... */
+#define OPA_ATTRIB_ID_PORT_STATE_INFO		cpu_to_be16(0x0087)
+/* ... */
+#define OPA_ATTRIB_ID_BUFFER_CONTROL_TABLE	cpu_to_be16(0x008A)
+/* ... */
+
+struct opa_node_description {
+	u8 data[64];
+} __attribute__ ((packed));
+
+struct opa_node_info {
+	u8      base_version;
+	u8      class_version;
+	u8      node_type;
+	u8      num_ports;
+	__be32  reserved;
+	__be64  system_image_guid;
+	__be64  node_guid;
+	__be64  port_guid;
+	__be16  partition_cap;
+	__be16  device_id;
+	__be32  revision;
+	u8      local_port_num;
+	u8      vendor_id[3];   /* network byte order */
+} __attribute__ ((packed));
+
+#define OPA_PARTITION_TABLE_BLK_SIZE 32
+
 static inline u8
 opa_get_smp_direction(struct opa_smp *smp)
 {
diff --git a/include/uapi/rdma/hfi/hfi1_user.h b/include/uapi/rdma/hfi/hfi1_user.h
new file mode 100644
index 0000000..2ee745a
--- /dev/null
+++ b/include/uapi/rdma/hfi/hfi1_user.h
@@ -0,0 +1,427 @@
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
+/*
+ * This file contains defines, structures, etc. that are used
+ * to communicate between kernel and user code.
+ */
+
+#ifndef _LINUX__HFI1_USER_H
+#define _LINUX__HFI1_USER_H
+
+#include <linux/types.h>
+
+/*
+ * This version number is given to the driver by the user code during
+ * initialization in the spu_userversion field of hfi1_user_info, so
+ * the driver can check for compatibility with user code.
+ *
+ * The major version changes when data structures change in an incompatible
+ * way. The driver must be the same for initialization to succeed.
+ */
+#define HFI1_USER_SWMAJOR 4
+
+/*
+ * Minor version differences are always compatible
+ * a within a major version, however if user software is larger
+ * than driver software, some new features and/or structure fields
+ * may not be implemented; the user code must deal with this if it
+ * cares, or it must abort after initialization reports the difference.
+ */
+#define HFI1_USER_SWMINOR 0
+
+/*
+ * Set of HW and driver capability/feature bits.
+ * These bit values are used to configure enabled/disabled HW and
+ * driver features. The same set of bits are communicated to user
+ * space.
+ */
+#define HFI1_CAP_DMA_RTAIL        (1UL <<  0) /* Use DMA'ed RTail value */
+#define HFI1_CAP_SDMA             (1UL <<  1) /* Enable SDMA support */
+#define HFI1_CAP_SDMA_AHG         (1UL <<  2) /* Enable SDMA AHG support */
+#define HFI1_CAP_EXTENDED_PSN     (1UL <<  3) /* Enable Extended PSN support */
+#define HFI1_CAP_HDRSUPP          (1UL <<  4) /* Enable Header Suppression */
+#define HFI1_CAP_ENABLE_SMA       (1UL <<  5) /* Enable driver SM Agent */
+#define HFI1_CAP_USE_SDMA_HEAD    (1UL <<  6) /* DMA Hdr Q tail vs. use CSR */
+#define HFI1_CAP_MULTI_PKT_EGR    (1UL <<  7) /* Enable multi-packet Egr buffs*/
+#define HFI1_CAP_NODROP_RHQ_FULL  (1UL <<  8) /* Don't drop on Hdr Q full */
+#define HFI1_CAP_NODROP_EGR_FULL  (1UL <<  9) /* Don't drop on EGR buffs full */
+#define HFI1_CAP_TID_UNMAP        (1UL << 10) /* Enable Expected TID caching */
+#define HFI1_CAP_PRINT_UNIMPL     (1UL << 11) /* Show for unimplemented feats */
+#define HFI1_CAP_ALLOW_PERM_JKEY  (1UL << 12) /* Allow use of permissive JKEY */
+#define HFI1_CAP_NO_INTEGRITY     (1UL << 13) /* Enable ctxt integrity checks */
+#define HFI1_CAP_PKEY_CHECK       (1UL << 14) /* Enable ctxt PKey checking */
+#define HFI1_CAP_STATIC_RATE_CTRL (1UL << 15) /* Allow PBC.StaticRateControl */
+#define HFI1_CAP_QSFP_ENABLED     (1UL << 16) /* Enable QSFP check during LNI */
+#define HFI1_CAP_SDMA_HEAD_CHECK  (1UL << 17) /* SDMA head checking */
+#define HFI1_CAP_EARLY_CREDIT_RETURN (1UL << 18) /* early credit return */
+
+#define HFI1_RCVHDR_ENTSIZE_2    (1UL << 0)
+#define HFI1_RCVHDR_ENTSIZE_16   (1UL << 1)
+#define HFI1_RCVDHR_ENTSIZE_32   (1UL << 2)
+
+/*
+ * If the unit is specified via open, HCA choice is fixed.  If port is
+ * specified, it's also fixed.  Otherwise we try to spread contexts
+ * across ports and HCAs, using different algorithms.  WITHIN is
+ * the old default, prior to this mechanism.
+ */
+#define HFI1_ALG_ACROSS 0 /* round robin contexts across HCAs, then
+			  * ports; this is the default */
+#define HFI1_ALG_WITHIN 1 /* use all contexts on an HCA (round robin
+			  * active ports within), then next HCA */
+#define HFI1_ALG_COUNT  2 /* number of algorithm choices */
+
+
+/* User commands. */
+#define HFI1_CMD_ASSIGN_CTXT     1	/* allocate HCA and context */
+#define HFI1_CMD_CTXT_INFO       2	/* find out what resources we got */
+#define HFI1_CMD_USER_INFO       3	/* set up userspace */
+#define HFI1_CMD_TID_UPDATE      4	/* update expected TID entries */
+#define HFI1_CMD_TID_FREE        5	/* free expected TID entries */
+#define HFI1_CMD_CREDIT_UPD      6	/* force an update of PIO credit */
+#define HFI1_CMD_SDMA_STATUS_UPD 7       /* force update of SDMA status ring */
+
+#define HFI1_CMD_RECV_CTRL       8	/* control receipt of packets */
+#define HFI1_CMD_POLL_TYPE       9	/* set the kind of polling we want */
+#define HFI1_CMD_ACK_EVENT       10	/* ack & clear user status bits */
+#define HFI1_CMD_SET_PKEY        11      /* set context's pkey */
+#define HFI1_CMD_CTXT_RESET      12      /* reset context's HW send context */
+/* separate EPROM commands from normal PSM commands */
+#define HFI1_CMD_EP_INFO         64      /* read EPROM device ID */
+#define HFI1_CMD_EP_ERASE_CHIP   65      /* erase whole EPROM */
+#define HFI1_CMD_EP_ERASE_P0     66      /* erase EPROM partition 0 */
+#define HFI1_CMD_EP_ERASE_P1     67      /* erase EPROM partition 1 */
+#define HFI1_CMD_EP_READ_P0      68      /* read EPROM partition 0 */
+#define HFI1_CMD_EP_READ_P1      69      /* read EPROM partition 1 */
+#define HFI1_CMD_EP_WRITE_P0     70      /* write EPROM partition 0 */
+#define HFI1_CMD_EP_WRITE_P1     71      /* write EPROM partition 1 */
+
+#define _HFI1_EVENT_FROZEN_BIT       0
+#define _HFI1_EVENT_LINKDOWN_BIT     1
+#define _HFI1_EVENT_LID_CHANGE_BIT   2
+#define _HFI1_EVENT_LMC_CHANGE_BIT   3
+#define _HFI1_EVENT_SL2VL_CHANGE_BIT 4
+#define _HFI1_MAX_EVENT_BIT _HFI1_EVENT_SL2VL_CHANGE_BIT
+
+#define HFI1_EVENT_FROZEN                (1UL << _HFI1_EVENT_FROZEN_BIT)
+#define HFI1_EVENT_LINKDOWN_BIT		(1UL << _HFI1_EVENT_LINKDOWN_BIT)
+#define HFI1_EVENT_LID_CHANGE_BIT	(1UL << _HFI1_EVENT_LID_CHANGE_BIT)
+#define HFI1_EVENT_LMC_CHANGE_BIT	(1UL << _HFI1_EVENT_LMC_CHANGE_BIT)
+#define HFI1_EVENT_SL2VL_CHANGE_BIT	(1UL << _HFI1_EVENT_SL2VL_CHANGE_BIT)
+
+/*
+ * These are the status bits readable (in ASCII form, 64bit value)
+ * from the "status" sysfs file.  For binary compatibility, values
+ * must remain as is; removed states can be reused for different
+ * purposes.
+ */
+#define HFI1_STATUS_INITTED       0x1    /* basic initialization done */
+/* Chip has been found and initialized */
+#define HFI1_STATUS_CHIP_PRESENT 0x20
+/* IB link is at ACTIVE, usable for data traffic */
+#define HFI1_STATUS_IB_READY     0x40
+/* link is configured, LID, MTU, etc. have been set */
+#define HFI1_STATUS_IB_CONF      0x80
+/* A Fatal hardware error has occurred. */
+#define HFI1_STATUS_HWERROR     0x200
+
+/*
+ * Number of supported shared contexts.
+ * This is the maximum number of software contexts that can share
+ * a hardware send/receive context.
+ */
+#define HFI1_MAX_SHARED_CTXTS 8
+
+/*
+ * Poll types
+ */
+#define HFI1_POLL_TYPE_ANYRCV     0x0
+#define HFI1_POLL_TYPE_URGENT     0x1
+
+/*
+ * This structure is passed to the driver to tell it where
+ * user code buffers are, sizes, etc.   The offsets and sizes of the
+ * fields must remain unchanged, for binary compatibility.  It can
+ * be extended, if userversion is changed so user code can tell, if needed
+ */
+struct hfi1_user_info {
+	/*
+	 * version of user software, to detect compatibility issues.
+	 * Should be set to HFI1_USER_SWVERSION.
+	 */
+	__u32 userversion;
+	__u16 pad;
+	/* HFI selection algorithm, if unit has not selected */
+	__u16 hfi1_alg;
+	/*
+	 * If two or more processes wish to share a context, each process
+	 * must set the subcontext_cnt and subcontext_id to the same
+	 * values.  The only restriction on the subcontext_id is that
+	 * it be unique for a given node.
+	 */
+	__u16 subctxt_cnt;
+	__u16 subctxt_id;
+	/* 128bit UUID passed in by PSM. */
+	__u8 uuid[16];
+};
+
+struct hfi1_ctxt_info {
+	__u64 runtime_flags;    /* chip/drv runtime flags (HFI1_CAP_*) */
+	__u32 rcvegr_size;      /* size of each eager buffer */
+	__u16 num_active;       /* number of active units */
+	__u16 unit;             /* unit (chip) assigned to caller */
+	__u16 ctxt;             /* ctxt on unit assigned to caller */
+	__u16 subctxt;          /* subctxt on unit assigned to caller */
+	__u16 rcvtids;          /* number of Rcv TIDs for this context */
+	__u16 credits;          /* number of PIO credits for this context */
+	__u16 numa_node;        /* NUMA node of the assigned device */
+	__u16 rec_cpu;          /* cpu # for affinity (0xffff if none) */
+	__u16 send_ctxt;        /* send context in use by this user context */
+	__u16 egrtids;          /* number of RcvArray entries for Eager Rcvs */
+	__u16 rcvhdrq_cnt;      /* number of RcvHdrQ entries */
+	__u16 rcvhdrq_entsize;  /* size (in bytes) for each RcvHdrQ entry */
+	__u16 sdma_ring_size;   /* number of entries in SDMA request ring */
+};
+
+struct hfi1_tid_info {
+	/* virtual address of first page in transfer */
+	__u64 vaddr;
+	/* pointer to tid array. this array is big enough */
+	__u64 tidlist;
+	/* number of tids programmed by this request */
+	__u32 tidcnt;
+	/* length of transfer buffer programmed by this request */
+	__u32 length;
+	/*
+	 * pointer to bitmap of TIDs used for this call;
+	 * checked for being large enough at open
+	 */
+	__u64 tidmap;
+};
+
+struct hfi1_cmd {
+	__u32 type;        /* command type */
+	__u32 len;         /* length of struct pointed to by add */
+	__u64 addr;        /* pointer to user structure */
+};
+
+enum hfi1_sdma_comp_state {
+	FREE = 0,
+	QUEUED,
+	COMPLETE,
+	ERROR
+};
+
+/*
+ * SDMA completion ring entry
+ */
+struct hfi1_sdma_comp_entry {
+	__u32 status;
+	__u32 errcode;
+};
+
+/*
+ * Device status and notifications from driver to user-space.
+ */
+struct hfi1_status {
+	__u64 dev;      /* device/hw status bits */
+	__u64 port;     /* port state and status bits */
+	char freezemsg[0];
+};
+
+/*
+ * This structure is returned by the driver immediately after
+ * open to get implementation-specific info, and info specific to this
+ * instance.
+ *
+ * This struct must have explicit pad fields where type sizes
+ * may result in different alignments between 32 and 64 bit
+ * programs, since the 64 bit * bit kernel requires the user code
+ * to have matching offsets
+ */
+struct hfi1_base_info {
+	/* version of hardware, for feature checking. */
+	__u32 hw_version;
+	/* version of software, for feature checking. */
+	__u32 sw_version;
+	/* Job key */
+	__u16 jkey;
+	__u16 padding1;
+	/*
+	 * The special QP (queue pair) value that identifies PSM
+	 * protocol packet from standard IB packets.
+	 */
+	__u32 bthqp;
+	/* PIO credit return address, */
+	__u64 sc_credits_addr;
+	/*
+	 * Base address of write-only pio buffers for this process.
+	 * Each buffer has sendpio_credits*64 bytes.
+	 */
+	__u64 pio_bufbase_sop;
+	/*
+	 * Base address of write-only pio buffers for this process.
+	 * Each buffer has sendpio_credits*64 bytes.
+	 */
+	__u64 pio_bufbase;
+	/* address where receive buffer queue is mapped into */
+	__u64 rcvhdr_bufbase;
+	/* base address of Eager receive buffers. */
+	__u64 rcvegr_bufbase;
+	/* base address of SDMA completion ring */
+	__u64 sdma_comp_bufbase;
+	/*
+	 * User register base for init code, not to be used directly by
+	 * protocol or applications.  Always maps real chip register space.
+	 * the register addresses are:
+	 * ur_rcvhdrhead, ur_rcvhdrtail, ur_rcvegrhead, ur_rcvegrtail,
+	 * ur_rcvtidflow
+	 */
+	__u64 user_regbase;
+	/* notification events */
+	__u64 events_bufbase;
+	/* status page */
+	__u64 status_bufbase;
+	/* rcvhdrtail update */
+	__u64 rcvhdrtail_base;
+	/*
+	 * shared memory pages for subctxts if ctxt is shared; these cover
+	 * all the processes in the group sharing a single context.
+	 * all have enough space for the num_subcontexts value on this job.
+	 */
+	__u64 subctxt_uregbase;
+	__u64 subctxt_rcvegrbuf;
+	__u64 subctxt_rcvhdrbuf;
+};
+
+enum sdma_req_opcode {
+	EXPECTED = 0,
+	EAGER
+};
+
+#define HFI1_SDMA_REQ_VERSION_MASK 0xF
+#define HFI1_SDMA_REQ_VERSION_SHIFT 0x0
+#define HFI1_SDMA_REQ_OPCODE_MASK 0xF
+#define HFI1_SDMA_REQ_OPCODE_SHIFT 0x4
+#define HFI1_SDMA_REQ_IOVCNT_MASK 0xFF
+#define HFI1_SDMA_REQ_IOVCNT_SHIFT 0x8
+
+struct sdma_req_info {
+	/*
+	 * bits 0-3 - version (currently unused)
+	 * bits 4-7 - opcode (enum sdma_req_opcode)
+	 * bits 8-15 - io vector count
+	 */
+	__u16 ctrl;
+	/*
+	 * Number of fragments contained in this request.
+	 * User-space has already computed how many
+	 * fragment-sized packet the user buffer will be
+	 * split into.
+	 */
+	__u16 npkts;
+	/*
+	 * Size of each fragment the user buffer will be
+	 * split into.
+	 */
+	__u16 fragsize;
+	/*
+	 * Index of the slot in the SDMA completion ring
+	 * this request should be using. User-space is
+	 * in charge of managing its own ring.
+	 */
+	__u16 comp_idx;
+} __packed;
+
+/*
+ * SW KDETH header.
+ * swdata is SW defined portion.
+ */
+struct hfi1_kdeth_header {
+	__le32 ver_tid_offset;
+	__le16 jkey;
+	__le16 hcrc;
+	__le32 swdata[7];
+} __packed;
+
+/*
+ * Structure describing the headers that User space uses. The
+ * structure above is a subset of this one.
+ */
+struct hfi1_pkt_header {
+	__le16 pbc[4];
+	__be16 lrh[4];
+	__be32 bth[3];
+	struct hfi1_kdeth_header kdeth;
+} __packed;
+
+
+/*
+ * The list of usermode accessible registers.
+ */
+enum hfi1_ureg {
+	/* (RO)  DMA RcvHdr to be used next. */
+	ur_rcvhdrtail = 0,
+	/* (RW)  RcvHdr entry to be processed next by host. */
+	ur_rcvhdrhead = 1,
+	/* (RO)  Index of next Eager index to use. */
+	ur_rcvegrindextail = 2,
+	/* (RW)  Eager TID to be processed next */
+	ur_rcvegrindexhead = 3,
+	/* (RO)  Receive Eager Offset Tail */
+	ur_rcvegroffsettail = 4,
+	/* For internal use only; max register number. */
+	ur_maxreg,
+	/* (RW)  Receive TID flow table */
+	ur_rcvtidflowtable = 256
+};
+
+#endif /* _LINIUX__HFI1_USER_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
