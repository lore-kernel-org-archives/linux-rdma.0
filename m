From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [bug report] qedr: Add support for QP verbs
Date: Wed, 23 Nov 2016 13:58:31 +0300
Message-ID: <20161123105831.GA11837@mwanda>
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

	drivers/infiniband/hw/qedr/verbs.c:1494 qedr_create_qp()
	warn: possible memory leak of 'qp'

drivers/infiniband/hw/qedr/verbs.c
  1484  
  1485          rc = qedr_check_qp_attrs(ibpd, dev, attrs);
  1486          if (rc)
  1487                  return ERR_PTR(rc);
  1488  
  1489          qp = kzalloc(sizeof(*qp), GFP_KERNEL);
  1490          if (!qp)
  1491                  return ERR_PTR(-ENOMEM);
  1492  
  1493          if (attrs->srq)
  1494                  return ERR_PTR(-EINVAL);

You should move this in front of the allocation to avoid the memory
leak.

  1495  
  1496          DP_DEBUG(dev, QEDR_MSG_QP,
  1497                   "create qp: sq_cq=%p, sq_icid=%d, rq_cq=%p, rq_icid=%d\n",
  1498                   get_qedr_cq(attrs->send_cq),
  1499                   get_qedr_cq(attrs->send_cq)->icid,
  1500                   get_qedr_cq(attrs->recv_cq),
  1501                   get_qedr_cq(attrs->recv_cq)->icid);
  1502  
  1503          qedr_set_qp_init_params(dev, qp, pd, attrs);
  1504  
  1505          if (attrs->qp_type == IB_QPT_GSI) {
  1506                  if (udata) {
  1507                          DP_ERR(dev,
  1508                                 "create qp: unexpected udata when creating GSI QP\n");
  1509                          goto err0;

Ugh...  GW-BASIC style numbered labels...  What does goto err0 do???
Imagine if instead of function names we should use numbers like:

	one();
	two();
	five();

Use a meaningful label names like "goto free_qp;"

  1510                  }
  1511                  return qedr_create_gsi_qp(dev, attrs, qp);

We should free qp if qedr_create_gsi_qp() fails as well.

  1512          }
  1513  
  1514          memset(&in_params, 0, sizeof(in_params));
  1515  
  1516          if (udata) {
  1517                  if (!(udata && ibpd->uobject && ibpd->uobject->context))
  1518                          goto err0;
  1519  

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
