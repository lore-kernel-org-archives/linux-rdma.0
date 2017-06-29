From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 6/7] mlx4: Add direct verbs man pages
Date: Thu, 29 Jun 2017 14:47:07 +0300
Message-ID: <1498736828-17875-7-git-send-email-yishaih@mellanox.com>
References: <1498736828-17875-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498736828-17875-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Document mlx4 direct verbs feature and exposed related functions.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 CMakeLists.txt                       |   1 +
 providers/mlx4/man/CMakeLists.txt    |   4 ++
 providers/mlx4/man/mlx4dv.7          |  39 ++++++++++++
 providers/mlx4/man/mlx4dv_init_obj.3 | 117 +++++++++++++++++++++++++++++++++++
 4 files changed, 161 insertions(+)
 create mode 100644 providers/mlx4/man/CMakeLists.txt
 create mode 100644 providers/mlx4/man/mlx4dv.7
 create mode 100644 providers/mlx4/man/mlx4dv_init_obj.3

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 634f327..5dcdb90 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -415,6 +415,7 @@ add_subdirectory(providers/cxgb4) # NO SPARSE
 add_subdirectory(providers/hns) # NO SPARSE
 add_subdirectory(providers/i40iw) # NO SPARSE
 add_subdirectory(providers/mlx4) # NO SPARSE
+add_subdirectory(providers/mlx4/man) # NO SPARSE
 add_subdirectory(providers/mlx5) # NO SPARSE
 add_subdirectory(providers/mlx5/man) # NO SPARSE
 add_subdirectory(providers/mthca) # NO SPARSE
diff --git a/providers/mlx4/man/CMakeLists.txt b/providers/mlx4/man/CMakeLists.txt
new file mode 100644
index 0000000..c44c7c3
--- /dev/null
+++ b/providers/mlx4/man/CMakeLists.txt
@@ -0,0 +1,4 @@
+rdma_man_pages(
+  mlx4dv_init_obj.3
+  mlx4dv.7
+)
diff --git a/providers/mlx4/man/mlx4dv.7 b/providers/mlx4/man/mlx4dv.7
new file mode 100644
index 0000000..92ced99
--- /dev/null
+++ b/providers/mlx4/man/mlx4dv.7
@@ -0,0 +1,39 @@
+.\" -*- nroff -*-
+.\" Licensed under the OpenIB.org (MIT) - See COPYING.md
+.\"
+.TH MLX4DV 7 2017-04-19 1.0.0
+.SH "NAME"
+mlx4dv \- Direct verbs for mlx4 devices
+.br
+This is low level access to mlx4 devices to perform data path operations,
+without general branching performed by \fBibv_post_send\fR(3).
+
+.SH "DESCRIPTION"
+The libibverbs API is an abstract one. It is agnostic to any underlying
+provider specific implementation. While this abstraction has the advantage
+of user applications portability it has a performance penalty. For some
+applications optimizing performance is more important than portability.
+
+The mlx4 direct verbs API is intended for such applications.
+It exposes mlx4 specific low level data path (send/receive/completion)
+operations, allowing the application to bypass the libibverbs data path API.
+
+This interface consists from one hardware specific header file
+with relevant inline functions and conversion logic from ibverbs structures
+to mlx4 specific structures.
+
+The direct include of mlx4dv.h together with linkage to mlx4 library will
+allow usage of this new interface.
+
+Once an application uses the direct flow the locking scheme is fully managed
+by itself. There is an expectation that no mixed flows in the data path for both
+direct/non-direct access will be by same application.
+
+.SH "NOTES"
+.SH "SEE ALSO"
+.BR ibv_post_send (3),
+.BR verbs (7)
+
+.SH "AUTHORS"
+.TP
+Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/providers/mlx4/man/mlx4dv_init_obj.3 b/providers/mlx4/man/mlx4dv_init_obj.3
new file mode 100644
index 0000000..0d0a4a5
--- /dev/null
+++ b/providers/mlx4/man/mlx4dv_init_obj.3
@@ -0,0 +1,117 @@
+.\" -*- nroff -*-
+.\" Licensed under the OpenIB.org (MIT) - See COPYING.md
+.\"
+.TH MLX4DV_INIT_OBJ 3 2017-02-02 1.0.0
+.SH "NAME"
+mlx4dv_init_obj \- Initialize mlx4 direct verbs object from ibv_xxx structures
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/mlx4dv.h>
+.sp
+.BI "int mlx4dv_init_obj(struct mlx4dv_obj *obj, uint64_t obj_type);
+.fi
+.SH "DESCRIPTION"
+.B mlx4dv_init_obj()
+This function will initialize mlx4dv_xxx structs based on supplied type. The information
+for initialization is taken from ibv_xx structs supplied as part of input.
+
+Request information of CQ marks its owned by direct verbs for all consumer index
+related actions. The initialization type can be combination of several types together.
+.PP
+.nf
+struct mlx4dv_qp {
+.in +8
+uint32_t         *rdb;
+uint32_t         *sdb;
+struct {
+.in +8
+uint32_t        wqe_cnt;
+int             wqe_shift;
+int             offset;
+.in -8
+} sq;
+struct {
+.in +8
+uint32_t        wqe_cnt;
+int             wqe_shift;
+int             offset;
+.in -8
+} rq;
+struct {
+.in +8
+void            *buf;
+size_t          length;
+.in -8
+} buf;
+uint64_t        comp_mask;
+.in -8
+};
+
+struct mlx4dv_cq {
+.in +8
+struct {
+.in +8
+void            *buf;
+size_t          length;
+.in -8
+} buf;
+uint32_t        cqe_cnt;
+uint32_t        cqn;
+uint32_t        *set_ci_db;
+uint32_t        *arm_db;
+int             arm_sn;
+int             cqe_size;
+uint64_t        comp_mask;
+.in -8
+};
+
+struct mlx4dv_srq {
+.in +8
+struct {
+.in +8
+void            *buf;
+size_t          length;
+.in -8
+} buf;
+int             wqe_shift;
+int             head;
+int             tail;
+uint32_t        *db;
+uint64_t        comp_mask;
+.in -8
+};
+
+struct mlx4dv_obj {
+.in +8
+struct {
+.in +8
+struct ibv_qp      *in;
+struct mlx4dv_qp   *out;
+.in -8
+} qp;
+struct {
+.in +8
+struct ibv_cq      *in;
+struct mlx4dv_cq   *out;
+.in -8
+} cq;
+.in -8
+};
+
+enum mlx4dv_obj_type {
+.in +8
+MLX4DV_OBJ_QP   = 1 << 0,
+MLX4DV_OBJ_CQ   = 1 << 1,
+MLX4DV_OBJ_SRQ  = 1 << 2,
+.in -8
+};
+.fi
+.SH "RETURN VALUE"
+0 on success or the value of errno on failure (which indicates the failure reason).
+.SH "NOTES"
+ * Compatibility masks (comp_mask) are in/out fields.
+.SH "SEE ALSO"
+.BR mlx4dv (7)
+.SH "AUTHORS"
+.TP
+Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
