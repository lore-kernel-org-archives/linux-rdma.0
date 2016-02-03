From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/7] IB/rdmavt: Add hardware driver send work request check
Date: Wed, 03 Feb 2016 14:14:45 -0800
Message-ID: <20160203221441.1765.13106.stgit@scvm10.sc.intel.com>
References: <20160203221136.1765.8947.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203221136.1765.8947.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Some hardware drivers requires additional checks on send WRs.  Create an
optional call back to allow hardware drivers to reject a send WR.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c |    4 ++++
 include/rdma/rdma_vt.h            |    2 ++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 8efb0f5..34c92c0 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -1387,6 +1387,10 @@ static int rvt_post_one_wr(struct rvt_qp *qp, struct ib_send_wr *wr)
 	if (next == qp->s_last)
 		return -ENOMEM;
 
+	if (rdi->driver_f.check_send_wr &&
+	    rdi->driver_f.check_send_wr(qp, wr))
+		return -EINVAL;
+
 	rkt = &rdi->lkey_table;
 	pd = ibpd_to_rvtpd(qp->ibqp.pd);
 	wqe = rvt_get_swqe_ptr(qp, qp->s_head);
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 1b77065..52dfa9c 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -265,6 +265,8 @@ struct rvt_driver_provided {
 	void (*modify_qp)(struct rvt_qp *qp, struct ib_qp_attr *attr,
 			  int attr_mask, struct ib_udata *udata);
 
+	int (*check_send_wr)(struct rvt_qp *qp, struct ib_send_wr *wr);
+
 	void (*notify_create_mad_agent)(struct rvt_dev_info *rdi, int port_idx);
 	void (*notify_free_mad_agent)(struct rvt_dev_info *rdi, int port_idx);
 };

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
