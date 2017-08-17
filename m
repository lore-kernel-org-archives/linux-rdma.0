From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next v3 13/24] IB/mlx5: Fix some spelling mistakes
Date: Thu, 17 Aug 2017 15:50:44 +0300
Message-ID: <20170817125055.31424-14-leon@kernel.org>
References: <20170817125055.31424-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170817125055.31424-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Fix spelling mistakes in remarks
    "retrun"->"return"
    "Decalring"->"Declaring"

Signed-off-by: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/cq.c  | 2 +-
 drivers/infiniband/hw/mlx5/mad.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index a384d72ea3cd..f7fcfc8c22bf 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -499,7 +499,7 @@ static void mlx5_ib_poll_sw_comp(struct mlx5_ib_cq *cq, int num_entries,
 	struct mlx5_ib_qp *qp;
 
 	*npolled = 0;
-	/* Find uncompleted WQEs belonging to that cq and retrun mmics ones */
+	/* Find uncompleted WQEs belonging to that cq and return mmics ones */
 	list_for_each_entry(qp, &cq->list_send_qp, cq_send_list) {
 		sw_send_comp(qp, num_entries, wc + *npolled, npolled);
 		if (*npolled >= num_entries)
diff --git a/drivers/infiniband/hw/mlx5/mad.c b/drivers/infiniband/hw/mlx5/mad.c
index cd2264ac88ae..98e51d51bb04 100644
--- a/drivers/infiniband/hw/mlx5/mad.c
+++ b/drivers/infiniband/hw/mlx5/mad.c
@@ -204,7 +204,7 @@ static int process_pma_cmd(struct ib_device *ibdev, u8 port_num,
 	int err;
 	void *out_cnt;
 
-	/* Decalring support of extended counters */
+	/* Declaring support of extended counters */
 	if (in_mad->mad_hdr.attr_id == IB_PMA_CLASS_PORT_INFO) {
 		struct ib_class_port_info cpi = {};
 
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
