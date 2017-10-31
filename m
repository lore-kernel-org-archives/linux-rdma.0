From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: 4.13 ib_mthca NULL pointer dereference with OpenSM
Date: Mon, 30 Oct 2017 22:24:35 -0600
Message-ID: <20171031042435.GB7961@ziepe.ca>
References: <CALpBJjoMLCqzVe5yKp4wCX-X-sH+=zv1QZfMvOWh2Ukh3c2LFg@mail.gmail.com>
 <20171029191114.GO16127@mtr-leonro.local>
 <CALpBJjoJpgR1QB-gzRJLOjGtjK4T2H4EbG1-R+ndodvznWkgwA@mail.gmail.com>
 <20171030071956.GU16127@mtr-leonro.local>
 <CALpBJjqWrXu3b12EG2-AWKwKs9v2q5pTf11rXSy04C-5dGta6A@mail.gmail.com>
 <20171030230156.GA4081@ziepe.ca>
 <VI1PR0502MB300860F7C004ABFB01079F53D15E0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <VI1PR0502MB300860F7C004ABFB01079F53D15E0-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Chris Blake <chrisrblake93-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 31, 2017 at 03:16:42AM +0000, Parav Pandit wrote:

> I am yet to review my below patch with Dan as he did most security
> dev, but I suspect this might be the cause where rmpp list is not
> initialized and mad processing is continued when security check
> fails.

This patch sure looks needed to me, ib_free_recv_mad touches
rmpp_list, so if it needs initializion then it certainly has to be
done earlier..

Adding the new return sure makes alot of sense as well..

Hal, Ira, would you check this routine too? kernel oops's are bad..

> diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
> index f8f53bb..cb91245 100644
> +++ b/drivers/infiniband/core/mad.c
> @@ -1974,14 +1974,15 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
>         unsigned long flags;
>         int ret;
> 
> +       INIT_LIST_HEAD(&mad_recv_wc->rmpp_list);
>         ret = ib_mad_enforce_security(mad_agent_priv,
>                                       mad_recv_wc->wc->pkey_index);
>         if (ret) {
>                 ib_free_recv_mad(mad_recv_wc);
>                 deref_mad_agent(mad_agent_priv);
> +               return;
>         }
> 
> -       INIT_LIST_HEAD(&mad_recv_wc->rmpp_list);
>         list_add(&mad_recv_wc->recv_buf.list, &mad_recv_wc->rmpp_list);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
