From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [RFC 2/8] IB/srp: consolidate state change code
Date: Mon, 27 Dec 2010 12:33:02 -0500
Message-ID: <1293471182.2896.19.camel@obelisk.thedillows.org>
References: <1293139893-11678-1-git-send-email-dillowda@ornl.gov>
	 <1293139893-11678-3-git-send-email-dillowda@ornl.gov>
	 <AANLkTimE83r3EKcDwOat3Q_5=gzmCjB9A0vhs11r=hMU@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimE83r3EKcDwOat3Q_5=gzmCjB9A0vhs11r=hMU-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 2010-12-27 at 16:12 +0100, Bart Van Assche wrote:
> On Thu, Dec 23, 2010 at 10:31 PM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> > This is a break-out and slight cleanup of Bart Van Assche's work.

> > +static bool srp_change_state(struct srp_target_port *target,
> > +                           enum srp_target_state old,
> > +                           enum srp_target_state new)
> > +{
> > +       int changed = false;
> > +
> > +       spin_lock_irq(target->scsi_host->host_lock);
> > +       if (target->state == old) {
> > +               target->state = new;
> > +               changed = true;
> > +       }
> > +       spin_unlock_irq(target->scsi_host->host_lock);
> > +       return changed;
> > +}
> 
> The variable 'changed' either has the value 'true' or 'false' and is
> converted by the return statement into the type bool, so I'm surprised
> to see that this variable has been declared as an int ?

Yeah, I missed it when I changed the return type based on your earlier
feedback.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
