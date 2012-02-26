From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 15/18] ib_srp: Maintain a single connection per I_T nexus
Date: Sun, 26 Feb 2012 01:34:00 -0500
Message-ID: <1330238040.1026.89.camel@obelisk.thedillows.org>
References: <3109536.qySrY1Ts3e@asus> <6527223.rH6NsR1Dga@asus>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6527223.rH6NsR1Dga@asus>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, 2012-01-14 at 12:54 +0000, Bart Van Assche wrote:
> The sysfs attribute 'add_target' may be used to relogin to a
> target. An SRP target that receives a second login request from
> an initiator will disconnect the previous connection. So before
> trying to reconnect, check whether another connection to the
> same SRP target identifier already exists. If so, remove the
> target port.  Add a target to the target list before connecting
> instead of after such that this algorithm has a chance to work.

I was OK before with preventing the addition of a duplicate connection,
but the initiator shouldn't be enforcing the removal of previous
connections -- that should happen via the target issuing a DREQ.

If you're going to disallow duplicate requests, then just disallow
adding the new one, don't tear down the old one -- let the admin
manually do that if desired.


> +/**
> + * srp_conn_unique() - Check whether the connection to a target is unique.
> + *
> + * Connections are compared by their SCSI target port identifier: identifier
> + * extension + IO controller GUID. See also paragraph B.5 in the SRP spec.
> + */
> +static bool srp_conn_unique(struct srp_host *host,
> +			    struct srp_target_port *target)
> +{
> +	struct srp_target_port *t;
> +	bool ret = true;
> +
> +	spin_lock(&host->target_lock);
> +	list_for_each_entry(t, &host->target_list, list) {
> +		if (t != target &&
> +		    target->id_ext == t->id_ext &&
> +		    target->ioc_guid == t->ioc_guid) {

You also need to consider target->initiator_ext here -- that will change
the I_T nexus.

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
