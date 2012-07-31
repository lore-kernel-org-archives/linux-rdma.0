From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] zero-copy extensions for rsockets
Date: Tue, 31 Jul 2012 17:15:57 -0600
Message-ID: <20120731231557.GA6956@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A6E8D5@ORSMSX101.amr.corp.intel.com>
 <20120731183243.GA4755@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A8237346A6E926@ORSMSX101.amr.corp.intel.com>
 <20120731213450.GA5787@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A8237346A6E9E6@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A6E9E6-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Christoph Lameter (christoph-zt5rKe7wo/JBDgjK7y7TUQ@public.gmane.org)" <christoph-zt5rKe7wo/JBDgjK7y7TUQ@public.gmane.org>, "Greg KH (gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org)" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 31, 2012 at 10:46:22PM +0000, Hefty, Sean wrote:
> > libaio is designed to be used along with an eventfd that provides the
> > epoll like semantics you are talking about. Each time you call
> > io_submit you can call io_set_eventfd() on the iocb and the aio engine
> > will trigger that eventfd when the IO completes. poll or epoll on the
> > eventfd fd.
> 
> A search for io_set_eventfd() turned up several references, several
> of which refer to it as "undocumented".  IMO, having aio simply
> return an fd rather than an abstract data type, coupled with an
> undocumented function would have been a much simpler way of
> designing aio to work with epoll/select/poll.  :P

Well, this is how it ended up, eventfd was added to the interface
after it was accepted into mainline. It is actually quite easy to use
and does have the added flexability of mapping different completions
to different 'CQs'..

> > I'm not sure what you are refering to here? Are you mixing up POSIX
> > aio with libaio?
> 
> possibly - I find different information based on looking for 'io' vs 'aio', though the differences are usually minor.
> 
> Here are the calls I'm looking at from the man pages:
> 
> int io_setup(unsigned nr_events, aio_context_t *ctxp);
> vs
> int io_queue_init(int maxevents, io_context_t *ctx);
> 
> int io_submit(aio_context_t ctx_id, long nrstruct iocb **" iocbpp );
> or
> int io_submit(io_context_t ctx, long nr, struct iocb *iocbs[]);
> 
> void io_set_callback(struct iocb *iocb, io_callback_t cb);

Right, that is the libaio interface.

> Maybe I'm confused about the intent of io_set_callback when
> comparing it to the POSIX aio documentation, but the documentation
> for io_set_callback isn't helping me here.

io_set_callback is only used in conjunction with io_queue_run, which
itself is just a wrapper around io_getevents that calls the function
pointer stored in the data member for each
completion. io_set_callback/io_queue_run does not seem to me to be a
very useful interface, I've never wanted to use it for sure.

> The API that I think would work well for these type of devices is
> one where an aio_context/ioq thingy would easily map to one or a
> small set of CQs (say, one per device), with each socket/fd having a
> fixed association to an ioq for its lifetime.  This is where I see a
> mismatch with aio.

I'm not sure that is so great, one of the benefits of the aio
interface is you have just one queue and one eventfd to manage, no
matter how many fd's you are AIOing against. Completions can happen
out of order. Requiring an app to juggle multiple ioq thingies split
on some arbitrary axis (ie by HCA, in particular) is very ugly from a
user perspective.

Matching IB WCs to io_context_t/iocb shouldn't be too hard, just an
encoding in the wr_id, and it similarly shouldn't be too difficult to
keep track of which CQs to poll on an io_get_events.

What I would see as much more difficult is how to match your streaming
RDMA WRITE ring algorithm used for synchronous read/write with
asynchronous read/write and direct placement. That seems pretty
complicated.

> Separately from aio, do you see issues with iomap/iounmap/get/put?

I'm not sure what semantics you are going for here? Is get/put the
same as a AIO read/write, or are they RDMA? How does it work if one
side is using read/write and the other does get/put? Are there two
things here? async read/write and the get/put RDMAish stuff?

At a minimum I think you'd want to prefix these names with rsockets_,
since they are very likely to collide with something else.

But, is this valuable? If people are going to have to do lots of
rework to support these calls would they just be better off using
something like CCI?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
