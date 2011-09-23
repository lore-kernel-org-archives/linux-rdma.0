From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 6/7] IB/qib: memcpy optimizations
Date: Fri, 23 Sep 2011 13:16:54 -0400
Message-ID: <20110923171654.14542.72098.stgit@kop-dev-sles11-04.qlogic.org>
References: <20110923171623.14542.78747.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110923171623.14542.78747.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The default memcpy used by qib_copy_sge() ends up being a rep movsb on x86_64,
which is pretty slow.

This fix adds an x86_64 specific routine that 1) probes for X86_FEATURE_REP_GOOD
and 2) uses an inline asm routine builton rep movsq that testing has shown is
better than the builtin memcpy for all cases up to 4K.  The probing routine is
now called when the qib module is loaded to enable the optimization.   When
X86_FEATURE_REP_GOOD is not set, the routine uses the kernel's unrolled __memcpy
when the length is more than 64 and the builtin memcpy otherwise.

This patch also adds the cache bypass copies from older releases.  Testing has
shown that AMD cpus benefit with a 40% improvement in netperf/ipoib.

The cache_bypass_copy module parameter can be used to enable on non-AMD
CPUs.

The qib_verbs_send_dma() and qib_copy_from_sge are also changed to use the
memcpy_string_op() to improve packet delivery performance to the
send engine.

The existing copy as well as a new stub probe routine are maintained as weak
symbols for other architectures.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/Makefile                 |    2 
 .../infiniband/hw/qib/memcpy_cachebypass_x86_64.S  |  266 ++++++++++++++++++++
 drivers/infiniband/hw/qib/qib_copy_sge_x86_64.c    |  146 +++++++++++
 drivers/infiniband/hw/qib/qib_driver.c             |    5 
 drivers/infiniband/hw/qib/qib_init.c               |    1 
 drivers/infiniband/hw/qib/qib_rc.c                 |    1 
 drivers/infiniband/hw/qib/qib_uc.c                 |    1 
 drivers/infiniband/hw/qib/qib_verbs.c              |   16 +
 drivers/infiniband/hw/qib/qib_verbs.h              |   56 ++++
 9 files changed, 488 insertions(+), 6 deletions(-)
 create mode 100644 drivers/infiniband/hw/qib/memcpy_cachebypass_x86_64.S
 create mode 100644 drivers/infiniband/hw/qib/qib_copy_sge_x86_64.c

diff --git a/drivers/infiniband/hw/qib/Makefile b/drivers/infiniband/hw/qib/Makefile
index f12d7bb..911e24c 100644
--- a/drivers/infiniband/hw/qib/Makefile
+++ b/drivers/infiniband/hw/qib/Makefile
@@ -11,5 +11,5 @@ ib_qib-y := qib_cq.o qib_diag.o qib_dma.o qib_driver.o qib_eeprom.o \
 # 6120 has no fallback if no MSI interrupts, others can do INTx
 ib_qib-$(CONFIG_PCI_MSI) += qib_iba6120.o
 
-ib_qib-$(CONFIG_X86_64) += qib_wc_x86_64.o
+ib_qib-$(CONFIG_X86_64) += qib_wc_x86_64.o qib_copy_sge_x86_64.o memcpy_cachebypass_x86_64.o
 ib_qib-$(CONFIG_PPC64) += qib_wc_ppc64.o
diff --git a/drivers/infiniband/hw/qib/memcpy_cachebypass_x86_64.S b/drivers/infiniband/hw/qib/memcpy_cachebypass_x86_64.S
new file mode 100644
index 0000000..41096c2
--- /dev/null
+++ b/drivers/infiniband/hw/qib/memcpy_cachebypass_x86_64.S
@@ -0,0 +1,266 @@
+/*
+ * Copyright (c) 2006, 2007, 2008 QLogic Corporation. All rights reserved.
+ * Copyright (c) 2003, 2004, 2005, 2006 PathScale, Inc. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+	.text
+	.p2align 4,,15
+	/* rdi  destination, rsi source, rdx count */
+	.globl	memcpy_cachebypass
+	.type	memcpy_cachebypass, @function
+# loads bypass the cache, stores fill the cache
+memcpy_cachebypass:
+	movq	%rdi, %rax
+.L5:
+	cmpq	$15, %rdx
+	ja	.L34
+.L3:
+	cmpl	$8, %edx	/* rdx is 0..15 */
+	jbe	.L9
+.L6:
+	testb	$8, %dxl	/* rdx is 3,5,6,7,9..15 */
+	je	.L13
+	movq	(%rsi), %rcx
+	addq	$8, %rsi
+	movq	%rcx, (%rdi)
+	addq	$8, %rdi
+.L13:
+	testb	$4, %dxl
+	je	.L15
+	movl	(%rsi), %ecx
+	addq	$4, %rsi
+	movl	%ecx, (%rdi)
+	addq	$4, %rdi
+.L15:
+	testb	$2, %dxl
+	je	.L17
+	movzwl	(%rsi), %ecx
+	addq	$2, %rsi
+	movw	%cx, (%rdi)
+	addq	$2, %rdi
+.L17:
+	testb	$1, %dxl
+	je	.L33
+.L1:
+	movzbl	(%rsi), %ecx
+	movb	%cl, (%rdi)
+.L33:
+	ret
+.L34:
+	cmpq	$63, %rdx	/* rdx is > 15 */
+	ja	.L64
+	movl	$16, %ecx	/* rdx is 16..63 */
+.L25:
+	movq	8(%rsi), %r8
+	movq	(%rsi), %r9
+	addq	%rcx, %rsi
+	movq	%r8, 8(%rdi)
+	movq	%r9, (%rdi)
+	addq	%rcx, %rdi
+	subq	%rcx, %rdx
+	cmpl	%edx, %ecx	/* is rdx >= 16? */
+	jbe	.L25
+	jmp	.L3		/* rdx is 0..15 */
+	.p2align 4,,7
+.L64:
+	movl	$64, %ecx
+.L42:
+	prefetchnta	256(%rsi)
+	movq	(%rsi), %r8
+	movq	8(%rsi), %r9
+	movq	16(%rsi), %r10
+	movq	24(%rsi), %r11
+	subq	%rcx, %rdx
+	movq	%r8, (%rdi)
+	movq	32(%rsi), %r8
+	movq	%r9, 8(%rdi)
+	movq	40(%rsi), %r9
+	movq	%r10, 16(%rdi)
+	movq	48(%rsi), %r10
+	movq	%r11, 24(%rdi)
+	movq	56(%rsi), %r11
+	addq	%rcx, %rsi
+	movq	%r8, 32(%rdi)
+	movq	%r9, 40(%rdi)
+	movq	%r10, 48(%rdi)
+	movq	%r11, 56(%rdi)
+	addq	%rcx, %rdi
+	cmpq	%rdx, %rcx	/* is rdx >= 64? */
+	jbe	.L42
+	/*sfence */
+	orl	%edx, %edx
+	je	.L33
+	jmp	.L5
+.L9:
+	jmp	*.L12(,%rdx,8)	/* rdx is 0..8 */
+	.section	.rodata
+	.align 8
+	.align 4
+.L12:
+	.quad	.L33
+	.quad	.L1
+	.quad	.L2
+	.quad	.L6
+	.quad	.L4
+	.quad	.L6
+	.quad	.L6
+	.quad	.L6
+	.quad	.L8
+	.text
+.L2:
+	movzwl	(%rsi), %ecx
+	movw	%cx, (%rdi)
+	ret
+.L4:
+	movl	(%rsi), %ecx
+	movl	%ecx, (%rdi)
+	ret
+.L8:
+	movq	(%rsi), %rcx
+	movq	%rcx, (%rdi)
+	ret
+
+		.text
+	.p2align 4,,15
+	/* rdi  destination, rsi source, rdx count */
+	.globl	memcpy_cachebypass2
+	.type	memcpy_cachebypass2, @function
+# both loads and stores bypass the cache
+memcpy_cachebypass2:
+	movq	%rdi, %rax
+.L2_5:
+	cmpq	$15, %rdx
+	ja	.L2_34
+.L2_3:
+	cmpl	$8, %edx	/* rdx is 0..15 */
+	jbe	.L2_9
+.L2_6:
+	testb	$8, %dxl	/* rdx is 3,5,6,7,9..15 */
+	je	.L2_13
+	movq	(%rsi), %rcx
+	addq	$8, %rsi
+	movq	%rcx, (%rdi)
+	addq	$8, %rdi
+.L2_13:
+	testb	$4, %dxl
+	je	.L2_15
+	movl	(%rsi), %ecx
+	addq	$4, %rsi
+	movl	%ecx, (%rdi)
+	addq	$4, %rdi
+.L2_15:
+	testb	$2, %dxl
+	je	.L2_17
+	movzwl	(%rsi), %ecx
+	addq	$2, %rsi
+	movw	%cx, (%rdi)
+	addq	$2, %rdi
+.L2_17:
+	testb	$1, %dxl
+	je	.L2_33
+.L2_1:
+	movzbl	(%rsi), %ecx
+	movb	%cl, (%rdi)
+.L2_33:
+	ret
+.L2_34:
+	cmpq	$63, %rdx	/* rdx is > 15 */
+	ja	.L2_64
+	movl	$16, %ecx	/* rdx is 16..63 */
+.L2_25:
+	movq	8(%rsi), %r8
+	movq	(%rsi), %r9
+	addq	%rcx, %rsi
+	movq	%r8, 8(%rdi)
+	movq	%r9, (%rdi)
+	addq	%rcx, %rdi
+	subq	%rcx, %rdx
+	cmpl	%edx, %ecx	/* is rdx >= 16? */
+	jbe	.L2_25
+	jmp	.L2_3		/* rdx is 0..15 */
+	.p2align 4,,7
+.L2_64:
+	movl	$64, %ecx
+.L2_42:
+	prefetchnta	256(%rsi)
+	movq	(%rsi), %r8
+	movq	8(%rsi), %r9
+	movq	16(%rsi), %r10
+	movq	24(%rsi), %r11
+	subq	%rcx, %rdx
+	movnti	%r8, (%rdi)
+	movq	32(%rsi), %r8
+	movnti	%r9, 8(%rdi)
+	movq	40(%rsi), %r9
+	movnti	%r10, 16(%rdi)
+	movq	48(%rsi), %r10
+	movnti	%r11, 24(%rdi)
+	movq	56(%rsi), %r11
+	addq	%rcx, %rsi
+	movnti	%r8, 32(%rdi)
+	movnti	%r9, 40(%rdi)
+	movnti	%r10, 48(%rdi)
+	movnti	%r11, 56(%rdi)
+	addq	%rcx, %rdi
+	cmpq	%rdx, %rcx	/* is rdx >= 64? */
+	jbe	.L2_42
+	sfence
+	orl	%edx, %edx
+	je	.L2_33
+	jmp	.L2_5
+.L2_9:
+	jmp	*.L2_12(,%rdx,8)	/* rdx is 0..8 */
+	.section	.rodata
+	.align 8
+	.align 4
+.L2_12:
+	.quad	.L2_33
+	.quad	.L2_1
+	.quad	.L2_2
+	.quad	.L2_6
+	.quad	.L2_4
+	.quad	.L2_6
+	.quad	.L2_6
+	.quad	.L2_6
+	.quad	.L2_8
+	.text
+.L2_2:
+	movzwl	(%rsi), %ecx
+	movw	%cx, (%rdi)
+	ret
+.L2_4:
+	movl	(%rsi), %ecx
+	movl	%ecx, (%rdi)
+	ret
+.L2_8:
+	movq	(%rsi), %rcx
+	movq	%rcx, (%rdi)
+	ret
diff --git a/drivers/infiniband/hw/qib/qib_copy_sge_x86_64.c b/drivers/infiniband/hw/qib/qib_copy_sge_x86_64.c
new file mode 100644
index 0000000..44a80d5
--- /dev/null
+++ b/drivers/infiniband/hw/qib/qib_copy_sge_x86_64.c
@@ -0,0 +1,146 @@
+/*
+ * Copyright (c) 2006, 2007, 2008, 2009, 2010, 2011 QLogic Corporation.
+ * All rights reserved.
+ * Copyright (c) 2003, 2004, 2005, 2006 PathScale, Inc. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+/*
+ * This file is conditionally built on x86_64 only.  Otherwise weak symbol
+ * versions of the functions exported from here are used.
+ */
+
+#include <linux/pci.h>
+#include <asm/mtrr.h>
+#include <asm/processor.h>
+
+#include "qib.h"
+
+static int use_string_ops;
+
+static unsigned qib_ss_size;
+module_param_named(ss_size, qib_ss_size, uint, S_IRUGO);
+MODULE_PARM_DESC(ss_size,
+	"Threshold to use streaming store (default is 512K)");
+
+static unsigned qib_cache_bypass_copy;
+module_param_named(cache_bypass_copy, qib_cache_bypass_copy, uint, S_IRUGO);
+MODULE_PARM_DESC(cache_bypass_copy, "Use cache bypass copies");
+
+void *memcpy_cachebypass(void *, const void *, __kernel_size_t);
+void *memcpy_cachebypass2(void *, const void *, __kernel_size_t);
+
+/**
+ * qib_copy_sge - copy data to SGE memory
+ * @ss: the SGE state
+ * @data: the data to copy
+ * @length: the length of the data
+ */
+void qib_copy_sge(struct qib_sge_state *ss, void *data, u32 length, int release)
+{
+	struct qib_sge *sge = &ss->sge;
+
+	while (length) {
+		u32 len;
+		len = sge->length;
+
+		if (len > length)
+			len = length;
+		if (len > sge->sge_length)
+			len = sge->sge_length;
+		BUG_ON(len == 0);
+		if (!qib_cache_bypass_copy) {
+			if (use_string_ops)
+				memcpy_string_op(sge->vaddr, data, len);
+			else {
+				if (len < 64)
+					memcpy(sge->vaddr, data, len);
+				else
+					__memcpy(sge->vaddr, data, len);
+			}
+		} else {
+			if ((!sge->mr->pd || !to_ipd(sge->mr->pd)->user)
+					&& ss->total_len >= qib_ss_size)
+				memcpy_cachebypass2(sge->vaddr, data, len);
+			else
+				memcpy_cachebypass(sge->vaddr, data, len);
+		}
+		sge->vaddr += len;
+		sge->length -= len;
+		sge->sge_length -= len;
+		if (sge->sge_length == 0) {
+			if (release)
+				atomic_dec(&sge->mr->refcount);
+			if (--ss->num_sge)
+				*sge = *ss->sg_list++;
+		} else if (sge->length == 0 && sge->mr->lkey) {
+			if (++sge->n >= QIB_SEGSZ) {
+				if (++sge->m >= sge->mr->mapsz)
+					break;
+				sge->n = 0;
+			}
+			sge->vaddr =
+				sge->mr->map[sge->m]->segs[sge->n].vaddr;
+			sge->length =
+				sge->mr->map[sge->m]->segs[sge->n].length;
+		}
+		data += len;
+		length -= len;
+	}
+}
+
+void qib_copy_sge_init(void)
+{
+	if (!qib_cache_bypass_copy) {
+		if (boot_cpu_has(X86_FEATURE_REP_GOOD)) {
+			use_string_ops = 1;
+		} else {
+			if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
+					boot_cpu_data.x86 == 6)
+				use_string_ops = 1;
+			if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD) {
+				if (boot_cpu_data.x86 == 0xf) {
+					u32 level;
+					level = cpuid_eax(1);
+					if ((level >= 0x0f48
+					    && level < 0x0f50) ||
+					    level >= 0x0f58)
+						use_string_ops = 1;
+				} else
+					if (boot_cpu_data.x86 >= 0x10)
+						use_string_ops = 1;
+			}
+		}
+		if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
+			qib_cache_bypass_copy = 1;
+	}
+	if (!qib_ss_size)
+		qib_ss_size = 512 * 1024;
+}
diff --git a/drivers/infiniband/hw/qib/qib_driver.c b/drivers/infiniband/hw/qib/qib_driver.c
index d35c9d3..1ba9da9 100644
--- a/drivers/infiniband/hw/qib/qib_driver.c
+++ b/drivers/infiniband/hw/qib/qib_driver.c
@@ -281,8 +281,11 @@ static inline void *qib_get_egrbuf(const struct qib_ctxtdata *rcd, u32 etail)
 {
 	const u32 chunk = etail >> rcd->rcvegrbufs_perchunk_shift;
 	const u32 idx =  etail & ((u32)rcd->rcvegrbufs_perchunk - 1);
+	void *rval;
 
-	return rcd->rcvegrbuf[chunk] + (idx << rcd->dd->rcvegrbufsize_shift);
+	rval = rcd->rcvegrbuf[chunk] + (idx << rcd->dd->rcvegrbufsize_shift);
+	qib_eager_prefetch(rval);
+	return rval;
 }
 
 /*
diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index 21ffa7c..22a82d5 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -1043,6 +1043,7 @@ static int __init qlogic_ib_init(void)
 {
 	int ret;
 
+	qib_copy_sge_init();
 	ret = qib_dev_init();
 	if (ret)
 		goto bail;
diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index ecfa087..a75b713 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -2083,6 +2083,7 @@ send_last:
 			if (unlikely(!ok))
 				goto nack_acc;
 			qp->r_sge.num_sge = 1;
+			qp->r_sge.total_len = be32_to_cpu(reth->length);
 		} else {
 			qp->r_sge.num_sge = 0;
 			qp->r_sge.sge.mr = NULL;
diff --git a/drivers/infiniband/hw/qib/qib_uc.c b/drivers/infiniband/hw/qib/qib_uc.c
index 9a4630f..7aa346f 100644
--- a/drivers/infiniband/hw/qib/qib_uc.c
+++ b/drivers/infiniband/hw/qib/qib_uc.c
@@ -456,6 +456,7 @@ rdma_first:
 			if (unlikely(!ok))
 				goto drop;
 			qp->r_sge.num_sge = 1;
+			qp->r_sge.total_len = be32_to_cpu(reth->length);
 		} else {
 			qp->r_sge.num_sge = 0;
 			qp->r_sge.sge.mr = NULL;
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 9627cb7..094e396 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -159,12 +159,20 @@ const enum ib_wc_opcode ib_qib_wc_opcode[] = {
 __be64 ib_qib_sys_image_guid;
 
 /**
+ * qib_copy_sge_init - setup for fast sge copy
+ */
+void __attribute__((weak)) qib_copy_sge_init(void)
+{
+}
+
+/**
  * qib_copy_sge - copy data to SGE memory
  * @ss: the SGE state
  * @data: the data to copy
  * @length: the length of the data
  */
-void qib_copy_sge(struct qib_sge_state *ss, void *data, u32 length, int release)
+void __attribute__((weak))
+qib_copy_sge(struct qib_sge_state *ss, void *data, u32 length, int release)
 {
 	struct qib_sge *sge = &ss->sge;
 
@@ -304,7 +312,7 @@ static void qib_copy_from_sge(void *data, struct qib_sge_state *ss, u32 length)
 		if (len > sge->sge_length)
 			len = sge->sge_length;
 		BUG_ON(len == 0);
-		memcpy(data, sge->vaddr, len);
+		memcpy_string_op(data, sge->vaddr, len);
 		sge->vaddr += len;
 		sge->length -= len;
 		sge->sge_length -= len;
@@ -1155,7 +1163,7 @@ static int qib_verbs_send_dma(struct qib_qp *qp, struct qib_ib_header *hdr,
 		phdr = &dev->pio_hdrs[tx->hdr_inx];
 		phdr->pbc[0] = cpu_to_le32(plen);
 		phdr->pbc[1] = cpu_to_le32(control);
-		memcpy(&phdr->hdr, hdr, hdrwords << 2);
+		memcpy_string_op(&phdr->hdr, hdr, hdrwords << 2);
 		tx->txreq.flags |= QIB_SDMA_TXREQ_F_FREEDESC;
 		tx->txreq.sg_count = ndesc;
 		tx->txreq.addr = dev->pio_hdrs_phys +
@@ -1172,7 +1180,7 @@ static int qib_verbs_send_dma(struct qib_qp *qp, struct qib_ib_header *hdr,
 		goto err_tx;
 	phdr->pbc[0] = cpu_to_le32(plen);
 	phdr->pbc[1] = cpu_to_le32(control);
-	memcpy(&phdr->hdr, hdr, hdrwords << 2);
+	memcpy_string_op(&phdr->hdr, hdr, hdrwords << 2);
 	qib_copy_from_sge((u32 *) &phdr->hdr + hdrwords, ss, len);
 
 	tx->txreq.addr = dma_map_single(&dd->pcidev->dev, phdr,
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index 0c19ef0..63b596e 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -901,6 +901,62 @@ void qib_put_txreq(struct qib_verbs_txreq *tx);
 int qib_verbs_send(struct qib_qp *qp, struct qib_ib_header *hdr,
 		   u32 hdrwords, struct qib_sge_state *ss, u32 len);
 
+#ifdef CONFIG_X86_64
+
+extern void *__memcpy(void *dst, const void *src, size_t n);
+
+static inline void qib_eager_prefetch(void *src)
+{
+	__asm__ __volatile__(
+		"prefetchnta (%0)\n"
+		"prefetchnta 64(%0)\n"
+		"prefetchnta 128(%0)\n"
+		"prefetchnta 192(%0)\n"
+	: /* no output */
+	: "S" (src)
+	);
+}
+
+static inline void *memcpy_string_op(void *dst, const void *src, size_t n)
+{
+	__asm__ __volatile__(
+		"        movq %2, %%rax\n"
+		"        shrq $3, %2\n"
+		"        je 1f\n"
+		"        cld\n"
+		"        rep movsq\n"
+		"1:      movq %%rax, %2\n"
+		"        andq $7, %2\n"
+		"        je 3f\n"
+		"2:      movb (%1), %%al\n"
+		"        incq %1\n"
+		"        movb %%al, (%0)\n"
+		"        incq %0\n"
+		"        decq %2\n"
+		"        jne 2b\n"
+		"3:\n"
+	: "+D" (dst), "+S" (src), "+c" (n)
+	:
+	: "rax", "memory");
+	return dst;
+
+}
+
+#else
+
+static inline void qib_eager_prefetch(void *src)
+{
+}
+
+static inline void *memcpy_string_op(void *dst, const void *src, size_t n)
+{
+	return memcpy(dst, src, n);
+}
+
+#endif
+
+void qib_copy_sge_init(void);
+
 void qib_copy_sge(struct qib_sge_state *ss, void *data, u32 length,
 		  int release);
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
