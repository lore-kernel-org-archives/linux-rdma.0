From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [infiniband-diags] [1/2] support libibnetdisc caching
 overwrite flag
Date: Mon, 19 Apr 2010 18:04:10 +0300
Message-ID: <20100419150410.GA23994@me>
References: <1271375547.17987.178.camel@auk31.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1271375547.17987.178.camel-X2zTWyBD0EhliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Al,

On 16:52 Thu 15 Apr     , Al Chu wrote:
> diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c b/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c
> index 480a0a2..6cf7d4d 100644
> --- a/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c
> +++ b/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c
> @@ -876,9 +876,20 @@ int ibnd_cache_fabric(ibnd_fabric_t * fabric, const char *file,
>  		return -1;
>  	}
>  
> -	if (!stat(file, &statbuf)) {
> -		IBND_DEBUG("file '%s' already exists\n", file);
> -		return -1;
> +	if (flags & IBND_CACHE_FABRIC_FLAG_OVERWRITE) {
> +		if (!stat(file, &statbuf)) {
> +			if (unlink(file) < 0) {
> +				IBND_DEBUG("error removing '%s': %s\n",
> +					   file, strerror(errno));
> +				return -1;
> +			}
> +		}
> +	}
> +	else {
> +		if (!stat(file, &statbuf)) {
> +			IBND_DEBUG("file '%s' already exists\n", file);
> +			return -1;
> +		}
>  	}

Wouldn't it be better to make it in opposite direction - overwrite file
by default and drop an error when "exclusive" flag is specified?

For me it looks as more "intuitive" behavior (similar to other
editors).

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
