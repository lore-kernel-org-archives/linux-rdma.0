From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 01/36] IB/rdmavt: Create module framework and handle
 driver registration
Date: Mon, 28 Dec 2015 12:59:45 -0800
Message-ID: <20151228205825.29850.23290.stgit@scvm10.sc.intel.com>
References: <20151228205612.29850.7328.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151228205612.29850.7328.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch introduces the basics for a new module called rdma_vt. This new
driver is a software implementation of the InfiniBand verbs and aims to
replace the multiple implementations that exist and duplicate each others'
code.

While the call to actually register the device with the IB core happens in
rdma_vt, most of the work is still done in the drivers themselves. This
will be changing in a follow on patch this is just laying the groundwork
for this infrastructure.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Changes since v1:
remove rdmavt specific driver version
move copyright above license text

 MAINTAINERS                           |    6 ++
 drivers/infiniband/Kconfig            |    2 +
 drivers/infiniband/Makefile           |    1 
 drivers/infiniband/sw/Makefile        |    1 
 drivers/infiniband/sw/rdmavt/Kconfig  |    6 ++
 drivers/infiniband/sw/rdmavt/Makefile |   10 ++++
 drivers/infiniband/sw/rdmavt/vt.c     |   83 +++++++++++++++++++++++++++++++++
 drivers/infiniband/sw/rdmavt/vt.h     |   53 +++++++++++++++++++++
 include/rdma/rdma_vt.h                |   70 ++++++++++++++++++++++++++++
 9 files changed, 232 insertions(+), 0 deletions(-)
 create mode 100644 drivers/infiniband/sw/Makefile
 create mode 100644 drivers/infiniband/sw/rdmavt/Kconfig
 create mode 100644 drivers/infiniband/sw/rdmavt/Makefile
 create mode 100644 drivers/infiniband/sw/rdmavt/vt.c
 create mode 100644 drivers/infiniband/sw/rdmavt/vt.h
 create mode 100644 include/rdma/rdma_vt.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 69c8a9c..37fc192 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8880,6 +8880,12 @@ L:	rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org (moderated for non-subscribers)
 S:	Supported
 F:	net/rds/
 
+RDMAVT - RDMA verbs software
+M:	Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+L:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+S:	Supported
+F:	drivers/infiniband/sw/rdmavt
+
 READ-COPY UPDATE (RCU)
 M:	"Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
 M:	Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index aa26f3c..1b00bb8 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -72,4 +72,6 @@ source "drivers/infiniband/ulp/srpt/Kconfig"
 source "drivers/infiniband/ulp/iser/Kconfig"
 source "drivers/infiniband/ulp/isert/Kconfig"
 
+source "drivers/infiniband/sw/rdmavt/Kconfig"
+
 endif # INFINIBAND
diff --git a/drivers/infiniband/Makefile b/drivers/infiniband/Makefile
index dc21836..fad0b44 100644
--- a/drivers/infiniband/Makefile
+++ b/drivers/infiniband/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_INFINIBAND)		+= core/
 obj-$(CONFIG_INFINIBAND)		+= hw/
 obj-$(CONFIG_INFINIBAND)		+= ulp/
+obj-$(CONFIG_INFINIBAND)		+= sw/
diff --git a/drivers/infiniband/sw/Makefile b/drivers/infiniband/sw/Makefile
new file mode 100644
index 0000000..988b6a0
--- /dev/null
+++ b/drivers/infiniband/sw/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_INFINIBAND_RDMAVT)		+= rdmavt/
diff --git a/drivers/infiniband/sw/rdmavt/Kconfig b/drivers/infiniband/sw/rdmavt/Kconfig
new file mode 100644
index 0000000..11aa6a3
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/Kconfig
@@ -0,0 +1,6 @@
+config INFINIBAND_RDMAVT
+	tristate "RDMA verbs transport library"
+	depends on 64BIT
+	default m
+	---help---
+	This is a common software verbs provider for RDMA networks.
diff --git a/drivers/infiniband/sw/rdmavt/Makefile b/drivers/infiniband/sw/rdmavt/Makefile
new file mode 100644
index 0000000..98a664d
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/Makefile
@@ -0,0 +1,10 @@
+#
+# rdmavt driver
+#
+#
+#
+# Called from the kernel module build system.
+#
+obj-$(CONFIG_INFINIBAND_RDMAVT) += rdmavt.o
+
+rdmavt-y := vt.o
diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
new file mode 100644
index 0000000..aa325db
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -0,0 +1,83 @@
+/*
+ * Copyright(c) 2015 Intel Corporation.
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
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
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include "vt.h"
+
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_DESCRIPTION("RDMA Verbs Transport Library");
+
+static int rvt_init(void)
+{
+	/* Do any work needed prior to drivers calling for registration*/
+	return 0;
+}
+module_init(rvt_init);
+
+static void rvt_cleanup(void)
+{
+}
+module_exit(rvt_cleanup);
+
+int rvt_register_device(struct rvt_dev_info *rdi)
+{
+	if (!rdi)
+		return -EINVAL;
+
+	return ib_register_device(&rdi->ibdev, rdi->port_callback);
+}
+EXPORT_SYMBOL(rvt_register_device);
+
+void rvt_unregister_device(struct rvt_dev_info *rdi)
+{
+	if (!rdi)
+		return;
+
+	ib_unregister_device(&rdi->ibdev);
+}
+EXPORT_SYMBOL(rvt_unregister_device);
diff --git a/drivers/infiniband/sw/rdmavt/vt.h b/drivers/infiniband/sw/rdmavt/vt.h
new file mode 100644
index 0000000..0a39448
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/vt.h
@@ -0,0 +1,53 @@
+#ifndef DEF_RDMAVT_H
+#define DEF_RDMAVT_H
+
+/*
+ * Copyright(c) 2015 Intel Corporation.
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
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
+#include <rdma/rdma_vt.h>
+
+#endif          /* DEF_RDMAVT_H */
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
new file mode 100644
index 0000000..0438bf2
--- /dev/null
+++ b/include/rdma/rdma_vt.h
@@ -0,0 +1,70 @@
+#ifndef DEF_RDMA_VT_H
+#define DEF_RDMA_VT_H
+
+/*
+ * Copyright(c) 2015 Intel Corporation.
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
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
+ * Structure that low level drivers will populate in order to register with the
+ * rdmavt layer.
+ */
+
+#include "ib_verbs.h"
+struct rvt_dev_info {
+	struct ib_device ibdev;
+	int (*port_callback)(struct ib_device *, u8, struct kobject *);
+
+	/*
+	 * TODO:
+	 *	need to reflect module parameters that may vary by dev
+	 */
+};
+
+int rvt_register_device(struct rvt_dev_info *rvd);
+void rvt_unregister_device(struct rvt_dev_info *rvd);
+
+#endif          /* DEF_RDMA_VT_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
