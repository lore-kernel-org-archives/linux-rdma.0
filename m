From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 11/16] librdmacm/rs-preload: Use environment variable to set
 QP size
Date: Wed, 30 May 2012 17:21:44 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A24C19@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Allow the user to specify the size of the send/receive queues
and inline data size through environment variables:
RS_SQ_SIZE, RS_RQ_SIZE, and RS_INLINE.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/preload.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/src/preload.c b/src/preload.c
index 99afd26..d21389f 100644
--- a/src/preload.c
+++ b/src/preload.c
@@ -97,6 +97,10 @@ static int (*real_fcntl)(int socket, int cmd, ... /* arg */);
 static struct index_map idm;
 static pthread_mutex_t mut = PTHREAD_MUTEX_INITIALIZER;
 
+static int sq_size;
+static int rq_size;
+static int sq_inline;
+
 enum fd_type {
 	fd_normal,
 	fd_rsocket
@@ -196,6 +200,23 @@ static enum fd_type fd_close(int index, int *fd)
 	return type;
 }
 
+void getenv_options(void)
+{
+	char *var;
+
+	var = getenv("RS_SQ_SIZE");
+	if (var)
+		sq_size = atoi(var);
+
+	var = getenv("RS_RQ_SIZE");
+	if (var)
+		rq_size = atoi(var);
+
+	var = getenv("RS_INLINE");
+	if (var)
+		sq_inline = atoi(var);
+}
+
 static void init_preload(void)
 {
 	static int init;
@@ -231,6 +252,8 @@ static void init_preload(void)
 	real_setsockopt = dlsym(RTLD_NEXT, "setsockopt");
 	real_getsockopt = dlsym(RTLD_NEXT, "getsockopt");
 	real_fcntl = dlsym(RTLD_NEXT, "fcntl");
+
+	getenv_options();
 	init = 1;
 out:
 	pthread_mutex_unlock(&mut);
@@ -285,6 +308,21 @@ err:
 	return ret;
 }
 
+/*
+ * Use defaults on failure.
+ */
+void set_rsocket_options(int rsocket)
+{
+	if (sq_size)
+		rsetsockopt(rsocket, SOL_RDMA, RDMA_SQSIZE, &sq_size, sizeof sq_size);
+
+	if (rq_size)
+		rsetsockopt(rsocket, SOL_RDMA, RDMA_RQSIZE, &rq_size, sizeof rq_size);
+
+	if (sq_inline)
+		rsetsockopt(rsocket, SOL_RDMA, RDMA_INLINE, &sq_inline, sizeof sq_inline);
+}
+
 int socket(int domain, int type, int protocol)
 {
 	static __thread int recursive;
@@ -303,6 +341,7 @@ int socket(int domain, int type, int protocol)
 	recursive = 0;
 	if (ret >= 0) {
 		fd_store(index, ret, fd_rsocket);
+		set_rsocket_options(ret);
 		return index;
 	}
 	fd_close(index, &ret);


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
