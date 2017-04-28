From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH v2 03/19] IB/core: For multicast functions,
 verify that LIDs are multicast LIDs
Date: Fri, 28 Apr 2017 10:39:11 -0700
Message-ID: <20170428173909.23960.80030.stgit@scvm10.sc.intel.com>
References: <20170428173443.23960.32602.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170428173443.23960.32602.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Ira Weiny <ira.weiny@intel.com>, stable@vger.kernel.org, Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl@intel.com>

The Infiniband spec defines "A multicast address is defined by a
MGID and a MLID" (section 10.5).  Currently the MLID value is not
validated.

Add check to verify that the MLID value is in the correct address
range.

Fixes: 0c33aeedb2cf ("[IB] Add checks to multicast attach and detach")
Cc: stable@vger.kernel.org
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
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
