From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/3] Support out of order data placement
Date: Tue, 1 Aug 2017 20:48:21 -0600
Message-ID: <20170802024821.GA25654@obsidianresearch.com>
References: <VI1PR0502MB30089915EB792CD20CA9D179D1A50@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <4444a96a-c1e6-ad33-204a-680982e19bfe@talpey.com>
 <20170722160939.GA30007@obsidianresearch.com>
 <VI1PR0502MB3008E483BB36F944C2E212ACD1A50@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170722212706.GA14714@obsidianresearch.com>
 <VI1PR0502MB300871C35E1CC06EB378D6C8D1B30@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170801190052.GA31205@obsidianresearch.com>
 <VI1PR0502MB3008D65E9568764C4A781230D1B30@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170801233754.GB10239@obsidianresearch.com>
 <VI1PR0502MB300860BDA4E6BD0B10F5DB1ED1B00@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <VI1PR0502MB300860BDA4E6BD0B10F5DB1ED1B00-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 02, 2017 at 12:30:33AM +0000, Parav Pandit wrote:

> > But doing that pretty much destroys much of the entire point of having a relaxed
> > ordering :P

> Probably not. I can understand that having that would be possibly ultimate thing.
> I like to add that whenever its available too.
> Some of the applications are heavy write or read driven instead of mix operations - those benefit from this attribute.

My point is, defining a 'relaxed ordering' feature such that as much
as is sensible is allowed to reordered allows the hardware to catch up
to prepared software.

The work to update the standards and CM is going to be large enough to
not want to do it more than once.

So you are better to come up with something broad and well described
that ycan be 'grown into'

> > > > > >  RDMA-W VA=0 Data=1
> > > > > >  RDMA-W VA=0 Data=2
> > > > > >  SEND
> > > > > >
> > > > > > Sounds like with the relaxed version the app could see 1 at SEND CQ time.
> > > > > >
> > > > > > So RDMA-W -> RDMA-W degrades to a F
> > > >
> > > > > No. Table-76 is based on  how requester sees the execution.
> > > > > So it stays as '#'.
> > > >
> > > > How is this possible?
> > > >
> > > Please don't mix requester side ordering with responder side execution.
> > > C9-28 on responder side is relaxed - as explained few times before.
> > 
> > No, I see what you are tring to say now. 
> Great.
> 
> > I disagree with this. Table-76 and C9-28
> > are describing the same thing, you cannot weaken C9-28 without also restating
> > Table 76.

> The intent is to not extend the definition of fence bit beyond RDMA
> reads here.

I am not talk about fence, I am saying, when the OOO attribute is set
some of the '#' must become 'F'  because the entire end-to-end system
no longer guarantees strict in order execution.

> What you are asking is when ooo attribute is set, and if user still
> wants to do in-order RDMA Writes for W1 and W2, fence bit should be
> extended for it.

Yes, I am also suggesting this should be true. The fence bit would
have to cause the sender to stop sending until acks are seen.

> There can be very few use cases where certain operations needs to
> follow ordering and certain don't in a single QP.  User is rather
> better off not setting this attribute on a QP when it needs W1, W2
> ordering.

Depends on use case, an app might do well to track outstanding ops by
address and only setting fence if there is a collision, for instance.

> So it can still send out the ACK while invalidation in progress (not
> yet started).

Not only an ack but it can begin processing another RDMA WRITE while
invalidation is ongoing, which is compatible with the idea that RDMA
WRITE can begin processing before seeing prior packets.

In esseence, there is another set of entries in table 76 that discusss
the INVALIDATE behavior and they are all 'F' with today's standard.

> I would agree for Atomic->read case because it's very similar to READ->Read.
> Write->Atomic goes back to first point as atomic completions can trigger implicit Write completions.
> So Write->atomic I will keep out of this attribute.
> Let me check with Idan for applying fence bit on Atomic->read, what he thinks about it.

Atomics do not cause completions at the responder, so  I'm not sure
what you are talking about here.

It is never, ever, OK to issue completions at the initiator out of
order, that would totally break every ULP we have.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
