From: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH infiniband-diags] libibnetdisc/ibnetdisc.c: improve log
 information to stdout
Date: Thu, 2 Jan 2014 08:44:15 +0200
Message-ID: <20140102064415.GA4568@r-ufm96.mtr.labs.mlnx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Write to stdout the route-path when smp returns
with status error.

Signed-off-by: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibnetdisc/src/internal.h  |   10 +++++++---
 libibnetdisc/src/query_smp.c |    6 ++++++
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/libibnetdisc/src/internal.h b/libibnetdisc/src/internal.h
index 1ccd29c..47b2a4c 100644
--- a/libibnetdisc/src/internal.h
+++ b/libibnetdisc/src/internal.h
@@ -42,12 +42,16 @@
 #include <complib/cl_qmap.h>
 #include <glib.h>
 
+#define	IBND_ERROR(fmt, ...) \
+		fprintf(stderr, "%s:%u; " fmt, __FILE__, __LINE__, ## __VA_ARGS__)
+
+#define	IBND_INFO(fmt, ...) \
+		printf("%s:%u; " fmt, __FILE__, __LINE__, ## __VA_ARGS__);
+
 #define	IBND_DEBUG(fmt, ...) \
 	if (ibdebug) { \
-		printf("%s:%u; " fmt, __FILE__, __LINE__, ## __VA_ARGS__); \
+		IBND_INFO(fmt,## __VA_ARGS__); \
 	}
-#define	IBND_ERROR(fmt, ...) \
-		fprintf(stderr, "%s:%u; " fmt, __FILE__, __LINE__, ## __VA_ARGS__)
 
 /* HASH table defines */
 #define HASHGUID(guid) ((uint32_t)(((uint32_t)(guid) * 101) ^ ((uint32_t)((guid) >> 32) * 103)))
diff --git a/libibnetdisc/src/query_smp.c b/libibnetdisc/src/query_smp.c
index 28620b4..ac4984e 100644
--- a/libibnetdisc/src/query_smp.c
+++ b/libibnetdisc/src/query_smp.c
@@ -192,6 +192,9 @@ static int process_one_recv(smp_engine_t * engine)
 		goto error;
 
 	if ((status = umad_status(umad))) {
+		IBND_INFO("umad (%s Attr 0x%x:%u) bad status %d; %s\n",
+			   portid2str(&smp->path), smp->rpc.attr.id,
+			   smp->rpc.attr.mod, status, strerror(status));
 		IBND_ERROR("umad (%s Attr 0x%x:%u) bad status %d; %s\n",
 			   portid2str(&smp->path), smp->rpc.attr.id,
 			   smp->rpc.attr.mod, status, strerror(status));
@@ -199,6 +202,9 @@ static int process_one_recv(smp_engine_t * engine)
 			rc = mlnx_ext_port_info_err(engine, smp, mad,
 						    smp->cb_data);
 	} else if ((status = mad_get_field(mad, 0, IB_DRSMP_STATUS_F))) {
+		IBND_INFO("mad (%s Attr 0x%x:%u) bad status 0x%x\n",
+			   portid2str(&smp->path), smp->rpc.attr.id,
+			   smp->rpc.attr.mod, status);
 		IBND_ERROR("mad (%s Attr 0x%x:%u) bad status 0x%x\n",
 			   portid2str(&smp->path), smp->rpc.attr.id,
 			   smp->rpc.attr.mod, status);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
