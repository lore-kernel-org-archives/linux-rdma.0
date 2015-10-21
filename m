From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] usnic: correctly check failed allocation
Date: Wed, 21 Oct 2015 16:43:39 -0400
Message-ID: <5627F8FB.5050102@redhat.com>
References: <1444943715-31250-1-git-send-email-wuninsu@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="AlioaLe9sFPlj5t8gHGjeAVR0rfGXc3xp"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444943715-31250-1-git-send-email-wuninsu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Insu Yun <wuninsu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: taesoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org, yeongjin.jang-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org, insu-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--AlioaLe9sFPlj5t8gHGjeAVR0rfGXc3xp
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/15/2015 05:15 PM, Insu Yun wrote:
> Since ib_alloc_device returns allocated memory address, not error,
> it should be checked as IS_NULL, not IS_ERR_OR_NULL.
>=20
> Signed-off-by: Insu Yun <wuninsu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Thanks, applied.

> ---
>  drivers/infiniband/hw/usnic/usnic_ib_main.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infi=
niband/hw/usnic/usnic_ib_main.c
> index 34c49b8..cbc0514 100644
> --- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
> +++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
> @@ -328,16 +328,15 @@ static void *usnic_ib_device_add(struct pci_dev *=
dev)
>  	netdev =3D pci_get_drvdata(dev);
> =20
>  	us_ibdev =3D (struct usnic_ib_dev *)ib_alloc_device(sizeof(*us_ibdev)=
);
> -	if (IS_ERR_OR_NULL(us_ibdev)) {
> +	if (!us_ibdev) {
>  		usnic_err("Device %s context alloc failed\n",
>  				netdev_name(pci_get_drvdata(dev)));
> -		return ERR_PTR(us_ibdev ? PTR_ERR(us_ibdev) : -EFAULT);
> +		return ERR_PTR(-EFAULT);
>  	}
> =20
>  	us_ibdev->ufdev =3D usnic_fwd_dev_alloc(dev);
> -	if (IS_ERR_OR_NULL(us_ibdev->ufdev)) {
> -		usnic_err("Failed to alloc ufdev for %s with err %ld\n",
> -				pci_name(dev), PTR_ERR(us_ibdev->ufdev));
> +	if (!us_ibdev->ufdev) {
> +		usnic_err("Failed to alloc ufdev for %s\n", pci_name(dev));
>  		goto err_dealloc;
>  	}
> =20
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--AlioaLe9sFPlj5t8gHGjeAVR0rfGXc3xp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWJ/j7AAoJELgmozMOVy/dFJMP/2BUmlzrqEeaT46jo9+90jF8
gmGJdD/W4ObBSfVplWjDqoW6ENIQxox3S621R506NeMyLp+YwpDjuc7DdjZxvvBL
vwCP6Oblq1jLc5SM0xtRbLfOu3+loSTtla48Hhfw/+xoAy8OCMIuyVWpXc4x+L9y
N64B4btOxja59uu5kQg31q8COgH0oNQfx127k4cmCt9LZU5CwoZZ6n02vUnsN+XN
MX4lIAMr36oZx5BISqPXuPg4pHdxuT+lEy/wnuuSFZ7Gfn6JRkIZgoi+HYOZ0Pxh
+hxIXtDo/4Gxzcthur9EW7zeiI1NYtYG1+AAZcPoJYFbveZPATXRoEJMdQ71JeI9
aD6K9nVTS77iXDo15P2CGdA8nwj3UifK65psnil3LJ4OgD+bIu0Gv+25OoHUKsiG
d/RZzKwAWC7b6ts7x8opo0JykILhoJDClDu5ZsAx1oij8FAqaHAhIATQmSFt0XPD
4f3T43kTxhrx+IdlG1RZW6ogjOGJsMIR3khPwVrTL26ilovM38Q/nLk7/yxMDImG
CzCAnkeAt5N5Ofes9nFwynEYwqCIAhPPDrxEDQsPAsV2dONtk8e0ZWWUF4U3gUFD
PBKvuQVZVgcDgVzzSBsGyYvYRy/LYn8sfBoBn9KxNhjaZsW36ka1pXpQ1odAivwP
lt/WclxEpFiipCFcDasX
=mVJx
-----END PGP SIGNATURE-----

--AlioaLe9sFPlj5t8gHGjeAVR0rfGXc3xp--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
