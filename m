From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/4] RDMA/core: Add support for iWARP Port Mapper user space
 service
Date: Sat, 31 Aug 2013 14:43:03 -0500
Message-ID: <20130831194303.GA15920@TENIKOLO-MOBL1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: robert.o.sharp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add netlink support for iWARP Port Mapper (IWPM) user space service:

1) Netlink interface functions are added: ibnl_unicast() and ibnl_mulitcast()
   for sending netlink messages

2) The signature of the existing ibnl_put_msg() is changed to more generic

3) Three netlink clients are added: RDMA_NL_NES, RDMA_NL_C4IW,
   RDMA_NL_GROUP_IWPM 

4) Enums are added to enumerate the attributes in the netlink messages, which
   are exchanged between the user space IWPM service and the iWARP drivers


Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Robert Sharp <robert.o.sharp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/core/cma.c     |  2 +-
 drivers/infiniband/core/netlink.c | 18 +++++++-
 include/rdma/rdma_netlink.h       | 23 +++++++++-
 include/uapi/rdma/rdma_netlink.h  | 94 ++++++++++++++++++++++++++++++++++++++-
 4 files changed, 132 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 3a2c3c3..e1bae73 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -3568,7 +3568,7 @@ static int cma_get_id_stats(struct sk_buff *skb, struct netlink_callback *cb)
 
 			id_stats = ibnl_put_msg(skb, &nlh, cb->nlh->nlmsg_seq,
 						sizeof *id_stats, RDMA_NL_RDMA_CM,
-						RDMA_NL_RDMA_CM_ID_STATS);
+						RDMA_NL_RDMA_CM_ID_STATS, NLM_F_MULTI);
 			if (!id_stats)
 				goto out;
 
diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
index da06abd..e64e10b 100644
--- a/drivers/infiniband/core/netlink.c
+++ b/drivers/infiniband/core/netlink.c
@@ -103,13 +103,13 @@ int ibnl_remove_client(int index)
 EXPORT_SYMBOL(ibnl_remove_client);
 
 void *ibnl_put_msg(struct sk_buff *skb, struct nlmsghdr **nlh, int seq,
-		   int len, int client, int op)
+		   int len, int client, int op, int flags)
 {
 	unsigned char *prev_tail;
 
 	prev_tail = skb_tail_pointer(skb);
 	*nlh = nlmsg_put(skb, 0, seq, RDMA_NL_GET_TYPE(client, op),
-			 len, NLM_F_MULTI);
+			 len, flags);
 	if (!*nlh)
 		goto out_nlmsg_trim;
 	(*nlh)->nlmsg_len = skb_tail_pointer(skb) - prev_tail;
@@ -172,6 +172,20 @@ static void ibnl_rcv(struct sk_buff *skb)
 	mutex_unlock(&ibnl_mutex);
 }
 
+int ibnl_unicast(struct sk_buff *skb, struct nlmsghdr *nlh,
+			__u32 pid)
+{
+	return nlmsg_unicast(nls, skb, pid);
+}
+EXPORT_SYMBOL(ibnl_unicast);
+
+int ibnl_multicast(struct sk_buff *skb, struct nlmsghdr *nlh,
+			unsigned int group, gfp_t flags)
+{
+	return nlmsg_multicast(nls, skb, 0, group, flags);
+}
+EXPORT_SYMBOL(ibnl_multicast);
+
 int __init ibnl_init(void)
 {
 	struct netlink_kernel_cfg cfg = {
diff --git a/include/rdma/rdma_netlink.h b/include/rdma/rdma_netlink.h
index e38de79..0790882 100644
--- a/include/rdma/rdma_netlink.h
+++ b/include/rdma/rdma_netlink.h
@@ -43,7 +43,7 @@ int ibnl_remove_client(int index);
  * Returns the allocated buffer on success and NULL on failure.
  */
 void *ibnl_put_msg(struct sk_buff *skb, struct nlmsghdr **nlh, int seq,
-		   int len, int client, int op);
+		   int len, int client, int op, int flags);
 /**
  * Put a new attribute in a supplied skb.
  * @skb: The netlink skb.
@@ -56,4 +56,25 @@ void *ibnl_put_msg(struct sk_buff *skb, struct nlmsghdr **nlh, int seq,
 int ibnl_put_attr(struct sk_buff *skb, struct nlmsghdr *nlh,
 		  int len, void *data, int type);
 
+/**
+ * Send the supplied skb to a specific userspace PID.
+ * @skb: The netlink skb
+ * @nlh: Header of the netlink message to send
+ * @pid: Userspace netlink process ID
+ * Returns 0 on success or a negative error code.
+ */
+int ibnl_unicast(struct sk_buff *skb, struct nlmsghdr *nlh,
+		__u32 pid);
+
+/**
+ * Send the supplied skb to a netlink group.
+ * @skb: The netlink skb
+ * @nlh: Header of the netlink message to send
+ * @group: Netlink group ID
+ * @flags: allocation flags
+ * Returns 0 on success or a negative error code.
+ */
+int ibnl_multicast(struct sk_buff *skb, struct nlmsghdr *nlh,
+		unsigned int group, gfp_t flags);
+
 #endif /* _RDMA_NETLINK_H */
diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
index 8297285..bcd0a5c 100644
--- a/include/uapi/rdma/rdma_netlink.h
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -4,7 +4,15 @@
 #include <linux/types.h>
 
 enum {
-	RDMA_NL_RDMA_CM = 1
+	RDMA_NL_RDMA_CM = 1,
+	RDMA_NL_NES,
+	RDMA_NL_C4IW
+};
+
+enum {
+	RDMA_NL_GROUP_CM = 1,
+	RDMA_NL_GROUP_IWPM,
+	RDMA_NL_NUM_GROUPS
 };
 
 #define RDMA_NL_GET_CLIENT(type) ((type & (((1 << 6) - 1) << 10)) >> 10)
@@ -22,6 +30,18 @@ enum {
 	RDMA_NL_RDMA_CM_NUM_ATTR,
 };
 
+/* iwarp port mapper op-codes */
+enum {
+	RDMA_NL_IWPM_REG_PID = 0,
+	RDMA_NL_IWPM_ADD_MAPPING,
+	RDMA_NL_IWPM_QUERY_MAPPING,
+	RDMA_NL_IWPM_REMOVE_MAPPING,
+	RDMA_NL_IWPM_HANDLE_ERR,
+	RDMA_NL_IWPM_MAP_INFO,
+	RDMA_NL_IWPM_MAP_INFO_NUM,
+	RDMA_NL_IWPM_NUM_OPS
+};
+
 struct rdma_cm_id_stats {
 	__u32	qp_num;
 	__u32	bound_dev_if;
@@ -33,5 +53,77 @@ struct rdma_cm_id_stats {
 	__u8	qp_type;
 };
 
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
+#define IWPM_NLA_MANAGE_MAPPING_MAX    3
+#define IWPM_NLA_REPORT_MAPPING_MAX    4
+#define IWPM_NLA_QUERY_MAPPING_MAX     4
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
+	IWPM_NLA_MAPINFO_COUNT_UNSPEC = 0,
+	IWPM_NLA_MAPINFO_SEQ,
+	IWPM_NLA_MAPINFO_NUMBER,
+	IWPM_NLA_MAPINFO_COUNT_MAX
+};
+
+enum {
+	IWPM_NLA_ERR_UNSPEC = 0,
+	IWPM_NLA_ERR_SEQ,
+	IWPM_NLA_ERR_CODE,
+	IWPM_NLA_ERR_MAX
+};
+
 
 #endif /* _UAPI_RDMA_NETLINK_H */
-- 
1.8.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
