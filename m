From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 13/14] ibacm: ib_acme remove IP addresses from ibacm_addr.cfg file generation
Date: Thu,  3 Apr 2014 20:51:53 -0400
Message-ID: <1396572714-16498-14-git-send-email-ira.weiny@intel.com>
References: <1396572714-16498-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1396572714-16498-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Makefile.am        |    3 +-
 linux/acme_linux.c |   95 ----------------------------------------------------
 man/ib_acme.1      |    3 +-
 src/acme.c         |   12 ++-----
 4 files changed, 5 insertions(+), 108 deletions(-)
 delete mode 100644 linux/acme_linux.c

diff --git a/Makefile.am b/Makefile.am
index cab1ca1..9070a5a 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -5,8 +5,7 @@ AM_CFLAGS = -g -Wall -D_GNU_SOURCE -DSYSCONFDIR=\"$(sysconfdir)\" -DBINDIR=\"$(b
 bin_PROGRAMS = util/ib_acme
 sbin_PROGRAMS = svc/ibacm
 svc_ibacm_SOURCES = src/acm.c src/acm_util.c
-util_ib_acme_SOURCES = src/acme.c linux/acme_linux.c src/libacm.c linux/libacm_linux.c \
-			src/parse.c src/acm_util.c
+util_ib_acme_SOURCES = src/acme.c src/libacm.c linux/libacm_linux.c src/parse.c
 svc_ibacm_CFLAGS = $(AM_CFLAGS)
 util_ib_acme_CFLAGS = $(AM_CFLAGS) -DACME_PRINTS
 
diff --git a/linux/acme_linux.c b/linux/acme_linux.c
deleted file mode 100644
index 33fafd2..0000000
--- a/linux/acme_linux.c
+++ /dev/null
@@ -1,95 +0,0 @@
-/*
- * Copyright (c) 2009 Intel Corporation. All rights reserved.
- *
- * This software is available to you under the OpenIB.org BSD license
- * below:
- *
- *     Redistribution and use in source and binary forms, with or
- *     without modification, are permitted provided that the following
- *     conditions are met:
- *
- *      - Redistributions of source code must retain the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer.
- *
- *      - Redistributions in binary form must reproduce the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer in the documentation and/or other materials
- *        provided with the distribution.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AWV
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- */
-
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-
-#include <infiniband/verbs.h>
-#include "acm_util.h"
-
-extern struct ibv_context **verbs;
-extern int dev_cnt;
-extern int verbose;
-
-static int
-get_devaddr(union ibv_gid *sgid, int *dev_index, uint8_t *port)
-{
-	struct ibv_device_attr dev_attr;
-	struct ibv_port_attr port_attr;
-	union ibv_gid gid;
-	int ret, i;
-
-	for (*dev_index = 0; *dev_index < dev_cnt; (*dev_index)++) {
-		ret = ibv_query_device(verbs[*dev_index], &dev_attr);
-		if (ret)
-			continue;
-
-		for (*port = 1; *port <= dev_attr.phys_port_cnt; (*port)++) {
-			ret = ibv_query_port(verbs[*dev_index], *port, &port_attr);
-			if (ret)
-				continue;
-
-			for (i = 0; i < port_attr.gid_tbl_len; i++) {
-				ret = ibv_query_gid(verbs[*dev_index], *port, i, &gid);
-				if (ret || !gid.global.interface_id)
-					break;
-
-				if (!memcmp(sgid->raw, gid.raw, sizeof gid))
-					return 0;
-			}
-		}
-	}
-	return -1;
-}
-
-static void iter_cb(char *ifname, union ibv_gid *gid, uint16_t pkey,
-		uint8_t addr_type, uint8_t *addr, size_t addr_len,
-		char *addr_name, void *ctx)
-{
-	FILE *f = (FILE *)ctx;
-	int ret;
-	int dev_index;
-	uint8_t port;
-
-	ret = get_devaddr(gid, &dev_index, &port);
-	if (ret) {
-		printf("Failed to find verbs device for %s\n", ifname);
-		return;
-	}
-
-	if (verbose)
-		printf("%s %s %d 0x%x\n", addr_name, verbs[dev_index]->device->name, port, pkey);
-	fprintf(f, "%s %s %d 0x%x\n", addr_name, verbs[dev_index]->device->name, port, pkey);
-}
-
-int gen_addr_ip(FILE *f)
-{
-	return acm_if_iter_sys(iter_cb, (void *)f);
-}
diff --git a/man/ib_acme.1 b/man/ib_acme.1
index b00b315..baa1dd6 100644
--- a/man/ib_acme.1
+++ b/man/ib_acme.1
@@ -55,8 +55,7 @@ performance of ACM cache lookups.  Defaults to 1.
 \-A [addr_file]
 With this option, the ib_acme utility automatically generates the address
 configuration file ibacm_addr.cfg.  The generated file is
-constructed using the system host name and any IP addresses that are
-assigned to IPoIB device instances.
+constructed using the system host name.
 .TP
 \-O [opt_file]
 With this option, the ib_acme utility automatically generates the option
diff --git a/src/acme.c b/src/acme.c
index 9c5b4d4..d83e56f 100644
--- a/src/acme.c
+++ b/src/acme.c
@@ -317,9 +317,11 @@ static void gen_addr_temp(FILE *f)
 	fprintf(f, "# Entry format is:\n");
 	fprintf(f, "# address device port pkey\n");
 	fprintf(f, "#\n");
+	fprintf(f, "# NOTE: IP addresses are now automatically read and monitored on the system.\n");
+	fprintf(f, "#       Therefore they are no longer required in this file.\n");
+	fprintf(f, "#\n");
 	fprintf(f, "# The address may be one of the following:\n");
 	fprintf(f, "# host_name - ascii character string, up to 31 characters\n");
-	fprintf(f, "# address - IPv4 or IPv6 formatted address\n");
 	fprintf(f, "#\n");
 	fprintf(f, "# device name - struct ibv_device name\n");
 	fprintf(f, "# port number - valid port number on device (numbering starts at 1)\n");
@@ -331,8 +333,6 @@ static void gen_addr_temp(FILE *f)
 	fprintf(f, "# node31      ibv_device0 1 default\n");
 	fprintf(f, "# node31-1    ibv_device0 1 0x00FF\n");
 	fprintf(f, "# node31-2    ibv_device0 2 0x00FF\n");
-	fprintf(f, "# 192.168.0.1 ibv_device0 1 0xFFFF\n");
-	fprintf(f, "# 192.168.0.2 ibv_device0 2 default\n");
 }
 
 static int open_verbs(void)
@@ -449,12 +449,6 @@ static int gen_addr(void)
 		goto out2;
 	}
 
-	ret = gen_addr_ip(f);
-	if (ret) {
-		printf("Failed to auto generate IP addresses in config file\n");
-		goto out2;
-	}
-
 out2:
 	close_verbs();
 out1:
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
