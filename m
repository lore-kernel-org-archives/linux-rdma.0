From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [rdma-next,V1 3/4] IB/netlink: Add a new local service operation
Date: Wed, 18 May 2016 17:57:25 +0300
Message-ID: <1463583446-30027-4-git-send-email-markb@mellanox.com>
References: <1463583446-30027-1-git-send-email-markb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1463583446-30027-1-git-send-email-markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This commits adds a new RDMA local service operation:
- IP to GID resolution.

The client request would include the ifindex of the outgoing interface
and would place in an attribute (LS_NLA_TYPE_IPV4 or LS_NLA_TYPE_IPV6)
the destnation IP.

The local service would answer with a message that has the attribute:
- LS_NLA_TYPE_DGID - The destination GID.

Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/uapi/rdma/rdma_netlink.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
index 6e373d1..17bbea1 100644
--- a/include/uapi/rdma/rdma_netlink.h
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -135,10 +135,12 @@ enum {
  * Local service operations:
  *   RESOLVE - The client requests the local service to resolve a path.
  *   SET_TIMEOUT - The local service requests the client to set the timeout.
+ *   IP_RESOLVE - The client requests the local servie to resolve an ip to gid.
  */
 enum {
 	RDMA_NL_LS_OP_RESOLVE = 0,
 	RDMA_NL_LS_OP_SET_TIMEOUT,
+	RDMA_NL_LS_OP_IP_RESOLVE,
 	RDMA_NL_LS_NUM_OPS
 };
 
@@ -176,6 +178,10 @@ struct rdma_ls_resolve_header {
 	__u8 path_use;
 };
 
+struct rdma_ls_ip_resolve_header {
+	__u32 ifindex;
+};
+
 /* Local service attribute type */
 #define RDMA_NLA_F_MANDATORY	(1 << 13)
 #define RDMA_NLA_TYPE_MASK	(~(NLA_F_NESTED | NLA_F_NET_BYTEORDER | \
@@ -193,6 +199,8 @@ struct rdma_ls_resolve_header {
  *   TCLASS          u8
  *   PKEY            u16                        cpu
  *   QOS_CLASS       u16                        cpu
+ *   IPV4            u32                        BE
+ *   IPV6            u8[16]                     BE
  */
 enum {
 	LS_NLA_TYPE_UNSPEC = 0,
@@ -204,6 +212,8 @@ enum {
 	LS_NLA_TYPE_TCLASS,
 	LS_NLA_TYPE_PKEY,
 	LS_NLA_TYPE_QOS_CLASS,
+	LS_NLA_TYPE_IPV4,
+	LS_NLA_TYPE_IPV6,
 	LS_NLA_TYPE_MAX
 };
 
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
