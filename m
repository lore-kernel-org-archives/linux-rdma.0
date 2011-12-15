From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 02/14] ib_srp: Consolidate repetitive sysfs code
Date: Thu, 15 Dec 2011 13:26:46 -0500
Message-ID: <1323973606.16703.16.camel@lap75545.ornl.gov>
References: <201112011954.25811.bvanassche@acm.org>
	 <201112011957.19892.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201112011957.19892.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2011-12-01 at 19:57 +0100, Bart Van Assche wrote:
> Remove sysfs attributes before removing a target instead of
> testing the target state in every sysfs attribute callback
> method. Note: it is safe to invoke a sysfs attribute removal
> method like device_remove_file() twice on the same attribute.

This is much cleaner, thanks.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
