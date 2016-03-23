From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: staging/rdma/hfi1: use mod_timer when appropriate
Date: Wed, 23 Mar 2016 23:48:17 +0300
Message-ID: <20160323204817.GA14975@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Mike Marciniszyn,

The patch 633d27399514: "staging/rdma/hfi1: use mod_timer when
appropriate" from Feb 4, 2016, leads to the following static checker
warning:

	drivers/staging/rdma/hfi1/rc.c:1500 do_rc_ack()
	info: ignoring unreachable code.

drivers/staging/rdma/hfi1/rc.c
  1487                  default:
  1488                          /* Ignore other reserved NAK error codes */
  1489                          goto reserved;
  1490                  }
  1491                  qp->s_retry = qp->s_retry_cnt;
  1492                  qp->s_rnr_retry = qp->s_rnr_retry_cnt;
  1493                  goto bail_stop;
  1494  
  1495          default:                /* 2: reserved */
  1496  reserved:
  1497                  /* Ignore reserved NAK codes. */
  1498                  goto bail_stop;
  1499          }
  1500          return ret;
                ^^^^^^^^^^
Not reachable.

  1501  bail_stop:
  1502          hfi1_stop_rc_timers(qp);
  1503          return ret;
  1504  }


regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
