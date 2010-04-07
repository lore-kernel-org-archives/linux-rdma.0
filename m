From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 32/37] librdmacm/rdma_client: add new client sample
Date: Wed, 7 Apr 2010 10:12:43 -0700
Message-ID: <A5D157848C5C40CBB57995DF0DEDA966@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
References: 
In-Reply-To: 
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Provide a very simple client application that shows the
minimal coding needed to establish a connection and exchange
messages with a server.  The client makes use of the new
rdma_getaddrinfo and rdma_create_ep calls, plus rdma verbs
abstractions.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 Makefile.am            |    5 +-
 examples/rdma_client.c |  134 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 138 insertions(+), 1 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 8aef24a..6071599 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -17,7 +17,8 @@ src_librdmacm_la_LDFLAGS = -version-info 1 -export-dynamic \
 			   $(librdmacm_version_script)
 src_librdmacm_la_DEPENDENCIES =  $(srcdir)/src/librdmacm.map
 
-bin_PROGRAMS = examples/ucmatose examples/rping examples/udaddy examples/mckey
+bin_PROGRAMS = examples/ucmatose examples/rping examples/udaddy examples/mckey \
+	       examples/rdma_client
 examples_ucmatose_SOURCES = examples/cmatose.c
 examples_ucmatose_LDADD = $(top_builddir)/src/librdmacm.la
 examples_rping_SOURCES = examples/rping.c
@@ -26,6 +27,8 @@ examples_udaddy_SOURCES = examples/udaddy.c
 examples_udaddy_LDADD = $(top_builddir)/src/librdmacm.la
 examples_mckey_SOURCES = examples/mckey.c
 examples_mckey_LDADD = $(top_builddir)/src/librdmacm.la
+examples_rdma_client_SOURCES = examples/rdma_client.c
+examples_rdma_client_LDADD = $(top_builddir)/src/librdmacm.la
 
 librdmacmincludedir = $(includedir)/rdma $(includedir)/infiniband
 
diff --git a/examples/rdma_client.c b/examples/rdma_client.c
new file mode 100644
index 0000000..7a59d97
--- /dev/null
+++ b/examples/rdma_client.c
@@ -0,0 +1,134 @@
+/*
+ * Copyright (c) 2010 Intel Corporation.  All rights reserved.
+ *
+ * This software is available to you under the OpenIB.org BSD license
+ * below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AWV
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+#include <getopt.h>
+#include <rdma/rdma_cma.h>
+#include <rdma/rdma_verbs.h>
+
+static char *server = "127.0.0.1";
+static char *port = "7471";
+
+struct rdma_cm_id *id;
+struct ibv_mr *mr;
+uint8_t send_msg[16];
+uint8_t recv_msg[16];
+
+static int run(void)
+{
+	struct rdma_addrinfo hints, *res;
+	struct ibv_qp_init_attr attr;
+	struct ibv_wc wc;
+	int ret;
+
+	memset(&hints, 0, sizeof hints);
+	hints.ai_port_space = RDMA_PS_TCP;
+	ret = rdma_getaddrinfo(server, port, &hints, &res);
+	if (ret) {
+		printf("rdma_getaddrinfo %d\n", errno);
+		return ret;
+	}
+
+	memset(&attr, 0, sizeof attr);
+	attr.cap.max_send_wr = attr.cap.max_recv_wr = 1;
+	attr.cap.max_send_sge = attr.cap.max_recv_sge = 1;
+	attr.cap.max_inline_data = 16;
+	attr.qp_context = id;
+	attr.sq_sig_all = 1;
+	ret = rdma_create_ep(&id, res, NULL, &attr);
+	rdma_freeaddrinfo(res);
+	if (ret) {
+		printf("rdma_create_ep %d\n", errno);
+		return ret;
+	}
+
+	mr = rdma_reg_msgs(id, recv_msg, 16);
+	if (!mr) {
+		printf("rdma_reg_msgs %d\n", errno);
+		return ret;
+	}
+
+	ret = rdma_post_recv(id, NULL, recv_msg, 16, mr);
+	if (ret) {
+		printf("rdma_post_recv %d\n", errno);
+		return ret;
+	}
+
+	ret = rdma_connect(id, NULL);
+	if (ret) {
+		printf("rdma_connect %d\n", errno);
+		return ret;
+	}
+
+	ret = rdma_post_send(id, NULL, send_msg, 16, NULL, IBV_SEND_INLINE);
+	if (ret) {
+		printf("rdma_post_send %d\n", errno);
+		return ret;
+	}
+
+	ret = rdma_get_recv_comp(id, &wc);
+	if (ret <= 0) {
+		printf("rdma_get_recv_comp %d\n", ret);
+		return ret;
+	}
+
+	rdma_disconnect(id);
+	rdma_dereg_mr(mr);
+	rdma_destroy_ep(id);
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	int op, ret;
+
+	while ((op = getopt(argc, argv, "s:p:")) != -1) {
+		switch (op) {
+		case 's':
+			server = optarg;
+			break;
+		case 'p':
+			port = optarg;
+			break;
+		default:
+			printf("usage: %s\n", argv[0]);
+			printf("\t[-s server_address]\n");
+			printf("\t[-p port_number]\n");
+			exit(1);
+		}
+	}
+
+	printf("rdma_client: start\n");
+	ret = run();
+	printf("rdma_client: end %d\n", ret);
+	return ret;
+}



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
