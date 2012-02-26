From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 03/18] ib_srp: Enlarge block layer timeout
Date: Sun, 26 Feb 2012 16:30:44 -0500
Message-ID: <1330291844.1026.115.camel@obelisk.thedillows.org>
References: <3109536.qySrY1Ts3e@asus> <2007426.PROb5t3CLZ@asus>
	 <1330237921.1026.81.camel@obelisk.thedillows.org>
	 <CAO+b5-orKx3VSWBke+opgc81TwE9y7=pekOwGQPUAB09gkCxnA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-orKx3VSWBke+opgc81TwE9y7=pekOwGQPUAB09gkCxnA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 2012-02-26 at 19:25 +0000, Bart Van Assche wrote:
> On Sun, Feb 26, 2012 at 6:32 AM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> > On Sat, 2012-01-14 at 12:41 +0000, Bart Van Assche wrote:
> > > Enlarge the block layer timeout such that it is above the
> > > InfiniBand transport layer timeout. This is necessary to avoid
> > > that an SRP response is received after the SCSI layer has
> > > already killed the associated SCSI command. Note: the timeout is
> > > only set for SCSI disk devices but not for any other type of
> > > SCSI device (M/O disk, tape, CD-ROM, ...).
> >
> > Why disk only? Different default timeouts? If so, there's a better
> > solution.
> 
> If you have a look at the sd, sr and st source code, you will see that
> the timeout set in slave_configure() will be honored only for regular
> and MO disks but not for any other type of SCSI device.

Ok, I had thought this code ran after the {sd,st,sr}_probe() calls, but
looking closer I see this isn't the case. Setting it only for disks
makes sense, thanks for the explanation. Bummer there isn't a good place
to hook in to fix the timeout once the s* drivers have set their
default.

> >> +static int srp_slave_configure(struct scsi_device *sdev)

> >> +     WARN_ON(target->rq_tmo_jiffies == 0);
> >> +     if (sdev->type == TYPE_DISK) {
> >> +             timeout = max_t(unsigned, 30 * HZ, target->rq_tmo_jiffies);
> >> +             blk_queue_rq_timeout(q, timeout);
> >> +     }

> The only reason that WARN_ON() is present is to verify that no timeout
> has been set yet by sd, just in case the timeout computation code in
> sd would ever be moved. I can leave out that WARN_ON() statement if
> you want.

No, keeping it is fine, just put a small comment about why it's there.
And if you are intending to guard against the SD timeout calculation
moving, you should be checking q->rq_timeout, not
target->rq_tmo_jiffies.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
