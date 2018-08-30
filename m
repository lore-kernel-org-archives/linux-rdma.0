From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH 0/3] IB/ipoib: Use dev_port to disambiguate port numbers
Date: Thu, 30 Aug 2018 08:43:30 +0300
Message-ID: <20180830054330.GC2796@mtr-leonro.mtl.com>
References: <20180828210117.6437-1-ar@cs.msu.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="63aIh6YiuHX+oBFP"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180828210117.6437-1-ar@cs.msu.ru>
Sender: netdev-owner@vger.kernel.org
To: Arseny Maslennikov <ar@cs.msu.ru>
Cc: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--63aIh6YiuHX+oBFP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 29, 2018 at 12:01:14AM +0300, Arseny Maslennikov wrote:
> Pre-3.15 userspace had trouble distinguishing different ports
> of a NIC on a single PCI bus/device/function. To solve this,
> a sysfs field `dev_port' was introduced quite a while ago
> (commit v3.14-rc3-739-g3f85944fe207), and some relevant device
> drivers were fixed to use it, but not in case of IPoIB.
>
> The convention for some reason never got documented in the kernel, but
> was immediately adopted by userspace (notably udev[1][2], biosdevname[3])
>
> 3/3 documents the sysfs field =E2=80=94 that's why I'm CC-ing netdev.
>
> This series was tested on and applies to 4.19-rc1.
>
> [1] https://lists.freedesktop.org/archives/systemd-devel/2014-June/020788=
=2Ehtml
> [2] https://lists.freedesktop.org/archives/systemd-devel/2014-July/020804=
=2Ehtml
> [3] https://github.com/CloudAutomationNTools/biosdevname/blob/c795d51dd93=
a5309652f0d635f12a3ecfabfaa72/src/eths.c#L38
>
> Arseny Maslennikov (3):
>   IB/ipoib: Use dev_port to expose network interface port numbers
>   IB/ipoib: Stop using dev_id to expose port numbers

I completely agree with previous Yuval's comment, it makes no sense to
start separate commits for every line.

Please decide what is best and right behavior and do it, instead of
pushing it up to be the maintainer's problem.

Thanks

>   Documentation/ABI: document /sys/class/net/*/dev_port
>
>  Documentation/ABI/testing/sysfs-class-net | 10 ++++++++++
>  drivers/infiniband/ulp/ipoib/ipoib_main.c |  2 +-
>  2 files changed, 11 insertions(+), 1 deletion(-)
>
> --
> 2.18.0
>

--63aIh6YiuHX+oBFP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbh4QCAAoJEORje4g2clinQA0QAKtYXKyNu/a3GlqDipZRqLzW
S8SqPacBsdpZzTX3IoljyG/YI6B6WgJagQItbHgOu4m8ik2B8qPT0TjVl+BCkGRX
ZC/m/LO/xD78a0R0eQ5JQnkZqAFt22k99L7TnHlmx/sWVTkDDH46Nku0Pb7ie3vl
56gcCSDJq1lblfOY6oMBJlbVZNMOucfWtcRVFMXl3nitk6cPZoW159fEJ7/ciRDc
z1gG1pQXXO9d39xwB07zdO3ZK5bnccPBb+6y2dte55bP1jrxXrRX037trzzgPKO1
FEWECVaLgtvVUgsRKNTmrqwzkDFAqPFTGkh3dutTjHW9TSRh81Y9mxRHHL5Sy8C8
qbRAHEA4kLOe2PgImH1d3KCp1GUK1VQpE1lmGiz00BHPER8LBtLD5YDBHpBOMyUb
ZAjnQE7YbJxuKfq2rbdRE1igWjXO04GZpbGr7xLpVpPkNfvoO2doP4oChG2CqyOh
aSiSFhSoDvX/4ZbH8zDzkxpY7rdJ4rPkjsFzBQRnYbwsKHt5lGuUf6tRh3hW/PtB
95aUvMWwvVAc1S2Npl5pXujo3dphNWDY9/jpxGEVlvgJbxnqepymVzpwPpLJc7OU
k9cx/5dA23eRLK9Gt7ncAbUC6XJe59aRIUP9d9x3G5i9b4jyYeY+YJu7tn0owEGB
Qnkz53d5M+WY+1Oe25nk
=uIqk
-----END PGP SIGNATURE-----

--63aIh6YiuHX+oBFP--
