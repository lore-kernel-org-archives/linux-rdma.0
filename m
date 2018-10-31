From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next v1 2/4] rdma: Introduce command execution helper with required device name
Date: Wed, 31 Oct 2018 09:17:56 +0200
Message-ID: <20181031071758.6178-3-leon@kernel.org>
References: <20181031071758.6178-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181031071758.6178-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, Steve Wise <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

In contradiction to various show commands, the set command explicitly
requires to use device name as an argument. Provide new command
execution helper which enforces it.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Steve Wise <swise@opengridcomputing.com>
---
 rdma/rdma.h  |  1 +
 rdma/utils.c | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/rdma/rdma.h b/rdma/rdma.h
index c3b7530b..547bb574 100644
--- a/rdma/rdma.h
+++ b/rdma/rdma.h
@@ -90,6 +90,7 @@ int cmd_link(struct rd *rd);
 int cmd_res(struct rd *rd);
 int rd_exec_cmd(struct rd *rd, const struct rd_cmd *c, const char *str);
 int rd_exec_dev(struct rd *rd, int (*cb)(struct rd *rd));
+int rd_exec_require_dev(struct rd *rd, int (*cb)(struct rd *rd));
 int rd_exec_link(struct rd *rd, int (*cb)(struct rd *rd), bool strict_port);
 void rd_free(struct rd *rd);
 int rd_set_arg_to_devname(struct rd *rd);
diff --git a/rdma/utils.c b/rdma/utils.c
index 4840bf22..61f4aeb1 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -577,6 +577,16 @@ out:
 	return ret;
 }
 
+int rd_exec_require_dev(struct rd *rd, int (*cb)(struct rd *rd))
+{
+	if (rd_no_arg(rd)) {
+		pr_err("Please provide device name.\n");
+		return -EINVAL;
+	}
+
+	return rd_exec_dev(rd, cb);
+}
+
 int rd_exec_cmd(struct rd *rd, const struct rd_cmd *cmds, const char *str)
 {
 	const struct rd_cmd *c;
-- 
2.14.4
