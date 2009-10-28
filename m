From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: Adjusting minimum packet size or "wait to merge requests" in SRP
Date: Wed, 28 Oct 2009 17:05:51 -0400
Message-ID: <1256763951.3544.17.camel@lap75545.ornl.gov>
References: <f3177b9e0910281147u5a47f75ao8bbe156d5b04969c@mail.gmail.com>
 <e2e108260910281214y5e3b5f4u24438986672e81b3@mail.gmail.com>
 <f3177b9e0910281238n1e53653eq3e667010caf8e745@mail.gmail.com>
 <1256759902.3544.9.camel@lap75545.ornl.gov>
 <f3177b9e0910281325i5ef5ce86u758ed665329232f2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <f3177b9e0910281325i5ef5ce86u758ed665329232f2-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2009-10-28 at 16:25 -0400, Chris Worley wrote:
> On Wed, Oct 28, 2009 at 1:58 PM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> > Under noop, the block layer will send requests as soon as it can without
> > merging. If it has more requests outstanding than the queue length on
> > the SRP initiator, then it will merge the new request with the queued
> > ones if possible.
> 
> So, noop will merge requests when the queue is full, but not hold-off
> to merge?

Correct.

> > The SRP initiator just hands off requests as quick as they are sent to
> > it by the block layer. You can control how big those requests are by
> > tuning /sys/block/$DEV/queue/max_sectors_kb up to .../max_hw_sectors_kb
> > which gets set by the max_sect parameter when adding the SRP target.
> 
> So the block layer may also hold-off on small requests, and decreasing
> max_sectors_kb will force it to flush to the SRP initiator ASAP (or is
> this just used for fragmentation of large requests)?

It is just used for breaking up large requests. The deadline, as, and
cfq schedulers may have some hold-off -- I've not checked -- but noop
does not.

You can check the length of the queue by looking
at /sys/class/scsi_disk/$TARGET/device/queue_depth.

That may well be 63, which is the maximum queue depth for the SRP
initiator unless you patch the source. Keep in mind that those 63
requests are shared across all LUNs on that connection, so you may queue
up before that, if you are driving many LUNs.

> Note that 'm trying to minimize latency for very small requests.

Reads or writes?
Are you doing direct IO or plain read/write?
File system or block device access?
Are you using the SCSI devices (/dev/sda etc) or DM multipath
(/dev/mpath/*)?

The SRP initiator is playing the cards it has been dealt, but you could
be getting coalescing from the rest of the system -- for example, I have
no idea if the SRP target code will do read ahead and turn a 4KB request
into a 64KB one -- I suspect it is possible. You can also turn on SCSI
logging to see what is being handed to the initiator to be sure which
side of the connection this is occurring.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
