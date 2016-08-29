From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 2/6] IB/core: add support to create a unsafe global rkey to ib_create_pd
Date: Mon, 29 Aug 2016 10:32:53 -0500
Message-ID: <013801d2020a$9c049440$d40dbcc0$@opengridcomputing.com>
References: <1472464943-29450-1-git-send-email-hch@lst.de> <1472464943-29450-3-git-send-email-hch@lst.de> <012c01d20209$ddb1bd60$99153820$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <012c01d20209$ddb1bd60$99153820$@opengridcomputing.com>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> > Instead of exposing ib_get_dma_mr to ULPs and letting them use it more or
> > less unchecked, this moves the capability of creating a global rkey into
> > the RDMA core, where it can be easily audited.  It also prints a warning
> > everytime this feature is used as well.
> >
> > Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> 
> looks good.
> 
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> 
 
Correction: 

Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

:)


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
