From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH] ib_srp: Avoid that LUN scanning creates duplicate devices
Date: Tue, 19 Jul 2011 12:03:57 -0400
Message-ID: <1311091437.18631.1.camel@lap75545.ornl.gov>
References: <201106251010.30994.bvanassche@acm.org>
 <1309018469.6908.3.camel@obelisk.thedillows.org>
 <CAO+b5-rfaf2DQtuGQePivWppzX5YC+Zbj_6Et1U6HrMJF6CLXA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <CAO+b5-rfaf2DQtuGQePivWppzX5YC+Zbj_6Et1U6HrMJF6CLXA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2011-07-19 at 07:24 -0400, Bart Van Assche wrote:
> On Sat, Jun 25, 2011 at 6:14 PM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> > On Sat, 2011-06-25 at 10:10 +0200, Bart Van Assche wrote:

> > > So a SCSI driver must either take the channel and target id values in account
> > > in its quecommand() function or it should declare that it only supports one
> > > channel and one target id. Currently the ib_srp driver does neither. As a
> > > result scanning the SCSI bus via e.g. rescan-scsi-bus.sh causes many
> > > duplicate SCSI devices to be created. For each 0:0:L device, several
> > > duplicates are created with the same LUN number and with (C:I) != (0:0). Fix
> > > this by declaring that the ib_srp driver only supports one channel and one
> > > target id.
> > >
> > > Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> > > Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
> >
> > Thanks for the additional detail in the commit message.
> >
> > Acked-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
> 
> Hi Dave,
> 
> Thanks for acking. Through which tree should this patch go in ?

I Ack'd thinking Roland would pick it up directly since has done that in
the past for singe patches, but I'm fine with pulling it into my tree
and pushing that way.

Roland?

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
