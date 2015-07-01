From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH V3 2/4] ipath,qib: Expose max_sge_rd correctly
Date: Wed, 01 Jul 2015 11:30:47 -0500
Message-ID: <20150701163047.6501.13146.stgit@build.ogc.int>
References: <20150701162936.6501.45512.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150701162936.6501.45512.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Applications must not assume that max_sge and max_sge_rd are the same,
Hence expose max_sge_rd correctly as well.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Acked-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/ipath/ipath_verbs.c |    1 +
 drivers/infiniband/hw/qib/qib_verbs.c     |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.c b/drivers/infiniband/hw/ipath/ipath_verbs.c
index 48253b8..d958236 100644
--- a/drivers/infiniband/hw/ipath/ipath_verbs.c
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.c
@@ -1521,6 +1521,7 @@ static int ipath_query_device(struct ib_device *ibdev, struct ib_device_attr *pr
 	props->max_qp = ib_ipath_max_qps;
 	props->max_qp_wr = ib_ipath_max_qp_wrs;
 	props->max_sge = ib_ipath_max_sges;
+	props->max_sge_rd = ib_ipath_max_sges;
 	props->max_cq = ib_ipath_max_cqs;
 	props->max_ah = ib_ipath_max_ahs;
 	props->max_cqe = ib_ipath_max_cqes;
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index a05d1a3..bc723b5 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1574,6 +1574,7 @@ static int qib_query_device(struct ib_device *ibdev, struct ib_device_attr *prop
 	props->max_qp = ib_qib_max_qps;
 	props->max_qp_wr = ib_qib_max_qp_wrs;
 	props->max_sge = ib_qib_max_sges;
+	props->max_sge_rd = ib_qib_max_sges;
 	props->max_cq = ib_qib_max_cqs;
 	props->max_ah = ib_qib_max_ahs;
 	props->max_cqe = ib_qib_max_cqes;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
