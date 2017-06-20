From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Unexpected issues with 2 NVME initiators using the same target
Date: Tue, 20 Jun 2017 13:27:42 -0600
Message-ID: <20170620192742.GB827@obsidianresearch.com>
References: <CAANLjFrCLpX3nb3q7LpFPpLJKciU+1Hvmt_hxyTovQJM2-zQmg@mail.gmail.com>
 <6073e553-e8c2-6d14-ba5d-c2bd5aff15eb@grimberg.me>
 <20170620074639.GP17846@mtr-leonro.local>
 <1c706958-992e-b104-6bae-4a6616c0a9f9@grimberg.me>
 <20170620083309.GQ17846@mtr-leonro.local>
 <bd0b986f-9bed-3dfa-7454-0661559a527b@grimberg.me>
 <614481c7-22dd-d93b-e97e-52f868727ec3@grimberg.me>
 <59FF0C04-2BFB-4F66-81BA-A598A9A087FC@oracle.com>
 <20170620173532.GA827@obsidianresearch.com>
 <D3DC49A2-FFC9-4F62-8876-3E6AD5167DE5@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <D3DC49A2-FFC9-4F62-8876-3E6AD5167DE5-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Gruher, Joseph R" <joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "shahar.salzman" <shahar.salzman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Riches Jr, Robert M" <robert.m.riches.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 20, 2017 at 02:17:39PM -0400, Chuck Lever wrote:

> The concern is whether a retransmitted Send will be exposed
> to the receiving ULP. Below you imply that it will not be, so
> perhaps this is not a concern after all.

A retransmitted SEND will never be exposed to the Reciever ULP for
Reliable Connected. That is part of the guarantee.

> > We've had this discussion on the list before. You can *never* re-use a
> > SEND, or RDMA WRITE buffer until you observe the HCA is done with it
> > via a CQ poll.
> 
> RPC-over-RDMA is careful to invalidate buffers that are the
> target of RDMA Write before RPC completion, as we have
> discussed before.
> 
> Sends are assumed to be complete when a LocalInv completes.
> 
> When we had this discussion before, you explained the problem
> with retransmitted Sends, but it appears that all the ULPs we
> have operate without Send completion. Others whom I trust have
> suggested that operating without that extra interrupt is

Operating without the interrupt is of course preferred, but that means
you have to defer the invalidate for MR's refered to by SEND until a
CQ observation as well.

> preferred. The client has operated this way since it was added
> to the kernel almost 10 years ago.

I thought the use of MR's with SEND was a new invention? If you use
the local rdma lkey with send, it is never invalidated, and this is
not an issue, which IIRC, was the historical configuration for NFS.

> So I took it as a "in a perfect world" kind of admonition.
> You are making a stronger and more normative assertion here.

All ULPs must have periodic (related to SQ depth) signaled completions
or some of our supported hardware will explode.

All ULPs must flow control additions to the SQ based on CQ feedback,
or they will fail under load with SQ overflows, if this is done, then
the above happens correctly for free.

All ULPs must ensure SEND/RDMA Write resources remain stable until the
CQ indicates that work is completed. 'In a perfect world' this
includes not changing the source memory as that would cause
retransmitted packets to be different.

All ULPs must ensure the lkey remains valid until the CQ confirms
the work is done. This is not important if the lkey is always the
local rdma lkey, which is always valid.

> > No. The SQ side is asynchronous to the CQ side, the HCA will pipeline
> > send packets on the wire up to some internal limit.
> 
> So if my ULP issues FastReg followed by Send followed by
> LocalInv (signaled), I can't rely on the LocalInv completion
> to imply that the Send is also complete?

Correct.

This is explicitly defined in Table 79 of the IBA.

It describes the ordering requirements, if you order Send followed by
LocalInv the ordering is 'L' which means they are not ordered unless
the WR has the Local Invalidate Fence bit set.

LIF is an optional feature, I do not know if any of our hardware
supports it, but it is defined to cause the local invalidate to wait
until all ongoing references to the MR are completed.

No idea on the relative performance of LIF vs doing it manually, but
the need for one or the other is unambigously clear in the spec.

Why are you invaliding lkeys anyhow, that doesn't seem like something
that needs to happen synchronously.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
