From: Alexey Ishchuk <alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/4] DAPL: Support for Linux on System z in libmlx4 library
Date: Thu, 19 Dec 2013 12:53:17 +0100
Message-ID: <1387453998-27416-5-git-send-email-alexey_ishchuk@ru.ibm.com>
References: <1387453998-27416-1-git-send-email-alexey_ishchuk@ru.ibm.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1387453998-27416-1-git-send-email-alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, gilr-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, klaus.wacker-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

s390: Enable libmlx4 for use with DAPL on Linux on System z

The changes to libmlx4-1.0.5 userpace Mellanox device driver library required
to provide support for the DAPL programming interface on the System z platform.
The following System z-specific changes have been made:
	* code that used the mapped memory areas to access the PCI memory of
	  the Mellanox networking device was replaced by the kernelspace
	  device driver primitive calls.


diff -aurp /usr/src/packages/BUILD/libmlx4-1.0.5//src/doorbell.h libmlx4-1.0.5/src/doorbell.h
--- /usr/src/packages/BUILD/libmlx4-1.0.5//src/doorbell.h	2011-03-08 18:56:59.000000000 +0100
+++ libmlx4-1.0.5/src/doorbell.h	2013-12-12 09:11:40.843796712 +0100
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
+		IB_UVERBS_KWRITE_MMIO_UAR,	/* UAR page */
+		offset,
+		2 * sizeof(val[0]),
+		val);
+}
+
+#endif
 
 #endif /* DOORBELL_H */
diff -aurp /usr/src/packages/BUILD/libmlx4-1.0.5//src/mlx4.c libmlx4-1.0.5/src/mlx4.c
--- /usr/src/packages/BUILD/libmlx4-1.0.5//src/mlx4.c	2013-04-03 20:21:44.000000000 +0200
+++ libmlx4-1.0.5/src/mlx4.c	2013-12-12 09:14:56.563796712 +0100
@@ -169,12 +169,15 @@ static struct ibv_context *mlx4_alloc_co
 
 	pthread_mutex_init(&context->db_list_mutex, NULL);
 
+#ifndef __s390x__
 	context->uar = mmap(NULL, to_mdev(ibdev)->page_size, PROT_WRITE,
 			    MAP_SHARED, cmd_fd, 0);
 	if (context->uar == MAP_FAILED)
 		goto err_free;
 
+#endif
 	if (bf_reg_size) {
+#ifndef __s390x__
 		context->bf_page = mmap(NULL, to_mdev(ibdev)->page_size,
 					PROT_WRITE, MAP_SHARED, cmd_fd,
 					to_mdev(ibdev)->page_size);
@@ -184,12 +187,17 @@ static struct ibv_context *mlx4_alloc_co
 				context->bf_page     = NULL;
 				context->bf_buf_size = 0;
 		} else {
+#endif
 			context->bf_buf_size = bf_reg_size / 2;
 			context->bf_offset   = 0;
 			pthread_spin_init(&context->bf_lock, PTHREAD_PROCESS_PRIVATE);
+#ifndef __s390x__
 		}
+#endif
 	} else {
+#ifndef __s390x__
 		context->bf_page     = NULL;
+#endif
 		context->bf_buf_size = 0;
 	}
 
@@ -208,9 +216,11 @@ static void mlx4_free_context(struct ibv
 {
 	struct mlx4_context *context = to_mctx(ibctx);
 
+#ifndef __s390x__
 	munmap(context->uar, to_mdev(ibctx->device)->page_size);
 	if (context->bf_page)
 		munmap(context->bf_page, to_mdev(ibctx->device)->page_size);
+#endif
 	free(context);
 }
 
diff -aurp /usr/src/packages/BUILD/libmlx4-1.0.5//src/mlx4.h libmlx4-1.0.5/src/mlx4.h
--- /usr/src/packages/BUILD/libmlx4-1.0.5//src/mlx4.h	2013-04-03 20:40:27.000000000 +0200
+++ libmlx4-1.0.5/src/mlx4.h	2013-12-12 09:17:10.053796712 +0100
@@ -73,6 +73,8 @@
 #define wc_wmb() asm volatile("sfence" ::: "memory")
 #elif defined(__ia64__)
 #define wc_wmb() asm volatile("fwb" ::: "memory")
+#elif defined(__s390x__)
+#define wc_wmb asm volatile(::: "memory")
 #else
 #define wc_wmb() wmb()
 #endif
@@ -141,10 +143,14 @@ struct mlx4_db_page;
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
diff -aurp /usr/src/packages/BUILD/libmlx4-1.0.5//src/qp.c libmlx4-1.0.5/src/qp.c
--- /usr/src/packages/BUILD/libmlx4-1.0.5//src/qp.c	2013-04-03 20:34:11.000000000 +0200
+++ libmlx4-1.0.5/src/qp.c	2013-12-12 09:57:14.683796712 +0100
@@ -173,6 +173,7 @@ static void set_data_seg(struct mlx4_wqe
 	dseg->byte_count = htonl(sg->length);
 }
 
+#ifndef __s390x__
 /*
  * Avoid using memcpy() to copy to BlueFlame page, since memcpy()
  * implementations may use move-string-buffer assembler instructions,
@@ -187,6 +188,7 @@ static void mlx4_bf_copy(unsigned long *
 	}
 }
 
+#endif
 int mlx4_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 			  struct ibv_send_wr **bad_wr)
 {
@@ -415,8 +417,16 @@ out:
 
 		pthread_spin_lock(&ctx->bf_lock);
 
+#ifndef __s390x__
 		mlx4_bf_copy(ctx->bf_page + ctx->bf_offset, (unsigned long *) ctrl,
 			     align(size * 16, 64));
+#else
+	mlx4_kwrite_mmio(ctx->ibv_ctx.cmd_fd,
+			IB_UVERBS_KWRITE_MMIO_BF_PAGE, /* BF page */
+			ctx->bf_offset,
+			align(size * 16, 64),
+			ctrl);
+#endif
 		wc_wmb();
 
 		ctx->bf_offset ^= ctx->bf_buf_size;
@@ -430,8 +440,15 @@ out:
 		 * doorbell record.
 		 */
 		wmb();
-
+#ifndef __s390x__
 		*(uint32_t *) (ctx->uar + MLX4_SEND_DOORBELL) = qp->doorbell_qpn;
+#else
+		mlx4_kwrite_mmio(ctx->ibv_ctx.cmd_fd,
+				IB_UVERBS_KWRITE_MMIO_UAR, /* UAR page */
+				MLX4_SEND_DOORBELL,
+				sizeof(qp->doorbell_qpn),
+				&qp->doorbell_qpn);
+#endif
 	}
 
 	if (nreq)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
