From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: RDMA and memory ordering
Date: Thu, 14 Nov 2013 12:05:14 -0700
Message-ID: <20131114190514.GB21549@obsidianresearch.com>
References: <CADPSxAhAGYZude8CM65-UDvfiPscStgcNsAfs=2XBbntg-wL0w@mail.gmail.com>
 <5281FFF9.5070705@gmail.com>
 <CADPSxAh6i74j8JVmWncttN6W4ithTGmsMgqWWpoBy2Z8RRb=_g@mail.gmail.com>
 <20131112183142.GB6639@obsidianresearch.com>
 <CADPSxAgF1CAiYoYbxbCON4NCD-tH8cAsJFRtECkTGJJQC4MXCg@mail.gmail.com>
 <20131112211123.GA29132@obsidianresearch.com>
 <CADPSxAhzmaut9s9L1fv5urhzX8xKU9GbL6z1TkOX3FuM4NUsww@mail.gmail.com>
 <20131113180915.GA6597@obsidianresearch.com>
 <CADPSxAiepGuzWYXjyDxnSzER5MqL57fZ9mh83SLwV461PwZO3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CADPSxAiepGuzWYXjyDxnSzER5MqL57fZ9mh83SLwV461PwZO3Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Gabriele Svelto <gabriele.svelto-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 14, 2013 at 01:12:55AM -0400, Anuj Kalia wrote:

> So, another question: why are the reads unordered while the writes are
> ordered? I think by now we can assume write ordering (my experiments +
> MVAPICH uses it). Can the PCI reorder the reads issued by the HCA?

Without fencing there is no gurantee in what order things are made
visible, and the CPU will flush its write buffers however it likes.

The PCI subsystem can also re-order reads however it likes, that is
part of the PCI spec. In a 2 socket system don't be surprised if cache
lines on different sockets complete out of order.

Think of this as a classic multi-threaded race condition, and not
related to PCI. If you do the same test using 2 threads you probably
get the same results.

> > Intel hardware is very good at hiding ordering issues 99% of the time,
> > but in many cases there can be a stress'd condition that will show a
> > different result.

> Hmm.. I'm willing to run billions of iterations of the test. That
> should give some confidence.

Not really, repeating the same test billions of times is not
comprehensive.  You need to stress the system in all sorts of
different ways to see different behavior.

For instance, in a 2 socket system there are likely all sorts of crazy
sensitivities that depend on which socket the memory lives, which
socket holds the newest cacheline, which socket has an old line, which
socket is connected directly to the HCA, etc.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
