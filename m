From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 25/37] librdmacm: auto create QPs in rdma_get_request
Date: Wed, 7 Apr 2010 10:12:43 -0700
Message-ID: <E10A47D54C0842CFA80808A31C7C8E64@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
References: 
In-Reply-To: 
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If the user passed initial QP attributes into rdma_create_ep,
allocate a QP for the user as part of rdma_get_request.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 src/cma.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/src/cma.c b/src/cma.c
index c59f47b..1cc4f1f 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -1287,6 +1287,12 @@ int rdma_get_request(struct rdma_cm_id *listen, struct rdma_cm_id **id)
 		goto err;
 	}
 
+	if (id_priv->qp_init_attr) {
+		ret = rdma_create_qp(event->id, id_priv->pd, id_priv->qp_init_attr);
+		if (ret)
+			goto err;
+	}
+
 	*id = event->id;
 	(*id)->event = event;
 	return 0;



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
