From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] librdmacm: Mckey test support for send only full member
Date: Tue, 14 Nov 2017 12:57:22 -0600
Message-ID: <20171114185739.923017203@linux.com>
References: <20171114185720.609975150@linux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=0002-librdmacm-Mckey-test-support-for-send-only-full-memb.patch
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/2] librdmacm: Mckey test support for send only full member

Use rdma_join_multicast_ex instead of rdma_join_multicast.
Added a new flag to -o to mckey, this flag will allow mckey
to join a MC as Send Only Full Member.

Signed-off-by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>

---
 librdmacm/examples/mckey.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/librdmacm/examples/mckey.c b/librdmacm/examples/mckey.c
index 60cf8a2..d2b1aeb 100644
--- a/librdmacm/examples/mckey.c
+++ b/librdmacm/examples/mckey.c
@@ -77,6 +77,7 @@ static int connections = 1;
 static int message_size = 100;
 static int message_count = 10;
 static int is_sender;
+static int send_only = 0;
 static int unmapped_addr;
 static char *dst_addr;
 static char *src_addr;
@@ -241,6 +242,7 @@ static void connect_error(void)
 static int addr_handler(struct cmatest_node *node)
 {
 	int ret;
+	struct rdma_cm_join_mc_attr_ex mc_attr;
 
 	ret = verify_test_params(node);
 	if (ret)
@@ -256,7 +258,13 @@ static int addr_handler(struct cmatest_node *node)
 			goto err;
 	}
 
-	ret = rdma_join_multicast(node->cma_id, test.dst_addr, node);
+	mc_attr.comp_mask = RDMA_CM_JOIN_MC_ATTR_ADDRESS | RDMA_CM_JOIN_MC_ATTR_JOIN_FLAGS;
+	mc_attr.addr = test.dst_addr;
+	mc_attr.join_flags = send_only ? RDMA_MC_JOIN_FLAG_SENDONLY_FULLMEMBER : \
+					 RDMA_MC_JOIN_FLAG_FULLMEMBER;
+
+	ret = rdma_join_multicast_ex(node->cma_id, &mc_attr, node);
+
 	if (ret) {
 		perror("mckey: failure joining");
 		goto err;
@@ -555,8 +563,7 @@ int main(int argc, char **argv)
 {
 	int op, ret;
 
-
-	while ((op = getopt(argc, argv, "m:M:sb:c:C:S:p:")) != -1) {
+	while ((op = getopt(argc, argv, "m:M:sb:c:C:S:p:o")) != -1) {
 		switch (op) {
 		case 'm':
 			dst_addr = optarg;
@@ -584,6 +591,10 @@ int main(int argc, char **argv)
 		case 'p':
 			port_space = strtol(optarg, NULL, 0);
 			break;
+                case 'o':
+                        send_only = 1;
+                        break;
+
 		default:
 			printf("usage: %s\n", argv[0]);
 			printf("\t-m multicast_address\n");
@@ -596,6 +607,7 @@ int main(int argc, char **argv)
 			printf("\t[-S message_size]\n");
 			printf("\t[-p port_space - %#x for UDP (default), "
 			       "%#x for IPOIB]\n", RDMA_PS_UDP, RDMA_PS_IPOIB);
+			printf("\t[-o join as sendonly fullmember]\n");
 			exit(1);
 		}
 	}
-- 
1.7.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
