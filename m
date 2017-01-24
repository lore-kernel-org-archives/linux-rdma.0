From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/ipoib: function interface change
Date: Tue, 24 Jan 2017 16:26:38 -0500
Message-ID: <1485293198.43764.78.camel@redhat.com>
References: <1484206741-15218-1-git-send-email-yanjun.zhu@oracle.com>
         <20170112090143.GF20392@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-MMv5u5gCrrsdn9TH1JWX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170112090143.GF20392-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shan.hai-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-MMv5u5gCrrsdn9TH1JWX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2017-01-12 at 11:01 +0200, Leon Romanovsky wrote:
> On Thu, Jan 12, 2017 at 02:39:01AM -0500, Zhu Yanjun wrote:
> >=20
> > The ipoib_ib_dev_down/ipoib_ib_dev_stop return zero unconditionally
> > and the callers never check the returned values,
> > change the return type to void and remove the redundant return
> > values.
> >=20
> > Reviewed-by: Shan Hai <shan.hai-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > ---
> > =C2=A0drivers/infiniband/ulp/ipoib/ipoib.h=C2=A0=C2=A0=C2=A0=C2=A0| 4 +=
+--
> > =C2=A0drivers/infiniband/ulp/ipoib/ipoib_ib.c | 8 ++------
> > =C2=A02 files changed, 4 insertions(+), 8 deletions(-)
> >=20
>=20
> Thanks,
> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-MMv5u5gCrrsdn9TH1JWX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYh8aOAAoJELgmozMOVy/dK2cP/1yr13WFrmSidUKdTVYgKZ/T
ptCmqnIeoe69Q5NEjicJl5k/au1q8OgV9Vz0fZhJDWx4qWu3nwj8Y5JP6XWTX1qf
u2T1JQ6+yTJi3PdsgndK8d0Vft8KNwiQ69X9KJ2DjhxtoDSHw471prLvAyQ2h50t
0AaM9cq19IExix5xE0JdGEWM3IA0E4JjLhZg2my1dqyacxGHqiQSIVdApd8tTpoy
2hUjF9XhHP62OL3LL968DNDi395tCDaNG9Aex9wRZItZx/fqohL7OvCs44uMwF0n
U6c8mQBlkAB8zT1ZekX9rEQ8Zke7wE5IEJ9hU4mxGYIWTTgGklVsBDfn8GL48YUd
Dqarf4Ob8VWuDr4jVAZGqjZS7ZH+mVhgrvFP/e/FDvNeiQM02Yh3Q8SJhr4OMG5C
hf4kqTJSKOUOwSx6+wSS7HDOdun476UVFTfHPFV5Pc6ZWYP5RjspL76ktD2tNDtv
LlptUPv7oK4H/NIYF3SsY6iax1tsQkZsZIG/AfNBx8d16LHmc18evpDgz5otiBKb
Ve0QH02+LoyzRJKBQqgISWmT2zqhr+Dodp9ufEZtbNkt0bkKCQW8LGh4eJpSqJE2
R8gHc3Bzi74zV5mt1H5lvajBKKUheB9r39Enk8vUMsn+nl87IiwNl50HPVbyDkQp
syS0VGLKX4Fz+7eAa52z
=DzMa
-----END PGP SIGNATURE-----

--=-MMv5u5gCrrsdn9TH1JWX--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
