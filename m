From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDMA/iser: Limit sgs to the device fastreg depth
Date: Tue, 28 Jul 2015 10:47:27 -0400
Message-ID: <55B795FF.3060108@redhat.com>
References: <20150728141152.13342.45907.stgit@build2.ogc.int>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="BsqcCLcspHaE37m2atIcHCMV9Hg5Qk4qo"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150728141152.13342.45907.stgit-PBeJgSbIpn97NCTnQtmixQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BsqcCLcspHaE37m2atIcHCMV9Hg5Qk4qo
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 07/28/2015 10:13 AM, Steve Wise wrote:
> Currently the sg tablesize, which dictates fast register page list
> depth to use, does not take into account the limits of the rdma device.=

> So adjust it once we discover the device fastreg max depth limit.  Also=

> adjust the max_sectors based on the resulting sg tablesize.
>=20
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> ---
> Note: This patch was originally part of
> http://www.spinics.net/lists/linux-rdma/msg27436.html. The isert work
> will be a separate series, so I'm submitting this one to go ahead and
> get it merged.
> ---
>=20
>=20
>  drivers/infiniband/ulp/iser/iscsi_iser.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infinib=
and/ulp/iser/iscsi_iser.c
> index 6a594aa..de8730d 100644
> --- a/drivers/infiniband/ulp/iser/iscsi_iser.c
> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
> @@ -640,6 +640,15 @@ iscsi_iser_session_create(struct iscsi_endpoint *e=
p,
>  						   SHOST_DIX_GUARD_CRC);
>  		}
> =20
> +		/*
> +		 * Limit the sg_tablesize and max_sectors based on the device
> +		 * max fastreg page list length.
> +		 */
> +		shost->sg_tablesize =3D min_t(unsigned short, shost->sg_tablesize,
> +			ib_conn->device->dev_attr.max_fast_reg_page_list_len);
> +		shost->max_sectors =3D min_t(unsigned int,
> +			1024, (shost->sg_tablesize * PAGE_SIZE) >> 9);
> +
>  		if (iscsi_host_add(shost,
>  				   ib_conn->device->ib_device->dma_device)) {
>  			mutex_unlock(&iser_conn->state_mutex);
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

Thanks Steve, I'm picking this one up today.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--BsqcCLcspHaE37m2atIcHCMV9Hg5Qk4qo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVt5X/AAoJELgmozMOVy/djSQQAMFS9Gz8LEtIkxywOZdJcbNi
tIxezmVfh/KMV/S0zsAxQW7q+jXQvHYRCBQt89M2ZjD79EG28NVLbz5pXpNu93mx
uPOBTYseyWhRBlj6fwA8bPYjOAIJqFnw17afhevREUBGcQy7ibf/34s+l88dKlvg
+TeZshrlADSrUl8vN1KcKlf7+5fzeST/SJuDnwB6QUmAyYm/hNk2FMeKVNxMFosz
04+PYPH/fN9FALEM+2SSUFWobcnFWPgVyH+rijRrQYKqFKcsyaFYLVR2Sp6R7hL1
Zb22X6ivbeCY7DJr7u/B/n7gD9GY6C91OmzuFnUYHf4s0Rt4+MlZs628miwuP27z
47hjnPAAbizFkvIMG6ZY/rpkyXzHfhuiNOUZq5YMtqG9p6YXXxcD1G11aqmkmX4T
8WXsimNRVCACxAB8jHnLXmxhc4pOT4Z3eW0iT6nl90BpL8H+L2SMEg3vVIULugcd
AqMrOzH26DFlSeHgNML3lnIqRgwBRbQXyY8M2wt335yRG9zeEeDAHza3fd/hUenK
AHhGLLDArBFRHT4KE11OrdC1EGHtAStZ4sUN5aXwlER8BHUkfQ7IxbXQI5p+rVPg
G4LPNEwcY+797/pEUkxD+EewYxW5CDak8lgi7hplaKwAR+061hQhGu+V67eqAEj7
GXfAroSRxAPw7Limvu3D
=OeDC
-----END PGP SIGNATURE-----

--BsqcCLcspHaE37m2atIcHCMV9Hg5Qk4qo--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
