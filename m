From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3] IB/mad: Fix 0-day build
Date: Wed, 08 Jul 2015 19:01:13 -0400
Message-ID: <559DABB9.4070802@redhat.com>
References: <1435248289-16477-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7ej5he2jpWu9gFqQ1hDQ7OPGvNKNlLm6A"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1435248289-16477-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7ej5he2jpWu9gFqQ1hDQ7OPGvNKNlLm6A
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 06/25/2015 12:04 PM, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> The define OPA_LID_PERMISSIVE is big endian and was compared to cpu val=
ue
> opa_drslid.
>=20
> 0-day build caught this while building with the OPA (hfi1) driver which=
 was
> recently sent to the list.
>=20
> Fixes: 8e4349d13f33 (IB/mad: Add final OPA MAD processing)
>=20
> Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: John, Jubin <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> ---
> Changes from V2
> 	Really update the commit message

I made some changes to the commit message, but patch was taken as is.

>=20
>  drivers/infiniband/core/mad.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/ma=
d.c
> index a4b1466c1bf6..9c90a729db62 100644
> --- a/drivers/infiniband/core/mad.c
> +++ b/drivers/infiniband/core/mad.c
> @@ -794,7 +794,7 @@ static int handle_outgoing_dr_smp(struct ib_mad_age=
nt_private *mad_agent_priv,
>  			goto out;
>  		}
>  		opa_drslid =3D be32_to_cpu(opa_smp->route.dr.dr_slid);
> -		if (opa_drslid !=3D OPA_LID_PERMISSIVE &&
> +		if (opa_drslid !=3D be32_to_cpu(OPA_LID_PERMISSIVE) &&
>  		    opa_drslid & 0xffff0000) {
>  			ret =3D -EINVAL;
>  			dev_err(&device->dev, "OPA Invalid dr_slid 0x%x\n",
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--7ej5he2jpWu9gFqQ1hDQ7OPGvNKNlLm6A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVnau5AAoJELgmozMOVy/dggIQAIhGu9JrAKxftVYxT/jKrvsD
BUIlWSZjsXa0m2LJtI+fg3oyOf1XIpOKrpXXkehv/QlRktn/quA9Ytev7bddbTjY
hK4k+CMJSotHbySsiewStFeKB+kbuxKMWeo4Y+GjNPogj8VIbz4iwN5960IwbydN
LaYaMn8jMmWOTee0YToXah/6pECNf61hlEEot+m3Sll2w/aqLbX3Hzf+iaEYlR8A
oaTvq51tYnR6L22eRp6TuCsEFVdmZ73MsUmKteQQyDD5cqWtIlgyHc4LGg02ettb
s3zF8pPuflQL20aGFcnM2r3xucu11+75RSbl+6IgIy+m2PYqQ4N5GI7kRQEJLliZ
xRobBJAl4MRYWqYkEnXUmdoIa7cWKwjoqU1bhRKHKnBk6FytOexQ+WjB93yq4gtH
x4eYWsP56KowTz9XhZMPWkccltM8jyp7uDcAsOYU7JmP8Ntc8HmQjjtWPTGZEqIi
/RD5Z8Epuh3Ga7QR9lu/Uo3QQyFdaB8DYWIQNRe8JHqsjkykNNKjIj76IiGDUojB
V2JNb55Bys24UzykEmYu3f55S3+zGug3Q5LW8EKqasMtUu8iV3ZBlFkHazXdSVFP
XWgPoDXYUuODxdBvi4itdm2jAa1PB4mYXQSSTU9iu3kTQV9R5WZx4TGlIyI88LGn
yyXDA+8tDU8W9aYQDEAh
=0XOv
-----END PGP SIGNATURE-----

--7ej5he2jpWu9gFqQ1hDQ7OPGvNKNlLm6A--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
