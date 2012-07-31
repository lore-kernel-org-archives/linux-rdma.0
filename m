From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] zero-copy extensions for rsockets
Date: Tue, 31 Jul 2012 22:46:22 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A6E9E6@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A6E8D5@ORSMSX101.amr.corp.intel.com>
 <20120731183243.GA4755@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A8237346A6E926@ORSMSX101.amr.corp.intel.com>
 <20120731213450.GA5787@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120731213450.GA5787-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Christoph Lameter (christoph-zt5rKe7wo/JBDgjK7y7TUQ@public.gmane.org)" <christoph-zt5rKe7wo/JBDgjK7y7TUQ@public.gmane.org>, "Greg KH (gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org)" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> libaio is designed to be used along with an eventfd that provides the
> epoll like semantics you are talking about. Each time you call
> io_submit you can call io_set_eventfd() on the iocb and the aio engine
> will trigger that eventfd when the IO completes. poll or epoll on the
> eventfd fd.

A search for io_set_eventfd() turned up several references, several of which refer to it as "undocumented".  IMO, having aio simply return an fd rather than an abstract data type, coupled with an undocumented function would have been a much simpler way of designing aio to work with epoll/select/poll.  :P
 
> > My concern is that supporting a more flexible API, like aoi, would
> > effectively result in losing some desirable feature handling
> > completions, such as kernel bypass or reducing interrupts.  With
> > aio, I'm unsure about the impact of supporting callback
> > notifications and the selection of each aio context on a per request
> > basis.
> 
> I'm not sure what you are refering to here? Are you mixing up POSIX
> aio with libaio?

possibly - I find different information based on looking for 'io' vs 'aio', though the differences are usually minor.

Here are the calls I'm looking at from the man pages:

int io_setup(unsigned nr_events, aio_context_t *ctxp);
vs
int io_queue_init(int maxevents, io_context_t *ctx);

int io_submit(aio_context_t ctx_id, long nrstruct iocb **" iocbpp );
or
int io_submit(io_context_t ctx, long nr, struct iocb *iocbs[]);

void io_set_callback(struct iocb *iocb, io_callback_t cb);
etc.

Maybe I'm confused about the intent of io_set_callback when comparing it to the POSIX aio documentation, but the documentation for io_set_callback isn't helping me here.

In any case, the aio calls associate an fd with an [a]io_context on each read/write.  Since RDMA devices associate each send or receive queue with exactly 1 CQ, this makes it difficult to map an [a]io_context to a set of CQs.

The API that I think would work well for these type of devices is one where an aio_context/ioq thingy would easily map to one or a small set of CQs (say, one per device), with each socket/fd having a fixed association to an ioq for its lifetime.  This is where I see a mismatch with aio.

Separately from aio, do you see issues with iomap/iounmap/get/put?

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
