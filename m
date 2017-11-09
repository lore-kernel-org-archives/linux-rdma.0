From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] librdmacm: mckey test with rdma_join_multicast_ex
Date: Thu, 09 Nov 2017 11:16:11 -0600
Message-ID: <20171109171618.963310045@linux.com>
References: <20171109171609.169281977@linux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=0002-librdmacm-add-test-code
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/2] librdmacm: mckey test with rdma_join_multicast_ex

This is a temporary commit modifying mckey to run
rdma_join_multicast_ex instead of rdma_join_multicast.
Added a new flag to -o to mckey, this flag will allow mckey
to join a MC as Send Only Full Member.

Tested-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>

---

Index: rdma-core/librdmacm/examples/mckey.c
===================================================================
--- rdma-core.orig/librdmacm/examples/mckey.c
+++ rdma-core/librdmacm/examples/mckey.c
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
+	struct rdma_cm_join_mc_attr_ex my_attr;
 
 	ret = verify_test_params(node);
 	if (ret)
@@ -256,7 +258,13 @@ static int addr_handler(struct cmatest_n
 			goto err;
 	}
 
-	ret = rdma_join_multicast(node->cma_id, test.dst_addr, node);
+	my_attr.comp_mask = RDMA_CM_JOIN_MC_ATTR_ADDRESS | RDMA_CM_JOIN_MC_ATTR_JOIN_FLAGS;
+	my_attr.addr = test.dst_addr;
+	my_attr.join_flags = send_only ? RDMA_MC_JOIN_FLAG_SENDONLY_FULLMEMBER : \
+					 RDMA_MC_JOIN_FLAG_FULLMEMBER;
+
+	ret = rdma_join_multicast_ex(node->cma_id, &my_attr, node);
+
 	if (ret) {
 		perror("mckey: failure joining");
 		goto err;
@@ -555,9 +563,12 @@ int main(int argc, char **argv)
 {
 	int op, ret;
 
-
-	while ((op = getopt(argc, argv, "m:M:sb:c:C:S:p:")) != -1) {
+	while ((op = getopt(argc, argv, "m:M:sb:c:C:S:p:o")) != -1) {
 		switch (op) {
+		case 'o':
+			puts("Will join as send only full member");
+			send_only = 1;
+			break;
 		case 'm':
 			dst_addr = optarg;
 			break;
@@ -596,6 +607,7 @@ int main(int argc, char **argv)
 			printf("\t[-S message_size]\n");
 			printf("\t[-p port_space - %#x for UDP (default), "
 			       "%#x for IPOIB]\n", RDMA_PS_UDP, RDMA_PS_IPOIB);
+			printf("\t[-o use sendonly fullmember]\n");
 			exit(1);
 		}
 	}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
