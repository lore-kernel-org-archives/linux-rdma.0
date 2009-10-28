From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: Adjusting minimum packet size or "wait to merge requests" in SRP
Date: Wed, 28 Oct 2009 15:58:22 -0400
Message-ID: <1256759902.3544.9.camel@lap75545.ornl.gov>
References: <f3177b9e0910281147u5a47f75ao8bbe156d5b04969c@mail.gmail.com>
 <e2e108260910281214y5e3b5f4u24438986672e81b3@mail.gmail.com>
 <f3177b9e0910281238n1e53653eq3e667010caf8e745@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <f3177b9e0910281238n1e53653eq3e667010caf8e745-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2009-10-28 at 13:38 -0600, Chris Worley wrote:
> There is no scheduler running on either target or initiator on the
> drives in question (sorry I worded that incorrectly initially), or so
> I've been told (this information is second-hand). 

So, noop scheduler, then?

Under noop, the block layer will send requests as soon as it can without
merging. If it has more requests outstanding than the queue length on
the SRP initiator, then it will merge the new request with the queued
ones if possible.

>  I did see iostat
> output from the initiator in his case, where there were long waits and
> service times that I'm guessing was due to some coalescing/merging.
> There was also a hint in the iostat output that a scheduler was
> enabled, as there were non-zero values (occasionally) under the
> [rw]qm/s columns, which, if I understand iostat correctly, means there
> is a scheduler merging results.
> 
> So you're saying there is no hold-off for merging on the initiator
> side of the IB/SRP stack?

The SRP initiator just hands off requests as quick as they are sent to
it by the block layer. You can control how big those requests are by
tuning /sys/block/$DEV/queue/max_sectors_kb up to .../max_hw_sectors_kb
which gets set by the max_sect parameter when adding the SRP target.

You can get some hold-off potentially by using a non-noop scheduler for
the block device, see /sys/block/$DEV/queue/scheduler. 'as' or
'deadline' may fit your bill, but they have a habit of breaking up
requests into smaller chunks.

Also, you want 'options ib_srp srp_sg_tablesize=255'
in /etc/modprobe.conf, as by default it only allows 12 scatter/gather
entries, which will only guarantee a 48KB request size. Using 255
guarantees you can send a 1020KB request. Of course, if the pages
coalesce in the request, you can send much larger requests before
running out of S/G entires. max_sectors_kb will limit what gets sent in
either case.

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
