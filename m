From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next 1/8] rdma: Update uapi headers to add statistic counter support
Date: Wed, 10 Apr 2019 14:21:14 +0300
Message-ID: <20190410112121.6790-2-leon@kernel.org>
References: <20190410112121.6790-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190410112121.6790-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, Mark Zhang <markz@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

Update rdma_netlink.h for statistic counter support, which allows
a user to monitor specific QPs categories.

Signed-off-by: Mark Zhang <markz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/include/uapi/rdma/rdma_netlink.h | 82 +++++++++++++++++++++++----
 1 file changed, 70 insertions(+), 12 deletions(-)

diff --git a/rdma/include/uapi/rdma/rdma_netlink.h b/rdma/include/uapi/rdma/rdma_netlink.h
index 23a90ad5..44d9f35b 100644
--- a/rdma/include/uapi/rdma/rdma_netlink.h
+++ b/rdma/include/uapi/rdma/rdma_netlink.h
@@ -49,17 +49,6 @@ enum {
 	RDMA_NL_IWPM_NUM_OPS
 };
 
-struct rdma_cm_id_stats {
-	__u32	qp_num;
-	__u32	bound_dev_if;
-	__u32	port_space;
-	__s32	pid;
-	__u8	cm_state;
-	__u8	node_type;
-	__u8	port_num;
-	__u8	qp_type;
-};
-
 enum {
 	IWPM_NLA_REG_PID_UNSPEC = 0,
 	IWPM_NLA_REG_PID_SEQ,
@@ -261,7 +250,10 @@ enum rdma_nldev_command {
 
 	RDMA_NLDEV_CMD_PORT_GET, /* can dump */
 
-	/* 6 - 8 are free to use */
+	RDMA_NLDEV_CMD_SYS_GET, /* can dump */
+	RDMA_NLDEV_CMD_SYS_SET,
+
+	/* 8 is free to use */
 
 	RDMA_NLDEV_CMD_RES_GET = 9, /* can dump */
 
@@ -275,6 +267,12 @@ enum rdma_nldev_command {
 
 	RDMA_NLDEV_CMD_RES_PD_GET, /* can dump */
 
+	RDMA_NLDEV_CMD_STAT_SET,
+
+	RDMA_NLDEV_CMD_STAT_GET, /* can dump */
+
+	RDMA_NLDEV_CMD_STAT_DEL,
+
 	RDMA_NLDEV_NUM_OPS
 };
 
@@ -472,9 +470,69 @@ enum rdma_nldev_attr {
 	 */
 	RDMA_NLDEV_ATTR_LINK_TYPE,		/* string */
 
+	/*
+	 * net namespace mode for rdma subsystem:
+	 * either shared or exclusive among multiple net namespaces.
+	 */
+	RDMA_NLDEV_SYS_ATTR_NETNS_MODE,		/* u8 */
+	/*
+	 * File descriptor handle of the net namespace object
+	 */
+	RDMA_NLDEV_NET_NS_FD,			/* u32 */
+
+	/*
+	 * Device protocol, e.g. ib, iw, usnic, roce and opa
+	 */
+	RDMA_NLDEV_ATTR_DEV_PROTOCOL,		/* string */
+	/*
+	 * Counter-specific attributes.
+	 */
+	RDMA_NLDEV_ATTR_STAT_MODE,		/* u32 */
+	RDMA_NLDEV_ATTR_STAT_RES,		/* u32 */
+	RDMA_NLDEV_ATTR_STAT_AUTO_MODE_MASK,	/* u32 */
+	RDMA_NLDEV_ATTR_STAT_COUNTER,		/* nested table */
+	RDMA_NLDEV_ATTR_STAT_COUNTER_ENTRY,	/* nested table */
+	RDMA_NLDEV_ATTR_STAT_COUNTER_ID,	/* u32 */
+	RDMA_NLDEV_ATTR_STAT_HWCOUNTERS,	/* nested table */
+	RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY,	/* nested table */
+	RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_NAME,	/* string */
+	RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_VALUE,	/* u64 */
 	/*
 	 * Always the end
 	 */
 	RDMA_NLDEV_ATTR_MAX
 };
+
+/*
+ * Supported counter bind modes. All modes are mutual-exclusive.
+ */
+enum rdma_nl_counter_mode {
+	RDMA_COUNTER_MODE_NONE,
+
+	/*
+	 * A qp is bound with a counter automatically during initialization
+	 * based on the auto mode (e.g., qp type, ...)
+	 */
+	RDMA_COUNTER_MODE_AUTO,
+
+	/*
+	 * Which qp are bound with which counter is explicitly specified
+	 * by the user
+	 */
+	RDMA_COUNTER_MODE_MANUAL,
+
+	/*
+	 * Always the end
+	 */
+	RDMA_COUNTER_MODE_MAX,
+};
+
+/*
+ * Supported criteria in counter auto mode.
+ * Currently only "qp type" is supported
+ */
+enum rdma_nl_counter_mask {
+	RDMA_COUNTER_MASK_QP_TYPE = 1,
+};
+
 #endif /* _RDMA_NETLINK_H */
-- 
2.20.1
