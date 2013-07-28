From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 2/4] cma: Remove the unused variable 'id_priv'
Date: Sun, 28 Jul 2013 11:19:15 +0200
Message-ID: <51F4E213.60805@acm.org>
References: <51F4E1B2.7070203@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51F4E1B2.7070203-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The variable 'id_priv' is assigned a value but is never used.
This triggers the following compiler warning:

src/cma.c:1178:25: warning: variable 'id_priv' set but not used [-Wunused-but-set-variable]

Hence remove this variable.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 src/cma.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/src/cma.c b/src/cma.c
index baebecd..374844c 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -1175,11 +1175,9 @@ err:
 int rdma_create_srq(struct rdma_cm_id *id, struct ibv_pd *pd,
 		    struct ibv_srq_init_attr *attr)
 {
-	struct cma_id_private *id_priv;
 	struct ibv_srq *srq;
 	int ret;
 
-	id_priv = container_of(id, struct cma_id_private, id);
 	if (!pd)
 		pd = id->pd;
 
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
