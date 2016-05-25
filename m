From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 10/10] IB/hfi1: Fix credit return threshold adjustment
Date: Wed, 25 May 2016 16:36:13 +0300
Message-ID: <20160525133613.GN25500@leon.nu>
References: <20160524194746.19706.42976.stgit@scvm10.sc.intel.com>
 <20160524195111.19706.76829.stgit@scvm10.sc.intel.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l3ej7W/Jb2pB3qL2"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160524195111.19706.76829.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--l3ej7W/Jb2pB3qL2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 24, 2016 at 12:51:12PM -0700, Dennis Dalessandro wrote:
> From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> The credit return threshold adjustment on mtu change algorithm does not
> take into account all the kernel send contexts that are assigned per VL.
> Use the pio send context map to adjust the credit return thresholds for
> all the allocated and assigned kernel send contexts based on the MTU
> adjustment per VL.
>=20
> The pio send context map can be changed dynamically based on the actual
> number of operational vls which is set by the fabric manager. When this
> happens update the credit return threshold values for all the remapped
> kernel send contexts.
>=20
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/hfi1/chip.c |    7 +++++--
>  drivers/infiniband/hw/hfi1/pio.c  |   21 +++++++++++++++++++--
>  2 files changed, 24 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hf=
i1/chip.c
> index 3b876da..be4fd3e 100644
> --- a/drivers/infiniband/hw/hfi1/chip.c
> +++ b/drivers/infiniband/hw/hfi1/chip.c
> @@ -9777,7 +9777,7 @@ static void set_send_length(struct hfi1_pportdata *=
ppd)
>  	u64 len1 =3D 0, len2 =3D (((dd->vld[15].mtu + max_hb) >> 2)
>  			      & SEND_LEN_CHECK1_LEN_VL15_MASK) <<
>  		SEND_LEN_CHECK1_LEN_VL15_SHIFT;
> -	int i;
> +	int i, j;
>  	u32 thres;
> =20
>  	for (i =3D 0; i < ppd->vls_supported; i++) {
> @@ -9801,7 +9801,10 @@ static void set_send_length(struct hfi1_pportdata =
*ppd)
>  			    sc_mtu_to_threshold(dd->vld[i].sc,
>  						dd->vld[i].mtu,
>  						dd->rcd[0]->rcvhdrqentsize));
> -		sc_set_cr_threshold(dd->vld[i].sc, thres);
> +		for (j =3D 0; j < INIT_SC_PER_VL; j++)
> +			sc_set_cr_threshold(
> +					pio_select_send_context_vl(dd, j, i),
> +					    thres);
>  	}
>  	thres =3D min(sc_percent_to_threshold(dd->vld[15].sc, 50),
>  		    sc_mtu_to_threshold(dd->vld[15].sc,
> diff --git a/drivers/infiniband/hw/hfi1/pio.c b/drivers/infiniband/hw/hfi=
1/pio.c
> index d5edb1a..d5a9a5c 100644
> --- a/drivers/infiniband/hw/hfi1/pio.c
> +++ b/drivers/infiniband/hw/hfi1/pio.c
> @@ -1832,6 +1832,7 @@ int pio_map_init(struct hfi1_devdata *dd, u8 port, =
u8 num_vls, u8 *vl_scontexts)
>  	int scontext =3D 1;
>  	int num_kernel_send_contexts =3D 0;
>  	u8 lvl_scontexts[OPA_MAX_VLS];
> +	u32 thres;
>  	struct pio_vl_map *oldmap, *newmap;
> =20
>  	if (!vl_scontexts) {
> @@ -1872,11 +1873,27 @@ int pio_map_init(struct hfi1_devdata *dd, u8 port=
, u8 num_vls, u8 *vl_scontexts)
>  			if (!newmap->map[i])
>  				goto bail;
>  			newmap->map[i]->mask =3D (1 << ilog2(sz)) - 1;
> -			/* assign send contexts */
> +			/*
> +			 * assign send contexts and
> +			 * adjust credit return threshold
> +			 */
>  			for (j =3D 0; j < sz; j++) {
> -				if (dd->kernel_send_context[scontext])
> +				if (dd->kernel_send_context[scontext]) {
>  					newmap->map[i]->ksc[j] =3D
>  					dd->kernel_send_context[scontext];
> +					thres =3D min(sc_percent_to_threshold(
> +						    dd->kernel_send_context
> +						    [scontext], 50),
> +						    sc_mtu_to_threshold(
> +						    dd->kernel_send_context
> +						    [scontext], dd->vld[i].mtu,
> +						    dd->rcd[0]->rcvhdrqentsize)
> +						    );
> +					sc_set_cr_threshold(
> +						dd->
> +						kernel_send_context[scontext],

You took checkpatch warnings output to the extreme.

> +						thres);
> +				}
>  				if (++scontext >=3D first_scontext +
>  						  vl_scontexts[i])
>  					/* wrap back to first send context */
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--l3ej7W/Jb2pB3qL2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXRapNAAoJEORje4g2clin31wP/2M7jYiEJCjoYrxHDavxn/A+
raOJxbwu7TNHQHB9JkZ1jVnsVzvAH/GHxc+cFX2TxVPkd6c3uA3O1j7YxH8IiQj5
fhRqBvmpcc9WyLTACTZZfUZRawCOus05lHqf5pmdJUG1Wx5O3mn/QvRz3hQnBci9
5XKjkHUIN3ZJ7e2BL8ODK38X26DaVGmox73LenE5YUfZ9Jik0u5ze8UB5LYWlzie
na1qOIRLdGiv5KTWrBUAEApUFgsnAQLsaKae0bfhFq5Av2lu9dTu3A6vlGp3SugQ
32B1+WWWKAUHWc1oyEHZVSsIqWuVRMN0wFhBFtr8diSlWtm1V/32DDYAvb4nBELd
vtpJfKmYSV6yfwlTIDXoJxOdMpinsQCOt9fOaiUNBYht1p2JRekJH/75c2X7+Ngq
FOQIu5Eha69Csx1UxV2rFDTSF2/G0IAMf9sV/DdN8yE+pDbP5pgkfzQoazPmEIRO
QFRBRW5E3DB4VsRmokyLWfD9OeJe3SW3r7v5gkYbXx0V5caYeHeURISw5d9c0Zep
GcR7Jb2Yb06wSGBsnQRATKJfw5PsW8fXPgC9wytsRBeRruGm4NNey71vNaGmpaSp
5CvRxZBa83wPY6TrJLhPW1c65XCIJNwAzx49ZBk21QSqs3ovtZoz8iAJ7iq+yexl
1JvYgyzBFQz/VZZLPrSf
=xgmp
-----END PGP SIGNATURE-----

--l3ej7W/Jb2pB3qL2--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
