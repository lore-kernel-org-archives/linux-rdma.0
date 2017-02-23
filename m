From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/4] sunrpc: flag transports as using IETF approved
 congestion control protocols
Date: Thu, 23 Feb 2017 15:00:34 -0500
Message-ID: <1487880034.3448.8.camel@redhat.com>
References: <20170223170337.10686-1-jlayton@redhat.com>
         <20170223170337.10686-2-jlayton@redhat.com>
         <2152dfdf-f847-2511-1600-6499b6ea9708@talpey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2152dfdf-f847-2511-1600-6499b6ea9708-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org
Cc: schumaker.anna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-02-23 at 14:42 -0500, Tom Talpey wrote:
> On 2/23/2017 12:03 PM, Jeff Layton wrote:
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  include/linux/sunrpc/svc_xprt.h          | 1 +
> >  net/sunrpc/svcsock.c                     | 1 +
> >  net/sunrpc/xprtrdma/svc_rdma_transport.c | 2 ++
> 
> There's a possibly-important detail here. Not all RDMA transports have
> "IETF-approved congestion control", for example, RoCEv1. However, iWARP
> and (arguably) RoCEv2 do. On the other hand, as a nonroutable protocol,
> RoCEv1 may not fall under this restriction.
> 
> Net-net, inspecting only the RDMA attribute of the transport may be
> insufficient here.
> 
> It could be argued however that the xprtrdma layer, with its rpcrdma
> crediting, provides such congestion. But that needs to be made
> explicit, and perhaps, discussed in IETF. Initially, I think it would
> be important to flag this as a point for the future. For now, it may
> be best to flag RoCEv1 as not supporting congestion.
> 
> Tom.
> 

(cc'ing Chuck and the linux-rdma list)

Thanks Tom, that's very interesting.

Not being well versed in the xprtrdma layer, what condition should we
use here to set the flag? git grep shows that the string "ROCEV1" only
shows up in the bxnt_en driver. Is there some way to determine this
generically for any given RDMA driver?


> >  3 files changed, 4 insertions(+)
> > 
> > diff --git a/include/linux/sunrpc/svc_xprt.h b/include/linux/sunrpc/svc_xprt.h
> > index 7440290f64ac..f8aa9452b63c 100644
> > --- a/include/linux/sunrpc/svc_xprt.h
> > +++ b/include/linux/sunrpc/svc_xprt.h
> > @@ -67,6 +67,7 @@ struct svc_xprt {
> >  #define XPT_CACHE_AUTH	11		/* cache auth info */
> >  #define XPT_LOCAL	12		/* connection from loopback interface */
> >  #define XPT_KILL_TEMP   13		/* call xpo_kill_temp_xprt before closing */
> > +#define XPT_CONG_CTRL	14		/* IETF approved congestion control protocol */
> > 
> >  	struct svc_serv		*xpt_server;	/* service for transport */
> >  	atomic_t    	    	xpt_reserved;	/* space on outq that is rsvd */
> > diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
> > index de066acdb34e..1956b8b96b2d 100644
> > --- a/net/sunrpc/svcsock.c
> > +++ b/net/sunrpc/svcsock.c
> > @@ -1306,6 +1306,7 @@ static void svc_tcp_init(struct svc_sock *svsk, struct svc_serv *serv)
> >  	svc_xprt_init(sock_net(svsk->sk_sock->sk), &svc_tcp_class,
> >  		      &svsk->sk_xprt, serv);
> >  	set_bit(XPT_CACHE_AUTH, &svsk->sk_xprt.xpt_flags);
> > +	set_bit(XPT_CONG_CTRL, &svsk->sk_xprt.xpt_flags);
> >  	if (sk->sk_state == TCP_LISTEN) {
> >  		dprintk("setting up TCP socket for listening\n");
> >  		set_bit(XPT_LISTENER, &svsk->sk_xprt.xpt_flags);
> > diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
> > index 39652d390a9c..96b4797c2c54 100644
> > --- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
> > +++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
> > @@ -571,6 +571,8 @@ static struct svcxprt_rdma *rdma_create_xprt(struct svc_serv *serv,
> >  	spin_lock_init(&cma_xprt->sc_ctxt_lock);
> >  	spin_lock_init(&cma_xprt->sc_map_lock);
> > 
> > +	set_bit(XPT_CONG_CTRL, &cma_xprt->sc_xprt.xpt_flags);
> > +
> >  	if (listener)
> >  		set_bit(XPT_LISTENER, &cma_xprt->sc_xprt.xpt_flags);
> > 
> > 

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
