From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 12/37] IB/rdmavt: Add address handle stubs
Date: Mon, 07 Dec 2015 15:43:50 -0500
Message-ID: <20151207204349.8144.782.stgit@phlsvslse11.ph.intel.com>
References: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151207204046.8144.18752.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Adds the stubs for create, destroy, modify, and query of the
address handle.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/Makefile |    3 -
 drivers/infiniband/sw/rdmavt/ah.c     |   79 +++++++++++++++++++++++++++++++++
 drivers/infiniband/sw/rdmavt/ah.h     |   62 ++++++++++++++++++++++++++
 drivers/infiniband/sw/rdmavt/vt.c     |    6 +++
 drivers/infiniband/sw/rdmavt/vt.h     |    1 
 5 files changed, 149 insertions(+), 2 deletions(-)
 create mode 100644 drivers/infiniband/sw/rdmavt/ah.c
 create mode 100644 drivers/infiniband/sw/rdmavt/ah.h

diff --git a/drivers/infiniband/sw/rdmavt/Makefile b/drivers/infiniband/sw/rdmavt/Makefile
index 9a9a095..628c684 100644
--- a/drivers/infiniband/sw/rdmavt/Makefile
+++ b/drivers/infiniband/sw/rdmavt/Makefile
@@ -7,5 +7,4 @@
 #
 obj-$(CONFIG_INFINIBAND_RDMAVT) += rdmavt.o
 
-rdmavt-y := vt.o dma.o pd.o qp.o
-
+rdmavt-y := vt.o ah.o dma.o pd.o qp.o
diff --git a/drivers/infiniband/sw/rdmavt/ah.c b/drivers/infiniband/sw/rdmavt/ah.c
new file mode 100644
index 0000000..f269a98
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/ah.c
@@ -0,0 +1,79 @@
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
+#include "ah.h"
+
+/**
+ * rvt_create_ah - create an address handle
+ * @pd: the protection domain
+ * @ah_attr: the attributes of the AH
+ *
+ * This may be called from interrupt context.
+ */
+struct ib_ah *rvt_create_ah(struct ib_pd *pd,
+			    struct ib_ah_attr *ah_attr)
+{
+	return ERR_PTR(-EINVAL);
+}
+
+int rvt_destroy_ah(struct ib_ah *ibah)
+{
+	return -EINVAL;
+}
+
+int rvt_modify_ah(struct ib_ah *ibah, struct ib_ah_attr *ah_attr)
+{
+	return -EINVAL;
+}
+
+int rvt_query_ah(struct ib_ah *ibah, struct ib_ah_attr *ah_attr)
+{
+	return -EINVAL;
+}
diff --git a/drivers/infiniband/sw/rdmavt/ah.h b/drivers/infiniband/sw/rdmavt/ah.h
new file mode 100644
index 0000000..bf6bb07
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/ah.h
@@ -0,0 +1,62 @@
+#ifndef DEF_RVTAH_H
+#define DEF_RVTAH_H
+
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
+#include <rdma/rdma_vt.h>
+
+struct ib_ah *rvt_create_ah(struct ib_pd *pd,
+			    struct ib_ah_attr *ah_attr);
+int rvt_destroy_ah(struct ib_ah *ibah);
+int rvt_modify_ah(struct ib_ah *ibah, struct ib_ah_attr *ah_attr);
+int rvt_query_ah(struct ib_ah *ibah, struct ib_ah_attr *ah_attr);
+
+#endif          /* DEF_RVTAH_H */
diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index 58732b4..f750178 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -232,6 +232,12 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 	CDR(rdi, destroy_qp);
 	CDR(rdi, query_qp);
 
+	/* Address Handle */
+	CDR(rdi, create_ah);
+	CDR(rdi, destroy_ah);
+	CDR(rdi, modify_ah);
+	CDR(rdi, query_ah);
+
 	/* DMA Operations */
 	rdi->ibdev.dma_ops =
 		rdi->ibdev.dma_ops ? : &rvt_default_dma_mapping_ops;
diff --git a/drivers/infiniband/sw/rdmavt/vt.h b/drivers/infiniband/sw/rdmavt/vt.h
index 317e187..af1df1b 100644
--- a/drivers/infiniband/sw/rdmavt/vt.h
+++ b/drivers/infiniband/sw/rdmavt/vt.h
@@ -55,5 +55,6 @@
 #include "dma.h"
 #include "pd.h"
 #include "qp.h"
+#include "ah.h"
 
 #endif          /* DEF_RDMAVT_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
