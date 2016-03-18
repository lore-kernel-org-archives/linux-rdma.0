From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: [PATCH] i40iw: Replace the obsolete crypto hash interface with
 shash
Date: Fri, 18 Mar 2016 10:39:10 +0800
Message-ID: <20160318023910.GB17000@gondor.apana.org.au>
References: <20160317212220.GA7292@TENIKOLO-MOBL2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160317212220.GA7292@TENIKOLO-MOBL2>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 17, 2016 at 04:22:20PM -0500, Tatyana Nikolova wrote:
>
> +	tfm = crypto_alloc_shash("crc32c", 0, CRYPTO_ALG_ASYNC);

No need for CRYPTO_ALG_ASYNC as shash is by definition sync only.

Thanks,
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
