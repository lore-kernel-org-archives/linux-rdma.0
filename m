From: Roman Penyaev <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [RFC PATCH 00/28] INFINIBAND NETWORK BLOCK DEVICE (IBNBD)
Date: Tue, 28 Mar 2017 16:17:14 +0200
Message-ID: <CAJrWOzBgswNC8z+XMCiHycPx0O-ejYeHwnBahSGNSgX7FfuoyA@mail.gmail.com>
References: <1490352343-20075-1-git-send-email-jinpu.wangl@profitbricks.com>
 <cfde9eab-a52a-8888-7d32-4f6fc9f9640a@grimberg.me> <CAMGffEmgsP9GjQQp63matwxpzJT+SZu+VPU+Co-h99b8D5g5Zw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAMGffEmgsP9GjQQp63matwxpzJT+SZu+VPU+Co-h99b8D5g5Zw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, hch <hch-jcswGhMUV9g@public.gmane.org>, Fabian Holler <mail-99BIx50xQYGELgA04lAiVw@public.gmane.org>, Milind Dumbare <Milind.dumbare-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Danil Kipnis <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Bart and Sagi,

Thanks for warm welcome and early feedback.  I will respond both of you
but here, on Jack's email, since I am not in CC in the first cover letter
(what a bummer).  Sorry for mess.

Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:

> - Is there room for this ibnbd? If we were to take every block driver
>   that was submitted without sufficient justification, it'd be very
>   hard to maintain. What advantage (if any) does this buy anyone over
>   existing rdma based protocols (srp, iser, nvmf)? I'm really (*really*)
>   not sold on this one...

It seems that better to start from the history.  IBNBD project, as it was
presented, is not only the block device (which supposed to be thin), but
mainly it is an rdma transport, client and server logic, which is called
IBTRS in our terms.  IBTRS was the starter, the main idea for us, which is
planned to bind our own replicated storage solution via infiniband.

We wanted clear transport interface, which should not be very much different
from what normal bsd sockets provide, e.g.:

  ibtrs_clt_open()               - Opens a session to a server.
  ibtrs_clt_rdma_write()         - WRITE, i.e transfer data to server.
  ibtrs_clt_request_rdma_write() - READ, i.e. request data transfer from server.

We did not want to rely, depend and embed any existent commands sets and
protocols (e.g. SCSI) inside our transport.  IBTRS should stay apart from
any storage knowledge and should be able to do only two things:

  1. establish connection to a server (accept connections from clients)
  2. read/write any data

Thinking about transport as a layer, IBNBD is just a user of that layer,
thin block device with only 4 commands, which establishes one connection
to the server and maps N block devices thru that connection.

I pretty well realize, that I've described obvious things with this
layering, but again, what we wanted and achieved is an independent
IB transport, which is planned to be used for replication and in that
project IBNBD won't exist.

> - To me, the fundamental design that the client side owns a pool of
>   buffers that it issues writes too, seems inferior than the
>   one taken in iser/nvmf (immediate data).

That of course discussable, since we consider that as a feature :)
But indeed, we never tested against nvmf.  And of course, I am open
to any surprises.

>   IMO, the ibnbd design has
>   scalability issues both in terms of server side resources,

Each client connection eats ~64Mb of memory on server side for the IO
buffer pool.  Since we are talking about hundreds of connections this
is reasonable trade off (memory is considerably cheap) to avoid any
allocations on IO path and make it completely lockless.

>   client side contention

We do not have any noticeable contentions.  What we have is a single
queue of buffers for all devices mapped on a client per connection
(session) and I can consider that as a single point of resource, where
each device have to fight in order to get an empty bit from a bitmap.
In practice all benchmarks we did (I have to say, that this was a pretty
old 4.4 kernel, and fresh data - is the amount of work which obviously
should be done) show that even we share a queue a bottleneck is always
an infiniband.

>   and network congestion (on infiniband the latter is
>   less severe).

We rely on IB flow control and if a server side did not respond
with

  ib_post_recv()

we do not reach the wire from a client.  That should be enough.

> - I honestly do not understand why you need *19057* LOC to implement
>   a rdma based block driver. Thats almost larger than all of our
>   existing block drivers combined...

Oh, those LOC numbers :)  IBNBD client (block device) itself is around
2800 lines with all sysfs handy things.  What is really bloated is a
transport client and server sides, which pretend to be smart and cover:

  o reconnects
  o heartbeats
  o quite huge FSM implementation for each connection (session)

True, this code can be split on common parts and deflated.

>   First glance at the code provides
>   some explanations,
> (1) you have some strange code that has no business
>   in a block driver like ibtrs_malloc/ibtrs_zalloc (yikes)

Indeed, that is crap which is left from those times, when we tried
to cover all generic kernel calls in order to do fault injection.

>   open-coding various existing logging routines,

No excuses, will be vanished.

> (2) you are for some
>   reason adding a second tag allocation scheme (why?)

Several reasons.  a) We share single queue of buffers for mapped devices
per client connection and we still support RQ mode.  b) MQ shared tags
indeed are shared, but not between different hctxs.  I.e. because of
our single queue for N devices per connection we are not able to create
M hctxs and share this single queue between them.  Sometimes we need to
do blk_mq_stop_hw_queue() in order to stop the hw queue and then restart
it from a completion.  Obviously, simplest approach is to equally share
static number of buffers in queue between N devices.  But that won't work
since with big N we finish with very small queue depth per device.

Of course, would be nice if along with BLK_MQ_F_TAG_SHARED another flag
exists, say, BLK_MQ_F_TAG_GLOBALLY_SHARED.  Unfortunately with our design
MQ does not help us a lot with current shared tags implementation.

> (3) you are open
>   coding a lot of stuff that we added to the stack in the past months...

Could you please point precisely in the code what do you mean?

If you are saying that you added a lot to nvmf, I would like to take a
pause and postpone nvmf discussion till we have fresh numbers and more
understanding.

>   (4) you seem to over-layer your code for reasons that I do not
>   really understand.

Frankly, I did not get this.  Here 'over-layer code' sounds very abstract
to me.

>   And I didn't really look deep at all into the
>   code, just to get the feel of it, and it seems like it needs a lot
>   of work before it can even be considered upstream ready.

Definetly.



Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:

> * Doesn't scale in terms of number of CPUs submitting I/O. The graphs shown
>   during the Vault talk clearly illustrate this. This is probably the result
>   of sharing a data structure across all client CPUs, maybe the bitmap that
>   tracks which parts of the target buffer space are in use.

Probably that was not clear from the presentation, but that exactly what
was fixed by CPU affinity (next slide after those hapless graphs).  What
is left unclear to us is the NUMA effect, which is not related to distances,
reported by numactl.

But still your advice to run everything against perf and check cache misses
is more than valid.  Thanks.

> * Supports IB but none of the other RDMA transports (RoCE / iWARP).

We did a lot of experiments with SoftRoCe and virtualized environment
in order to have quick testing results on one host without hardware.
That works quite well (despite SoftRoCe bugs which were fixed locally).
So should not be a big deal to cover iWARP.

> We also need performance numbers that compare IBNBD against SRP and/or
> NVMeOF with memory registration disabled to see whether and how much faster
> IBNBD is compared to these two protocols.

Indeed, we've never tested against nvmf and that is a must.


Thanks.

--
Roman
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
