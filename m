From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: IB/srp: Fix deadlock between host removal and multipathd
Date: Tue, 5 Aug 2014 02:31:40 +0300
Message-ID: <20140804233140.GA9106@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bvanassche-HInyCGIudOg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Bart Van Assche,

The patch bcc059103591: "IB/srp: Fix deadlock between host removal
and multipathd" from Jul 9, 2014, leads to the following static
checker warning:

	drivers/infiniband/ulp/srp/ib_srp.c:3323 srp_init_module()
	warn: 'srp_remove_wq' isn't an ERR_PTR

drivers/infiniband/ulp/srp/ib_srp.c
  3321  
  3322          srp_remove_wq = create_workqueue("srp_remove");

Returns NULL on failure and not an ERR_PTR.

  3323          if (IS_ERR(srp_remove_wq)) {
  3324                  ret = PTR_ERR(srp_remove_wq);
  3325                  goto out;
  3326          }
  3327  
  3328          ret = -ENOMEM;
  3329          ib_srp_transport_template =
  3330                  srp_attach_transport(&ib_srp_transport_functions);
  3331          if (!ib_srp_transport_template)
  3332                  goto destroy_wq;

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
