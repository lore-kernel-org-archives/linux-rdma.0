From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core 6/7] Always user internal kernel headers when building
Date: Thu,  8 Feb 2018 20:09:03 -0700
Message-ID: <20180209030904.22370-7-jgg@ziepe.ca>
References: <20180209030904.22370-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180209030904.22370-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Move the kernel headers out of buildlib/fixup-include/ and into
kernel-headers/ and bring in the complete set of include/uapi/
kernel headers.

The build will always use these internal headers, we no longer
attempt to use the distro headers.

These headers are not installed and cannot be referenced from
our public headers.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 CMakeLists.txt                                     |   6 +-
 buildlib/RDMA_LinuxHeaders.cmake                   |  98 -----
 kernel-headers/CMakeLists.txt                      |  27 ++
 kernel-headers/rdma/bnxt_re-abi.h                  | 101 +++++
 kernel-headers/rdma/cxgb3-abi.h                    |  77 ++++
 kernel-headers/rdma/cxgb4-abi.h                    |  82 ++++
 kernel-headers/rdma/hfi/hfi1_ioctl.h               | 174 +++++++++
 kernel-headers/rdma/hfi/hfi1_user.h                | 267 +++++++++++++
 kernel-headers/rdma/hns-abi.h                      |  55 +++
 kernel-headers/rdma/ib_user_cm.h                   | 326 ++++++++++++++++
 kernel-headers/rdma/ib_user_ioctl_verbs.h          |  84 +++++
 kernel-headers/rdma/ib_user_mad.h                  | 234 ++++++++++++
 kernel-headers/rdma/ib_user_sa.h                   |  77 ++++
 .../rdma/ib_user_verbs.h                           |   7 +-
 kernel-headers/rdma/mlx4-abi.h                     | 159 ++++++++
 kernel-headers/rdma/mlx5-abi.h                     | 416 +++++++++++++++++++++
 kernel-headers/rdma/mthca-abi.h                    | 112 ++++++
 kernel-headers/rdma/nes-abi.h                      | 115 ++++++
 kernel-headers/rdma/ocrdma-abi.h                   | 152 ++++++++
 kernel-headers/rdma/qedr-abi.h                     | 110 ++++++
 .../rdma/rdma_netlink.h                            | 134 ++++++-
 kernel-headers/rdma/rdma_user_cm.h                 | 311 +++++++++++++++
 kernel-headers/rdma/rdma_user_ioctl.h              | 121 ++++++
 .../rdma/rdma_user_rxe.h                           |   5 +-
 .../rdma/vmw_pvrdma-abi.h                          |   0
 25 files changed, 3144 insertions(+), 106 deletions(-)
 delete mode 100644 buildlib/RDMA_LinuxHeaders.cmake
 create mode 100644 kernel-headers/CMakeLists.txt
 create mode 100644 kernel-headers/rdma/bnxt_re-abi.h
 create mode 100644 kernel-headers/rdma/cxgb3-abi.h
 create mode 100644 kernel-headers/rdma/cxgb4-abi.h
 create mode 100644 kernel-headers/rdma/hfi/hfi1_ioctl.h
 create mode 100644 kernel-headers/rdma/hfi/hfi1_user.h
 create mode 100644 kernel-headers/rdma/hns-abi.h
 create mode 100644 kernel-headers/rdma/ib_user_cm.h
 create mode 100644 kernel-headers/rdma/ib_user_ioctl_verbs.h
 create mode 100644 kernel-headers/rdma/ib_user_mad.h
 create mode 100644 kernel-headers/rdma/ib_user_sa.h
 rename buildlib/fixup-include/rdma-ib_user_verbs.h => kernel-headers/rdma/ib_user_verbs.h (99%)
 create mode 100644 kernel-headers/rdma/mlx4-abi.h
 create mode 100644 kernel-headers/rdma/mlx5-abi.h
 create mode 100644 kernel-headers/rdma/mthca-abi.h
 create mode 100644 kernel-headers/rdma/nes-abi.h
 create mode 100644 kernel-headers/rdma/ocrdma-abi.h
 create mode 100644 kernel-headers/rdma/qedr-abi.h
 rename buildlib/fixup-include/rdma-rdma_netlink.h => kernel-headers/rdma/rdma_netlink.h (59%)
 create mode 100644 kernel-headers/rdma/rdma_user_cm.h
 create mode 100644 kernel-headers/rdma/rdma_user_ioctl.h
 rename buildlib/fixup-include/rdma-rdma_user_rxe.h => kernel-headers/rdma/rdma_user_rxe.h (95%)
 rename buildlib/fixup-include/rdma-vmw_pvrdma-abi.h => kernel-headers/rdma/vmw_pvrdma-abi.h (100%)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 3ba9a0bc6989d2..58e4ba75756ebe 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -22,8 +22,6 @@
 #      Produce static libraries along with the usual shared libraries.
 #  -DVERBS_PROVIDER_DIR='' (default /usr/lib.../libibverbs)
 #      Use the historical search path for providers, in the standard system library.
-#  -DKERNEL_DIR='.../linux' (default '')
-#      If set use the kernel UAPI headers from this kernel source tree.
 #  -DNO_COMPAT_SYMS=1 (default disabled)
 #      Do not generate backwards compatibility symbols in the shared
 #      libraries. This may is necessary if using a dynmic linker that does
@@ -348,8 +346,6 @@ include_directories(${UDEV_INCLUDE_DIRS})
 # should rely on this.
 check_type_size("long" SIZEOF_LONG BUILTIN_TYPES_ONLY LANGUAGE C)
 
-include(RDMA_LinuxHeaders)
-
 # Determine if this arch supports cache coherent DMA. This isn't really an
 # arch specific property, but for our purposes arches that do not support it
 # also do not define wmb/etc which breaks our compile.
@@ -433,6 +429,7 @@ add_subdirectory(ccan)
 add_subdirectory(util)
 add_subdirectory(Documentation)
 add_subdirectory(kernel-boot)
+add_subdirectory(kernel-headers)
 # Libraries
 add_subdirectory(libibumad)
 add_subdirectory(libibumad/man)
@@ -517,7 +514,6 @@ endif()
 if (NOT UDEV_FOUND)
   message(STATUS " libudev NOT found (disabling features)")
 endif()
-rdma_report_missing_kheaders()
 if (NOT HAVE_C_WARNINGS)
   message(STATUS " extended C warnings NOT supported")
 endif()
diff --git a/buildlib/RDMA_LinuxHeaders.cmake b/buildlib/RDMA_LinuxHeaders.cmake
deleted file mode 100644
index 05dfd224bb9392..00000000000000
diff --git a/kernel-headers/CMakeLists.txt b/kernel-headers/CMakeLists.txt
new file mode 100644
index 00000000000000..64bc5e66c21b18
--- /dev/null
+++ b/kernel-headers/CMakeLists.txt
@@ -0,0 +1,27 @@
+publish_internal_headers(rdma
+  rdma/bnxt_re-abi.h
+  rdma/cxgb3-abi.h
+  rdma/cxgb4-abi.h
+  rdma/hns-abi.h
+  rdma/ib_user_cm.h
+  rdma/ib_user_ioctl_verbs.h
+  rdma/ib_user_mad.h
+  rdma/ib_user_sa.h
+  rdma/ib_user_verbs.h
+  rdma/mlx4-abi.h
+  rdma/mlx5-abi.h
+  rdma/mthca-abi.h
+  rdma/nes-abi.h
+  rdma/ocrdma-abi.h
+  rdma/qedr-abi.h
+  rdma/rdma_netlink.h
+  rdma/rdma_user_cm.h
+  rdma/rdma_user_ioctl.h
+  rdma/rdma_user_rxe.h
+  rdma/vmw_pvrdma-abi.h
+  )
+
+publish_internal_headers(rdma/hfi
+  rdma/hfi/hfi1_ioctl.h
+  rdma/hfi/hfi1_user.h
+  )
diff --git a/kernel-headers/rdma/bnxt_re-abi.h b/kernel-headers/rdma/bnxt_re-abi.h
new file mode 100644
index 00000000000000..db54115be0447a
--- /dev/null
+++ b/kernel-headers/rdma/bnxt_re-abi.h
@@ -0,0 +1,101 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause) */
+/*
+ * Broadcom NetXtreme-E RoCE driver.
+ *
+ * Copyright (c) 2016 - 2017, Broadcom. All rights reserved.  The term
+ * Broadcom refers to Broadcom Limited and/or its subsidiaries.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * BSD license below:
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS''
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
+ * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
+ * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS
+ * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
+ * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
+ * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
+ * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
+ * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ * Description: Uverbs ABI header file
+ */
+
+#ifndef __BNXT_RE_UVERBS_ABI_H__
+#define __BNXT_RE_UVERBS_ABI_H__
+
+#include <linux/types.h>
+
+#define BNXT_RE_ABI_VERSION	1
+
+struct bnxt_re_uctx_resp {
+	__u32 dev_id;
+	__u32 max_qp;
+	__u32 pg_size;
+	__u32 cqe_sz;
+	__u32 max_cqd;
+	__u32 rsvd;
+};
+
+struct bnxt_re_pd_resp {
+	__u32 pdid;
+	__u32 dpi;
+	__u64 dbr;
+};
+
+struct bnxt_re_cq_req {
+	__u64 cq_va;
+	__u64 cq_handle;
+};
+
+struct bnxt_re_cq_resp {
+	__u32 cqid;
+	__u32 tail;
+	__u32 phase;
+	__u32 rsvd;
+};
+
+struct bnxt_re_qp_req {
+	__u64 qpsva;
+	__u64 qprva;
+	__u64 qp_handle;
+};
+
+struct bnxt_re_qp_resp {
+	__u32 qpid;
+	__u32 rsvd;
+};
+
+struct bnxt_re_srq_req {
+	__u64 srqva;
+	__u64 srq_handle;
+};
+
+struct bnxt_re_srq_resp {
+	__u32 srqid;
+};
+
+enum bnxt_re_shpg_offt {
+	BNXT_RE_BEG_RESV_OFFT	= 0x00,
+	BNXT_RE_AVID_OFFT	= 0x10,
+	BNXT_RE_AVID_SIZE	= 0x04,
+	BNXT_RE_END_RESV_OFFT	= 0xFF0
+};
+
+#endif /* __BNXT_RE_UVERBS_ABI_H__*/
diff --git a/kernel-headers/rdma/cxgb3-abi.h b/kernel-headers/rdma/cxgb3-abi.h
new file mode 100644
index 00000000000000..d5745e43ae8571
--- /dev/null
+++ b/kernel-headers/rdma/cxgb3-abi.h
@@ -0,0 +1,77 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause) */
+/*
+ * Copyright (c) 2006 Chelsio, Inc. All rights reserved.
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
+#ifndef CXGB3_ABI_USER_H
+#define CXGB3_ABI_USER_H
+
+#include <linux/types.h>
+
+#define IWCH_UVERBS_ABI_VERSION	1
+
+/*
+ * Make sure that all structs defined in this file remain laid out so
+ * that they pack the same way on 32-bit and 64-bit architectures (to
+ * avoid incompatibility between 32-bit userspace and 64-bit kernels).
+ * In particular do not use pointer types -- pass pointers in __u64
+ * instead.
+ */
+struct iwch_create_cq_req {
+	__u64 user_rptr_addr;
+};
+
+struct iwch_create_cq_resp_v0 {
+	__u64 key;
+	__u32 cqid;
+	__u32 size_log2;
+};
+
+struct iwch_create_cq_resp {
+	__u64 key;
+	__u32 cqid;
+	__u32 size_log2;
+	__u32 memsize;
+	__u32 reserved;
+};
+
+struct iwch_create_qp_resp {
+	__u64 key;
+	__u64 db_key;
+	__u32 qpid;
+	__u32 size_log2;
+	__u32 sq_size_log2;
+	__u32 rq_size_log2;
+};
+
+struct iwch_reg_user_mr_resp {
+	__u32 pbl_addr;
+};
+#endif /* CXGB3_ABI_USER_H */
diff --git a/kernel-headers/rdma/cxgb4-abi.h b/kernel-headers/rdma/cxgb4-abi.h
new file mode 100644
index 00000000000000..05f71f1bc1194d
--- /dev/null
+++ b/kernel-headers/rdma/cxgb4-abi.h
@@ -0,0 +1,82 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause) */
+/*
+ * Copyright (c) 2009-2010 Chelsio, Inc. All rights reserved.
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
+#ifndef CXGB4_ABI_USER_H
+#define CXGB4_ABI_USER_H
+
+#include <linux/types.h>
+
+#define C4IW_UVERBS_ABI_VERSION	3
+
+/*
+ * Make sure that all structs defined in this file remain laid out so
+ * that they pack the same way on 32-bit and 64-bit architectures (to
+ * avoid incompatibility between 32-bit userspace and 64-bit kernels).
+ * In particular do not use pointer types -- pass pointers in __u64
+ * instead.
+ */
+struct c4iw_create_cq_resp {
+	__u64 key;
+	__u64 gts_key;
+	__u64 memsize;
+	__u32 cqid;
+	__u32 size;
+	__u32 qid_mask;
+	__u32 reserved; /* explicit padding (optional for i386) */
+};
+
+enum {
+	C4IW_QPF_ONCHIP = (1 << 0)
+};
+
+struct c4iw_create_qp_resp {
+	__u64 ma_sync_key;
+	__u64 sq_key;
+	__u64 rq_key;
+	__u64 sq_db_gts_key;
+	__u64 rq_db_gts_key;
+	__u64 sq_memsize;
+	__u64 rq_memsize;
+	__u32 sqid;
+	__u32 rqid;
+	__u32 sq_size;
+	__u32 rq_size;
+	__u32 qid_mask;
+	__u32 flags;
+};
+
+struct c4iw_alloc_ucontext_resp {
+	__u64 status_page_key;
+	__u32 status_page_size;
+	__u32 reserved; /* explicit padding (optional for i386) */
+};
+#endif /* CXGB4_ABI_USER_H */
diff --git a/kernel-headers/rdma/hfi/hfi1_ioctl.h b/kernel-headers/rdma/hfi/hfi1_ioctl.h
new file mode 100644
index 00000000000000..9de78c5ee9139e
--- /dev/null
+++ b/kernel-headers/rdma/hfi/hfi1_ioctl.h
@@ -0,0 +1,174 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
+/*
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2015 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2015 Intel Corporation.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  - Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  - Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  - Neither the name of Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+
+#ifndef _LINUX__HFI1_IOCTL_H
+#define _LINUX__HFI1_IOCTL_H
+#include <linux/types.h>
+
+/*
+ * This structure is passed to the driver to tell it where
+ * user code buffers are, sizes, etc.   The offsets and sizes of the
+ * fields must remain unchanged, for binary compatibility.  It can
+ * be extended, if userversion is changed so user code can tell, if needed
+ */
+struct hfi1_user_info {
+	/*
+	 * version of user software, to detect compatibility issues.
+	 * Should be set to HFI1_USER_SWVERSION.
+	 */
+	__u32 userversion;
+	__u32 pad;
+	/*
+	 * If two or more processes wish to share a context, each process
+	 * must set the subcontext_cnt and subcontext_id to the same
+	 * values.  The only restriction on the subcontext_id is that
+	 * it be unique for a given node.
+	 */
+	__u16 subctxt_cnt;
+	__u16 subctxt_id;
+	/* 128bit UUID passed in by PSM. */
+	__u8 uuid[16];
+};
+
+struct hfi1_ctxt_info {
+	__u64 runtime_flags;    /* chip/drv runtime flags (HFI1_CAP_*) */
+	__u32 rcvegr_size;      /* size of each eager buffer */
+	__u16 num_active;       /* number of active units */
+	__u16 unit;             /* unit (chip) assigned to caller */
+	__u16 ctxt;             /* ctxt on unit assigned to caller */
+	__u16 subctxt;          /* subctxt on unit assigned to caller */
+	__u16 rcvtids;          /* number of Rcv TIDs for this context */
+	__u16 credits;          /* number of PIO credits for this context */
+	__u16 numa_node;        /* NUMA node of the assigned device */
+	__u16 rec_cpu;          /* cpu # for affinity (0xffff if none) */
+	__u16 send_ctxt;        /* send context in use by this user context */
+	__u16 egrtids;          /* number of RcvArray entries for Eager Rcvs */
+	__u16 rcvhdrq_cnt;      /* number of RcvHdrQ entries */
+	__u16 rcvhdrq_entsize;  /* size (in bytes) for each RcvHdrQ entry */
+	__u16 sdma_ring_size;   /* number of entries in SDMA request ring */
+};
+
+struct hfi1_tid_info {
+	/* virtual address of first page in transfer */
+	__u64 vaddr;
+	/* pointer to tid array. this array is big enough */
+	__u64 tidlist;
+	/* number of tids programmed by this request */
+	__u32 tidcnt;
+	/* length of transfer buffer programmed by this request */
+	__u32 length;
+};
+
+/*
+ * This structure is returned by the driver immediately after
+ * open to get implementation-specific info, and info specific to this
+ * instance.
+ *
+ * This struct must have explicit pad fields where type sizes
+ * may result in different alignments between 32 and 64 bit
+ * programs, since the 64 bit * bit kernel requires the user code
+ * to have matching offsets
+ */
+struct hfi1_base_info {
+	/* version of hardware, for feature checking. */
+	__u32 hw_version;
+	/* version of software, for feature checking. */
+	__u32 sw_version;
+	/* Job key */
+	__u16 jkey;
+	__u16 padding1;
+	/*
+	 * The special QP (queue pair) value that identifies PSM
+	 * protocol packet from standard IB packets.
+	 */
+	__u32 bthqp;
+	/* PIO credit return address, */
+	__u64 sc_credits_addr;
+	/*
+	 * Base address of write-only pio buffers for this process.
+	 * Each buffer has sendpio_credits*64 bytes.
+	 */
+	__u64 pio_bufbase_sop;
+	/*
+	 * Base address of write-only pio buffers for this process.
+	 * Each buffer has sendpio_credits*64 bytes.
+	 */
+	__u64 pio_bufbase;
+	/* address where receive buffer queue is mapped into */
+	__u64 rcvhdr_bufbase;
+	/* base address of Eager receive buffers. */
+	__u64 rcvegr_bufbase;
+	/* base address of SDMA completion ring */
+	__u64 sdma_comp_bufbase;
+	/*
+	 * User register base for init code, not to be used directly by
+	 * protocol or applications.  Always maps real chip register space.
+	 * the register addresses are:
+	 * ur_rcvhdrhead, ur_rcvhdrtail, ur_rcvegrhead, ur_rcvegrtail,
+	 * ur_rcvtidflow
+	 */
+	__u64 user_regbase;
+	/* notification events */
+	__u64 events_bufbase;
+	/* status page */
+	__u64 status_bufbase;
+	/* rcvhdrtail update */
+	__u64 rcvhdrtail_base;
+	/*
+	 * shared memory pages for subctxts if ctxt is shared; these cover
+	 * all the processes in the group sharing a single context.
+	 * all have enough space for the num_subcontexts value on this job.
+	 */
+	__u64 subctxt_uregbase;
+	__u64 subctxt_rcvegrbuf;
+	__u64 subctxt_rcvhdrbuf;
+};
+#endif /* _LINIUX__HFI1_IOCTL_H */
diff --git a/kernel-headers/rdma/hfi/hfi1_user.h b/kernel-headers/rdma/hfi/hfi1_user.h
new file mode 100644
index 00000000000000..43b46bf6f8bb10
--- /dev/null
+++ b/kernel-headers/rdma/hfi/hfi1_user.h
@@ -0,0 +1,267 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
+/*
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2015 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2015 Intel Corporation.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  - Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  - Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  - Neither the name of Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+
+/*
+ * This file contains defines, structures, etc. that are used
+ * to communicate between kernel and user code.
+ */
+
+#ifndef _LINUX__HFI1_USER_H
+#define _LINUX__HFI1_USER_H
+
+#include <linux/types.h>
+#include <rdma/rdma_user_ioctl.h>
+
+/*
+ * This version number is given to the driver by the user code during
+ * initialization in the spu_userversion field of hfi1_user_info, so
+ * the driver can check for compatibility with user code.
+ *
+ * The major version changes when data structures change in an incompatible
+ * way. The driver must be the same for initialization to succeed.
+ */
+#define HFI1_USER_SWMAJOR 6
+
+/*
+ * Minor version differences are always compatible
+ * a within a major version, however if user software is larger
+ * than driver software, some new features and/or structure fields
+ * may not be implemented; the user code must deal with this if it
+ * cares, or it must abort after initialization reports the difference.
+ */
+#define HFI1_USER_SWMINOR 3
+
+/*
+ * We will encode the major/minor inside a single 32bit version number.
+ */
+#define HFI1_SWMAJOR_SHIFT 16
+
+/*
+ * Set of HW and driver capability/feature bits.
+ * These bit values are used to configure enabled/disabled HW and
+ * driver features. The same set of bits are communicated to user
+ * space.
+ */
+#define HFI1_CAP_DMA_RTAIL        (1UL <<  0) /* Use DMA'ed RTail value */
+#define HFI1_CAP_SDMA             (1UL <<  1) /* Enable SDMA support */
+#define HFI1_CAP_SDMA_AHG         (1UL <<  2) /* Enable SDMA AHG support */
+#define HFI1_CAP_EXTENDED_PSN     (1UL <<  3) /* Enable Extended PSN support */
+#define HFI1_CAP_HDRSUPP          (1UL <<  4) /* Enable Header Suppression */
+/* 1UL << 5 unused */
+#define HFI1_CAP_USE_SDMA_HEAD    (1UL <<  6) /* DMA Hdr Q tail vs. use CSR */
+#define HFI1_CAP_MULTI_PKT_EGR    (1UL <<  7) /* Enable multi-packet Egr buffs*/
+#define HFI1_CAP_NODROP_RHQ_FULL  (1UL <<  8) /* Don't drop on Hdr Q full */
+#define HFI1_CAP_NODROP_EGR_FULL  (1UL <<  9) /* Don't drop on EGR buffs full */
+#define HFI1_CAP_TID_UNMAP        (1UL << 10) /* Disable Expected TID caching */
+#define HFI1_CAP_PRINT_UNIMPL     (1UL << 11) /* Show for unimplemented feats */
+#define HFI1_CAP_ALLOW_PERM_JKEY  (1UL << 12) /* Allow use of permissive JKEY */
+#define HFI1_CAP_NO_INTEGRITY     (1UL << 13) /* Enable ctxt integrity checks */
+#define HFI1_CAP_PKEY_CHECK       (1UL << 14) /* Enable ctxt PKey checking */
+#define HFI1_CAP_STATIC_RATE_CTRL (1UL << 15) /* Allow PBC.StaticRateControl */
+/* 1UL << 16 unused */
+#define HFI1_CAP_SDMA_HEAD_CHECK  (1UL << 17) /* SDMA head checking */
+#define HFI1_CAP_EARLY_CREDIT_RETURN (1UL << 18) /* early credit return */
+
+#define HFI1_RCVHDR_ENTSIZE_2    (1UL << 0)
+#define HFI1_RCVHDR_ENTSIZE_16   (1UL << 1)
+#define HFI1_RCVDHR_ENTSIZE_32   (1UL << 2)
+
+#define _HFI1_EVENT_FROZEN_BIT         0
+#define _HFI1_EVENT_LINKDOWN_BIT       1
+#define _HFI1_EVENT_LID_CHANGE_BIT     2
+#define _HFI1_EVENT_LMC_CHANGE_BIT     3
+#define _HFI1_EVENT_SL2VL_CHANGE_BIT   4
+#define _HFI1_EVENT_TID_MMU_NOTIFY_BIT 5
+#define _HFI1_MAX_EVENT_BIT _HFI1_EVENT_TID_MMU_NOTIFY_BIT
+
+#define HFI1_EVENT_FROZEN            (1UL << _HFI1_EVENT_FROZEN_BIT)
+#define HFI1_EVENT_LINKDOWN          (1UL << _HFI1_EVENT_LINKDOWN_BIT)
+#define HFI1_EVENT_LID_CHANGE        (1UL << _HFI1_EVENT_LID_CHANGE_BIT)
+#define HFI1_EVENT_LMC_CHANGE        (1UL << _HFI1_EVENT_LMC_CHANGE_BIT)
+#define HFI1_EVENT_SL2VL_CHANGE      (1UL << _HFI1_EVENT_SL2VL_CHANGE_BIT)
+#define HFI1_EVENT_TID_MMU_NOTIFY    (1UL << _HFI1_EVENT_TID_MMU_NOTIFY_BIT)
+
+/*
+ * These are the status bits readable (in ASCII form, 64bit value)
+ * from the "status" sysfs file.  For binary compatibility, values
+ * must remain as is; removed states can be reused for different
+ * purposes.
+ */
+#define HFI1_STATUS_INITTED       0x1    /* basic initialization done */
+/* Chip has been found and initialized */
+#define HFI1_STATUS_CHIP_PRESENT 0x20
+/* IB link is at ACTIVE, usable for data traffic */
+#define HFI1_STATUS_IB_READY     0x40
+/* link is configured, LID, MTU, etc. have been set */
+#define HFI1_STATUS_IB_CONF      0x80
+/* A Fatal hardware error has occurred. */
+#define HFI1_STATUS_HWERROR     0x200
+
+/*
+ * Number of supported shared contexts.
+ * This is the maximum number of software contexts that can share
+ * a hardware send/receive context.
+ */
+#define HFI1_MAX_SHARED_CTXTS 8
+
+/*
+ * Poll types
+ */
+#define HFI1_POLL_TYPE_ANYRCV     0x0
+#define HFI1_POLL_TYPE_URGENT     0x1
+
+enum hfi1_sdma_comp_state {
+	FREE = 0,
+	QUEUED,
+	COMPLETE,
+	ERROR
+};
+
+/*
+ * SDMA completion ring entry
+ */
+struct hfi1_sdma_comp_entry {
+	__u32 status;
+	__u32 errcode;
+};
+
+/*
+ * Device status and notifications from driver to user-space.
+ */
+struct hfi1_status {
+	__u64 dev;      /* device/hw status bits */
+	__u64 port;     /* port state and status bits */
+	char freezemsg[0];
+};
+
+enum sdma_req_opcode {
+	EXPECTED = 0,
+	EAGER
+};
+
+#define HFI1_SDMA_REQ_VERSION_MASK 0xF
+#define HFI1_SDMA_REQ_VERSION_SHIFT 0x0
+#define HFI1_SDMA_REQ_OPCODE_MASK 0xF
+#define HFI1_SDMA_REQ_OPCODE_SHIFT 0x4
+#define HFI1_SDMA_REQ_IOVCNT_MASK 0xFF
+#define HFI1_SDMA_REQ_IOVCNT_SHIFT 0x8
+
+struct sdma_req_info {
+	/*
+	 * bits 0-3 - version (currently unused)
+	 * bits 4-7 - opcode (enum sdma_req_opcode)
+	 * bits 8-15 - io vector count
+	 */
+	__u16 ctrl;
+	/*
+	 * Number of fragments contained in this request.
+	 * User-space has already computed how many
+	 * fragment-sized packet the user buffer will be
+	 * split into.
+	 */
+	__u16 npkts;
+	/*
+	 * Size of each fragment the user buffer will be
+	 * split into.
+	 */
+	__u16 fragsize;
+	/*
+	 * Index of the slot in the SDMA completion ring
+	 * this request should be using. User-space is
+	 * in charge of managing its own ring.
+	 */
+	__u16 comp_idx;
+} __attribute__((__packed__));
+
+/*
+ * SW KDETH header.
+ * swdata is SW defined portion.
+ */
+struct hfi1_kdeth_header {
+	__le32 ver_tid_offset;
+	__le16 jkey;
+	__le16 hcrc;
+	__le32 swdata[7];
+}  __attribute__((__packed__));
+
+/*
+ * Structure describing the headers that User space uses. The
+ * structure above is a subset of this one.
+ */
+struct hfi1_pkt_header {
+	__le16 pbc[4];
+	__be16 lrh[4];
+	__be32 bth[3];
+	struct hfi1_kdeth_header kdeth;
+}  __attribute__((__packed__));
+
+
+/*
+ * The list of usermode accessible registers.
+ */
+enum hfi1_ureg {
+	/* (RO)  DMA RcvHdr to be used next. */
+	ur_rcvhdrtail = 0,
+	/* (RW)  RcvHdr entry to be processed next by host. */
+	ur_rcvhdrhead = 1,
+	/* (RO)  Index of next Eager index to use. */
+	ur_rcvegrindextail = 2,
+	/* (RW)  Eager TID to be processed next */
+	ur_rcvegrindexhead = 3,
+	/* (RO)  Receive Eager Offset Tail */
+	ur_rcvegroffsettail = 4,
+	/* For internal use only; max register number. */
+	ur_maxreg,
+	/* (RW)  Receive TID flow table */
+	ur_rcvtidflowtable = 256
+};
+
+#endif /* _LINIUX__HFI1_USER_H */
diff --git a/kernel-headers/rdma/hns-abi.h b/kernel-headers/rdma/hns-abi.h
new file mode 100644
index 00000000000000..a9c03b0eed573f
--- /dev/null
+++ b/kernel-headers/rdma/hns-abi.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause) */
+/*
+ * Copyright (c) 2016 Hisilicon Limited.
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
+#ifndef HNS_ABI_USER_H
+#define HNS_ABI_USER_H
+
+#include <linux/types.h>
+
+struct hns_roce_ib_create_cq {
+	__u64   buf_addr;
+};
+
+struct hns_roce_ib_create_qp {
+	__u64	buf_addr;
+	__u64   db_addr;
+	__u8    log_sq_bb_count;
+	__u8    log_sq_stride;
+	__u8    sq_no_prefetch;
+	__u8    reserved[5];
+};
+
+struct hns_roce_ib_alloc_ucontext_resp {
+	__u32	qp_tab_size;
+};
+#endif /* HNS_ABI_USER_H */
diff --git a/kernel-headers/rdma/ib_user_cm.h b/kernel-headers/rdma/ib_user_cm.h
new file mode 100644
index 00000000000000..f4041bdc4d0892
--- /dev/null
+++ b/kernel-headers/rdma/ib_user_cm.h
@@ -0,0 +1,326 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause) */
+/*
+ * Copyright (c) 2005 Topspin Communications.  All rights reserved.
+ * Copyright (c) 2005 Intel Corporation.  All rights reserved.
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
+#ifndef IB_USER_CM_H
+#define IB_USER_CM_H
+
+#include <linux/types.h>
+#include <rdma/ib_user_sa.h>
+
+#define IB_USER_CM_ABI_VERSION 5
+
+enum {
+	IB_USER_CM_CMD_CREATE_ID,
+	IB_USER_CM_CMD_DESTROY_ID,
+	IB_USER_CM_CMD_ATTR_ID,
+
+	IB_USER_CM_CMD_LISTEN,
+	IB_USER_CM_CMD_NOTIFY,
+
+	IB_USER_CM_CMD_SEND_REQ,
+	IB_USER_CM_CMD_SEND_REP,
+	IB_USER_CM_CMD_SEND_RTU,
+	IB_USER_CM_CMD_SEND_DREQ,
+	IB_USER_CM_CMD_SEND_DREP,
+	IB_USER_CM_CMD_SEND_REJ,
+	IB_USER_CM_CMD_SEND_MRA,
+	IB_USER_CM_CMD_SEND_LAP,
+	IB_USER_CM_CMD_SEND_APR,
+	IB_USER_CM_CMD_SEND_SIDR_REQ,
+	IB_USER_CM_CMD_SEND_SIDR_REP,
+
+	IB_USER_CM_CMD_EVENT,
+	IB_USER_CM_CMD_INIT_QP_ATTR,
+};
+/*
+ * command ABI structures.
+ */
+struct ib_ucm_cmd_hdr {
+	__u32 cmd;
+	__u16 in;
+	__u16 out;
+};
+
+struct ib_ucm_create_id {
+	__u64 uid;
+	__u64 response;
+};
+
+struct ib_ucm_create_id_resp {
+	__u32 id;
+};
+
+struct ib_ucm_destroy_id {
+	__u64 response;
+	__u32 id;
+	__u32 reserved;
+};
+
+struct ib_ucm_destroy_id_resp {
+	__u32 events_reported;
+};
+
+struct ib_ucm_attr_id {
+	__u64 response;
+	__u32 id;
+	__u32 reserved;
+};
+
+struct ib_ucm_attr_id_resp {
+	__be64 service_id;
+	__be64 service_mask;
+	__be32 local_id;
+	__be32 remote_id;
+};
+
+struct ib_ucm_init_qp_attr {
+	__u64 response;
+	__u32 id;
+	__u32 qp_state;
+};
+
+struct ib_ucm_listen {
+	__be64 service_id;
+	__be64 service_mask;
+	__u32 id;
+	__u32 reserved;
+};
+
+struct ib_ucm_notify {
+	__u32 id;
+	__u32 event;
+};
+
+struct ib_ucm_private_data {
+	__u64 data;
+	__u32 id;
+	__u8  len;
+	__u8  reserved[3];
+};
+
+struct ib_ucm_req {
+	__u32 id;
+	__u32 qpn;
+	__u32 qp_type;
+	__u32 psn;
+	__be64 sid;
+	__u64 data;
+	__u64 primary_path;
+	__u64 alternate_path;
+	__u8  len;
+	__u8  peer_to_peer;
+	__u8  responder_resources;
+	__u8  initiator_depth;
+	__u8  remote_cm_response_timeout;
+	__u8  flow_control;
+	__u8  local_cm_response_timeout;
+	__u8  retry_count;
+	__u8  rnr_retry_count;
+	__u8  max_cm_retries;
+	__u8  srq;
+	__u8  reserved[5];
+};
+
+struct ib_ucm_rep {
+	__u64 uid;
+	__u64 data;
+	__u32 id;
+	__u32 qpn;
+	__u32 psn;
+	__u8  len;
+	__u8  responder_resources;
+	__u8  initiator_depth;
+	__u8  target_ack_delay;
+	__u8  failover_accepted;
+	__u8  flow_control;
+	__u8  rnr_retry_count;
+	__u8  srq;
+	__u8  reserved[4];
+};
+
+struct ib_ucm_info {
+	__u32 id;
+	__u32 status;
+	__u64 info;
+	__u64 data;
+	__u8  info_len;
+	__u8  data_len;
+	__u8  reserved[6];
+};
+
+struct ib_ucm_mra {
+	__u64 data;
+	__u32 id;
+	__u8  len;
+	__u8  timeout;
+	__u8  reserved[2];
+};
+
+struct ib_ucm_lap {
+	__u64 path;
+	__u64 data;
+	__u32 id;
+	__u8  len;
+	__u8  reserved[3];
+};
+
+struct ib_ucm_sidr_req {
+	__u32 id;
+	__u32 timeout;
+	__be64 sid;
+	__u64 data;
+	__u64 path;
+	__u16 reserved_pkey;
+	__u8  len;
+	__u8  max_cm_retries;
+	__u8  reserved[4];
+};
+
+struct ib_ucm_sidr_rep {
+	__u32 id;
+	__u32 qpn;
+	__u32 qkey;
+	__u32 status;
+	__u64 info;
+	__u64 data;
+	__u8  info_len;
+	__u8  data_len;
+	__u8  reserved[6];
+};
+/*
+ * event notification ABI structures.
+ */
+struct ib_ucm_event_get {
+	__u64 response;
+	__u64 data;
+	__u64 info;
+	__u8  data_len;
+	__u8  info_len;
+	__u8  reserved[6];
+};
+
+struct ib_ucm_req_event_resp {
+	struct ib_user_path_rec primary_path;
+	struct ib_user_path_rec alternate_path;
+	__be64                 remote_ca_guid;
+	__u32                  remote_qkey;
+	__u32                  remote_qpn;
+	__u32                  qp_type;
+	__u32                  starting_psn;
+	__u8  responder_resources;
+	__u8  initiator_depth;
+	__u8  local_cm_response_timeout;
+	__u8  flow_control;
+	__u8  remote_cm_response_timeout;
+	__u8  retry_count;
+	__u8  rnr_retry_count;
+	__u8  srq;
+	__u8  port;
+	__u8  reserved[7];
+};
+
+struct ib_ucm_rep_event_resp {
+	__be64 remote_ca_guid;
+	__u32 remote_qkey;
+	__u32 remote_qpn;
+	__u32 starting_psn;
+	__u8  responder_resources;
+	__u8  initiator_depth;
+	__u8  target_ack_delay;
+	__u8  failover_accepted;
+	__u8  flow_control;
+	__u8  rnr_retry_count;
+	__u8  srq;
+	__u8  reserved[5];
+};
+
+struct ib_ucm_rej_event_resp {
+	__u32 reason;
+	/* ari in ib_ucm_event_get info field. */
+};
+
+struct ib_ucm_mra_event_resp {
+	__u8  timeout;
+	__u8  reserved[3];
+};
+
+struct ib_ucm_lap_event_resp {
+	struct ib_user_path_rec path;
+};
+
+struct ib_ucm_apr_event_resp {
+	__u32 status;
+	/* apr info in ib_ucm_event_get info field. */
+};
+
+struct ib_ucm_sidr_req_event_resp {
+	__u16 pkey;
+	__u8  port;
+	__u8  reserved;
+};
+
+struct ib_ucm_sidr_rep_event_resp {
+	__u32 status;
+	__u32 qkey;
+	__u32 qpn;
+	/* info in ib_ucm_event_get info field. */
+};
+
+#define IB_UCM_PRES_DATA      0x01
+#define IB_UCM_PRES_INFO      0x02
+#define IB_UCM_PRES_PRIMARY   0x04
+#define IB_UCM_PRES_ALTERNATE 0x08
+
+struct ib_ucm_event_resp {
+	__u64 uid;
+	__u32 id;
+	__u32 event;
+	__u32 present;
+	__u32 reserved;
+	union {
+		struct ib_ucm_req_event_resp req_resp;
+		struct ib_ucm_rep_event_resp rep_resp;
+		struct ib_ucm_rej_event_resp rej_resp;
+		struct ib_ucm_mra_event_resp mra_resp;
+		struct ib_ucm_lap_event_resp lap_resp;
+		struct ib_ucm_apr_event_resp apr_resp;
+
+		struct ib_ucm_sidr_req_event_resp sidr_req_resp;
+		struct ib_ucm_sidr_rep_event_resp sidr_rep_resp;
+
+		__u32                             send_status;
+	} u;
+};
+
+#endif /* IB_USER_CM_H */
diff --git a/kernel-headers/rdma/ib_user_ioctl_verbs.h b/kernel-headers/rdma/ib_user_ioctl_verbs.h
new file mode 100644
index 00000000000000..842792eae38314
--- /dev/null
+++ b/kernel-headers/rdma/ib_user_ioctl_verbs.h
@@ -0,0 +1,84 @@
+/*
+ * Copyright (c) 2017, Mellanox Technologies inc.  All rights reserved.
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
+#ifndef IB_USER_IOCTL_VERBS_H
+#define IB_USER_IOCTL_VERBS_H
+
+#include <rdma/rdma_user_ioctl.h>
+
+#define UVERBS_UDATA_DRIVER_DATA_NS	1
+#define UVERBS_UDATA_DRIVER_DATA_FLAG	(1UL << UVERBS_ID_NS_SHIFT)
+
+enum uverbs_default_objects {
+	UVERBS_OBJECT_DEVICE, /* No instances of DEVICE are allowed */
+	UVERBS_OBJECT_PD,
+	UVERBS_OBJECT_COMP_CHANNEL,
+	UVERBS_OBJECT_CQ,
+	UVERBS_OBJECT_QP,
+	UVERBS_OBJECT_SRQ,
+	UVERBS_OBJECT_AH,
+	UVERBS_OBJECT_MR,
+	UVERBS_OBJECT_MW,
+	UVERBS_OBJECT_FLOW,
+	UVERBS_OBJECT_XRCD,
+	UVERBS_OBJECT_RWQ_IND_TBL,
+	UVERBS_OBJECT_WQ,
+	UVERBS_OBJECT_LAST,
+};
+
+enum {
+	UVERBS_UHW_IN = UVERBS_UDATA_DRIVER_DATA_FLAG,
+	UVERBS_UHW_OUT,
+};
+
+enum uverbs_create_cq_cmd_attr_ids {
+	CREATE_CQ_HANDLE,
+	CREATE_CQ_CQE,
+	CREATE_CQ_USER_HANDLE,
+	CREATE_CQ_COMP_CHANNEL,
+	CREATE_CQ_COMP_VECTOR,
+	CREATE_CQ_FLAGS,
+	CREATE_CQ_RESP_CQE,
+};
+
+enum uverbs_destroy_cq_cmd_attr_ids {
+	DESTROY_CQ_HANDLE,
+	DESTROY_CQ_RESP,
+};
+
+enum uverbs_actions_cq_ops {
+	UVERBS_CQ_CREATE,
+	UVERBS_CQ_DESTROY,
+};
+
+#endif
+
diff --git a/kernel-headers/rdma/ib_user_mad.h b/kernel-headers/rdma/ib_user_mad.h
new file mode 100644
index 00000000000000..330a3c5f1aa864
--- /dev/null
+++ b/kernel-headers/rdma/ib_user_mad.h
@@ -0,0 +1,234 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause) */
+/*
+ * Copyright (c) 2004 Topspin Communications.  All rights reserved.
+ * Copyright (c) 2005 Voltaire, Inc. All rights reserved.
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
+#ifndef IB_USER_MAD_H
+#define IB_USER_MAD_H
+
+#include <linux/types.h>
+#include <rdma/rdma_user_ioctl.h>
+
+/*
+ * Increment this value if any changes that break userspace ABI
+ * compatibility are made.
+ */
+#define IB_USER_MAD_ABI_VERSION	5
+
+/*
+ * Make sure that all structs defined in this file remain laid out so
+ * that they pack the same way on 32-bit and 64-bit architectures (to
+ * avoid incompatibility between 32-bit userspace and 64-bit kernels).
+ */
+
+/**
+ * ib_user_mad_hdr_old - Old version of MAD packet header without pkey_index
+ * @id - ID of agent MAD received with/to be sent with
+ * @status - 0 on successful receive, ETIMEDOUT if no response
+ *   received (transaction ID in data[] will be set to TID of original
+ *   request) (ignored on send)
+ * @timeout_ms - Milliseconds to wait for response (unset on receive)
+ * @retries - Number of automatic retries to attempt
+ * @qpn - Remote QP number received from/to be sent to
+ * @qkey - Remote Q_Key to be sent with (unset on receive)
+ * @lid - Remote lid received from/to be sent to
+ * @sl - Service level received with/to be sent with
+ * @path_bits - Local path bits received with/to be sent with
+ * @grh_present - If set, GRH was received/should be sent
+ * @gid_index - Local GID index to send with (unset on receive)
+ * @hop_limit - Hop limit in GRH
+ * @traffic_class - Traffic class in GRH
+ * @gid - Remote GID in GRH
+ * @flow_label - Flow label in GRH
+ */
+struct ib_user_mad_hdr_old {
+	__u32	id;
+	__u32	status;
+	__u32	timeout_ms;
+	__u32	retries;
+	__u32	length;
+	__be32	qpn;
+	__be32  qkey;
+	__be16	lid;
+	__u8	sl;
+	__u8	path_bits;
+	__u8	grh_present;
+	__u8	gid_index;
+	__u8	hop_limit;
+	__u8	traffic_class;
+	__u8	gid[16];
+	__be32	flow_label;
+};
+
+/**
+ * ib_user_mad_hdr - MAD packet header
+ *   This layout allows specifying/receiving the P_Key index.  To use
+ *   this capability, an application must call the
+ *   IB_USER_MAD_ENABLE_PKEY ioctl on the user MAD file handle before
+ *   any other actions with the file handle.
+ * @id - ID of agent MAD received with/to be sent with
+ * @status - 0 on successful receive, ETIMEDOUT if no response
+ *   received (transaction ID in data[] will be set to TID of original
+ *   request) (ignored on send)
+ * @timeout_ms - Milliseconds to wait for response (unset on receive)
+ * @retries - Number of automatic retries to attempt
+ * @qpn - Remote QP number received from/to be sent to
+ * @qkey - Remote Q_Key to be sent with (unset on receive)
+ * @lid - Remote lid received from/to be sent to
+ * @sl - Service level received with/to be sent with
+ * @path_bits - Local path bits received with/to be sent with
+ * @grh_present - If set, GRH was received/should be sent
+ * @gid_index - Local GID index to send with (unset on receive)
+ * @hop_limit - Hop limit in GRH
+ * @traffic_class - Traffic class in GRH
+ * @gid - Remote GID in GRH
+ * @flow_label - Flow label in GRH
+ * @pkey_index - P_Key index
+ */
+struct ib_user_mad_hdr {
+	__u32	id;
+	__u32	status;
+	__u32	timeout_ms;
+	__u32	retries;
+	__u32	length;
+	__be32	qpn;
+	__be32  qkey;
+	__be16	lid;
+	__u8	sl;
+	__u8	path_bits;
+	__u8	grh_present;
+	__u8	gid_index;
+	__u8	hop_limit;
+	__u8	traffic_class;
+	__u8	gid[16];
+	__be32	flow_label;
+	__u16	pkey_index;
+	__u8	reserved[6];
+};
+
+/**
+ * ib_user_mad - MAD packet
+ * @hdr - MAD packet header
+ * @data - Contents of MAD
+ *
+ */
+struct ib_user_mad {
+	struct ib_user_mad_hdr hdr;
+	__u64	data[0];
+};
+
+/*
+ * Earlier versions of this interface definition declared the
+ * method_mask[] member as an array of __u32 but treated it as a
+ * bitmap made up of longs in the kernel.  This ambiguity meant that
+ * 32-bit big-endian applications that can run on both 32-bit and
+ * 64-bit kernels had no consistent ABI to rely on, and 64-bit
+ * big-endian applications that treated method_mask as being made up
+ * of 32-bit words would have their bitmap misinterpreted.
+ *
+ * To clear up this confusion, we change the declaration of
+ * method_mask[] to use unsigned long and handle the conversion from
+ * 32-bit userspace to 64-bit kernel for big-endian systems in the
+ * compat_ioctl method.  Unfortunately, to keep the structure layout
+ * the same, we need the method_mask[] array to be aligned only to 4
+ * bytes even when long is 64 bits, which forces us into this ugly
+ * typedef.
+ */
+typedef unsigned long __attribute__((aligned(4))) packed_ulong;
+#define IB_USER_MAD_LONGS_PER_METHOD_MASK (128 / (8 * sizeof (long)))
+
+/**
+ * ib_user_mad_reg_req - MAD registration request
+ * @id - Set by the kernel; used to identify agent in future requests.
+ * @qpn - Queue pair number; must be 0 or 1.
+ * @method_mask - The caller will receive unsolicited MADs for any method
+ *   where @method_mask = 1.
+ * @mgmt_class - Indicates which management class of MADs should be receive
+ *   by the caller.  This field is only required if the user wishes to
+ *   receive unsolicited MADs, otherwise it should be 0.
+ * @mgmt_class_version - Indicates which version of MADs for the given
+ *   management class to receive.
+ * @oui: Indicates IEEE OUI when mgmt_class is a vendor class
+ *   in the range from 0x30 to 0x4f. Otherwise not used.
+ * @rmpp_version: If set, indicates the RMPP version used.
+ *
+ */
+struct ib_user_mad_reg_req {
+	__u32	id;
+	packed_ulong method_mask[IB_USER_MAD_LONGS_PER_METHOD_MASK];
+	__u8	qpn;
+	__u8	mgmt_class;
+	__u8	mgmt_class_version;
+	__u8    oui[3];
+	__u8	rmpp_version;
+};
+
+/**
+ * ib_user_mad_reg_req2 - MAD registration request
+ *
+ * @id                 - Set by the _kernel_; used by userspace to identify the
+ *                       registered agent in future requests.
+ * @qpn                - Queue pair number; must be 0 or 1.
+ * @mgmt_class         - Indicates which management class of MADs should be
+ *                       receive by the caller.  This field is only required if
+ *                       the user wishes to receive unsolicited MADs, otherwise
+ *                       it should be 0.
+ * @mgmt_class_version - Indicates which version of MADs for the given
+ *                       management class to receive.
+ * @res                - Ignored.
+ * @flags              - additional registration flags; Must be in the set of
+ *                       flags defined in IB_USER_MAD_REG_FLAGS_CAP
+ * @method_mask        - The caller wishes to receive unsolicited MADs for the
+ *                       methods whose bit(s) is(are) set.
+ * @oui                - Indicates IEEE OUI to use when mgmt_class is a vendor
+ *                       class in the range from 0x30 to 0x4f. Otherwise not
+ *                       used.
+ * @rmpp_version       - If set, indicates the RMPP version to use.
+ */
+enum {
+	IB_USER_MAD_USER_RMPP = (1 << 0),
+};
+#define IB_USER_MAD_REG_FLAGS_CAP (IB_USER_MAD_USER_RMPP)
+struct ib_user_mad_reg_req2 {
+	__u32	id;
+	__u32	qpn;
+	__u8	mgmt_class;
+	__u8	mgmt_class_version;
+	__u16   res;
+	__u32   flags;
+	__u64   method_mask[2];
+	__u32   oui;
+	__u8	rmpp_version;
+	__u8	reserved[3];
+};
+
+#endif /* IB_USER_MAD_H */
diff --git a/kernel-headers/rdma/ib_user_sa.h b/kernel-headers/rdma/ib_user_sa.h
new file mode 100644
index 00000000000000..0d2607f0cd20c3
--- /dev/null
+++ b/kernel-headers/rdma/ib_user_sa.h
@@ -0,0 +1,77 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause) */
+/*
+ * Copyright (c) 2005 Intel Corporation.  All rights reserved.
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
+#ifndef IB_USER_SA_H
+#define IB_USER_SA_H
+
+#include <linux/types.h>
+
+enum {
+	IB_PATH_GMP		= 1,
+	IB_PATH_PRIMARY		= (1<<1),
+	IB_PATH_ALTERNATE	= (1<<2),
+	IB_PATH_OUTBOUND	= (1<<3),
+	IB_PATH_INBOUND		= (1<<4),
+	IB_PATH_INBOUND_REVERSE = (1<<5),
+	IB_PATH_BIDIRECTIONAL	= IB_PATH_OUTBOUND | IB_PATH_INBOUND_REVERSE
+};
+
+struct ib_path_rec_data {
+	__u32	flags;
+	__u32	reserved;
+	__u32	path_rec[16];
+};
+
+struct ib_user_path_rec {
+	__u8	dgid[16];
+	__u8	sgid[16];
+	__be16	dlid;
+	__be16	slid;
+	__u32	raw_traffic;
+	__be32	flow_label;
+	__u32	reversible;
+	__u32	mtu;
+	__be16	pkey;
+	__u8	hop_limit;
+	__u8	traffic_class;
+	__u8	numb_path;
+	__u8	sl;
+	__u8	mtu_selector;
+	__u8	rate_selector;
+	__u8	rate;
+	__u8	packet_life_time_selector;
+	__u8	packet_life_time;
+	__u8	preference;
+};
+
+#endif /* IB_USER_SA_H */
diff --git a/buildlib/fixup-include/rdma-ib_user_verbs.h b/kernel-headers/rdma/ib_user_verbs.h
similarity index 99%
rename from buildlib/fixup-include/rdma-ib_user_verbs.h
rename to kernel-headers/rdma/ib_user_verbs.h
index fd035641cf41ce..04d0e67b13120c 100644
--- a/buildlib/fixup-include/rdma-ib_user_verbs.h
+++ b/kernel-headers/rdma/ib_user_verbs.h
@@ -402,13 +402,18 @@ struct ib_uverbs_create_cq {
 	__u64 driver_data[0];
 };
 
+enum ib_uverbs_ex_create_cq_flags {
+	IB_UVERBS_CQ_FLAGS_TIMESTAMP_COMPLETION = 1 << 0,
+	IB_UVERBS_CQ_FLAGS_IGNORE_OVERRUN = 1 << 1,
+};
+
 struct ib_uverbs_ex_create_cq {
 	__u64 user_handle;
 	__u32 cqe;
 	__u32 comp_vector;
 	__s32 comp_channel;
 	__u32 comp_mask;
-	__u32 flags;
+	__u32 flags;  /* bitmask of ib_uverbs_ex_create_cq_flags */
 	__u32 reserved;
 };
 
diff --git a/kernel-headers/rdma/mlx4-abi.h b/kernel-headers/rdma/mlx4-abi.h
new file mode 100644
index 00000000000000..7f9c37346613e0
--- /dev/null
+++ b/kernel-headers/rdma/mlx4-abi.h
@@ -0,0 +1,159 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause) */
+/*
+ * Copyright (c) 2007 Cisco Systems, Inc. All rights reserved.
+ * Copyright (c) 2007, 2008 Mellanox Technologies. All rights reserved.
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
+#ifndef MLX4_ABI_USER_H
+#define MLX4_ABI_USER_H
+
+#include <linux/types.h>
+
+/*
+ * Increment this value if any changes that break userspace ABI
+ * compatibility are made.
+ */
+
+#define MLX4_IB_UVERBS_NO_DEV_CAPS_ABI_VERSION	3
+#define MLX4_IB_UVERBS_ABI_VERSION		4
+
+/*
+ * Make sure that all structs defined in this file remain laid out so
+ * that they pack the same way on 32-bit and 64-bit architectures (to
+ * avoid incompatibility between 32-bit userspace and 64-bit kernels).
+ * In particular do not use pointer types -- pass pointers in __u64
+ * instead.
+ */
+
+struct mlx4_ib_alloc_ucontext_resp_v3 {
+	__u32	qp_tab_size;
+	__u16	bf_reg_size;
+	__u16	bf_regs_per_page;
+};
+
+struct mlx4_ib_alloc_ucontext_resp {
+	__u32	dev_caps;
+	__u32	qp_tab_size;
+	__u16	bf_reg_size;
+	__u16	bf_regs_per_page;
+	__u32	cqe_size;
+};
+
+struct mlx4_ib_alloc_pd_resp {
+	__u32	pdn;
+	__u32	reserved;
+};
+
+struct mlx4_ib_create_cq {
+	__u64	buf_addr;
+	__u64	db_addr;
+};
+
+struct mlx4_ib_create_cq_resp {
+	__u32	cqn;
+	__u32	reserved;
+};
+
+struct mlx4_ib_resize_cq {
+	__u64	buf_addr;
+};
+
+struct mlx4_ib_create_srq {
+	__u64	buf_addr;
+	__u64	db_addr;
+};
+
+struct mlx4_ib_create_srq_resp {
+	__u32	srqn;
+	__u32	reserved;
+};
+
+struct mlx4_ib_create_qp_rss {
+	__u64   rx_hash_fields_mask; /* Use  enum mlx4_ib_rx_hash_fields */
+	__u8    rx_hash_function; /* Use enum mlx4_ib_rx_hash_function_flags */
+	__u8    reserved[7];
+	__u8    rx_hash_key[40];
+	__u32   comp_mask;
+	__u32   reserved1;
+};
+
+struct mlx4_ib_create_qp {
+	__u64	buf_addr;
+	__u64	db_addr;
+	__u8	log_sq_bb_count;
+	__u8	log_sq_stride;
+	__u8	sq_no_prefetch;
+	__u8	reserved;
+	__u32	inl_recv_sz;
+};
+
+struct mlx4_ib_create_wq {
+	__u64	buf_addr;
+	__u64	db_addr;
+	__u8	log_range_size;
+	__u8	reserved[3];
+	__u32   comp_mask;
+};
+
+struct mlx4_ib_modify_wq {
+	__u32	comp_mask;
+	__u32	reserved;
+};
+
+struct mlx4_ib_create_rwq_ind_tbl_resp {
+	__u32	response_length;
+	__u32	reserved;
+};
+
+/* RX Hash function flags */
+enum mlx4_ib_rx_hash_function_flags {
+	MLX4_IB_RX_HASH_FUNC_TOEPLITZ	= 1 << 0,
+};
+
+/*
+ * RX Hash flags, these flags allows to set which incoming packet's field should
+ * participates in RX Hash. Each flag represent certain packet's field,
+ * when the flag is set the field that is represented by the flag will
+ * participate in RX Hash calculation.
+ */
+enum mlx4_ib_rx_hash_fields {
+	MLX4_IB_RX_HASH_SRC_IPV4	= 1 << 0,
+	MLX4_IB_RX_HASH_DST_IPV4	= 1 << 1,
+	MLX4_IB_RX_HASH_SRC_IPV6	= 1 << 2,
+	MLX4_IB_RX_HASH_DST_IPV6	= 1 << 3,
+	MLX4_IB_RX_HASH_SRC_PORT_TCP	= 1 << 4,
+	MLX4_IB_RX_HASH_DST_PORT_TCP	= 1 << 5,
+	MLX4_IB_RX_HASH_SRC_PORT_UDP	= 1 << 6,
+	MLX4_IB_RX_HASH_DST_PORT_UDP	= 1 << 7,
+	MLX4_IB_RX_HASH_INNER		= 1ULL << 31,
+};
+
+#endif /* MLX4_ABI_USER_H */
diff --git a/kernel-headers/rdma/mlx5-abi.h b/kernel-headers/rdma/mlx5-abi.h
new file mode 100644
index 00000000000000..1111aa4e7c1ed0
--- /dev/null
+++ b/kernel-headers/rdma/mlx5-abi.h
@@ -0,0 +1,416 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause) */
+/*
+ * Copyright (c) 2013-2015, Mellanox Technologies. All rights reserved.
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
+#ifndef MLX5_ABI_USER_H
+#define MLX5_ABI_USER_H
+
+#include <linux/types.h>
+#include <linux/if_ether.h>	/* For ETH_ALEN. */
+
+enum {
+	MLX5_QP_FLAG_SIGNATURE		= 1 << 0,
+	MLX5_QP_FLAG_SCATTER_CQE	= 1 << 1,
+	MLX5_QP_FLAG_TUNNEL_OFFLOADS	= 1 << 2,
+	MLX5_QP_FLAG_BFREG_INDEX	= 1 << 3,
+	MLX5_QP_FLAG_TYPE_DCT		= 1 << 4,
+	MLX5_QP_FLAG_TYPE_DCI		= 1 << 5,
+};
+
+enum {
+	MLX5_SRQ_FLAG_SIGNATURE		= 1 << 0,
+};
+
+enum {
+	MLX5_WQ_FLAG_SIGNATURE		= 1 << 0,
+};
+
+/* Increment this value if any changes that break userspace ABI
+ * compatibility are made.
+ */
+#define MLX5_IB_UVERBS_ABI_VERSION	1
+
+/* Make sure that all structs defined in this file remain laid out so
+ * that they pack the same way on 32-bit and 64-bit architectures (to
+ * avoid incompatibility between 32-bit userspace and 64-bit kernels).
+ * In particular do not use pointer types -- pass pointers in __u64
+ * instead.
+ */
+
+struct mlx5_ib_alloc_ucontext_req {
+	__u32	total_num_bfregs;
+	__u32	num_low_latency_bfregs;
+};
+
+enum mlx5_lib_caps {
+	MLX5_LIB_CAP_4K_UAR	= (__u64)1 << 0,
+};
+
+struct mlx5_ib_alloc_ucontext_req_v2 {
+	__u32	total_num_bfregs;
+	__u32	num_low_latency_bfregs;
+	__u32	flags;
+	__u32	comp_mask;
+	__u8	max_cqe_version;
+	__u8	reserved0;
+	__u16	reserved1;
+	__u32	reserved2;
+	__u64	lib_caps;
+};
+
+enum mlx5_ib_alloc_ucontext_resp_mask {
+	MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_CORE_CLOCK_OFFSET = 1UL << 0,
+};
+
+enum mlx5_user_cmds_supp_uhw {
+	MLX5_USER_CMDS_SUPP_UHW_QUERY_DEVICE = 1 << 0,
+	MLX5_USER_CMDS_SUPP_UHW_CREATE_AH    = 1 << 1,
+};
+
+/* The eth_min_inline response value is set to off-by-one vs the FW
+ * returned value to allow user-space to deal with older kernels.
+ */
+enum mlx5_user_inline_mode {
+	MLX5_USER_INLINE_MODE_NA,
+	MLX5_USER_INLINE_MODE_NONE,
+	MLX5_USER_INLINE_MODE_L2,
+	MLX5_USER_INLINE_MODE_IP,
+	MLX5_USER_INLINE_MODE_TCP_UDP,
+};
+
+struct mlx5_ib_alloc_ucontext_resp {
+	__u32	qp_tab_size;
+	__u32	bf_reg_size;
+	__u32	tot_bfregs;
+	__u32	cache_line_size;
+	__u16	max_sq_desc_sz;
+	__u16	max_rq_desc_sz;
+	__u32	max_send_wqebb;
+	__u32	max_recv_wr;
+	__u32	max_srq_recv_wr;
+	__u16	num_ports;
+	__u16	reserved1;
+	__u32	comp_mask;
+	__u32	response_length;
+	__u8	cqe_version;
+	__u8	cmds_supp_uhw;
+	__u8	eth_min_inline;
+	__u8	clock_info_versions;
+	__u64	hca_core_clock_offset;
+	__u32	log_uar_size;
+	__u32	num_uars_per_page;
+	__u32	num_dyn_bfregs;
+	__u32	reserved3;
+};
+
+struct mlx5_ib_alloc_pd_resp {
+	__u32	pdn;
+};
+
+struct mlx5_ib_tso_caps {
+	__u32 max_tso; /* Maximum tso payload size in bytes */
+
+	/* Corresponding bit will be set if qp type from
+	 * 'enum ib_qp_type' is supported, e.g.
+	 * supported_qpts |= 1 << IB_QPT_UD
+	 */
+	__u32 supported_qpts;
+};
+
+struct mlx5_ib_rss_caps {
+	__u64 rx_hash_fields_mask; /* enum mlx5_rx_hash_fields */
+	__u8 rx_hash_function; /* enum mlx5_rx_hash_function_flags */
+	__u8 reserved[7];
+};
+
+enum mlx5_ib_cqe_comp_res_format {
+	MLX5_IB_CQE_RES_FORMAT_HASH	= 1 << 0,
+	MLX5_IB_CQE_RES_FORMAT_CSUM	= 1 << 1,
+	MLX5_IB_CQE_RES_RESERVED	= 1 << 2,
+};
+
+struct mlx5_ib_cqe_comp_caps {
+	__u32 max_num;
+	__u32 supported_format; /* enum mlx5_ib_cqe_comp_res_format */
+};
+
+struct mlx5_packet_pacing_caps {
+	__u32 qp_rate_limit_min;
+	__u32 qp_rate_limit_max; /* In kpbs */
+
+	/* Corresponding bit will be set if qp type from
+	 * 'enum ib_qp_type' is supported, e.g.
+	 * supported_qpts |= 1 << IB_QPT_RAW_PACKET
+	 */
+	__u32 supported_qpts;
+	__u32 reserved;
+};
+
+enum mlx5_ib_mpw_caps {
+	MPW_RESERVED		= 1 << 0,
+	MLX5_IB_ALLOW_MPW	= 1 << 1,
+	MLX5_IB_SUPPORT_EMPW	= 1 << 2,
+};
+
+enum mlx5_ib_sw_parsing_offloads {
+	MLX5_IB_SW_PARSING = 1 << 0,
+	MLX5_IB_SW_PARSING_CSUM = 1 << 1,
+	MLX5_IB_SW_PARSING_LSO = 1 << 2,
+};
+
+struct mlx5_ib_sw_parsing_caps {
+	__u32 sw_parsing_offloads; /* enum mlx5_ib_sw_parsing_offloads */
+
+	/* Corresponding bit will be set if qp type from
+	 * 'enum ib_qp_type' is supported, e.g.
+	 * supported_qpts |= 1 << IB_QPT_RAW_PACKET
+	 */
+	__u32 supported_qpts;
+};
+
+struct mlx5_ib_striding_rq_caps {
+	__u32 min_single_stride_log_num_of_bytes;
+	__u32 max_single_stride_log_num_of_bytes;
+	__u32 min_single_wqe_log_num_of_strides;
+	__u32 max_single_wqe_log_num_of_strides;
+
+	/* Corresponding bit will be set if qp type from
+	 * 'enum ib_qp_type' is supported, e.g.
+	 * supported_qpts |= 1 << IB_QPT_RAW_PACKET
+	 */
+	__u32 supported_qpts;
+	__u32 reserved;
+};
+
+enum mlx5_ib_query_dev_resp_flags {
+	/* Support 128B CQE compression */
+	MLX5_IB_QUERY_DEV_RESP_FLAGS_CQE_128B_COMP = 1 << 0,
+	MLX5_IB_QUERY_DEV_RESP_FLAGS_CQE_128B_PAD  = 1 << 1,
+};
+
+enum mlx5_ib_tunnel_offloads {
+	MLX5_IB_TUNNELED_OFFLOADS_VXLAN  = 1 << 0,
+	MLX5_IB_TUNNELED_OFFLOADS_GRE    = 1 << 1,
+	MLX5_IB_TUNNELED_OFFLOADS_GENEVE = 1 << 2
+};
+
+struct mlx5_ib_query_device_resp {
+	__u32	comp_mask;
+	__u32	response_length;
+	struct	mlx5_ib_tso_caps tso_caps;
+	struct	mlx5_ib_rss_caps rss_caps;
+	struct	mlx5_ib_cqe_comp_caps cqe_comp_caps;
+	struct	mlx5_packet_pacing_caps packet_pacing_caps;
+	__u32	mlx5_ib_support_multi_pkt_send_wqes;
+	__u32	flags; /* Use enum mlx5_ib_query_dev_resp_flags */
+	struct mlx5_ib_sw_parsing_caps sw_parsing_caps;
+	struct mlx5_ib_striding_rq_caps striding_rq_caps;
+	__u32	tunnel_offloads_caps; /* enum mlx5_ib_tunnel_offloads */
+	__u32	reserved;
+};
+
+enum mlx5_ib_create_cq_flags {
+	MLX5_IB_CREATE_CQ_FLAGS_CQE_128B_PAD	= 1 << 0,
+};
+
+struct mlx5_ib_create_cq {
+	__u64	buf_addr;
+	__u64	db_addr;
+	__u32	cqe_size;
+	__u8    cqe_comp_en;
+	__u8    cqe_comp_res_format;
+	__u16	flags;
+};
+
+struct mlx5_ib_create_cq_resp {
+	__u32	cqn;
+	__u32	reserved;
+};
+
+struct mlx5_ib_resize_cq {
+	__u64	buf_addr;
+	__u16	cqe_size;
+	__u16	reserved0;
+	__u32	reserved1;
+};
+
+struct mlx5_ib_create_srq {
+	__u64	buf_addr;
+	__u64	db_addr;
+	__u32	flags;
+	__u32	reserved0; /* explicit padding (optional on i386) */
+	__u32	uidx;
+	__u32	reserved1;
+};
+
+struct mlx5_ib_create_srq_resp {
+	__u32	srqn;
+	__u32	reserved;
+};
+
+struct mlx5_ib_create_qp {
+	__u64	buf_addr;
+	__u64	db_addr;
+	__u32	sq_wqe_count;
+	__u32	rq_wqe_count;
+	__u32	rq_wqe_shift;
+	__u32	flags;
+	__u32	uidx;
+	__u32	bfreg_index;
+	union {
+		__u64	sq_buf_addr;
+		__u64	access_key;
+	};
+};
+
+/* RX Hash function flags */
+enum mlx5_rx_hash_function_flags {
+	MLX5_RX_HASH_FUNC_TOEPLITZ	= 1 << 0,
+};
+
+/*
+ * RX Hash flags, these flags allows to set which incoming packet's field should
+ * participates in RX Hash. Each flag represent certain packet's field,
+ * when the flag is set the field that is represented by the flag will
+ * participate in RX Hash calculation.
+ * Note: *IPV4 and *IPV6 flags can't be enabled together on the same QP
+ * and *TCP and *UDP flags can't be enabled together on the same QP.
+*/
+enum mlx5_rx_hash_fields {
+	MLX5_RX_HASH_SRC_IPV4	= 1 << 0,
+	MLX5_RX_HASH_DST_IPV4	= 1 << 1,
+	MLX5_RX_HASH_SRC_IPV6	= 1 << 2,
+	MLX5_RX_HASH_DST_IPV6	= 1 << 3,
+	MLX5_RX_HASH_SRC_PORT_TCP	= 1 << 4,
+	MLX5_RX_HASH_DST_PORT_TCP	= 1 << 5,
+	MLX5_RX_HASH_SRC_PORT_UDP	= 1 << 6,
+	MLX5_RX_HASH_DST_PORT_UDP	= 1 << 7,
+	/* Save bits for future fields */
+	MLX5_RX_HASH_INNER		= (1UL << 31),
+};
+
+struct mlx5_ib_create_qp_rss {
+	__u64 rx_hash_fields_mask; /* enum mlx5_rx_hash_fields */
+	__u8 rx_hash_function; /* enum mlx5_rx_hash_function_flags */
+	__u8 rx_key_len; /* valid only for Toeplitz */
+	__u8 reserved[6];
+	__u8 rx_hash_key[128]; /* valid only for Toeplitz */
+	__u32   comp_mask;
+	__u32	flags;
+};
+
+struct mlx5_ib_create_qp_resp {
+	__u32	bfreg_index;
+};
+
+struct mlx5_ib_alloc_mw {
+	__u32	comp_mask;
+	__u8	num_klms;
+	__u8	reserved1;
+	__u16	reserved2;
+};
+
+enum mlx5_ib_create_wq_mask {
+	MLX5_IB_CREATE_WQ_STRIDING_RQ	= (1 << 0),
+};
+
+struct mlx5_ib_create_wq {
+	__u64   buf_addr;
+	__u64   db_addr;
+	__u32   rq_wqe_count;
+	__u32   rq_wqe_shift;
+	__u32   user_index;
+	__u32   flags;
+	__u32   comp_mask;
+	__u32	single_stride_log_num_of_bytes;
+	__u32	single_wqe_log_num_of_strides;
+	__u32	two_byte_shift_en;
+};
+
+struct mlx5_ib_create_ah_resp {
+	__u32	response_length;
+	__u8	dmac[ETH_ALEN];
+	__u8	reserved[6];
+};
+
+struct mlx5_ib_modify_qp_resp {
+	__u32	response_length;
+	__u32	dctn;
+};
+
+struct mlx5_ib_create_wq_resp {
+	__u32	response_length;
+	__u32	reserved;
+};
+
+struct mlx5_ib_create_rwq_ind_tbl_resp {
+	__u32	response_length;
+	__u32	reserved;
+};
+
+struct mlx5_ib_modify_wq {
+	__u32	comp_mask;
+	__u32	reserved;
+};
+
+struct mlx5_ib_clock_info {
+	__u32 sign;
+	__u32 resv;
+	__u64 nsec;
+	__u64 cycles;
+	__u64 frac;
+	__u32 mult;
+	__u32 shift;
+	__u64 mask;
+	__u64 overflow_period;
+};
+
+enum mlx5_ib_mmap_cmd {
+	MLX5_IB_MMAP_REGULAR_PAGE               = 0,
+	MLX5_IB_MMAP_GET_CONTIGUOUS_PAGES       = 1,
+	MLX5_IB_MMAP_WC_PAGE                    = 2,
+	MLX5_IB_MMAP_NC_PAGE                    = 3,
+	/* 5 is chosen in order to be compatible with old versions of libmlx5 */
+	MLX5_IB_MMAP_CORE_CLOCK                 = 5,
+	MLX5_IB_MMAP_ALLOC_WC                   = 6,
+	MLX5_IB_MMAP_CLOCK_INFO                 = 7,
+};
+
+enum {
+	MLX5_IB_CLOCK_INFO_KERNEL_UPDATING = 1,
+};
+
+/* Bit indexes for the mlx5_alloc_ucontext_resp.clock_info_versions bitmap */
+enum {
+	MLX5_IB_CLOCK_INFO_V1              = 0,
+};
+#endif /* MLX5_ABI_USER_H */
diff --git a/kernel-headers/rdma/mthca-abi.h b/kernel-headers/rdma/mthca-abi.h
new file mode 100644
index 00000000000000..3020d8a907a74f
--- /dev/null
+++ b/kernel-headers/rdma/mthca-abi.h
@@ -0,0 +1,112 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause) */
+/*
+ * Copyright (c) 2005 Topspin Communications.  All rights reserved.
+ * Copyright (c) 2005, 2006 Cisco Systems.  All rights reserved.
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
+#ifndef MTHCA_ABI_USER_H
+#define MTHCA_ABI_USER_H
+
+#include <linux/types.h>
+
+/*
+ * Increment this value if any changes that break userspace ABI
+ * compatibility are made.
+ */
+#define MTHCA_UVERBS_ABI_VERSION	1
+
+/*
+ * Make sure that all structs defined in this file remain laid out so
+ * that they pack the same way on 32-bit and 64-bit architectures (to
+ * avoid incompatibility between 32-bit userspace and 64-bit kernels).
+ * In particular do not use pointer types -- pass pointers in __u64
+ * instead.
+ */
+struct mthca_alloc_ucontext_resp {
+	__u32 qp_tab_size;
+	__u32 uarc_size;
+};
+
+struct mthca_alloc_pd_resp {
+	__u32 pdn;
+	__u32 reserved;
+};
+
+/*
+ * Mark the memory region with a DMA attribute that causes
+ * in-flight DMA to be flushed when the region is written to:
+ */
+#define MTHCA_MR_DMASYNC	0x1
+
+struct mthca_reg_mr {
+	__u32 mr_attrs;
+	__u32 reserved;
+};
+
+struct mthca_create_cq {
+	__u32 lkey;
+	__u32 pdn;
+	__u64 arm_db_page;
+	__u64 set_db_page;
+	__u32 arm_db_index;
+	__u32 set_db_index;
+};
+
+struct mthca_create_cq_resp {
+	__u32 cqn;
+	__u32 reserved;
+};
+
+struct mthca_resize_cq {
+	__u32 lkey;
+	__u32 reserved;
+};
+
+struct mthca_create_srq {
+	__u32 lkey;
+	__u32 db_index;
+	__u64 db_page;
+};
+
+struct mthca_create_srq_resp {
+	__u32 srqn;
+	__u32 reserved;
+};
+
+struct mthca_create_qp {
+	__u32 lkey;
+	__u32 reserved;
+	__u64 sq_db_page;
+	__u64 rq_db_page;
+	__u32 sq_db_index;
+	__u32 rq_db_index;
+};
+#endif /* MTHCA_ABI_USER_H */
diff --git a/kernel-headers/rdma/nes-abi.h b/kernel-headers/rdma/nes-abi.h
new file mode 100644
index 00000000000000..f5b2437aab2884
--- /dev/null
+++ b/kernel-headers/rdma/nes-abi.h
@@ -0,0 +1,115 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause) */
+/*
+ * Copyright (c) 2006 - 2011 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2005 Topspin Communications.  All rights reserved.
+ * Copyright (c) 2005 Cisco Systems.  All rights reserved.
+ * Copyright (c) 2005 Open Grid Computing, Inc. All rights reserved.
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
+ *
+ */
+
+#ifndef NES_ABI_USER_H
+#define NES_ABI_USER_H
+
+#include <linux/types.h>
+
+#define NES_ABI_USERSPACE_VER 2
+#define NES_ABI_KERNEL_VER    2
+
+/*
+ * Make sure that all structs defined in this file remain laid out so
+ * that they pack the same way on 32-bit and 64-bit architectures (to
+ * avoid incompatibility between 32-bit userspace and 64-bit kernels).
+ * In particular do not use pointer types -- pass pointers in __u64
+ * instead.
+ */
+
+struct nes_alloc_ucontext_req {
+	__u32 reserved32;
+	__u8  userspace_ver;
+	__u8  reserved8[3];
+};
+
+struct nes_alloc_ucontext_resp {
+	__u32 max_pds; /* maximum pds allowed for this user process */
+	__u32 max_qps; /* maximum qps allowed for this user process */
+	__u32 wq_size; /* size of the WQs (sq+rq) allocated to the mmaped area */
+	__u8  virtwq;  /* flag to indicate if virtual WQ are to be used or not */
+	__u8  kernel_ver;
+	__u8  reserved[2];
+};
+
+struct nes_alloc_pd_resp {
+	__u32 pd_id;
+	__u32 mmap_db_index;
+};
+
+struct nes_create_cq_req {
+	__u64 user_cq_buffer;
+	__u32 mcrqf;
+	__u8 reserved[4];
+};
+
+struct nes_create_qp_req {
+	__u64 user_wqe_buffers;
+	__u64 user_qp_buffer;
+};
+
+enum iwnes_memreg_type {
+	IWNES_MEMREG_TYPE_MEM = 0x0000,
+	IWNES_MEMREG_TYPE_QP = 0x0001,
+	IWNES_MEMREG_TYPE_CQ = 0x0002,
+	IWNES_MEMREG_TYPE_MW = 0x0003,
+	IWNES_MEMREG_TYPE_FMR = 0x0004,
+	IWNES_MEMREG_TYPE_FMEM = 0x0005,
+};
+
+struct nes_mem_reg_req {
+	__u32 reg_type;	/* indicates if id is memory, QP or CQ */
+	__u32 reserved;
+};
+
+struct nes_create_cq_resp {
+	__u32 cq_id;
+	__u32 cq_size;
+	__u32 mmap_db_index;
+	__u32 reserved;
+};
+
+struct nes_create_qp_resp {
+	__u32 qp_id;
+	__u32 actual_sq_size;
+	__u32 actual_rq_size;
+	__u32 mmap_sq_db_index;
+	__u32 mmap_rq_db_index;
+	__u32 nes_drv_opt;
+};
+
+#endif	/* NES_ABI_USER_H */
diff --git a/kernel-headers/rdma/ocrdma-abi.h b/kernel-headers/rdma/ocrdma-abi.h
new file mode 100644
index 00000000000000..e0475d59cdf00d
--- /dev/null
+++ b/kernel-headers/rdma/ocrdma-abi.h
@@ -0,0 +1,152 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause) */
+/* This file is part of the Emulex RoCE Device Driver for
+ * RoCE (RDMA over Converged Ethernet) adapters.
+ * Copyright (C) 2012-2015 Emulex. All rights reserved.
+ * EMULEX and SLI are trademarks of Emulex.
+ * www.emulex.com
+ *
+ * This software is available to you under a choice of one of two licenses.
+ * You may choose to be licensed under the terms of the GNU General Public
+ * License (GPL) Version 2, available from the file COPYING in the main
+ * directory of this source tree, or the BSD license below:
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ * - Redistributions of source code must retain the above copyright notice,
+ *   this list of conditions and the following disclaimer.
+ *
+ * - Redistributions in binary form must reproduce the above copyright
+ *   notice, this list of conditions and the following disclaimer in
+ *   the documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
+ * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
+ * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
+ * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
+ * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ * Contact Information:
+ * linux-drivers-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org
+ *
+ * Emulex
+ * 3333 Susan Street
+ * Costa Mesa, CA 92626
+ */
+
+#ifndef OCRDMA_ABI_USER_H
+#define OCRDMA_ABI_USER_H
+
+#include <linux/types.h>
+
+#define OCRDMA_ABI_VERSION 2
+#define OCRDMA_BE_ROCE_ABI_VERSION 1
+/* user kernel communication data structures. */
+
+struct ocrdma_alloc_ucontext_resp {
+	__u32 dev_id;
+	__u32 wqe_size;
+	__u32 max_inline_data;
+	__u32 dpp_wqe_size;
+	__u64 ah_tbl_page;
+	__u32 ah_tbl_len;
+	__u32 rqe_size;
+	__u8 fw_ver[32];
+	/* for future use/new features in progress */
+	__u64 rsvd1;
+	__u64 rsvd2;
+};
+
+struct ocrdma_alloc_pd_ureq {
+	__u64 rsvd1;
+};
+
+struct ocrdma_alloc_pd_uresp {
+	__u32 id;
+	__u32 dpp_enabled;
+	__u32 dpp_page_addr_hi;
+	__u32 dpp_page_addr_lo;
+	__u64 rsvd1;
+};
+
+struct ocrdma_create_cq_ureq {
+	__u32 dpp_cq;
+	__u32 rsvd; /* pad */
+};
+
+#define MAX_CQ_PAGES 8
+struct ocrdma_create_cq_uresp {
+	__u32 cq_id;
+	__u32 page_size;
+	__u32 num_pages;
+	__u32 max_hw_cqe;
+	__u64 page_addr[MAX_CQ_PAGES];
+	__u64 db_page_addr;
+	__u32 db_page_size;
+	__u32 phase_change;
+	/* for future use/new features in progress */
+	__u64 rsvd1;
+	__u64 rsvd2;
+};
+
+#define MAX_QP_PAGES 8
+#define MAX_UD_AV_PAGES 8
+
+struct ocrdma_create_qp_ureq {
+	__u8 enable_dpp_cq;
+	__u8 rsvd;
+	__u16 dpp_cq_id;
+	__u32 rsvd1;	/* pad */
+};
+
+struct ocrdma_create_qp_uresp {
+	__u16 qp_id;
+	__u16 sq_dbid;
+	__u16 rq_dbid;
+	__u16 resv0;	/* pad */
+	__u32 sq_page_size;
+	__u32 rq_page_size;
+	__u32 num_sq_pages;
+	__u32 num_rq_pages;
+	__u64 sq_page_addr[MAX_QP_PAGES];
+	__u64 rq_page_addr[MAX_QP_PAGES];
+	__u64 db_page_addr;
+	__u32 db_page_size;
+	__u32 dpp_credit;
+	__u32 dpp_offset;
+	__u32 num_wqe_allocated;
+	__u32 num_rqe_allocated;
+	__u32 db_sq_offset;
+	__u32 db_rq_offset;
+	__u32 db_shift;
+	__u64 rsvd[11];
+};
+
+struct ocrdma_create_srq_uresp {
+	__u16 rq_dbid;
+	__u16 resv0;	/* pad */
+	__u32 resv1;
+
+	__u32 rq_page_size;
+	__u32 num_rq_pages;
+
+	__u64 rq_page_addr[MAX_QP_PAGES];
+	__u64 db_page_addr;
+
+	__u32 db_page_size;
+	__u32 num_rqe_allocated;
+	__u32 db_rq_offset;
+	__u32 db_shift;
+
+	__u64 rsvd2;
+	__u64 rsvd3;
+};
+
+#endif	/* OCRDMA_ABI_USER_H */
diff --git a/kernel-headers/rdma/qedr-abi.h b/kernel-headers/rdma/qedr-abi.h
new file mode 100644
index 00000000000000..261c6db4623e28
--- /dev/null
+++ b/kernel-headers/rdma/qedr-abi.h
@@ -0,0 +1,110 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause) */
+/* QLogic qedr NIC Driver
+ * Copyright (c) 2015-2016  QLogic Corporation
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
+ *        disclaimer in the documentation and /or other materials
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
+#ifndef __QEDR_USER_H__
+#define __QEDR_USER_H__
+
+#include <linux/types.h>
+
+#define QEDR_ABI_VERSION		(8)
+
+/* user kernel communication data structures. */
+
+struct qedr_alloc_ucontext_resp {
+	__u64 db_pa;
+	__u32 db_size;
+
+	__u32 max_send_wr;
+	__u32 max_recv_wr;
+	__u32 max_srq_wr;
+	__u32 sges_per_send_wr;
+	__u32 sges_per_recv_wr;
+	__u32 sges_per_srq_wr;
+	__u32 max_cqes;
+	__u8 dpm_enabled;
+	__u8 wids_enabled;
+	__u16 wid_count;
+};
+
+struct qedr_alloc_pd_ureq {
+	__u64 rsvd1;
+};
+
+struct qedr_alloc_pd_uresp {
+	__u32 pd_id;
+};
+
+struct qedr_create_cq_ureq {
+	__u64 addr;
+	__u64 len;
+};
+
+struct qedr_create_cq_uresp {
+	__u32 db_offset;
+	__u16 icid;
+};
+
+struct qedr_create_qp_ureq {
+	__u32 qp_handle_hi;
+	__u32 qp_handle_lo;
+
+	/* SQ */
+	/* user space virtual address of SQ buffer */
+	__u64 sq_addr;
+
+	/* length of SQ buffer */
+	__u64 sq_len;
+
+	/* RQ */
+	/* user space virtual address of RQ buffer */
+	__u64 rq_addr;
+
+	/* length of RQ buffer */
+	__u64 rq_len;
+};
+
+struct qedr_create_qp_uresp {
+	__u32 qp_id;
+	__u32 atomic_supported;
+
+	/* SQ */
+	__u32 sq_db_offset;
+	__u16 sq_icid;
+
+	/* RQ */
+	__u32 rq_db_offset;
+	__u16 rq_icid;
+
+	__u32 rq_db2_offset;
+};
+
+#endif /* __QEDR_USER_H__ */
diff --git a/buildlib/fixup-include/rdma-rdma_netlink.h b/kernel-headers/rdma/rdma_netlink.h
similarity index 59%
rename from buildlib/fixup-include/rdma-rdma_netlink.h
rename to kernel-headers/rdma/rdma_netlink.h
index 02fe8390c18f6d..17e59bec169ec0 100644
--- a/buildlib/fixup-include/rdma-rdma_netlink.h
+++ b/kernel-headers/rdma/rdma_netlink.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 #ifndef _UAPI_RDMA_NETLINK_H
 #define _UAPI_RDMA_NETLINK_H
 
@@ -8,7 +9,7 @@ enum {
 	RDMA_NL_IWCM,
 	RDMA_NL_RSVD,
 	RDMA_NL_LS,	/* RDMA Local Services */
-	RDMA_NL_I40IW,
+	RDMA_NL_NLDEV,	/* RDMA device interface */
 	RDMA_NL_NUM_CLIENTS
 };
 
@@ -222,4 +223,135 @@ struct rdma_nla_ls_gid {
 	__u8		gid[16];
 };
 
+enum rdma_nldev_command {
+	RDMA_NLDEV_CMD_UNSPEC,
+
+	RDMA_NLDEV_CMD_GET, /* can dump */
+	RDMA_NLDEV_CMD_SET,
+	RDMA_NLDEV_CMD_NEW,
+	RDMA_NLDEV_CMD_DEL,
+
+	RDMA_NLDEV_CMD_PORT_GET, /* can dump */
+	RDMA_NLDEV_CMD_PORT_SET,
+	RDMA_NLDEV_CMD_PORT_NEW,
+	RDMA_NLDEV_CMD_PORT_DEL,
+
+	RDMA_NLDEV_CMD_RES_GET, /* can dump */
+
+	RDMA_NLDEV_CMD_RES_QP_GET, /* can dump */
+
+	RDMA_NLDEV_NUM_OPS
+};
+
+enum rdma_nldev_attr {
+	/* don't change the order or add anything between, this is ABI! */
+	RDMA_NLDEV_ATTR_UNSPEC,
+
+	/* Identifier for ib_device */
+	RDMA_NLDEV_ATTR_DEV_INDEX,		/* u32 */
+
+	RDMA_NLDEV_ATTR_DEV_NAME,		/* string */
+	/*
+	 * Device index together with port index are identifiers
+	 * for port/link properties.
+	 *
+	 * For RDMA_NLDEV_CMD_GET commamnd, port index will return number
+	 * of available ports in ib_device, while for port specific operations,
+	 * it will be real port index as it appears in sysfs. Port index follows
+	 * sysfs notation and starts from 1 for the first port.
+	 */
+	RDMA_NLDEV_ATTR_PORT_INDEX,		/* u32 */
+
+	/*
+	 * Device and port capabilities
+	 */
+	RDMA_NLDEV_ATTR_CAP_FLAGS,		/* u64 */
+
+	/*
+	 * FW version
+	 */
+	RDMA_NLDEV_ATTR_FW_VERSION,		/* string */
+
+	/*
+	 * Node GUID (in host byte order) associated with the RDMA device.
+	 */
+	RDMA_NLDEV_ATTR_NODE_GUID,			/* u64 */
+
+	/*
+	 * System image GUID (in host byte order) associated with
+	 * this RDMA device and other devices which are part of a
+	 * single system.
+	 */
+	RDMA_NLDEV_ATTR_SYS_IMAGE_GUID,		/* u64 */
+
+	/*
+	 * Subnet prefix (in host byte order)
+	 */
+	RDMA_NLDEV_ATTR_SUBNET_PREFIX,		/* u64 */
+
+	/*
+	 * Local Identifier (LID),
+	 * According to IB specification, It is 16-bit address assigned
+	 * by the Subnet Manager. Extended to be 32-bit for OmniPath users.
+	 */
+	RDMA_NLDEV_ATTR_LID,			/* u32 */
+	RDMA_NLDEV_ATTR_SM_LID,			/* u32 */
+
+	/*
+	 * LID mask control (LMC)
+	 */
+	RDMA_NLDEV_ATTR_LMC,			/* u8 */
+
+	RDMA_NLDEV_ATTR_PORT_STATE,		/* u8 */
+	RDMA_NLDEV_ATTR_PORT_PHYS_STATE,	/* u8 */
+
+	RDMA_NLDEV_ATTR_DEV_NODE_TYPE,		/* u8 */
+
+	RDMA_NLDEV_ATTR_RES_SUMMARY,		/* nested table */
+	RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY,	/* nested table */
+	RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_NAME,	/* string */
+	RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_CURR,	/* u64 */
+
+	RDMA_NLDEV_ATTR_RES_QP,			/* nested table */
+	RDMA_NLDEV_ATTR_RES_QP_ENTRY,		/* nested table */
+	/*
+	 * Local QPN
+	 */
+	RDMA_NLDEV_ATTR_RES_LQPN,		/* u32 */
+	/*
+	 * Remote QPN,
+	 * Applicable for RC and UC only IBTA 11.2.5.3 QUERY QUEUE PAIR
+	 */
+	RDMA_NLDEV_ATTR_RES_RQPN,		/* u32 */
+	/*
+	 * Receive Queue PSN,
+	 * Applicable for RC and UC only 11.2.5.3 QUERY QUEUE PAIR
+	 */
+	RDMA_NLDEV_ATTR_RES_RQ_PSN,		/* u32 */
+	/*
+	 * Send Queue PSN
+	 */
+	RDMA_NLDEV_ATTR_RES_SQ_PSN,		/* u32 */
+	RDMA_NLDEV_ATTR_RES_PATH_MIG_STATE,	/* u8 */
+	/*
+	 * QP types as visible to RDMA/core, the reserved QPT
+	 * are not exported through this interface.
+	 */
+	RDMA_NLDEV_ATTR_RES_TYPE,		/* u8 */
+	RDMA_NLDEV_ATTR_RES_STATE,		/* u8 */
+	/*
+	 * Process ID which created object,
+	 * in case of kernel origin, PID won't exist.
+	 */
+	RDMA_NLDEV_ATTR_RES_PID,		/* u32 */
+	/*
+	 * The name of process created following resource.
+	 * It will exist only for kernel objects.
+	 * For user created objects, the user is supposed
+	 * to read /proc/PID/comm file.
+	 */
+	RDMA_NLDEV_ATTR_RES_KERN_NAME,		/* string */
+
+	RDMA_NLDEV_ATTR_MAX
+};
 #endif /* _UAPI_RDMA_NETLINK_H */
diff --git a/kernel-headers/rdma/rdma_user_cm.h b/kernel-headers/rdma/rdma_user_cm.h
new file mode 100644
index 00000000000000..c83ef0026079c8
--- /dev/null
+++ b/kernel-headers/rdma/rdma_user_cm.h
@@ -0,0 +1,311 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause) */
+/*
+ * Copyright (c) 2005-2006 Intel Corporation.  All rights reserved.
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
+#ifndef RDMA_USER_CM_H
+#define RDMA_USER_CM_H
+
+#include <linux/types.h>
+#include <linux/socket.h>
+#include <linux/in6.h>
+#include <rdma/ib_user_verbs.h>
+#include <rdma/ib_user_sa.h>
+
+#define RDMA_USER_CM_ABI_VERSION	4
+
+#define RDMA_MAX_PRIVATE_DATA		256
+
+enum {
+	RDMA_USER_CM_CMD_CREATE_ID,
+	RDMA_USER_CM_CMD_DESTROY_ID,
+	RDMA_USER_CM_CMD_BIND_IP,
+	RDMA_USER_CM_CMD_RESOLVE_IP,
+	RDMA_USER_CM_CMD_RESOLVE_ROUTE,
+	RDMA_USER_CM_CMD_QUERY_ROUTE,
+	RDMA_USER_CM_CMD_CONNECT,
+	RDMA_USER_CM_CMD_LISTEN,
+	RDMA_USER_CM_CMD_ACCEPT,
+	RDMA_USER_CM_CMD_REJECT,
+	RDMA_USER_CM_CMD_DISCONNECT,
+	RDMA_USER_CM_CMD_INIT_QP_ATTR,
+	RDMA_USER_CM_CMD_GET_EVENT,
+	RDMA_USER_CM_CMD_GET_OPTION,
+	RDMA_USER_CM_CMD_SET_OPTION,
+	RDMA_USER_CM_CMD_NOTIFY,
+	RDMA_USER_CM_CMD_JOIN_IP_MCAST,
+	RDMA_USER_CM_CMD_LEAVE_MCAST,
+	RDMA_USER_CM_CMD_MIGRATE_ID,
+	RDMA_USER_CM_CMD_QUERY,
+	RDMA_USER_CM_CMD_BIND,
+	RDMA_USER_CM_CMD_RESOLVE_ADDR,
+	RDMA_USER_CM_CMD_JOIN_MCAST
+};
+
+/*
+ * command ABI structures.
+ */
+struct rdma_ucm_cmd_hdr {
+	__u32 cmd;
+	__u16 in;
+	__u16 out;
+};
+
+struct rdma_ucm_create_id {
+	__u64 uid;
+	__u64 response;
+	__u16 ps;
+	__u8  qp_type;
+	__u8  reserved[5];
+};
+
+struct rdma_ucm_create_id_resp {
+	__u32 id;
+};
+
+struct rdma_ucm_destroy_id {
+	__u64 response;
+	__u32 id;
+	__u32 reserved;
+};
+
+struct rdma_ucm_destroy_id_resp {
+	__u32 events_reported;
+};
+
+struct rdma_ucm_bind_ip {
+	__u64 response;
+	struct sockaddr_in6 addr;
+	__u32 id;
+};
+
+struct rdma_ucm_bind {
+	__u32 id;
+	__u16 addr_size;
+	__u16 reserved;
+	struct __kernel_sockaddr_storage addr;
+};
+
+struct rdma_ucm_resolve_ip {
+	struct sockaddr_in6 src_addr;
+	struct sockaddr_in6 dst_addr;
+	__u32 id;
+	__u32 timeout_ms;
+};
+
+struct rdma_ucm_resolve_addr {
+	__u32 id;
+	__u32 timeout_ms;
+	__u16 src_size;
+	__u16 dst_size;
+	__u32 reserved;
+	struct __kernel_sockaddr_storage src_addr;
+	struct __kernel_sockaddr_storage dst_addr;
+};
+
+struct rdma_ucm_resolve_route {
+	__u32 id;
+	__u32 timeout_ms;
+};
+
+enum {
+	RDMA_USER_CM_QUERY_ADDR,
+	RDMA_USER_CM_QUERY_PATH,
+	RDMA_USER_CM_QUERY_GID
+};
+
+struct rdma_ucm_query {
+	__u64 response;
+	__u32 id;
+	__u32 option;
+};
+
+struct rdma_ucm_query_route_resp {
+	__u64 node_guid;
+	struct ib_user_path_rec ib_route[2];
+	struct sockaddr_in6 src_addr;
+	struct sockaddr_in6 dst_addr;
+	__u32 num_paths;
+	__u8 port_num;
+	__u8 reserved[3];
+};
+
+struct rdma_ucm_query_addr_resp {
+	__u64 node_guid;
+	__u8  port_num;
+	__u8  reserved;
+	__u16 pkey;
+	__u16 src_size;
+	__u16 dst_size;
+	struct __kernel_sockaddr_storage src_addr;
+	struct __kernel_sockaddr_storage dst_addr;
+};
+
+struct rdma_ucm_query_path_resp {
+	__u32 num_paths;
+	__u32 reserved;
+	struct ib_path_rec_data path_data[0];
+};
+
+struct rdma_ucm_conn_param {
+	__u32 qp_num;
+	__u32 qkey;
+	__u8  private_data[RDMA_MAX_PRIVATE_DATA];
+	__u8  private_data_len;
+	__u8  srq;
+	__u8  responder_resources;
+	__u8  initiator_depth;
+	__u8  flow_control;
+	__u8  retry_count;
+	__u8  rnr_retry_count;
+	__u8  valid;
+};
+
+struct rdma_ucm_ud_param {
+	__u32 qp_num;
+	__u32 qkey;
+	struct ib_uverbs_ah_attr ah_attr;
+	__u8  private_data[RDMA_MAX_PRIVATE_DATA];
+	__u8  private_data_len;
+	__u8  reserved[7];
+};
+
+struct rdma_ucm_connect {
+	struct rdma_ucm_conn_param conn_param;
+	__u32 id;
+	__u32 reserved;
+};
+
+struct rdma_ucm_listen {
+	__u32 id;
+	__u32 backlog;
+};
+
+struct rdma_ucm_accept {
+	__u64 uid;
+	struct rdma_ucm_conn_param conn_param;
+	__u32 id;
+	__u32 reserved;
+};
+
+struct rdma_ucm_reject {
+	__u32 id;
+	__u8  private_data_len;
+	__u8  reserved[3];
+	__u8  private_data[RDMA_MAX_PRIVATE_DATA];
+};
+
+struct rdma_ucm_disconnect {
+	__u32 id;
+};
+
+struct rdma_ucm_init_qp_attr {
+	__u64 response;
+	__u32 id;
+	__u32 qp_state;
+};
+
+struct rdma_ucm_notify {
+	__u32 id;
+	__u32 event;
+};
+
+struct rdma_ucm_join_ip_mcast {
+	__u64 response;		/* rdma_ucm_create_id_resp */
+	__u64 uid;
+	struct sockaddr_in6 addr;
+	__u32 id;
+};
+
+/* Multicast join flags */
+enum {
+	RDMA_MC_JOIN_FLAG_FULLMEMBER,
+	RDMA_MC_JOIN_FLAG_SENDONLY_FULLMEMBER,
+	RDMA_MC_JOIN_FLAG_RESERVED,
+};
+
+struct rdma_ucm_join_mcast {
+	__u64 response;		/* rdma_ucma_create_id_resp */
+	__u64 uid;
+	__u32 id;
+	__u16 addr_size;
+	__u16 join_flags;
+	struct __kernel_sockaddr_storage addr;
+};
+
+struct rdma_ucm_get_event {
+	__u64 response;
+};
+
+struct rdma_ucm_event_resp {
+	__u64 uid;
+	__u32 id;
+	__u32 event;
+	__u32 status;
+	union {
+		struct rdma_ucm_conn_param conn;
+		struct rdma_ucm_ud_param   ud;
+	} param;
+};
+
+/* Option levels */
+enum {
+	RDMA_OPTION_ID		= 0,
+	RDMA_OPTION_IB		= 1
+};
+
+/* Option details */
+enum {
+	RDMA_OPTION_ID_TOS	 = 0,
+	RDMA_OPTION_ID_REUSEADDR = 1,
+	RDMA_OPTION_ID_AFONLY	 = 2,
+	RDMA_OPTION_IB_PATH	 = 1
+};
+
+struct rdma_ucm_set_option {
+	__u64 optval;
+	__u32 id;
+	__u32 level;
+	__u32 optname;
+	__u32 optlen;
+};
+
+struct rdma_ucm_migrate_id {
+	__u64 response;
+	__u32 id;
+	__u32 fd;
+};
+
+struct rdma_ucm_migrate_resp {
+	__u32 events_reported;
+};
+
+#endif /* RDMA_USER_CM_H */
diff --git a/kernel-headers/rdma/rdma_user_ioctl.h b/kernel-headers/rdma/rdma_user_ioctl.h
new file mode 100644
index 00000000000000..03557b5f9aa6b8
--- /dev/null
+++ b/kernel-headers/rdma/rdma_user_ioctl.h
@@ -0,0 +1,121 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause) */
+/*
+ * Copyright (c) 2016 Mellanox Technologies, LTD. All rights reserved.
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
+#ifndef RDMA_USER_IOCTL_H
+#define RDMA_USER_IOCTL_H
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+#include <rdma/ib_user_mad.h>
+#include <rdma/hfi/hfi1_ioctl.h>
+
+/* Documentation/ioctl/ioctl-number.txt */
+#define RDMA_IOCTL_MAGIC	0x1b
+/* Legacy name, for user space application which already use it */
+#define IB_IOCTL_MAGIC		RDMA_IOCTL_MAGIC
+
+#define RDMA_VERBS_IOCTL \
+	_IOWR(RDMA_IOCTL_MAGIC, 1, struct ib_uverbs_ioctl_hdr)
+
+#define UVERBS_ID_NS_MASK 0xF000
+#define UVERBS_ID_NS_SHIFT 12
+
+enum {
+	/* User input */
+	UVERBS_ATTR_F_MANDATORY = 1U << 0,
+	/*
+	 * Valid output bit should be ignored and considered set in
+	 * mandatory fields. This bit is kernel output.
+	 */
+	UVERBS_ATTR_F_VALID_OUTPUT = 1U << 1,
+};
+
+struct ib_uverbs_attr {
+	__u16 attr_id;		/* command specific type attribute */
+	__u16 len;		/* only for pointers */
+	__u16 flags;		/* combination of UVERBS_ATTR_F_XXXX */
+	__u16 reserved;
+	__u64 data;		/* ptr to command, inline data or idr/fd */
+};
+
+struct ib_uverbs_ioctl_hdr {
+	__u16 length;
+	__u16 object_id;
+	__u16 method_id;
+	__u16 num_attrs;
+	__u64 reserved;
+	struct ib_uverbs_attr  attrs[0];
+};
+
+/*
+ * General blocks assignments
+ * It is closed on purpose do not expose it it user space
+ * #define MAD_CMD_BASE		0x00
+ * #define HFI1_CMD_BAS		0xE0
+ */
+
+/* MAD specific section */
+#define IB_USER_MAD_REGISTER_AGENT	_IOWR(RDMA_IOCTL_MAGIC, 0x01, struct ib_user_mad_reg_req)
+#define IB_USER_MAD_UNREGISTER_AGENT	_IOW(RDMA_IOCTL_MAGIC,  0x02, __u32)
+#define IB_USER_MAD_ENABLE_PKEY		_IO(RDMA_IOCTL_MAGIC,   0x03)
+#define IB_USER_MAD_REGISTER_AGENT2	_IOWR(RDMA_IOCTL_MAGIC, 0x04, struct ib_user_mad_reg_req2)
+
+/* HFI specific section */
+/* allocate HFI and context */
+#define HFI1_IOCTL_ASSIGN_CTXT		_IOWR(RDMA_IOCTL_MAGIC, 0xE1, struct hfi1_user_info)
+/* find out what resources we got */
+#define HFI1_IOCTL_CTXT_INFO		_IOW(RDMA_IOCTL_MAGIC,  0xE2, struct hfi1_ctxt_info)
+/* set up userspace */
+#define HFI1_IOCTL_USER_INFO		_IOW(RDMA_IOCTL_MAGIC,  0xE3, struct hfi1_base_info)
+/* update expected TID entries */
+#define HFI1_IOCTL_TID_UPDATE		_IOWR(RDMA_IOCTL_MAGIC, 0xE4, struct hfi1_tid_info)
+/* free expected TID entries */
+#define HFI1_IOCTL_TID_FREE		_IOWR(RDMA_IOCTL_MAGIC, 0xE5, struct hfi1_tid_info)
+/* force an update of PIO credit */
+#define HFI1_IOCTL_CREDIT_UPD		_IO(RDMA_IOCTL_MAGIC,   0xE6)
+/* control receipt of packets */
+#define HFI1_IOCTL_RECV_CTRL		_IOW(RDMA_IOCTL_MAGIC,  0xE8, int)
+/* set the kind of polling we want */
+#define HFI1_IOCTL_POLL_TYPE		_IOW(RDMA_IOCTL_MAGIC,  0xE9, int)
+/* ack & clear user status bits */
+#define HFI1_IOCTL_ACK_EVENT		_IOW(RDMA_IOCTL_MAGIC,  0xEA, unsigned long)
+/* set context's pkey */
+#define HFI1_IOCTL_SET_PKEY		_IOW(RDMA_IOCTL_MAGIC,  0xEB, __u16)
+/* reset context's HW send context */
+#define HFI1_IOCTL_CTXT_RESET		_IO(RDMA_IOCTL_MAGIC,   0xEC)
+/* read TID cache invalidations */
+#define HFI1_IOCTL_TID_INVAL_READ	_IOWR(RDMA_IOCTL_MAGIC, 0xED, struct hfi1_tid_info)
+/* get the version of the user cdev */
+#define HFI1_IOCTL_GET_VERS		_IOR(RDMA_IOCTL_MAGIC,  0xEE, int)
+
+#endif /* RDMA_USER_IOCTL_H */
diff --git a/buildlib/fixup-include/rdma-rdma_user_rxe.h b/kernel-headers/rdma/rdma_user_rxe.h
similarity index 95%
rename from buildlib/fixup-include/rdma-rdma_user_rxe.h
rename to kernel-headers/rdma/rdma_user_rxe.h
index 1de99cfdaf7d39..e3e6852b58eb45 100644
--- a/buildlib/fixup-include/rdma-rdma_user_rxe.h
+++ b/kernel-headers/rdma/rdma_user_rxe.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause) */
 /*
  * Copyright (c) 2016 Mellanox Technologies Ltd. All rights reserved.
  *
@@ -34,6 +35,9 @@
 #define RDMA_USER_RXE_H
 
 #include <linux/types.h>
+#include <linux/socket.h>
+#include <linux/in.h>
+#include <linux/in6.h>
 
 union rxe_gid {
 	__u8	raw[16];
@@ -56,7 +60,6 @@ struct rxe_av {
 	__u8			network_type;
 	struct rxe_global_route	grh;
 	union {
-		struct sockaddr		_sockaddr;
 		struct sockaddr_in	_sockaddr_in;
 		struct sockaddr_in6	_sockaddr_in6;
 	} sgid_addr, dgid_addr;
diff --git a/buildlib/fixup-include/rdma-vmw_pvrdma-abi.h b/kernel-headers/rdma/vmw_pvrdma-abi.h
similarity index 100%
rename from buildlib/fixup-include/rdma-vmw_pvrdma-abi.h
rename to kernel-headers/rdma/vmw_pvrdma-abi.h
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
