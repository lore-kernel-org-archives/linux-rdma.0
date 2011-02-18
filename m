From: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] Add support for ib_build_node_desc() to the HCAs.
Date: Fri, 18 Feb 2011 16:29:19 -0500
Message-ID: <20110218212919.21364.6992.stgit@homer>
References: <20110218212723.21364.92709.stgit@homer>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110218212723.21364.92709.stgit@homer>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Adds support for ib_build_node_desc() to the HCAs.

Signed-off-by: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

---
 drivers/infiniband/hw/ipath/ipath_mad.c |    2 +-
 drivers/infiniband/hw/mlx4/mad.c        |    2 +-
 drivers/infiniband/hw/mthca/mthca_mad.c |    2 +-
 drivers/infiniband/hw/qib/qib_mad.c     |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_mad.c b/drivers/infiniband/hw/ipath/ipath_mad.c
index ceb98ee..bd1a112 100644
--- a/drivers/infiniband/hw/ipath/ipath_mad.c
+++ b/drivers/infiniband/hw/ipath/ipath_mad.c
@@ -60,7 +60,7 @@ static int recv_subn_get_nodedescription(struct ib_smp *smp,
 	if (smp->attr_mod)
 		smp->status |= IB_SMP_INVALID_FIELD;
 
-	memcpy(smp->data, ibdev->node_desc, sizeof(smp->data));
+	ib_build_node_desc(smp, ibdev->node_desc);
 
 	return reply(smp);
 }
diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 57ffa50..6a89c3c 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -196,7 +196,7 @@ static void node_desc_override(struct ib_device *dev,
 	    mad->mad_hdr.method == IB_MGMT_METHOD_GET_RESP &&
 	    mad->mad_hdr.attr_id == IB_SMP_ATTR_NODE_DESC) {
 		spin_lock(&to_mdev(dev)->sm_lock);
-		memcpy(((struct ib_smp *) mad)->data, dev->node_desc, 64);
+		ib_build_node_desc((struct ib_smp *) mad, dev->node_desc);
 		spin_unlock(&to_mdev(dev)->sm_lock);
 	}
 }
diff --git a/drivers/infiniband/hw/mthca/mthca_mad.c b/drivers/infiniband/hw/mthca/mthca_mad.c
index 03a5953..b442028 100644
--- a/drivers/infiniband/hw/mthca/mthca_mad.c
+++ b/drivers/infiniband/hw/mthca/mthca_mad.c
@@ -153,7 +153,7 @@ static void node_desc_override(struct ib_device *dev,
 	    mad->mad_hdr.method == IB_MGMT_METHOD_GET_RESP &&
 	    mad->mad_hdr.attr_id == IB_SMP_ATTR_NODE_DESC) {
 		mutex_lock(&to_mdev(dev)->cap_mask_mutex);
-		memcpy(((struct ib_smp *) mad)->data, dev->node_desc, 64);
+		ib_build_node_desc((struct ib_smp *) mad, dev->node_desc);
 		mutex_unlock(&to_mdev(dev)->cap_mask_mutex);
 	}
 }
diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index 5ad224e..1033112 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -260,7 +260,7 @@ static int subn_get_nodedescription(struct ib_smp *smp,
 	if (smp->attr_mod)
 		smp->status |= IB_SMP_INVALID_FIELD;
 
-	memcpy(smp->data, ibdev->node_desc, sizeof(smp->data));
+	ib_build_node_desc(smp, ibdev->node_desc);
 
 	return reply(smp);
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
