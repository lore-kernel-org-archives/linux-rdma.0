From: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC rdma-core 3/4] mlx5/examples: Create a DCI QP
Date: Sun, 26 Nov 2017 19:45:16 +0200
Message-ID: <1511718317-3381-6-git-send-email-alexma@mellanox.com>
References: <1511718317-3381-1-git-send-email-alexma@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1511718317-3381-1-git-send-email-alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This program creates a DCI QP by using the mlx5dv_create_qp() interface.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/examples/dc_send.c | 146 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 146 insertions(+)
 create mode 100644 providers/mlx5/examples/dc_send.c

diff --git a/providers/mlx5/examples/dc_send.c b/providers/mlx5/examples/dc_send.c
new file mode 100644
index 0000000..af2a5b4
--- /dev/null
+++ b/providers/mlx5/examples/dc_send.c
@@ -0,0 +1,146 @@
+#define _GNU_SOURCE
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <string.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <sys/time.h>
+#include <netdb.h>
+#include <malloc.h>
+#include <getopt.h>
+#include <arpa/inet.h>
+#include <time.h>
+#include <verbs.h>
+#include  "mlx5dv.h"
+
+
+static void usage(const char *argv0)
+{
+	printf("Usage:\n");
+	printf("  %s <host>     connect to server at <host>\n", argv0);
+	printf("\n");
+	printf("Options:\n");
+	printf("  -p, --port=<port>      listen on/connect to port <port> (default 18515)\n");
+	printf("  -d, --ib-dev=<dev>     use IB device <dev> (default first device found)\n");
+	printf("  -i, --ib-port=<port>   use port <port> of IB device (default 1)\n");
+}
+
+int main(int argc, char *argv[])
+{
+	char                    *servername = NULL;
+	struct ibv_device      **dev_list;
+	struct ibv_device	*ib_dev;
+	int                      ib_port = 1;
+	char                    *ib_devname = NULL;
+
+	while (1) {
+		int c;
+
+		static struct option long_options[] = {
+			{ .name = "ib-dev",   .has_arg = 1, .val = 'd' },
+			{ .name = "ib-port",  .has_arg = 1, .val = 'i' },
+			{}
+		};
+
+		c = getopt_long(argc, argv, "d:i:", long_options, NULL);
+		if (c == -1)
+			break;
+
+		switch (c) {
+		case 'd':
+			ib_devname = strdupa(optarg);
+			break;
+
+		case 'i':
+			ib_port = strtol(optarg, NULL, 0);
+			if (ib_port < 1) {
+				usage(argv[0]);
+				return 1;
+			}
+			break;
+		default:
+			usage(argv[0]);
+			return 1;
+		}
+	}
+
+	if (optind == argc - 1)
+		servername = strdupa(argv[optind]);
+	else if (optind < argc) {
+		usage(argv[0]);
+		return 1;
+	}
+
+	dev_list = ibv_get_device_list(NULL);
+	if (!dev_list) {
+		perror("Failed to get IB devices list");
+		return 1;
+	}
+
+	if (!ib_devname) {
+		ib_dev = *dev_list;
+		if (!ib_dev) {
+			fprintf(stderr, "No IB devices found\n");
+			return 1;
+		}
+	} else {
+		int i;
+		for (i = 0; dev_list[i]; ++i)
+			if (!strcmp(ibv_get_device_name(dev_list[i]), ib_devname))
+				break;
+		ib_dev = dev_list[i];
+		if (!ib_dev) {
+			fprintf(stderr, "IB device %s not found\n", ib_devname);
+			return 1;
+		}
+	}
+	{
+		struct ibv_context	*context;
+		struct ibv_pd		*pd;
+		struct ibv_cq		*cq;
+		struct ibv_qp		*qp;
+		int			qp_depth = 128;
+		struct ibv_qp_attr	attr;
+		struct ibv_qp_init_attr_ex 	init_attr;
+		struct mlx5dv_qp_init_attr	dv_init_attr;
+
+		context = ibv_open_device(ib_dev);
+		if (!context) {
+			fprintf(stderr, "Couldn't get context for %s\n",
+					ibv_get_device_name(ib_dev));
+			return -1;
+		}
+		pd = ibv_alloc_pd(context);
+		if (!pd) {
+			fprintf(stderr, "Couldn't allocate PD\n");
+			return -1;
+		}
+		cq = ibv_create_cq(context, qp_depth + 1, NULL, NULL, 0);
+		if (cq) {
+			fprintf(stderr, "Couldn't create CQ\n");
+			return -1;
+		}
+
+		init_attr.send_cq = cq;
+		init_attr.recv_cq = cq;
+		init_attr.cap.max_send_wr  = 100; 
+		init_attr.cap.max_send_sge  = 1;
+		init_attr.qp_type = IBV_QPT_VENDOR;
+		init_attr.pd = pd;
+
+		dv_init_attr.vendor_qp_type = MLX5_VENDOR_QPT_DCI;
+		dv_init_attr.dc_ini.mode = MLX5DV_QP_HANDSHAKE_MODE_FULL;
+		dv_init_attr.dc_ini.reverse_cnak_sl = 0;
+
+		qp = mlx5dv_create_qp(context, &init_attr, &dv_init_attr);
+		if (qp) {
+			fprintf(stderr, "Couldn't create QP\n");
+			return -1;
+		}
+		
+		fprintf(stdout, "Success: Create DC send QP\n");
+	}
+	return 0;
+}
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
