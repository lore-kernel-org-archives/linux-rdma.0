From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 01/18] ib_srp: Introduce pr_fmt()
Date: Sun, 26 Feb 2012 01:31:38 -0500
Message-ID: <1330237900.1026.79.camel@obelisk.thedillows.org>
References: <3109536.qySrY1Ts3e@asus> <2235456.14ddII0dbk@asus>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2235456.14ddII0dbk@asus>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, 2012-01-14 at 12:39 +0000, Bart Van Assche wrote:
> Make the logging code a little more brief by replacing
> printk(KERN_WARNING PFX ...) by pr_warn(...) and by replacing
> printk(KERN_ERR PFX ...) by pr_err(...).  Join log messages
> split over multiple lines into a single line to make it easier
> to grep for these messages. Change the severity of the log
> statement in srp_qp_event() from "error" to "debug". Change a
> double space into a single in the "bad IO class parameter" error
> message. Remove one trailing space to avoid a checkpatch warning.

All you really need for the commit message is "Using pr_* is preferred
over printk". The rest is superfluous and readily apparent from the
patch itself.

Otherwise, this patch is fine.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
