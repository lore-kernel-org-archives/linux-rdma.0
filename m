From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 0/3] iw_cxgb3/4 bug fixes
Date: Wed, 20 Apr 2016 12:13:25 -0500
Message-ID: <00af01d19b27$f2ed8fe0$d8c8afa0$@opengridcomputing.com>
References: <20160412143035.3B08CE08CA@smtp.ogc.us>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160412143035.3B08CE08CA-/5N3P9jjx0xzbRFIqnYvSA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> Here are three important bug fixes that I recommend get pulled into
> 4.6-rc.
> 
> Steve Wise (3):
>   iw_cxgb4: initialize ibdev.iwcm->ifname for port mapping
>   iw_cxgb3: initialize ibdev.iwcm->ifname for port mapping
>   iw_cxgb4: handing draining an idle qp
> 
>  drivers/infiniband/hw/cxgb3/iwch_provider.c |  2 ++
>  drivers/infiniband/hw/cxgb4/provider.c      |  2 ++
>  drivers/infiniband/hw/cxgb4/qp.c            | 18 ++++++++++++++++--
>  3 files changed, 20 insertions(+), 2 deletions(-)
> 

Hey Doug, Will you pull these in for 4.6-rc?

Thanks,

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
