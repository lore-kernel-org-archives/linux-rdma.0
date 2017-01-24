From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/2] Fixes for vmw_pvrdma
Date: Tue, 24 Jan 2017 14:16:51 -0500
Message-ID: <1485285411.43764.40.camel@redhat.com>
References: <cover.1484859556.git.aditr@vmware.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-cYXY+j723Nsrq0bONUPp"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1484859556.git.aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-cYXY+j723Nsrq0bONUPp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2017-01-19 at 13:20 -0800, Adit Ranadive wrote:
> Hi Doug,
>=20
> Here are the fixes for vmw_pvrdma for this round of rc. These apply
> cleanly to your k.o/for-4.10-rc branch.
>=20
> Thanks,
> Adit
>=20
> Adit Ranadive (2):
> =C2=A0 IB/vmw_pvrdma: Don't leak info from alloc_ucontext
> =C2=A0 IB/vmw_pvrdma: Fix incorrect cleanup on pvrdma_pci_probe error pat=
h
>=20
> =C2=A0drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c=C2=A0=C2=A0| 4 +---
> =C2=A0drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c | 2 +-
> =C2=A02 files changed, 2 insertions(+), 4 deletions(-)

Thanks, series applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-cYXY+j723Nsrq0bONUPp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYh6gjAAoJELgmozMOVy/d01wP/3FsrpBATBhiK9WnbV0LTc9W
fl/d0DYEC5F4M1nI3U5FAcKO3oMQd1F7KcCrvKLxuCpT7YIULcvYAPy5tnf9Mitp
a1w8MNI0DxW4E4D0Dmj4kDSHiGWAclBLf+aAegQT9WNOgjJW2CDv1PSxTDcD1Xrd
c0Ne3SZe+JqrlvQcu/VERizflAtcG1zRY8FZrq00bFYMFAaPSBDsPL1QXWp/oPnj
mjPhPCbMA0FAi1nuqgw3jz3GnG7c0mNhHSZXn8t88by4VwVq78eTpSCZjFM8i9YD
tudwGk6Wnfs+ybLTrLG3QUopHn7g0kFm7WZmuApfPTpbraIzXuD5A7mSbd9qzSqv
GjhxJbk9dzEFgnw84QmAedNRVIiVmGBOgzm8AjwMkTNQ4cLPwg9AlYt4r56RTfn8
3bhhHuEhjl9/MPtxbBN7FSCU7ZY7kwBL+ENHzR9kUruPwJdb0qSOjKWMEfpyxUD7
Z1GrhOxwDEONTpTG9RA5mgOIkfB2kiSWVU6TuJROvVn2pb7sIUsynrLi32kkhgHA
G8ciTXSyMLvWPEYW7XIJzMMx4+3uATZRcFXOk0Qes2PbooBh+sFGoAkzMQodP3hn
RYkG81VrkzJjMY7TfYbxBDJXn/Qxu4wtnDC+iiuGSSaZb0blUk4sqVuxHsGBV3kL
/WIo5ZFbv6546X0yMY/H
=2dUZ
-----END PGP SIGNATURE-----

--=-cYXY+j723Nsrq0bONUPp--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
