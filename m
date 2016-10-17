From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 12/13] ibacm: mark symbols static where possible
Date: Mon, 17 Oct 2016 21:11:21 +0200
Message-ID: <1476731482-26491-13-git-send-email-hch@lst.de>
References: <1476731482-26491-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476731482-26491-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 ibacm/prov/acmp/src/acmp.c | 2 +-
 ibacm/src/acm.c            | 2 +-
 ibacm/src/acme.c           | 6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/ibacm/prov/acmp/src/acmp.c b/ibacm/prov/acmp/src/acmp.c
index 1e37ee4..2ca0bf5 100644
--- a/ibacm/prov/acmp/src/acmp.c
+++ b/ibacm/prov/acmp/src/acmp.c
@@ -259,7 +259,7 @@ static atomic_t wait_cnt;
 static pthread_t retry_thread_id;
 static int retry_thread_started = 0;
 
-__thread char log_data[ACM_MAX_ADDRESS];
+static __thread char log_data[ACM_MAX_ADDRESS];
 
 /*
  * Service options - may be set through ibacm_opts.cfg file.
diff --git a/ibacm/src/acm.c b/ibacm/src/acm.c
index 0571363..b7f1dc0 100644
--- a/ibacm/src/acm.c
+++ b/ibacm/src/acm.c
@@ -186,7 +186,7 @@ static struct acmc_client client_array[FD_SETSIZE - 1];
 
 static FILE *flog;
 static pthread_mutex_t log_lock;
-__thread char log_data[ACM_MAX_ADDRESS];
+static __thread char log_data[ACM_MAX_ADDRESS];
 static atomic_t counter[ACM_MAX_COUNTER];
 
 static struct acmc_device *
diff --git a/ibacm/src/acme.c b/ibacm/src/acme.c
index 5a571cf..36221f4 100644
--- a/ibacm/src/acme.c
+++ b/ibacm/src/acme.c
@@ -69,10 +69,10 @@ enum perf_query_output {
 	PERF_QUERY_EP_ADDR
 };
 static enum perf_query_output perf_query;
-int verbose;
+static int verbose;
 
-struct ibv_context **verbs;
-int dev_cnt;
+static struct ibv_context **verbs;
+static int dev_cnt;
 
 #define VPRINT(format, ...) do { if (verbose) printf(format, ## __VA_ARGS__ ); } while (0)
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
