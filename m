From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: IB/qib: use arch_phys_wc_add()
Date: Tue, 12 May 2015 21:09:05 +0300
Message-ID: <20150512180905.GC5672@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mcgrof-IBi9RG/b67k@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Luis R. Rodriguez,

The patch d4988623cc60: "IB/qib: use arch_phys_wc_add()" from Apr 22,
2015, leads to the following static checker warning:

	drivers/infiniband/hw/qib/qib_wc_x86_64.c:120 qib_enable_wc()
	warn: unsigned 'dd->wc_cookie' is never less than zero.

drivers/infiniband/hw/qib/qib_wc_x86_64.c
   117  
   118          if (!ret) {
   119                  dd->wc_cookie = arch_phys_wc_add(pioaddr, piolen);
   120                  if (dd->wc_cookie < 0)
                            ^^^^^^^^^^^^^^^^^
arch_phys_wc_add() does return negatives on error but this is unsigned.

   121                          ret = -EINVAL;
   122          }
   123  
   124          return ret;
   125  }

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
