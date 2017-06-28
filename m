From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [bug report] RDMA/bnxt_re: HW workarounds for handling specific
 conditions
Date: Wed, 28 Jun 2017 16:37:40 +0300
Message-ID: <20170628133740.bvqfbaleqjsjq5b4@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Eddie Wai,

The patch 9152e0b722b2: "RDMA/bnxt_re: HW workarounds for handling
specific conditions" from Jun 14, 2017, leads to the following static
checker warning:

	drivers/infiniband/hw/bnxt_re/qplib_fp.c:1737 bnxt_qplib_cq_process_req()
	warn: missing error code here? 'do_wa9060()' failed. 'rc' = '0'

drivers/infiniband/hw/bnxt_re/qplib_fp.c
  1729                          sq->condition = false;
  1730                          sq->single = false;
  1731                  } else {
  1732                          if (swq->flags & SQ_SEND_FLAGS_SIGNAL_COMP) {
  1733                                  /* Before we complete, do WA 9060 */
  1734                                  if (do_wa9060(qp, cq, cq_cons, sw_sq_cons,
  1735                                                cqe_sq_cons)) {
  1736                                          *lib_qp = qp;
  1737                                          goto out;

It's not immediately clear to an outside reviewer if we're intentionally
returning success on this path...

  1738                                  }
  1739                                  cqe->status = CQ_REQ_STATUS_OK;
  1740                                  cqe++;
  1741                                  (*budget)--;
  1742                          }
  1743                  }
  1744  skip:
  1745                  sq->hwq.cons++;
  1746                  if (sq->single)
  1747                          break;
  1748          }
  1749  out:
  1750          *pcqe = cqe;
  1751          if (HWQ_CMP(sq->hwq.cons, &sq->hwq) != cqe_sq_cons) {
  1752                  /* Out of budget */
  1753                  rc = -EAGAIN;
  1754                  goto done;
  1755          }

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
