From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Can I call routines like ib_post_{send,recv} from completion
 queue callbacks?
Date: Fri, 27 Sep 2013 23:30:35 +0300
Message-ID: <CAJZOPZK+aRoXVDyoq7NPVQKFv6PhuJLc2Y4=9ffFH4wRQBR9jQ@mail.gmail.com>
References: <CACyXjPxMsw=dMGzH7pycit5=1oEv4dOUjiWbQFz5+LjwuVRS6Q@mail.gmail.com>
	<CACyXjPyGBC=bBZ6fWGe_LeHMNpHqDk+hPttA6RFDBaVC=5BZ-Q@mail.gmail.com>
	<CACyXjPz=V0PXEm761t0PsbFNLqhKpnsJr00A70zgnSh2osevXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACyXjPz=V0PXEm761t0PsbFNLqhKpnsJr00A70zgnSh2osevXw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 24, 2013 at 6:13 AM, Richard Sharpe
<realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Mon, Sep 23, 2013 at 10:55 AM, Richard Sharpe wrote:
>> On Mon, Sep 23, 2013 at 5:02 AM, Richard Sharpe wrote:

>>> Hi folks,
>>> I am trying to figure out the reason for the latest hang in my SMB
>>> Direct driver for Linux.
>>> Should I be calling ib_post_{send,recv} from completion queue
>>> callbacks or should I be doing it from a different context, like a work queue?

>> Just to clarify, calling ib_post_recv from a CM callback seems fine.
>> My problem has been with calling ib_post_send from within the callback
>> resulting from the completion of a RECV.
>> Is that appropriate to do?

> First, it was a copy-paste error. This is not the memory region you are looking for.
> Next. Scheduling while atomic. Clearly, not appropriate.

Richard,

I suspect some messages from this thread missed the list, I am nor
sure who is "you" and where memory region is previously mentioned on
this thread. Anyway && this way or another, fast path verbs calls,
specifically ib_post_recv/send  and ib_poll_cq ARE allowed && should
be supported from any context, as indicated in the IB core locking
rules documet @ Documentation/infiniband/core_locking.txt, if you saw
a problem with the IB core or some IB driver to use that, please
report it here -- thanks,

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
