From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] libmlx4: Add support for verbs extensions
Date: Wed, 15 Jun 2011 17:06:47 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373021260@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Update the libmlx4 library to register extensions with
libibverbs, if it supports extensions.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 configure.in   |    3 ++
 src/mlx4-ext.c |   70 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/mlx4-ext.h |   52 ++++++++++++++++++++++++++++++++++++++++++
 src/mlx4.c     |    6 ++++-
 4 files changed, 130 insertions(+), 1 deletions(-)
 create mode 100644 src/mlx4-ext.c
 create mode 100644 src/mlx4-ext.h

diff --git a/configure.in b/configure.in
index d7fb436..2ed1cfa 100644
--- a/configure.in
+++ b/configure.in
@@ -28,6 +28,9 @@ dnl Checks for libraries
 AC_CHECK_LIB(ibverbs, ibv_get_device_list, [],
     AC_MSG_ERROR([ibv_get_device_list() not found.  libmlx4 requires libibverbs.]))
 
+AC_CHECK_LIB(ibverbs, ibv_register_driver_ext,
+    AC_DEFINE(HAVE_IBV_EXT, 1, [adding verbs extension support]))
+
 dnl Checks for header files.
 AC_CHECK_HEADER(infiniband/driver.h, [],
     AC_MSG_ERROR([<infiniband/driver.h> not found.  libmlx4 requires libibverbs.]))
diff --git a/src/mlx4-ext.c b/src/mlx4-ext.c
new file mode 100644
index 0000000..7734720
--- /dev/null
+++ b/src/mlx4-ext.c
@@ -0,0 +1,70 @@
+/*
+ * Copyright (c) 2011 Intel Corp., Inc.  All rights reserved.
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
+#if HAVE_CONFIG_H
+#  include <config.h>
+#endif /* HAVE_CONFIG_H */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <errno.h>
+#include <pthread.h>
+#include <string.h>
+
+#include "mlx4.h"
+#include "mlx4-abi.h"
+#include "mlx4-ext.h"
+
+int mlx4_have_ext_ops(struct ibv_device *device, const char *ext_name)
+{
+	if (!stricmp(ext_name, "ibv_xrc"))
+		return 0;
+
+	return ENOSYS;
+}
+
+void mlx4_device_config_ext(struct ibv_device *device)
+{
+	device->have_ext_ops = mlx4_have_ext_ops;
+	device->get_device_ext_ops = NULL;
+}
+
+static void *mlx4_get_ext_ops(struct ibv_context *context, const char *ext_name)
+{
+	return NULL;
+}
+
+void mlx4_context_config_ext(struct ibv_context *ibv_ctx)
+{
+	ibv_ctx->get_ext_ops = mlx4_get_ext_ops;
+}
diff --git a/src/mlx4-ext.h b/src/mlx4-ext.h
new file mode 100644
index 0000000..a91d6ba
--- /dev/null
+++ b/src/mlx4-ext.h
@@ -0,0 +1,52 @@
+/*
+ * Copyright (c) 2011 Intel Corp., Inc.  All rights reserved.
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
+#ifndef MLX4_EXT_H
+#define MLX4_EXT_H
+
+#include <infiniband/driver.h>
+#include <infiniband/verbs.h>
+
+#ifdef HAVE_IBV_EXT
+#define IBV_REGISTER_DRIVER_EXT ibv_register_driver_ext
+
+int mlx4_have_ext_ops(struct ibv_device *device, const char *ext_name);
+void mlx4_device_config_ext(struct ibv_device *device);
+void mlx4_context_config_ext(struct ibv_context *context);
+
+#else /* HAVE_IBV_EXT */
+#define IBV_REGISTER_DRIVER_EXT ibv_register_driver
+#define mlx4_device_config_ext(x)
+#define mlx4_context_config_ext(x)
+#endif
+
+#endif /* MLX4_EXT_H */
diff --git a/src/mlx4.c b/src/mlx4.c
index 1295c53..2a091a1 100644
--- a/src/mlx4.c
+++ b/src/mlx4.c
@@ -48,6 +48,7 @@
 
 #include "mlx4.h"
 #include "mlx4-abi.h"
+#include "mlx4-ext.h"
 
 #ifndef PCI_VENDOR_ID_MELLANOX
 #define PCI_VENDOR_ID_MELLANOX			0x15b3
@@ -155,6 +156,7 @@ static struct ibv_context *mlx4_alloc_context(struct ibv_device *ibdev, int cmd_
 	pthread_spin_init(&context->uar_lock, PTHREAD_PROCESS_PRIVATE);
 
 	context->ibv_ctx.ops = mlx4_ctx_ops;
+	mlx4_context_config_ext(&context->ibv_ctx);
 
 	return &context->ibv_ctx;
 
@@ -222,6 +224,7 @@ found:
 	}
 
 	dev->ibv_dev.ops = mlx4_dev_ops;
+	mlx4_device_config_ext(&dev->ibv_dev);
 	dev->page_size   = sysconf(_SC_PAGESIZE);
 
 	return &dev->ibv_dev;
@@ -230,8 +233,9 @@ found:
 #ifdef HAVE_IBV_REGISTER_DRIVER
 static __attribute__((constructor)) void mlx4_register_driver(void)
 {
-	ibv_register_driver("mlx4", mlx4_driver_init);
+	IBV_REGISTER_DRIVER_EXT("mlx4", mlx4_driver_init);
 }
+
 #else
 /*
  * Export the old libsysfs sysfs_class_device-based driver entry point


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
