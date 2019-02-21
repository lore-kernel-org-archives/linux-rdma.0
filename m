From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH v1 iproute2-next 1/4] rdma: add helper rd_sendrecv_msg()
Date: Thu, 21 Feb 2019 08:19:03 -0800
Message-ID: <aa883bc5ffd63047cf57e2f9925002e7573fd7ac.1550773362.git.swise@opengridcomputing.com>
References: <cover.1550773362.git.swise@opengridcomputing.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1550773362.git.swise@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: dsahern@gmail.com, leon@kernel.org
Cc: stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This function sends the constructed netlink message and then
receives the response, displaying any error text.

Change 'rdma dev set' to use it.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---
 rdma/dev.c   |  2 +-
 rdma/rdma.h  |  1 +
 rdma/utils.c | 21 +++++++++++++++++++++
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/rdma/dev.c b/rdma/dev.c
index 60ff4b31e320..d2949c378f08 100644
--- a/rdma/dev.c
+++ b/rdma/dev.c
@@ -273,7 +273,7 @@ static int dev_set_name(struct rd *rd)
 	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_DEV_INDEX, rd->dev_idx);
 	mnl_attr_put_strz(rd->nlh, RDMA_NLDEV_ATTR_DEV_NAME, rd_argv(rd));
 
-	return rd_send_msg(rd);
+	return rd_sendrecv_msg(rd, seq);
 }
 
 static int dev_one_set(struct rd *rd)
diff --git a/rdma/rdma.h b/rdma/rdma.h
index 547bb5749a39..20be2f12c4f8 100644
--- a/rdma/rdma.h
+++ b/rdma/rdma.h
@@ -115,6 +115,7 @@ bool rd_check_is_key_exist(struct rd *rd, const char *key);
  */
 int rd_send_msg(struct rd *rd);
 int rd_recv_msg(struct rd *rd, mnl_cb_t callback, void *data, uint32_t seq);
+int rd_sendrecv_msg(struct rd *rd, unsigned int seq);
 void rd_prepare_msg(struct rd *rd, uint32_t cmd, uint32_t *seq, uint16_t flags);
 int rd_dev_init_cb(const struct nlmsghdr *nlh, void *data);
 int rd_attr_cb(const struct nlattr *attr, void *data);
diff --git a/rdma/utils.c b/rdma/utils.c
index 069d44fece10..a6f2826c9605 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -664,6 +664,27 @@ int rd_recv_msg(struct rd *rd, mnl_cb_t callback, void *data, unsigned int seq)
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
+	if (ret) {
+		perror(NULL);
+		goto out;
+	}
+	ret = rd_recv_msg(rd, null_cb, rd, seq);
+	if (ret)
+		perror(NULL);
+out:
+	return ret;
+}
+
 static struct dev_map *_dev_map_lookup(struct rd *rd, const char *dev_name)
 {
 	struct dev_map *dev_map;
-- 
1.8.3.1
