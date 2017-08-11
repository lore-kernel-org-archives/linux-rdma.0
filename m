From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next 14/22] IB/mlx4: Fix some spelling mistakes
Date: Fri, 11 Aug 2017 13:49:55 +0300
Message-ID: <20170811105003.7661-15-leon@kernel.org>
References: <20170811105003.7661-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170811105003.7661-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Fix spelling mistakes in remarks
    "retrun"->"return"
    "cancell"->"cancel"

Signed-off-by: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/alias_GUID.c | 2 +-
 drivers/infiniband/hw/mlx4/cq.c         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/alias_GUID.c b/drivers/infiniband/hw/mlx4/alias_GUID.c
index ea24230ea0d4..6c8d285e31a3 100644
--- a/drivers/infiniband/hw/mlx4/alias_GUID.c
+++ b/drivers/infiniband/hw/mlx4/alias_GUID.c
@@ -781,7 +781,7 @@ void mlx4_ib_init_alias_guid_work(struct mlx4_ib_dev *dev, int port)
 	spin_lock_irqsave(&dev->sriov.going_down_lock, flags);
 	spin_lock_irqsave(&dev->sriov.alias_guid.ag_work_lock, flags1);
 	if (!dev->sriov.is_going_down) {
-		/* If there is pending one should cancell then run, otherwise
+		/* If there is pending one should cancel then run, otherwise
 		  * won't run till previous one is ended as same work
 		  * struct is used.
 		  */
diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index 95382faa7ad1..cab796341697 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -637,7 +637,7 @@ static void mlx4_ib_poll_sw_comp(struct mlx4_ib_cq *cq, int num_entries,
 	struct mlx4_ib_qp *qp;
 
 	*npolled = 0;
-	/* Find uncompleted WQEs belonging to that cq and retrun
+	/* Find uncompleted WQEs belonging to that cq and return
 	 * simulated FLUSH_ERR completions
 	 */
 	list_for_each_entry(qp, &cq->send_qp_list, cq_send_list) {
-- 
2.14.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
