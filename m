From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v2] libibumad: add new registration ioctl
Date: Mon, 26 May 2014 22:46:03 -0400
Message-ID: <1401158763-1736-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This supports the new registration ioctl which the kernel is exporting.
Specifically this adds flags to the registration operation.  The first such
flag is to request user space RMPP.  Thus turning off kernel based RMPP
coalescing.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Changes from V1:
	1) update man page
	2) convert oui to 32 bits and host byte order
	3) Pad Kernel struct out to 64 bits for easier 32/64bit compatibility
	4) update trace/debug messages
	5) remove struct version from API (will use symbol versions if future
	   versions are needed.)
	6) If the kernel does not support the new ioctl and no flags are
	   specified automatically use the old ioctl to perform the
	   registration.  Otherwise indicate that no flags are supported as per
	   the man page.
---
 Makefile.am               |   1 +
 include/infiniband/umad.h |  18 ++++++++
 man/umad_register2.3      |  76 ++++++++++++++++++++++++++++++++++
 src/libibumad.map         |   1 +
 src/umad.c                | 102 ++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 198 insertions(+)
 create mode 100644 man/umad_register2.3

diff --git a/Makefile.am b/Makefile.am
index 24b5dd8..a15ac2d 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -16,6 +16,7 @@ man_MANS = man/umad_debug.3 man/umad_get_ca.3 \
 	   man/umad_set_addr_net.3 man/umad_set_addr.3 man/umad_set_pkey.3 \
 	   man/umad_get_pkey.3 \
 	   man/umad_register.3 man/umad_register_oui.3 man/umad_unregister.3 \
+	   man/umad_register2.3 \
 	   man/umad_send.3 man/umad_recv.3 man/umad_poll.3 \
 	   man/umad_get_issm_path.3 \
 	   man/umad_attribute_str.3 \
diff --git a/include/infiniband/umad.h b/include/infiniband/umad.h
index 6af30c0..ca649e3 100644
--- a/include/infiniband/umad.h
+++ b/include/infiniband/umad.h
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire Inc.  All rights reserved.
+ * Copyright (c) 2014 Intel Corporation.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -90,6 +91,8 @@ typedef struct ib_user_mad {
 					      struct ib_user_mad_reg_req)
 #define IB_USER_MAD_UNREGISTER_AGENT	_IOW(IB_IOCTL_MAGIC, 2, uint32_t)
 #define IB_USER_MAD_ENABLE_PKEY		_IO(IB_IOCTL_MAGIC, 3)
+#define IB_USER_MAD_REGISTER_AGENT2     _IOWR(IB_IOCTL_MAGIC, 4, \
+					      struct ib_user_mad_reg_req2)
 
 #define UMAD_CA_NAME_LEN	20
 #define UMAD_CA_MAX_PORTS	10	/* 0 - 9 */
@@ -196,6 +199,21 @@ int umad_register_oui(int portid, int mgmt_class, uint8_t rmpp_version,
 		      uint8_t oui[3], long method_mask[16 / sizeof(long)]);
 int umad_unregister(int portid, int agentid);
 
+enum {
+	UMAD_USER_RMPP = (1 << 0)
+} umad_reg_flags;
+struct umad_reg_attr {
+	uint8_t    mgmt_class;
+	uint8_t    mgmt_class_version;
+	uint32_t   flags;
+	uint64_t   method_mask[2];
+	uint32_t   oui;
+	uint8_t    rmpp_version;
+};
+int umad_register2(int port_fd, struct umad_reg_attr *attr,
+		   uint32_t *agent_id);
+
+
 int umad_debug(int level);
 void umad_addr_dump(ib_mad_addr_t * addr);
 void umad_dump(void *umad);
diff --git a/man/umad_register2.3 b/man/umad_register2.3
new file mode 100644
index 0000000..1940489
--- /dev/null
+++ b/man/umad_register2.3
@@ -0,0 +1,76 @@
+.\" -*- nroff -*-
+.\"
+.TH UMAD_REGISTER2 3  "March 25, 2014" "OpenIB" "OpenIB Programmer\'s Manual"
+.SH "NAME"
+umad_register2 \- register the specified management class and version for port
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/umad.h>
+.sp
+.BI "int umad_register2(int " "port_fd" ", struct umad_reg_attr *" "attr" ", uint32_t *" "agent_id");
+.fi
+.SH "DESCRIPTION"
+.B umad_register2()
+registers for a MAD agent using the provided registration attributes
+
+.I port_fd\fR
+the port on which to register the agent
+
+.I attr\fR
+The registration attributes as defined by the structure passed.  See below for details of this structure.  Future structures may be defined.
+
+.I agent_id\fR
+returned on success.  agent_id identifies the kernel MAD agent a MAD is received by or to be sent by.  agent_id is returned in the umad header "struct ib_user_mad" on recv and specified in umad_send when sending.
+
+
+.SH "REGISTRATION ATTRIBUTE STRUCTURE VERSION 0"
+.nf
+struct umad_reg_attr {
+.in +8
+uint16_t   struct_version;
+uint8_t    mgmt_class;
+uint8_t    mgmt_class_version;
+uint32_t   flags;
+uint64_t   method_mask[2];
+uint8_t    oui[3];    /* network order */
+uint8_t    rmpp_version;
+.in -8
+};
+
+.I struct_version\fR
+Version of the attribute structure being passed.  Set to '0'
+
+.I mgmt_class\fR
+Management class to register for.
+
+.I mgmt_class_version\fR
+Management class version to register for.
+
+.I flags\fR
+Registration flags.  If a flag specified is not supported by the kernel, the supported flags are returned in this field.
+
+.P
+Current flags are.
+.in +8
+UMAD_USER_RMPP -- flag to indicate the kernel should not process RMPP packets.  All RMPP packets will be treated like individual MAD's.  The user is responsible for implementing the RMPP protocol.
+.in -8
+
+.I method_mask\fR
+A bit mask which indicates which unsolicited methods this agent should receive.  Setting this array to 0 will result in the agent only receiving response MAD's for which a request was sent.
+
+.I oui\fR
+The oui to use for vendor classes 0x30 - 0x4f.  Otherwise ignored.
+
+.I rmpp_version\fR
+If the class supports RMPP and kernel RMPP is enabled (the default) indicate which rmpp_version to use.
+
+
+.SH "RETURN VALUE"
+.B umad_register2()
+returns 0 on success and +ERRNO on failure.
+
+.SH "SEE ALSO"
+.BR umad_unregister (3)
+.SH "AUTHOR"
+.TP
+Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
diff --git a/src/libibumad.map b/src/libibumad.map
index eeb9d83..e42dc79 100644
--- a/src/libibumad.map
+++ b/src/libibumad.map
@@ -23,6 +23,7 @@ IBUMAD_1.0 {
 		umad_poll;
 		umad_get_fd;
 		umad_register;
+		umad_register2;
 		umad_register_oui;
 		umad_unregister;
 		umad_status;
diff --git a/src/umad.c b/src/umad.c
index 5dd7f09..f2dce07 100644
--- a/src/umad.c
+++ b/src/umad.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire Inc.  All rights reserved.
+ * Copyright (c) 2014 Intel Corporation.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -47,6 +48,7 @@
 #include <netinet/in.h>
 #include <dirent.h>
 #include <ctype.h>
+#include <inttypes.h>
 
 #include "umad.h"
 
@@ -76,6 +78,19 @@ typedef struct ib_user_mad_reg_req {
 	uint8_t rmpp_version;
 } ib_user_mad_reg_req_t;
 
+struct ib_user_mad_reg_req2 {
+	uint32_t id;
+	uint32_t qpn;
+	uint8_t  mgmt_class;
+	uint8_t  mgmt_class_version;
+	uint16_t res;
+	uint32_t flags;
+	uint64_t method_mask[2];
+	uint32_t oui;
+	uint8_t  rmpp_version;
+	uint8_t  reserved[3];
+};
+
 extern int sys_read_string(const char *dir_name, const char *file_name, char *str, int len);
 extern int sys_read_guid(const char *dir_name, const char *file_name, uint64_t * net_guid);
 extern int sys_read_gid(const char *dir_name, const char *file_name, uint8_t * gid);
@@ -973,6 +988,93 @@ int umad_register(int fd, int mgmt_class, int mgmt_version,
 	return -EPERM;
 }
 
+int umad_register2(int port_fd, struct umad_reg_attr *attr, uint32_t *agent_id)
+{
+	struct ib_user_mad_reg_req2 req;
+	int rc;
+
+	if (!attr || !agent_id)
+		return EINVAL;
+
+	TRACE("fd %d mgmt_class %u mgmt_class_version %u flags 0x%08x "
+	      "method_mask 0x%016"PRIx64" %016"PRIx64
+	      "oui 0x%06x rmpp_version %u ",
+	      port_fd, attr->mgmt_class, attr->mgmt_class_version,
+	      attr->flags, attr->method_mask[0], attr->method_mask[1],
+	      attr->oui, attr->rmpp_version);
+
+	if (attr->mgmt_class >= 0x30 && attr->mgmt_class <= 0x4f
+	    && ((attr->oui & 0x00FFFFFF) == 0 || (attr->oui & 0xff000000) != 0)) {
+		DEBUG("mgmt class %d is in vendor range 2 but oui (0x%08x) is invalid",
+			attr->mgmt_class, attr->oui);
+		return EINVAL;
+	}
+
+	memset(&req, 0, sizeof (req));
+
+	req.mgmt_class = attr->mgmt_class;
+	req.mgmt_class_version = attr->mgmt_class_version;
+	req.qpn = (attr->mgmt_class == 0x1 || attr->mgmt_class == 0x81) ? 0 : 1;
+	req.flags = attr->flags;
+	memcpy(req.method_mask, attr->method_mask, sizeof req.method_mask);
+	req.oui = attr->oui;
+	req.rmpp_version = attr->rmpp_version;
+
+	VALGRIND_MAKE_MEM_DEFINED(&req, sizeof req);
+
+	if ((rc = ioctl(port_fd, IB_USER_MAD_REGISTER_AGENT2, (void *)&req))
+	     == 0) {
+		DEBUG
+		    ("fd %d registered to use agent %d qp %d class 0x%x oui 0x%06x",
+		     port_fd, req.id, req.qpn, req.mgmt_class, attr->oui);
+		*agent_id = req.id;
+		return 0;
+	}
+
+	if (errno == ENOTTY) {
+
+		TRACE("no kernel support for registration flags\n");
+		req.flags = 0;
+
+		if (attr->flags == 0) {
+			struct ib_user_mad_reg_req req_v1;
+
+			TRACE("attempting original register ioctl\n");
+
+			memset(&req_v1, 0, sizeof (req_v1));
+			req_v1.mgmt_class = req.mgmt_class;
+			req_v1.mgmt_class_version = req.mgmt_class_version;
+			req_v1.qpn = req.qpn;
+			req_v1.rmpp_version = req.rmpp_version;
+			req_v1.oui[0] = (req.oui & 0xff0000) >> 16;
+			req_v1.oui[1] = (req.oui & 0x00ff00) >> 8;
+			req_v1.oui[2] =  req.oui & 0x0000ff;
+			req_v1.method_mask[0] =  (req.method_mask[0] & 0x00000000ffffffffULL);
+			req_v1.method_mask[1] =  (req.method_mask[0] & 0xffffffff00000000ULL) >> 32;
+			req_v1.method_mask[2] =  (req.method_mask[1] & 0x00000000ffffffffULL);
+			req_v1.method_mask[3] =  (req.method_mask[1] & 0xffffffff00000000ULL) >> 32;
+
+			if ((rc = ioctl(port_fd, IB_USER_MAD_REGISTER_AGENT,
+					(void *)&req_v1)) == 0) {
+				DEBUG("fd %d registered to use agent %d qp %d class 0x%x oui 0x%06x",
+				      port_fd, req_v1.id, req_v1.qpn, req_v1.mgmt_class, attr->oui);
+				*agent_id = req_v1.id;
+				return 0;
+			}
+		}
+	}
+
+	rc = errno;
+	attr->flags = req.flags;
+
+	DEBUG("fd %d registering qp %d class 0x%x version %d "
+	      "oui 0x%06x failed flags returned 0x%x : %m",
+	      port_fd, req.qpn, req.mgmt_class, req.mgmt_class_version,
+	      attr->oui, req.flags);
+
+	return rc;
+}
+
 int umad_unregister(int fd, int agentid)
 {
 	TRACE("fd %d unregistering agent %d", fd, agentid);
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
