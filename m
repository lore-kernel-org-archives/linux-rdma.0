From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/4] sunrpc: flag transports as using IETF approved
 congestion control protocols
Date: Thu, 23 Feb 2017 15:32:31 -0500
Message-ID: <1487881951.3448.10.camel@redhat.com>
References: <20170223170337.10686-1-jlayton@redhat.com>
         <20170223170337.10686-2-jlayton@redhat.com>
         <2152dfdf-f847-2511-1600-6499b6ea9708@talpey.com>
         <1487880034.3448.8.camel@redhat.com>
         <65056db6-f30a-c44d-b01c-b549887c4895@talpey.com>
         <20170223201109.GC11882@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170223201109.GC11882-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Cc: trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, schumaker.anna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-02-23 at 15:11 -0500, J. Bruce Fields wrote:
> On Thu, Feb 23, 2017 at 03:06:25PM -0500, Tom Talpey wrote:
> > On 2/23/2017 3:00 PM, Jeff Layton wrote:
> > > On Thu, 2017-02-23 at 14:42 -0500, Tom Talpey wrote:
> > > > On 2/23/2017 12:03 PM, Jeff Layton wrote:
> > > > > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > > > ---
> > > > > include/linux/sunrpc/svc_xprt.h          | 1 +
> > > > > net/sunrpc/svcsock.c                     | 1 +
> > > > > net/sunrpc/xprtrdma/svc_rdma_transport.c | 2 ++
> > > > 
> > > > There's a possibly-important detail here. Not all RDMA transports have
> > > > "IETF-approved congestion control", for example, RoCEv1. However, iWARP
> > > > and (arguably) RoCEv2 do. On the other hand, as a nonroutable protocol,
> > > > RoCEv1 may not fall under this restriction.
> > > > 
> > > > Net-net, inspecting only the RDMA attribute of the transport may be
> > > > insufficient here.
> > > > 
> > > > It could be argued however that the xprtrdma layer, with its rpcrdma
> > > > crediting, provides such congestion. But that needs to be made
> > > > explicit, and perhaps, discussed in IETF. Initially, I think it would
> > > > be important to flag this as a point for the future. For now, it may
> > > > be best to flag RoCEv1 as not supporting congestion.
> > > > 
> > > > Tom.
> > > > 
> > > 
> > > (cc'ing Chuck and the linux-rdma list)
> > > 
> > > Thanks Tom, that's very interesting.
> > > 
> > > Not being well versed in the xprtrdma layer, what condition should we
> > > use here to set the flag? git grep shows that the string "ROCEV1" only
> > > shows up in the bxnt_en driver. Is there some way to determine this
> > > generically for any given RDMA driver?
> > 
> > I would not code RoCEv1 as an exception, I would code iWARP and RoCEv2
> > as the only eligible ones. There are any number of other possibilities,
> > none of which should be automatically flagged as congestion-controlled.
> > 
> > I'm also not sure I'm comfortable with hardcoding such a list into RPC.
> > But it may be the best you can do for now. Chuck, are you aware of a
> > verbs interface to obtain the RDMA transport type?
> 
> If this gets too complicated--we've been allowing NFSv4/UDP for years,
> letting this one (arguable?) exception through in RDMA a little longer
> won't kill us.
> 

That's my feeling too. This is still an improvement over the status
quo, and hopefully anyone with RDMA hardware will have a bit more clue
as to whether it can properly support v4.

We can always further restrict when rdma_create_xprt sets the flag in a
later patch if we figure out some way to determine this generically. I
will plan to add a comment that we're setting this RDMA svc_xprt
universally even though it may not always be true.

> (And if we really shouldn't be doing NFSv4 over some RDMA transports--is
> it worth supporting them at all, if the only support we can get is
> NFSv3-only?)
> 

I'd be inclined to leave them working and just deny the use of v4 on
such transports.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
