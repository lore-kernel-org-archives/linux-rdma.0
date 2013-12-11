From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: IB/usnic: Add Cisco VIC low-level hardware driver
Date: Thu, 12 Dec 2013 01:39:35 +0300
Message-ID: <20131211223934.GB3955@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Upinder Malhi,

The patch b1819c455542: "IB/usnic: Add Cisco VIC low-level hardware
driver" from Sep 10, 2013, leads to the following Smatch
warning:

	drivers/infiniband/hw/usnic/usnic_uiom.c:560
	usnic_uiom_get_dev_list()
	error: scheduling with locks held: 'spin_lock:lock'

drivers/infiniband/hw/usnic/usnic_uiom.c
   553  struct device **usnic_uiom_get_dev_list(struct usnic_uiom_pd *pd)
   554  {
   555          struct usnic_uiom_dev *uiom_dev;
   556          struct device **devs;
   557          int i = 0;
   558  
   559          spin_lock(&pd->lock);
   560          devs = kzalloc(sizeof(*devs)*(pd->dev_cnt + 1), GFP_KERNEL);
                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
You can't do blocking allocations with a spin_lock held.

   561          if (!devs) {
   562                  devs = ERR_PTR(-ENOMEM);
   563                  goto out;
   564          }

regards,
dan carpenter

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
