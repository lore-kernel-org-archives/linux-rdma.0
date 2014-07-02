From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 2/8] librdmacm: Use SRQ in rdma_create_qp
Date: Tue,  1 Jul 2014 23:11:13 -0700
Message-ID: <1404281479-6755-3-git-send-email-sean.hefty@intel.com>
References: <1404281479-6755-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404281479-6755-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

If an application has allocated an SRQ on an rdma_cm_id, use
it when creating a QP.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/cma.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/src/cma.c b/src/cma.c
index 1a88e5c..192d9ed 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -1303,6 +1303,8 @@ int rdma_create_qp(struct rdma_cm_id *id, struct ibv_pd *pd,
 		qp_init_attr->send_cq = id->send_cq;
 	if (!qp_init_attr->recv_cq)
 		qp_init_attr->recv_cq = id->recv_cq;
+	if (id->srq && !qp_init_attr->srq)
+		qp_init_attr->srq = id->srq;
 	qp = ibv_create_qp(pd, qp_init_attr);
 	if (!qp) {
 		ret = ERR(ENOMEM);
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
