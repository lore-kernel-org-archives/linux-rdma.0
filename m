From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 2/6] ib/ipath: change default node description processing
Date: Thu, 30 Oct 2014 19:50:17 -0400
Message-ID: <1414713021-12175-3-git-send-email-ira.weiny@intel.com>
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
 drivers/infiniband/hw/ipath/ipath_mad.c   | 3 ++-
 drivers/infiniband/hw/ipath/ipath_verbs.c | 4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_mad.c b/drivers/infiniband/hw/ipath/ipath_mad.c
index e890e5b..1ec0afd 100644
--- a/drivers/infiniband/hw/ipath/ipath_mad.c
+++ b/drivers/infiniband/hw/ipath/ipath_mad.c
@@ -61,7 +61,8 @@ static int recv_subn_get_nodedescription(struct ib_smp *smp,
 	if (smp->attr_mod)
 		smp->status |= IB_SMP_INVALID_FIELD;
 
-	memcpy(smp->data, ibdev->node_desc, sizeof(smp->data));
+	ib_build_node_desc(smp->data, ibdev->node_desc, IB_DEVICE_DESC_MAX,
+			   ibdev);
 
 	return reply(smp);
 }
diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.c b/drivers/infiniband/hw/ipath/ipath_verbs.c
index 44ea939..bec61d6 100644
--- a/drivers/infiniband/hw/ipath/ipath_verbs.c
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.c
@@ -2180,8 +2180,8 @@ int ipath_register_ib_device(struct ipath_devdata *dd)
 	dev->mmap = ipath_mmap;
 	dev->dma_ops = &ipath_dma_mapping_ops;
 
-	snprintf(dev->node_desc, sizeof(dev->node_desc),
-		 IPATH_IDSTR " %s", init_utsname()->nodename);
+	snprintf(dev->node_desc, sizeof(dev->node_desc)-1, "%s",
+		 IB_DEFAULT_ND_FORMAT);
 
 	ret = ib_register_device(dev, NULL);
 	if (ret)
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
