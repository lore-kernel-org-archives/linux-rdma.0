From: Steve Wise <larrystevenwise@gmail.com>
Subject: [PATCH v3 iproute2-next 2/4] rdma: add helper rd_sendrecv_msg()
Date: Wed,  3 Apr 2019 12:10:30 -0500
Message-ID: <15b656f2c6235902f34321c052d3eaec2632c82e.1554304142.git.larrystevenwise@gmail.com>
References: <cover.1554304142.git.larrystevenwise@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1554304142.git.larrystevenwise@gmail.com>
Sender: netdev-owner@vger.kernel.org
To: dsahern@gmail.com
Cc: Steve Wise <larrystevenwise@gmail.com>, leon@kernel.org, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

This function sends the constructed netlink message and then
receives the response.

Change rd_recv_msg() to display any error messages.

Change 'rdma dev set' to use rd_sendrecv_msg().

Signed-off-by: Steve Wise <larrystevenwise@gmail.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/dev.c   |  2 +-
 rdma/rdma.h  |  2 ++
 rdma/res.h   |  1 +
 rdma/utils.c | 18 ++++++++++++++++++
 4 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/rdma/dev.c b/rdma/dev.c
index 954e0015..33962520 100644
--- a/rdma/dev.c
+++ b/rdma/dev.c
@@ -268,7 +268,7 @@ static int dev_set_name(struct rd *rd)
 	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_DEV_INDEX, rd->dev_idx);
 	mnl_attr_put_strz(rd->nlh, RDMA_NLDEV_ATTR_DEV_NAME, rd_argv(rd));
 
-	return rd_send_msg(rd);
+	return rd_sendrecv_msg(rd, seq);
 }
 
 static int dev_one_set(struct rd *rd)
diff --git a/rdma/rdma.h b/rdma/rdma.h
index 1022e9a2..6c7f7d15 100644
--- a/rdma/rdma.h
+++ b/rdma/rdma.h
@@ -68,6 +68,7 @@ struct rd {
 	json_writer_t *jw;
 	bool json_output;
 	bool pretty_output;
+	bool suppress_errors;
 	struct list_head filter_list;
 };
 
@@ -119,6 +120,7 @@ bool rd_is_string_filtered_attr(struct rd *rd, const char *key, const char *val,
  */
 int rd_send_msg(struct rd *rd);
 int rd_recv_msg(struct rd *rd, mnl_cb_t callback, void *data, uint32_t seq);
+int rd_sendrecv_msg(struct rd *rd, unsigned int seq);
 void rd_prepare_msg(struct rd *rd, uint32_t cmd, uint32_t *seq, uint16_t flags);
 int rd_dev_init_cb(const struct nlmsghdr *nlh, void *data);
 int rd_attr_cb(const struct nlattr *attr, void *data);
diff --git a/rdma/res.h b/rdma/res.h
index b4a7e552..525171fc 100644
--- a/rdma/res.h
+++ b/rdma/res.h
@@ -31,6 +31,7 @@ int res_qp_idx_parse_cb(const struct nlmsghdr *nlh, void *data);
 		if (id) {                                                              \
 			ret = rd_doit_index(rd, &idx);                                 \
 			if (ret) {                                                     \
+				rd->suppress_errors = true;                            \
 				ret = _res_send_idx_msg(rd, command,                   \
 							name##_idx_parse_cb,           \
 							idx, id);                      \
diff --git a/rdma/utils.c b/rdma/utils.c
index 1f6bf330..11ed8a73 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -693,10 +693,28 @@ int rd_recv_msg(struct rd *rd, mnl_cb_t callback, void *data, unsigned int seq)
 		ret = mnl_cb_run(buf, ret, seq, portid, callback, data);
 	} while (ret > 0);
 
+	if (ret < 0 && !rd->suppress_errors)
+		perror("error");
+
 	mnl_socket_close(rd->nl);
 	return ret;
 }
 
+static int null_cb(const struct nlmsghdr *nlh, void *data)
+{
+	return MNL_CB_OK;
+}
+
+int rd_sendrecv_msg(struct rd *rd, unsigned int seq)
+{
+	int ret;
+
+	ret = rd_send_msg(rd);
+	if (!ret)
+		ret = rd_recv_msg(rd, null_cb, rd, seq);
+	return ret;
+}
+
 static struct dev_map *_dev_map_lookup(struct rd *rd, const char *dev_name)
 {
 	struct dev_map *dev_map;
-- 
2.20.1
