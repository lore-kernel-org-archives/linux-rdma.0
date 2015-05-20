From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 13/14] IB/mad: Add partial Intel OPA MAD support
Date: Wed, 20 May 2015 04:13:34 -0400
Message-ID: <1432109615-19564-14-git-send-email-ira.weiny@intel.com>
References: <1432109615-19564-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432109615-19564-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add OPA SMP processing functionality.

Define the new OPA SMP format, create support functions for this format using
the previously defined helper functions as appropriate.

These functions are defined in this patch and used in the final OPA MAD support
patch.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/mad_priv.h |   2 +
 drivers/infiniband/core/opa_smi.h  |  78 +++++++++++++++++++++++++++
 drivers/infiniband/core/smi.c      |  54 +++++++++++++++++++
 include/rdma/opa_smi.h             | 106 +++++++++++++++++++++++++++++++++++++
 4 files changed, 240 insertions(+)
 create mode 100644 drivers/infiniband/core/opa_smi.h
 create mode 100644 include/rdma/opa_smi.h

diff --git a/drivers/infiniband/core/mad_priv.h b/drivers/infiniband/core/mad_priv.h
index b93e9a958725..6e8b02fdcc5f 100644
--- a/drivers/infiniband/core/mad_priv.h
+++ b/drivers/infiniband/core/mad_priv.h
@@ -41,6 +41,7 @@
 #include <linux/workqueue.h>
 #include <rdma/ib_mad.h>
 #include <rdma/ib_smi.h>
+#include <rdma/opa_smi.h>
 
 #define IB_MAD_QPS_CORE		2 /* Always QP0 and QP1 as a minimum */
 
@@ -82,6 +83,7 @@ struct ib_mad_private {
 		struct ib_smp smp;
 		struct opa_mad opa_mad;
 		struct opa_rmpp_mad opa_rmpp_mad;
+		struct opa_smp opa_smp;
 	} mad;
 } __attribute__ ((packed));
 
diff --git a/drivers/infiniband/core/opa_smi.h b/drivers/infiniband/core/opa_smi.h
new file mode 100644
index 000000000000..62d91bfa4cb7
--- /dev/null
+++ b/drivers/infiniband/core/opa_smi.h
@@ -0,0 +1,78 @@
+/*
+ * Copyright (c) 2014 Intel Corporation.  All rights reserved.
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
+#ifndef __OPA_SMI_H_
+#define __OPA_SMI_H_
+
+#include <rdma/ib_smi.h>
+#include <rdma/opa_smi.h>
+
+#include "smi.h"
+
+enum smi_action opa_smi_handle_dr_smp_recv(struct opa_smp *smp, u8 node_type,
+				       int port_num, int phys_port_cnt);
+int opa_smi_get_fwd_port(struct opa_smp *smp);
+extern enum smi_forward_action opa_smi_check_forward_dr_smp(struct opa_smp *smp);
+extern enum smi_action opa_smi_handle_dr_smp_send(struct opa_smp *smp,
+					      u8 node_type, int port_num);
+
+/*
+ * Return IB_SMI_HANDLE if the SMP should be handled by the local SMA/SM
+ * via process_mad
+ */
+static inline enum smi_action opa_smi_check_local_smp(struct opa_smp *smp,
+						      struct ib_device *device)
+{
+	/* C14-9:3 -- We're at the end of the DR segment of path */
+	/* C14-9:4 -- Hop Pointer = Hop Count + 1 -> give to SMA/SM */
+	return (device->process_mad &&
+		!opa_get_smp_direction(smp) &&
+		(smp->hop_ptr == smp->hop_cnt + 1)) ?
+		IB_SMI_HANDLE : IB_SMI_DISCARD;
+}
+
+/*
+ * Return IB_SMI_HANDLE if the SMP should be handled by the local SMA/SM
+ * via process_mad
+ */
+static inline enum smi_action opa_smi_check_local_returning_smp(struct opa_smp *smp,
+								struct ib_device *device)
+{
+	/* C14-13:3 -- We're at the end of the DR segment of path */
+	/* C14-13:4 -- Hop Pointer == 0 -> give to SM */
+	return (device->process_mad &&
+		opa_get_smp_direction(smp) &&
+		!smp->hop_ptr) ? IB_SMI_HANDLE : IB_SMI_DISCARD;
+}
+
+#endif	/* __OPA_SMI_H_ */
diff --git a/drivers/infiniband/core/smi.c b/drivers/infiniband/core/smi.c
index 4969ce3338fb..8ce332207596 100644
--- a/drivers/infiniband/core/smi.c
+++ b/drivers/infiniband/core/smi.c
@@ -5,6 +5,7 @@
  * Copyright (c) 2004, 2005 Topspin Corporation.  All rights reserved.
  * Copyright (c) 2004-2007 Voltaire Corporation.  All rights reserved.
  * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2014 Intel Corporation.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -38,6 +39,7 @@
 
 #include <rdma/ib_smi.h>
 #include "smi.h"
+#include "opa_smi.h"
 
 static inline
 enum smi_action __smi_handle_dr_smp_send(u8 node_type, int port_num,
@@ -137,6 +139,20 @@ enum smi_action smi_handle_dr_smp_send(struct ib_smp *smp,
 					smp->dr_slid == IB_LID_PERMISSIVE);
 }
 
+enum smi_action opa_smi_handle_dr_smp_send(struct opa_smp *smp,
+				       u8 node_type, int port_num)
+{
+	return __smi_handle_dr_smp_send(node_type, port_num,
+					&smp->hop_ptr, smp->hop_cnt,
+					smp->route.dr.initial_path,
+					smp->route.dr.return_path,
+					opa_get_smp_direction(smp),
+					smp->route.dr.dr_dlid ==
+					OPA_LID_PERMISSIVE,
+					smp->route.dr.dr_slid ==
+					OPA_LID_PERMISSIVE);
+}
+
 static inline
 enum smi_action __smi_handle_dr_smp_recv(u8 node_type, int port_num,
 					 int phys_port_cnt,
@@ -236,6 +252,24 @@ enum smi_action smi_handle_dr_smp_recv(struct ib_smp *smp, u8 node_type,
 					smp->dr_slid == IB_LID_PERMISSIVE);
 }
 
+/*
+ * Adjust information for a received SMP
+ * Return IB_SMI_DISCARD if the SMP should be dropped
+ */
+enum smi_action opa_smi_handle_dr_smp_recv(struct opa_smp *smp, u8 node_type,
+					   int port_num, int phys_port_cnt)
+{
+	return __smi_handle_dr_smp_recv(node_type, port_num, phys_port_cnt,
+					&smp->hop_ptr, smp->hop_cnt,
+					smp->route.dr.initial_path,
+					smp->route.dr.return_path,
+					opa_get_smp_direction(smp),
+					smp->route.dr.dr_dlid ==
+					OPA_LID_PERMISSIVE,
+					smp->route.dr.dr_slid ==
+					OPA_LID_PERMISSIVE);
+}
+
 static inline
 enum smi_forward_action __smi_check_forward_dr_smp(u8 hop_ptr, u8 hop_cnt,
 						   u8 direction,
@@ -277,6 +311,16 @@ enum smi_forward_action smi_check_forward_dr_smp(struct ib_smp *smp)
 					  smp->dr_slid != IB_LID_PERMISSIVE);
 }
 
+enum smi_forward_action opa_smi_check_forward_dr_smp(struct opa_smp *smp)
+{
+	return __smi_check_forward_dr_smp(smp->hop_ptr, smp->hop_cnt,
+					  opa_get_smp_direction(smp),
+					  smp->route.dr.dr_dlid ==
+					  OPA_LID_PERMISSIVE,
+					  smp->route.dr.dr_slid ==
+					  OPA_LID_PERMISSIVE);
+}
+
 /*
  * Return the forwarding port number from initial_path for outgoing SMP and
  * from return_path for returning SMP
@@ -286,3 +330,13 @@ int smi_get_fwd_port(struct ib_smp *smp)
 	return (!ib_get_smp_direction(smp) ? smp->initial_path[smp->hop_ptr+1] :
 		smp->return_path[smp->hop_ptr-1]);
 }
+
+/*
+ * Return the forwarding port number from initial_path for outgoing SMP and
+ * from return_path for returning SMP
+ */
+int opa_smi_get_fwd_port(struct opa_smp *smp)
+{
+	return !opa_get_smp_direction(smp) ? smp->route.dr.initial_path[smp->hop_ptr+1] :
+		smp->route.dr.return_path[smp->hop_ptr-1];
+}
diff --git a/include/rdma/opa_smi.h b/include/rdma/opa_smi.h
new file mode 100644
index 000000000000..29063e84c253
--- /dev/null
+++ b/include/rdma/opa_smi.h
@@ -0,0 +1,106 @@
+/*
+ * Copyright (c) 2014 Intel Corporation.  All rights reserved.
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
+#if !defined(OPA_SMI_H)
+#define OPA_SMI_H
+
+#include <rdma/ib_mad.h>
+#include <rdma/ib_smi.h>
+
+#define OPA_SMP_LID_DATA_SIZE			2016
+#define OPA_SMP_DR_DATA_SIZE			1872
+#define OPA_SMP_MAX_PATH_HOPS			64
+
+#define OPA_SMI_CLASS_VERSION			0x80
+
+#define OPA_LID_PERMISSIVE			cpu_to_be32(0xFFFFFFFF)
+
+struct opa_smp {
+	u8	base_version;
+	u8	mgmt_class;
+	u8	class_version;
+	u8	method;
+	__be16	status;
+	u8	hop_ptr;
+	u8	hop_cnt;
+	__be64	tid;
+	__be16	attr_id;
+	__be16	resv;
+	__be32	attr_mod;
+	__be64	mkey;
+	union {
+		struct {
+			uint8_t data[OPA_SMP_LID_DATA_SIZE];
+		} lid;
+		struct {
+			__be32	dr_slid;
+			__be32	dr_dlid;
+			u8	initial_path[OPA_SMP_MAX_PATH_HOPS];
+			u8	return_path[OPA_SMP_MAX_PATH_HOPS];
+			u8	reserved[8];
+			u8	data[OPA_SMP_DR_DATA_SIZE];
+		} dr;
+	} route;
+} __packed;
+
+
+static inline u8
+opa_get_smp_direction(struct opa_smp *smp)
+{
+	return ib_get_smp_direction((struct ib_smp *)smp);
+}
+
+static inline u8 *opa_get_smp_data(struct opa_smp *smp)
+{
+	if (smp->mgmt_class == IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE)
+		return smp->route.dr.data;
+
+	return smp->route.lid.data;
+}
+
+static inline size_t opa_get_smp_data_size(struct opa_smp *smp)
+{
+	if (smp->mgmt_class == IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE)
+		return sizeof(smp->route.dr.data);
+
+	return sizeof(smp->route.lid.data);
+}
+
+static inline size_t opa_get_smp_header_size(struct opa_smp *smp)
+{
+	if (smp->mgmt_class == IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE)
+		return sizeof(*smp) - sizeof(smp->route.dr.data);
+
+	return sizeof(*smp) - sizeof(smp->route.lid.data);
+}
+
+#endif /* OPA_SMI_H */
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
