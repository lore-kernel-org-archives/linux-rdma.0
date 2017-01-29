From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 06/11] libbnxtre: convert cpu to le all over
 the place
Date: Sun, 29 Jan 2017 16:09:45 -0700
Message-ID: <20170129230945.GD24051@obsidianresearch.com>
References: <1485641622-30015-1-git-send-email-devesh.sharma@broadcom.com>
 <1485641622-30015-7-git-send-email-devesh.sharma@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1485641622-30015-7-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Jan 28, 2017 at 05:13:37PM -0500, Devesh Sharma wrote:

> +/* Memory byte order conversion functions. */
> +#if __BYTE_ORDER == __BIG_ENDIAN

No reason for this ifdef

> +static inline int bnxt_re_host_to_le64(uint64_t *src, int bytes)
> +{
> +	int qwords, indx;
> +
> +	if (!bytes || bytes < 8)
> +		return -EINVAL;
> +
> +	qwords = bytes / sizeof(uint64_t);
> +	for (indx = 0; indx < qwords; indx++) {
> +		if (*(src + indx))
> +			*(src + indx) = htole64(*(src + indx));
> +	}
> +
> +	return qwords;
> +}
> +
> +static inline int bnxt_re_le64_to_host(uint64_t *src, int bytes)
> +{
> +	int qwords, indx;
> +
> +	if (!bytes || bytes < 8)
> +		return -EINVAL;
> +
> +	qwords = bytes / sizeof(uint64_t);
> +	for (indx = 0; indx < qwords; indx++) {
> +		if (*(src + indx))
> +			*(src + indx) = le64toh(*(src + indx));
> +	}
> +
> +	return qwords;
> +}
> +#else
> +static inline int bnxt_re_host_to_le64(uint64_t *src, int bytes)
> +{
> +	return 0;
> +}
> +
> +static inline int bnxt_re_le64_to_host(uint64_t *src, int bytes)
> +{
> +	return 0;
> +}

And your alts look broken anyhow. Just use the first version, gcc will
optimize it properly..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
