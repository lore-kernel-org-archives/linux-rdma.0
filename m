From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 01/14] ib_srp: Introduce pr_fmt()
Date: Thu, 01 Dec 2011 18:40:05 -0500
Message-ID: <1322782805.11664.11.camel@lap75545.ornl.gov>
References: <201112011954.25811.bvanassche@acm.org>
 <201112011955.47198.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <201112011955.47198.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2011-12-01 at 13:55 -0500, Bart Van Assche wrote:
> Make the logging code more a little more brief by replacing
> printk(KERN_WARNING PFX ...) by pr_warn(...) and by replacing
> printk(KERN_ERR PFX ...) by pr_err(...). Remove one trailing
> space to avoid a checkpatch warning.

This is a good step; three minor nits:
1) Please go ahead and merge the multiline strings into one, even though
checkpatch will complain about the line length. I'm not a huge fan of
the long lines either, but Linus has clearly stated his preference for
being able to grep the string in the message
2) Please re-align the variables on wrapped lines to just after the (;
below the work token should be pushed over by one space.
3) All the commit message needs to really say is 'Using pr_* is
preferred over printk.' Probably can just be the short summary, and no
commit body needed. 

>  			if (token != SRP_REV10_IB_IO_CLASS &&
>  			    token != SRP_REV16A_IB_IO_CLASS) {
> -				printk(KERN_WARNING PFX "unknown IO class parameter value"
> +				pr_warn("unknown IO class parameter value"
>  				       " %x specified (use %x or %x).\n",
>  				       token, SRP_REV10_IB_IO_CLASS, SRP_REV16A_IB_IO_CLASS);
>  				goto out;

Thanks!
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
