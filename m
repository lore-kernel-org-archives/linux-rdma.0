From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 08/18] ib_srp: Eliminate state SRP_TARGET_DEAD
Date: Sun, 26 Feb 2012 01:33:06 -0500
Message-ID: <1330237986.1026.86.camel@obelisk.thedillows.org>
References: <3109536.qySrY1Ts3e@asus> <1542335.oobt4mZRgv@asus>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1542335.oobt4mZRgv@asus>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, 2012-01-14 at 12:46 +0000, Bart Van Assche wrote:
> Only queue removal work after having changed the target state
> into SRP_TARGET_REMOVED and not if that state was already equal
> to SRP_TARGET_REMOVED. That allows to remove the state
> SRP_TARGET_DEAD. Add a call to srp_disconnect_target() in
> srp_remove_target() - due to previous changes it is now safe to
> invoke that last function even if the IB connection has already
> been disconnected. Rename srp_target_port.work into
> srp_target_port.remove_work and move function srp_change_state()
> to just before srp_change_state_to_removed().

Again, commit messages should be about why you changed, not a mechanical
listing of what you change.

"Rename srp_target_port.work into srp_target_port.remove_work" doesn't
tell me anything. I had to read later patches to see that what you mean
was really "Rename srp_target_port.work to reflect its usage and remove
a future conflict when push the SCSI scan into it's own work task."

This would have saved me some head scratching, and is why I try to
review as much as I can of a series in one go -- all too often you make
changes that leave me wondering until I see a later patch.

I'm also not keen on how the code looks after these changes, but I do
like getting rid of the DEAD state... I'm not sure there is a good way
to handle the removal of the module that doesn't look a bit ugly.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
