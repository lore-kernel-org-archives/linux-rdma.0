From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libmlx5] abi: adds explicit padding on mlx5_create_cq and mlx5_create_srq
Date: Sun,  4 May 2014 23:41:53 +0200
Message-ID: <1399239713-18152-1-git-send-email-ydroneaud@opteya.com>
References: <cover.1399216475.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1399216475.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

i386 ABI disagree with most other ABIs regarding alignment
of data type larger than 4 bytes: on most ABIs a padding must
be added at end of the structures, while it is not
required on i386.

Such ABI disagreement will make an x86_64 kernel try to read
past a buffer provided by an i386 binary, as the latter will
not have the expected padding for struct mlx5_create_cq and
mlx5_create_srq.

On kernel side, these structures were added for kernel v3.11-rc1
by following commit:

  Commit e126ba97dba9edeb6fafa3665b5f8497fc9cdf8c
  Author: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
  Date:   Sun Jul 7 17:25:49 2013 +0300

      mlx5: Add driver for Mellanox Connect-IB adapters

If future kernel is to use the padding for extension, on a
x86_64 unpatched kernel, it might read garbage as it would
read past the i386 provided buffer.

In this other hand, if boundary check is implemented on kernel
side, the x86_64 kernel will refuse to read past the i386
userspace provided buffer for struct mlx5_create_cq and
mlx5_create_srq, making the uverbs fail.

To address all these issues, this patch add an explicit padding
at end of structures and initialize it so that i386 and others ABI
share the same structure layout.

With this patch, libmlx5 will run on older kernel and
newer patched kernel.

Link: http://marc.info/?i=cover.1399216475.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 src/mlx5-abi.h | 2 ++
 src/verbs.c    | 6 ++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/src/mlx5-abi.h b/src/mlx5-abi.h
index 6f98e62c59d5..980b24910403 100644
--- a/src/mlx5-abi.h
+++ b/src/mlx5-abi.h
@@ -83,6 +83,7 @@ struct mlx5_create_cq {
 	__u64				buf_addr;
 	__u64				db_addr;
 	__u32				cqe_size;
+	__u32				reserved;
 };
 
 struct mlx5_create_cq_resp {
@@ -95,6 +96,7 @@ struct mlx5_create_srq {
 	__u64				buf_addr;
 	__u64				db_addr;
 	__u32				flags;
+	__u32				reserved;
 };
 
 struct mlx5_create_srq_resp {
diff --git a/src/verbs.c b/src/verbs.c
index 7201e94925c5..1de8692e5264 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -261,7 +261,6 @@ struct ibv_cq *mlx5_create_cq(struct ibv_context *context, int cqe,
 		return NULL;
 	}
 
-	memset(&cmd, 0, sizeof cmd);
 	cq->cons_index = 0;
 
 	if (mlx5_spinlock_init(&cq->lock))
@@ -307,6 +306,7 @@ struct ibv_cq *mlx5_create_cq(struct ibv_context *context, int cqe,
 	cmd.buf_addr = (uintptr_t) cq->buf_a.buf;
 	cmd.db_addr  = (uintptr_t) cq->dbrec;
 	cmd.cqe_size = cqe_sz;
+	cmd.reserved = 0;
 
 	ret = ibv_cmd_create_cq(context, ncqe - 1, channel, comp_vector,
 				&cq->ibv_cq, &cmd.ibv_cmd, sizeof cmd,
@@ -442,7 +442,6 @@ struct ibv_srq *mlx5_create_srq(struct ibv_pd *pd,
 	}
 	ibsrq = &srq->srq;
 
-	memset(&cmd, 0, sizeof cmd);
 	if (mlx5_spinlock_init(&srq->lock)) {
 		fprintf(stderr, "%s-%d:\n", __func__, __LINE__);
 		goto err;
@@ -490,6 +489,9 @@ struct ibv_srq *mlx5_create_srq(struct ibv_pd *pd,
 	srq->wq_sig = srq_sig_enabled();
 	if (srq->wq_sig)
 		cmd.flags = MLX5_SRQ_FLAG_SIGNATURE;
+	else
+		cmd.flags = 0;
+	cmd.reserved = 0;
 
 	attr->attr.max_sge = srq->max_gs;
 	pthread_mutex_lock(&ctx->srq_table_mutex);
-- 
1.9.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
