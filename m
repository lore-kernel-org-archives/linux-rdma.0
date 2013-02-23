From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: RDMA/amso1100: Add driver for Ammasso 1100 RNIC
Date: Sat, 23 Feb 2013 08:37:55 +0300
Message-ID: <20130223053754.GA20085@longonot.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Tom Tucker,

The patch f94b533d091a: "RDMA/amso1100: Add driver for Ammasso 1100 
RNIC" from Sep 22, 2006, leads to the following warning:
"drivers/infiniband/hw/amso1100/c2_provider.c:272 c2_create_qp()
	 error: passing non neg 255 to ERR_PTR"

drivers/infiniband/hw/amso1100/c2_qp.c
   496          reply = (struct c2wr_qp_create_rep *) (unsigned long) (vq_req->reply_msg);
   497          if (!reply) {
   498                  err = -ENOMEM;
   499                  goto bail3;
   500          }
   501  
   502          if ((err = c2_wr_get_result(reply)) != 0) {
                           ^^^^^^^^^^^^^^^^^^^^^^^

This returns an unsigned char and not a negative error code.

   503                  goto bail4;
   504          }
   505  
   506          /* Fill in the kernel QP struct */

regards,
dan carpenter

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
