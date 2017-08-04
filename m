From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 02/27] IB/hfi1: Remove pmtu from the QP structure
Date: Fri, 04 Aug 2017 13:52:20 -0700
Message-ID: <20170804205219.17853.6849.stgit@scvm10.sc.intel.com>
References: <20170804204842.17853.14858.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170804204842.17853.14858.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The pmtu field doens't have be stored in the QP structure
as it can easily be calculated when needed.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c |    3 +--
 include/rdma/rdmavt_qp.h          |    1 -
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 1878a97..eb0c3d6 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -1243,7 +1243,6 @@ int rvt_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 
 	if (attr_mask & IB_QP_PATH_MTU) {
 		qp->pmtu = rdi->driver_f.mtu_from_qp(rdi, qp, pmtu);
-		qp->path_mtu = rdi->driver_f.mtu_to_path_mtu(qp->pmtu);
 		qp->log_pmtu = ilog2(qp->pmtu);
 	}
 
@@ -1366,7 +1365,7 @@ int rvt_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 
 	attr->qp_state = qp->state;
 	attr->cur_qp_state = attr->qp_state;
-	attr->path_mtu = qp->path_mtu;
+	attr->path_mtu = rdi->driver_f.mtu_to_path_mtu(qp->pmtu);
 	attr->path_mig_state = qp->s_mig_state;
 	attr->qkey = qp->qkey;
 	attr->rq_psn = qp->r_psn & rdi->dparms.psn_mask;
diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index 07e2fff..8fbafb0 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -277,7 +277,6 @@ struct rvt_qp {
 
 	unsigned long timeout_jiffies;  /* computed from timeout */
 
-	enum ib_mtu path_mtu;
 	int srate_mbps;		/* s_srate (below) converted to Mbit/s */
 	pid_t pid;		/* pid for user mode QPs */
 	u32 remote_qpn;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
