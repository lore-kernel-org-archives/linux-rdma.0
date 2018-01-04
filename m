From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH iproute2-next v1 4/9] rdma: Set pointer to device name position
Date: Thu,  4 Jan 2018 09:01:45 +0200
Message-ID: <20180104070150.15625-5-leon@kernel.org>
References: <20180104070150.15625-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180104070150.15625-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The dev and link execution callbacks expects that next
command line argument is device or port name.

Set pointer to device or port name position prior calls to
rd_exec_dev()/rd_exec_link().

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
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
index 446c23da..73f0d04e 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -403,6 +403,25 @@ void rd_free(struct rd *rd)
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

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
