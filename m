From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC 7/8] IB/srp: try to use larger FMR sizes to cover our mappings
Date: Thu, 20 Jan 2011 12:24:11 +0200
Message-ID: <4D380D4B.6060404@voltaire.com>
References: <1295411242-26148-1-git-send-email-dillowda@ornl.gov> <1295411242-26148-8-git-send-email-dillowda@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1295411242-26148-8-git-send-email-dillowda-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

David Dillow wrote:
> Now that we can get larger SG lists, we can take advantage of HCAs that
> allow us to use larger FMR sizes. In many cases, we can use up to 512
> entries, so start there and work our way down.

I'm not clear what this patch really tries to do but before that, going
to low level details

> +	for (max_pages_per_fmr = SRP_FMR_SIZE;
> +			max_pages_per_fmr >= SRP_FMR_MIN_SIZE;
> +			max_pages_per_fmr /= 2, srp_dev->fmr_max_size /= 2) {
> +		fmr_param.pool_size	    = SRP_FMR_POOL_SIZE;
> +		fmr_param.dirty_watermark   = SRP_FMR_DIRTY_SIZE;
> +		fmr_param.cache		    = 1;
> +		fmr_param.max_pages_per_fmr = SRP_FMR_SIZE;
> +		fmr_param.page_shift	    = fmr_page_shift;

> +		srp_dev->fmr_pool = ib_create_fmr_pool(srp_dev->pd, &fmr_param);
> +		if (!IS_ERR(srp_dev->fmr_pool))
> +			break;
> +	}

aren't stepping on srp_dev->fmr_pool on each invocation of the for loop? didn't you
want page_shift and/or max_pages_per_fmr to change throughout the loop?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
