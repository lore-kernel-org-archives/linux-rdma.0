From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 05/18] ib_srp: Separate connection and host state
Date: Sun, 26 Feb 2012 01:32:28 -0500
Message-ID: <1330237948.1026.83.camel@obelisk.thedillows.org>
References: <3109536.qySrY1Ts3e@asus> <2010394.C571grUHsm@asus>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2010394.C571grUHsm@asus>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, 2012-01-14 at 12:43 +0000, Bart Van Assche wrote:
> Separate connection and host state. Only report QP errors while
> connected. Only invoke ib_send_cm_dreq() from inside
> srp_disconnect_target() when connected such that invoking
> srp_disconnect_target() after having received a DREQ does not
> cause an error message to be printed.

I'm not sure that splitting connection state from the target state is
really buying you anything other than more storage and complexity.
I looked to later patches for a reason this makes sense, but I'm coming
up short, so maybe I'm just missing it.

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
