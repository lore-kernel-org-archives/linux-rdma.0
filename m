From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [bug report] IB/hns: Fix the bug when destroy qp
Date: Tue, 7 Feb 2017 12:26:50 +0300
Message-ID: <20170207092650.GA26924@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Wei Hu (Xavier),

The patch d838c481e025: "IB/hns: Fix the bug when destroy qp" from
Nov 29, 2016, leads to the following static checker warning:

	drivers/infiniband/hw/hns/hns_roce_hw_v1.c:3686 hns_roce_v1_destroy_qp_work_fn()
	error: dereferencing freed memory 'hr_qp'

drivers/infiniband/hw/hns/hns_roce_hw_v1.c
  3674          hns_roce_qp_remove(hr_dev, hr_qp);
  3675          hns_roce_qp_free(hr_dev, hr_qp);
  3676  
  3677          if (hr_qp->ibqp.qp_type == IB_QPT_RC) {
  3678                  /* RC QP, release QPN */
  3679                  hns_roce_release_range_qp(hr_dev, hr_qp->qpn, 1);
  3680                  kfree(hr_qp);
                              ^^^^^
Free.

  3681          } else
  3682                  kfree(hr_to_hr_sqp(hr_qp));
  3683  
  3684          kfree(qp_work_entry);
  3685  
  3686          dev_dbg(dev, "Accomplished destroy QP(0x%lx) work.\n", hr_qp->qpn);
                                                                       ^^^^^^^^^^
Use after free.

  3687  }


regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
