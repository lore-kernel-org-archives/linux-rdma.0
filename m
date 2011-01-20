From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [RFC 7/8] IB/srp: try to use larger FMR sizes to cover our
 mappings
Date: Thu, 20 Jan 2011 07:40:50 -0500
Message-ID: <1295527250.22825.50.camel@obelisk.thedillows.org>
References: <1295411242-26148-1-git-send-email-dillowda@ornl.gov>
	 <1295411242-26148-8-git-send-email-dillowda@ornl.gov>
	 <4D380D4B.6060404@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D380D4B.6060404-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2011-01-20 at 12:24 +0200, Or Gerlitz wrote:
> David Dillow wrote:
> > Now that we can get larger SG lists, we can take advantage of HCAs that
> > allow us to use larger FMR sizes. In many cases, we can use up to 512
> > entries, so start there and work our way down.
> 
> I'm not clear what this patch really tries to do but before that, going
> to low level details

I want to use 512 entry FMRs instead of 256 entry ones. I'll accept 128
entries if I have to. This reduces the number of indirect entries in the
list going to the client.

> > +	for (max_pages_per_fmr = SRP_FMR_SIZE;
> > +			max_pages_per_fmr >= SRP_FMR_MIN_SIZE;
> > +			max_pages_per_fmr /= 2, srp_dev->fmr_max_size /= 2) {
> > +		fmr_param.pool_size	    = SRP_FMR_POOL_SIZE;
> > +		fmr_param.dirty_watermark   = SRP_FMR_DIRTY_SIZE;
> > +		fmr_param.cache		    = 1;
> > +		fmr_param.max_pages_per_fmr = SRP_FMR_SIZE;
> > +		fmr_param.page_shift	    = fmr_page_shift;
> 
> > +		srp_dev->fmr_pool = ib_create_fmr_pool(srp_dev->pd, &fmr_param);
> > +		if (!IS_ERR(srp_dev->fmr_pool))
> > +			break;
> > +	}
> 
> aren't stepping on srp_dev->fmr_pool on each invocation of the for loop?

No, we break out of the loop if we got a good allocation -- ! IS_ERR().

> didn't you want page_shift and/or max_pages_per_fmr to change
> throughout the loop?

Uhm. Yeah. Forgot to s/SRP_FMR_SIZE/max_pages_per_fmr/ there, didn't I.
Good catch, thanks.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
