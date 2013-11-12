From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: RDMA and memory ordering
Date: Tue, 12 Nov 2013 14:11:23 -0700
Message-ID: <20131112211123.GA29132@obsidianresearch.com>
References: <CADPSxAhAGYZude8CM65-UDvfiPscStgcNsAfs=2XBbntg-wL0w@mail.gmail.com>
 <5281FFF9.5070705@gmail.com>
 <CADPSxAh6i74j8JVmWncttN6W4ithTGmsMgqWWpoBy2Z8RRb=_g@mail.gmail.com>
 <20131112183142.GB6639@obsidianresearch.com>
 <CADPSxAgF1CAiYoYbxbCON4NCD-tH8cAsJFRtECkTGJJQC4MXCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CADPSxAgF1CAiYoYbxbCON4NCD-tH8cAsJFRtECkTGJJQC4MXCg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Gabriele Svelto <gabriele.svelto-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 12, 2013 at 04:59:19PM -0400, Anuj Kalia wrote:

> Thanks again. So we conclude there is nothing like an atomic cacheline
> read. Then my current design is a dud. But there should be 8 byte
> atomicity, right? I think I can leverage that to get what I want.

64 bit CPUs do have 64 bit atomic stores, so you can rely on DMAs
seeing only values you've written and not some combination of old/new
bits.

> This part is interesting (from Jason's reply):
> "If you burst read from the HCA value and counter then the result is
> undefined, you don't know if counter was read before value, or the
> other way around."
 
> Is there a way of knowing the order in which they are read - for
> example, I heard in a talk that there is a left-to-right ordering
> when

So, this I don't know. I don't think anyone has ever had a need to
look into that, it is certainly not defined. What you are asking is
how does memory write ordering interact with a burst read.

> a HCA reads a contiguous buffer. This could be totally architecture
> specific, for example, I just want the answer for Mellanox ConnectX-3
> cards. I think I can check this experimentally, but a definitive
> answer would be great.

The talk you heard about left-to-write ordering was probably in the
context of DMA burst writes and MPI polling.

In this case the DMA would write DDDDDP, and the MPI would poll on
P. Once P is written it assumes that D is visible.

This is undefined in general, but ensured in some cases on Intel and
Mellanox. I'm not sure if D and P have to be in the same cache line,
but you probably need a fence after reading P..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
