From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Fix CONFIG_INFINIBAND_IPOIB_CM
Date: Thu, 23 Jul 2015 17:33:25 -0400
Message-ID: <55B15DA5.1000704@redhat.com>
References: <20150722203003.GA9613@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Fha1SKHwJuawUFnViK6SK0ohNbEmkdisx"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150722203003.GA9613-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Fha1SKHwJuawUFnViK6SK0ohNbEmkdisx
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/22/2015 04:30 PM, Jason Gunthorpe wrote:
> If the above is turned off then ipoib_cm_dev_init unconditionally
> returns ENOSYS, and the newly added error handling in
> 0b3957 prevents ipoib from coming up at all:
>=20
> kernel: mlx4_0: ipoib_transport_dev_init failed
> kernel: mlx4_0: failed to initialize port 1 (ret =3D -12)
>=20
> Fixes: 0b39578bcde4 (IB/ipoib: Use dedicated workqueues per interface)
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_verbs.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c b/drivers/infin=
iband/ulp/ipoib/ipoib_verbs.c
> index 9e6ee82a8fd7..851c8219d501 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
> @@ -177,7 +177,8 @@ int ipoib_transport_dev_init(struct net_device *dev=
, struct ib_device *ca)
>  		else
>  			size +=3D ipoib_recvq_size * ipoib_max_conn_qp;
>  	} else
> -		goto out_free_wq;
> +		if (ret !=3D -ENOSYS)
> +			goto out_free_wq;
> =20
>  	cq_attr.cqe =3D size;
>  	priv->recv_cq =3D ib_create_cq(priv->ca, ipoib_ib_completion, NULL,
>=20

Thanks, applied for 4.2-rc.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--Fha1SKHwJuawUFnViK6SK0ohNbEmkdisx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVsV2lAAoJELgmozMOVy/d5E0P/jgfeypKzCnVGLztQfZCbRX8
n7kVqLzzZFkzwiyxFZwx2wrRv+1Ik8VWU66RDgbU7y/3hacPVyEbAg4vC9j6xGKG
gSHBc9JO5DOtJ5ENTpSpJa4ky2j+fy6vjPaG6MgEL1tamk7G0TzWvmdqvi4nt/lh
nU+04hdrQePBEySW/Eyffo7pEKUwEyZz5puXBc5mJNjKWYLf5xGhgHjfuogRs7tm
ePqQNJ0zlQP0nJfpJbiF/VjBDW6VUKTDLijnKh3FxjwrNEISVIEt9y2qDniJ1pv2
OofdoznDWSkxJ4VZhN6+bP7PrUnlmOrM4PKkGckEboxNLGXvZiwLBw7O1WWW/o8r
Q2iYwCl96Wof3z43vmoELEKZ2K5gmCHEcQCYBuBTPlZdePD8eyW6olvrO7/2Ml4s
HRrQjShiI0KA4n3y+tHDXgX/sh0EwTS0vkgjRGf8vBECADbtKU8HHODJaBWR9OqP
8zngiGcG98WPdm2j02XP6pVatznOauxxaJ4hPwYR0oorzHOaTxd7ujkRdvc8ojLK
P/8jWne+u9h0YALlykbrm/qUhgaZM6LRzVMO/eVF6pkN1YGOS0U4RQGQd+ui5jiA
SY2vq24b4vIlIvx8aPcEWlRfZPBrCbNR6Esum7zGTddTK4jpnUNI0W9vLQr1wfHx
OeRr6uGtVKWFuzx84m7R
=ZRub
-----END PGP SIGNATURE-----

--Fha1SKHwJuawUFnViK6SK0ohNbEmkdisx--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
