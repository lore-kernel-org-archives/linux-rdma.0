From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH v4 iproute2-next 7/7] rdma: Add PD resource tracking
 information
Date: Thu, 29 Mar 2018 09:10:44 -0700
Message-ID: <9745441dbbcbbd3e0b4ac12c2930c752cf35c342.1522359537.git.swise@opengridcomputing.com>
References: <cover.1522359537.git.swise@opengridcomputing.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1522359537.git.swise@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: dsahern@gmail.com
Cc: leon@kernel.org, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Sample output:

Without CAP_NET_ADMIN capability:

dev mlx4_0 users 0 pid 0 comm [ib_srpt]
dev mlx4_0 users 0 pid 0 comm [ib_srp]
dev mlx4_0 users 1 pid 0 comm [ib_core]
dev cxgb4_0 users 0 pid 0 comm [ib_srp]

With CAP_NET_ADMIN capability:
dev mlx4_0 local_dma_lkey 0x8000 users 0 pid 0 comm [ib_srpt]
dev mlx4_0 local_dma_lkey 0x8000 users 0 pid 0 comm [ib_srp]
dev mlx4_0 local_dma_lkey 0x8000 users 1 pid 0 comm [ib_core]
dev cxgb4_0 local_dma_lkey 0x0 users 0 pid 0 comm [ib_srp]

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/res.c | 95 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 95 insertions(+)

diff --git a/rdma/res.c b/rdma/res.c
index 9c1f736..1a0aab6 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -927,6 +927,91 @@ static int res_mr_parse_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
 }
 
+static int res_pd_parse_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
+	struct nlattr *nla_table, *nla_entry;
+	struct rd *rd = data;
+	const char *name;
+	uint32_t idx;
+
+	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
+	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] ||
+	    !tb[RDMA_NLDEV_ATTR_DEV_NAME] ||
+	    !tb[RDMA_NLDEV_ATTR_RES_PD])
+		return MNL_CB_ERROR;
+
+	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
+	idx =  mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
+	nla_table = tb[RDMA_NLDEV_ATTR_RES_PD];
+
+	mnl_attr_for_each_nested(nla_entry, nla_table) {
+		uint32_t local_dma_lkey = 0, unsafe_global_rkey = 0;
+		struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
+		char *comm = NULL;
+		uint32_t pid = 0;
+		uint64_t users;
+		int err;
+
+		err = mnl_attr_parse_nested(nla_entry, rd_attr_cb, nla_line);
+		if (err != MNL_CB_OK)
+			return MNL_CB_ERROR;
+
+		if (!nla_line[RDMA_NLDEV_ATTR_RES_USECNT] ||
+		    (!nla_line[RDMA_NLDEV_ATTR_RES_PID] &&
+		     !nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])) {
+			return MNL_CB_ERROR;
+		}
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY])
+			local_dma_lkey = mnl_attr_get_u32(
+				nla_line[RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY]);
+
+		users = mnl_attr_get_u64(nla_line[RDMA_NLDEV_ATTR_RES_USECNT]);
+		if (rd_check_is_filtered(rd, "users", users))
+			continue;
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY])
+			unsafe_global_rkey = mnl_attr_get_u32(
+			      nla_line[RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY]);
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
+			pid = mnl_attr_get_u32(
+				nla_line[RDMA_NLDEV_ATTR_RES_PID]);
+			comm = get_task_name(pid);
+		}
+
+		if (rd_check_is_filtered(rd, "pid", pid))
+			continue;
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
+			/* discard const from mnl_attr_get_str */
+			comm = (char *)mnl_attr_get_str(
+				nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
+
+		if (rd->json_output)
+			jsonw_start_array(rd->jw);
+
+		print_dev(rd, idx, name);
+		if (nla_line[RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY])
+			print_key(rd, "local_dma_lkey", local_dma_lkey);
+		print_users(rd, users);
+		if (nla_line[RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY])
+			print_key(rd, "unsafe_global_rkey", unsafe_global_rkey);
+		print_pid(rd, pid);
+		print_comm(rd, comm, nla_line);
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
+			free(comm);
+
+		if (rd->json_output)
+			jsonw_end_array(rd->jw);
+		else
+			pr_out("\n");
+	}
+	return MNL_CB_OK;
+}
+
 RES_FUNC(res_no_args,	RDMA_NLDEV_CMD_RES_GET,	NULL, true);
 
 static const struct
@@ -990,6 +1075,15 @@ struct filters mr_valid_filters[MAX_NUMBER_OF_FILTERS] = {
 
 RES_FUNC(res_mr, RDMA_NLDEV_CMD_RES_MR_GET, mr_valid_filters, true);
 
+static const
+struct filters pd_valid_filters[MAX_NUMBER_OF_FILTERS] = {
+	{ .name = "dev", .is_number = false },
+	{ .name = "users", .is_number = true },
+	{ .name = "pid", .is_number = true }
+};
+
+RES_FUNC(res_pd, RDMA_NLDEV_CMD_RES_PD_GET, pd_valid_filters, true);
+
 static int res_show(struct rd *rd)
 {
 	const struct rd_cmd cmds[] = {
@@ -998,6 +1092,7 @@ static int res_show(struct rd *rd)
 		{ "cm_id",	res_cm_id	},
 		{ "cq",		res_cq		},
 		{ "mr",		res_mr		},
+		{ "pd",		res_pd		},
 		{ 0 }
 	};
 
-- 
1.8.3.1
