From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH RFC v2 1/3] rdma_cm: add rdma_reject_msg() helper
        function
Date: Fri, 21 Oct 2016 14:12:34 +0200
Message-ID: <20161021121234.GA17028@lst.de>
References: <cover.1477003235.git.swise@opengridcomputing.com> <1360f08b7c25f3befcd6836b47af81e2ecb51b75.1477003235.git.swise@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1360f08b7c25f3befcd6836b47af81e2ecb51b75.1477003235.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, sagig-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> +const char *__attribute_const__ ib_reject_msg(int reason)
> +{
> +	size_t index = reason;
> +
> +	return (index < ARRAY_SIZE(ib_rej_reason_strs) &&
> +		ib_rej_reason_strs[index]) ?
> +		ib_rej_reason_strs[index] : "unrecognized reason";
> +}
> +EXPORT_SYMBOL(ib_reject_msg);

This looks a bit odd, why not something like:

const char *__attribute_const__ ib_reject_msg(int reason)
{
	if (reason >= ARRAY_SIZE(ib_rej_reason_strs) ||
	    !ib_rej_reason_strs[reason])
		return "unrecognized reason";
	return ib_rej_reason_strs[reason];
}

> +const char *__attribute_const__ iw_reject_msg(int reason)
> +{
> +	size_t index = -reason;
> +
> +	/* iWARP uses negative errnos */
> +	index = -index;
> +	return (index < ARRAY_SIZE(iw_rej_reason_strs) &&
> +		iw_rej_reason_strs[index]) ?
> +		iw_rej_reason_strs[index] : "unrecognized reason";
> +}
> +EXPORT_SYMBOL(iw_reject_msg);

Same here:

const char *__attribute_const__ iw_reject_msg(int reason)
{
	/* iWARP uses negative errnos */
	reason = -reason;

	if (reason >= ARRAY_SIZE(iw_rej_reason_strs) ||
	    !iw_rej_reason_strs[reason])
		return "unrecognized reason";
	return iw_rej_reason_strs[reason];
}

Otherwise this looks good and very useful to me.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
