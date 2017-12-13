From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: RDMA/cxgb4: Add a sanity check in process_work()
Date: Wed, 13 Dec 2017 11:20:26 -0700
Message-ID: <20171213182026.GE5984@ziepe.ca>
References: <20171205143654.n5ybdhj3ga2tp7t4@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171205143654.n5ybdhj3ga2tp7t4@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 05, 2017 at 05:36:54PM +0300, Dan Carpenter wrote:
> The story is that Smatch marks skb->data as untrusted so it generates
> a warning message here:
> 
>     drivers/infiniband/hw/cxgb4/cm.c:4100 process_work()
>     error: buffer overflow 'work_handlers' 241 <= 255
> 
> In other places which handle this such as t4_uld_rx_handler() there is
> some checking to make sure that the function pointer is not NULL.  I
> have added bounds checking and a check for NULL here as well.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Acked-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Thanks, applied to -next

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
