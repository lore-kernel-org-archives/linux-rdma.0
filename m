From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 06/18] ib_srp: Wait for last completion when
 disconnecting
Date: Sun, 26 Feb 2012 01:32:40 -0500
Message-ID: <1330237960.1026.84.camel@obelisk.thedillows.org>
References: <3109536.qySrY1Ts3e@asus> <1559902.bolRMFhoqP@asus>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1559902.bolRMFhoqP@asus>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, 2012-01-14 at 12:44 +0000, Bart Van Assche wrote:
> When disconnecting the IB connection via the IB CM, wait until
> any invoked completion handlers have finished processing SRP
> protocol data and prevent that new work completions are queued.
> Change the IB completion handlers such that all error completions
> are processed instead of a subset and also such that receiving a
> completion with zero wr_id is recognized as an end-of-work marker.

This seems really ugly, and a bit of overkill. There must be a better
way.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
