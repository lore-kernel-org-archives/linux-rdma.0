From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v4 5/8] IB/core: Add functions to convert 32
 bit lids to 16 bits
Date: Fri, 11 Aug 2017 14:03:55 +0300
Message-ID: <20170811110355.GF24282@mtr-leonro.local>
References: <1502388268-20687-1-git-send-email-don.hiatt@intel.com>
 <1502388268-20687-6-git-send-email-don.hiatt@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cHMo6Wbp1wrKhbfi"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1502388268-20687-6-git-send-email-don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--cHMo6Wbp1wrKhbfi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 10, 2017 at 02:04:25PM -0400, Don Hiatt wrote:
> Add two helper functions (ib_lid_cpu16(), ib_lid_be16()) to
> convert 32 bit lids to 16 bits.
>
> Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  include/rdma/ib_verbs.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index a7d6990..3875ea5d 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -3710,4 +3710,16 @@ static inline enum rdma_ah_attr_type rdma_ah_find_type(struct ib_device *dev,
>  	else
>  		return RDMA_AH_ATTR_TYPE_IB;
>  }
> +
> +/* Return lid in 16bit CPU encoding */
> +static inline u16 ib_lid_cpu16(u32 lid)
> +{
> +	return (u16)lid;
> +}
> +
> +/* Return lid in 16bit BE encoding */
> +static inline u16 ib_lid_be16(u32 lid)
> +{
> +	return cpu_to_be16((u16)lid);
> +}

Please add comments to these functions, with the description when and
why we are doing this conversion, and I think that it is worth to add
here WARN_ON_ONCE(lid && 0xFFFF0000) to catch possible bad flows.

>  #endif /* IB_VERBS_H */
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--cHMo6Wbp1wrKhbfi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmNjxsACgkQ5GN7iDZy
WKcbeRAAwkPo4dCKHWMRc+G9JLb6kLs5K6Rl1QQPZt2+IupNvfjpdQwCOuCfagAY
iwWNG/A6OUpvxqp/9eMHY/tJksQgVBUgqDfPE0HOcXSuo3eS4TTI7YlPYWxsoA8n
DVWzFzCkNKlKjlVCyCBBg6z1HDgoJCp3MMNAgXYbF9KRYBLISAIFh3L0jr7LSfG+
JUUzKawKEfDq0ztbB1hxaYXz04VTXNdUkDMKkv0/6sGQ1Y/sgAa2Oktm8+pK8l7l
1GNDxgmK+a9TadLs1gbaL/TaVs+8uKr4FUAQxYzvISDfxK9/YgzUB0PEbS9FgCEn
XypUyhoYhgkO1XFaLkdHx7JmtAqX3cX9ERWmKgEOed6/T7fwDWJkqvtdPJ+esWGe
P/WiewUzBXhIKntgKAO50r/GlYUHg9XNwrm+B/SpZ2B3iLdlW+ejZwQ65436xsyo
UBIsOM3olMmLui7uQSab+ntayum+MTxjQz+REYRGgqRcLJbUYQ76R1uOTrBkibRv
t98zIiIarHMlxXykZdLDeY+jlab50OhtsipeKWc6xBvBJFeSWxslGZNYd28bZZgJ
jiV5gAbPN+FfBOL1YOelIOsx+bw7uf4klB8BRxwqvVyzsld0E7KORdwr0C01zDO5
JY0oZmlryRhmM82YOgYCFdv7pbj9WrpqZGed8NRAM6ZwOpFjxuA=
=NfZC
-----END PGP SIGNATURE-----

--cHMo6Wbp1wrKhbfi--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
