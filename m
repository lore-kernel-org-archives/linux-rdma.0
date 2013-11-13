From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: RDMA and memory ordering
Date: Wed, 13 Nov 2013 11:09:15 -0700
Message-ID: <20131113180915.GA6597@obsidianresearch.com>
References: <CADPSxAhAGYZude8CM65-UDvfiPscStgcNsAfs=2XBbntg-wL0w@mail.gmail.com>
 <5281FFF9.5070705@gmail.com>
 <CADPSxAh6i74j8JVmWncttN6W4ithTGmsMgqWWpoBy2Z8RRb=_g@mail.gmail.com>
 <20131112183142.GB6639@obsidianresearch.com>
 <CADPSxAgF1CAiYoYbxbCON4NCD-tH8cAsJFRtECkTGJJQC4MXCg@mail.gmail.com>
 <20131112211123.GA29132@obsidianresearch.com>
 <CADPSxAhzmaut9s9L1fv5urhzX8xKU9GbL6z1TkOX3FuM4NUsww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CADPSxAhzmaut9s9L1fv5urhzX8xKU9GbL6z1TkOX3FuM4NUsww-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Gabriele Svelto <gabriele.svelto-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 13, 2013 at 02:55:53AM -0400, Anuj Kalia wrote:

> I don't know what you meant by burst writes: do you mean several RDMA
> writes or one large write? I'm concered with the order in which data

A RDMA write will be split up by the HCA into a burst of PCI MemoryWr
operations.

> I guess now is the time I run lots of micro experiments. Thanks a lot
> for the help everyone.

Carefull, experiments can't prove that order is guranteed to be
present, they can only show if it certainly isn't.

Intel hardware is very good at hiding ordering issues 99% of the time,
but in many cases there can be a stress'd condition that will show a
different result.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
