From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next 4/9] rdma: Set pointer to device name position
Date: Tue,  2 Jan 2018 11:37:20 +0200
Message-ID: <20180102093725.6172-5-leon@kernel.org>
References: <20180102093725.6172-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180102093725.6172-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, David Ahern <dsahern@gmail.com>
Cc: RDMA mailing list <linux-rdma@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
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
index cd415670..e842d076 100644
--- a/rdma/rdma.h
+++ b/rdma/rdma.h
@@ -81,6 +81,7 @@ int rd_exec_cmd(struct rd *rd, const struct rd_cmd *c, const char *str);
 int rd_exec_dev(struct rd *rd, int (*cb)(struct rd *rd));
 int rd_exec_link(struct rd *rd, int (*cb)(struct rd *rd), bool strict_port);
 void rd_free(struct rd *rd);
+int rd_set_arg_to_devname(struct rd *rd);
 int rd_argc(struct rd *rd);
 
 /*
diff --git a/rdma/utils.c b/rdma/utils.c
index dc9f4f01..fbeffa08 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -395,6 +395,25 @@ void rd_free(struct rd *rd)
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
2.15.1
