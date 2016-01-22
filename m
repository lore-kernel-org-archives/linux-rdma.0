From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 6/7] IB/rdmavt: Add support for rvt_query_device function
Date: Fri, 22 Jan 2016 12:50:36 -0800
Message-ID: <20160122205035.4351.18507.stgit@scvm10.sc.intel.com>
References: <20160122204807.4351.24569.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160122204807.4351.24569.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

With this commit, the drivers using rdmavt need not define query_device
function. But they should fill in the IB device attributes structure
rvt_dev_info.dparms.props

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/vt.c |    9 +++++++--
 include/rdma/rdma_vt.h            |    5 ++++-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index e75eb3d..f2b6438 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -68,10 +68,15 @@ static int rvt_query_device(struct ib_device *ibdev,
 			    struct ib_device_attr *props,
 			    struct ib_udata *uhw)
 {
+	struct rvt_dev_info *rdi = ib_to_rvt(ibdev);
+
+	if (uhw->inlen || uhw->outlen)
+		return -EINVAL;
 	/*
-	 * Return rvt_dev_info.props contents
+	 * Return rvt_dev_info.dparms.props contents
 	 */
-	return -EOPNOTSUPP;
+	*props = rdi->dparms.props;
+	return 0;
 }
 
 static int rvt_modify_device(struct ib_device *device,
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index e412e67..725778a 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -245,7 +245,10 @@ struct rvt_dev_info {
 	 * allocating space for this structure.
 	 *
 	 * The driver will also be responsible for filling in certain members of
-	 * dparms.props
+	 * dparms.props. The driver needs to fill in dparms exactly as it would
+	 * want values reported to a ULP. This will be returned to the caller
+	 * in rdmavt's device. The driver should also therefore refrain from
+	 * modifying this directly after registration with rdmavt.
 	 */
 
 	/* Driver specific properties */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
