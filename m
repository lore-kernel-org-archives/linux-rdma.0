From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: SRP Q's: 1) When is asynchronous I/O complete, 2) Is
 sequential I/O  coalesced, and 3) why is iSCSI faster than SRP in some
 instances
Date: Wed, 06 Jan 2010 20:57:21 -0500
Message-ID: <1262829441.29991.10.camel@obelisk.thedillows.org>
References: <f3177b9e1001061616v4f0015d1h843ba19c8cdd83d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f3177b9e1001061616v4f0015d1h843ba19c8cdd83d-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2010-01-06 at 17:16 -0700, Chris Worley wrote:
> 1) I'm seeing small block random writes (32KB and smaller) get better
> performance over SRP than they do as a local drive.  I'm guessing this
> is async behavior: once the written data is on the wire, it's deemed
> complete, and setting a sync flag would disable this.  Is this
> correct? 

No, from the initiator point of view, the request is not complete until
the target has responded to the command.

> If not, any ideas why SRP random writes would be faster than
> the same writes locally?

I would guess deeper queue depths and more cache available on the
target, especially if you are using a Linux-based SRP target.

But it would only be a guess without knowing more about your setup.

> 2) I'm seeing very poor sequential vs. random I/O performance (both
> read and write) at small block sizes (random performs well, sequential
> performance is poor).  I'm using direct I/O and the noop scheduler on
> the initiator, so there should be no coalescing.  Coalescing on these
> drives is not a good thing to do, as they are ultra low latency, and
> much faster if the OS doesn't try to coalesce.  Could anything in the
> IB/SRP/SCST stack be trying to coalesce sequential data?

Yes, if you have more requests outstanding than available queue depth --
ie queue backpressure/congestion -- even noop will merge sequential
requests in the queue. You could avoid this by setting max_sectors_kb to
the maximum IO size you wish the drive to see.

Though, I'd be surprised if there was no benefit at all to the OS
coalescing under congestion.


> 3) In my iSCSI (tgt) results using the HCA as a 10G interface (not
> IPoIB, but mlnx4_en), comparing this to the results of using the same
> HCA as IB under SRP, I get much better results with SRP when
> benchmarking the raw device, as you'd expect.  This is w/ a drive that
> does under 1GB/s.  When I use MD to mirror that SRP or iSCSI device w/
> an identical local device, and benchmark the raw MD device, iSCSI gets
> superior write performance and about equal read performance.  Does
> iSCSI/TGT have some special hook into MD devices that IB/SRP isn't
> privy to?

Are trying to achieve high IOPS or high bandwidth? I'm guessing IOPS
from your other comments, but device-mapper (and I suspect MD as well)
used to suffer from an internal limit on the max_sectors_kb -- you could
have it set to 8 MB on the raw devices, but MD would end up restricting
it to 512 KB. This is unlikely the problem if you are going for IOPS,
but can play a factor in bandwidth.

Then again, since the setup seems to be identical, I'm not sure it is
your problem here either. :(

Have you tried using the function tracer or perf tools found in recent
kernels to follow the data path and find the hotspots?

Dave

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
