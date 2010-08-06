From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 03/10] attach cq to least cqs attached completion
	vector
Date: Fri, 06 Aug 2010 15:50:21 -0700
Message-ID: <4C5C91AD.4010005@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030905070404050106010606"
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------030905070404050106010606
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

When the vector number passed to mlx4_cq_alloc is MLX4_LEAST_ATTACHED_VECTOR
the driver selects the completion vector that has the least CQ's attached
to it and attaches the CQ to the chosen vector.
IB_CQ_VECTOR_LEAST_ATTACHED is defined in rdma/ib_verbs.h, when mlx4_ib driv
recieves this cq vector number, it uses MLX4_LEAST_ATTACHED_VECTOR
    
Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Vu Pham <vu-jyKWETY2nSZBDgjK7y7TUQ@public.gmane.org>

 drivers/infiniband/hw/mlx4/cq.c |    4 +++-
 drivers/net/mlx4/cq.c           |   27 +++++++++++++++++++++++----
 drivers/net/mlx4/en_cq.c        |    2 +-
 drivers/net/mlx4/mlx4.h         |    1 +
 include/linux/mlx4/device.h     |    2 ++
 include/rdma/ib_verbs.h         |   10 +++++++++-
 6 files changed, 39 insertions(+), 7 deletions(-)


--------------030905070404050106010606
Content-Type: text/x-patch;
 name="mlx4_fc_0003_automatic_comp_vector.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mlx4_fc_0003_automatic_comp_vector.patch"

When the vector number passed to mlx4_cq_alloc is MLX4_LEAST_ATTACHED_VECTOR
the driver selects the completion vector that has the least CQ's attached
to it and attaches the CQ to the chosen vector.
IB_CQ_VECTOR_LEAST_ATTACHED is defined in rdma/ib_verbs.h, when mlx4_ib driv
recieves this cq vector number, it uses MLX4_LEAST_ATTACHED_VECTOR 
    
Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Vu Pham <vu-jyKWETY2nSZBDgjK7y7TUQ@public.gmane.org>
 

 drivers/infiniband/hw/mlx4/cq.c |    4 +++-
 drivers/net/mlx4/cq.c           |   27 +++++++++++++++++++++++----
 drivers/net/mlx4/en_cq.c        |    2 +-
 drivers/net/mlx4/mlx4.h         |    1 +
 include/linux/mlx4/device.h     |    2 ++
 include/rdma/ib_verbs.h         |   10 +++++++++-
 6 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index 5a219a2..2687970 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -223,7 +223,9 @@ struct ib_cq *mlx4_ib_create_cq(struct ib_device *ibdev, int entries, int vector
 	}
 
 	err = mlx4_cq_alloc(dev->dev, entries, &cq->buf.mtt, uar,
-			    cq->db.dma, &cq->mcq, vector, 0);
+			    cq->db.dma, &cq->mcq,
+			    vector == IB_CQ_VECTOR_LEAST_ATTACHED ?
+			    MLX4_LEAST_ATTACHED_VECTOR : vector, 0);
 	if (err)
 		goto err_dbmap;
 
diff --git a/drivers/net/mlx4/cq.c b/drivers/net/mlx4/cq.c
index 7cd34e9..a6f03f9 100644
--- a/drivers/net/mlx4/cq.c
+++ b/drivers/net/mlx4/cq.c
@@ -187,6 +187,22 @@ int mlx4_cq_resize(struct mlx4_dev *dev, struct mlx4_cq *cq,
 }
 EXPORT_SYMBOL_GPL(mlx4_cq_resize);
 
+static int mlx4_find_least_loaded_vector(struct mlx4_priv *priv)
+{
+	int i;
+	int index = 0;
+	int min = priv->eq_table.eq[0].load;
+
+	for (i = 1; i < priv->dev.caps.num_comp_vectors; i++) {
+		if (priv->eq_table.eq[i].load < min) {
+			index = i;
+			min = priv->eq_table.eq[i].load;
+		}
+	}
+
+	return index;
+}
+
 int mlx4_cq_alloc(struct mlx4_dev *dev, int nent, struct mlx4_mtt *mtt,
 		  struct mlx4_uar *uar, u64 db_rec, struct mlx4_cq *cq,
 		  unsigned vector, int collapsed)
@@ -198,10 +214,11 @@ int mlx4_cq_alloc(struct mlx4_dev *dev, int nent, struct mlx4_mtt *mtt,
 	u64 mtt_addr;
 	int err;
 
-	if (vector >= dev->caps.num_comp_vectors)
-		return -EINVAL;
+	cq->vector = (vector == MLX4_LEAST_ATTACHED_VECTOR) ?
+		mlx4_find_least_loaded_vector(priv) : vector;
 
-	cq->vector = vector;
+	if (cq->vector >= dev->caps.num_comp_vectors)
+		return -EINVAL;
 
 	cq->cqn = mlx4_bitmap_alloc(&cq_table->bitmap);
 	if (cq->cqn == -1)
@@ -232,7 +249,7 @@ int mlx4_cq_alloc(struct mlx4_dev *dev, int nent, struct mlx4_mtt *mtt,
 
 	cq_context->flags	    = cpu_to_be32(!!collapsed << 18);
 	cq_context->logsize_usrpage = cpu_to_be32((ilog2(nent) << 24) | uar->index);
-	cq_context->comp_eqn	    = priv->eq_table.eq[vector].eqn;
+	cq_context->comp_eqn	    = priv->eq_table.eq[cq->vector].eqn;
 	cq_context->log_page_size   = mtt->page_shift - MLX4_ICM_PAGE_SHIFT;
 
 	mtt_addr = mlx4_mtt_addr(dev, mtt);
@@ -245,6 +262,7 @@ int mlx4_cq_alloc(struct mlx4_dev *dev, int nent, struct mlx4_mtt *mtt,
 	if (err)
 		goto err_radix;
 
+	priv->eq_table.eq[cq->vector].load++;
 	cq->cons_index = 0;
 	cq->arm_sn     = 1;
 	cq->uar        = uar;
@@ -282,6 +300,7 @@ void mlx4_cq_free(struct mlx4_dev *dev, struct mlx4_cq *cq)
 		mlx4_warn(dev, "HW2SW_CQ failed (%d) for CQN %06x\n", err, cq->cqn);
 
 	synchronize_irq(priv->eq_table.eq[cq->vector].irq);
+	priv->eq_table.eq[cq->vector].load--;
 
 	spin_lock_irq(&cq_table->lock);
 	radix_tree_delete(&cq_table->tree, cq->cqn);
diff --git a/drivers/net/mlx4/en_cq.c b/drivers/net/mlx4/en_cq.c
index 21786ad..f3dc8b7 100644
--- a/drivers/net/mlx4/en_cq.c
+++ b/drivers/net/mlx4/en_cq.c
@@ -56,7 +56,7 @@ int mlx4_en_create_cq(struct mlx4_en_priv *priv,
 		cq->vector   = ring % mdev->dev->caps.num_comp_vectors;
 	} else {
 		cq->buf_size = sizeof(struct mlx4_cqe);
-		cq->vector   = 0;
+		cq->vector   = MLX4_LEAST_ATTACHED_VECTOR;
 	}
 
 	cq->ring = ring;
diff --git a/drivers/net/mlx4/mlx4.h b/drivers/net/mlx4/mlx4.h
index 13343e8..416aeca 100644
--- a/drivers/net/mlx4/mlx4.h
+++ b/drivers/net/mlx4/mlx4.h
@@ -138,6 +138,7 @@ struct mlx4_eq {
 	u16			irq;
 	u16			have_irq;
 	int			nent;
+	int			load;
 	struct mlx4_buf_list   *page_list;
 	struct mlx4_mtt		mtt;
 };
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 4408b96..4664d1d 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -171,6 +171,8 @@ enum {
 	MLX4_NUM_FEXCH          = 64 * 1024,
 };
 
+#define MLX4_LEAST_ATTACHED_VECTOR	0xffffffff
+
 static inline u64 mlx4_fw_ver(u64 major, u64 minor, u64 subminor)
 {
 	return (major << 32) | (minor << 16) | subminor;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index f3e8f3c..0ff2824 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1462,6 +1462,13 @@ static inline int ib_post_recv(struct ib_qp *qp,
 	return qp->device->post_recv(qp, recv_wr, bad_recv_wr);
 }
 
+/*
+ * IB_CQ_VECTOR_LEAST_ATTACHED: The constant specifies that
+ *	the CQ will be attached to the completion vector that has
+ *	the least number of CQs already attached to it.
+ */
+#define IB_CQ_VECTOR_LEAST_ATTACHED	0xffffffff
+
 /**
  * ib_create_cq - Creates a CQ on the specified device.
  * @device: The device on which to create the CQ.
@@ -1473,7 +1480,8 @@ static inline int ib_post_recv(struct ib_qp *qp,
  *   the associated completion and event handlers.
  * @cqe: The minimum size of the CQ.
  * @comp_vector - Completion vector used to signal completion events.
- *     Must be >= 0 and < context->num_comp_vectors.
+ *     Must be >= 0 and < context->num_comp_vectors
+ *     or IB_CQ_VECTOR_LEAST_ATTACHED.
  *
  * Users can examine the cq structure to determine the actual CQ size.
  */

--------------030905070404050106010606
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ewg mailing list
ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
--------------030905070404050106010606--
