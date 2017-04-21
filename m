From: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: [PATCH v2 09/17] IB/mlx4: Split a condition check in six functions
Date: Fri, 21 Apr 2017 20:40:56 +0200
Message-ID: <4ae3cd4d-9196-6365-4d80-e91a6ee66c76@users.sourceforge.net>
References: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>
 <1492720654.3041.16.camel@redhat.com>
 <a56f9301-e116-c59c-681a-9108519920e5@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a56f9301-e116-c59c-681a-9108519920e5-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Language: en-GB
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Date: Fri, 21 Apr 2017 18:13:16 +0200

The kfree() function was called in up to two cases during error handling
even if the passed variable contained a null pointer.

* Split a condition check for memory allocation failures.

* Adjust jump targets according to the Linux coding style convention.

* Delete initialisations for variables at the beginning
  which became unnecessary with this refactoring.

Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
---

v2:
Changes were rebased on source files from Linux next-20170421.
These were recombined as requested by Doug Ledford.

 drivers/infiniband/hw/mlx4/mad.c  | 14 +++---
 drivers/infiniband/hw/mlx4/main.c | 90 +++++++++++++++++++++++++--------------
 2 files changed, 68 insertions(+), 36 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 41461aeb7c5e..b26817f0669f 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -1129,17 +1129,20 @@ static void propagate_pkey_ev(struct mlx4_ib_dev *dev, int port_num,
 static void handle_slaves_guid_change(struct mlx4_ib_dev *dev, u8 port_num,
 				      u32 guid_tbl_blk_num, u32 change_bitmap)
 {
-	struct ib_smp *in_mad  = NULL;
-	struct ib_smp *out_mad  = NULL;
+	struct ib_smp *in_mad;
+	struct ib_smp *out_mad;
 	u16 i;
 
 	if (!mlx4_is_mfunc(dev->dev) || !mlx4_is_master(dev->dev))
 		return;
 
 	in_mad  = kmalloc(sizeof(*in_mad), GFP_KERNEL);
+	if (!in_mad)
+		return;
+
 	out_mad = kmalloc(sizeof(*out_mad), GFP_KERNEL);
-	if (!in_mad || !out_mad)
-		goto out;
+	if (!out_mad)
+		goto free_in_mad;
 
 	guid_tbl_blk_num  *= 4;
 
@@ -1172,8 +1175,9 @@ static void handle_slaves_guid_change(struct mlx4_ib_dev *dev, u8 port_num,
 	}
 
 out:
-	kfree(in_mad);
 	kfree(out_mad);
+free_in_mad:
+	kfree(in_mad);
 }
 
 void handle_port_mgmt_change_event(struct work_struct *work)
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 8f0e37c4f381..e18e46a68809 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -435,8 +435,8 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 				struct ib_udata *uhw)
 {
 	struct mlx4_ib_dev *dev = to_mdev(ibdev);
-	struct ib_smp *in_mad  = NULL;
-	struct ib_smp *out_mad = NULL;
+	struct ib_smp *in_mad;
+	struct ib_smp *out_mad;
 	int err;
 	int have_ib_ports;
 	struct mlx4_uverbs_ex_query_device cmd;
@@ -461,10 +461,14 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 	resp.response_length = offsetof(typeof(resp), response_length) +
 		sizeof(resp.response_length);
 	in_mad  = kzalloc(sizeof(*in_mad), GFP_KERNEL);
+	if (!in_mad)
+		return -ENOMEM;
+
 	out_mad = kmalloc(sizeof(*out_mad), GFP_KERNEL);
-	err = -ENOMEM;
-	if (!in_mad || !out_mad)
-		goto out;
+	if (!out_mad) {
+		err = -ENOMEM;
+		goto free_in_mad;
+	}
 
 	init_query_mad(in_mad);
 	in_mad->attr_id = IB_SMP_ATTR_NODE_INFO;
@@ -573,9 +577,9 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 			goto out;
 	}
 out:
-	kfree(in_mad);
 	kfree(out_mad);
-
+free_in_mad:
+	kfree(in_mad);
 	return err;
 }
 
@@ -591,16 +595,21 @@ mlx4_ib_port_link_layer(struct ib_device *device, u8 port_num)
 static int ib_link_query_port(struct ib_device *ibdev, u8 port,
 			      struct ib_port_attr *props, int netw_view)
 {
-	struct ib_smp *in_mad  = NULL;
-	struct ib_smp *out_mad = NULL;
+	struct ib_smp *in_mad;
+	struct ib_smp *out_mad;
 	int ext_active_speed;
 	int mad_ifc_flags = MLX4_MAD_IFC_IGNORE_KEYS;
-	int err = -ENOMEM;
+	int err;
 
 	in_mad  = kzalloc(sizeof(*in_mad), GFP_KERNEL);
+	if (!in_mad)
+		return -ENOMEM;
+
 	out_mad = kmalloc(sizeof(*out_mad), GFP_KERNEL);
-	if (!in_mad || !out_mad)
-		goto out;
+	if (!out_mad) {
+		err = -ENOMEM;
+		goto free_in_mad;
+	}
 
 	init_query_mad(in_mad);
 	in_mad->attr_id  = IB_SMP_ATTR_PORT_INFO;
@@ -673,8 +682,9 @@ static int ib_link_query_port(struct ib_device *ibdev, u8 port,
 		 props->active_speed = IB_SPEED_SDR;
 
 out:
-	kfree(in_mad);
 	kfree(out_mad);
+free_in_mad:
+	kfree(in_mad);
 	return err;
 }
 
@@ -766,17 +776,22 @@ static int mlx4_ib_query_port(struct ib_device *ibdev, u8 port,
 int __mlx4_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
 			union ib_gid *gid, int netw_view)
 {
-	struct ib_smp *in_mad  = NULL;
-	struct ib_smp *out_mad = NULL;
-	int err = -ENOMEM;
+	struct ib_smp *in_mad;
+	struct ib_smp *out_mad;
+	int err;
 	struct mlx4_ib_dev *dev = to_mdev(ibdev);
 	int clear = 0;
 	int mad_ifc_flags = MLX4_MAD_IFC_IGNORE_KEYS;
 
 	in_mad  = kzalloc(sizeof(*in_mad), GFP_KERNEL);
+	if (!in_mad)
+		return -ENOMEM;
+
 	out_mad = kmalloc(sizeof(*out_mad), GFP_KERNEL);
-	if (!in_mad || !out_mad)
-		goto out;
+	if (!out_mad) {
+		err = -ENOMEM;
+		goto free_in_mad;
+	}
 
 	init_query_mad(in_mad);
 	in_mad->attr_id  = IB_SMP_ATTR_PORT_INFO;
@@ -814,8 +829,9 @@ int __mlx4_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
 out:
 	if (clear)
 		memset(gid->raw + 8, 0, 8);
-	kfree(in_mad);
 	kfree(out_mad);
+free_in_mad:
+	kfree(in_mad);
 	return err;
 }
 
@@ -905,15 +921,20 @@ static void mlx4_init_sl2vl_tbl(struct mlx4_ib_dev *mdev)
 int __mlx4_ib_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
 			 u16 *pkey, int netw_view)
 {
-	struct ib_smp *in_mad  = NULL;
-	struct ib_smp *out_mad = NULL;
+	struct ib_smp *in_mad;
+	struct ib_smp *out_mad;
 	int mad_ifc_flags = MLX4_MAD_IFC_IGNORE_KEYS;
-	int err = -ENOMEM;
+	int err;
 
 	in_mad  = kzalloc(sizeof(*in_mad), GFP_KERNEL);
+	if (!in_mad)
+		return -ENOMEM;
+
 	out_mad = kmalloc(sizeof(*out_mad), GFP_KERNEL);
-	if (!in_mad || !out_mad)
-		goto out;
+	if (!out_mad) {
+		err = -ENOMEM;
+		goto free_in_mad;
+	}
 
 	init_query_mad(in_mad);
 	in_mad->attr_id  = IB_SMP_ATTR_PKEY_TABLE;
@@ -930,8 +951,9 @@ int __mlx4_ib_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
 	*pkey = be16_to_cpu(((__be16 *) out_mad->data)[index % 32]);
 
 out:
-	kfree(in_mad);
 	kfree(out_mad);
+free_in_mad:
+	kfree(in_mad);
 	return err;
 }
 
@@ -2086,15 +2108,20 @@ static int mlx4_ib_mcg_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 
 static int init_node_data(struct mlx4_ib_dev *dev)
 {
-	struct ib_smp *in_mad  = NULL;
-	struct ib_smp *out_mad = NULL;
+	struct ib_smp *in_mad;
+	struct ib_smp *out_mad;
 	int mad_ifc_flags = MLX4_MAD_IFC_IGNORE_KEYS;
-	int err = -ENOMEM;
+	int err;
 
 	in_mad  = kzalloc(sizeof(*in_mad), GFP_KERNEL);
+	if (!in_mad)
+		return -ENOMEM;
+
 	out_mad = kmalloc(sizeof(*out_mad), GFP_KERNEL);
-	if (!in_mad || !out_mad)
-		goto out;
+	if (!out_mad) {
+		err = -ENOMEM;
+		goto free_in_mad;
+	}
 
 	init_query_mad(in_mad);
 	in_mad->attr_id = IB_SMP_ATTR_NODE_DESC;
@@ -2117,8 +2144,9 @@ static int init_node_data(struct mlx4_ib_dev *dev)
 	memcpy(&dev->ib_dev.node_guid, out_mad->data + 12, 8);
 
 out:
-	kfree(in_mad);
 	kfree(out_mad);
+free_in_mad:
+	kfree(in_mad);
 	return err;
 }
 
-- 
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
