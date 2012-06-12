From: Bernhard Reutner-Fischer <rep.dot.nop-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] perftest: Fix typo in informational string
Date: Tue, 12 Jun 2012 14:03:28 +0200
Message-ID: <1339502608-26453-1-git-send-email-rep.dot.nop@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bernhard Reutner-Fischer <rep.dot.nop-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ido Shamay <idos-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

s/deivce/device/g

Signed-off-by: Bernhard Reutner-Fischer <rep.dot.nop-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 atomic_lat.c          |    2 +-
 perftest_parameters.h |    2 +-
 perftest_resources.h  |    4 ++--
 read_lat.c            |    2 +-
 send_bw.c             |    2 +-
 send_lat.c            |    2 +-
 write_bw.c            |    2 +-
 write_bw_postlist.c   |    2 +-
 write_lat.c           |    2 +-
 9 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/atomic_lat.c b/atomic_lat.c
index 4c394ac..d19d594 100644
--- a/atomic_lat.c
+++ b/atomic_lat.c
@@ -325,7 +325,7 @@ int __cdecl main(int argc, char *argv[]) {
 	// Finding the IB device selected (or defalut if no selected).
 	ib_dev = ctx_find_dev(user_param.ib_devname);
 	if (!ib_dev) {
-		fprintf(stderr," Unable to find the Infiniband/RoCE deivce\n");
+		fprintf(stderr," Unable to find the Infiniband/RoCE device\n");
 		return FAILURE;
 	}
 
diff --git a/perftest_parameters.h b/perftest_parameters.h
index 65dee5c..56165d9 100644
--- a/perftest_parameters.h
+++ b/perftest_parameters.h
@@ -256,7 +256,7 @@ int parser(struct perftest_parameters *user_param,char *argv[], int argc);
  *
  * Parameters :
  *
- *	 context    - Context of the deivce.
+ *	 context    - Context of the device.
  *	 user_param - Perftest parameters.
  *
  * Return Value : SUCCESS, FAILURE.
diff --git a/perftest_resources.h b/perftest_resources.h
index a088258..658f840 100644
--- a/perftest_resources.h
+++ b/perftest_resources.h
@@ -185,9 +185,9 @@ int check_add_port(char **service,int port,
  *
  * Parameters : 
  *	
- *	ib_devname - The name of the deivce requested or NULL for the first one.
+ *	ib_devname - The name of the device requested or NULL for the first one.
  *
- * Return Value : the deivce or NULL in case of failure.
+ * Return Value : the device or NULL in case of failure.
  */
 struct ibv_device* ctx_find_dev(const char *ib_devname);
 
diff --git a/read_lat.c b/read_lat.c
index f9343de..b8a282e 100644
--- a/read_lat.c
+++ b/read_lat.c
@@ -314,7 +314,7 @@ int __cdecl main(int argc, char *argv[]) {
 	// Finding the IB device selected (or defalut if no selected).
 	ib_dev = ctx_find_dev(user_param.ib_devname);
 	if (!ib_dev) {
-		fprintf(stderr," Unable to find the Infiniband/RoCE deivce\n");
+		fprintf(stderr," Unable to find the Infiniband/RoCE device\n");
 		return FAILURE;
 	}
 
diff --git a/send_bw.c b/send_bw.c
index 58c394a..a217b04 100644
--- a/send_bw.c
+++ b/send_bw.c
@@ -693,7 +693,7 @@ int __cdecl main(int argc, char *argv[]) {
 	// Finding the IB device selected (or defalut if no selected).
 	ib_dev = ctx_find_dev(user_param.ib_devname);
 	if (!ib_dev) {
-		fprintf(stderr," Unable to find the Infiniband/RoCE deivce\n");
+		fprintf(stderr," Unable to find the Infiniband/RoCE device\n");
 		return 1;
 	}
 
diff --git a/send_lat.c b/send_lat.c
index c1d5572..1445a34 100644
--- a/send_lat.c
+++ b/send_lat.c
@@ -673,7 +673,7 @@ int __cdecl main(int argc, char *argv[]) {
 	// Finding the IB device selected (or defalut if no selected).
 	ib_dev = ctx_find_dev(user_param.ib_devname);
 	if (!ib_dev) {
-		fprintf(stderr," Unable to find the Infiniband/RoCE deivce\n");
+		fprintf(stderr," Unable to find the Infiniband/RoCE device\n");
 		return 1;
 	}
 
diff --git a/write_bw.c b/write_bw.c
index 6c3746e..71064c2 100644
--- a/write_bw.c
+++ b/write_bw.c
@@ -322,7 +322,7 @@ int __cdecl main(int argc, char *argv[]) {
 	// Finding the IB device selected (or defalut if no selected).
 	ib_dev = ctx_find_dev(user_param.ib_devname);
 	if (!ib_dev) {
-		fprintf(stderr," Unable to find the Infiniband/RoCE deivce\n");
+		fprintf(stderr," Unable to find the Infiniband/RoCE device\n");
 		return 1;
 	}
 
diff --git a/write_bw_postlist.c b/write_bw_postlist.c
index 54f7689..53e0fda 100644
--- a/write_bw_postlist.c
+++ b/write_bw_postlist.c
@@ -282,7 +282,7 @@ int main(int argc, char *argv[]) {
 	// Finding the IB device selected (or defalut if no selected).
 	ib_dev = ctx_find_dev(user_param.ib_devname);
 	if (!ib_dev) {
-		fprintf(stderr," Unable to find the Infiniband/RoCE deivce\n");
+		fprintf(stderr," Unable to find the Infiniband/RoCE device\n");
 		return 1;
 	}
 
diff --git a/write_lat.c b/write_lat.c
index 7db9644..14ad1e3 100644
--- a/write_lat.c
+++ b/write_lat.c
@@ -347,7 +347,7 @@ int __cdecl main(int argc, char *argv[]) {
 	// Finding the IB device selected (or defalut if no selected).
 	ib_dev = ctx_find_dev(user_param.ib_devname);
 	if (!ib_dev) {
-		fprintf(stderr," Unable to find the Infiniband/RoCE deivce\n");
+		fprintf(stderr," Unable to find the Infiniband/RoCE device\n");
 		return FAILURE;
 	}
 
-- 
1.7.10

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
