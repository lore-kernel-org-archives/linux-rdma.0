From: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: RDMA and memory ordering
Date: Wed, 13 Nov 2013 02:55:53 -0400
Message-ID: <CADPSxAhzmaut9s9L1fv5urhzX8xKU9GbL6z1TkOX3FuM4NUsww@mail.gmail.com>
References: <CADPSxAhAGYZude8CM65-UDvfiPscStgcNsAfs=2XBbntg-wL0w@mail.gmail.com>
	<5281FFF9.5070705@gmail.com>
	<CADPSxAh6i74j8JVmWncttN6W4ithTGmsMgqWWpoBy2Z8RRb=_g@mail.gmail.com>
	<20131112183142.GB6639@obsidianresearch.com>
	<CADPSxAgF1CAiYoYbxbCON4NCD-tH8cAsJFRtECkTGJJQC4MXCg@mail.gmail.com>
	<20131112211123.GA29132@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131112211123.GA29132-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Gabriele Svelto <gabriele.svelto-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 12, 2013 at 5:11 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Tue, Nov 12, 2013 at 04:59:19PM -0400, Anuj Kalia wrote:
>
>> Thanks again. So we conclude there is nothing like an atomic cacheline
>> read. Then my current design is a dud. But there should be 8 byte
>> atomicity, right? I think I can leverage that to get what I want.
>
> 64 bit CPUs do have 64 bit atomic stores, so you can rely on DMAs
> seeing only values you've written and not some combination of old/new
> bits.
That's a relief :).
>> This part is interesting (from Jason's reply):
>> "If you burst read from the HCA value and counter then the result is
>> undefined, you don't know if counter was read before value, or the
>> other way around."
>
>> Is there a way of knowing the order in which they are read - for
>> example, I heard in a talk that there is a left-to-right ordering
>> when
>
> So, this I don't know. I don't think anyone has ever had a need to
> look into that, it is certainly not defined. What you are asking is
> how does memory write ordering interact with a burst read.

OK. I'll do some experiments to figure out the order in which
cacheline words are read by the HCA. I'll post my findings if they're
interesting.

>> a HCA reads a contiguous buffer. This could be totally architecture
>> specific, for example, I just want the answer for Mellanox ConnectX-3
>> cards. I think I can check this experimentally, but a definitive
>> answer would be great.
>
> The talk you heard about left-to-write ordering was probably in the
> context of DMA burst writes and MPI polling.
>
> In this case the DMA would write DDDDDP, and the MPI would poll on
> P. Once P is written it assumes that D is visible.

The talk wasn't about MPI but you're right. It was about RDMA writes
and CPU polls. Thanks for making that clear.

I don't know what you meant by burst writes: do you mean several RDMA
writes or one large write? I'm concered with the order in which data
is written out in one large RDMA write (I'm concerned with RDMA reads
too). For example, if I read/write 64 bytes addressed from "buf" to
"buf+64", does [buf, buf+7] get read/written first or does [buf+56,
buf+63]?

I guess now is the time I run lots of micro experiments. Thanks a lot
for the help everyone.

> This is undefined in general, but ensured in some cases on Intel and
> Mellanox. I'm not sure if D and P have to be in the same cache line,
> but you probably need a fence after reading P..
>
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
