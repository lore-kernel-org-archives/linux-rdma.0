From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [bug report] IB/cma: Add default RoCE TOS to CMA configfs
Date: Tue, 31 Jan 2017 13:59:29 +0300
Message-ID: <20170131105929.GA6788@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Majd Dibbiny,

The patch eeec11e5c404: "IB/cma: Add default RoCE TOS to CMA
configfs" from Dec 19, 2016, leads to the following static checker
warning:

	drivers/infiniband/core/cma.c:303 cma_get_default_roce_tos()
	warn: signedness bug returning '(-22)'

drivers/infiniband/core/cma.c
   298  
   299  u8 cma_get_default_roce_tos(struct cma_device *cma_dev, unsigned int port)
   300  {
   301          if (port < rdma_start_port(cma_dev->device) ||
   302              port > rdma_end_port(cma_dev->device))
   303                  return -EINVAL;

This is a u8 function so you can't return negative error codes.

   304  
   305          return cma_dev->default_roce_tos[port - rdma_start_port(cma_dev->device)];
   306  }
   307  

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
