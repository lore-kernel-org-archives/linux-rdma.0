From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 3/6] ib/mlx4: change default node description processing
Date: Thu, 30 Oct 2014 19:50:18 -0400
Message-ID: <1414713021-12175-4-git-send-email-ira.weiny@intel.com>
References: <1414713021-12175-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414713021-12175-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Change the default node description string to IB_DEFAULT_ND_FORMAT
Use ib_build_node_desc to dynamically map this string when queried and to set
the Node Description in FW

Reviewed-by: John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Michael Heinz <michael.william.heinz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
 drivers/infiniband/hw/mlx4/mad.c  |  3 ++-
 drivers/infiniband/hw/mlx4/main.c | 14 ++++++--------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 82a7dd8..0d736d6 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -343,7 +343,8 @@ static void node_desc_override(struct ib_device *dev,
 	    mad->mad_hdr.method == IB_MGMT_METHOD_GET_RESP &&
 	    mad->mad_hdr.attr_id == IB_SMP_ATTR_NODE_DESC) {
 		spin_lock_irqsave(&to_mdev(dev)->sm_lock, flags);
-		memcpy(((struct ib_smp *) mad)->data, dev->node_desc, 64);
+		ib_build_node_desc(((struct ib_smp *)mad)->data, dev->node_desc,
+				   IB_DEVICE_DESC_MAX, dev);
 		spin_unlock_irqrestore(&to_mdev(dev)->sm_lock, flags);
 	}
 }
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index bda5994..6327ee5 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -553,7 +553,7 @@ static int mlx4_ib_modify_device(struct ib_device *ibdev, int mask,
 	if (IS_ERR(mailbox))
 		return 0;
 
-	memcpy(mailbox->buf, props->node_desc, 64);
+	ib_build_node_desc(mailbox->buf, props->node_desc, 64, ibdev);
 	mlx4_cmd(to_mdev(ibdev)->dev, mailbox->dma, 1, 0,
 		 MLX4_CMD_SET_NODE, MLX4_CMD_TIME_CLASS_A, MLX4_CMD_NATIVE);
 
@@ -1332,23 +1332,21 @@ static int init_node_data(struct mlx4_ib_dev *dev)
 	struct ib_smp *out_mad = NULL;
 	int mad_ifc_flags = MLX4_MAD_IFC_IGNORE_KEYS;
 	int err = -ENOMEM;
+	struct ib_device_modify props;
 
 	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
 	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
 	if (!in_mad || !out_mad)
 		goto out;
 
+	snprintf(props.node_desc, sizeof(props.node_desc)-1, "%s",
+		 IB_DEFAULT_ND_FORMAT);
+	mlx4_ib_modify_device(&dev->ib_dev, IB_DEVICE_MODIFY_NODE_DESC, &props);
+
 	init_query_mad(in_mad);
-	in_mad->attr_id = IB_SMP_ATTR_NODE_DESC;
 	if (mlx4_is_master(dev->dev))
 		mad_ifc_flags |= MLX4_MAD_IFC_NET_VIEW;
 
-	err = mlx4_MAD_IFC(dev, mad_ifc_flags, 1, NULL, NULL, in_mad, out_mad);
-	if (err)
-		goto out;
-
-	memcpy(dev->ib_dev.node_desc, out_mad->data, 64);
-
 	in_mad->attr_id = IB_SMP_ATTR_NODE_INFO;
 
 	err = mlx4_MAD_IFC(dev, mad_ifc_flags, 1, NULL, NULL, in_mad, out_mad);
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
