From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [bug report] qedr: Add support for QP verbs
Date: Mon, 14 Nov 2016 16:03:10 +0300
Message-ID: <20161114130310.GA14500@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Ram Amrani,

The patch cecbcddf6461: "qedr: Add support for QP verbs" from Oct 10,
2016, leads to the following static checker warning:

	drivers/infiniband/hw/qedr/verbs.c:2067 qedr_destroy_qp()
	'0x5 | 0x1' has '0x1' set on both sides

drivers/infiniband/hw/qedr/verbs.c
  2056  int qedr_destroy_qp(struct ib_qp *ibqp)
  2057  {
  2058          struct qedr_qp *qp = get_qedr_qp(ibqp);
  2059          struct qedr_dev *dev = qp->dev;
  2060          struct ib_qp_attr attr;
  2061          int attr_mask = 0;
  2062          int rc = 0;
  2063  
  2064          DP_DEBUG(dev, QEDR_MSG_QP, "destroy qp: destroying %p, qp type=%d\n",
  2065                   qp, qp->qp_type);
  2066  
  2067          if (qp->state != (QED_ROCE_QP_STATE_RESET | QED_ROCE_QP_STATE_ERR |
  2068                            QED_ROCE_QP_STATE_INIT)) {

These aren't bitfields, they're just numbers.  This code is pretty
suspect.  Not sure what was intended.

  2069                  attr.qp_state = IB_QPS_ERR;
  2070                  attr_mask |= IB_QP_STATE;
  2071  
  2072                  /* Change the QP state to ERROR */
  2073                  qedr_modify_qp(ibqp, &attr, attr_mask, NULL);
  2074          }

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
