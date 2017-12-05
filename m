From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH] RDMA/cxgb4: Add a sanity check in process_work()
Date: Tue, 5 Dec 2017 09:05:28 -0600
Message-ID: <017901d36dda$7cab1000$76013000$@opengridcomputing.com>
References: <20171205143654.n5ybdhj3ga2tp7t4@mwanda>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171205143654.n5ybdhj3ga2tp7t4@mwanda>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Dan Carpenter' <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Jason Gunthorpe' <jgg-uk2M96/98Pc@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
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

Acked-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
