From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/hfi1: Fix a parameter of find_first_bit.
Date: Fri, 26 Aug 2016 09:35:11 -0400
Message-ID: <cf61e699-9e2d-a594-64e6-43ea33b239d9@redhat.com>
References: <1472186949-9025-1-git-send-email-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fnBJqBvUmwftHaOPL5WTj8SdMj05qLgwe"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472186949-9025-1-git-send-email-christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fnBJqBvUmwftHaOPL5WTj8SdMj05qLgwe
Content-Type: multipart/mixed; boundary="rTnBtUMRQKIIh5h1tUfPTpXfxH5juCXUk"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>,
 mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org,
 sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <cf61e699-9e2d-a594-64e6-43ea33b239d9-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/hfi1: Fix a parameter of find_first_bit.
References: <1472186949-9025-1-git-send-email-christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>
In-Reply-To: <1472186949-9025-1-git-send-email-christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>

--rTnBtUMRQKIIh5h1tUfPTpXfxH5juCXUk
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 8/26/2016 12:49 AM, Christophe JAILLET wrote:
> The 2nd parameter of 'find_first_bit' is the number of bits to search.
> In this case, we are passing 'sizeof(unsigned long)' which is likely to=

> be 4 or 8.

If the size can be 4 or 8, then using 64 universally is not correct.
Why not use sizeof() * 8 (or << 3)?

> It is likely that the number of bits of 'port_mask' was expected here. =
This
> variable is a 'u64', so use 64 instead.
>=20
> It has been spotted by the following coccinelle script:
> @@
> expression ret, x;
>=20
> @@
> *  ret =3D \(find_first_bit \| find_first_zero_bit\) (x, sizeof(...));
>=20
> Signed-off-by: Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>
> ---
> Not sure that using 64 directly is the best option.
> Maybe '8 * sizeof(port_mask)' as used in the same file for
> 'for_each_set_bit' would be better
> ---
>  drivers/infiniband/hw/hfi1/mad.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/h=
fi1/mad.c
> index 1263abe01999..2c6c138c41b2 100644
> --- a/drivers/infiniband/hw/hfi1/mad.c
> +++ b/drivers/infiniband/hw/hfi1/mad.c
> @@ -2632,8 +2632,7 @@ static int pma_get_opa_datacounters(struct opa_pm=
a_mad *pmp,
>  	 * port the request came in on.
>  	 */
>  	port_mask =3D be64_to_cpu(req->port_select_mask[3]);
> -	port_num =3D find_first_bit((unsigned long *)&port_mask,
> -				  sizeof(port_mask));
> +	port_num =3D find_first_bit((unsigned long *)&port_mask, 64);
> =20
>  	if ((u8)port_num !=3D port) {
>  		pmp->mad_hdr.status |=3D IB_SMP_INVALID_FIELD;
> @@ -2836,8 +2835,7 @@ static int pma_get_opa_porterrors(struct opa_pma_=
mad *pmp,
>  	 * port the request came in on.
>  	 */
>  	port_mask =3D be64_to_cpu(req->port_select_mask[3]);
> -	port_num =3D find_first_bit((unsigned long *)&port_mask,
> -				  sizeof(port_mask));
> +	port_num =3D find_first_bit((unsigned long *)&port_mask, 64);
> =20
>  	if (port_num !=3D port) {
>  		pmp->mad_hdr.status |=3D IB_SMP_INVALID_FIELD;
> @@ -3009,8 +3007,7 @@ static int pma_get_opa_errorinfo(struct opa_pma_m=
ad *pmp,
>  	 * the request came in on.
>  	 */
>  	port_mask =3D be64_to_cpu(req->port_select_mask[3]);
> -	port_num =3D find_first_bit((unsigned long *)&port_mask,
> -				  sizeof(port_mask));
> +	port_num =3D find_first_bit((unsigned long *)&port_mask, 64);
> =20
>  	if (port_num !=3D port) {
>  		pmp->mad_hdr.status |=3D IB_SMP_INVALID_FIELD;
> @@ -3246,8 +3243,7 @@ static int pma_set_opa_errorinfo(struct opa_pma_m=
ad *pmp,
>  	 * the request came in on.
>  	 */
>  	port_mask =3D be64_to_cpu(req->port_select_mask[3]);
> -	port_num =3D find_first_bit((unsigned long *)&port_mask,
> -				  sizeof(port_mask));
> +	port_num =3D find_first_bit((unsigned long *)&port_mask, 64);
> =20
>  	if (port_num !=3D port) {
>  		pmp->mad_hdr.status |=3D IB_SMP_INVALID_FIELD;
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--rTnBtUMRQKIIh5h1tUfPTpXfxH5juCXUk--

--fnBJqBvUmwftHaOPL5WTj8SdMj05qLgwe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXwEWPAAoJELgmozMOVy/dXuUP/0Ov1Px+WSZw+dY9zs/W+ej7
uNl2aMEI44+gsqeP9CbFuDZ82PXgcF/OWnoJMfHVyh5dHYDUNr8Jp7aJp5Pdz4qx
xUWPYH66t6GnTERr99x8PYwoHO9yMJ9BnYEFUA8ABZAsjk41dKhWsjXZNUOOQ863
Nyi3HeQ+lkCJLNVRV05pGNrvNiC+prCGt3toe35ZuA58PDbQqS+1Fs7JJGAUR7mE
rd8BfmAN2Ef6DZHSteFrwkOjOw/Ee08atjOTI/wPaOkbSItwEByG7INRwB3Q+Z2h
e4em55OMN6e60YmsfC7tY5e1SmxuU8zRDFw09LFEb92Z5C9dfdzroKRyT+dPNvDi
KPq0i3/yrsqHFH3Y+03fxQTWHGugjFBQrQfUcWksV/yFvzx/L5xK1iTow7tDs27N
EriXpnyw+Y15pJo5IzHl0bat6cWzm/v7GLn2APyihGQ9dUc65mSnUf9JS+vWBQ0T
Zk+fAl34tTFaxnxvDuGBBOdqHw7zj/rg3YVp7yKbuppg1YGGLwaV5ZkZo59HONBg
dNtObKRHY62w4ty6fIfZPZA2OnI/qdvxrOIRXKLnGu9hcEILxdMOAh2ysKpenVro
c05IeP5nKkZ6yXZAYNQla3YUtYmro6mtRj0LkdUhRjFo5TaZ0HWtA7j5Nn/SRdkW
OTLQR9mU3rpXL4DFPZsn
=oxoL
-----END PGP SIGNATURE-----

--fnBJqBvUmwftHaOPL5WTj8SdMj05qLgwe--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
