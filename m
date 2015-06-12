From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1 linux-next] IB/mthca: use swap() in mthca_make_profile()
Date: Fri, 12 Jun 2015 11:24:17 -0400
Message-ID: <557AF9A1.80003@redhat.com>
References: <1433953911-23735-1-git-send-email-fabf@skynet.be>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="kc3bdwHnQwvq4BjQ6mLbw1vt9XeXiGbrO"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433953911-23735-1-git-send-email-fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Julia Lawall <Julia.Lawall-L2FTfq7BK8M@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kc3bdwHnQwvq4BjQ6mLbw1vt9XeXiGbrO
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 06/10/2015 12:31 PM, Fabian Frederick wrote:
> Use kernel.h macro definition.
>=20
> Thanks to Julia Lawall for Coccinelle scripting support.
>=20
> Signed-off-by: Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>

Thanks, applied.

> ---
>  drivers/infiniband/hw/mthca/mthca_profile.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mthca/mthca_profile.c b/drivers/infi=
niband/hw/mthca/mthca_profile.c
> index 8edb28a..15d0644 100644
> --- a/drivers/infiniband/hw/mthca/mthca_profile.c
> +++ b/drivers/infiniband/hw/mthca/mthca_profile.c
> @@ -77,7 +77,6 @@ s64 mthca_make_profile(struct mthca_dev *dev,
>  	u64 mem_base, mem_avail;
>  	s64 total_size =3D 0;
>  	struct mthca_resource *profile;
> -	struct mthca_resource tmp;
>  	int i, j;
> =20
>  	profile =3D kzalloc(MTHCA_RES_NUM * sizeof *profile, GFP_KERNEL);
> @@ -136,11 +135,8 @@ s64 mthca_make_profile(struct mthca_dev *dev,
>  	 */
>  	for (i =3D MTHCA_RES_NUM; i > 0; --i)
>  		for (j =3D 1; j < i; ++j) {
> -			if (profile[j].size > profile[j - 1].size) {
> -				tmp            =3D profile[j];
> -				profile[j]     =3D profile[j - 1];
> -				profile[j - 1] =3D tmp;
> -			}
> +			if (profile[j].size > profile[j - 1].size)
> +				swap(profile[j], profile[j - 1]);
>  		}
> =20
>  	for (i =3D 0; i < MTHCA_RES_NUM; ++i) {
>=20



--kc3bdwHnQwvq4BjQ6mLbw1vt9XeXiGbrO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVevmhAAoJELgmozMOVy/dvkIP/icwHmRVJEOprv3UPRwu6C7b
xIWvziHSuo/XhTqtBosnndNtNVWKLvHcJWTJlKagXtPmxTFWc8npjXnggCi55NII
Fqe117H0akd8qrIdZLYLuT4cozDy+Yfgv0KiVJ5zkcAobHTDzrHBkPu6IAWNbh0N
XUF786AP38qND1IaDkn77UDTQBUZm8BjeyeICv/igj8THeqmATBAWGs0XhlyKtTL
UY0tKG6a7RzWm0Q9yG2sjKy8wSR9gBmigRLlqbyFtBtIWbB4aAJJeh/qJcFTlM/4
QmnOetHO3n0/Pxcml2yOrJBQcpfe/RzG249Cnojzt89EHgg+JdTnyMeDSttPfjIA
pPpjPdpuCmpKCvsY00q1VLB+K0H37iqPAjzmD+OZifbWWsOedpJgQPPbOcaBiT1w
opAcUqaQHhpz1dQpsqDd62/mVzJfZ73jz+Ee+D8h7PLJ256hJkj2b+XjgBEUsyZg
65vx2YQixJXNJ4cvXz5WTTQjA55dpe1PGMKsKzLuiJPqUvlS8Z2puDlJZz/QiyL1
knapjpI6ZPwAvLIl8gK5nIQHP9kAo/aJhPpjsbVJbwG6Ad0Bj+s73KrsfU39isPc
woRygBFq4zI54b4zsvI2JFAMc8y+yxWfxUbMhjQk2ACrt0AVXd2FRkt7UF3B/xET
oa8HJT8AC+VTFB2HTNgg
=Dxla
-----END PGP SIGNATURE-----

--kc3bdwHnQwvq4BjQ6mLbw1vt9XeXiGbrO--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
