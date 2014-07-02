From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 4/8] rdmacm: Add functionality to allocate an XRCD
Date: Tue,  1 Jul 2014 23:11:15 -0700
Message-ID: <1404281479-6755-5-git-send-email-sean.hefty@intel.com>
References: <1404281479-6755-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404281479-6755-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

XRC QPs and SRQs are associated by an XRC domain.  Provide a
call to allocate an XRCD, similar to how the rdmacm allocates
a PD for the user.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/cma.c |   22 +++++++++++++++++++++-
 1 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/src/cma.c b/src/cma.c
index 192d9ed..52d81ff 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -76,6 +76,7 @@ do {						\
 struct cma_device {
 	struct ibv_context *verbs;
 	struct ibv_pd	   *pd;
+	struct ibv_xrcd    *xrcd;
 	uint64_t	    guid;
 	int		    port_cnt;
 	int		    refcnt;
@@ -439,9 +440,28 @@ out:
 static void ucma_put_device(struct cma_device *cma_dev)
 {
 	pthread_mutex_lock(&mut);
-	if (!--cma_dev->refcnt)
+	if (!--cma_dev->refcnt) {
 		ibv_dealloc_pd(cma_dev->pd);
+		if (cma_dev->xrcd)
+			ibv_close_xrcd(cma_dev->xrcd);
+	}
+	pthread_mutex_unlock(&mut);
+}
+
+static struct ibv_xrcd *ucma_get_xrcd(struct cma_device *cma_dev)
+{
+	struct ibv_xrcd_init_attr attr;
+
+	pthread_mutex_lock(&mut);
+	if (!cma_dev->xrcd) {
+		memset(&attr, 0, sizeof attr);
+		attr.comp_mask = IBV_XRCD_INIT_ATTR_FD | IBV_XRCD_INIT_ATTR_OFLAGS;
+		attr.fd = -1;
+		attr.oflags = O_CREAT;
+		cma_dev->xrcd = ibv_open_xrcd(cma_dev->verbs, &attr);
+	}
 	pthread_mutex_unlock(&mut);
+	return cma_dev->xrcd;
 }
 
 static void ucma_insert_id(struct cma_id_private *id_priv)
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
