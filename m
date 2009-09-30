From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/4] dapl/dtest: remove direct include of infiniband/verbs.h
Date: Wed, 30 Sep 2009 16:13:04 -0700
Message-ID: <F9C156C6B6A34461826AD1BA8274E8FE@amr.corp.intel.com>
References: <E61D2EAC1B404A49ACB04B4092C00BEC@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E61D2EAC1B404A49ACB04B4092C00BEC-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

dtest* include a provider header file directly.  Avoid this.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 test/dtest/dtest.c   |   18 +++++++-----------
 test/dtest/dtestcm.c |   18 +++++++-----------
 test/dtest/dtestx.c  |   26 +++++++-------------------
 3 files changed, 21 insertions(+), 41 deletions(-)

diff --git a/test/dtest/dtest.c b/test/dtest/dtest.c
index 75cbe4c..22999f7 100755
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
 
@@ -447,15 +446,12 @@ int main(int argc, char **argv)
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
+        printf("%d Local Address %s port %d\n", getpid(),
+               inet_ntoa(((struct sockaddr_in *) &local)->sin_addr),
+               ((struct sockaddr_in *) &local)->sin_port);
+	printf("%d Local Address QPN=0x%x, LID=0x%x\n", 
+		getpid(), ntohl(local.ib.qpn), 
+		ntohs(local.ib.lid));
 
 	/* Create Protection Zone */
 	start = get_time();
diff --git a/test/dtest/dtestcm.c b/test/dtest/dtestcm.c
index 5b0272a..427a25e 100644
--- a/test/dtest/dtestcm.c
+++ b/test/dtest/dtestcm.c
@@ -97,7 +97,6 @@
 #define MAX_POLLING_CNT 50000
 
 /* Header files needed for DAT/uDAPL */
-#include "infiniband/verbs.h"
 #include "dat2/udat.h"
 #include "dat2/dat_ib_extensions.h"
 
@@ -109,7 +108,7 @@ union dcm_addr {
 		uint8_t		port_num;
 		uint16_t	lid;
 		uint32_t	qpn;
-		union ibv_gid	gid;
+		uint8_t		gid[16];
 	} ib;
 };
 
@@ -338,15 +337,12 @@ int main(int argc, char **argv)
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
+        printf("%d Local Address %s port %d\n", getpid(),
+               inet_ntoa(((struct sockaddr_in *) &local)->sin_addr),
+               ((struct sockaddr_in *) &local)->sin_port);
+	printf("%d Local Address QPN=0x%x, LID=0x%x\n", 
+		getpid(), ntohl(local.ib.qpn), 
+		ntohs(local.ib.lid));
 
 	/* Create Protection Zone */
 	start = get_time();
diff --git a/test/dtest/dtestx.c b/test/dtest/dtestx.c
index 6e17b6d..f41ad66 100755
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
+		uint8_t 	gid[16];
 	} ib;
 };
 
@@ -444,23 +443,12 @@ int connect_ep(char *hostname)
 		(void*)ia_attr.ia_address_ptr,
 		sizeof(DAT_SOCK_ADDR6));
 
-	if (local.ib.qp_type == IBV_QPT_UD) {
-		ucm = 1;
-
-		if (ud_test) {
-			printf("%d UD test over UCM provider not supported\n",
-				getpid());
-			exit(1);
-		}
-
-		printf("%d Local uCM Address = QPN=0x%x, LID=0x%x\n",
-			getpid(), ntohl(local.ib.qpn),
-			ntohs(local.ib.lid));
-		printf("%d Remote uCM Address = QPN=0x%x, LID=0x%x\n",
-			getpid(), ntohl(remote.ib.qpn),
-			ntohs(remote.ib.lid));
-	}
-
+        printf("%d Local Address %s port %d\n", getpid(),
+               inet_ntoa(((struct sockaddr_in *) &local)->sin_addr),
+               ((struct sockaddr_in *) &local)->sin_port);
+	printf("%d Local Address QPN=0x%x, LID=0x%x\n", 
+		getpid(), ntohl(local.ib.qpn), 
+		ntohs(local.ib.lid));
 
 	/* Print provider specific attributes */
 	for (i = 0; i < prov_attrs.num_provider_specific_attr; i++) {



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
