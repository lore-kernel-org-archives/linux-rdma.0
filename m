From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] rdma/uverbs: Sketch for an ioctl framework
Date: Wed, 25 May 2016 13:00:39 -0600
Message-ID: <20160525190039.GA5525@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A82373AB04FB7F@ORSMSX109.amr.corp.intel.com>
 <HE1PR05MB141819B27F9AAA360DCB420FB14F0@HE1PR05MB1418.eurprd05.prod.outlook.com>
 <11b6d9c1-0b20-f929-c896-ca084fe18192@redhat.com>
 <20160524214137.GA6760@obsidianresearch.com>
 <5745E9AE.6020700@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5745E9AE.6020700-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hefty Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 25, 2016 at 02:06:38PM -0400, Doug Ledford wrote:

> >> Sean's proposal does away with the rigid nature of the current verbs 1.0
> >> API and makes it much more flexible on a per-driver basis.  This doesn't
> >> address the end user API issues, but it at least cleans up the user
> >> driver <-> kernel driver API so that one vendor's driver is not forced
> >> to carry around all the baggage needed for every other vendor's drivers.
> > 
> > I'm not sure what you are reading, but to me both proposals look very
> > similar. They are both based on the generic object/action/method sort
> > of model I talked about in an earlier thread.
 
> They are similar in initial expression, but not in intent.  Sean's is
> not concerned about preserving struct ib_qp (just as an example) as it
> stands, while Mellanox's patchset is all about passing around the same
> objects via a different interface.  Even though they encode objects in
> netlink attributes, they are still expected to be the same basic objects
> we use today (and this is how they minimize the driver impact).

Again, I think you are reading way too much into both patches. Until
we go down the object by object patches it is too early to say how
exactly things will be translated in either case.

Eg Sean's comments about dis-aggregating the event_fd from the context
in the Mellanox series is a good example of the kind of discussion and
improvements I'm expecting to see on an object-by-object basis.

But today I view both series as primarily exploring the dispatch and
marshalling of the function calls - which is one of the first
questions to settle.

> their own on the passed through data.  The Mellanox patches do so, but
> at the expense of netlink which many people on this list find painful to
> read.

Well, I'm not sold on the netlink idea either, and I posted an
alternative already. If you see another alternative you should
describe it.

> There are multiple trains of thought on where this will end up, and
> simply switching from write to ioctl is only part of the overall big
> picture.  There should only be one API break in this entire process, so
> we need to make sure that any other possible API breakers are included
> in the initial change to the ioctl interface.

To be very clear, an *API* break is not tolerable. The libibverbs 1.0
API must still be 100% functional on the new interface. We are talking
about changing the *ABI* that transports that API. There is a lot
of latitude there, but at the end of the day all the same objects must
still exist in some form.

If people have ideas for different future APIs then the best approach
is to make room for them in the ABI. Sean's discussion on the event
stuff is a prime example of that process. eg we can make room in the
ABI for a different async event model by dis-aggregating things at the
ABI level. The old API still remains preserved by that kind of
dis-aggregation.

If someone wants to suggest a different starting point for this than
libibverbs 1.0 then they had better do the work and concretely
describe that soon. Otherwise I see no better option than to go
object-by-object through the libibverbs 1.0 API and collect comments.

Obvious existing avenues to source comments from are better support
for OPA, iWarp, rocee, dpdk and libfabric.

> > I'm starting to think the basic thrust of the Mellanox series (provide
> > an easy compatability with our userspace) is a sane approach. The
> > other options look like far too much work to use as a starting point.
> 
> I could not care less about this argument.  When you have to break an
> API, you do what you have to do to do the job right.  Doing things the
> right way may turn out to be the easy way, but the argument would be
> because it's the right thing to do, not the easy thing to do.

Usually giant monster changes result in failure, it is a bad software
engineering practice. Substantially recoding every driver and every
provider seems like it is too big a task to complete to me.

Just preserving the existing write interface structure-by-structure
also seems like a bad idea because we already know it has an
inadaquate ABI for current drivers.

> This is arguable.  If we know we want to go basically direct only in the
> future, then preserving the existing layer in the ioctl API eventually
> becomes a burden.  It would be better to go direct only from the
> beginning.  This needs to be settled.

It would be like any other migration, if we eventually reach a point
where the kernel fully supports something like direct-only for all
kernel drivers then we can talk about an obsolescence path for the
other interface.

But, it also isn't really clear if direct-only is even a good idea, I
would be really interested to see some patches exploring what that
would look like.

I'm still thinking of a hybrid common & direct approach as the leading
option ...

> If we end up just doing a behind the scenes switch from write to ioctl
> with no changing of data structures or command flow or anything else,
> then we can ignore the end to end picture because it won't change
> significantly.

You should describe what specific things you want to see.

It is time for the people who are hand waving about non-verbs, non-qp,
'new data transfers' to sit down and specify what they want to see out
of the kernel uABI.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
