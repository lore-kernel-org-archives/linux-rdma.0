From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Potential NULL pointer dereference in drivers/infiniband/core
Date: Tue, 21 Feb 2017 13:59:19 +0200
Message-ID: <20170221115918.GA3616@yuval-lap>
References: <7e4ed5f8bdc1578f2459231c78e0d1e9@cs.utah.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7e4ed5f8bdc1578f2459231c78e0d1e9-sDh8Nw2yj/+Vc3sceRu5cw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shaobo <shaobo-sDh8Nw2yj/+Vc3sceRu5cw@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 20, 2017 at 11:23:41PM -0700, Shaobo wrote:
> Dear developers,
> 
> My name is Shaobo He and I am a graduate student at University of
> Utah. I am applying a static analysis tool to the Linux device
> drivers and got an error trace of null pointer dereference in
> drivers/infiniband/core starting from function `ucma_accept`: it
> calls `rdma_accept` with the second argument being NULL. In
> `rdma_accept`, `cma_accept_iw` is called with the second argument
> also being NULL. Then in `cma_accept_iw`, `cma_modify_qp_rtr` can
> return 0 if `id_priv->id.qp` is NULL, which can be suggested by an
> if statement in `rdma_accept`. Finally, the second argument
> `conn_param` of `cma_accept_iw` gets dereferenced. As you can see,
> the error trace is only plausible since it depends on certain
> conditions. Therefore, I was wondering if you could confirm it.
> 
> Thanks for your time. I am looking forward to your reply.

Suggesting to prepare a patch and ask for review.
I believe the issue will get faster attention this way.

> 
> Best,
> Shaobo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
