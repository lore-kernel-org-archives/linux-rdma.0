From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next 04/10] rdma: Set pointer to device name position
Date: Wed, 31 Jan 2018 10:11:50 +0200
Message-ID: <20180131081156.19607-5-leon@kernel.org>
References: <20180131081156.19607-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180131081156.19607-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: RDMA mailing list <linux-rdma@vger.kernel.org>, Steve Wise <swise@opengridcomputing.com>, Leon Romanovsky <leon@kernel.org>, netdev <netdev@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

The dev and link execution callbacks expects that next
command line argument is device or port name.

Set pointer to device or port name position prior calls to
rd_exec_dev()/rd_exec_link().

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/rdma.h  |  1 +
 rdma/utils.c | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/rdma/rdma.h b/rdma/rdma.h
index 8e60ce26..35506a96 100644
--- a/rdma/rdma.h
+++ b/rdma/rdma.h
@@ -87,6 +87,7 @@ int rd_exec_cmd(struct rd *rd, const struct rd_cmd *c, const char *str);
 int rd_exec_dev(struct rd *rd, int (*cb)(struct rd *rd));
 int rd_exec_link(struct rd *rd, int (*cb)(struct rd *rd), bool strict_port);
 void rd_free(struct rd *rd);
+int rd_set_arg_to_devname(struct rd *rd);
 int rd_argc(struct rd *rd);
 
 /*
diff --git a/rdma/utils.c b/rdma/utils.c
index 157699c0..f93f05e1 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -412,6 +412,25 @@ void rd_free(struct rd *rd)
 	filters_cleanup(rd);
 }
 
+int rd_set_arg_to_devname(struct rd *rd)
+{
+	int ret = 0;
+
+	while (!rd_no_arg(rd)) {
+		if (rd_argv_match(rd, "dev") || rd_argv_match(rd, "link")) {
+			rd_arg_inc(rd);
+			if (rd_no_arg(rd)) {
+				pr_err("No device name was supplied\n");
+				ret = -EINVAL;
+			}
+			goto out;
+		}
+		rd_arg_inc(rd);
+	}
+out:
+	return ret;
+}
+
 int rd_exec_link(struct rd *rd, int (*cb)(struct rd *rd), bool strict_port)
 {
 	struct dev_map *dev_map;
-- 
2.16.1
