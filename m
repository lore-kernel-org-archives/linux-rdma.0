From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 6/7] ibverbs: Update man pages to include cvlan offloads options
Date: Tue, 14 Mar 2017 13:15:42 +0200
Message-ID: <1489490143-29018-7-git-send-email-yishaih@mellanox.com>
References: <1489490143-29018-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489490143-29018-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Provide information about the cvlan stripping offload for
- ibv_create_wq
- ibv_modify_wq
- ibv_create_cq_ex
- ibv_query_device_ex

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/man/ibv_create_cq_ex.3    |  9 +++++++--
 libibverbs/man/ibv_create_wq.3       | 10 ++++++++++
 libibverbs/man/ibv_modify_wq.3       |  2 ++
 libibverbs/man/ibv_query_device_ex.3 |  1 +
 4 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/libibverbs/man/ibv_create_cq_ex.3 b/libibverbs/man/ibv_create_cq_ex.3
index a6ae769..020bbb4 100644
--- a/libibverbs/man/ibv_create_cq_ex.3
+++ b/libibverbs/man/ibv_create_cq_ex.3
@@ -17,10 +17,10 @@ creates a completion queue (CQ) for RDMA device context
 .I context\fR.
 The argument
 .I cq_attr
-is a pointer to struct ibv_create_cq_attr_ex as defined in <infiniband/verbs.h>.
+is a pointer to struct ibv_cq_init_attr_ex as defined in <infiniband/verbs.h>.
 .PP
 .nf
-struct ibv_create_cq_attr_ex {
+struct ibv_cq_init_attr_ex {
 .in +8
 int                     cqe;               /* Minimum number of entries required for CQ */
 void                    *cq_context;       /* Consumer-supplied context returned for completion events */
@@ -28,6 +28,7 @@ struct ibv_comp_channel *channel;          /* Completion channel where completio
 int                     comp_vector;       /* Completion vector used to signal completion events. Must be >= 0 and < context->num_comp_vectors. */
 uint64_t                wc_flags;          /* The wc_flags that should be returned in ibv_poll_cq_ex. Or'ed bit of enum ibv_wc_flags_ex. */
 uint32_t                comp_mask;         /* compatibility mask (extended verb). */
+uint32_t                flags              /* One or more flags from enum ibv_create_cq_attr_flags */
 .in -8
 };
 
@@ -40,6 +41,7 @@ enum ibv_wc_flags_ex {
         IBV_WC_EX_WITH_SL                    = 1 << 5,  /* Require sl in WC */
         IBV_WC_EX_WITH_DLID_PATH_BITS        = 1 << 6,  /* Require dlid path bits in WC */
         IBV_WC_EX_WITH_COMPLETION_TIMESTAMP  = 1 << 7,  /* Require completion timestamp in WC /*
+        IBV_WC_EX_WITH_CVLAN                 = 1 << 8,  /* Require VLAN info in WC */
 };
 
 enum ibv_cq_init_attr_mask {
@@ -128,6 +130,9 @@ Below members and functions are used in order to poll the current completion. Th
 .BI "uint64_t ibv_wc_read_completion_ts(struct ibv_cq_ex " "*cq"); \c
  Get the completion timestamp from the current completion.
 
+.BI "uint16_t ibv_wc_read_cvlan(struct ibv_cq_ex " "*cq"); \c
+ Get the CVLAN field from the current completion.
+
 .SH "RETURN VALUE"
 .B ibv_create_cq_ex()
 returns a pointer to the CQ, or NULL if the request fails.
diff --git a/libibverbs/man/ibv_create_wq.3 b/libibverbs/man/ibv_create_wq.3
index aad6741..81fea04 100644
--- a/libibverbs/man/ibv_create_wq.3
+++ b/libibverbs/man/ibv_create_wq.3
@@ -31,8 +31,18 @@ uint32_t                   max_sge;       /* Requested max number of scatter/gat
 struct  ibv_pd            *pd;            /* PD to be associated with the WQ */
 struct  ibv_cq            *cq;            /* CQ to be associated with the WQ */
 uint32_t                   comp_mask;     /* Identifies valid fields. Use ibv_wq_init_attr_mask */
+uint32_t                  create_flags    /* Creation flags for this WQ, use enum ibv_wq_flags */
 .in -8
 };
+.sp
+.nf
+enum ibv_wq_flags {
+.in +8
+IBV_WQ_FLAGS_CVLAN_STRIPPING            = 1 << 0,
+IBV_WQ_FLAGS_RESERVED                   = 1 << 1,
+.in -8
+};
+.nf
 .fi
 .PP
 The function
diff --git a/libibverbs/man/ibv_modify_wq.3 b/libibverbs/man/ibv_modify_wq.3
index f17faed..1972ec2 100644
--- a/libibverbs/man/ibv_modify_wq.3
+++ b/libibverbs/man/ibv_modify_wq.3
@@ -26,6 +26,8 @@ struct ibv_wq_attr {
 uint32_t                attr_mask;     /* Use enum ibv_wq_attr_mask */
 enum ibv_wq_state       wq_state;      /* Move to this state */
 enum ibv_wq_state       curr_wq_state; /* Assume this is the current state */
+uint32_t                flags;         /* Flags values to modify, use enum ibv_wq_flags */
+uint32_t                flags_mask;    /* Which flags to modify, use enum ibv_wq_flags */
 .in -8
 };
 .fi
diff --git a/libibverbs/man/ibv_query_device_ex.3 b/libibverbs/man/ibv_query_device_ex.3
index c291017..7f58355 100644
--- a/libibverbs/man/ibv_query_device_ex.3
+++ b/libibverbs/man/ibv_query_device_ex.3
@@ -32,6 +32,7 @@ struct ibv_tso_caps    tso_caps;                   /* TCP segmentation offload c
 struct ibv_rss_caps    rss_caps;                   /* RSS capabilities */
 uint32_t               max_wq_type_rq;             /* Max Work Queue from type RQ */
 struct ibv_packet_pacing_caps packet_pacing_caps; /* Packet pacing capabilities */
+uint32_t               raw_packet_caps;            /* Raw packet capabilities, use enum ibv_raw_packet_caps */
 .in -8
 };
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
