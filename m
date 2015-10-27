From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 libmlx4 6/7] Add support for different poll_one_ex functions
Date: Tue, 27 Oct 2015 19:08:56 +0200
Message-ID: <1445965737-14187-7-git-send-email-matanb@mellanox.com>
References: <1445965737-14187-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445965737-14187-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In order to opitimize the poll_one extended verb for different
wc_flags, add support for poll_one_ex callback function.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/cq.c    | 5 +++--
 src/mlx4.h  | 5 +++++
 src/verbs.c | 1 +
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/src/cq.c b/src/cq.c
index 7f40f12..1f2d572 100644
--- a/src/cq.c
+++ b/src/cq.c
@@ -601,7 +601,8 @@ int mlx4_poll_cq_ex(struct ibv_cq *ibcq,
 	int npolled;
 	int err = CQ_OK;
 	unsigned int ne = attr->max_entries;
-	uint64_t wc_flags = cq->wc_flags;
+	int (*poll_fn)(struct mlx4_cq *cq, struct mlx4_qp **cur_qp,
+		       struct ibv_wc_ex **wc_ex) = cq->mlx4_poll_one;
 
 	if (attr->comp_mask)
 		return -EINVAL;
@@ -609,7 +610,7 @@ int mlx4_poll_cq_ex(struct ibv_cq *ibcq,
 	pthread_spin_lock(&cq->lock);
 
 	for (npolled = 0; npolled < ne; ++npolled) {
-		err = _mlx4_poll_one_ex(cq, &qp, &wc, wc_flags);
+		err = poll_fn(cq, &qp, &wc);
 		if (err != CQ_OK)
 			break;
 	}
diff --git a/src/mlx4.h b/src/mlx4.h
index 8e1935d..46a18d6 100644
--- a/src/mlx4.h
+++ b/src/mlx4.h
@@ -215,6 +215,8 @@ struct mlx4_pd {
 struct mlx4_cq {
 	struct ibv_cq			ibv_cq;
 	uint64_t			wc_flags;
+	int (*mlx4_poll_one)(struct mlx4_cq *cq, struct mlx4_qp **cur_qp,
+			     struct ibv_wc_ex **wc_ex);
 	struct mlx4_buf			buf;
 	struct mlx4_buf			resize_buf;
 	pthread_spinlock_t		lock;
@@ -432,6 +434,9 @@ int mlx4_poll_cq(struct ibv_cq *cq, int ne, struct ibv_wc *wc);
 int mlx4_poll_cq_ex(struct ibv_cq *ibcq,
 		    struct ibv_wc_ex *wc,
 		    struct ibv_poll_cq_ex_attr *attr);
+int mlx4_poll_one_ex(struct mlx4_cq *cq,
+		     struct mlx4_qp **cur_qp,
+		     struct ibv_wc_ex **pwc_ex);
 int mlx4_arm_cq(struct ibv_cq *cq, int solicited);
 void mlx4_cq_event(struct ibv_cq *cq);
 void __mlx4_cq_clean(struct mlx4_cq *cq, uint32_t qpn, struct mlx4_srq *srq);
diff --git a/src/verbs.c b/src/verbs.c
index 843ca1e..62908c1 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -432,6 +432,7 @@ static struct ibv_cq *create_cq(struct ibv_context *context,
 	if (ret)
 		goto err_db;
 
+	cq->mlx4_poll_one = mlx4_poll_one_ex;
 	cq->creation_flags = cmd_e.ibv_cmd.flags;
 	cq->wc_flags = cq_attr->wc_flags;
 	cq->cqn = resp.cqn;
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
