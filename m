From: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Adjusting minimum packet size or "wait to merge requests" in SRP
Date: Wed, 28 Oct 2009 14:25:45 -0600
Message-ID: <f3177b9e0910281325i5ef5ce86u758ed665329232f2@mail.gmail.com>
References: <f3177b9e0910281147u5a47f75ao8bbe156d5b04969c@mail.gmail.com>
	 <e2e108260910281214y5e3b5f4u24438986672e81b3@mail.gmail.com>
	 <f3177b9e0910281238n1e53653eq3e667010caf8e745@mail.gmail.com>
	 <1256759902.3544.9.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1256759902.3544.9.camel-FqX9LgGZnHWDB2HL1qBt2PIbXMQ5te18@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 28, 2009 at 1:58 PM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> On Wed, 2009-10-28 at 13:38 -0600, Chris Worley wrote:
>> There is no scheduler running on either target or initiator on the
>> drives in question (sorry I worded that incorrectly initially), or so
>> I've been told (this information is second-hand).
>
> So, noop scheduler, then?

Yes, "elevator=noop" on both sides.  Again, sorry to be unclear about that.

>
> Under noop, the block layer will send requests as soon as it can without
> merging. If it has more requests outstanding than the queue length on
> the SRP initiator, then it will merge the new request with the queued
> ones if possible.

So, noop will merge requests when the queue is full, but not hold-off to merge?

<snip>
>
> The SRP initiator just hands off requests as quick as they are sent to
> it by the block layer. You can control how big those requests are by
> tuning /sys/block/$DEV/queue/max_sectors_kb up to .../max_hw_sectors_kb
> which gets set by the max_sect parameter when adding the SRP target.

So the block layer may also hold-off on small requests, and decreasing
max_sectors_kb will force it to flush to the SRP initiator ASAP (or is
this just used for fragmentation of large requests)?

Note that 'm trying to minimize latency for very small requests.

Thanks,

Chris
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
