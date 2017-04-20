From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC 1/2] Introduce egress IB flow steering flag
Date: Thu, 20 Apr 2017 20:48:09 +0300
Message-ID: <20170420174809.GS14088@mtr-leonro.local>
References: <cover.1492685328.git.borisp@mellanox.com>
 <8539540c4130ea91bbd128f2ec2845082d6000f8.1492685328.git.borisp@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="CUrluEZVXmx7ezWQ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8539540c4130ea91bbd128f2ec2845082d6000f8.1492685328.git.borisp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boris Pismenny <borisp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ronye-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, aviadye-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

--CUrluEZVXmx7ezWQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 20, 2017 at 02:00:09PM +0300, Boris Pismenny wrote:
> From: borisp <borisp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> This commit introduces egress flow steering. Egress flow steering
> is useful for specifying actions that might be applied by hardware
> to outgoing flows on a specific QP.
>

How will user know which flow actions are applicable for egress traffic,
for both ingress/egress and for ingress only?

I think separate structure for ingress vs. egress are better approach,
than blind global flag.


> Signed-off-by: borisp <borisp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Please configure your git, "Signed-off-by" line is a legal document and
supposed to have proper author name.

Thanks

> ---
>  include/rdma/ib_verbs.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 99e4423..6c1c867 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -1679,7 +1679,8 @@ enum ib_flow_domain {
>
>  enum ib_flow_flags {
>  	IB_FLOW_ATTR_FLAGS_DONT_TRAP = 1UL << 1, /* Continue match, no steal */
> -	IB_FLOW_ATTR_FLAGS_RESERVED  = 1UL << 2  /* Must be last */
> +	IB_FLOW_ATTR_FLAGS_EGRESS = 1UL << 2, /* Egress steering rule */
> +	IB_FLOW_ATTR_FLAGS_RESERVED  = 1UL << 3  /* Must be last */
>  };
>
>  struct ib_flow_eth_filter {
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--CUrluEZVXmx7ezWQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlj49FkACgkQ5GN7iDZy
WKfkAA//eKzadS4C3XuSekVk58zzjmPZQGEntu6pw4T1CIh+b8BCkK0uyeTT/GUU
5uoWybMN1u9IXrs6vWuMABlKZYte7hPvjpBD66D6xoGU1TYKkdtKzZ8OvqS7Oypx
9Ns25iiX3s2artuxiLfWJL6WCchjYQX822qcN55+i6SG3de5IuGXp4sZf4eNRmDs
FBNFM4q19Rt5Ql2EyRj99f2bWR1rR2XiGI2tpOrVffnlUuuZ54tnb7LgjETRX+bt
AsQ3XtQUezy58WHIgG3Y0LOHBxXBCpYocHDP9Tk6U0L2oRCLWLlzKJNrmpqLbnOW
R2pDjugAMc6b/C6Er+zgfLVCcFX8Lvl1x0eEbXI/dkTWMysik7Qb02RYauN9anQQ
/Ka5iMrl/OzTMKOOdupmH0a5jB6rCpm72Wczq3zBm3R/eYfDWSAa4YeEr+vR1NnE
iAEa/nh8RDA5g3IMGOmeBhaiWeNfBNxLNjMrz/VJr0jg832T0djSFyO9EUKzx4en
FXv88W2OhqxPIII4WDEYM1X3OVkfV/O8M6IFsHeQxAxRJgDpRnzJ+2jUMR0XpP/G
O6UtSpPp+qCUfd/e4wGtYXtdS9+NEO84Kci/4YvBiWpBtmrwlLQ0m7JgjJDmO/Sq
x5c06KOq5oSVYjYWc3nhm615ggZmLZRVTebvgb94/XlzyOk8CJY=
=MzRr
-----END PGP SIGNATURE-----

--CUrluEZVXmx7ezWQ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
