From: "Arlin Davis" <arlin.r.davis@intel.com>
Subject: [PATCH] DAPL v2: dtest, dtestx: remove IB verb definitions
Date: Wed, 30 Sep 2009 15:04:31 -0700
Message-ID: <6DF924A7A42A4E68A8F2217696304884@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ofw-bounces@lists.openfabrics.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: linux-rdma@vger.kernel.org, ofw@lists.openfabrics.org
List-Id: linux-rdma@vger.kernel.org


Remove gid and qp_type references from test app.
Print address infomation in sockaddr and
ucm provider format with qpn and lid.

Signed-off-by: Arlin Davis <arlin.r.davis@intel.com>
---
 test/dtest/dtest.c  |   19 ++++++++-----------
 test/dtest/dtestx.c |   27 +++++++++++----------------
 2 files changed, 19 insertions(+), 27 deletions(-)

diff --git a/test/dtest/dtest.c b/test/dtest/dtest.c
index 75cbe4c..5ac16c4 100755
--- a/test/dtest/dtest.c
+++ b/test/dtest/dtest.c
@@ -100,7 +100,6 @@
 #define MAX_PROCS      1000
 
 /* Header files needed for DAT/uDAPL */
-#include "infiniband/verbs.h"
 #include "dat2/udat.h"
 
 /* definitions */
@@ -219,7 +218,7 @@ union dcm_addr {
 		uint8_t		port_num;
 		uint16_t	lid;
 		uint32_t	qpn;
-		union ibv_gid	gid;
+		uint8_t		gid[16];
 	} ib;
 };
 
@@ -447,15 +446,13 @@ int main(int argc, char **argv)
 		(void*)ia_attr.ia_address_ptr,
 		sizeof(DAT_SOCK_ADDR6));
 
-	if (local.ib.qp_type == IBV_QPT_UD) {
-		ucm = 1;
-		printf("%d Local uCM Address = QPN=0x%x, LID=0x%x\n",
-			getpid(), ntohl(local.ib.qpn),
-			ntohs(local.ib.lid));
-		printf("%d Remote uCM Address = QPN=0x%x, LID=0x%x\n",
-			getpid(), ntohl(remote.ib.qpn),
-			ntohs(remote.ib.lid));
-	}
+	printf("%d Local Address %s port %d\n", getpid(),
+	       inet_ntoa(((struct sockaddr_in *)&local)->sin_addr), 
+	       SERVER_CONN_QUAL);
+
+	printf("%d Local Address QPN=0x%x, LID=0x%x  <<< ucm provider\n",
+		getpid(), ntohl(local.ib.qpn),
+		ntohs(local.ib.lid));
 
 	/* Create Protection Zone */
 	start = get_time();
diff --git a/test/dtest/dtestx.c b/test/dtest/dtestx.c
index 6e17b6d..2132f31 100755
--- a/test/dtest/dtestx.c
+++ b/test/dtest/dtestx.c
@@ -65,7 +65,6 @@
 
 #endif
 
-#include "infiniband/verbs.h"
 #include "dat2/udat.h"
 #include "dat2/dat_ib_extensions.h"
 
@@ -189,7 +188,7 @@ union dcm_addr {
 		uint8_t		port_num;
 		uint16_t	lid;
 		uint32_t	qpn;
-		union ibv_gid	gid;
+		uint8_t		gid[16];
 	} ib;
 };
 
@@ -444,24 +443,20 @@ int connect_ep(char *hostname)
 		(void*)ia_attr.ia_address_ptr,
 		sizeof(DAT_SOCK_ADDR6));
 
-	if (local.ib.qp_type == IBV_QPT_UD) {
-		ucm = 1;
+        printf("%d Local Address %s port %d\n", getpid(),
+               inet_ntoa(((struct sockaddr_in *)&local)->sin_addr),
+               SERVER_ID);
 
-		if (ud_test) {
-			printf("%d UD test over UCM provider not supported\n",
-				getpid());
-			exit(1);
-		}
+        printf("%d Local Address QPN=0x%x, LID=0x%x <<< ucm provider\n",
+                getpid(), ntohl(local.ib.qpn),
+                ntohs(local.ib.lid));
 
-		printf("%d Local uCM Address = QPN=0x%x, LID=0x%x\n",
-			getpid(), ntohl(local.ib.qpn),
-			ntohs(local.ib.lid));
-		printf("%d Remote uCM Address = QPN=0x%x, LID=0x%x\n",
-			getpid(), ntohl(remote.ib.qpn),
-			ntohs(remote.ib.lid));
+	if (ucm && ud_test) {
+		printf("%d UD test over UCM provider not supported\n",
+			getpid());
+		exit(1);
 	}
 
-
 	/* Print provider specific attributes */
 	for (i = 0; i < prov_attrs.num_provider_specific_attr; i++) {
 		LOGPRINTF(" Provider Specific Attribute[%d] %s=%s\n",
-- 
1.5.2.5
