From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 2/4] Move rdma_netlink compat into CMake
Date: Thu, 27 Oct 2016 17:06:08 -0600
Message-ID: <1477609570-8087-3-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1477609570-8087-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477609570-8087-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Detect if the distro's rdma_netlink.h is new enough, if not replace
it with the built in copy, and eliminate the two loose copies of the
header.

The built in copy is from v4.8

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 buildlib/RDMA_LinuxHeaders.cmake           |   2 +-
 buildlib/fixup-include/rdma-rdma_netlink.h | 225 +++++++++++++++++++++++++++++
 ibacm/src/acm.c                            |   3 -
 ibacm/src/acm_netlink.h                    | 128 ----------------
 iwpmd/iwarp_pm.h                           |   2 +-
 iwpmd/iwarp_pm_common.c                    |   5 -
 iwpmd/iwarp_pm_server.c                    |   4 +-
 iwpmd/iwpm_netlink.h                       | 214 ---------------------------
 8 files changed, 229 insertions(+), 354 deletions(-)
 create mode 100644 buildlib/fixup-include/rdma-rdma_netlink.h
 delete mode 100644 ibacm/src/acm_netlink.h
 delete mode 100644 iwpmd/iwpm_netlink.h

Steve,

Can you check if the changes to iwpmd/iwarp_pm_server.c make sense?
Should we do something to fix the kernel header?

diff --git a/buildlib/RDMA_LinuxHeaders.cmake b/buildlib/RDMA_LinuxHeaders.cmake
index bd16d8deca72..c67b0a6113d2 100644
--- a/buildlib/RDMA_LinuxHeaders.cmake
+++ b/buildlib/RDMA_LinuxHeaders.cmake
@@ -80,6 +80,6 @@ rdma_check_kheader("rdma/ib_user_verbs.h" "${DEFAULT_TEST}")
 rdma_check_kheader("rdma/ib_user_sa.h" "${DEFAULT_TEST}")
 rdma_check_kheader("rdma/ib_user_cm.h" "${DEFAULT_TEST}")
 rdma_check_kheader("rdma/ib_user_mad.h" "${DEFAULT_TEST}")
-rdma_check_kheader("rdma/rdma_netlink.h" "${DEFAULT_TEST}")
+rdma_check_kheader("rdma/rdma_netlink.h" "int main(int argc,const char *argv[]) { return RDMA_NL_IWPM_REMOTE_INFO && RDMA_NL_IWCM; }")
 rdma_check_kheader("rdma/rdma_user_cm.h" "${DEFAULT_TEST}")
 rdma_check_kheader("rdma/rdma_user_rxe.h" "${DEFAULT_TEST}")
diff --git a/buildlib/fixup-include/rdma-rdma_netlink.h b/buildlib/fixup-include/rdma-rdma_netlink.h
new file mode 100644
index 000000000000..02fe8390c18f
--- /dev/null
+++ b/buildlib/fixup-include/rdma-rdma_netlink.h
@@ -0,0 +1,225 @@
+#ifndef _UAPI_RDMA_NETLINK_H
+#define _UAPI_RDMA_NETLINK_H
+
+#include <linux/types.h>
+
+enum {
+	RDMA_NL_RDMA_CM = 1,
+	RDMA_NL_IWCM,
+	RDMA_NL_RSVD,
+	RDMA_NL_LS,	/* RDMA Local Services */
+	RDMA_NL_I40IW,
+	RDMA_NL_NUM_CLIENTS
+};
+
+enum {
+	RDMA_NL_GROUP_CM = 1,
+	RDMA_NL_GROUP_IWPM,
+	RDMA_NL_GROUP_LS,
+	RDMA_NL_NUM_GROUPS
+};
+
+#define RDMA_NL_GET_CLIENT(type) ((type & (((1 << 6) - 1) << 10)) >> 10)
+#define RDMA_NL_GET_OP(type) (type & ((1 << 10) - 1))
+#define RDMA_NL_GET_TYPE(client, op) ((client << 10) + op)
+
+enum {
+	RDMA_NL_RDMA_CM_ID_STATS = 0,
+	RDMA_NL_RDMA_CM_NUM_OPS
+};
+
+enum {
+	RDMA_NL_RDMA_CM_ATTR_SRC_ADDR = 1,
+	RDMA_NL_RDMA_CM_ATTR_DST_ADDR,
+	RDMA_NL_RDMA_CM_NUM_ATTR,
+};
+
+/* iwarp port mapper op-codes */
+enum {
+	RDMA_NL_IWPM_REG_PID = 0,
+	RDMA_NL_IWPM_ADD_MAPPING,
+	RDMA_NL_IWPM_QUERY_MAPPING,
+	RDMA_NL_IWPM_REMOVE_MAPPING,
+	RDMA_NL_IWPM_REMOTE_INFO,
+	RDMA_NL_IWPM_HANDLE_ERR,
+	RDMA_NL_IWPM_MAPINFO,
+	RDMA_NL_IWPM_MAPINFO_NUM,
+	RDMA_NL_IWPM_NUM_OPS
+};
+
+struct rdma_cm_id_stats {
+	__u32	qp_num;
+	__u32	bound_dev_if;
+	__u32	port_space;
+	__s32	pid;
+	__u8	cm_state;
+	__u8	node_type;
+	__u8	port_num;
+	__u8	qp_type;
+};
+
+enum {
+	IWPM_NLA_REG_PID_UNSPEC = 0,
+	IWPM_NLA_REG_PID_SEQ,
+	IWPM_NLA_REG_IF_NAME,
+	IWPM_NLA_REG_IBDEV_NAME,
+	IWPM_NLA_REG_ULIB_NAME,
+	IWPM_NLA_REG_PID_MAX
+};
+
+enum {
+	IWPM_NLA_RREG_PID_UNSPEC = 0,
+	IWPM_NLA_RREG_PID_SEQ,
+	IWPM_NLA_RREG_IBDEV_NAME,
+	IWPM_NLA_RREG_ULIB_NAME,
+	IWPM_NLA_RREG_ULIB_VER,
+	IWPM_NLA_RREG_PID_ERR,
+	IWPM_NLA_RREG_PID_MAX
+
+};
+
+enum {
+	IWPM_NLA_MANAGE_MAPPING_UNSPEC = 0,
+	IWPM_NLA_MANAGE_MAPPING_SEQ,
+	IWPM_NLA_MANAGE_ADDR,
+	IWPM_NLA_MANAGE_MAPPED_LOC_ADDR,
+	IWPM_NLA_RMANAGE_MAPPING_ERR,
+	IWPM_NLA_RMANAGE_MAPPING_MAX
+};
+
+#define IWPM_NLA_MANAGE_MAPPING_MAX 3
+#define IWPM_NLA_QUERY_MAPPING_MAX  4
+#define IWPM_NLA_MAPINFO_SEND_MAX   3
+
+enum {
+	IWPM_NLA_QUERY_MAPPING_UNSPEC = 0,
+	IWPM_NLA_QUERY_MAPPING_SEQ,
+	IWPM_NLA_QUERY_LOCAL_ADDR,
+	IWPM_NLA_QUERY_REMOTE_ADDR,
+	IWPM_NLA_RQUERY_MAPPED_LOC_ADDR,
+	IWPM_NLA_RQUERY_MAPPED_REM_ADDR,
+	IWPM_NLA_RQUERY_MAPPING_ERR,
+	IWPM_NLA_RQUERY_MAPPING_MAX
+};
+
+enum {
+	IWPM_NLA_MAPINFO_REQ_UNSPEC = 0,
+	IWPM_NLA_MAPINFO_ULIB_NAME,
+	IWPM_NLA_MAPINFO_ULIB_VER,
+	IWPM_NLA_MAPINFO_REQ_MAX
+};
+
+enum {
+	IWPM_NLA_MAPINFO_UNSPEC = 0,
+	IWPM_NLA_MAPINFO_LOCAL_ADDR,
+	IWPM_NLA_MAPINFO_MAPPED_ADDR,
+	IWPM_NLA_MAPINFO_MAX
+};
+
+enum {
+	IWPM_NLA_MAPINFO_NUM_UNSPEC = 0,
+	IWPM_NLA_MAPINFO_SEQ,
+	IWPM_NLA_MAPINFO_SEND_NUM,
+	IWPM_NLA_MAPINFO_ACK_NUM,
+	IWPM_NLA_MAPINFO_NUM_MAX
+};
+
+enum {
+	IWPM_NLA_ERR_UNSPEC = 0,
+	IWPM_NLA_ERR_SEQ,
+	IWPM_NLA_ERR_CODE,
+	IWPM_NLA_ERR_MAX
+};
+
+/*
+ * Local service operations:
+ *   RESOLVE - The client requests the local service to resolve a path.
+ *   SET_TIMEOUT - The local service requests the client to set the timeout.
+ *   IP_RESOLVE - The client requests the local service to resolve an IP to GID.
+ */
+enum {
+	RDMA_NL_LS_OP_RESOLVE = 0,
+	RDMA_NL_LS_OP_SET_TIMEOUT,
+	RDMA_NL_LS_OP_IP_RESOLVE,
+	RDMA_NL_LS_NUM_OPS
+};
+
+/* Local service netlink message flags */
+#define RDMA_NL_LS_F_ERR	0x0100	/* Failed response */
+
+/*
+ * Local service resolve operation family header.
+ * The layout for the resolve operation:
+ *    nlmsg header
+ *    family header
+ *    attributes
+ */
+
+/*
+ * Local service path use:
+ * Specify how the path(s) will be used.
+ *   ALL - For connected CM operation (6 pathrecords)
+ *   UNIDIRECTIONAL - For unidirectional UD (1 pathrecord)
+ *   GMP - For miscellaneous GMP like operation (at least 1 reversible
+ *         pathrecord)
+ */
+enum {
+	LS_RESOLVE_PATH_USE_ALL = 0,
+	LS_RESOLVE_PATH_USE_UNIDIRECTIONAL,
+	LS_RESOLVE_PATH_USE_GMP,
+	LS_RESOLVE_PATH_USE_MAX
+};
+
+#define LS_DEVICE_NAME_MAX 64
+
+struct rdma_ls_resolve_header {
+	__u8 device_name[LS_DEVICE_NAME_MAX];
+	__u8 port_num;
+	__u8 path_use;
+};
+
+struct rdma_ls_ip_resolve_header {
+	__u32 ifindex;
+};
+
+/* Local service attribute type */
+#define RDMA_NLA_F_MANDATORY	(1 << 13)
+#define RDMA_NLA_TYPE_MASK	(~(NLA_F_NESTED | NLA_F_NET_BYTEORDER | \
+				  RDMA_NLA_F_MANDATORY))
+
+/*
+ * Local service attributes:
+ *   Attr Name       Size                       Byte order
+ *   -----------------------------------------------------
+ *   PATH_RECORD     struct ib_path_rec_data
+ *   TIMEOUT         u32                        cpu
+ *   SERVICE_ID      u64                        cpu
+ *   DGID            u8[16]                     BE
+ *   SGID            u8[16]                     BE
+ *   TCLASS          u8
+ *   PKEY            u16                        cpu
+ *   QOS_CLASS       u16                        cpu
+ *   IPV4            u32                        BE
+ *   IPV6            u8[16]                     BE
+ */
+enum {
+	LS_NLA_TYPE_UNSPEC = 0,
+	LS_NLA_TYPE_PATH_RECORD,
+	LS_NLA_TYPE_TIMEOUT,
+	LS_NLA_TYPE_SERVICE_ID,
+	LS_NLA_TYPE_DGID,
+	LS_NLA_TYPE_SGID,
+	LS_NLA_TYPE_TCLASS,
+	LS_NLA_TYPE_PKEY,
+	LS_NLA_TYPE_QOS_CLASS,
+	LS_NLA_TYPE_IPV4,
+	LS_NLA_TYPE_IPV6,
+	LS_NLA_TYPE_MAX
+};
+
+/* Local service DGID/SGID attribute: big endian */
+struct rdma_nla_ls_gid {
+	__u8		gid[16];
+};
+
+#endif /* _UAPI_RDMA_NETLINK_H */
diff --git a/ibacm/src/acm.c b/ibacm/src/acm.c
index cc7dd065f69c..5f4068f619b4 100644
--- a/ibacm/src/acm.c
+++ b/ibacm/src/acm.c
@@ -61,9 +61,6 @@
 #include <ccan/list.h>
 #include "acm_mad.h"
 #include "acm_util.h"
-#if !defined(RDMA_NL_LS_F_ERR)
-	#include "acm_netlink.h"
-#endif
 
 #define src_out     data[0]
 #define src_index   data[1]
diff --git a/ibacm/src/acm_netlink.h b/ibacm/src/acm_netlink.h
deleted file mode 100644
index 867ae8c838fc..000000000000
diff --git a/iwpmd/iwarp_pm.h b/iwpmd/iwarp_pm.h
index b5a5a457a423..fc09e4fd752a 100644
--- a/iwpmd/iwarp_pm.h
+++ b/iwpmd/iwarp_pm.h
@@ -53,7 +53,7 @@
 #include <syslog.h>
 #include <netlink/msg.h>
 #include <ccan/list.h>
-#include "iwpm_netlink.h"
+#include <rdma/rdma_netlink.h>
 
 #define IWARP_PM_PORT          3935
 #define IWARP_PM_VER_SHIFT     6
diff --git a/iwpmd/iwarp_pm_common.c b/iwpmd/iwarp_pm_common.c
index 58b1089a1998..941e0406ade7 100644
--- a/iwpmd/iwarp_pm_common.c
+++ b/iwpmd/iwarp_pm_common.c
@@ -33,11 +33,6 @@
 
 #include "iwarp_pm.h"
 
-/* Necessary only for SLES11 */
-#if !defined (NETLINK_RDMA)
-	#define NETLINK_RDMA	        20
-#endif
-
 /* iwpm config params */
 static const char * iwpm_param_names[IWPM_PARAM_NUM] =
 	{ "nl_sock_rbuf_size" };
diff --git a/iwpmd/iwarp_pm_server.c b/iwpmd/iwarp_pm_server.c
index ab90c6c4b077..ef541c8175ed 100644
--- a/iwpmd/iwarp_pm_server.c
+++ b/iwpmd/iwarp_pm_server.c
@@ -1214,8 +1214,8 @@ static int init_iwpm_clients(__u32 iwarp_clients[])
 {
 	int client_num = 2;
 
-	iwarp_clients[0] = RDMA_NL_NES;
-	iwarp_clients[1] = RDMA_NL_C4IW;
+	iwarp_clients[0] = RDMA_NL_IWCM;
+	iwarp_clients[1] = RDMA_NL_IWCM+1; /* Legacy RDMA_NL_C4IW for old kernels */
 
 	return client_num;
 }
diff --git a/iwpmd/iwpm_netlink.h b/iwpmd/iwpm_netlink.h
deleted file mode 100644
index 0edcb620de99..000000000000
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
