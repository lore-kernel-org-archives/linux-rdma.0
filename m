From: Arseny Maslennikov <ar@cs.msu.ru>
Subject: Re: [PATCH 0/3] IB/ipoib: Use dev_port to disambiguate port numbers
Date: Thu, 30 Aug 2018 11:42:46 +0300
Message-ID: <20180830084246.GA1522@cello.Dlink>
References: <20180828210117.6437-1-ar@cs.msu.ru>
 <20180830054330.GC2796@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180830054330.GC2796@mtr-leonro.mtl.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 30, 2018 at 08:43:30AM +0300, Leon Romanovsky wrote:
> On Wed, Aug 29, 2018 at 12:01:14AM +0300, Arseny Maslennikov wrote:
> > Pre-3.15 userspace had trouble distinguishing different ports
> > of a NIC on a single PCI bus/device/function. To solve this,
> > a sysfs field `dev_port' was introduced quite a while ago
> > (commit v3.14-rc3-739-g3f85944fe207), and some relevant device
> > drivers were fixed to use it, but not in case of IPoIB.
> >
> > The convention for some reason never got documented in the kernel, but
> > was immediately adopted by userspace (notably udev[1][2], biosdevname[3=
])
> >
> > 3/3 documents the sysfs field =E2=80=94 that's why I'm CC-ing netdev.
> >
> > This series was tested on and applies to 4.19-rc1.
> >
> > [1] https://lists.freedesktop.org/archives/systemd-devel/2014-June/0207=
88.html
> > [2] https://lists.freedesktop.org/archives/systemd-devel/2014-July/0208=
04.html
> > [3] https://github.com/CloudAutomationNTools/biosdevname/blob/c795d51dd=
93a5309652f0d635f12a3ecfabfaa72/src/eths.c#L38
> >
> > Arseny Maslennikov (3):
> >   IB/ipoib: Use dev_port to expose network interface port numbers
> >   IB/ipoib: Stop using dev_id to expose port numbers
>=20
> I completely agree with previous Yuval's comment, it makes no sense to
> start separate commits for every line.
>=20
> Please decide what is best and right behavior and do it, instead of
> pushing it up to be the maintainer's problem.
>=20

No problem; will squash those two in v2, then.

> Thanks
>=20
> >   Documentation/ABI: document /sys/class/net/*/dev_port
> >
> >  Documentation/ABI/testing/sysfs-class-net | 10 ++++++++++
> >  drivers/infiniband/ulp/ipoib/ipoib_main.c |  2 +-
> >  2 files changed, 11 insertions(+), 1 deletion(-)
> >
> > --
> > 2.18.0
> >



--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE56JD3UKTLEu/ddrm9dQjyAYL01AFAluHrfcACgkQ9dQjyAYL
01A9EBAAwexKxX3iAd+9/cvOiXTTDVyhelJOUXSxbob5FHrPciMOHWJ8YuhYW1ei
q/yCcAMeTNCwJbEH8zZv579O+xXO3IJUihfcq0McqNlBl5/iN7HyltHotb4Qtc6U
n2uLr3weQ25SZCeYy+HZOJY3vyBNXlPJ1CcWl39mKPuf/eSsIPqAfQWg1c6BT38G
bHBnc/v25J5H6EyrSSxX5V1xnouWSBA/nwHGfVEVhgP6hbR7BBLtMZ3a8liBnzI2
xSp387EK6+DO/u+d50wHHAVsi0GpcFBufkzRE1h0tddhXIaSNFIux4y4IC53OX6s
Ai/E7mKFNk6AZn0EmvpB2vdWrJ1I/+T+GrvrrbTUWMtfbkx3LBgQirwsofwLulJq
94uWMwWPl9d/RKEp26JryxyEU//DYUMsQbOnosDbzk8Ltpjke1U0lbzf/2KFLFkd
ljS9HC7waxW9o16HUH+1mgbYhSE8CdlfgLWyY4opI5Qs8PTod5o5n1YikhL/7sPu
EcsZuHJhWtAlK/NCCkDFhTP+O3IeDvXm1Dyjx4q6yKwTncFtvczQmD4WDdT8c/GW
STho9Q5jjB9a2N0RvjtmyJ3HmnE/ReXYGtMgQrqxYRda9+Vd/KISKr2+7v+M4V1F
JtMrB1K6Vmi5hd4IKAmQBsdAtG5P0kZmrGQZlEy8L1vAlk21cyI=
=3xdl
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
