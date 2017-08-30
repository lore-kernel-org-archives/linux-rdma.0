From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next v1 0/2] RDMA/vmw_pvrdma: Patches for 4.14
Date: Wed, 30 Aug 2017 10:24:21 -0400
Message-ID: <46592fc7-5ed6-294f-0f2f-69c326284b2c@redhat.com>
References: <cover.1504045411.git.aditr@vmware.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Mr1J9OLAbOgSTNSarbmqCQSI4PGF1uRLt"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1504045411.git.aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Mr1J9OLAbOgSTNSarbmqCQSI4PGF1uRLt
Content-Type: multipart/mixed; boundary="WweKEIjFVkUhmGed9aqR8Bcbf1wTj925k";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
Message-ID: <46592fc7-5ed6-294f-0f2f-69c326284b2c-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next v1 0/2] RDMA/vmw_pvrdma: Patches for 4.14
References: <cover.1504045411.git.aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1504045411.git.aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>

--WweKEIjFVkUhmGed9aqR8Bcbf1wTj925k
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/29/2017 6:51 PM, Adit Ranadive wrote:
> Hi Doug,
>=20
> Here are a couple more patches for the VMware PVRDMA driver for 4.14.
> These are based on your for-next branch.
>=20
> Thanks,
> Adit
> ---
> Changes v0 -> v1:
>  - Dropped the PVRDMA network type enums and the conversion function.
> ---
> Adit Ranadive (1):
>   RDMA/vmw_pvrdma: Fix a signedness
>=20
> Aditya Sarwade (1):
>   RDMA/vmw_pvrdma: Report network header type in WC
>=20
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c | 3 ++-
>  include/uapi/rdma/vmw_pvrdma-abi.h           | 6 ++++--
>  2 files changed, 6 insertions(+), 3 deletions(-)
>=20

Thanks, will apply these today.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--WweKEIjFVkUhmGed9aqR8Bcbf1wTj925k--

--Mr1J9OLAbOgSTNSarbmqCQSI4PGF1uRLt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZpsqVAAoJELgmozMOVy/drV8P/1pbXKCumL+0FvP3NmnWP16T
dCh1/mtD/NfvBUyX2/14XwYD5l4az60T+ojcXhP0wqpZ1X+Ip6gJS80IlIKaCmcf
mXdDv0L3A576BL2YYRMDN9hx8JO43iSCwHy7E0ytfs+x8mYSaTuYzby0XQSMoifn
JuOirXKZxrTNuWAOmXrDjy42jNLZxXaugJlrjy5txGZnbI/wo4R2hqZd9dPsV+73
Lq3X9qh9ixec5Wz9v/l1KlNKjv2qr8Z66tS+WXWx3g9gbCU7vQqnlSbOL/XkNpd9
VrVkmmHVjd9IhVtDUSiCFqf3Bhal+Je/R6gH3Er5Hy0fXKGlnQLV0fq7MXxKOc1q
dtyzRxBaCzB1z/ncm8lQ7xmclHewkcUL2lHXLqHtCWvxL5bKjgHgJnElQONeVhsb
FyxfLAhQF50RcaV55YU0CsJLUgVCNfwn6yRQG0pTfJC7jBaVaiEZoeRSZOGkJcuP
VoEHtSd/DgikTpQC5S2r1sbdsGfnFzJ1B32CTnWfkOdO7lBbGVfXAxDDcSKJ/x+h
muM+Ai0g/wyAIlN+GpmEZLRmVmqaiNeiFzJo7FaH0P5e10+LXnDu/lP78V6sxx68
8wir1E9nFhJsp4Gzm1PHTGBBiIMQP/6A6ki8Hukl+VTn7k6mbv+XZ/Hjk1f4a1UU
edt1h/26Faz+yWjqIUKf
=DR43
-----END PGP SIGNATURE-----

--Mr1J9OLAbOgSTNSarbmqCQSI4PGF1uRLt--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
