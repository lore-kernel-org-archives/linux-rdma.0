From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 12/29] IB/mlx4: Enclose 17 expressions for the sizeof operator
 by parentheses
Date: Sat, 18 Feb 2017 22:00:45 +0100
Message-ID: <9ba34d2d-1d54-4f65-4c01-152c72b624b4@users.sourceforge.net>
References: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leonro@mellanox.com>, Matan Barak <matanb@mellanox.com>, Sean Hefty <sean.hefty@intel.com>, Yishai Hadas <yishaih@mellanox.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 18 Feb 2017 11:28:41 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script "checkpatch.pl" pointed information out like the following.

WARNING: sizeof … should be sizeof(…)

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/mlx4/main.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 350c9148340e..b3b5ded85166 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -457,8 +457,8 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 
 	resp.response_length = offsetof(typeof(resp), response_length) +
 		sizeof(resp.response_length);
-	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
-	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
+	in_mad  = kzalloc(sizeof(*in_mad), GFP_KERNEL);
+	out_mad = kmalloc(sizeof(*out_mad), GFP_KERNEL);
 	err = -ENOMEM;
 	if (!in_mad || !out_mad)
 		goto out;
@@ -471,8 +471,7 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 	if (err)
 		goto out;
 
-	memset(props, 0, sizeof *props);
-
+	memset(props, 0, sizeof(*props));
 	have_ib_ports = num_ib_ports(dev->dev);
 
 	props->fw_ver = dev->dev->caps.fw_ver;
@@ -595,8 +594,8 @@ static int ib_link_query_port(struct ib_device *ibdev, u8 port,
 	int mad_ifc_flags = MLX4_MAD_IFC_IGNORE_KEYS;
 	int err = -ENOMEM;
 
-	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
-	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
+	in_mad  = kzalloc(sizeof(*in_mad), GFP_KERNEL);
+	out_mad = kmalloc(sizeof(*out_mad), GFP_KERNEL);
 	if (!in_mad || !out_mad)
 		goto out;
 
@@ -771,8 +770,8 @@ int __mlx4_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
 	int clear = 0;
 	int mad_ifc_flags = MLX4_MAD_IFC_IGNORE_KEYS;
 
-	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
-	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
+	in_mad  = kzalloc(sizeof(*in_mad), GFP_KERNEL);
+	out_mad = kmalloc(sizeof(*out_mad), GFP_KERNEL);
 	if (!in_mad || !out_mad)
 		goto out;
 
@@ -908,8 +907,8 @@ int __mlx4_ib_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
 	int mad_ifc_flags = MLX4_MAD_IFC_IGNORE_KEYS;
 	int err = -ENOMEM;
 
-	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
-	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
+	in_mad  = kzalloc(sizeof(*in_mad), GFP_KERNEL);
+	out_mad = kmalloc(sizeof(*out_mad), GFP_KERNEL);
 	if (!in_mad || !out_mad)
 		goto out;
 
@@ -1280,7 +1279,7 @@ static struct ib_pd *mlx4_ib_alloc_pd(struct ib_device *ibdev,
 	struct mlx4_ib_pd *pd;
 	int err;
 
-	pd = kmalloc(sizeof *pd, GFP_KERNEL);
+	pd = kmalloc(sizeof(*pd), GFP_KERNEL);
 	if (!pd)
 		return ERR_PTR(-ENOMEM);
 
@@ -1319,7 +1318,7 @@ static struct ib_xrcd *mlx4_ib_alloc_xrcd(struct ib_device *ibdev,
 	if (!(to_mdev(ibdev)->dev->caps.flags & MLX4_DEV_CAP_FLAG_XRC))
 		return ERR_PTR(-ENOSYS);
 
-	xrcd = kmalloc(sizeof *xrcd, GFP_KERNEL);
+	xrcd = kmalloc(sizeof(*xrcd), GFP_KERNEL);
 	if (!xrcd)
 		return ERR_PTR(-ENOMEM);
 
@@ -1367,7 +1366,7 @@ static int add_gid_entry(struct ib_qp *ibqp, union ib_gid *gid)
 	struct mlx4_ib_dev *mdev = to_mdev(ibqp->device);
 	struct mlx4_ib_gid_entry *ge;
 
-	ge = kzalloc(sizeof *ge, GFP_KERNEL);
+	ge = kzalloc(sizeof(*ge), GFP_KERNEL);
 	if (!ge)
 		return -ENOMEM;
 
@@ -2089,8 +2088,8 @@ static int init_node_data(struct mlx4_ib_dev *dev)
 	int mad_ifc_flags = MLX4_MAD_IFC_IGNORE_KEYS;
 	int err = -ENOMEM;
 
-	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
-	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
+	in_mad  = kzalloc(sizeof(*in_mad), GFP_KERNEL);
+	out_mad = kmalloc(sizeof(*out_mad), GFP_KERNEL);
 	if (!in_mad || !out_mad)
 		goto out;
 
@@ -2600,7 +2599,7 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	if (num_ports == 0)
 		return NULL;
 
-	ibdev = (struct mlx4_ib_dev *) ib_alloc_device(sizeof *ibdev);
+	ibdev = (struct mlx4_ib_dev *) ib_alloc_device(sizeof(*ibdev));
 	if (!ibdev) {
 		dev_err(&dev->persist->pdev->dev,
 			"Device struct alloc failed\n");
@@ -3301,12 +3300,12 @@ static void mlx4_ib_event(struct mlx4_dev *dev, void *ibdev_ptr,
 		break;
 
 	case MLX4_DEV_EVENT_PORT_MGMT_CHANGE:
-		ew = kmalloc(sizeof *ew, GFP_ATOMIC);
+		ew = kmalloc(sizeof(*ew), GFP_ATOMIC);
 		if (!ew)
 			break;
 
 		INIT_WORK(&ew->work, handle_port_mgmt_change_event);
-		memcpy(&ew->ib_eqe, eqe, sizeof *eqe);
+		memcpy(&ew->ib_eqe, eqe, sizeof(*eqe));
 		ew->ib_dev = ibdev;
 		/* need to queue only for port owner, which uses GEN_EQE */
 		if (mlx4_is_master(dev))
-- 
2.11.1
