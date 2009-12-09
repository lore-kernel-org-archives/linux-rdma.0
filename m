From: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 01/11] RDMA/nes: change MAX_CM_BUFFER define
Date: Wed, 9 Dec 2009 14:36:40 -0600
Message-ID: <20091209203640.GA121588@flatif-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 Changed MAX_CM_BUFFER for MPA frame to be conformant to RFC 5044.
 This will change it to 512 + 20 instead of 512.
 Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>


diff --git a/drivers/infiniband/hw/nes/nes_cm.h b/drivers/infiniband/hw/nes/nes_cm.h
index 90e8e4d..2d867a6 100644
--- a/drivers/infiniband/hw/nes/nes_cm.h
+++ b/drivers/infiniband/hw/nes/nes_cm.h
@@ -47,6 +47,8 @@
 #define IEFT_MPA_KEY_REP  "MPA ID Rep Frame"
 #define IETF_MPA_KEY_SIZE 16
 #define IETF_MPA_VERSION  1
+#define IETF_MAX_PRIV_DATA_LEN 512
+#define IETF_MPA_FRAME_SIZE     20
 
 enum ietf_mpa_flags {
 	IETF_MPA_FLAGS_MARKERS = 0x80,	/* receive Markers */
@@ -169,7 +171,7 @@ struct nes_timer_entry {
 
 #define NES_CM_DEF_SEQ2      0x18ed5740
 #define NES_CM_DEF_LOCAL_ID2 0xb807
-#define	MAX_CM_BUFFER	512
+#define	MAX_CM_BUFFER	(IETF_MPA_FRAME_SIZE + IETF_MAX_PRIV_DATA_LEN)
 
 
 typedef u32 nes_addr_t;
diff --git a/drivers/infiniband/hw/nes/nes_context.h b/drivers/infiniband/hw/nes/nes_context.h
deleted file mode 100644
index 0fb8d81..0000000
--- a/drivers/infiniband/hw/nes/nes_context.h
+++ /dev/null
@@ -1,193 +0,0 @@
-/*
- * Copyright (c) 2006 - 2009 Intel-NE, Inc.  All rights reserved.
- *
- * This software is available to you under a choice of one of two
- * licenses.  You may choose to be licensed under the terms of the GNU
- * General Public License (GPL) Version 2, available from the file
- * COPYING in the main directory of this source tree, or the
- * OpenIB.org BSD license below:
- *
- *     Redistribution and use in source and binary forms, with or
- *     without modification, are permitted provided that the following
- *     conditions are met:
- *
- *      - Redistributions of source code must retain the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer.
- *
- *      - Redistributions in binary form must reproduce the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer in the documentation and/or other materials
- *        provided with the distribution.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- */
-
-#ifndef NES_CONTEXT_H
-#define NES_CONTEXT_H
-
-struct nes_qp_context {
-	__le32   misc;
-	__le32   cqs;
-	__le32   sq_addr_low;
-	__le32   sq_addr_high;
-	__le32   rq_addr_low;
-	__le32   rq_addr_high;
-	__le32   misc2;
-	__le16   tcpPorts[2];
-	__le32   ip0;
-	__le32   ip1;
-	__le32   ip2;
-	__le32   ip3;
-	__le32   mss;
-	__le32   arp_index_vlan;
-	__le32   tcp_state_flow_label;
-	__le32   pd_index_wscale;
-	__le32   keepalive;
-	u32   ts_recent;
-	u32   ts_age;
-	__le32   snd_nxt;
-	__le32   snd_wnd;
-	__le32   rcv_nxt;
-	__le32   rcv_wnd;
-	__le32   snd_max;
-	__le32   snd_una;
-	u32   srtt;
-	__le32   rttvar;
-	__le32   ssthresh;
-	__le32   cwnd;
-	__le32   snd_wl1;
-	__le32   snd_wl2;
-	__le32   max_snd_wnd;
-	__le32   ts_val_delta;
-	u32   retransmit;
-	u32   probe_cnt;
-	u32   hte_index;
-	__le32   q2_addr_low;
-	__le32   q2_addr_high;
-	__le32   ird_index;
-	u32   Rsvd3;
-	__le32   ird_ord_sizes;
-	u32   mrkr_offset;
-	__le32   aeq_token_low;
-	__le32   aeq_token_high;
-};
-
-/* QP Context Misc Field */
-
-#define NES_QPCONTEXT_MISC_IWARP_VER_MASK    0x00000003
-#define NES_QPCONTEXT_MISC_IWARP_VER_SHIFT   0
-#define NES_QPCONTEXT_MISC_EFB_SIZE_MASK     0x000000C0
-#define NES_QPCONTEXT_MISC_EFB_SIZE_SHIFT    6
-#define NES_QPCONTEXT_MISC_RQ_SIZE_MASK      0x00000300
-#define NES_QPCONTEXT_MISC_RQ_SIZE_SHIFT     8
-#define NES_QPCONTEXT_MISC_SQ_SIZE_MASK      0x00000c00
-#define NES_QPCONTEXT_MISC_SQ_SIZE_SHIFT     10
-#define NES_QPCONTEXT_MISC_PCI_FCN_MASK      0x00007000
-#define NES_QPCONTEXT_MISC_PCI_FCN_SHIFT     12
-#define NES_QPCONTEXT_MISC_DUP_ACKS_MASK     0x00070000
-#define NES_QPCONTEXT_MISC_DUP_ACKS_SHIFT    16
-
-enum nes_qp_context_misc_bits {
-	NES_QPCONTEXT_MISC_RX_WQE_SIZE         = 0x00000004,
-	NES_QPCONTEXT_MISC_IPV4                = 0x00000008,
-	NES_QPCONTEXT_MISC_DO_NOT_FRAG         = 0x00000010,
-	NES_QPCONTEXT_MISC_INSERT_VLAN         = 0x00000020,
-	NES_QPCONTEXT_MISC_DROS                = 0x00008000,
-	NES_QPCONTEXT_MISC_WSCALE              = 0x00080000,
-	NES_QPCONTEXT_MISC_KEEPALIVE           = 0x00100000,
-	NES_QPCONTEXT_MISC_TIMESTAMP           = 0x00200000,
-	NES_QPCONTEXT_MISC_SACK                = 0x00400000,
-	NES_QPCONTEXT_MISC_RDMA_WRITE_EN       = 0x00800000,
-	NES_QPCONTEXT_MISC_RDMA_READ_EN        = 0x01000000,
-	NES_QPCONTEXT_MISC_WBIND_EN            = 0x10000000,
-	NES_QPCONTEXT_MISC_FAST_REGISTER_EN    = 0x20000000,
-	NES_QPCONTEXT_MISC_PRIV_EN             = 0x40000000,
-	NES_QPCONTEXT_MISC_NO_NAGLE            = 0x80000000
-};
-
-enum nes_qp_acc_wq_sizes {
-	HCONTEXT_TSA_WQ_SIZE_4 = 0,
-	HCONTEXT_TSA_WQ_SIZE_32 = 1,
-	HCONTEXT_TSA_WQ_SIZE_128 = 2,
-	HCONTEXT_TSA_WQ_SIZE_512 = 3
-};
-
-/* QP Context Misc2 Fields */
-#define NES_QPCONTEXT_MISC2_TTL_MASK            0x000000ff
-#define NES_QPCONTEXT_MISC2_TTL_SHIFT           0
-#define NES_QPCONTEXT_MISC2_HOP_LIMIT_MASK      0x000000ff
-#define NES_QPCONTEXT_MISC2_HOP_LIMIT_SHIFT     0
-#define NES_QPCONTEXT_MISC2_LIMIT_MASK          0x00000300
-#define NES_QPCONTEXT_MISC2_LIMIT_SHIFT         8
-#define NES_QPCONTEXT_MISC2_NIC_INDEX_MASK      0x0000fc00
-#define NES_QPCONTEXT_MISC2_NIC_INDEX_SHIFT     10
-#define NES_QPCONTEXT_MISC2_SRC_IP_MASK         0x001f0000
-#define NES_QPCONTEXT_MISC2_SRC_IP_SHIFT        16
-#define NES_QPCONTEXT_MISC2_TOS_MASK            0xff000000
-#define NES_QPCONTEXT_MISC2_TOS_SHIFT           24
-#define NES_QPCONTEXT_MISC2_TRAFFIC_CLASS_MASK  0xff000000
-#define NES_QPCONTEXT_MISC2_TRAFFIC_CLASS_SHIFT 24
-
-/* QP Context Tcp State/Flow Label Fields */
-#define NES_QPCONTEXT_TCPFLOW_FLOW_LABEL_MASK   0x000fffff
-#define NES_QPCONTEXT_TCPFLOW_FLOW_LABEL_SHIFT  0
-#define NES_QPCONTEXT_TCPFLOW_TCP_STATE_MASK    0xf0000000
-#define NES_QPCONTEXT_TCPFLOW_TCP_STATE_SHIFT   28
-
-enum nes_qp_tcp_state {
-	NES_QPCONTEXT_TCPSTATE_CLOSED = 1,
-	NES_QPCONTEXT_TCPSTATE_EST = 5,
-	NES_QPCONTEXT_TCPSTATE_TIME_WAIT = 11,
-};
-
-/* QP Context PD Index/wscale Fields */
-#define NES_QPCONTEXT_PDWSCALE_RCV_WSCALE_MASK  0x0000000f
-#define NES_QPCONTEXT_PDWSCALE_RCV_WSCALE_SHIFT 0
-#define NES_QPCONTEXT_PDWSCALE_SND_WSCALE_MASK  0x00000f00
-#define NES_QPCONTEXT_PDWSCALE_SND_WSCALE_SHIFT 8
-#define NES_QPCONTEXT_PDWSCALE_PDINDEX_MASK     0xffff0000
-#define NES_QPCONTEXT_PDWSCALE_PDINDEX_SHIFT    16
-
-/* QP Context Keepalive Fields */
-#define NES_QPCONTEXT_KEEPALIVE_DELTA_MASK      0x0000ffff
-#define NES_QPCONTEXT_KEEPALIVE_DELTA_SHIFT     0
-#define NES_QPCONTEXT_KEEPALIVE_PROBE_CNT_MASK  0x00ff0000
-#define NES_QPCONTEXT_KEEPALIVE_PROBE_CNT_SHIFT 16
-#define NES_QPCONTEXT_KEEPALIVE_INTV_MASK       0xff000000
-#define NES_QPCONTEXT_KEEPALIVE_INTV_SHIFT      24
-
-/* QP Context ORD/IRD Fields */
-#define NES_QPCONTEXT_ORDIRD_ORDSIZE_MASK       0x0000007f
-#define NES_QPCONTEXT_ORDIRD_ORDSIZE_SHIFT      0
-#define NES_QPCONTEXT_ORDIRD_IRDSIZE_MASK       0x00030000
-#define NES_QPCONTEXT_ORDIRD_IRDSIZE_SHIFT      16
-#define NES_QPCONTEXT_ORDIRD_IWARP_MODE_MASK    0x30000000
-#define NES_QPCONTEXT_ORDIRD_IWARP_MODE_SHIFT   28
-
-enum nes_ord_ird_bits {
-	NES_QPCONTEXT_ORDIRD_WRPDU                   = 0x02000000,
-	NES_QPCONTEXT_ORDIRD_LSMM_PRESENT            = 0x04000000,
-	NES_QPCONTEXT_ORDIRD_ALSMM                   = 0x08000000,
-	NES_QPCONTEXT_ORDIRD_AAH                     = 0x40000000,
-	NES_QPCONTEXT_ORDIRD_RNMC                    = 0x80000000
-};
-
-enum nes_iwarp_qp_state {
-	NES_QPCONTEXT_IWARP_STATE_NONEXIST  = 0,
-	NES_QPCONTEXT_IWARP_STATE_IDLE      = 1,
-	NES_QPCONTEXT_IWARP_STATE_RTS       = 2,
-	NES_QPCONTEXT_IWARP_STATE_CLOSING   = 3,
-	NES_QPCONTEXT_IWARP_STATE_TERMINATE = 5,
-	NES_QPCONTEXT_IWARP_STATE_ERROR     = 6
-};
-
-
-#endif		/* NES_CONTEXT_H */
-- 
1.5.3.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
