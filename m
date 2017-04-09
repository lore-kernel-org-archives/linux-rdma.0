From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 04/20] IB/core: For multicast functions,
 verify that LIDs are multicast LIDs
Date: Sun, 09 Apr 2017 10:15:51 -0700
Message-ID: <20170409171549.10579.98819.stgit@scvm10.sc.intel.com>
References: <20170409171329.10579.92775.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170409171329.10579.92775.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The Infiniband spec defines "A multicast address is defined by a
MGID and a MLID" (section 10.5).  Currently the MLID value is not
validated.

Add check to verify that the MLID value is in the correct address
range.

Fixes: 0c33aeedb2cf ("[IB] Add checks to multicast attach and detach")
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 85ed505..207e5c2 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1519,7 +1519,9 @@ int ib_attach_mcast(struct ib_qp *qp, union ib_gid *gid, u16 lid)
 
 	if (!qp->device->attach_mcast)
 		return -ENOSYS;
-	if (gid->raw[0] != 0xff || qp->qp_type != IB_QPT_UD)
+	if (gid->raw[0] != 0xff || qp->qp_type != IB_QPT_UD ||
+	    lid < be16_to_cpu(IB_MULTICAST_LID_BASE) ||
+	    lid == be16_to_cpu(IB_LID_PERMISSIVE))
 		return -EINVAL;
 
 	ret = qp->device->attach_mcast(qp, gid, lid);
@@ -1535,7 +1537,9 @@ int ib_detach_mcast(struct ib_qp *qp, union ib_gid *gid, u16 lid)
 
 	if (!qp->device->detach_mcast)
 		return -ENOSYS;
-	if (gid->raw[0] != 0xff || qp->qp_type != IB_QPT_UD)
+	if (gid->raw[0] != 0xff || qp->qp_type != IB_QPT_UD ||
+	    lid < be16_to_cpu(IB_MULTICAST_LID_BASE) ||
+	    lid == be16_to_cpu(IB_LID_PERMISSIVE))
 		return -EINVAL;
 
 	ret = qp->device->detach_mcast(qp, gid, lid);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
