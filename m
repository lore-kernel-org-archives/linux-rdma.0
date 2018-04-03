From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next v1] rdma: Print net device name and index for RDMA device
Date: Tue,  3 Apr 2018 07:29:14 +0300
Message-ID: <20180403042914.23360-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, Steve Wise <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

The RDMA devices are operated in RoCE and iWARP modes have net device
underneath. Present their names in regular output and their net index
in detailed mode.

[root@nps ~]# rdma link show mlx5_3/1
4/1: mlx5_3/1: state ACTIVE physical_state LINK_UP netdev ens7
[root@nps ~]# rdma link show mlx5_3/1 -d
4/1: mlx5_3/1: state ACTIVE physical_state LINK_UP netdev ens7 netdev_index 7
    caps: <CM, IP_BASED_GIDS>

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Steve Wise <swise@opengridcomputing.com>
---
 Changes v0->v1:
  * Resend after commit 29122c1aae35 ("rdma: update rdma_netlink.h")
    which updated relevant netlink attributes.
  * Added Steve's ROB
---
 rdma/include/uapi/rdma/rdma_netlink.h |  4 ++++
 rdma/link.c                           | 21 +++++++++++++++++++++
 rdma/utils.c                          |  2 ++
 3 files changed, 27 insertions(+)

diff --git a/rdma/include/uapi/rdma/rdma_netlink.h b/rdma/include/uapi/rdma/rdma_netlink.h
index 9446a721..45474f13 100644
--- a/rdma/include/uapi/rdma/rdma_netlink.h
+++ b/rdma/include/uapi/rdma/rdma_netlink.h
@@ -388,6 +388,10 @@ enum rdma_nldev_attr {
 	RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY,	/* u32 */
 	RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY,	/* u32 */

+	/* Netdev information for relevant protocols, like RoCE and iWARP */
+	RDMA_NLDEV_ATTR_NDEV_INDEX,		/* u32 */
+	RDMA_NLDEV_ATTR_NDEV_NAME,		/* string */
+
 	RDMA_NLDEV_ATTR_MAX
 };
 #endif /* _RDMA_NETLINK_H */
diff --git a/rdma/link.c b/rdma/link.c
index 66bcd50e..7e914c87 100644
--- a/rdma/link.c
+++ b/rdma/link.c
@@ -205,6 +205,26 @@ static void link_print_phys_state(struct rd *rd, struct nlattr **tb)
 		pr_out("physical_state %s ", phys_state_to_str(phys_state));
 }

+static void link_print_netdev(struct rd *rd, struct nlattr **tb)
+{
+	const char *netdev_name;
+	uint32_t idx;
+
+	if (!tb[RDMA_NLDEV_ATTR_NDEV_NAME] || !tb[RDMA_NLDEV_ATTR_NDEV_INDEX])
+		return;
+
+	netdev_name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_NDEV_NAME]);
+	idx = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_NDEV_INDEX]);
+	if (rd->json_output) {
+		jsonw_string_field(rd->jw, "netdev", netdev_name);
+		jsonw_uint_field(rd->jw, "netdev_index", idx);
+	} else {
+		pr_out("netdev %s ", netdev_name);
+		if (rd->show_details)
+			pr_out("netdev_index %u ", idx);
+	}
+}
+
 static int link_parse_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
@@ -241,6 +261,7 @@ static int link_parse_cb(const struct nlmsghdr *nlh, void *data)
 	link_print_lmc(rd, tb);
 	link_print_state(rd, tb);
 	link_print_phys_state(rd, tb);
+	link_print_netdev(rd, tb);
 	if (rd->show_details)
 		link_print_caps(rd, tb);

diff --git a/rdma/utils.c b/rdma/utils.c
index a2e08e91..f38f0459 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -391,6 +391,8 @@ static const enum mnl_attr_data_type nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
 	[RDMA_NLDEV_ATTR_RES_LKEY] = MNL_TYPE_U32,
 	[RDMA_NLDEV_ATTR_RES_IOVA] = MNL_TYPE_U64,
 	[RDMA_NLDEV_ATTR_RES_MRLEN] = MNL_TYPE_U64,
+	[RDMA_NLDEV_ATTR_NDEV_INDEX]		= MNL_TYPE_U32,
+	[RDMA_NLDEV_ATTR_NDEV_NAME]		= MNL_TYPE_NUL_STRING,
 };

 int rd_attr_cb(const struct nlattr *attr, void *data)
