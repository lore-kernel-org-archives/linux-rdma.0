From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 6/6] infiniband-diags/ibstat.c: Add support for FDR10
Date: Fri, 19 Aug 2011 12:54:16 -0400
Message-ID: <4E4E9538.5050400@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


without changing libibumad umad_port_t structure

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/ibstat.c |   70 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 69 insertions(+), 1 deletions(-)

diff --git a/src/ibstat.c b/src/ibstat.c
index 92fcd0f..ade5d7a 100644
--- a/src/ibstat.c
+++ b/src/ibstat.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire Inc.  All rights reserved.
+ * Copyright (c) 2011 Mellanox Technologies LTD.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -43,6 +44,10 @@
 #include <stdlib.h>
 #include <getopt.h>
 #include <netinet/in.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <errno.h>
 
 #include <infiniband/umad.h>
 #include <infiniband/mad.h>
@@ -96,6 +101,66 @@ static char *port_phy_state_str[] = {
 	"PhyTest"
 };
 
+static int ret_code(void)
+{
+	int e = errno;
+
+	if (e > 0)
+		return -e;
+	return e;
+}
+
+static int sys_read_string(char *dir_name, char *file_name, char *str,
+			   int max_len)
+{
+	char path[256], *s;
+	int fd, r;
+
+	snprintf(path, sizeof(path), "%s/%s", dir_name, file_name);
+
+	if ((fd = open(path, O_RDONLY)) < 0)
+		return ret_code();
+
+	if ((r = read(fd, str, max_len)) < 0) {
+		int e = errno;
+		close(fd);
+		errno = e;
+		return ret_code();
+	}
+
+	str[(r < max_len) ? r : max_len - 1] = 0;
+
+	if ((s = strrchr(str, '\n')))
+		*s = 0;
+
+	close(fd);
+	return 0;
+}
+
+static int is_fdr10(umad_port_t *port)
+{
+	char port_dir[256];
+	char rate[32];
+	int len, fdr10 = 0;
+	char *p;
+
+	len = snprintf(port_dir, sizeof(port_dir), "%s/%s/%s/%d",
+		       SYS_INFINIBAND, port->ca_name, SYS_CA_PORTS_DIR,
+		       port->portnum);
+	if (len < 0 || len > sizeof(port_dir))
+		goto done;
+
+	if (sys_read_string(port_dir, SYS_PORT_RATE, rate, sizeof(rate)) == 0) {
+		if ((p = strchr(rate, ')'))) {
+			if (!strncasecmp(p - 5, "fdr10", 5))
+				fdr10 = 1;
+		}
+	}
+
+done:
+	return fdr10;
+}
+
 static int port_dump(umad_port_t * port, int alone)
 {
 	char *pre = "";
@@ -116,7 +181,10 @@ static int port_dump(umad_port_t * port, int alone)
 	printf("%sPhysical state: %s\n", pre,
 	       (unsigned)port->phys_state <=
 	       7 ? port_phy_state_str[port->phys_state] : "???");
-	printf("%sRate: %d\n", pre, port->rate);
+	if (is_fdr10(port))
+		printf("%sRate: %d (FDR10)\n", pre, port->rate);
+	else
+		printf("%sRate: %d\n", pre, port->rate);
 	printf("%sBase lid: %d\n", pre, port->base_lid);
 	printf("%sLMC: %d\n", pre, port->lmc);
 	printf("%sSM lid: %d\n", pre, port->sm_lid);
-- 
1.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
