From: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: RDMA and memory ordering
Date: Thu, 14 Nov 2013 01:12:55 -0400
Message-ID: <CADPSxAiepGuzWYXjyDxnSzER5MqL57fZ9mh83SLwV461PwZO3Q@mail.gmail.com>
References: <CADPSxAhAGYZude8CM65-UDvfiPscStgcNsAfs=2XBbntg-wL0w@mail.gmail.com>
	<5281FFF9.5070705@gmail.com>
	<CADPSxAh6i74j8JVmWncttN6W4ithTGmsMgqWWpoBy2Z8RRb=_g@mail.gmail.com>
	<20131112183142.GB6639@obsidianresearch.com>
	<CADPSxAgF1CAiYoYbxbCON4NCD-tH8cAsJFRtECkTGJJQC4MXCg@mail.gmail.com>
	<20131112211123.GA29132@obsidianresearch.com>
	<CADPSxAhzmaut9s9L1fv5urhzX8xKU9GbL6z1TkOX3FuM4NUsww@mail.gmail.com>
	<20131113180915.GA6597@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131113180915.GA6597-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Gabriele Svelto <gabriele.svelto-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason,

Thanks again :).

I found another similar thread:
http://www.spinics.net/lists/linux-rdma/msg02709.html. The conclusion
there was that although Infiniband specs don't specify any ordering of
writes, many people assume left-to-right ordering anyway. There is no
mention of reads though.

So I did the micro experiments and I found that although writes follow
the left-right ordering, reads do not. More details follow:

1. Write ordering experiment:
1.a. In the nth iteration, a client writes a buffer containing C ~
1024 integers (each equal to 'n') to the server. The client sleeps for
2000 us between iterations.
1.b. The server busily polls for a change to the Cth integer. When the
Cth integer changes from i to i+1, it checks if the entire buffer is
equal to i+1. The check always passes (I've tried over 15 million
checks). The test fails if the polled integer is not the rightmost
integer.

2. Read ordering experiment:
2.a. In the nth iteration, the server writes 'n' to C ~ 1024 integers
in a local buffer. The server does the write in reverse order
(starting from index C-1). It then sleeps for 2000 us.
2.b. The client continuously reads the buffer. When the Cth integer in
the read sink changes from i to i+1, it checks if all the integers in
the buffer are i+1. This check fails (although rarely).

This shows that reads are NOT ordered left to right. The read pattern
that I'd expect is HHHH...HHHH (where H corresponds to i+1). However,
I can see patterns like HH..LLLLL...HH (L corresponds to i). This is
wrong because we don't expect i's to be lingering around after the
first integer has become i+1 (under the false assumption that reads
happen left-to-right).

Curiously, whenever there are stale i's, they are always such that the
contiguous chunk of i's would fit inside a cacheline. I'm seeing 16
i's and 48 i's usually.
2.c. The check always succeeds if C is 16 (the buffer fits inside a
cacheline). I've done 15 million checks, will do much more tonight.

So, another question: why are the reads unordered while the writes are
ordered? I think by now we can assume write ordering (my experiments +
MVAPICH uses it). Can the PCI reorder the reads issued by the HCA?

On Wed, Nov 13, 2013 at 2:09 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Wed, Nov 13, 2013 at 02:55:53AM -0400, Anuj Kalia wrote:
>
>> I don't know what you meant by burst writes: do you mean several RDMA
>> writes or one large write? I'm concered with the order in which data
>
> A RDMA write will be split up by the HCA into a burst of PCI MemoryWr
> operations.
>
>> I guess now is the time I run lots of micro experiments. Thanks a lot
>> for the help everyone.
>
> Carefull, experiments can't prove that order is guranteed to be
> present, they can only show if it certainly isn't.
Aah, unfortunately that's true. However, I ran experiments anyway. If
people have been assuming an ordering on writes, I guess I can check
if reads are ordered too.
> Intel hardware is very good at hiding ordering issues 99% of the time,
> but in many cases there can be a stress'd condition that will show a
> different result.
Hmm.. I'm willing to run billions of iterations of the test. That
should give some confidence.
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
