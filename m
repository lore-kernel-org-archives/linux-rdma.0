From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 4/6] ib/mthca: change default node description processing
Date: Thu, 30 Oct 2014 19:50:19 -0400
Message-ID: <1414713021-12175-5-git-send-email-ira.weiny@intel.com>
References: <1414713021-12175-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414713021-12175-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Change the default node description string to IB_DEFAULT_ND_FORMAT
Use ib_build_node_desc to dynamically map this string when queried

Reviewed-by: John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Michael Heinz <michael.william.heinz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
 drivers/infiniband/hw/mthca/mthca_mad.c      |  3 ++-
 drivers/infiniband/hw/mthca/mthca_provider.c | 12 +++---------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_mad.c b/drivers/infiniband/hw/mthca/mthca_mad.c
index 8881fa3..2c15359 100644
--- a/drivers/infiniband/hw/mthca/mthca_mad.c
+++ b/drivers/infiniband/hw/mthca/mthca_mad.c
@@ -153,7 +153,8 @@ static void node_desc_override(struct ib_device *dev,
 	    mad->mad_hdr.method == IB_MGMT_METHOD_GET_RESP &&
 	    mad->mad_hdr.attr_id == IB_SMP_ATTR_NODE_DESC) {
 		mutex_lock(&to_mdev(dev)->cap_mask_mutex);
-		memcpy(((struct ib_smp *) mad)->data, dev->node_desc, 64);
+		ib_build_node_desc(((struct ib_smp *)mad)->data, dev->node_desc,
+				   64, dev);
 		mutex_unlock(&to_mdev(dev)->cap_mask_mutex);
 	}
 }
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 415f8e1..c8e3d23 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -1217,16 +1217,10 @@ static int mthca_init_node_data(struct mthca_dev *dev)
 	if (!in_mad || !out_mad)
 		goto out;
 
-	init_query_mad(in_mad);
-	in_mad->attr_id = IB_SMP_ATTR_NODE_DESC;
-
-	err = mthca_MAD_IFC(dev, 1, 1,
-			    1, NULL, NULL, in_mad, out_mad);
-	if (err)
-		goto out;
-
-	memcpy(dev->ib_dev.node_desc, out_mad->data, 64);
+	snprintf(dev->ib_dev.node_desc, sizeof(dev->ib_dev.node_desc)-1, "%s",
+		 IB_DEFAULT_ND_FORMAT);
 
+	init_query_mad(in_mad);
 	in_mad->attr_id = IB_SMP_ATTR_NODE_INFO;
 
 	err = mthca_MAD_IFC(dev, 1, 1,
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
