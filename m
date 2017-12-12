From: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH RFC] Introduce verbs API for multi-packet work request
Date: Tue, 12 Dec 2017 23:15:36 +0200
Message-ID: <CAFgAxU-rJb6mvH_XRt0S5_-wKwv3rOnweiLJ8WSuc=9F+P0BrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Guy Levi(SW)" <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Alex @ Mellanox" <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This RFC patch introduces a libibverbs API for receiving multiple packets
on a single work request (aka: "MP WR").

Traditional verbs work request maps a single WR to a single received
message. The entire WR buffer is consumed, regardless of the ingress
message size. The WR has a single completion, which reports the message
length and some additional flags and/or values.
Some limitations of the traditional WR include:
1. If the ingress message is much smaller than the WR buffer, the buffer
   memory is not well utilized.
2. If the ingress message is larger than the WR buffer, the QP might
   transition to error or the message might be dropped.

The motivation for a MP WR is to enable:
1. High efficiency of receive buffer memory utilization by:
 a. Allowing multiple ingress packets to be written in a single WR
    buffer, into different memory parts of the entire WR buffer.
    Each packet start offset in the buffer will be according to a packet
    alignment size defined by user. The packet alignment size can be equal
    to cache line size, a page size, or other desired application logic
    values. A packet can be delivered while consuming multiple aligned
    memory segments. This allows multiple different packet sizes to be
    received within a single MP WR buffer.
    Work completions are generated for the received data similar to when
    completions are generated for a traditional work request.
 b. Allowing a FIRST and MIDDLE packets to be writen to WR memory in a
    dis-contiguous fashion. This allows very large transfers to MP WRs QPs
    without having to increase the WR buffer size to the largest possible
    message length.
    After any FIRST or MIDDLE packet the hardware can write a CQE with the
    'MORE_IN_MSG' flag to indicate it is not the end of the logical transfer.
    The entire message, built from the multi-packet completions, can span
    over multiple work request.
2. Improved device PCI utilization: device PCI fetch of a single WR entry
   can handle multiple packets, rather than having to fetch WR entires for
   each received packet as is traditionally required.

Definitions of verbs MP WR:
- MP WR capability is supported by a device when struct ibv_mp_wr_caps
  values are greater than zero bytes, both max_wr_buffer_sz and
  max_packet_align_sz.
- MP WR receive queue can be defined for a QP, SRQ, or WQ (of type RQ).
- A MP WR is defined with struct ibv_mp_wr_caps, by its WR buffer size
  and the packet alignment size (both in bytes). User sets the requested
  values during object creation, and the returned values are the actual
  values used by provider library (equal or greater from user
  requested). All post receive must have same size WR buffers, matching
  the buffer size specified during creation.
- A MP WR requires additional completion flags. For this, the QP, SRQ or
  WQ must be created with an extended CQ using ibv_create_cq_ex() with the
  IBV_WC_EX_WITH_MP_WR flag.
- The reported MP WR completion flags include:
  a. IBV_WC_MP_WR_MORE_IN_MSG: is reported by a multi-packet work
     request that has more packet completions expected in this message for
     this qp_num. This is set after receiving a FIRST or MIDDLE packet
     into the WR.
  b. IBV_WC_MP_WR_CONSUMED: is reported once an entire multi-packet
     work request buffer is consumed, so that user knows the device releases
     ownership of that wr_id and buffer. IBV_WC_RECV_NOP opcode is reported
     in WC for a 'consumed' WR that is without a received message.
- The byte offset in the work request buffer for the start of a specific logical
  transfer is report by ibv_wc_read_mp_wr_offset(). This may be the start of a
  complete full packet, or the start of a FIRST, MIDDLE or LAST segment.

Application Notes:
- When using the MP WR, multiple packets can be reported for each wr_id. In
this case the wr_id reflects the MP WR buffer submitted to the hardware by
the application can be repeated for multiple completions. Application's will
need to use different logic around with wr_id to support MP WR.
- It's the user's responsibility to reconstruct the full packet if it was
segmented across multiple WC buffers, and across multiple WR buffers.

Example A:
1. Create MP WR QP with:
   - wr_buffer_sz = 64 KB
   - packet_align_sz = 512 bytes
2. Lets assume MTU is 4 KB
3. In which case each wr can receive
   a. 128 RDMA messages of 512 bytes each until WR is entirely consumed.
   b. A 12,000 bytes RDMA message will report up to 3 WCs. FIRST and
      MIDDLE packets have 2 WC's with MP_WR_MORE_IN_MSG of length 4,096 bytes,
      ending in a WC with 3808 bytes. WR will still have 52 KB left for
      ingress packets handling before reporting MP_WR_CONSUMED.

Example B:
1. Create MP WR QP with:
   - wr_buffer_sz = 1 MB
   - packet_align_sz = 4 KB
2. Lets assume MTU is 4 KB
3. In which case each WR can receive up to 256 packets. We cut the post_recv
and PCI WR fetch by a factor of 1:250.
Packets are received in page (4K) alignment.

Issue: 1215816
Change-Id: I8f9cca81c7c70d79f2bbf25401f62b06e4f61b27
Signed-off-by: Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/man/ibv_create_cq_ex.3    | 22 +++++++++++++++++++-
 libibverbs/man/ibv_create_qp_ex.3    | 40 ++++++++++++++++++++++++++++++++----
 libibverbs/man/ibv_create_srq_ex.3   | 33 ++++++++++++++++++++++++++++-
 libibverbs/man/ibv_create_wq.3       | 34 +++++++++++++++++++++++++++++-
 libibverbs/man/ibv_query_device_ex.3 |  9 ++++++++
 libibverbs/verbs.h                   | 35 ++++++++++++++++++++++++++++---
 6 files changed, 163 insertions(+), 10 deletions(-)

diff --git a/libibverbs/man/ibv_create_cq_ex.3
b/libibverbs/man/ibv_create_cq_ex.3
index 23f867c..6c61baa 100644
--- a/libibverbs/man/ibv_create_cq_ex.3
+++ b/libibverbs/man/ibv_create_cq_ex.3
@@ -43,6 +43,7 @@ enum ibv_wc_flags_ex {
         IBV_WC_EX_WITH_COMPLETION_TIMESTAMP  = 1 << 7,  /* Require
completion timestamp in WC /*
         IBV_WC_EX_WITH_CVLAN                 = 1 << 8,  /* Require
VLAN info in WC */
         IBV_WC_EX_WITH_FLOW_TAG      = 1 << 9,  /* Require flow tag in WC */
+        IBV_WC_EX_WITH_MP_WR                 = 1 << 10, /* Require
multi-packet WR reporting offset and additional flags */
 };

 enum ibv_cq_init_attr_mask {
@@ -117,7 +118,7 @@ Below members and functions are used in order to
poll the current completion. Th
  Get the source QP number field from the current completion.

 .BI "int ibv_wc_read_wc_flags(struct ibv_cq_ex " "*cq"); \c
- Get the QP flags field from the current completion.
+ Get the QP flags field from the current completion as defined in ibv_wc_flags.

 .BI "uint16_t ibv_wc_read_pkey_index(struct ibv_cq_ex " "*cq"); \c
  Get the pkey index field from the current completion.
@@ -150,7 +151,11 @@ uint64_t tag;  /* tag from TMH */
 uint32_t priv; /* opaque user data from TMH */
 .in -8
 };
+.nf
+.fi

+.BI "size_t ibv_wc_read_mp_wr_offset(struct ibv_cq_ex " *cq ",); \c
+ Get the bytes offset from start of buffer for a multi-packet work request.
 .SH "RETURN VALUE"
 .B ibv_create_cq_ex()
 returns a pointer to the CQ, or NULL if the request fails.
@@ -158,6 +163,19 @@ returns a pointer to the CQ, or NULL if the request fails.
 .B ibv_create_cq_ex()
 may create a CQ with size greater than or equal to the requested
 size. Check the cqe attribute in the returned CQ for the actual size.
+.TP
+Reported work completion flags:
+
+.B IBV_WC_MP_WR_MORE_IN_MSG \c
+is reported by a multi-packet WR that has more packet completions expected
+in this message for this qp_num.
+
+.B IBV_WC_MP_WR_CONSUMED \c
+is reported once the entire WR buffer of a multi-packet WR is consumed, so
+that user knows the device releases ownership of that wr_id and buffer.
+IBV_WC_RECV_NOP opcode is reported in WC for a 'consumed' WR that is without
+data.
+
 .PP
 CQ should be destroyed with ibv_destroy_cq.
 .PP
@@ -171,3 +189,5 @@ CQ should be destroyed with ibv_destroy_cq.
 .SH "AUTHORS"
 .TP
 Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+.TP
+Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/libibverbs/man/ibv_create_qp_ex.3
b/libibverbs/man/ibv_create_qp_ex.3
index bb2d1b6..f1a7c84 100644
--- a/libibverbs/man/ibv_create_qp_ex.3
+++ b/libibverbs/man/ibv_create_qp_ex.3
@@ -39,6 +39,7 @@ uint16_t                max_tso_header; /* Maximum
TSO header size */
 struct ibv_rwq_ind_table *rwq_ind_tbl;  /* Indirection table to be
associated with the QP */
 struct ibv_rx_hash_conf  rx_hash_conf;  /* RX hash configuration to be used */
 uint32_t                source_qpn;     /* Source QP number, creation
flag IBV_QP_CREATE_SOURCE_QPN should be set, few NOTEs below */
+struct ibv_mp_wr_attr  *mp_wr;          /* with
IBV_QP_INIT_ATTR_MP_WR (not valid with ibv_srq) */
 .in -8
 };
 .sp
@@ -52,6 +53,7 @@ uint32_t                max_recv_sge;   /* Requested
max number of s/g elements
 uint32_t                max_inline_data;/* Requested max number of
data (bytes) that can be posted inline to the SQ, otherwise 0 */
 .in -8
 };
+.sp
 .nf
 enum ibv_qp_create_flags {
 .in +8
@@ -62,6 +64,7 @@ IBV_QP_CREATE_SOURCE_QPN                = 1 << 10,
/* The created QP will use th
 IBV_QP_CREATE_PCI_WRITE_END_PADDING     = 1 << 11, /* Incoming
packets will be padded to cacheline size */
 .in -8
 };
+.sp
 .nf
 struct ibv_rx_hash_conf {
 .in +8
@@ -71,8 +74,7 @@ uint8_t                *rx_hash_key;           /* RX
hash key data */
 uint64_t               rx_hash_fields_mask;    /* RX fields that
should participate in the hashing, use enum ibv_rx_hash_fields */
 .in -8
 };
-.fi
-
+.sp
 .nf
 enum ibv_rx_hash_fields {
 .in +8
@@ -90,15 +92,43 @@ IBV_RX_HASH_DST_PORT_UDP        = 1 << 7,
 IBV_RX_HASH_INNER = (1UL << 31),
 .in -8
 };
+.sp
+.nf
+struct ibv_mp_wr_attr {
+.in +8
+size_t                  wr_buffer_sz;    /* buffer size for a single wr */
+uint32_t                packet_align_sz; /* alignment size for new packet */
+.in -8
+};
+.nf
 .fi
-
+.PP
+A QP can be created with support for multi-packet work requests by setting
+the IBV_QP_INIT_ATTR_MP_WR in the
+.I comp_mask\fR.
+A multi-packet work request can receive multiple packets within a single
+ibv_recv_wr. The max number of packets a single MP_WR will receive is
+determined by the size of the
+.I wr_buffer_sz
+divided by the
+.I packet_align_sz\fR,
+which defines the number of aligned segments.
+Multiple completions can be generated for a single ibv_recv_wr. ibv_wc_flags
+will report the extra MP_WR completion flags and ibv_wc_read_mp_wr_offset()
+will report the bytes offset in the buffer of the respectful ibv_recv_wr.
+.I cq
+must be created with an extended CQ using IBV_WC_EX_WITH_MP_WR flag in order
+to handle the additional multi-packet WR's info.
 .PP
 The function
 .B ibv_create_qp_ex()
 will update the
 .I qp_init_attr_ex\fB\fR->cap
 struct with the actual \s-1QP\s0 values of the QP that was created;
-the values will be greater than or equal to the values requested.
+the values will be greater than or equal to the values requested.
Similarly, the
+.I mp_wr
+values, wr_buffer_sz and packet_align_sz, will get updated with greater than or
+equal to the values requested.
 .PP
 .B ibv_destroy_qp()
 destroys the QP
@@ -128,3 +158,5 @@ fails if the QP is attached to a multicast group.
 .SH "AUTHORS"
 .TP
 Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+.TP
+Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/libibverbs/man/ibv_create_srq_ex.3
b/libibverbs/man/ibv_create_srq_ex.3
index 97529ae..e720e1a 100644
--- a/libibverbs/man/ibv_create_srq_ex.3
+++ b/libibverbs/man/ibv_create_srq_ex.3
@@ -31,6 +31,7 @@ struct ibv_pd          *pd;             /* PD
associated with the SRQ */
 struct ibv_xrcd        *xrcd;           /* XRC domain to associate
with the SRQ */
 struct ibv_cq          *cq;             /* CQ to associate with the
SRQ for XRC mode */
 struct ibv_tm_cap       tm_cap;         /* Tag matching attributes */
+struct ibv_mp_wr_attr  *mp_wr;          /* with IBV_SRQ_INIT_ATTR_MP_WR */
 .in -8
 };
 .sp
@@ -52,15 +53,43 @@ uint32_t                max_ops;        /* Number
of outstanding tag list operat
 };
 .sp
 .nf
+struct ibv_mp_wr_attr {
+.in +8
+size_t                  wr_buffer_sz;    /* buffer size for a single wr */
+uint32_t                packet_align_sz; /* alignment size for new packet */
+.in -8
+};
+.sp
+.nf
 .fi
 .PP
+A SRQ can be created with support for multi-packet work requests by setting
+the IBV_SRQ_INIT_ATTR_MP_WR in the
+.I comp_mask\fR.
+A multi-packet work request can receive multiple packets within a single
+ibv_recv_wr. The max number of packets a single MP_WR will receive is
+determined by the size of the
+.I wr_buffer_sz
+divided by the
+.I packet_align_sz\fR,
+which defines the number of aligned segments.
+Multiple completions can be generated for a single ibv_recv_wr. ibv_wc_flags
+will report the extra MP_WR completion flags and ibv_wc_read_mp_wr_offset()
+will report the bytes offset in the buffer of the respectful ibv_recv_wr.
+.I cq
+must be created with an extended CQ using IBV_WC_EX_WITH_MP_WR flag in order
+to handle the additional multi-packet WR's info.
+.PP
 The function
 .B ibv_create_srq_ex()
 will update the
 .I srq_init_attr_ex
 struct with the original values of the SRQ that was created; the
 values of max_wr and max_sge will be greater than or equal to the
-values requested.
+values requested. Similarly, the
+.I mp_wr
+values, wr_buffer_sz and packet_align_sz, will get updated with greater than or
+equal to the values requested.
 .PP
 .B ibv_destroy_srq()
 destroys the SRQ
@@ -81,3 +110,5 @@ fails if any queue pair is still associated with this SRQ.
 .SH "AUTHORS"
 .TP
 Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+.TP
+Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/libibverbs/man/ibv_create_wq.3 b/libibverbs/man/ibv_create_wq.3
index 10fe965..3f43d44 100644
--- a/libibverbs/man/ibv_create_wq.3
+++ b/libibverbs/man/ibv_create_wq.3
@@ -32,6 +32,7 @@ struct  ibv_pd            *pd;            /* PD to
be associated with the WQ */
 struct  ibv_cq            *cq;            /* CQ to be associated with the WQ */
 uint32_t                   comp_mask;     /* Identifies valid fields.
Use ibv_wq_init_attr_mask */
 uint32_t                   create_flags    /* Creation flags for this
WQ, use enum ibv_wq_flags */
+struct ibv_mp_wr_attr     *mp_wr;         /* with IBV_WQ_INIT_ATTR_MP_WR */
 .in -8
 };

@@ -46,8 +47,33 @@ IBV_WQ_FLAGS_PCI_WRITE_END_PADDING      = 1 << 3,
/* Incoming packets will be pa
 IBV_WQ_FLAGS_RESERVED                   = 1 << 4,
 .in -8
 };
+.sp
+.nf
+struct ibv_mp_wr_attr {
+.in +8
+size_t                  wr_buffer_sz;    /* buffer size for a single wr */
+uint32_t                packet_align_sz; /* alignment size for new packet */
+.in -8
+};
+.sp
 .nf
 .fi
+A IBV_WQT_RQ can be created with support for multi-packet work requests by
+setting the IBV_WQ_INIT_ATTR_MP_WR in the
+.I comp_mask\fR.
+A multi-packet work request can receive multiple packets within a single
+ibv_recv_wr. The max number of packets a single MP_WR will receive is
+determined by the size of the
+.I wr_buffer_sz
+divided by the
+.I packet_align_sz\fR,
+which defines the number of aligned segments.
+Multiple completions can be generated for a single ibv_recv_wr. ibv_wc_flags
+will report the extra MP_WR completion flags and ibv_wc_read_mp_wr_offset()
+will report the bytes offset in the buffer of the respectful ibv_recv_wr.
+.I cq
+must be created with an extended CQ using IBV_WC_EX_WITH_MP_WR flag in order
+to handle the additional multi-packet WR's info.
 .PP
 The function
 .B ibv_create_wq()
@@ -56,7 +82,10 @@ will update the
 and
 .I wq_init_attr\fB\fR->max_sge
 fields with the actual \s-1WQ\s0 values of the WQ that was created;
-the values will be greater than or equal to the values requested.
+the values will be greater than or equal to the values requested.
Similarly, the
+.I mp_wr
+values, wr_buffer_sz and packet_align_sz, will get updated with greater than or
+equal to the values requested.
 .PP
 .B ibv_destroy_wq()
 destroys the WQ
@@ -72,3 +101,6 @@ returns 0 on success, or the value of errno on
failure (which indicates the fail
 .SH "AUTHORS"
 .TP
 Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+.TP
+Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+
diff --git a/libibverbs/man/ibv_query_device_ex.3
b/libibverbs/man/ibv_query_device_ex.3
index 1172523..88f25f3 100644
--- a/libibverbs/man/ibv_query_device_ex.3
+++ b/libibverbs/man/ibv_query_device_ex.3
@@ -35,6 +35,7 @@ struct ibv_packet_pacing_caps packet_pacing_caps; /*
Packet pacing capabilities
 uint32_t               raw_packet_caps;            /* Raw packet
capabilities, use enum ibv_raw_packet_caps */
 struct ibv_tm_caps     tm_caps;                    /* Tag matching
capabilities */
 struct ibv_cq_moderation_caps  cq_mod_caps;        /* CQ moderation
max capabilities */
+struct ibv_mp_wr_caps  mp_wr_caps;                 /* Multi-packet
work request capabilities */
 .in -8
 };

@@ -106,6 +107,14 @@ struct ibv_cq_moderation_caps {
  uint16_t max_cq_count;
  uint16_t max_cq_period;
 };
+
+struct ibv_mp_wr_caps {
+.in +8
+size_t                  max_wr_buffer_sz;    /* max buffer size for a
single wr */
+uint32_t                max_packet_align_sz; /* max alignment size
for new packet */
+.in -8
+};
+
 .fi

 Extended device capability flags (device_cap_flags_ex):
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 0785c77..6f36465 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -288,6 +288,11 @@ struct ibv_cq_moderation_caps {
  uint16_t max_cq_period; /* in micro seconds */
 };

+struct ibv_mp_wr_caps {
+ size_t max_wr_buffer_sz;    /* max buffer size for a single wr */
+ uint32_t max_packet_align_sz; /* max alignment size for new packet */
+};
+
 struct ibv_device_attr_ex {
  struct ibv_device_attr orig_attr;
  uint32_t comp_mask;
@@ -302,6 +307,7 @@ struct ibv_device_attr_ex {
  uint32_t raw_packet_caps; /* Use ibv_raw_packet_caps */
  struct ibv_tm_caps tm_caps;
  struct ibv_cq_moderation_caps  cq_mod_caps;
+ struct ibv_mp_wr_caps mp_wr_caps;
 };

 enum ibv_mtu {
@@ -460,6 +466,8 @@ enum ibv_wc_opcode {
  IBV_WC_TM_SYNC,
  IBV_WC_TM_RECV,
  IBV_WC_TM_NO_TAG,
+
+ IBV_WC_RECV_NOP,
 };

 enum {
@@ -478,6 +486,7 @@ enum ibv_create_cq_wc_flags {
  IBV_WC_EX_WITH_CVLAN = 1 << 8,
  IBV_WC_EX_WITH_FLOW_TAG = 1 << 9,
  IBV_WC_EX_WITH_TM_INFO = 1 << 10,
+ IBV_WC_EX_WITH_MP_WR = 1 << 11,
 };

 enum {
@@ -506,6 +515,8 @@ enum ibv_wc_flags {
  IBV_WC_TM_SYNC_REQ = 1 << 4,
  IBV_WC_TM_MATCH = 1 << 5,
  IBV_WC_TM_DATA_VALID = 1 << 6,
+ IBV_WC_MP_WR_MORE_IN_MSG= 1 << 7,
+ IBV_WC_MP_WR_CONSUMED = 1 << 8,
 };

 struct ibv_wc {
@@ -702,7 +713,8 @@ enum ibv_srq_init_attr_mask {
  IBV_SRQ_INIT_ATTR_XRCD = 1 << 2,
  IBV_SRQ_INIT_ATTR_CQ = 1 << 3,
  IBV_SRQ_INIT_ATTR_TM = 1 << 4,
- IBV_SRQ_INIT_ATTR_RESERVED = 1 << 5,
+ IBV_SRQ_INIT_ATTR_MP_WR = 1 << 5,
+ IBV_SRQ_INIT_ATTR_RESERVED = 1 << 6,
 };

 struct ibv_tm_cap {
@@ -710,6 +722,12 @@ struct ibv_tm_cap {
  uint32_t max_ops;
 };

+struct ibv_mp_wr_attr {
+ size_t wr_buffer_sz;    /* buffer size for a single wr */
+ uint32_t packet_align_sz; /* alignment size for new packet */
+};
+
+
 struct ibv_srq_init_attr_ex {
  void        *srq_context;
  struct ibv_srq_attr attr;
@@ -720,6 +738,7 @@ struct ibv_srq_init_attr_ex {
  struct ibv_xrcd        *xrcd;
  struct ibv_cq        *cq;
  struct ibv_tm_cap tm_cap;
+ struct ibv_mp_wr_attr  *mp_wr; /* with IBV_SRQ_INIT_ATTR_MP_WR */
 };

 enum ibv_wq_type {
@@ -728,7 +747,8 @@ enum ibv_wq_type {

 enum ibv_wq_init_attr_mask {
  IBV_WQ_INIT_ATTR_FLAGS = 1 << 0,
- IBV_WQ_INIT_ATTR_RESERVED = 1 << 1,
+ IBV_WQ_INIT_ATTR_MP_WR = 1 << 1,
+ IBV_WQ_INIT_ATTR_RESERVED = 1 << 2,
 };

 enum ibv_wq_flags {
@@ -748,6 +768,7 @@ struct ibv_wq_init_attr {
  struct ibv_cq        *cq;
  uint32_t comp_mask; /* Use ibv_wq_init_attr_mask */
  uint32_t create_flags; /* use ibv_wq_flags */
+ struct ibv_mp_wr_attr  *mp_wr; /* with IBV_WQ_INIT_ATTR_MP_WR */
 };

 enum ibv_wq_state {
@@ -837,7 +858,8 @@ enum ibv_qp_init_attr_mask {
  IBV_QP_INIT_ATTR_MAX_TSO_HEADER = 1 << 3,
  IBV_QP_INIT_ATTR_IND_TABLE = 1 << 4,
  IBV_QP_INIT_ATTR_RX_HASH = 1 << 5,
- IBV_QP_INIT_ATTR_RESERVED = 1 << 6
+ IBV_QP_INIT_ATTR_MP_WR = 1 << 6,
+ IBV_QP_INIT_ATTR_RESERVED = 1 << 7
 };

 enum ibv_qp_create_flags {
@@ -874,6 +896,7 @@ struct ibv_qp_init_attr_ex {
  struct ibv_rwq_ind_table       *rwq_ind_tbl;
  struct ibv_rx_hash_conf rx_hash_conf;
  uint32_t source_qpn;
+ struct ibv_mp_wr_attr  *mp_wr; /* with IBV_QP_INIT_ATTR_MP_WR (not
valid with ibv_srq) */
 };

 enum ibv_qp_open_attr_mask {
@@ -1209,6 +1232,7 @@ struct ibv_cq_ex {
  uint32_t (*read_flow_tag)(struct ibv_cq_ex *current);
  void (*read_tm_info)(struct ibv_cq_ex *current,
       struct ibv_wc_tm_info *tm_info);
+ size_t  (*read_mp_wr_offset)(struct ibv_cq_ex *cq);
 };

 static inline struct ibv_cq *ibv_cq_ex_to_cq(struct ibv_cq_ex *cq)
@@ -1327,6 +1351,11 @@ static inline void ibv_wc_read_tm_info(struct
ibv_cq_ex *cq,
  cq->read_tm_info(cq, tm_info);
 }

+static inline size_t ibv_wc_read_mp_wr_offset(struct ibv_cq_ex *cq)
+{
+ return cq->read_mp_wr_offset(cq);
+}
+
 static inline int ibv_post_wq_recv(struct ibv_wq *wq,
     struct ibv_recv_wr *recv_wr,
     struct ibv_recv_wr **bad_recv_wr)
-- 
1.8.3.1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
