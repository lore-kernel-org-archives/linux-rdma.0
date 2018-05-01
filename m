From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/cxgb4: use skb_put_zero()/__skb_put_zero
Date: Tue, 01 May 2018 11:27:57 -0400
Message-ID: <1525188477.11756.101.camel@redhat.com>
References: <20180428073106.14696-1-yuehaibing@huawei.com>
         <004f01d3dee7$8b5c4cd0$a214e670$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-sCUh6x3wCQHXGA5RY3VO"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <004f01d3dee7$8b5c4cd0$a214e670$@opengridcomputing.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>, 'YueHaibing' <yuehaibing@huawei.com>, swise@chelsio.com, jgg@ziepe.ca, monis@mellanox.com
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-sCUh6x3wCQHXGA5RY3VO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2018-04-28 at 06:53 -0500, Steve Wise wrote:
> > -----Original Message-----
> > From: YueHaibing <yuehaibing@huawei.com>
> > Sent: Saturday, April 28, 2018 2:31 AM
> > To: swise@chelsio.com; dledford@redhat.com; jgg@ziepe.ca;
> > monis@mellanox.com
> > Cc: linux-rdma@vger.kernel.org; linux-kernel@vger.kernel.org; YueHaibin=
g
> > <yuehaibing@huawei.com>
> > Subject: [PATCH] IB/cxgb4: use skb_put_zero()/__skb_put_zero
> >=20
> > Use the recently introduced helper to replace the pattern of
> > skb_put_zero/__skb_put() && memset().
> >=20
> > Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>=20
> Looks ok.
>=20
> Reviewed-by: Steve Wise <swise@opengridcomputing.com>
>=20
>=20

Applied to for-next, thanks.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-sCUh6x3wCQHXGA5RY3VO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlroh30ACgkQuCajMw5X
L93UzQ//Wucf429vIvYdtVH9nz7qpba/2MtVmKEPDOZzMrpUr1bJzj45aBM4OZ72
67Re4rbcLE0CqEmvPOBsDelydHiTq+2TP2UGoKr/8ijMlUV2YjXXP0LRvOIs5KYR
JN5TS5BBUU2cZmixY60I6uuKPSEvF/EJiuSRaUXmIIp4zJim2KRCKv3SJYW6xbnw
QByv5MAWDMQoCdb9BV8W6ErX5Bd6CAS7tOafKIDOjBkvbz2wCTryAR5XuyuZ9lnT
DPUYPQxU6tsfimr1KlmZjLl25iTSjXqiiYUzSRuiz4FRM6hieeYScAHhFJPVSzAx
6ayBA3nBDsKzwWK3jqjZulerx1i1W1vM3MYqsB+Zju0OejxqzUKVRqOgIzwlvdH3
7BYwIBQ41HjeZdXJSP6ioy8KponwdcpnVkceSjyDbWcJc3wHuCqtXTVsVwiIC+wO
SHysgZXs3R6v5BWghhgVJThiplRAIVSwqp+sZAnAOHZhHSvNf2KQzH6pcuyrg7uS
g/FbiPQ5iVDHk0e6Xxfm6EBpAL+/VUPGn/r2d4cLxkBUQYVJ3EtTAF32TrQHfedI
CJdp+cyPlf8jvV/wxfg2+El+3ciqrCOIsE7ovSzxsAaSHR4nrYkHYPpxkkzO9OOw
aMgdBsnl3DnZkRp3kM2q1kP/j77pbHopMZ8jPclPewC1ciMfQc8=
=98m+
-----END PGP SIGNATURE-----

--=-sCUh6x3wCQHXGA5RY3VO--
