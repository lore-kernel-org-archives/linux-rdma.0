From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [bug report] RDMA/iw_cxgb4: Handle return value of c4iw_ofld_send()
 in abort_arp_failure()
Date: Thu, 23 Feb 2017 18:58:09 +0300
Message-ID: <20170223155809.GA16463@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Hariprasad S,

The patch 761e19a504af: "RDMA/iw_cxgb4: Handle return value of
c4iw_ofld_send() in abort_arp_failure()" from May 6, 2016, leads to
the following static checker warning:

	drivers/infiniband/hw/cxgb4/cm.c:575 abort_arp_failure()
	warn: passing freed memory 'skb'

drivers/infiniband/hw/cxgb4/cm.c
   559  /*
   560   * Handle an ARP failure for a CPL_ABORT_REQ.  Change it into a no RST variant
   561   * and send it along.
   562   */
   563  static void abort_arp_failure(void *handle, struct sk_buff *skb)
   564  {
   565          int ret;
   566          struct c4iw_ep *ep = handle;
   567          struct c4iw_rdev *rdev = &ep->com.dev->rdev;
   568          struct cpl_abort_req *req = cplhdr(skb);
   569  
   570          PDBG("%s rdev %p\n", __func__, rdev);
   571          req->cmd = CPL_ABORT_NO_RST;
   572          ret = c4iw_ofld_send(rdev, skb);
   573          if (ret) {

If c4iw_ofld_send() fails then it frees skb.

   574                  __state_set(&ep->com, DEAD);
   575                  queue_arp_failure_cpl(ep, skb, FAKE_CPL_PUT_EP_SAFE);
                                                  ^^^
Used after free here.  These are ref counted data so it might actually
be that I have misread it and miscounted the references so perhaps it's
OK, but it looks might suspect at a glance.

   576          }
   577  }

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
