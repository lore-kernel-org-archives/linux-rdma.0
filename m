From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 18/18] ib_srp: Rework error handling
Date: Sun, 26 Feb 2012 01:39:13 -0500
Message-ID: <1330238354.1026.93.camel@obelisk.thedillows.org>
References: <3109536.qySrY1Ts3e@asus> <2527465.kS0UWM2o6z@asus>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2527465.kS0UWM2o6z@asus>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, 2012-01-14 at 12:57 +0000, Bart Van Assche wrote:
> Add fast_io_fail_tmo and dev_loss_tmo sysfs attributes. Block
> the SCSI target as soon as a transport layer error has been
> detected (ping timeout, disconnect or IB error completion). Try
> to reconnect until dev_loss_tmo elapses.
> 
> Disconnect the IB connection earlier in srp_remove_target() to
> make sure that error recovery is not triggered during host
> removal. Swap the "connected" and "removed" tests in
> srp_queuecommand() because of this change.
> 
> Rescan LUNs after having unblocked a SCSI target controlled by
> ib_srp.

The inclusion of the ping gets 16..18 a NAK from me. As I've previously
said, this is better handled by user space and you add additional
failure cases when you try to retrofit a transport ping into SRP. Just
don't do it.

I'll try to parse through the rest of this soon to give you feedback on
the conversion to dev_loss_tmo etc.

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
