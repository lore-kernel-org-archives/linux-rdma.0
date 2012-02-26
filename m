From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 02/18] ib_srp: Consolidate repetitive sysfs code
Date: Sun, 26 Feb 2012 01:31:50 -0500
Message-ID: <1330237910.1026.80.camel@obelisk.thedillows.org>
References: <3109536.qySrY1Ts3e@asus> <1500127.hxDoVn5zlk@asus>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500127.hxDoVn5zlk@asus>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, 2012-01-14 at 12:40 +0000, Bart Van Assche wrote:
> Remove sysfs attributes before removing a target instead of
> testing the target state in every sysfs attribute callback
> method. Note: it is safe to invoke a sysfs attribute removal
> method like device_remove_file() twice on the same attribute.

This patch is fine.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
