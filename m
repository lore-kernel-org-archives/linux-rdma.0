From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/cma: Set default gid type to RoCEv2
Date: Wed, 7 Jun 2017 12:07:50 +0300
Message-ID: <20170607090750.GC1127@mtr-leonro.local>
References: <20170530064734.4731-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GZVR6ND4mMseVXL/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170530064734.4731-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--GZVR6ND4mMseVXL/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 30, 2017 at 09:47:34AM +0300, Leon Romanovsky wrote:
> From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> RoCEv2 is the preferred RDMA protocol for Ethernet link layer because
> of its advantages over RoCEv1. For better user experience make it the
> default choice for RDMA_CM connections if device/port support it.
>
> Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/core/cma.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index 91b7a2fe5a55..5ce3c9e1657e 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -72,6 +72,7 @@ MODULE_LICENSE("Dual BSD/GPL");
>  #define CMA_MAX_CM_RETRIES 15
>  #define CMA_CM_MRA_SETTING (IB_CM_MRA_FLAG_DELAY | 24)
>  #define CMA_IBOE_PACKET_LIFETIME 18
> +#define CMA_PREFERRED_ROCE_GID_TYPE IB_GID_TYPE_ROCE_UDP_ENCAP

It should be (1 << IB_GID_TYPE_ROCE_UDP_ENCAP) and not as was written
above. We will send a fix for that.

Thanks

--GZVR6ND4mMseVXL/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlk3wmUACgkQ5GN7iDZy
WKf4ABAAvCP4JXlb0linD2BFi9f/HkryKOJetZSKGN0e1PgHIcUjkPV1CdeP84m1
CAWoDl0VKZ/VdFdkVgQR3d1SELaLWw5PtqYb10xW0CReqSVTGKfBUiOqc1+3HefO
XzUbky4zYik/hhSk8HwtyPjePJmhJPp2++/Hf9xfkN0PT/j5HwWcBcCaKS+8Px6R
DY5OgTwYm693YmUAWq7LfSuI4ES6J0RxwPAw9CCFw94hBAob+Au4QMx9AvKJmHok
/J5vflyMLbgTbLJ7zm+DHAm1DfA9EDXU0ldZNzz/+yYrxbvKeMrYrispSmhqvTEC
gALqrL2UqqWVeCk/uJgFL5kSS4NztPHUX2sPT1o5R6w0Kcl3CNN49loceuBevS60
qlPbxnPeBPtcRs4yRo7+N4hi1DCk8yxCDPLgDpFOlWPVYAhg7vA5SMT7Xm9ms9QP
8VBNo35WlPFuHNa1iR3oErkJAUvdwpgyyXUFffCkTu1JP6TU/8gbC7O5KyXK118x
REskerw22GLUP0ULu8OYFSjUunCJpbJIATg7suxFAkSso8n62a9M5LysBy+QI24k
ZpSAkptXIHFhsPFmPzcGZmARoj40xz1y3hEaR4S7yS7HFWqUawW7ABV/Zo2WUIyp
MajSDwkLmZA3OhbJXK/vEIDIOa0051dh/1xKTbntioUd43IEj2U=
=Aezs
-----END PGP SIGNATURE-----

--GZVR6ND4mMseVXL/--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
