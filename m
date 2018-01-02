From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH iproute2-next 1/9] rdam: Add option to provide "-" sign for the port number
Date: Tue,  2 Jan 2018 11:37:17 +0200
Message-ID: <20180102093725.6172-2-leon@kernel.org>
References: <20180102093725.6172-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180102093725.6172-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

According to the IBTA spec [1], the physical connected port is provided
for the QP in RTR-to-INIT stage performed by modify_qp(). It causes
to do not have port number for newly created QPs.

The following patch adds "-" sign to present absence of port, because
QPs are going to be associated with rdmatool link object, which needs
port number as an index.

[1] InfiniBand Architecture Release 1.3 -
	"Table 96 QP State Transition Properties"

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 rdma/link.c  |  2 +-
 rdma/rdma.h  |  3 +--
 rdma/utils.c | 49 +++++++++++++++++++++++++++++++++++++++++--------
 3 files changed, 43 insertions(+), 11 deletions(-)

diff --git a/rdma/link.c b/rdma/link.c
index 676cb21d..66bcd50e 100644
--- a/rdma/link.c
+++ b/rdma/link.c
@@ -285,7 +285,7 @@ static int link_one_show(struct rd *rd)
 
 static int link_show(struct rd *rd)
 {
-	return rd_exec_link(rd, link_one_show);
+	return rd_exec_link(rd, link_one_show, true);
 }
 
 int cmd_link(struct rd *rd)
diff --git a/rdma/rdma.h b/rdma/rdma.h
index 8d53d3a0..cbd9aa89 100644
--- a/rdma/rdma.h
+++ b/rdma/rdma.h
@@ -64,7 +64,6 @@ bool rd_no_arg(struct rd *rd);
 void rd_arg_inc(struct rd *rd);
 
 char *rd_argv(struct rd *rd);
-uint32_t get_port_from_argv(struct rd *rd);
 
 /*
  * Commands interface
@@ -73,7 +72,7 @@ int cmd_dev(struct rd *rd);
 int cmd_link(struct rd *rd);
 int rd_exec_cmd(struct rd *rd, const struct rd_cmd *c, const char *str);
 int rd_exec_dev(struct rd *rd, int (*cb)(struct rd *rd));
-int rd_exec_link(struct rd *rd, int (*cb)(struct rd *rd));
+int rd_exec_link(struct rd *rd, int (*cb)(struct rd *rd), bool strict_port);
 void rd_free(struct rd *rd);
 
 /*
diff --git a/rdma/utils.c b/rdma/utils.c
index 7b2001e2..7c920a5c 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -10,6 +10,7 @@
  */
 
 #include "rdma.h"
+#include <ctype.h>
 
 static int rd_argc(struct rd *rd)
 {
@@ -50,13 +51,43 @@ bool rd_no_arg(struct rd *rd)
 	return rd_argc(rd) == 0;
 }
 
-uint32_t get_port_from_argv(struct rd *rd)
+/*
+ * Possible input:output
+ * dev/port    | first port | is_dump_all
+ * mlx5_1      | 0          | true
+ * mlx5_1/     | 0          | true
+ * mlx5_1/0    | 0          | false
+ * mlx5_1/1    | 1          | false
+ * mlx5_1/-    | 0          | false
+ *
+ * In strict mode, /- will return error.
+ */
+static int get_port_from_argv(struct rd *rd, uint32_t *port,
+			      bool *is_dump_all, bool strict_port)
 {
 	char *slash;
 
+	*port = 0;
+	*is_dump_all = true;
+
 	slash = strchr(rd_argv(rd), '/');
 	/* if no port found, return 0 */
-	return slash ? atoi(slash + 1) : 0;
+	if (slash) {
+		if (*(slash + 1) == '-') {
+			if (strict_port)
+				return -EINVAL;
+			*is_dump_all = false;
+			return 0;
+		}
+
+		if (isdigit(*(slash + 1))) {
+			*is_dump_all = false;
+			*port = atoi(slash + 1);
+		}
+		if (!*port && strlen(slash + 1))
+			return -EINVAL;
+	}
+	return 0;
 }
 
 static struct dev_map *dev_map_alloc(const char *dev_name)
@@ -152,7 +183,7 @@ void rd_free(struct rd *rd)
 	dev_map_cleanup(rd);
 }
 
-int rd_exec_link(struct rd *rd, int (*cb)(struct rd *rd))
+int rd_exec_link(struct rd *rd, int (*cb)(struct rd *rd), bool strict_port)
 {
 	struct dev_map *dev_map;
 	uint32_t port;
@@ -163,7 +194,8 @@ int rd_exec_link(struct rd *rd, int (*cb)(struct rd *rd))
 	if (rd_no_arg(rd)) {
 		list_for_each_entry(dev_map, &rd->dev_map_list, list) {
 			rd->dev_idx = dev_map->idx;
-			for (port = 1; port < dev_map->num_ports + 1; port++) {
+			port = (strict_port) ? 1 : 0;
+			for (; port < dev_map->num_ports + 1; port++) {
 				rd->port_idx = port;
 				ret = cb(rd);
 				if (ret)
@@ -172,21 +204,22 @@ int rd_exec_link(struct rd *rd, int (*cb)(struct rd *rd))
 		}
 
 	} else {
+		bool is_dump_all;
 		dev_map = dev_map_lookup(rd, true);
-		port = get_port_from_argv(rd);
-		if (!dev_map || port > dev_map->num_ports) {
+		ret = get_port_from_argv(rd, &port, &is_dump_all, strict_port);
+		if (!dev_map || port > dev_map->num_ports || (!port && ret)) {
 			pr_err("Wrong device name\n");
 			ret = -ENOENT;
 			goto out;
 		}
 		rd_arg_inc(rd);
 		rd->dev_idx = dev_map->idx;
-		rd->port_idx = port ? : 1;
+		rd->port_idx = port;
 		for (; rd->port_idx < dev_map->num_ports + 1; rd->port_idx++) {
 			ret = cb(rd);
 			if (ret)
 				goto out;
-			if (port)
+			if (!is_dump_all)
 				/*
 				 * We got request to show link for devname
 				 * with port index.
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
