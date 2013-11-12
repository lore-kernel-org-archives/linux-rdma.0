From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: RDMA and memory ordering
Date: Tue, 12 Nov 2013 11:31:42 -0700
Message-ID: <20131112183142.GB6639@obsidianresearch.com>
References: <CADPSxAhAGYZude8CM65-UDvfiPscStgcNsAfs=2XBbntg-wL0w@mail.gmail.com>
 <5281FFF9.5070705@gmail.com>
 <CADPSxAh6i74j8JVmWncttN6W4ithTGmsMgqWWpoBy2Z8RRb=_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CADPSxAh6i74j8JVmWncttN6W4ithTGmsMgqWWpoBy2Z8RRb=_g@mail.gmail.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Gabriele Svelto <gabriele.svelto-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 12, 2013 at 06:31:04AM -0400, Anuj Kalia wrote:

> That makes sense. This way, we have no consistency between the CPU's
> view and the HCA's view - it all depends when the cache gets flushed
> to RAM.

What you are talking about is firmly in undefined territory. You might
be able to get something to work today, but tomorrows CPUs and HCAs
might mess it up.

You will never reliably get the guarentee you desired with the scheme
you have. Even with two CPUs it is not going to happen.

> I have a remote client which reads the struct A[i] from the server
> (via RDMA) in a loop. Sometimes in the value that the client reads,
> A[i].counter is larger than A[i].value. i.e., I see the newer value of
> A[i].counter but A[i].value corresponds to a previous iteration of the
> server's loop.

This is a fundamental mis-understanding of what FENCE does, it just
makes the writes happen in-order, it doesn't alter the reader side

CPU1                         CPU2
                             read avalue
value = counter
FENCE
a.counter = counter
                             read a.counter

value < counter


CPU1                         CPU2
a.value = counter
                             read a.value
FENCE
a.counter = counter
                             read a.coutner

value < counter


CPU1                         CPU2
a.value = counter
FENCE
                             read a.value
< SCHEDULE >
a.counter = counter
                             read a.coutner

value < counter

etc.

This stuff is hard, if you want a crazy scheme to be reliable you need
to have really detailed understanding of what is actually being
guarenteed.

> However, if the HCA performs reads from L3 cache, then everything
> should be consistent, right? While ordering the writes, I think we
> can

No. The cache makes no difference. Fundamentally you aren't atomically
writing cache lines. You are writing single values.

99% of the time it might look like atomic cache line writes, but there
is a 1% where that assumption will break.

Probably the best you can do is a collision detect scheme:

uint64_t counter
void data[];

writer
 counter++
 FENCE
 data = [.....];
 FENCE
 counter++

reader:
  read counter
   if counter % 2 == 1: retry
  read data
  read counter
   if counter != last_counter: retry

But even something as simple as that probably has scary races - I only
thought about it for a few moments. :)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
