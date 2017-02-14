From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 rdma-core 6/7] mlx5: Add direct verbs man pages
Date: Tue, 14 Feb 2017 15:48:23 +0200
Message-ID: <1487080104-28991-7-git-send-email-yishaih@mellanox.com>
References: <1487080104-28991-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487080104-28991-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Document mlx5 direct verbs feature and exposed related functions.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 CMakeLists.txt                           |   1 +
 providers/mlx5/man/CMakeLists.txt        |   5 ++
 providers/mlx5/man/mlx5dv.7              |  44 +++++++++++
 providers/mlx5/man/mlx5dv_init_obj.3     | 130 +++++++++++++++++++++++++++++++
 providers/mlx5/man/mlx5dv_query_device.3 |  50 ++++++++++++
 5 files changed, 230 insertions(+)
 create mode 100644 providers/mlx5/man/CMakeLists.txt
 create mode 100644 providers/mlx5/man/mlx5dv.7
 create mode 100644 providers/mlx5/man/mlx5dv_init_obj.3
 create mode 100644 providers/mlx5/man/mlx5dv_query_device.3

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 45cbc4e..529c0cd 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -377,6 +377,7 @@ add_subdirectory(providers/hns)
 add_subdirectory(providers/i40iw)
 add_subdirectory(providers/mlx4)
 add_subdirectory(providers/mlx5)
+add_subdirectory(providers/mlx5/man)
 add_subdirectory(providers/mthca)
 add_subdirectory(providers/nes)
 add_subdirectory(providers/ocrdma)
diff --git a/providers/mlx5/man/CMakeLists.txt b/providers/mlx5/man/CMakeLists.txt
new file mode 100644
index 0000000..bb1610b
--- /dev/null
+++ b/providers/mlx5/man/CMakeLists.txt
@@ -0,0 +1,5 @@
+rdma_man_pages(
+  mlx5dv_init_obj.3
+  mlx5dv_query_device.3
+  mlx5dv.7
+)
diff --git a/providers/mlx5/man/mlx5dv.7 b/providers/mlx5/man/mlx5dv.7
new file mode 100644
index 0000000..c02c967
--- /dev/null
+++ b/providers/mlx5/man/mlx5dv.7
@@ -0,0 +1,44 @@
+.\" -*- nroff -*-
+.\" Licensed under the OpenIB.org (MIT) - See COPYING.md
+.\"
+.TH MLX5DV 7 2017-02-02 1.0.0
+.SH "NAME"
+mlx5dv \- Direct verbs for mlx5 devices
+.br
+This is low level access to mlx5 devices to perform data path operations,
+without general branching performed by \fBibv_post_send\fR(3).
+
+.SH "DESCRIPTION"
+The libibverbs API is an abstract one. It is agnostic to any underlying
+provider specific implementation. While this abstraction has the advantage
+of user applications portability it has a performance penalty. For some
+applications optimizing performance is more important than portability.
+
+The mlx5 direct verbs API is intended for such applications.
+It exposes mlx5 specific low level data path (send/receive/completion)
+operations, allowing the application to bypass the libibverbs data path API.
+
+This interface consists from one hardware specific header file
+with relevant inline functions and conversion logic from ibverbs structures
+to mlx5 specific structures.
+
+The direct include of mlx5dv.h together with linkage to mlx5 library will
+allow usage of this new interface.
+
+Once an application uses the direct flow the locking scheme is fully managed
+by itself. There is an expectation that no mixed flows in the data path for both
+direct/non-direct access will be by same application.
+
+.SH "NOTES"
+All Mellanox NIC devices starting from Connect-IB (Connect-IB,
+ConnectX-4, ConnectX-4Lx, ConnectX-5, ...) implement the mlx5 API,
+thus using the mlx5 direct verbs does not limit the applications
+to a single NIC HW device thus keeping some level of portability.
+
+.SH "SEE ALSO"
+.BR ibv_post_send (3),
+.BR verbs (7)
+
+.SH "AUTHORS"
+.TP
+Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/providers/mlx5/man/mlx5dv_init_obj.3 b/providers/mlx5/man/mlx5dv_init_obj.3
new file mode 100644
index 0000000..2468407
--- /dev/null
+++ b/providers/mlx5/man/mlx5dv_init_obj.3
@@ -0,0 +1,130 @@
+.\" -*- nroff -*-
+.\" Licensed under the OpenIB.org (MIT) - See COPYING.md
+.\"
+.TH MLX5DV_INIT_OBJ 3 2017-02-02 1.0.0
+.SH "NAME"
+mlx5dv_init_obj \- Initialize mlx5 direct verbs object from ibv_xxx structures
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/mlx5dv.h>
+.sp
+.BI "int mlx5dv_init_obj(struct mlx5dv_obj *obj, uint64_t obj_type);
+.fi
+.SH "DESCRIPTION"
+.B mlx5dv_init_obj()
+This function will initialize mlx5dv_xxx structs based on supplied type. The information
+for initialization is taken from ibv_xx structs supplied as part of input.
+
+Request information of CQ marks its owned by direct verbs for all consumer index
+related actions. The initialization type can be combination of several types together.
+.PP
+.nf
+struct mlx5dv_qp {
+.in +8
+uint32_t                *dbrec;
+struct {
+.in +8
+void            *buf;
+uint32_t        wqe_cnt;
+uint32_t        stride;
+.in -8
+} sq;
+struct {
+.in +8
+void            *buf;
+uint32_t        wqe_cnt;
+uint32_t        stride;
+.in -8
+} rq;
+struct {
+.in +8
+void            *reg;
+uint32_t        size;
+.in -8
+} bf;
+uint64_t                comp_mask;
+.in -8
+};
+
+struct mlx5dv_cq {
+.in +8
+void                    *buf;
+uint32_t                *dbrec;
+uint32_t                cqe_cnt;
+uint32_t                cqe_size;
+void                    *uar;
+uint32_t                cqn;
+uint64_t                comp_mask;
+.in -8
+};
+
+struct mlx5dv_srq {
+.in +8
+void                    *buf;
+uint32_t                *dbrec;
+uint32_t                stride;
+uint32_t                head;
+uint32_t                tail;
+uint64_t                comp_mask;
+.in -8
+};
+
+struct mlx5dv_rwq {
+.in +8
+void            *buf;
+uint32_t        *dbrec;
+uint32_t        wqe_cnt;
+uint32_t        stride;
+uint64_t        comp_mask;
+.in -8
+};
+
+struct mlx5dv_obj {
+.in +8
+struct {
+.in +8
+struct ibv_qp           *in;
+struct mlx5dv_qp        *out;
+.in -8
+} qp;
+struct {
+.in +8
+struct ibv_cq           *in;
+struct mlx5dv_cq        *out;
+.in -8
+} cq;
+struct {
+.in +8
+struct ibv_srq          *in;
+struct mlx5dv_srq       *out;
+.in -8
+} srq;
+struct {
+.in +8
+struct ibv_wq           *in;
+struct mlx5dv_rwq       *out;
+.in -8
+} rwq;
+.in -8
+};
+
+enum mlx5dv_obj_type {
+.in +8
+MLX5DV_OBJ_QP   = 1 << 0,
+MLX5DV_OBJ_CQ   = 1 << 1,
+MLX5DV_OBJ_SRQ  = 1 << 2,
+MLX5DV_OBJ_RWQ  = 1 << 3,
+.in -8
+};
+.fi
+.SH "RETURN VALUE"
+0 on success or the value of errno on failure (which indicates the failure reason).
+.SH "NOTES"
+ * The information if doorbell is blueflame is based on mlx5dv_qp->bf->size,
+in case of 0 it's not a BF.
+ * Compatibility masks (comp_mask) are in/out fields.
+.SH "SEE ALSO"
+.BR mlx5dv (7)
+.SH "AUTHORS"
+.TP
+Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/providers/mlx5/man/mlx5dv_query_device.3 b/providers/mlx5/man/mlx5dv_query_device.3
new file mode 100644
index 0000000..1954714
--- /dev/null
+++ b/providers/mlx5/man/mlx5dv_query_device.3
@@ -0,0 +1,50 @@
+.\" -*- nroff -*-
+.\" Licensed under the OpenIB.org (MIT) - See COPYING.md
+.\"
+.TH MLX5DV_QUERY_DEVICE 3 2017-02-02 1.0.0
+.SH "NAME"
+mlx5dv_query_device \- Query device capabilities specific to mlx5
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/mlx5dv.h>
+.sp
+.BI "int mlx5dv_query_device(struct ibv_context *ctx_in,
+.BI "                        struct mlx5dv_context *attrs_out);
+.fi
+.SH "DESCRIPTION"
+.B mlx5dv_query_device()
+Query HW device-specific information which is important for data-path, but isn't provided by
+\fBibv_query_device\fR(3).
+.PP
+This function returns version, flags and compatibility mask. The version represents the format
+of the internal hardware structures that mlx5dv.h represents. Additions of new fields to the existed
+structures are handled by comp_mask field.
+.PP
+.nf
+struct mlx5dv_context {
+.in +8
+uint8_t         version;
+uint64_t        flags;
+uint64_t        comp_mask;
+.in -8
+};
+
+enum mlx5dv_context_flags {
+.in +8
+/*
+ * This flag indicates if CQE version 0 or 1 is needed.
+ */
+ MLX5DV_CONTEXT_FLAGS_CQE_V1 = (1 << 0),
+.in -8
+};
+.fi
+.SH "RETURN VALUE"
+0 on success or the value of errno on failure (which indicates the failure reason).
+.SH "NOTES"
+ * Compatibility mask (comp_mask) is in/out field.
+.SH "SEE ALSO"
+.BR mlx5dv (7),
+.BR ibv_query_device (3)
+.SH "AUTHORS"
+.TP
+Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
