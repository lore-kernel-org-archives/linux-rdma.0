From: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 2/2] Add support for ib_build_node_desc() to the HCAs.
Date: Wed, 23 Feb 2011 21:24:49 -0500
Message-ID: <20110224022449.26808.67272.stgit@homer>
References: <20110224022124.26808.62012.stgit@homer>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110224022124.26808.62012.stgit@homer>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
Cc: todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Adds support for ib_build_node_desc() to the QLogic and Mellanox HCAs.

Changes from Version 1:

Changed the default node description for Mellanox and QLogic HCAs to read "%h: %d <description>" where '<description>' is the old default value.

Signed-off-by: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

---
 drivers/infiniband/hw/ipath/ipath_mad.c      |    2 +-
 drivers/infiniband/hw/ipath/ipath_verbs.c    |    4 ++--
 drivers/infiniband/hw/mlx4/mad.c             |    2 +-
 drivers/infiniband/hw/mlx4/main.c            |    3 ++-
 drivers/infiniband/hw/mthca/mthca_mad.c      |    2 +-
 drivers/infiniband/hw/mthca/mthca_provider.c |    3 ++-
 drivers/infiniband/hw/qib/qib_mad.c          |    2 +-
 drivers/infiniband/hw/qib/qib_verbs.c        |    2 +-
 8 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_mad.c b/drivers/infiniband/hw/ipath/ipath_mad.c
index ceb98ee..387eba7 100644
--- a/drivers/infiniband/hw/ipath/ipath_mad.c
+++ b/drivers/infiniband/hw/ipath/ipath_mad.c
@@ -60,7 +60,7 @@ static int recv_subn_get_nodedescription(struct ib_smp *smp,
 	if (smp->attr_mod)
 		smp->status |= IB_SMP_INVALID_FIELD;
 
-	memcpy(smp->data, ibdev->node_desc, sizeof(smp->data));
+	ib_build_node_desc(smp, ibdev);
 
 	return reply(smp);
 }
diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.c b/drivers/infiniband/hw/ipath/ipath_verbs.c
index dd7f26d..e8a429e 100644
--- a/drivers/infiniband/hw/ipath/ipath_verbs.c
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.c
@@ -2179,8 +2179,8 @@ int ipath_register_ib_device(struct ipath_devdata *dd)
 	dev->mmap = ipath_mmap;
 	dev->dma_ops = &ipath_dma_mapping_ops;
 
-	snprintf(dev->node_desc, sizeof(dev->node_desc),
-		 IPATH_IDSTR " %s", init_utsname()->nodename);
+	strncpy(dev->node_desc, sizeof(dev->node_desc),
+		    "%h: %d " IPATH_IDSTR);
 
 	ret = ib_register_device(dev, NULL);
 	if (ret)
diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 57ffa50..8c7205f 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -196,7 +196,7 @@ static void node_desc_override(struct ib_device *dev,
 	    mad->mad_hdr.method == IB_MGMT_METHOD_GET_RESP &&
 	    mad->mad_hdr.attr_id == IB_SMP_ATTR_NODE_DESC) {
 		spin_lock(&to_mdev(dev)->sm_lock);
-		memcpy(((struct ib_smp *) mad)->data, dev->node_desc, 64);
+		ib_build_node_desc((struct ib_smp *) mad, dev);
 		spin_unlock(&to_mdev(dev)->sm_lock);
 	}
 }
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index c7a6213..ef74cb9 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -713,7 +713,8 @@ static int init_node_data(struct mlx4_ib_dev *dev)
 	if (err)
 		goto out;
 
-	memcpy(dev->ib_dev.node_desc, out_mad->data, 64);
+	snprintf(dev->ib_dev.node_desc, 64, "%%h: %%d %s", out_mad->data);
+	dev->ib_dev.node_desc[63] = 0;
 
 	in_mad->attr_id = IB_SMP_ATTR_NODE_INFO;
 
diff --git a/drivers/infiniband/hw/mthca/mthca_mad.c b/drivers/infiniband/hw/mthca/mthca_mad.c
index 03a5953..57e11d5 100644
--- a/drivers/infiniband/hw/mthca/mthca_mad.c
+++ b/drivers/infiniband/hw/mthca/mthca_mad.c
@@ -153,7 +153,7 @@ static void node_desc_override(struct ib_device *dev,
 	    mad->mad_hdr.method == IB_MGMT_METHOD_GET_RESP &&
 	    mad->mad_hdr.attr_id == IB_SMP_ATTR_NODE_DESC) {
 		mutex_lock(&to_mdev(dev)->cap_mask_mutex);
-		memcpy(((struct ib_smp *) mad)->data, dev->node_desc, 64);
+		ib_build_node_desc((struct ib_smp *) mad, dev);
 		mutex_unlock(&to_mdev(dev)->cap_mask_mutex);
 	}
 }
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 1e0b4b6..0f858f7 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -1273,7 +1273,8 @@ static int mthca_init_node_data(struct mthca_dev *dev)
 		goto out;
 	}
 
-	memcpy(dev->ib_dev.node_desc, out_mad->data, 64);
+	snprintf(dev->ib_dev.node_desc, 64, "%%h: %%d %s", out_mad->data);
+	dev->ib_dev.node_desc[63] = 0;
 
 	in_mad->attr_id = IB_SMP_ATTR_NODE_INFO;
 
diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index 5ad224e..5139e3c 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -260,7 +260,7 @@ static int subn_get_nodedescription(struct ib_smp *smp,
 	if (smp->attr_mod)
 		smp->status |= IB_SMP_INVALID_FIELD;
 
-	memcpy(smp->data, ibdev->node_desc, sizeof(smp->data));
+	ib_build_node_desc(smp, ibdev);
 
 	return reply(smp);
 }
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 9fab404..f611859 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -2158,7 +2158,7 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	ibdev->dma_ops = &qib_dma_mapping_ops;
 
 	snprintf(ibdev->node_desc, sizeof(ibdev->node_desc),
-		 QIB_IDSTR " %s", init_utsname()->nodename);
+		 "%h: %d " QIB_IDSTR);
 
 	ret = ib_register_device(ibdev, qib_create_port_files);
 	if (ret)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
