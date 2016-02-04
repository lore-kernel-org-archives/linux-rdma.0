From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH][V2] IB/sysfs: remove unused va_list args
Date: Thu, 4 Feb 2016 07:12:43 -0500
Message-ID: <56B3403B.2020708@redhat.com>
References: <1453747086-31000-1-git-send-email-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="OfEPKBNa4Pdc123wNR1iwo653O5numivA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453747086-31000-1-git-send-email-colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Colin King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OfEPKBNa4Pdc123wNR1iwo653O5numivA
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 01/25/2016 01:38 PM, Colin King wrote:
> From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
>=20
> _show_port_gid_attr performs a va_end on some unused va_list args.
> Clean this up by removing the args completely.
>=20
> Fixes: 470be516a226e8 ("IB/core: Add gid attributes to sysfs")
> Signed-off-by: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> ---
>  drivers/infiniband/core/sysfs.c | 2 --
>  1 file changed, 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/=
sysfs.c
> index 3de9351..ec46386 100644
> --- a/drivers/infiniband/core/sysfs.c
> +++ b/drivers/infiniband/core/sysfs.c
> @@ -336,7 +336,6 @@ static ssize_t _show_port_gid_attr(struct ib_port *=
p,
>  	union ib_gid gid;
>  	struct ib_gid_attr gid_attr =3D {};
>  	ssize_t ret;
> -	va_list args;
> =20
>  	ret =3D ib_query_gid(p->ibdev, p->port_num, tab_attr->index, &gid,
>  			   &gid_attr);
> @@ -348,7 +347,6 @@ static ssize_t _show_port_gid_attr(struct ib_port *=
p,
>  err:
>  	if (gid_attr.ndev)
>  		dev_put(gid_attr.ndev);
> -	va_end(args);
>  	return ret;
>  }
> =20
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--OfEPKBNa4Pdc123wNR1iwo653O5numivA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWs0A7AAoJELgmozMOVy/dh+MQAIHQfcMo+LQcYvGEywQeQ/2h
3X/95XhUnXY7cQkvYLPwoTFuehcmUQD0V+ITu/NW90rsUVEWTmmFmW/d0sPXGVv2
z0x7Hb61qAT0H90QCAHH8XlS25yoLhakBxR84U54EAQ/wt4MuribehlXk6cw6+MM
vtn4+BI4O1YOjDQ395ZUFxFwCCuyF3YP8yBurKtuvh19TtgxMbaApAc4Qg4KJJbX
UhBU+nUK7QDQrjTuZEFaYtEv7nLOkWxjoSj7Dx6vV4jw8AlBAsNa5XZBTmHSmrKh
wiDuuVAckakC91OqLvUdM8RZNzY7HzqsXRyDcSZM6Xu+MoYCCmmrJ0egx2GrFm2f
9yFThGiG5C4hgTJYpqQUaEcleJiiiILaVHuSMXLRSzQop5tx2kfwNM5He0eQIuI/
zHfXIBRIqFt7lyv9KFHKOE/K9p+dE/0nkFBE2n+aVW+Fruf6oYHqFXvLpHBEw99N
sui3BIabfKu8QSS3BcrDj5GQpXoG6BWLr0UCTa2gch50tgdRePVBSa5DWuf4lCCo
1Oa296eZJbMpxe0aHiEIhKZgei6DXMq6ZWfXJlf22YctLuAXEiU8jESp9ImkeJ20
DrvilnPJZLnEhA/AxkVL+QU5jh19M1P/LWSJ/BDg79WQz8omU3Ktq4yccxn9EREb
1xdOtkObfwv+gaG846TU
=peGO
-----END PGP SIGNATURE-----

--OfEPKBNa4Pdc123wNR1iwo653O5numivA--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
