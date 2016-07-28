From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs 3/3] Update man pages for TSO support
Date: Thu, 28 Jul 2016 15:19:42 +0300
Message-ID: <1469708382-29408-4-git-send-email-yishaih@mellanox.com>
References: <1469708382-29408-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469708382-29408-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Update relevant man pages for TSO:
- Add max_tso_header as part of ibv_create_qp_ex man page.
- Add IBV_WR_TSO opcode and update send operation support table for
  RAW_PACKET QP as part of ibv_post_send man page.
- Add TSO capabilities as part of ibv_query_device_ex man page.

In addition, fixed a typo as part of updating ibv_post_send related to
ibv_odp_caps.


Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 man/ibv_create_qp_ex.3    |  1 +
 man/ibv_post_send.3       | 36 ++++++++++++++++++++++++------------
 man/ibv_query_device_ex.3 | 22 ++++++++++++++--------
 3 files changed, 39 insertions(+), 20 deletions(-)

diff --git a/man/ibv_create_qp_ex.3 b/man/ibv_create_qp_ex.3
index f772a57..a2a67a4 100644
--- a/man/ibv_create_qp_ex.3
+++ b/man/ibv_create_qp_ex.3
@@ -34,6 +34,7 @@ uint32_t                comp_mask;	/* Identifies valid fields */
 struct ibv_pd          *pd;		/* PD to be associated with the QP */
 struct ibv_xrcd        *xrcd;		/* XRC domain to be associated with the target QP */
 enum ibv_qp_create_flags create_flags;	/* Creation flags for this QP */
+uint16_t                max_tso_header; /* Maximum TSO header size */
 .in -8
 };
 .sp
diff --git a/man/ibv_post_send.3 b/man/ibv_post_send.3
index f918afb..0d3fa66 100644
--- a/man/ibv_post_send.3
+++ b/man/ibv_post_send.3
@@ -69,6 +69,8 @@ uint32_t remote_srqn;            /* Number of the remote SRQ */
 } xrc;
 .in -8
 } qp_type;
+union {
+.in +8
 struct {
 .in +8
 struct ibv_mw            *mw;             /* Memory window (MW) of type 2 to bind */
@@ -76,6 +78,15 @@ uint32_t                 rkey;            /* The desired new rkey of the MW */
 struct ibv_mw_bind_info  bind_info;       /* MW additional bind information */
 .in -8
 } bind_mw;
+struct {
+.in +8
+void			*hdr;	/* Pointer address of inline header */
+uint16_t		hdr_sz;	/* Inline header size */
+uint16_t		mss;	/* Maximum segment size for each TSO fragment */
+.in -8
+} tso;
+.in -8
+};
 .in -8
 };
 .fi
@@ -104,18 +115,19 @@ uint32_t                lkey;                   /* Key of the local Memory Regio
 Each QP Transport Service Type supports a specific set of opcodes, as shown in the following table:
 .PP
 .nf
-OPCODE                      | IBV_QPT_UD | IBV_QPT_UC | IBV_QPT_RC | IBV_QPT_XRC_SEND
-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-+\-\-\-\-\-\-\-\-\-\-\-\-+\-\-\-\-\-\-\-\-\-\-\-\-+\-\-\-\-\-\-\-\-\-\-\-
-IBV_WR_SEND                 |     X      |     X      |     X     |     X
-IBV_WR_SEND_WITH_IMM        |     X      |     X      |     X     |     X
-IBV_WR_RDMA_WRITE           |            |     X      |     X     |     X
-IBV_WR_RDMA_WRITE_WITH_IMM  |            |     X      |     X     |     X
-IBV_WR_RDMA_READ            |            |            |     X     |     X
-IBV_WR_ATOMIC_CMP_AND_SWP   |            |            |     X     |     X
-IBV_WR_ATOMIC_FETCH_AND_ADD |            |            |     X     |     X
-IBV_WR_LOCAL_INV            |            |     X      |     X     |     X
-IBV_WR_BIND_MW              |            |     X      |     X     |     X
-IBV_WR_SEND_WITH_INV        |            |     X      |     X     |     X
+OPCODE                      | IBV_QPT_UD | IBV_QPT_UC | IBV_QPT_RC | IBV_QPT_XRC_SEND | IBV_QPT_RAW_PACKET
+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-+\-\-\-\-\-\-\-\-\-\-\-\-+\-\-\-\-\-\-\-\-\-\-\-\-+\-\-\-\-\-\-\-\-\-\-\-\-+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-
+IBV_WR_SEND                 |     X      |     X      |     X      |         X        |         X
+IBV_WR_SEND_WITH_IMM        |     X      |     X      |     X      |         X        |
+IBV_WR_RDMA_WRITE           |            |     X      |     X      |         X        |
+IBV_WR_RDMA_WRITE_WITH_IMM  |            |     X      |     X      |         X        |
+IBV_WR_RDMA_READ            |            |            |     X      |         X        |
+IBV_WR_ATOMIC_CMP_AND_SWP   |            |            |     X      |         X        |
+IBV_WR_ATOMIC_FETCH_AND_ADD |            |            |     X      |         X        |
+IBV_WR_LOCAL_INV            |            |     X      |     X      |         X        |
+IBV_WR_BIND_MW              |            |     X      |     X      |         X        |
+IBV_WR_SEND_WITH_INV        |            |     X      |     X      |         X        |
+IBV_WR_TSO                  |            |            |            |                  |         X
 .fi
 .PP
 The attribute send_flags describes the properties of the \s-1WR\s0. It is either 0 or the bitwise \s-1OR\s0 of one or more of the following flags:
diff --git a/man/ibv_query_device_ex.3 b/man/ibv_query_device_ex.3
index 5097be0..d06b40f 100644
--- a/man/ibv_query_device_ex.3
+++ b/man/ibv_query_device_ex.3
@@ -26,17 +26,18 @@ uint32_t               comp_mask;                  /* Compatibility mask that de
 struct ibv_odp_caps    odp_caps;                   /* On-Demand Paging capabilities */
 uint64_t               completion_timestamp_mask;  /* Completion timestamp mask (0 = unsupported) */
 uint64_t               hca_core_clock;             /* The frequency (in kHZ) of the HCA (0 = unsupported) */
-uint64_t               device_cap_flags_ex;    /* Extended device capability flags */
+uint64_t               device_cap_flags_ex;        /* Extended device capability flags */
+struct ibv_tso_caps    tso_caps;                   /* TCP segmentation offload capabilities */
 .in -8
 };
 
-struct ibv_exp_odp_caps {
-	uint64_t	general_odp_caps;  /* Mask with enum ibv_odp_general_cap_bits */
-	struct {
-		uint32_t	rc_odp_caps;      /* Mask with enum ibv_odp_tranport_cap_bits to know which operations are supported. */
-		uint32_t	uc_odp_caps;      /* Mask with enum ibv_odp_tranport_cap_bits to know which operations are supported. */
-		uint32_t	ud_odp_caps;      /* Mask with enum ibv_odp_tranport_cap_bits to know which operations are supported. */
-	} per_transport_caps;
+struct ibv_odp_caps {
+        uint64_t general_odp_caps;    /* Mask with enum ibv_odp_general_cap_bits */
+        struct {
+                uint32_t rc_odp_caps; /* Mask with enum ibv_odp_tranport_cap_bits to know which operations are supported. */
+                uint32_t uc_odp_caps; /* Mask with enum ibv_odp_tranport_cap_bits to know which operations are supported. */
+                uint32_t ud_odp_caps; /* Mask with enum ibv_odp_tranport_cap_bits to know which operations are supported. */
+        } per_transport_caps;
 };
 
 enum ibv_odp_general_cap_bits {
@@ -51,6 +52,11 @@ enum ibv_odp_transport_cap_bits {
         IBV_ODP_SUPPORT_ATOMIC   = 1 << 4, /* RDMA-Atomic operations support on-demand paging */
 };
 
+struct ibv_tso_caps {
+        uint32_t max_tso;        /* Maximum payload size in bytes supported for segmentation by TSO engine.*/
+        uint32_t supported_qpts; /* Bitmap showing which QP types are supported by TSO operation. */
+};
+
 .fi
 .SH "RETURN VALUE"
 .B ibv_query_device_ex()
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
