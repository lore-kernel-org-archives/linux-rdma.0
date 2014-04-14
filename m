From: Alexey Ishchuk <alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/5] libmlx4: add new verb command support
Date: Mon, 14 Apr 2014 19:01:07 +0200
Message-ID: <1397494869-43842-4-git-send-email-alexey_ishchuk@ru.ibm.com>
References: <1397494869-43842-1-git-send-email-alexey_ishchuk@ru.ibm.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1397494869-43842-1-git-send-email-alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, gilr-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexey Ishchuk <alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Since s390x platform requires execution of privileged CPU instructions
to work with PCI I/O memory, the PCI I/O memory cannot be accessed from
the userspace programs via the mapped memory areas. The current
implementation of the Inifiniband verbs uses mapped memory areas to
write data to device UAR and Blueflame page to initiate the I/O
operations, these verbs cannot be used on the s390x platfrom without
modification.
There are two approaches could be implemented to solve this problem:
	* using a page fault handler to intercept mapped memory area
	  access errors, and handle them in the handler by issuing the
	  appropriate privileged CPU instructions;
	* modification of the existing verbs to avoid the mapped memory
	  areas usage on the s390x platform.
The page fault handler solution is the most complex one because it requires
not only modifcation of the virtual memory handling in Linux kernel but
also makes the developer to provide code for all the CPU instrutions which
work with memory program interpretation. This approcach requires lots of
lines of code and noticable overhead during the program execution.
The modification of the existing verbs solution is much simpler and more
realible. It requires modification of the libraries provided in the DAPL
support packages to replace the usage of mapped memory areas used to
access the device UAR and Blueflame page with the device driver write
primitive calls supplying a special verb command to kernelspace.
The modification of the existing verbs solution has been choosen for
implementation.
This patch contains the changes to the libmlx4 userspace Mellanox device
driver library required to provide support for the DAPL API on the s390x
platform. The code that used mapped memory areas to access the PCI I/O
memory of the Mellanox networking device is replaced with the kernelspace
device driver write primitive system calls that pass to kernel the new
IB_USER_VERBS_CMD_KWRITE_MMIO verb command with apporpriate parameters.

Signed-off-by: Alexey Ishchuk <alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
---
 src/doorbell.h |   67 +++++++++++++++++++++++++++++++++++++++++++
 src/mlx4.c     |   87 +++++++++++++++++++++++++++++++++++++++++----------------
 src/mlx4.h     |    6 +++
 src/qp.c       |   43 +++++++++++++++++++++++++---
 4 files changed, 176 insertions(+), 27 deletions(-)

--- a/src/doorbell.h
+++ b/src/doorbell.h
@@ -33,6 +33,7 @@
 #ifndef DOORBELL_H
 #define DOORBELL_H
 
+#ifndef __s390x__
 #if SIZEOF_LONG == 8
 
 #if __BYTE_ORDER == __LITTLE_ENDIAN
@@ -59,5 +60,71 @@ static inline void mlx4_write64(uint32_t
 }
 
 #endif
+#else  /* __s390x__ */
+
+#include <stdio.h>
+#include <unistd.h>
+#include <errno.h>
+#include <infiniband/driver.h>
+#include <infiniband/arch.h>
+
+enum ib_uverbs_kwrite_mmio_location {
+	IB_UVERBS_KWRITE_MMIO_UAR,
+	IB_UVERBS_KWRITE_MMIO_BF_PAGE
+};
+
+struct mlx4_kwrite_mmio {
+	__u32	command;
+	__u16	in_words;
+	__u16	out_words;
+	__u16	offset;
+	__u16	length;
+	__u8	location;
+	__u8	reserved[3];
+	__u8	value[0];
+};
+
+static inline int mlx4_kwrite_mmio(int fd,
+			uint8_t location,
+			uint32_t offset,
+			uint32_t length,
+			void *value)
+{
+	struct mlx4_kwrite_mmio *cmd = NULL;
+	int cmd_size = 0;
+	int ret = 0;
+
+	cmd_size = sizeof(*cmd) + length;
+	cmd = calloc(1, cmd_size);
+	if (!cmd)
+		return -ENOMEM;
+
+	cmd->command = IB_USER_VERBS_CMD_KWRITE_MMIO;
+	cmd->in_words = cmd_size / 4;
+	cmd->out_words = 0;
+	cmd->offset = offset;
+	cmd->length = length;
+	cmd->location = location;
+
+	memcpy(cmd->value, value, length);
+
+	ret = write(fd, cmd, cmd_size);
+	free(cmd);
+
+	return ret;
+}
+
+static inline void mlx4_write64(uint32_t val[2],
+			struct mlx4_context *ctx,
+			int offset)
+{
+	mlx4_kwrite_mmio(ctx->ibv_ctx.cmd_fd,
+			 IB_UVERBS_KWRITE_MMIO_UAR,	/* UAR page */
+			 offset,
+			 2 * sizeof(val[0]),
+			 val);
+}
+
+#endif
 
 #endif /* DOORBELL_H */
--- a/src/mlx4.c
+++ b/src/mlx4.c
@@ -116,6 +116,59 @@ static struct ibv_context_ops mlx4_ctx_o
 	.detach_mcast  = ibv_cmd_detach_mcast
 };
 
+#ifdef __s390x__
+static inline int mlx4_context_init_mapping(struct mlx4_context *context,
+					const int cmd_fd,
+					const __u16 bf_reg_size,
+					const struct mlx4_device *dev)
+{
+	if (bf_reg_size) {
+		context->bf_buf_size = bf_reg_size / 2;
+		context->bf_offset   = 0;
+		pthread_spin_init(&context->bf_lock, PTHREAD_PROCESS_PRIVATE);
+	} else
+		context->bf_buf_size = 0;
+
+	return 0;
+}
+#else
+static inline int mlx4_context_init_mapping(struct mlx4_context *context,
+					const int cmd_fd,
+					const __u16 bf_reg_size,
+					const struct mlx4_device *dev)
+{
+	static const char *mlx4_bf_format = "%s %s\n";
+	static const char *mlx4_bf_warning =
+	"Warning: BlueFlame available, but failed to mmap() BlueFlame page.";
+
+	context->uar = mmap(NULL, dev->page_size, PROT_WRITE,
+			    MAP_SHARED, cmd_fd, 0);
+	if (context->uar == MAP_FAILED)
+		return errno;
+
+	if (bf_reg_size) {
+		context->bf_page = mmap(NULL, dev->page_size,
+					PROT_WRITE, MAP_SHARED, cmd_fd,
+					dev->page_size);
+		if (context->bf_page == MAP_FAILED) {
+			fprintf(stderr, mlx4_bf_format, PFX, mlx4_bf_warning);
+				context->bf_page     = NULL;
+				context->bf_buf_size = 0;
+		} else {
+			context->bf_buf_size = bf_reg_size / 2;
+			context->bf_offset   = 0;
+			pthread_spin_init(&context->bf_lock,
+					  PTHREAD_PROCESS_PRIVATE);
+		}
+	} else {
+		context->bf_page     = NULL;
+		context->bf_buf_size = 0;
+	}
+
+	return 0;
+}
+#endif
+
 static int mlx4_init_context(struct verbs_device *v_device,
 				struct ibv_context *ibv_ctx, int cmd_fd)
 {
@@ -127,6 +180,7 @@ static int mlx4_init_context(struct verb
 	__u16				bf_reg_size;
 	struct mlx4_device              *dev = to_mdev(&v_device->device);
 	struct verbs_context *verbs_ctx = verbs_get_ctx(ibv_ctx);
+	int				ret;
 
 	/* memory footprint of mlx4_context and verbs_context share
 	* struct ibv_context.
@@ -168,29 +222,9 @@ static int mlx4_init_context(struct verb
 	mlx4_init_xsrq_table(&context->xsrq_table, context->num_qps);
 	pthread_mutex_init(&context->db_list_mutex, NULL);
 
-	context->uar = mmap(NULL, dev->page_size, PROT_WRITE,
-			    MAP_SHARED, cmd_fd, 0);
-	if (context->uar == MAP_FAILED)
-		return errno;
-
-	if (bf_reg_size) {
-		context->bf_page = mmap(NULL, dev->page_size,
-					PROT_WRITE, MAP_SHARED, cmd_fd,
-					dev->page_size);
-		if (context->bf_page == MAP_FAILED) {
-			fprintf(stderr, PFX "Warning: BlueFlame available, "
-				"but failed to mmap() BlueFlame page.\n");
-				context->bf_page     = NULL;
-				context->bf_buf_size = 0;
-		} else {
-			context->bf_buf_size = bf_reg_size / 2;
-			context->bf_offset   = 0;
-			pthread_spin_init(&context->bf_lock, PTHREAD_PROCESS_PRIVATE);
-		}
-	} else {
-		context->bf_page     = NULL;
-		context->bf_buf_size = 0;
-	}
+	ret = mlx4_context_init_mapping(context, cmd_fd, bf_reg_size, dev);
+	if (ret)
+		return ret;
 
 	pthread_spin_init(&context->uar_lock, PTHREAD_PROCESS_PRIVATE);
 	ibv_ctx->ops = mlx4_ctx_ops;
@@ -208,6 +242,12 @@ static int mlx4_init_context(struct verb
 
 }
 
+#ifdef __s390x__
+static void mlx4_uninit_context(struct verbs_device *v_device,
+				struct ibv_context *ibv_ctx)
+{
+}
+#else
 static void mlx4_uninit_context(struct verbs_device *v_device,
 					struct ibv_context *ibv_ctx)
 {
@@ -218,6 +258,7 @@ static void mlx4_uninit_context(struct v
 		munmap(context->bf_page, to_mdev(&v_device->device)->page_size);
 
 }
+#endif
 
 static struct verbs_device *mlx4_driver_init(const char *uverbs_sys_path, int abi_version)
 {
--- a/src/mlx4.h
+++ b/src/mlx4.h
@@ -74,6 +74,8 @@
 #define wc_wmb() asm volatile("sfence" ::: "memory")
 #elif defined(__ia64__)
 #define wc_wmb() asm volatile("fwb" ::: "memory")
+#elif defined(__s390x__)
+#define wc_wmb { asm volatile("" : : : "memory") }
 #else
 #define wc_wmb() wmb()
 #endif
@@ -168,10 +170,14 @@ struct mlx4_db_page;
 struct mlx4_context {
 	struct ibv_context		ibv_ctx;
 
+#ifndef __s390x__
 	void			       *uar;
+#endif
 	pthread_spinlock_t		uar_lock;
 
+#ifndef __s390x__
 	void			       *bf_page;
+#endif
 	int				bf_buf_size;
 	int				bf_offset;
 	pthread_spinlock_t		bf_lock;
--- a/src/qp.c
+++ b/src/qp.c
@@ -173,13 +173,41 @@ static void set_data_seg(struct mlx4_wqe
 	dseg->byte_count = htonl(sg->length);
 }
 
+#ifdef __s390x__
+static inline void mlx4_bf_copy(struct mlx4_context *ctx,
+				unsigned long *src,
+				unsigned bytecnt)
+{
+	mlx4_kwrite_mmio(ctx->ibv_ctx.cmd_fd,
+			 IB_UVERBS_KWRITE_MMIO_BF_PAGE, /* BF page */
+			 ctx->bf_offset,
+			 bytecnt,
+			 src);
+
+}
+
+static inline void mlx4_send_doorbell(struct mlx4_context *ctx,
+					uint32_t offset,
+					uint32_t value)
+{
+	mlx4_kwrite_mmio(ctx->ibv_ctx.cmd_fd,
+			 IB_UVERBS_KWRITE_MMIO_UAR, /* UAR page */
+			 offset,
+			 sizeof(value),
+			 &value);
+}
+#else
 /*
  * Avoid using memcpy() to copy to BlueFlame page, since memcpy()
  * implementations may use move-string-buffer assembler instructions,
  * which do not guarantee order of copying.
  */
-static void mlx4_bf_copy(unsigned long *dst, unsigned long *src, unsigned bytecnt)
+static void mlx4_bf_copy(struct mlx4_context *ctx,
+			unsigned long *src,
+			unsigned bytecnt)
 {
+	unsigned long *dst = (unsigned long *)(ctx->bf_page + ctx->bf_offset);
+
 	while (bytecnt > 0) {
 		*dst++ = *src++;
 		*dst++ = *src++;
@@ -187,6 +215,14 @@ static void mlx4_bf_copy(unsigned long *
 	}
 }
 
+static inline void mlx4_send_doorbell(struct mlx4_context *ctx,
+					uint32_t offset,
+					uint32_t value)
+{
+	*(uint32_t *) (ctx->uar + offset) = value;
+}
+#endif
+
 int mlx4_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 			  struct ibv_send_wr **bad_wr)
 {
@@ -418,8 +454,7 @@ out:
 
 		pthread_spin_lock(&ctx->bf_lock);
 
-		mlx4_bf_copy(ctx->bf_page + ctx->bf_offset, (unsigned long *) ctrl,
-			     align(size * 16, 64));
+		mlx4_bf_copy(ctx, (unsigned long *) ctrl, align(size * 16, 64));
 		wc_wmb();
 
 		ctx->bf_offset ^= ctx->bf_buf_size;
@@ -434,7 +469,7 @@ out:
 		 */
 		wmb();
 
-		*(uint32_t *) (ctx->uar + MLX4_SEND_DOORBELL) = qp->doorbell_qpn;
+		mlx4_send_doorbell(ctx, MLX4_SEND_DOORBELL, qp->doorbell_qpn);
 	}
 
 	if (nreq)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
