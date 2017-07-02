From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Unexpected issues with 2 NVME initiators using the same target
Date: Sun, 2 Jul 2017 14:17:52 -0400
Message-ID: <9E30754F-464A-4B62-ADE7-F6B2F6D95763@oracle.com>
References: <20170620074639.GP17846@mtr-leonro.local> <1c706958-992e-b104-6bae-4a6616c0a9f9@grimberg.me> <20170620083309.GQ17846@mtr-leonro.local> <bd0b986f-9bed-3dfa-7454-0661559a527b@grimberg.me> <614481c7-22dd-d93b-e97e-52f868727ec3@grimberg.me> <59FF0C04-2BFB-4F66-81BA-A598A9A087FC@oracle.com> <20170620173532.GA827@obsidianresearch.com> <D3DC49A2-FFC9-4F62-8876-3E6AD5167DE5@oracle.com> <20170620192742.GB827@obsidianresearch.com> <C14B071E-F1B2-466A-82CF-4E20BFAD9DC1@oracle.com> <20170620211958.GA5574@obsidianresearch.com> <4f0812f1-0067-4e63-e383-b913ee1f319d@grimberg.me> <28F6F58E-B6F4-4114-8DFF-B72353CE814B@oracle.com> <52ad3547-efcf-f428-6b39-117efda3379f@grimberg.me> <9990B5CB-E0FF-481E-9F34-21EACF0E796E@oracle.com> <f1f1a68c-90db-e6bf-e35e-55c4b469c339@grimberg.me> <7D1C540B-FEA0-
 4101-8B58-87BCB7DB5492@oracle.com> <66b1b8be-e506-50b8-c01f-fa0e3cea98a4@grimberg.me> <9D8C7BC8-7E18-405A-9017-9DB23A6B5C15@oracle.com> <11aa1a24-9f0b-dbb8-18eb-ad357c7727b2@grimberg.me>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <11aa1a24-9f0b-dbb8-18eb-ad357c7727b2-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Gruher, Joseph R" <joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "shahar.salzman" <shahar.salzman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Riches Jr, Robert M" <robert.m.riches.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Jul 2, 2017, at 5:45 AM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
> 
> 
>>> Or wait for the send completion before completing the I/O?
>> In the normal case, that works.
>> If a POSIX signal occurs (^C, RPC timeout), the RPC exits immediately
>> and recovers all resources. The Send can still be running at that
>> point, and it can't be stopped (without transitioning the QP to
>> error state, I guess).
> 
> In that case we can't complete the I/O either (or move the
> QP into error state), we need to defer/sleep on send completion.

Unfortunately the RPC client finite state machine mustn't
sleep when a POSIX signal fires. xprtrdma has to unblock the
waiting application process but clean up the resources
asynchronously.

The RPC completion doesn't have to wait on DMA unmapping the
send buffer. What would have to wait is cleaning up the
resources -- in particular, allowing the rpcrdma_req
structure, where the send SGEs are kept, to be re-used. In
the current design, both happen at the same time.


>> The alternative is reference-counting the data structure that has
>> the ib_cqe and the SGE array. That adds one or more atomic_t
>> operations per I/O that I'd like to avoid.
> 
> Why atomics?

Either an atomic reference count or a spin lock is necessary
because there are two different ways an RPC can exit:

1. The common way, which is through receipt of an RPC reply,
handled by rpcrdma_reply_handler.

2. POSIX signal, where the RPC reply races with the wake-up
of the application process (in other words, the reply can
still arrive while the RPC is terminating).

In both cases, the RPC client has to invalidate any
registered memory, and it has to be done no more and no less
than once.

I deal with some of this in my for-13 patches:

http://marc.info/?l=linux-nfs&m=149693711119727&w=2

The first seven patches handle the race condition and the
need for exactly-once invalidation.

But the issue with unmapping the Send buffers has to do
with how the Send SGEs are managed. The data structure
containing the SGEs goes away once the RPC is complete.

So there are two "users": one is the RPC completion, and
one is the Send completion. Once both are done, the data
structure can be released. But RPC completion can't wait
if the Send completion hasn't yet fired.

I could kmalloc the SGE array instead, signal each Send,
and then in the Send completion handler, unmap the SGEs
and then kfree the SGE array. That's a lot of overhead.

Or I could revert all the "map page cache pages" logic and
just use memcpy for small NFS WRITEs, and RDMA the rest of
the time. That keeps everything simple, but means large
inline thresholds can't use send-in-place.

I'm still open to suggestion. for-4.14 will deal with other
problems, unless an obvious and easy fix arises.


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
