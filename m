From: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: [PATCH 13/29] IB/mlx4: Split a condition check in five functions
Date: Sat, 18 Feb 2017 22:01:46 +0100
Message-ID: <c2594ee3-ce5f-f86b-980c-098adf3e4609@users.sourceforge.net>
References: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1935365a-bd7c-461e-6a84-0c5d3a501fff-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Date: Sat, 18 Feb 2017 14:43:34 +0100

The kfree() function was called in up to two cases during error handling
even if the passed variable contained a null pointer.

* Split a condition check for memory allocation failures.

* Adjust jump targets according to the Linux coding style convention.

* Delete initialisations for variables at the beginning
  which became unnecessary with this refactoring.

Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c | 90 +++++++++++++++++++++++++--------------
 1 file changed, 59 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index b3b5ded85166..c0c299ffa0f6 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -432,8 +432,8 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
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
@@ -458,10 +458,14 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
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
@@ -570,9 +574,9 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
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
 
@@ -588,16 +592,21 @@ mlx4_ib_port_link_layer(struct ib_device *device, u8 port_num)
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
@@ -670,8 +679,9 @@ static int ib_link_query_port(struct ib_device *ibdev, u8 port,
 		 props->active_speed = IB_SPEED_SDR;
 
 out:
-	kfree(in_mad);
 	kfree(out_mad);
+free_in_mad:
+	kfree(in_mad);
 	return err;
 }
 
@@ -763,17 +773,22 @@ static int mlx4_ib_query_port(struct ib_device *ibdev, u8 port,
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
@@ -811,8 +826,9 @@ int __mlx4_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
 out:
 	if (clear)
 		memset(gid->raw + 8, 0, 8);
-	kfree(in_mad);
 	kfree(out_mad);
+free_in_mad:
+	kfree(in_mad);
 	return err;
 }
 
@@ -902,15 +918,20 @@ static void mlx4_init_sl2vl_tbl(struct mlx4_ib_dev *mdev)
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
@@ -927,8 +948,9 @@ int __mlx4_ib_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
 	*pkey = be16_to_cpu(((__be16 *) out_mad->data)[index % 32]);
 
 out:
-	kfree(in_mad);
 	kfree(out_mad);
+free_in_mad:
+	kfree(in_mad);
 	return err;
 }
 
@@ -2083,15 +2105,20 @@ static int mlx4_ib_mcg_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 
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
@@ -2114,8 +2141,9 @@ static int init_node_data(struct mlx4_ib_dev *dev)
 	memcpy(&dev->ib_dev.node_guid, out_mad->data + 12, 8);
 
 out:
-	kfree(in_mad);
 	kfree(out_mad);
+free_in_mad:
+	kfree(in_mad);
 	return err;
 }
 
-- 
2.11.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
