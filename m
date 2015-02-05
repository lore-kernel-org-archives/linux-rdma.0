From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 for-next 4/5] IB/core: Make sure that the PSN does not overflow
Date: Thu,  5 Feb 2015 12:12:17 +0200
Message-ID: <1423131138-19060-5-git-send-email-ogerlitz@mellanox.com>
References: <1423131138-19060-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423131138-19060-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The rq/sq->psn is 24 bits as defined in the IB spec, therefore ULPs and User
space applications shouldn't use the 8 most significant bits in the 32 bits
variables to avoid overflow in modify_qp.

Fixed the PSN generation by the RDMA-CM to mask out the 8 most significant bits,
also mask out these bits in uverbs for attributes provided by user-space.

issue: 416925
Change-Id: I7db9acc42564462de15bae84f4c512233fa8a62c
Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cma.c        |    1 +
 drivers/infiniband/core/uverbs_cmd.c |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index d570030..fab0ee5 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -512,6 +512,7 @@ struct rdma_cm_id *rdma_create_id(rdma_cm_event_handler event_handler,
 	INIT_LIST_HEAD(&id_priv->listen_list);
 	INIT_LIST_HEAD(&id_priv->mc_list);
 	get_random_bytes(&id_priv->seq_num, sizeof id_priv->seq_num);
+	id_priv->seq_num &= 0xffffff;
 
 	return &id_priv->id;
 }
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 532d8eb..ecb6430 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2053,8 +2053,8 @@ ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
 	attr->path_mtu 		  = cmd.path_mtu;
 	attr->path_mig_state 	  = cmd.path_mig_state;
 	attr->qkey 		  = cmd.qkey;
-	attr->rq_psn 		  = cmd.rq_psn;
-	attr->sq_psn 		  = cmd.sq_psn;
+	attr->rq_psn              = cmd.rq_psn & 0xffffff;
+	attr->sq_psn              = cmd.sq_psn & 0xffffff;
 	attr->dest_qp_num 	  = cmd.dest_qp_num;
 	attr->qp_access_flags 	  = cmd.qp_access_flags;
 	attr->pkey_index 	  = cmd.pkey_index;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
