From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2 for-next 4/4] IB/ipoib: Support SendOnlyFullMember
 MCG for SendOnly join
Date: Thu, 5 May 2016 21:29:14 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1605052124140.1091@east.gentwo.org>
References: <1462448219-24571-1-git-send-email-erezsh@mellanox.com> <1462448219-24571-5-git-send-email-erezsh@mellanox.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462448219-24571-5-git-send-email-erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 5 May 2016, Erez Shitrit wrote:

> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> index 2588931..fc3e50e 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> @@ -64,6 +64,9 @@ struct ipoib_mcast_iter {
>  	unsigned int       send_only;
>  };
>
> +/* join state that allows creating mcg with sendonly member request */
> +#define SENDONLY_FULLMEMBER_JOIN	8

What are the other join states etc? Should all the join states not be
defined with struct ib_sa_mcmbember_rec in include/rdma/ib_sa.h?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
