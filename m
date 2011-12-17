From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 04/14] ib_srp: Set block layer timeout
Date: Sat, 17 Dec 2011 17:39:05 -0500
Message-ID: <1324161546.17849.20.camel@obelisk.thedillows.org>
References: <201112011954.25811.bvanassche@acm.org>
	 <201112011959.11956.bvanassche@acm.org>
	 <1323977841.16703.57.camel@lap75545.ornl.gov>
	 <CAO+b5-p9FQVvdVZtUvRJgMW6qhcnUKrp4RhCch1Hnt8JsjS5qQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-p9FQVvdVZtUvRJgMW6qhcnUKrp4RhCch1Hnt8JsjS5qQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, 2011-12-17 at 18:50 +0100, Bart Van Assche wrote:
> On Thu, Dec 15, 2011 at 8:37 PM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> > > +static int srp_slave_alloc(struct scsi_device *sdev)
> > > +{
> > > +     struct Scsi_Host *shost = sdev->host;
> > > +     struct srp_target_port *target = host_to_target(shost);
> > > +
> > > +     if (!WARN_ON(target->rq_tmo_jiffies == 0))
> > > +             blk_queue_rq_timeout(sdev->request_queue,
> > > +                                  target->rq_tmo_jiffies);
> >
> > What does having a WARN_ON here buy us? We should just set
> > target->rq_tmo_jiffies to a default value in srp_create_target(), and
> > adjust it as needed based on the CM response.
> 
> That WARN_ON() statement is there to verify that rq_tmo_jiffies has
> been initialized to a non-zero value - which is the case unless
> something bad like memory corruption has happened. I can leave it out
> if you want.

Better to just set it to a nonzero value that is appropriate for the
defaults and set it up when the CM handler gives you the reply. Sounds
like 61 seconds is the correct value, from your original commit message.
This way you know you have a sane value, even if the CM is broken, and
the user doesn't get a confusing stack trace that doesn't really tell
them what's wrong.

> >        if (attr_mask & (IP_QP_TIMEOUT | IB_QP_RETRY_CNT)) {
> >
> > Also, you need to handle the case where only one of those is set, and
> > provide defaults when they aren't -- unless the spec says they both must
> > always be set (I haven't looked), in which case you can modify the
> > attr_mask test.
> 
> According to table 91 in the IB spec (section 11.2.4.2, Modify Queue
> Pair), both the QP timeout and the retry count have to be set for RC
> QP's upon the RTR to RTS transition.

Ok, then safer to only change from the default set in
srp_create_target() when
(attr_mask & (IP_QP_TIMEOUT|IB_OP_RETRY_CNT) == (IP_OP_TIMEOUT|IB_OP_RETRY_CNT))

> > > +             /*
> > > +              * Set target->rq_tmo_jiffies to one second more than the
> > > +              * largest time it can take before an error completion is
> > > +              * generated.
> > > +              */
> >
> > The calculations have a fair number of magic numbers in them; may be
> > useful to explain.
> 
> All these magic numbers come straight from the IB spec. I can add a
> comment mentioning that if you want.

Changing to something like

/* The maximum detection time for a lost ACK is 4 times the retry timeout,
 * and we'll retry a set number of times before declaring the connection
 * dead (IB spec C9-140, C9-141, C9-142). Set our default IO timeout to be
 * one second longer to make sure we wait long enough before declaring a
 * request dead.
 */
T_tr_ns = 4096 * (1ULL << qp_attr->timeout);
max_compl_time_ms = ...

may make it pretty obvious. Also, you could use USEC_PER_MSEC and
MSEC_PER_SEC from <linux/time.h> to make the other numbers meaningful.

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
