From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH -next] RDMA: Remove duplicated include from ib_addr.h
Date: Thu, 13 Sep 2018 13:00:56 -0400
Message-ID: <4aff78ec912c8e898c9b1bf1503689a7790f887e.camel@redhat.com>
References: <20180913134752.22780-1-yuehaibing@huawei.com>
         <20180913155826.GR5257@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-W93PfBi418HMMnwsnXHV"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180913155826.GR5257@mtr-leonro.mtl.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, YueHaibing <yuehaibing@huawei.com>
Cc: jgg@ziepe.ca, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-W93PfBi418HMMnwsnXHV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2018-09-13 at 18:58 +0300, Leon Romanovsky wrote:
> On Thu, Sep 13, 2018 at 09:47:52PM +0800, YueHaibing wrote:
> > Remove duplicated include.
> >=20
> > Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> > ---
> >  include/rdma/ib_addr.h | 1 -
> >  1 file changed, 1 deletion(-)
> >=20
>=20
> Thanks,
> Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

Thanks, applied to for-next.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-W93PfBi418HMMnwsnXHV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlual8gACgkQuCajMw5X
L91XMg//W1ErPkJI5Yk8X7tjpHXRraqcCZ0AxDfj5ldd4q9840jOJPp8ZgSXEPOC
eQ+veWSYUz7+keNwqTwRFM56DRmAI6qzC5U2mMoAo1fV6YTQbDJtJJWVL2G0Vm47
XU84kVQ7N1kgxJg8I4R/OmkIEDDVAGMl+nTNaTwVV9qJM87g1WjGFEPAEvFDXgkv
tV+vr0mQ+KYK/RnrWvB4mqweF8SiaSKfx5vXJ9qGBe368+KQAf/7E1vcBnsNMqaI
KTzOR6qyvghlbsvd8CBM4hlWHxyxHqljj05pSLYICcZieDab6SidtyzUO5jL/mbk
dkqGUPUlUFDF6R5Ufi3KXAzHM8vURyXIstCPXsWeTPUPt43oeqeJ4O/Nb4uizImR
xrtd5ps2P8SuLGNUadozq9A6ndmWptzH1WIrgutBc+PHgzb29d8bF8ATAiibu+Jp
46h3dDbJpIE/V3MCcOxzcez93Yy6hAkXPW2qLtotgo1B52AvOXcwBkmNnOiXkRq1
rsHcMQqzMCMG9lCzegmhrMBKsAvLEgyx9gaqR0RGyr59s8kNrcDZu7DcC+oMjOun
kBQFQq7cmqqGvgt8xjt/HbikQWIPR7gCy9hFFu5JMscE1uBwBMseGwW859Lq9bWN
/mE3CRhixPGlWMFTOJ7MIc42+tTk0/eCmxDt+f2zYqBL3O0RA4U=
=jQoy
-----END PGP SIGNATURE-----

--=-W93PfBi418HMMnwsnXHV--
