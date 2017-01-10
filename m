From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 07/15] IB/rxe: Let the compiler check the type of the cleanup functions
Date: Tue, 10 Jan 2017 11:15:46 -0800
Message-ID: <20170110191554.17359-8-bart.vanassche@sandisk.com>
References: <20170110191554.17359-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170110191554.17359-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Change the argument type of these functions from void * into
struct rxe_pool_entry *.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_cq.c    | 4 ++--
 drivers/infiniband/sw/rxe/rxe_loc.h   | 8 ++++----
 drivers/infiniband/sw/rxe/rxe_mcast.c | 4 ++--
 drivers/infiniband/sw/rxe/rxe_mr.c    | 4 ++--
 drivers/infiniband/sw/rxe/rxe_pool.h  | 6 ++++--
 drivers/infiniband/sw/rxe/rxe_qp.c    | 4 ++--
 drivers/infiniband/sw/rxe/rxe_verbs.h | 2 +-
 7 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_cq.c b/drivers/infiniband/sw/rxe/rxe_cq.c
index e5e6a5e7dee9..49fe42c23f4d 100644
--- a/drivers/infiniband/sw/rxe/rxe_cq.c
+++ b/drivers/infiniband/sw/rxe/rxe_cq.c
@@ -156,9 +156,9 @@ int rxe_cq_post(struct rxe_cq *cq, struct rxe_cqe *cqe, int solicited)
 	return 0;
 }
 
-void rxe_cq_cleanup(void *arg)
+void rxe_cq_cleanup(struct rxe_pool_entry *arg)
 {
-	struct rxe_cq *cq = arg;
+	struct rxe_cq *cq = container_of(arg, typeof(*cq), pelem);
 
 	if (cq->queue)
 		rxe_queue_cleanup(cq->queue);
diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index efe4c6a35442..da191d7acb6f 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -64,7 +64,7 @@ int rxe_cq_resize_queue(struct rxe_cq *cq, int new_cqe, struct ib_udata *udata);
 
 int rxe_cq_post(struct rxe_cq *cq, struct rxe_cqe *cqe, int solicited);
 
-void rxe_cq_cleanup(void *arg);
+void rxe_cq_cleanup(struct rxe_pool_entry *arg);
 
 /* rxe_mcast.c */
 int rxe_mcast_get_grp(struct rxe_dev *rxe, union ib_gid *mgid,
@@ -78,7 +78,7 @@ int rxe_mcast_drop_grp_elem(struct rxe_dev *rxe, struct rxe_qp *qp,
 
 void rxe_drop_all_mcast_groups(struct rxe_qp *qp);
 
-void rxe_mc_cleanup(void *arg);
+void rxe_mc_cleanup(struct rxe_pool_entry *arg);
 
 /* rxe_mmap.c */
 struct rxe_mmap_info {
@@ -137,7 +137,7 @@ int mem_check_range(struct rxe_mem *mem, u64 iova, size_t length);
 int rxe_mem_map_pages(struct rxe_dev *rxe, struct rxe_mem *mem,
 		      u64 *page, int num_pages, u64 iova);
 
-void rxe_mem_cleanup(void *arg);
+void rxe_mem_cleanup(struct rxe_pool_entry *arg);
 
 int advance_dma_data(struct rxe_dma_info *dma, unsigned int length);
 
@@ -162,7 +162,7 @@ void rxe_qp_error(struct rxe_qp *qp);
 
 void rxe_qp_destroy(struct rxe_qp *qp);
 
-void rxe_qp_cleanup(void *arg);
+void rxe_qp_cleanup(struct rxe_pool_entry *arg);
 
 static inline int qp_num(struct rxe_qp *qp)
 {
diff --git a/drivers/infiniband/sw/rxe/rxe_mcast.c b/drivers/infiniband/sw/rxe/rxe_mcast.c
index fa95544ca7e0..e0fb6752f90e 100644
--- a/drivers/infiniband/sw/rxe/rxe_mcast.c
+++ b/drivers/infiniband/sw/rxe/rxe_mcast.c
@@ -180,9 +180,9 @@ void rxe_drop_all_mcast_groups(struct rxe_qp *qp)
 	}
 }
 
-void rxe_mc_cleanup(void *arg)
+void rxe_mc_cleanup(struct rxe_pool_entry *arg)
 {
-	struct rxe_mc_grp *grp = arg;
+	struct rxe_mc_grp *grp = container_of(arg, typeof(*grp), pelem);
 	struct rxe_dev *rxe = grp->rxe;
 
 	rxe_drop_key(grp);
diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index d0faca294006..8ca3acd327b3 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -89,9 +89,9 @@ static void rxe_mem_init(int access, struct rxe_mem *mem)
 	mem->map_shift		= ilog2(RXE_BUF_PER_MAP);
 }
 
-void rxe_mem_cleanup(void *arg)
+void rxe_mem_cleanup(struct rxe_pool_entry *arg)
 {
-	struct rxe_mem *mem = arg;
+	struct rxe_mem *mem = container_of(arg, typeof(*mem), pelem);
 	int i;
 
 	if (mem->umem)
diff --git a/drivers/infiniband/sw/rxe/rxe_pool.h b/drivers/infiniband/sw/rxe/rxe_pool.h
index 7846ccc58b25..47df28e43acf 100644
--- a/drivers/infiniband/sw/rxe/rxe_pool.h
+++ b/drivers/infiniband/sw/rxe/rxe_pool.h
@@ -57,10 +57,12 @@ enum rxe_elem_type {
 	RXE_NUM_TYPES,		/* keep me last */
 };
 
+struct rxe_pool_entry;
+
 struct rxe_type_info {
 	const char		*name;
 	size_t			size;
-	void			(*cleanup)(void *obj);
+	void			(*cleanup)(struct rxe_pool_entry *obj);
 	enum rxe_pool_flags	flags;
 	u32			max_index;
 	u32			min_index;
@@ -91,7 +93,7 @@ struct rxe_pool {
 	spinlock_t              pool_lock; /* pool spinlock */
 	size_t			elem_size;
 	struct kref		ref_cnt;
-	void			(*cleanup)(void *obj);
+	void			(*cleanup)(struct rxe_pool_entry *obj);
 	enum rxe_pool_state	state;
 	enum rxe_pool_flags	flags;
 	enum rxe_elem_type	type;
diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index 486d576e55bc..917147ce4cf9 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -825,9 +825,9 @@ void rxe_qp_destroy(struct rxe_qp *qp)
 }
 
 /* called when the last reference to the qp is dropped */
-void rxe_qp_cleanup(void *arg)
+void rxe_qp_cleanup(struct rxe_pool_entry *arg)
 {
-	struct rxe_qp *qp = arg;
+	struct rxe_qp *qp = container_of(arg, typeof(*qp), pelem);
 
 	rxe_drop_all_mcast_groups(qp);
 
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/sw/rxe/rxe_verbs.h
index cac1d52a08f0..536974b69ed9 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
@@ -475,6 +475,6 @@ static inline struct rxe_mem *to_rmw(struct ib_mw *mw)
 int rxe_register_device(struct rxe_dev *rxe);
 int rxe_unregister_device(struct rxe_dev *rxe);
 
-void rxe_mc_cleanup(void *arg);
+void rxe_mc_cleanup(struct rxe_pool_entry *arg);
 
 #endif /* RXE_VERBS_H */
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
