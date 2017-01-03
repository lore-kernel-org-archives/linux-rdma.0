From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/1] ipoib: remove unnecessary returned value check
Date: Tue, 3 Jan 2017 09:29:30 +0200
Message-ID: <20170103072930.GG12077@mtr-leonro.local>
References: <1482151756-8802-1-git-send-email-yanjun.zhu@oracle.com>
 <586B0DB8.3060301@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xJK8B5Wah2CMJs8h"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <586B0DB8.3060301-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yanjun Zhu <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, emilbart-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org, dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--xJK8B5Wah2CMJs8h
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 03, 2017 at 10:34:32AM +0800, Yanjun Zhu wrote:
> Any comment ?
>
>
> On 2016/12/19 20:49, Zhu Yanjun wrote:
> > In the function ipoib_set_dev_features, the returned value is always 0.
> > As such, it is not necessary to check the returned value.
> > This is not a bug. When I read the source code, I think it is not
> > necessary to check it.
> >
> > Signed-off-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > ---
> >   drivers/infiniband/ulp/ipoib/ipoib.h      | 2 +-
> >   drivers/infiniband/ulp/ipoib/ipoib_main.c | 8 ++------
> >   2 files changed, 3 insertions(+), 7 deletions(-)


=E2=9E=9C  linux-rdma git:(rdma-next) grep -rI ipoib_set_dev_features drive=
rs/infiniband/ulp/ipoib/*
drivers/infiniband/ulp/ipoib/ipoib.h:int ipoib_set_dev_features(struct ipoi=
b_dev_priv *priv, struct ib_device *hca);
drivers/infiniband/ulp/ipoib/ipoib_main.c:int ipoib_set_dev_features(struct=
 ipoib_dev_priv *priv, struct ib_device *hca)
drivers/infiniband/ulp/ipoib/ipoib_main.c:	result =3D ipoib_set_dev_feature=
s(priv, hca);
drivers/infiniband/ulp/ipoib/ipoib_vlan.c:	result =3D ipoib_set_dev_feature=
s(priv, ppriv->ca);

It lloks like, you frogot to update ipib_vlan.c

--xJK8B5Wah2CMJs8h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhrUtoACgkQ5GN7iDZy
WKezFA/7BJh2tB7FwuwCe2o+c151oyvb3Cf9/Ri31lwVhKhEUosJZLwxEPsLx8qV
fhzoDJc1GWscp9bs/GA+M9msuFCD8f5T55NOb5uVU/34/fj1lK2uAlr857Z2KyQ5
Lxbaf+d0Bu/uW1fJTO2DZYWze7tiAdzhn7Fs20fboUKZKnejM7OROW2oDh7bbHU8
sf5vdFfSUuKkXUlHMgjXrCL+zypVCE8KwLKlFhVhRo//EHfZpKCIGrtjCe+Pyo+7
AchpLwmApirk9REfRgC5bIWkSS5lZl5b4cqqrwCEBB8oTx2H4OJ0tpmgEeWhxFgh
+N4jJRUW3qEMOqD5pQ6ozIuhkFEy20x6PWPW8A0TSJIJhBvd0E41jKYia4t9x7RF
kW0uX1IL9fNo5OdPfhh/gtEcHgqQxODMNmtCENBmveF1tujqYNNqZuKnWXbH+Zp6
uriC0kSkWTZCs3P2IQApJRttbAZb6RkO0e5Vv55WHrDCJ0wsP0VU1v/pcOJcvhOm
/jtFZIuEP8AcbN6qi+6IHCe0DoCKmTxMe0aRUt0TFQOt7iqwNfx83iRGNslNpAHI
34GNDH9NtZDTXIoMryMPN8pyWbusP4yplVroUZr0Jmykbg6mntJgpEHxu/kR1MnV
tdbRW9EcUM7wpwnoJNWcDHfl528eydENi20ZoFrZLLBFBaHnhh0=
=EUHR
-----END PGP SIGNATURE-----

--xJK8B5Wah2CMJs8h--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
