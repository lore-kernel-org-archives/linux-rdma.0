From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-next] RDMA/cxgb4: Annotate r2 and stag as __be32
Date: Wed, 25 Oct 2017 15:12:00 -0500
Message-ID: <037e01d34dcd$845c1ce0$8d1456a0$@opengridcomputing.com>
References: <20171025201019.7367-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171025201019.7367-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> Chelsio cxgb4 HW is big-endian, hence there is need to properly
> annotate r2 and stag fields as __be32 and not __u32 to fix the
> following sparse warnings.
> 
>   drivers/infiniband/hw/cxgb4/qp.c:614:16:
>     warning: incorrect type in assignment (different base types)
>       expected unsigned int [unsigned] [usertype] r2
>       got restricted __be32 [usertype] <noident>
>   drivers/infiniband/hw/cxgb4/qp.c:615:18:
>     warning: incorrect type in assignment (different base types)
>       expected unsigned int [unsigned] [usertype] stag
>       got restricted __be32 [usertype] <noident>
> 
> Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Looks fine. Thanks Leon!

Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
