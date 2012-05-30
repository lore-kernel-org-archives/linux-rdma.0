From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 15/16] librdmacm/rstream: Use snprintf in place of sprintf
Date: Wed, 30 May 2012 17:21:45 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A24C2F@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid possible buffer overrun.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 examples/rstream.c |   38 +++++++++++++++++++++-----------------
 1 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/examples/rstream.c b/examples/rstream.c
index df36e34..054d11e 100644
--- a/examples/rstream.c
+++ b/examples/rstream.c
@@ -82,7 +82,7 @@ static int iterations = 1;
 static int transfer_size = 1000;
 static int transfer_count = 1000;
 static int buffer_size;
-static char test_name[9] = "custom";
+static char test_name[10] = "custom";
 static char *port = "7471";
 static char *dst_addr;
 static char *src_addr;
@@ -105,7 +105,7 @@ static void *buf;
 #define rs_getsockopt(s,l,n,v,ol) \
 	use_rs ? rgetsockopt(s,l,n,v,ol) : getsockopt(s,l,n,v,ol)
 
-static void size_str(char *str, long long size)
+static void size_str(char *str, size_t ssize, long long size)
 {
 	long long base, fraction = 0;
 	char mag;
@@ -127,22 +127,22 @@ static void size_str(char *str, long long size)
 	if (size / base < 10)
 		fraction = (size % base) * 10 / base;
 	if (fraction) {
-		sprintf(str, "%lld.%lld%c", size / base, fraction, mag);
+		snprintf(str, ssize, "%lld.%lld%c", size / base, fraction, mag);
 	} else {
-		sprintf(str, "%lld%c", size / base, mag);
+		snprintf(str, ssize, "%lld%c", size / base, mag);
 	}
 }
 
-static void cnt_str(char *str, long long cnt)
+static void cnt_str(char *str, size_t ssize, long long cnt)
 {
 	if (cnt >= 1000000000)
-		sprintf(str, "%lldb", cnt / 1000000000);
+		snprintf(str, ssize, "%lldb", cnt / 1000000000);
 	else if (cnt >= 1000000)
-		sprintf(str, "%lldm", cnt / 1000000);
+		snprintf(str, ssize, "%lldm", cnt / 1000000);
 	else if (cnt >= 1000)
-		sprintf(str, "%lldk", cnt / 1000);
+		snprintf(str, ssize, "%lldk", cnt / 1000);
 	else
-		sprintf(str, "%lld", cnt);
+		snprintf(str, ssize, "%lld", cnt);
 }
 
 static void show_perf(void)
@@ -156,13 +156,13 @@ static void show_perf(void)
 
 	/* name size transfers iterations bytes seconds Gb/sec usec/xfer */
 	printf("%-10s", test_name);
-	size_str(str, transfer_size);
+	size_str(str, sizeof str, transfer_size);
 	printf("%-8s", str);
-	cnt_str(str, transfer_count);
+	cnt_str(str, sizeof str, transfer_count);
 	printf("%-8s", str);
-	cnt_str(str, iterations);
+	cnt_str(str, sizeof str, iterations);
 	printf("%-8s", str);
-	size_str(str, bytes);
+	size_str(str, sizeof str, bytes);
 	printf("%-8s", str);
 	printf("%8.2fs%10.2f%11.2f\n",
 		usec / 1000000., (bytes * 8) / (1000. * usec),
@@ -185,8 +185,10 @@ static int size_to_count(int size)
 
 static void init_latency_test(int size)
 {
-	size_str(test_name, size);
-	sprintf(test_name, "%s_lat", test_name);
+	char sstr[5];
+
+	size_str(sstr, sizeof sstr, size);
+	snprintf(test_name, sizeof test_name, "%s_lat", sstr);
 	transfer_count = 1;
 	transfer_size = size;
 	iterations = size_to_count(transfer_size);
@@ -194,8 +196,10 @@ static void init_latency_test(int size)
 
 static void init_bandwidth_test(int size)
 {
-	size_str(test_name, size);
-	sprintf(test_name, "%s_bw", test_name);
+	char sstr[5];
+
+	size_str(sstr, sizeof sstr, size);
+	snprintf(test_name, sizeof test_name, "%s_bw", sstr);
 	iterations = 1;
 	transfer_size = size;
 	transfer_count = size_to_count(transfer_size);


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
