From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 07/18] ib_srp: Introduce three helper functions
Date: Sun, 26 Feb 2012 01:32:49 -0500
Message-ID: <1330237969.1026.85.camel@obelisk.thedillows.org>
References: <3109536.qySrY1Ts3e@asus> <3639113.Zct32Hvp8M@asus>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3639113.Zct32Hvp8M@asus>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, 2012-01-14 at 12:45 +0000, Bart Van Assche wrote:
> Introduce srp_remove_target(), srp_change_state_to_removed() and
> srp_scan_target().

> +static bool srp_change_state_to_removed(struct srp_target_port *target)
> +{
> +	bool changed = false;
> +
> +	spin_lock_irq(&target->lock);
> +	if (target->state != SRP_TARGET_REMOVED) {
> +		target->state = SRP_TARGET_REMOVED;
> +		changed = true;
> +	}
> +	spin_unlock_irq(&target->lock);
> +
> +	return changed;
> +}

I'm not sure why you introduce this here, just to move
srp_change_state() up and change this back to
	srp_change_state(target, SRP_TARGET_LIVE, SRP_TARGET_REMOVED);
in the next patch.

There also doesn't seem to be much of a reason to introduce
srp_scan_target() now rather than in patch 18 where you add another use
of it.

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
