From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [rdma-core v4 1/8] libbnxt_re: introduce bnxtre user space RDMA provider
Date: Fri, 21 Apr 2017 13:30:11 -0400
Message-ID: <1492795818-29618-2-git-send-email-devesh.sharma@broadcom.com>
References: <1492795818-29618-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1492795818-29618-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

libnxtre is a user-space driver which provides RDMA
capability to user applications. The current framework
has following parts working:

 -Basic Cmake framework to build and install the library.
 -Register and unregister user-space driver with uverbs
  interface.
 -List all available bnxt_re devices using "ibv_devinfo"
  admin command.
 -List all the device and port attributes using
  "ibv_devinfo" admin command.
 -Support allocate/free of protection domains.
 -Check ABI version between library and kernel module.
 -Update MAINTAINERS file

v1->v2:
 --Deleted bnxtre.driver file
 --Dropped HAVE_CONFIG_H macro and cna_table declaration
 --Renamed abi.h to bnxt_re-abi.h

Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 CMakeLists.txt                   |   1 +
 MAINTAINERS                      |   5 +
 providers/bnxt_re/CMakeLists.txt |   4 +
 providers/bnxt_re/bnxt_re-abi.h  |  59 ++++++++++
 providers/bnxt_re/main.c         | 190 ++++++++++++++++++++++++++++++
 providers/bnxt_re/main.h         | 110 ++++++++++++++++++
 providers/bnxt_re/verbs.c        | 244 +++++++++++++++++++++++++++++++++++++++
 providers/bnxt_re/verbs.h        | 101 ++++++++++++++++
 8 files changed, 714 insertions(+)
 create mode 100644 providers/bnxt_re/CMakeLists.txt
 create mode 100644 providers/bnxt_re/bnxt_re-abi.h
 create mode 100644 providers/bnxt_re/main.c
 create mode 100644 providers/bnxt_re/main.h
 create mode 100644 providers/bnxt_re/verbs.c
 create mode 100644 providers/bnxt_re/verbs.h

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 1ff3189..29c6164 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -376,6 +376,7 @@ add_subdirectory(libibcm)
 
 # Providers
 if (HAVE_COHERENT_DMA)
+add_subdirectory(providers/bnxt_re)
 add_subdirectory(providers/cxgb3) # NO SPARSE
 add_subdirectory(providers/cxgb4) # NO SPARSE
 add_subdirectory(providers/hns) # NO SPARSE
diff --git a/MAINTAINERS b/MAINTAINERS
index 2ae504c..19fe88d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -40,6 +40,11 @@ F:	*/CMakeLists.txt
 F:	*/lib*.map
 F:	buildlib/
 
+BNXT_RE USERSPACE PROVIDER (for bnxt_re.ko)
+M:	Devesh Sharma  <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
+S:	Supported
+F:	providers/bnxt_re/
+
 CXGB3 USERSPACE PROVIDER (for iw_cxgb3.ko)
 M:	Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
 S:	Supported
diff --git a/providers/bnxt_re/CMakeLists.txt b/providers/bnxt_re/CMakeLists.txt
new file mode 100644
index 0000000..45e609d
--- /dev/null
+++ b/providers/bnxt_re/CMakeLists.txt
@@ -0,0 +1,4 @@
+rdma_provider(bnxt_re
+	main.c
+	verbs.c
+)
diff --git a/providers/bnxt_re/bnxt_re-abi.h b/providers/bnxt_re/bnxt_re-abi.h
new file mode 100644
index 0000000..05a0888
--- /dev/null
+++ b/providers/bnxt_re/bnxt_re-abi.h
@@ -0,0 +1,59 @@
+/*
+ * Broadcom NetXtreme-E User Space RoCE driver
+ *
+ * Copyright (c) 2015-2017, Broadcom. All rights reserved.  The term
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
+ * Description: ABI data structure definition
+ */
+
+#ifndef __BNXT_RE_ABI_H__
+#define __BNXT_RE_ABI_H__
+
+#include <infiniband/kern-abi.h>
+
+#define BNXT_RE_ABI_VERSION 1
+
+struct bnxt_re_cntx_resp {
+	struct ibv_get_context_resp resp;
+	__u32 dev_id;
+	__u32 max_qp; /* To allocate qp-table */
+};
+
+struct bnxt_re_pd_resp {
+	struct ibv_alloc_pd_resp resp;
+	__u32 pdid;
+	__u32 dpi;
+	__u64 dbr;
+};
+
+#endif
diff --git a/providers/bnxt_re/main.c b/providers/bnxt_re/main.c
new file mode 100644
index 0000000..24343b8
--- /dev/null
+++ b/providers/bnxt_re/main.c
@@ -0,0 +1,190 @@
+/*
+ * Broadcom NetXtreme-E User Space RoCE driver
+ *
+ * Copyright (c) 2015-2017, Broadcom. All rights reserved.  The term
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
+ * Description: Device detection and initializatoin
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <errno.h>
+#include <sys/mman.h>
+#include <pthread.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+
+#include "main.h"
+#include "verbs.h"
+
+#define PCI_VENDOR_ID_BROADCOM		0x14E4
+
+#define CNA(v, d)					\
+	{	.vendor = PCI_VENDOR_ID_##v,		\
+		.device = d }
+
+static const struct {
+	unsigned int vendor;
+	unsigned int device;
+} cna_table[] = {
+	CNA(BROADCOM, 0x16C0),  /* BCM57417 NPAR */
+	CNA(BROADCOM, 0x16CE),  /* BMC57311 */
+	CNA(BROADCOM, 0x16CF),  /* BMC57312 */
+	CNA(BROADCOM, 0x16DF),  /* BMC57314 */
+	CNA(BROADCOM, 0x16E5),  /* BMC57314 VF */
+	CNA(BROADCOM, 0x16E2),  /* BMC57417 */
+	CNA(BROADCOM, 0x16E3),  /* BMC57416 */
+	CNA(BROADCOM, 0x16D6),  /* BMC57412*/
+	CNA(BROADCOM, 0x16D7),  /* BMC57414 */
+	CNA(BROADCOM, 0x16D8),  /* BMC57416 Cu */
+	CNA(BROADCOM, 0x16D9),  /* BMC57417 Cu */
+	CNA(BROADCOM, 0x16C1),  /* BMC57414 VF */
+	CNA(BROADCOM, 0x16EF),  /* BCM57416 NPAR */
+	CNA(BROADCOM, 0x16ED),  /* BCM57414 NPAR */
+	CNA(BROADCOM, 0x16EB)   /* BCM57412 NPAR */
+};
+
+static struct ibv_context_ops bnxt_re_cntx_ops = {
+	.query_device  = bnxt_re_query_device,
+	.query_port    = bnxt_re_query_port,
+	.alloc_pd      = bnxt_re_alloc_pd,
+	.dealloc_pd    = bnxt_re_free_pd,
+	.reg_mr        = bnxt_re_reg_mr,
+	.dereg_mr      = bnxt_re_dereg_mr,
+	.create_cq     = bnxt_re_create_cq,
+	.poll_cq       = bnxt_re_poll_cq,
+	.req_notify_cq = bnxt_re_arm_cq,
+	.cq_event      = bnxt_re_cq_event,
+	.resize_cq     = bnxt_re_resize_cq,
+	.destroy_cq    = bnxt_re_destroy_cq,
+	.create_srq    = bnxt_re_create_srq,
+	.modify_srq    = bnxt_re_modify_srq,
+	.query_srq     = bnxt_re_query_srq,
+	.destroy_srq   = bnxt_re_destroy_srq,
+	.post_srq_recv = bnxt_re_post_srq_recv,
+	.create_qp     = bnxt_re_create_qp,
+	.query_qp      = bnxt_re_query_qp,
+	.modify_qp     = bnxt_re_modify_qp,
+	.destroy_qp    = bnxt_re_destroy_qp,
+	.post_send     = bnxt_re_post_send,
+	.post_recv     = bnxt_re_post_recv,
+	.create_ah     = bnxt_re_create_ah,
+	.destroy_ah    = bnxt_re_destroy_ah
+};
+
+static int bnxt_re_init_context(struct verbs_device *vdev,
+				struct ibv_context *ibvctx, int cmd_fd)
+{
+	struct ibv_get_context cmd;
+	struct bnxt_re_cntx_resp resp;
+	struct bnxt_re_context *cntx;
+
+	cntx = to_bnxt_re_context(ibvctx);
+
+	memset(&resp, 0, sizeof(resp));
+	ibvctx->cmd_fd = cmd_fd;
+	if (ibv_cmd_get_context(ibvctx, &cmd, sizeof(cmd),
+				&resp.resp, sizeof(resp)))
+		return errno;
+
+	cntx->dev_id = resp.dev_id;
+	cntx->max_qp = resp.max_qp;
+	ibvctx->ops = bnxt_re_cntx_ops;
+
+	return 0;
+}
+
+static void bnxt_re_uninit_context(struct verbs_device *vdev,
+				   struct ibv_context *ibvctx)
+{
+	/* Unmap if anything device specific was mapped in init_context. */
+}
+
+static struct verbs_device_ops bnxt_re_dev_ops = {
+	.init_context = bnxt_re_init_context,
+	.uninit_context = bnxt_re_uninit_context,
+};
+
+static struct verbs_device *bnxt_re_driver_init(const char *uverbs_sys_path,
+						int abi_version)
+{
+	char value[10];
+	struct bnxt_re_dev *dev;
+	unsigned int vendor, device;
+	int i;
+
+	if (ibv_read_sysfs_file(uverbs_sys_path, "device/vendor",
+				value, sizeof(value)) < 0)
+		return NULL;
+	vendor = strtol(value, NULL, 16);
+
+	if (ibv_read_sysfs_file(uverbs_sys_path, "device/device",
+				value, sizeof(value)) < 0)
+		return NULL;
+	device = strtol(value, NULL, 16);
+
+	for (i = 0; i < sizeof(cna_table) / sizeof(cna_table[0]); ++i)
+		if (vendor == cna_table[i].vendor &&
+		    device == cna_table[i].device)
+			goto found;
+	return NULL;
+found:
+	if (abi_version != BNXT_RE_ABI_VERSION) {
+		fprintf(stderr, DEV "FATAL: Max supported ABI of %s is %d "
+			"check for the latest version of kernel driver and"
+			"user library\n", uverbs_sys_path, abi_version);
+		return NULL;
+	}
+
+	dev = calloc(1, sizeof(*dev));
+	if (!dev) {
+		fprintf(stderr, DEV "Failed to allocate device for %s\n",
+			uverbs_sys_path);
+		return NULL;
+	}
+
+	dev->vdev.sz = sizeof(*dev);
+	dev->vdev.size_of_context =
+		sizeof(struct bnxt_re_context) - sizeof(struct ibv_context);
+	dev->vdev.ops = &bnxt_re_dev_ops;
+
+	return &dev->vdev;
+}
+
+static __attribute__((constructor)) void bnxt_re_register_driver(void)
+{
+	verbs_register_driver("bnxtre", bnxt_re_driver_init);
+}
diff --git a/providers/bnxt_re/main.h b/providers/bnxt_re/main.h
new file mode 100644
index 0000000..d621efa
--- /dev/null
+++ b/providers/bnxt_re/main.h
@@ -0,0 +1,110 @@
+/*
+ * Broadcom NetXtreme-E User Space RoCE driver
+ *
+ * Copyright (c) 2015-2017, Broadcom. All rights reserved.  The term
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
+ * Description: Basic device data structures needed for book-keeping
+ */
+
+#ifndef __MAIN_H__
+#define __MAIN_H__
+
+#include <inttypes.h>
+#include <stddef.h>
+#include <endian.h>
+#include <pthread.h>
+
+#include <infiniband/driver.h>
+#include <util/udma_barrier.h>
+
+#include "bnxt_re-abi.h"
+
+struct bnxt_re_pd {
+	struct ibv_pd ibvpd;
+	uint32_t pdid;
+};
+
+struct bnxt_re_cq {
+	struct ibv_cq ibvcq;
+};
+
+struct bnxt_re_qp {
+	struct ibv_qp ibvqp;
+};
+
+struct bnxt_re_srq {
+	struct ibv_srq ibvsrq;
+};
+
+struct bnxt_re_mr {
+	struct ibv_mr ibvmr;
+};
+
+#define DEV	"bnxtre : "
+
+struct bnxt_re_dpi {
+	__u32 dpindx;
+	__u64 *dbpage;
+	pthread_spinlock_t db_lock;
+};
+
+struct bnxt_re_dev {
+	struct verbs_device vdev;
+	uint8_t abi_version;
+};
+
+struct bnxt_re_context {
+	struct ibv_context ibvctx;
+	uint32_t dev_id;
+	uint32_t max_qp;
+	uint32_t max_srq;
+	struct bnxt_re_dpi udpi;
+};
+
+static inline struct bnxt_re_dev *to_bnxt_re_dev(struct ibv_device *ibvdev)
+{
+	return container_of(ibvdev, struct bnxt_re_dev, vdev);
+}
+
+static inline struct bnxt_re_context *to_bnxt_re_context(
+		struct ibv_context *ibvctx)
+{
+	return container_of(ibvctx, struct bnxt_re_context, ibvctx);
+}
+
+static inline struct bnxt_re_pd *to_bnxt_re_pd(struct ibv_pd *ibvpd)
+{
+	return container_of(ibvpd, struct bnxt_re_pd, ibvpd);
+}
+
+#endif
diff --git a/providers/bnxt_re/verbs.c b/providers/bnxt_re/verbs.c
new file mode 100644
index 0000000..3993c61
--- /dev/null
+++ b/providers/bnxt_re/verbs.c
@@ -0,0 +1,244 @@
+/*
+ * Broadcom NetXtreme-E User Space RoCE driver
+ *
+ * Copyright (c) 2015-2017, Broadcom. All rights reserved.  The term
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
+ * Description: User IB-Verbs implementation
+ */
+
+#include <assert.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <unistd.h>
+#include <signal.h>
+#include <errno.h>
+#include <pthread.h>
+#include <malloc.h>
+#include <sys/mman.h>
+#include <netinet/in.h>
+#include <unistd.h>
+
+#include "main.h"
+#include "verbs.h"
+
+int bnxt_re_query_device(struct ibv_context *ibvctx,
+			 struct ibv_device_attr *dev_attr)
+{
+	struct ibv_query_device cmd;
+	uint64_t fw_ver;
+	int status;
+
+	memset(dev_attr, 0, sizeof(struct ibv_device_attr));
+	status = ibv_cmd_query_device(ibvctx, dev_attr, &fw_ver,
+				      &cmd, sizeof(cmd));
+	return status;
+}
+
+int bnxt_re_query_port(struct ibv_context *ibvctx, uint8_t port,
+		       struct ibv_port_attr *port_attr)
+{
+	struct ibv_query_port cmd;
+
+	memset(port_attr, 0, sizeof(struct ibv_port_attr));
+	return ibv_cmd_query_port(ibvctx, port, port_attr, &cmd, sizeof(cmd));
+}
+
+struct ibv_pd *bnxt_re_alloc_pd(struct ibv_context *ibvctx)
+{
+	struct ibv_alloc_pd cmd;
+	struct bnxt_re_pd_resp resp;
+	struct bnxt_re_context *cntx = to_bnxt_re_context(ibvctx);
+	struct bnxt_re_pd *pd;
+	uint64_t dbr;
+
+	pd = calloc(1, sizeof(*pd));
+	if (!pd)
+		return NULL;
+
+	memset(&resp, 0, sizeof(resp));
+	if (ibv_cmd_alloc_pd(ibvctx, &pd->ibvpd, &cmd, sizeof(cmd),
+			     &resp.resp, sizeof(resp)))
+		goto out;
+
+	pd->pdid = resp.pdid;
+	dbr = *(uint64_t *)((uint32_t *)&resp + 3);
+
+	/* Map DB page now. */
+	cntx->udpi.dpindx = resp.dpi;
+	cntx->udpi.dbpage = mmap(NULL, 4096, PROT_WRITE, MAP_SHARED,
+				 ibvctx->cmd_fd, dbr);
+	if (cntx->udpi.dbpage == MAP_FAILED) {
+		(void)ibv_cmd_dealloc_pd(&pd->ibvpd);
+		goto out;
+	}
+	pthread_spin_init(&cntx->udpi.db_lock, PTHREAD_PROCESS_PRIVATE);
+
+	return &pd->ibvpd;
+out:
+	free(pd);
+	return NULL;
+}
+
+int bnxt_re_free_pd(struct ibv_pd *ibvpd)
+{
+	struct bnxt_re_pd *pd = to_bnxt_re_pd(ibvpd);
+	struct bnxt_re_context *cntx = to_bnxt_re_context(ibvpd->context);
+	int status;
+
+	status = ibv_cmd_dealloc_pd(ibvpd);
+	if (status)
+		return status;
+
+	pthread_spin_destroy(&cntx->udpi.db_lock);
+	if (cntx->udpi.dbpage && (cntx->udpi.dbpage != MAP_FAILED))
+		munmap(cntx->udpi.dbpage, 4096);
+	free(pd);
+
+	return 0;
+}
+
+struct ibv_mr *bnxt_re_reg_mr(struct ibv_pd *ibvpd, void *sva, size_t len,
+			      int access)
+{
+	return NULL;
+}
+
+int bnxt_re_dereg_mr(struct ibv_mr *ibvmr)
+{
+	return -ENOSYS;
+}
+
+struct ibv_cq *bnxt_re_create_cq(struct ibv_context *ibvctx, int ncqe,
+				 struct ibv_comp_channel *channel, int vec)
+{
+	return NULL;
+}
+
+int bnxt_re_resize_cq(struct ibv_cq *ibvcq, int ncqe)
+{
+	return -ENOSYS;
+}
+
+int bnxt_re_destroy_cq(struct ibv_cq *ibvcq)
+{
+	return -ENOSYS;
+}
+
+int bnxt_re_poll_cq(struct ibv_cq *ibvcq, int nwc, struct ibv_wc *wc)
+{
+	return -ENOSYS;
+}
+
+void bnxt_re_cq_event(struct ibv_cq *ibvcq)
+{
+
+}
+
+int bnxt_re_arm_cq(struct ibv_cq *ibvcq, int flags)
+{
+	return -ENOSYS;
+}
+
+struct ibv_qp *bnxt_re_create_qp(struct ibv_pd *ibvpd,
+				 struct ibv_qp_init_attr *attr)
+{
+	return NULL;
+}
+
+int bnxt_re_modify_qp(struct ibv_qp *ibvqp, struct ibv_qp_attr *attr,
+		      int attr_mask)
+{
+	return -ENOSYS;
+}
+
+int bnxt_re_query_qp(struct ibv_qp *ibvqp, struct ibv_qp_attr *attr,
+		     int attr_mask, struct ibv_qp_init_attr *init_attr)
+{
+	return -ENOSYS;
+}
+
+int bnxt_re_destroy_qp(struct ibv_qp *ibvqp)
+{
+	return -ENOSYS;
+}
+
+int bnxt_re_post_send(struct ibv_qp *ibvqp, struct ibv_send_wr *wr,
+		      struct ibv_send_wr **bad)
+{
+	return -ENOSYS;
+}
+
+int bnxt_re_post_recv(struct ibv_qp *ibvqp, struct ibv_recv_wr *wr,
+		      struct ibv_recv_wr **bad)
+{
+	return -ENOSYS;
+}
+
+struct ibv_srq *bnxt_re_create_srq(struct ibv_pd *ibvpd,
+				   struct ibv_srq_init_attr *attr)
+{
+	return NULL;
+}
+
+int bnxt_re_modify_srq(struct ibv_srq *ibvsrq, struct ibv_srq_attr *attr,
+		       int init_attr)
+{
+	return -ENOSYS;
+}
+
+int bnxt_re_destroy_srq(struct ibv_srq *ibvsrq)
+{
+	return -ENOSYS;
+}
+
+int bnxt_re_query_srq(struct ibv_srq *ibvsrq, struct ibv_srq_attr *attr)
+{
+	return -ENOSYS;
+}
+
+int bnxt_re_post_srq_recv(struct ibv_srq *ibvsrq, struct ibv_recv_wr *wr,
+			  struct ibv_recv_wr **bad)
+{
+	return -ENOSYS;
+}
+
+struct ibv_ah *bnxt_re_create_ah(struct ibv_pd *ibvpd, struct ibv_ah_attr *attr)
+{
+	return NULL;
+}
+
+int bnxt_re_destroy_ah(struct ibv_ah *ibvah)
+{
+	return -ENOSYS;
+}
diff --git a/providers/bnxt_re/verbs.h b/providers/bnxt_re/verbs.h
new file mode 100644
index 0000000..1b2a4a7
--- /dev/null
+++ b/providers/bnxt_re/verbs.h
@@ -0,0 +1,101 @@
+/*
+ * Broadcom NetXtreme-E User Space RoCE driver
+ *
+ * Copyright (c) 2015-2017, Broadcom. All rights reserved.  The term
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
+ * Description: Internal IB-verbs function declaration
+ */
+
+#ifndef __VERBS_H__
+#define __VERBS_H__
+
+#include <assert.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <unistd.h>
+#include <signal.h>
+#include <errno.h>
+#include <pthread.h>
+#include <malloc.h>
+#include <sys/mman.h>
+#include <netinet/in.h>
+#include <unistd.h>
+
+#include <infiniband/driver.h>
+#include <infiniband/verbs.h>
+
+int bnxt_re_query_device(struct ibv_context *uctx,
+			 struct ibv_device_attr *attr);
+int bnxt_re_query_port(struct ibv_context *uctx, uint8_t port,
+		       struct ibv_port_attr *attr);
+struct ibv_pd *bnxt_re_alloc_pd(struct ibv_context *uctx);
+int bnxt_re_free_pd(struct ibv_pd *ibvpd);
+struct ibv_mr *bnxt_re_reg_mr(struct ibv_pd *ibvpd, void *buf, size_t len,
+			      int ibv_access_flags);
+int bnxt_re_dereg_mr(struct ibv_mr *ibvmr);
+
+struct ibv_cq *bnxt_re_create_cq(struct ibv_context *uctx, int ncqe,
+				 struct ibv_comp_channel *ch, int vec);
+int bnxt_re_resize_cq(struct ibv_cq *ibvcq, int ncqe);
+int bnxt_re_destroy_cq(struct ibv_cq *ibvcq);
+int bnxt_re_poll_cq(struct ibv_cq *ibvcq, int nwc, struct ibv_wc *wc);
+void bnxt_re_cq_event(struct ibv_cq *ibvcq);
+int bnxt_re_arm_cq(struct ibv_cq *ibvcq, int flags);
+
+struct ibv_qp *bnxt_re_create_qp(struct ibv_pd *ibvpd,
+				 struct ibv_qp_init_attr *attr);
+int bnxt_re_modify_qp(struct ibv_qp *ibvqp, struct ibv_qp_attr *attr,
+		      int ibv_qp_attr_mask);
+int bnxt_re_query_qp(struct ibv_qp *ibvqp, struct ibv_qp_attr *attr,
+		     int attr_mask, struct ibv_qp_init_attr *init_attr);
+int bnxt_re_destroy_qp(struct ibv_qp *ibvqp);
+int bnxt_re_post_send(struct ibv_qp *ibvqp, struct ibv_send_wr *wr,
+		      struct ibv_send_wr **bad);
+int bnxt_re_post_recv(struct ibv_qp *ibvqp, struct ibv_recv_wr *wr,
+		      struct ibv_recv_wr **bad);
+
+struct ibv_srq *bnxt_re_create_srq(struct ibv_pd *ibvpd,
+				   struct ibv_srq_init_attr *attr);
+int bnxt_re_modify_srq(struct ibv_srq *ibvsrq,
+		       struct ibv_srq_attr *attr, int mask);
+int bnxt_re_destroy_srq(struct ibv_srq *ibvsrq);
+int bnxt_re_query_srq(struct ibv_srq *ibvsrq, struct ibv_srq_attr *attr);
+int bnxt_re_post_srq_recv(struct ibv_srq *ibvsrq, struct ibv_recv_wr *wr,
+			  struct ibv_recv_wr **bad);
+
+struct ibv_ah *bnxt_re_create_ah(struct ibv_pd *ibvpd,
+				 struct ibv_ah_attr *attr);
+int bnxt_re_destroy_ah(struct ibv_ah *ibvah);
+
+#endif /* __BNXT_RE_VERBS_H__ */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
