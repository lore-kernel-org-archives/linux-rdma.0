From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 04/18] ib_srp: Micro-optimize completion handlers
Date: Sun, 26 Feb 2012 01:32:14 -0500
Message-ID: <1330237934.1026.82.camel@obelisk.thedillows.org>
References: <3109536.qySrY1Ts3e@asus> <8420403.E35AZndOFd@asus>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8420403.E35AZndOFd@asus>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, 2012-01-14 at 12:42 +0000, Bart Van Assche wrote:
> Reduce completion queue lock contention by polling for multiple
> work completions at once. Help the CPU branch predictor by making
> it clear that IB_WC_SUCCESS is the most likely case. Move the
> error handling code into the new function srp_handle_qp_err().
> 
> Also, convert srp_target_port.qp_in_error from int to bool and
> move the initialization of that variable into srp_connect_target().

Don't merge the two different changes here. Introducing
srp_handle_qp_err() is fine, but the change to polling for multiple WC
is completely unrelated to that and to the stated intent of this series.
It also hurt performance when I measured it during the IOP scaling work.

Let's get this series out of the way, then we can talk about the WC
changes.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
