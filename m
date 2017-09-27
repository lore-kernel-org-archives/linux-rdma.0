From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [perftests and rdma-core]: Location of upstream perftest repo
 and inclusion in rdma-core
Date: Wed, 27 Sep 2017 11:01:31 +0300
Message-ID: <20170927080131.GD2297@mtr-leonro.local>
References: <C4BBDD1E-5DB8-4892-9B5B-0AE3D74D457A@raithlin.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1sNVjLsmu1MXqwQ/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <C4BBDD1E-5DB8-4892-9B5B-0AE3D74D457A-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>, zoharb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--1sNVjLsmu1MXqwQ/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 26, 2017 at 09:01:35PM +0000, Stephen  Bates wrote:
> Hi All
>
> Firstly, a big thanks to Parav for solving my =E2=80=9Ctwo RNICs in the s=
ame server=E2=80=9D loopback woes [1]. The script you provided worked a tre=
at with rdma_cm things like rping and NVMe over Fabrics working very nicely.
>
> One thing I did notice is that for the perftests (e.g. ib_write_bw) there=
 is no way to bind to an IP address when using the rdma_cm option =E2=80=93=
R. Does anyone know if this is possible with the existing code? If not I=E2=
=80=99d like to propose a patch for the perftests but I am not sure where t=
he current upstream repo for perftests is? I also wanted to ask if this is =
something that could be considered for rdma-core as we have other user-spac=
e tools there?
>
> A repo for perftests lives here [2] (which Logan forked a while back [3])=
 but it seems pretty inactive=E2=80=A6

Perftest official repo is on the github:
https://github.com/linux-rdma/perftest

Thanks

>
> Cheers
>
> Stephen
>
> [1] https://marc.info/?l=3Dlinux-rdma&m=3D150575871330293&w=3D2
> [2] git://git.openfabrics.org/~grockah/perftest.git
> [3] https://github.com/lsgunth/perftest
>
>

--1sNVjLsmu1MXqwQ/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnLWtoACgkQ5GN7iDZy
WKdzFA/+JM55LWt05gwZSO+75Txgu6NzMz/F5Szr+HC8d3OZ4UG58Od3wGekZ5MA
QRJJTzZTxsiv8+f0mPnB8gJTP+yxywObLyCux3GbEoBvdwnMbuOIEJwmY/GO5r1B
nlpR877aVwFSV0wiI1FABy1Bg2MDcI55ImPX57JJ+cEf4OMEX63konxMhGjtIV2u
09kw5TIEZxc1GBBQaLwkqRWXblNVeFigplouiLo3fP7ntWx8/c0nb70PxiiiAL9z
6N/ifE1z8+dV0/yKkHn7Q1ENV0GgeyxFUvuwlDE8qI7kXUv1sDx/WspCztwdiWSp
09AZ3QCt/plqNyuxnqqJkJPepQLms7QmebCnTWATECZfJ2eWVJohpOlqb2ycRo8d
0Hz55M3an8dXrZM16sTXnPwPDy33zgCijqz49RyTvZgSlisMQSpABmX3szQJpgGD
tWZFzdq786I9XmlpO4Ngx3m+RRZnUoZWFj3hCfLrL4YTZf0EHwMZoDBSsatG0YIx
RQoBFxIDBEc42AwwKg8pddr8yd17m+n57Ycnx4Ci6Hzx04r39CwXSsN7WfXKhPvV
ZoHF0i3oYOfOqWQXRoCMWQtvHKAzZH4kGlFdrJQ2/8wIwYb1X+Se/ZdEJhbmnVU4
QBxbguRmrzFY7sMknbp0tfizhYNQ6uGUX4TC78Vbov5iLI9nDgo=
=r+yi
-----END PGP SIGNATURE-----

--1sNVjLsmu1MXqwQ/--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
