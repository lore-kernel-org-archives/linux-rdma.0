From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next 15/19] rdma: Separate PD code
Date: Tue, 22 Jan 2019 20:31:21 +0200
Message-ID: <20190122183125.15920-16-leon@kernel.org>
References: <20190122183125.15920-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190122183125.15920-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/res-pd.c | 170 ++++++++++++++++++++++++++------------------------
 1 file changed, 89 insertions(+), 81 deletions(-)

diff --git a/rdma/res-pd.c b/rdma/res-pd.c
index 24ac7f1b..3c9ffa4e 100644
--- a/rdma/res-pd.c
+++ b/rdma/res-pd.c
@@ -7,11 +7,95 @@
 #include "res.h"
 #include <inttypes.h>
 
+static int res_pd_line(struct rd *rd, const char *name, int idx,
+		       struct nlattr *nla_entry)
+{
+	uint32_t local_dma_lkey = 0, unsafe_global_rkey = 0;
+	struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
+	char *comm = NULL;
+	uint32_t ctxn = 0;
+	uint32_t pid = 0;
+	uint32_t pdn = 0;
+	uint64_t users;
+	int err;
+
+	err = mnl_attr_parse_nested(nla_entry, rd_attr_cb, nla_line);
+	if (err != MNL_CB_OK)
+		return MNL_CB_ERROR;
+
+	if (!nla_line[RDMA_NLDEV_ATTR_RES_USECNT] ||
+	    (!nla_line[RDMA_NLDEV_ATTR_RES_PID] &&
+	     !nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])) {
+		return MNL_CB_ERROR;
+	}
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY])
+		local_dma_lkey = mnl_attr_get_u32(
+			nla_line[RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY]);
+
+	users = mnl_attr_get_u64(nla_line[RDMA_NLDEV_ATTR_RES_USECNT]);
+	if (rd_check_is_filtered(rd, "users", users))
+		goto out;
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY])
+		unsafe_global_rkey = mnl_attr_get_u32(
+			nla_line[RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY]);
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
+		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
+		comm = get_task_name(pid);
+	}
+
+	if (rd_check_is_filtered(rd, "pid", pid))
+		goto out;
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_CTXN])
+		ctxn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_CTXN]);
+
+	if (rd_check_is_filtered(rd, "ctxn", ctxn))
+		goto out;
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_PDN])
+		pdn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
+	if (rd_check_is_filtered(rd, "pdn", pdn))
+		goto out;
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
+		/* discard const from mnl_attr_get_str */
+		comm = (char *)mnl_attr_get_str(
+			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
+
+	if (rd->json_output)
+		jsonw_start_array(rd->jw);
+
+	print_dev(rd, idx, name);
+	if (nla_line[RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY])
+		print_key(rd, "local_dma_lkey", local_dma_lkey);
+	res_print_uint(rd, "users", users);
+	if (nla_line[RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY])
+		print_key(rd, "unsafe_global_rkey", unsafe_global_rkey);
+	res_print_uint(rd, "pid", pid);
+	print_comm(rd, comm, nla_line);
+	if (nla_line[RDMA_NLDEV_ATTR_RES_CTXN])
+		res_print_uint(rd, "ctxn", ctxn);
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_PDN])
+		res_print_uint(rd, "pdn", pdn);
+
+	print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
+	newline(rd);
+
+out:	if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
+		free(comm);
+	return MNL_CB_OK;
+}
+
 int res_pd_parse_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
 	struct nlattr *nla_table, *nla_entry;
 	struct rd *rd = data;
+	int ret = MNL_CB_OK;
 	const char *name;
 	uint32_t idx;
 
@@ -25,86 +109,10 @@ int res_pd_parse_cb(const struct nlmsghdr *nlh, void *data)
 	nla_table = tb[RDMA_NLDEV_ATTR_RES_PD];
 
 	mnl_attr_for_each_nested(nla_entry, nla_table) {
-		uint32_t local_dma_lkey = 0, unsafe_global_rkey = 0;
-		struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
-		char *comm = NULL;
-		uint32_t ctxn = 0;
-		uint32_t pid = 0;
-		uint32_t pdn = 0;
-		uint64_t users;
-		int err;
-
-		err = mnl_attr_parse_nested(nla_entry, rd_attr_cb, nla_line);
-		if (err != MNL_CB_OK)
-			return MNL_CB_ERROR;
-
-		if (!nla_line[RDMA_NLDEV_ATTR_RES_USECNT] ||
-		    (!nla_line[RDMA_NLDEV_ATTR_RES_PID] &&
-		     !nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])) {
-			return MNL_CB_ERROR;
-		}
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY])
-			local_dma_lkey = mnl_attr_get_u32(
-				nla_line[RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY]);
-
-		users = mnl_attr_get_u64(nla_line[RDMA_NLDEV_ATTR_RES_USECNT]);
-		if (rd_check_is_filtered(rd, "users", users))
-			continue;
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY])
-			unsafe_global_rkey = mnl_attr_get_u32(
-				nla_line[RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY]);
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
-			pid = mnl_attr_get_u32(
-				nla_line[RDMA_NLDEV_ATTR_RES_PID]);
-			comm = get_task_name(pid);
-		}
-
-		if (rd_check_is_filtered(rd, "pid", pid))
-			continue;
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_CTXN])
-			ctxn = mnl_attr_get_u32(
-				nla_line[RDMA_NLDEV_ATTR_RES_CTXN]);
-
-		if (rd_check_is_filtered(rd, "ctxn", ctxn))
-			continue;
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_PDN])
-			pdn = mnl_attr_get_u32(
-				nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
-		if (rd_check_is_filtered(rd, "pdn", pdn))
-			continue;
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
-			/* discard const from mnl_attr_get_str */
-			comm = (char *)mnl_attr_get_str(
-				nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
-
-		if (rd->json_output)
-			jsonw_start_array(rd->jw);
-
-		print_dev(rd, idx, name);
-		if (nla_line[RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY])
-			print_key(rd, "local_dma_lkey", local_dma_lkey);
-		res_print_uint(rd, "users", users);
-		if (nla_line[RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY])
-			print_key(rd, "unsafe_global_rkey", unsafe_global_rkey);
-		res_print_uint(rd, "pid", pid);
-		print_comm(rd, comm, nla_line);
-		if (nla_line[RDMA_NLDEV_ATTR_RES_CTXN])
-			res_print_uint(rd, "ctxn", ctxn);
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_PDN])
-			res_print_uint(rd, "pdn", pdn);
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
-			free(comm);
-
-		print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
-		newline(rd);
+		ret = res_pd_line(rd, name, idx, nla_entry);
+
+		if (ret != MNL_CB_OK)
+			break;
 	}
-	return MNL_CB_OK;
+	return ret;
 }
-- 
2.19.1
