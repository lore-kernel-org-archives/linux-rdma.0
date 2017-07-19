From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [bug report] IB/hns: Fix the bug of polling cq failed for loopback
 Qps
Date: Wed, 19 Jul 2017 14:48:29 +0300
Message-ID: <20170719114829.sctq34wns6h6zvxz@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello oulijun,

This is a semi-automatic email about new static checker warnings.

The patch 5802883d4b7c: "IB/hns: Fix the bug of polling cq failed for
loopback Qps" from Jun 10, 2017, leads to the following Smatch
complaint:

    drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1009 hns_roce_v1_mr_free_work_fn()
    error: we previously assumed 'hr_qp' could be null (see line 991)

drivers/infiniband/hw/hns/hns_roce_hw_v1.c
   989          for (i = 0; i < HNS_ROCE_V1_RESV_QP; i++) {
   990			hr_qp = free_mr->mr_free_qp[i];
   991			if (!hr_qp)
                             ^^^^^
New check for NULL.  Assume it happens on the last iteration through the
loop.

   992				continue;
   993			ne++;
   994	
   995			ret = hns_roce_v1_send_lp_wqe(hr_qp);
   996			if (ret) {
   997				dev_err(dev,
   998				     "Send wqe (qp:0x%lx) for mr free failed(%d)!\n",
   999				     hr_qp->qpn, ret);
  1000				goto free_work;
  1001			}
  1002		}
  1003	
  1004		do {
  1005			ret = hns_roce_v1_poll_cq(&mr_free_cq->ib_cq, ne, wc);
  1006			if (ret < 0) {
  1007				dev_err(dev,
  1008				   "(qp:0x%lx) starts, Poll cqe failed(%d) for mr 0x%x free! Remain %d cqe\n",
  1009				   hr_qp->qpn, ret, hr_mr->key, ne);
                                   ^^^^^^^^^^
Unchecked dereference.

  1010				goto free_work;
  1011			}

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
