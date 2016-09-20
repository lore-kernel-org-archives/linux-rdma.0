From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] Support for Chelsio T6 devices
Date: Tue, 20 Sep 2016 13:21:08 +0300
Message-ID: <20160920102108.GG26673@leon.nu>
References: <20160919200957.8777AE0BC1@smtp.ogc.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="c7hkjup166d4FzgN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160919200957.8777AE0BC1-/5N3P9jjx0xzbRFIqnYvSA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--c7hkjup166d4FzgN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 19, 2016 at 12:55:16PM -0700, Steve Wise wrote:
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> ---
>  src/perftest_parameters.c |    1 +
>  src/perftest_parameters.h |    3 ++-
>  2 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/src/perftest_parameters.c b/src/perftest_parameters.c
> index a21b6eb..0d1ea2f 100755
> --- a/src/perftest_parameters.c
> +++ b/src/perftest_parameters.c
> @@ -1326,6 +1326,7 @@ enum ctx_device ib_dev_name(struct ibv_context *context)
>  			case 4  : dev_fname = CHELSIO_T4; break;
>  			case 11 :
>  			case 5  : dev_fname = CHELSIO_T5; break;
> +			case 6  : dev_fname = CHELSIO_T6; break;
>  			default : dev_fname = UNKNOWN; break;
>  		}
>
> diff --git a/src/perftest_parameters.h b/src/perftest_parameters.h
> index 448e398..727a65f 100755
> --- a/src/perftest_parameters.h
> +++ b/src/perftest_parameters.h
> @@ -269,7 +269,8 @@ enum ctx_device {
>  	CONNECTX4		= 10,
>  	CONNECTX4LX		= 11,
>  	QLOGIC_E4		= 12,
> -	QLOGIC_AH		= 13
> +	QLOGIC_AH		= 13,
> +	CHELSIO_T6		= 14

Nit comment,
if you use "14," and not "14", the next submitter will send patch with
less churn.

>  };
>
>  /* Units for rate limiter */
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--c7hkjup166d4FzgN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX4Q2UAAoJEORje4g2clinPEkP/1s/9uLHvDhgQwCW8890vC3N
W3U6Fv12XXgBtkcdxg3oMS24mT/FzJ/HdfYNO2bJHdum8cYZEDWUQ5iVrmg3poDy
2e7z/LV3MEDNnrbFUIxv1vfGmYJgTOPZNwVXMz0y2tDomwH0g8f5eZo9A90F+OWg
YcOcyIUzY0GwqcYyI3Higk0UNoJGkNz/6Cr0T0Gk+r4Z2z5PEUE6nuZAbUamnavz
C8zbphZ69ROToZkg0rTQLCBXWFyCVhd3wnSERWDA0Ai9+VcWdx60mwlmwM2UFbN7
nuejNsFlgrjhbrITKCfMo5ktOjkxKGY/MpX2mWuyDkkepF67OJOxRxxswujAfTVV
XL2XmDr4CCf6dzaDAZcpdOOrQjpaP77VwSQY/kiZ7WkVo1OuX8hfFaC0eh9nfAvs
NVg1kmjYrZy2u46PM/LWiAT6/7x7mtwOWBSC7lPYpHsWbRvZF5M9jx4Ck+qXwIK+
aQmIokP7A8WQyKu6Xw6wQaIIvPlBfTA6kZ0a+F5J71Z1o9lcPBxjSx+II73gzs9w
ffgMR+ZK0rfI+QzH/hwuXAbv39dt6ARtuLG+PziRkkQp4QRzFvEOBEIzSBsug0QE
x4t9+adLE2UVOypZ7UjMBnKXAWnbAmfvoBVH7+GESCCj2YGSBltJQcsqGebRmnU2
BTOvg+XWOxBeHAfNOjH+
=sb8n
-----END PGP SIGNATURE-----

--c7hkjup166d4FzgN--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
