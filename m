From: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC rdma-core 2/2] verbs: Introduce non-contiguous memory registration
Date: Thu,  4 Jan 2018 19:47:26 +0200
Message-ID: <1515088046-26605-2-git-send-email-alexma@mellanox.com>
References: <1515088046-26605-1-git-send-email-alexma@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1515088046-26605-1-git-send-email-alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/man/ibv_mr_set_layout_interleaved.3 | 232 +++++++++++++++++++++++++
 libibverbs/man/ibv_mr_set_layout_sg.3          | 153 ++++++++++++++++
 libibverbs/man/ibv_reg_mr.3                    |   2 +
 libibverbs/man/ibv_rereg_mr.3                  |   2 +
 libibverbs/verbs.h                             |  80 +++++++++
 5 files changed, 469 insertions(+)
 create mode 100644 libibverbs/man/ibv_mr_set_layout_interleaved.3
 create mode 100644 libibverbs/man/ibv_mr_set_layout_sg.3

diff --git a/libibverbs/man/ibv_mr_set_layout_interleaved.3 b/libibverbs/man/ibv_mr_set_layout_interleaved.3
new file mode 100644
index 0000000..93f5768
--- /dev/null
+++ b/libibverbs/man/ibv_mr_set_layout_interleaved.3
@@ -0,0 +1,232 @@
+.\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
+.\"
+.TH IBV_MR_SET_LAYOUT_INTERLEAVED 3 2016-03-13 libibverbs "Libibverbs Programmer's Manual"
+.SH "NAME"
+ibv_mr_set_layout_interleaved \- register an interleaved (non-contiguous) memory region (MR)
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/verbs.h>
+.sp
+.BI "int ibv_mr_set_layout_interleaved(struct ibv_mr " "*mr" ", int " "flags" ", int " "num_interleaved",
+.BI "                             struct ibv_mr_interleaved * " "interleaved_list");
+.fi
+.fi
+.SH "DESCRIPTION"
+The
+.B ibv_mr_set_layout_interleaved()
+function registers a non-contiguous memory layout to the given memory region (MR).
+Such memory layout is described by a repeating pattern of contiguous ranges
+within one or more MRs. Once this registration is valid, a send or recieve operation
+can alternate between those MRs by using a single local or remote key.
+.PP
+.I mr\fR
+is the result of a successful call to ibv_reg_mr(), and will be bound to the new
+memory layout. Creating an MR strictly for non-contiguous registration could be
+expadited by requesting zero length in ibv_reg_mr(). The same MR could be reused
+for multiple calls - each overriding the previous.
+.PP
+.I flags\fR
+is a bit-mask of optional modifiers. Flags should be a combination (bit field) of:
+.PP
+.br
+.B IBV_MR_SET_LAYOUT_AVOID_INVALIDATION \fR Prevent MR key invalidation (see Notes).
+.PP
+.I num_interleaved\fR
+is the size of the array describing the memory layout.
+.PP
+The argument
+.I interleaved_list\fR
+is an ibv_mr_interleaved struct, as defined in <infiniband/verbs.h>. Each entry
+refers to a pattern of items, or datum, and the resulting MR would take one datum
+from each entry in a Round-robin fashion. The MRs passed as arguments in interleaved_list
+could also be non-contiguous, as a result to previous calls to ibv_mr_set_layout_sg()
+or ibv_mr_set_layout_interleaved() on them. This case creates a nested definition of
+a non-contiguous memory layout, and it is supported up to a nesting level stated
+in max_mr_nesting_level inside struct ibv_mr_set_layout_caps.
+.PP
+Each entry is describes a pattern as follows:
+.nf
+
+struct ibv_mr_layout_interleaved {
+.in +8
+struct ibv_sge                                first_datum;    /* description of the first single item */
+int                                           num_repeated;   /* number of times to repeat this struct */
+int                                           num_dimensions; /* size of the dimensions array */
+struct ibv_mr_layout_interleved_dimensions    *dims;
+.in -8
+}
+.fi
+.PP
+In case
+.I num_repeated\fR > 1
+, which is only supported if IBV_MR_SET_LAYOUT_INTERLEAVED_REPEAT appears in cap_flags
+inside struct ibv_mr_set_layout_caps, means this entry would be visited this amount of
+of times consecutively on each round-robin cycle. This is the equivalent of
+duplicating an entry in the array. If IBV_MR_SET_LAYOUT_INTERLEAVED_NONUNIFORM_REPEAT
+also appears,
+.I num_repeated\fR
+may vary between entries.
+.PP
+.I num_dimensions\fR
+determines the length of the following
+.I dims\fR
+array, and is intended for multi-dimnetional data-structures such as a matrix.
+For example, a column in a 3D matrix could be described as with num_dimentions=2.
+.nf
+
+struct ibv_mr_layout_interleved_dimensions {
+.in +8
+uint64_t                               offset_stride;  /* Distance between two consecutive item base pointers */
+uint64_t                               datum_count;    /* Number of consecutive items */
+.in -8
+}
+.fi
+.PP
+Each dimention contains
+.I offset_stride\fR
+, which is the distance between the start of two consecutive datum, and
+.I datum_count\fR
+, which is the number of datum for this dimension.
+In the typical case,
+.I datum_count\fR
+would be the number of items at that MR, and
+.I offset_stride\fR
+would be the size of each item plus the distance to the next item. In multi-dimensional
+cases, the second dimension describes the number of times the first dimension appears,
+and how far away between two such appearances.
+.PP
+After a successful call, the new MR has to be bound before it could be used.
+A call to ibv_post_send() with the opcode IBV_WR_BIND_MR would bind the MR
+(usable after WR completion or in the following WRs on the same QP).
+.PP
+To clarify the pattern description, below is the pseduo-code for reading a pattern
+in a simple single-dimension case:
+.nf
+
+        foreach(entry in interleaved_list):
+                foreach(i from 0 to num_repeated):
+                        Read from entry.first_datum.addr (entry.first_datum.length Bytes)
+                        entry.first_datum.addr += entry.dims[0].offset_stride
+.fi
+.SH "RETURN VALUE"
+.B ibv_mr_set_layout_interleaved()
+returns 0 on success, otherwise an error has occurred,
+.I enum ibv_mr_set_layout_err_code\fR
+represents the error as listed below:
+.br
+IBV_MR_SET_LAYOUT_ERR_INPUT - Old MR is valid, an input error was detected by libibverbs.
+.br
+IBV_MR_SET_LAYOUT_ERR_WOULD_INVALIDATE - MR requires invalidation, but IBV_MR_SET_LAYOUT_AVOID_INVALIDATION was given.
+.br
+IBV_MR_SET_LAYOUT_ERR_UNSUPPORTED - Input requires a capability not supported (see
+.I struct ibv_mr_layout_caps\fR).
+.SH "EXAMPLES"
+The following code example demonstrates non-contiguous memory registration,
+along with the WR-based completion semantic. This example swaps the items with
+the odd indexes with with the even when sending (without actually changing
+memory contents):
+.PP
+.nf
+contig_mr = ibv_reg_mr(pd, addr, item_len * 100, 0);
+if (!contig_mr) {
+        fprintf(stderr, "Failed to create contiguous MR\en");
+        return 1;
+}
+
+noncontig_mr = ibv_reg_mr(pd, NULL, 0, IBV_ACCESS_ZERO_BASED);
+if (!noncontig_mr) {
+        fprintf(stderr, "Failed to create non-contiguous MR\en");
+        return 1;
+}
+
+struct ibv_mr_interleved_dimensions mr_ilv_dim =
+{
+    .offset_stride = 2 * item_len, /* after item[x] take item[x+2] */
+    .datum_count = 50
+};
+
+struct ibv_mr_interleaved mr_ilv[2] =
+{
+        {
+                .first_datum =
+                {
+                        .addr = item_len, /* start with item[1] */
+                        .length = item_len,
+                        .lkey = contig_mr->lkey
+                },
+                num_repeated = 1,
+                num_dimensions = 1,
+                dims = &mr_ilv_dim
+        },
+        {
+                .first_datum =
+                {
+                        .addr = 0, /* start with item[0] */
+                        .length = item_len,
+                        .lkey = contig_mr->lkey
+                },
+                num_repeated = 1,
+                num_dimensions = 1,
+                dims = &mr_ilv_dim
+        },
+};
+
+ret = ibv_mr_set_layout_interleaved(noncontig_mr, 0, 2, mr_ilv);
+if (ret) {
+        fprintf(stderr, "Non-contiguous registration failed\en");
+        return 1;
+}
+
+struct ibv_sge interleaved =
+{
+        .addr = 0,
+        .length = item_len * 100,
+        .lkey = noncontig_mr->lkey
+};
+
+struct ibv_send_wr send_wr = {
+        .opcode = IBV_WR_SEND,
+        .num_sge = 1,
+        .sg_list = interleaved,
+        .flags = 0
+};
+
+ret = ibv_post_send(qp, send_wr, &bad_wr);
+if (ret) {
+        fprintf(stderr, "Non-contiguous send failed\en");
+        return 1;
+}
+
+.PP
+.SH "NOTES"
+There are two alternatives for completion semantics: registration is valid on
+function return (default), or upon completion of a user-initiated WR with the
+opcode IBV_WR_BIND_MR and the MR passed in struct bind_mr inside struct ibv_send_wr.
+In order to select the latter, flags should include IBV_MR_SET_LAYOUT_WITH_POST_WR.
+In this case, a user may post send/recieve WR on this MR right after the bind WR
+on the same QP, and it is guaranteed to be processed correctly.
+.PP
+Storing the layout may require additional space, causing an internal
+re-initialization of the MR (at some latency cost) and the invalidation of
+previous local and remote keys. Using the same
+.I num_interleaved\fR
+and the same
+.I num_repeated\fR
+would prevent resizing. Alternatively, passing IBV_MR_SET_LAYOUT_AVOID_INVALIDATION would
+cause the call to fail if a resize would be required.
+.PP
+Even upon a failure the user is still required to call ibv_dereg_mr on this MR.
+Also, deregistration must occur in inverse order relative to registration of MRs.
+.SH "SEE ALSO"
+.BR ibv_reg_mr (3),
+.BR ibv_mr_set_layout_sg (3),
+.BR ibv_mr_set_layout_interleaved (3),
+.BR ibv_dereg_mr (3),
+.SH "AUTHORS"
+.TP
+Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+.TP
+Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+.TP
+Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/libibverbs/man/ibv_mr_set_layout_sg.3 b/libibverbs/man/ibv_mr_set_layout_sg.3
new file mode 100644
index 0000000..22fa03c
--- /dev/null
+++ b/libibverbs/man/ibv_mr_set_layout_sg.3
@@ -0,0 +1,153 @@
+.\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
+.\"
+.TH IBV_MR_SET_LAYOUT_SG 3 2016-03-13 libibverbs "Libibverbs Programmer's Manual"
+.SH "NAME"
+ibv_mr_set_layout_sg \- register a non-contiguous memory region (MR)
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/verbs.h>
+.sp
+.BI "int ibv_mr_set_layout_sg(struct ibv_mr " "*mr" ", int " "flags" ",
+.BI "                    int " "num_sge" ", struct ibv_sge * " "sg_list");
+.fi
+.fi
+.SH "DESCRIPTION"
+The
+.B ibv_mr_set_layout_sg()
+function registers a non-contiguous memory layout to the given memory region (MR).
+Such memory layout is described by a list of contiguous ranges
+within other MRs. Once this registration is valid, a send or recieve operation
+can span across that list of MRs by using a single local or remote key.
+.PP
+.I mr\fR
+is the result of a successful call to ibv_reg_mr(), and will be bound to the new
+memory layout. Creating an MR strictly for non-contiguous registration could be
+expadited by requesting zero length in ibv_reg_mr(). The same MR could be reused
+for multiple calls - each overriding the previous.
+.PP
+.I flags\fR
+is a bit-mask of optional modifiers. Flags should be a combination (bit field) of:
+.PP
+.br
+.B IBV_MR_SET_LAYOUT_AVOID_INVALIDATION \fR Prevent MR key invalidation (see Notes).
+.PP
+.I num_sge\fR
+is the size of the s/g array describing the memory layout.
+.PP
+The argument
+.I sge_list\fR
+is an ibv_sge struct, as defined in <infiniband/verbs.h>. Each entry refers to a
+buffer, described by it's MR (local key), length and either a pointer or an offset
+ - depending on whether the MR is "zero-based". The MRs passed as arguments in
+sg_list could also be non-contiguous, as a result to previous calls to
+ibv_mr_set_layout_sg() or ibv_mr_set_layout_interleaved() on them.
+This case creates a nested definition of a non-contiguous memory layout, and it
+is supported up to a nesting level stated in max_mr_nesting_level inside struct
+ibv_mr_set_layout_caps.
+.PP
+.SH "RETURN VALUE"
+.B ibv_mr_set_layout_sg()
+returns 0 on success, otherwise an error has occurred,
+.I enum ibv_mr_set_layout_err_code\fR
+represents the error as listed below:
+.br
+IBV_MR_SET_LAYOUT_ERR_INPUT - Old MR is valid, an input error was detected by libibverbs.
+.br
+IBV_MR_SET_LAYOUT_ERR_WOULD_INVALIDATE - MR requires invalidation, but IBV_MR_SET_LAYOUT_AVOID_INVALIDATION was given.
+.br
+IBV_MR_SET_LAYOUT_ERR_UNSUPPORTED - Input requires a capability not supported (see
+.I struct ibv_mr_layout_caps\fR).
+.SH "EXAMPLES"
+The following code example demonstrates non-contiguous memory registration,
+by combining two contiguous regions, along with the WR-based completion semantic:
+.PP
+.nf
+mr1 = ibv_reg_mr(pd, addr1, len1, 0);
+if (!mr1) {
+        fprintf(stderr, "Failed to create MR #1\en");
+        return 1;
+}
+
+mr2 = ibv_reg_mr(pd, addr2, len2, 0);
+if (!mr2) {
+        fprintf(stderr, "Failed to create MR #2\en");
+        return 1;
+}
+
+mr3 = ibv_reg_mr(pd, NULL, 0, IBV_ACCESS_ZERO_BASED);
+if (!mr3) {
+        fprintf(stderr, "Failed to create result MR\en");
+        return 1;
+}
+
+struct ibv_sge composite[] =
+{
+        {
+                .addr = addr1,
+                .length = len1,
+                .lkey = mr1->lkey
+        },
+        {
+                .addr = addr2,
+                .length = len2,
+                .lkey = mr2->lkey
+        }
+};
+
+ret = ibv_mr_set_layout_sg(mr3, 0, 2, composite);
+if (ret) {
+        fprintf(stderr, "Non-contiguous registration failed\en");
+        return 1;
+}
+
+struct ibv_sge non_contig =
+{
+        .addr = 0,
+        .length = len1 + len2,
+        .lkey = mr3->lkey
+};
+
+struct ibv_send_wr send_wr = {
+        .opcode = IBV_WR_SEND,
+        .num_sge = 1,
+        .sg_list = non_contig,
+        .flags = 0
+};
+
+ret = ibv_post_send(qp, send_wr, &bad_wr);
+if (ret) {
+        fprintf(stderr, "Non-contiguous send failed\en");
+        return 1;
+}
+
+.PP
+.SH "NOTES"
+There are two alternatives for completion semantics: registration is valid on
+function return (default), or upon completion of a user-initiated WR with the
+opcode IBV_WR_BIND_MR and the MR passed in struct bind_mr inside struct ibv_send_wr.
+In order to select the latter, flags should include IBV_MR_SET_LAYOUT_WITH_POST_WR.
+In this case, a user may post send/recieve WR on this MR right after the bind WR
+on the same QP, and it is guaranteed to be processed correctly.
+.PP
+Storing the layout may require additional space, causing an internal
+re-initialization of the MR (at some latency cost) and the invalidation of
+previous local and remote keys. Using the same
+.I num_sge\fR
+would prevent resizing. Alternatively, passing IBV_MR_SET_LAYOUT_AVOID_INVALIDATION would
+cause the call to fail if a resize would be required.
+.PP
+Even upon a failure the user is still required to call ibv_dereg_mr on this MR.
+Also, deregistration must occur in inverse order relative to registration of MRs.
+.SH "SEE ALSO"
+.BR ibv_reg_mr (3),
+.BR ibv_dereg_mr_sg (3),
+.BR ibv_dereg_mr_interleaved (3),
+.BR ibv_dereg_mr (3),
+.SH "AUTHORS"
+.TP
+Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+.TP
+Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+.TP
+Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/libibverbs/man/ibv_reg_mr.3 b/libibverbs/man/ibv_reg_mr.3
index d3f09c0..506c3a1 100644
--- a/libibverbs/man/ibv_reg_mr.3
+++ b/libibverbs/man/ibv_reg_mr.3
@@ -74,6 +74,8 @@ fails if any memory window is still bound to this MR.
 .BR ibv_post_send (3),
 .BR ibv_post_recv (3),
 .BR ibv_post_srq_recv (3)
+.BR ibv_mr_set_layout_sg (3),
+.BR ibv_mr_set_layout_interleaved (3),
 .SH "AUTHORS"
 .TP
 Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
diff --git a/libibverbs/man/ibv_rereg_mr.3 b/libibverbs/man/ibv_rereg_mr.3
index 9fa567c..c21ef06 100644
--- a/libibverbs/man/ibv_rereg_mr.3
+++ b/libibverbs/man/ibv_rereg_mr.3
@@ -69,6 +69,8 @@ IBV_REREG_MR_ERR_CMD_AND_DO_FORK_NEW - MR shouldn't be used, command error, inva
 Even on a failure, the user still needs to call ibv_dereg_mr on this MR.
 .SH "SEE ALSO"
 .BR ibv_reg_mr (3),
+.BR ibv_mr_set_layout_sg (3),
+.BR ibv_mr_set_layout_interleaved (3),
 .BR ibv_dereg_mr (3),
 .SH "AUTHORS"
 .TP
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 7b53a6f..8903db8 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -208,6 +208,24 @@ struct ibv_tso_caps {
 	uint32_t supported_qpts;
 };
 
+enum ibv_mr_layout_cap_flags {
+	IBV_MR_SET_LAYOUT_SG					= 1 << 0,
+	IBV_MR_SET_LAYOUT_INTERLEAVED			= 1 << 1,
+	IBV_MR_SET_LAYOUT_INTERLEAVED_REPEAT			= 1 << 2,
+	IBV_MR_SET_LAYOUT_INTERLEAVED_NONUNIFORM_REPEAT	= 1 << 3,
+	IBV_MR_SET_LAYOUT_INTERLEAVED_NONUNIFORM_DATUM_TOTAL = 1 << 4,
+};
+
+struct ibv_mr_layout_caps {
+	uint64_t cap_flags;
+	uint32_t max_num_sg;
+	uint32_t max_inline_num_sg;
+	uint32_t max_num_interleaved;
+	uint32_t max_inline_num_interleaved;
+	uint32_t max_mr_stride_dimenson;
+	uint32_t max_mr_nesting_level;
+};
+
 /* RX Hash function flags */
 enum ibv_rx_hash_function_flags {
 	IBV_RX_HASH_FUNC_TOEPLITZ	= 1 << 0,
@@ -290,6 +308,7 @@ struct ibv_device_attr_ex {
 	uint32_t		raw_packet_caps; /* Use ibv_raw_packet_caps */
 	struct ibv_tm_caps	tm_caps;
 	struct ibv_cq_moderation_caps  cq_mod_caps;
+	struct ibv_mr_layout_caps mr_layout_caps;
 };
 
 enum ibv_mtu {
@@ -564,6 +583,12 @@ enum ibv_rereg_mr_flags {
 	IBV_REREG_MR_FLAGS_SUPPORTED	= ((IBV_REREG_MR_KEEP_VALID << 1) - 1)
 };
 
+enum ibv_mr_set_layout_flags {
+	IBV_MR_SET_LAYOUT_WITH_POST_WR		= (1 << 0),
+	IBV_MR_SET_LAYOUT_AVOID_INVALIDATION		= (1 << 1),
+	IBV_MR_SET_LAYOUT_FLAGS_SUPPORTED	= ((IBV_MR_SET_LAYOUT_AVOID_INVALIDATION << 1) - 1)
+};
+
 struct ibv_mr {
 	struct ibv_context     *context;
 	struct ibv_pd	       *pd;
@@ -1033,6 +1058,9 @@ struct ibv_send_wr {
 			uint16_t		hdr_sz;
 			uint16_t		mss;
 		} tso;
+		struct {
+			struct ibv_mr *mr;
+		} mr_set_layout;
 	};
 };
 
@@ -1634,8 +1662,38 @@ struct ibv_values_ex {
 	struct timespec raw_clock;
 };
 
+struct ibv_mr_layout_interleved_dimensions {
+	uint64_t offset_stride;
+	uint64_t datum_count;
+};
+
+struct ibv_mr_layout_interleaved {
+	struct ibv_sge				   first_datum;
+	int					   num_repeated;
+	int 					   num_dimentsions;
+	struct ibv_mr_layout_interleved_dimensions *dims;
+};
+
+enum verbs_context_mask {
+	VERBS_CONTEXT_XRCD	= 1 << 0,
+	VERBS_CONTEXT_SRQ	= 1 << 1,
+	VERBS_CONTEXT_QP	= 1 << 2,
+	VERBS_CONTEXT_CREATE_FLOW = 1 << 3,
+	VERBS_CONTEXT_DESTROY_FLOW = 1 << 4,
+	VERBS_CONTEXT_REREG_MR	= 1 << 5,
+	VERBS_CONTEXT_RESERVED	= 1 << 6
+};
+
 struct verbs_context {
 	/*  "grows up" - new fields go here */
+	int (*mr_set_layout_sg)(struct ibv_mr* mr,
+				int flags,
+				int num_sge,
+				struct ibv_sge *sg_list);
+	int (*mr_set_layout_interleaved)(struct ibv_mr* mr,
+					 int flags,
+					 int num_interleaved,
+					 struct ibv_mr_layout_interleaved *interleaved_list);
 	int (*modify_cq)(struct ibv_cq *cq, struct ibv_modify_cq_attr *attr);
 	int (*post_srq_ops)(struct ibv_srq *srq,
 			    struct ibv_ops_wr *op,
@@ -1878,6 +1936,28 @@ int ibv_rereg_mr(struct ibv_mr *mr, int flags,
  */
 int ibv_dereg_mr(struct ibv_mr *mr);
 
+enum ibv_mr_set_layout_err_code {
+	/* Old MR is valid, invalid input */
+	IBV_MR_SET_LAYOUT_ERR_INPUT = -1,
+	/* MR requires invalidation, but IBV_MR_SET_LAYOUT_KEEP_VALID is on */
+	IBV_MR_SET_LAYOUT_ERR_WOULD_INVALIDATE = -2,
+	/* Input valid, but the capability is unsupported (see ibv_mr_layout_caps) */
+	IBV_MR_SET_LAYOUT_ERR_UNSUPPORTED = -3,
+};
+
+/**
+ * ibv_mr_set_layout_sg - Register several memory regions as one.
+ */
+int ibv_mr_set_layout_sg(struct ibv_mr* mr, int flags,
+			 int num_sge,
+			 struct ibv_sge *sg_list);
+/**
+ * ibv_mr_set_layout_interleaved - Register several interleaving memory regions as one.
+ */
+int ibv_mr_set_layout_interleaved(struct ibv_mr* mr, int flags,
+				  int num_interleaved,
+				  struct ibv_mr_layout_interleaved *interleaved_list);
+
 /**
  * ibv_alloc_mw - Allocate a memory window
  */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
