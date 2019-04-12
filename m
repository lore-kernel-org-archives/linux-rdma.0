From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] RDMA/cma: Make CM response timeout and # CM retries
 configurable
Date: Fri, 12 Apr 2019 22:56:45 +0300
Message-ID: <20190412195645.GG3201@mtr-leonro.mtl.com>
References: <20190217170909.1178575-1-haakon.bugge@oracle.com>
 <20190222163637.GA9819@ziepe.ca>
 <afadc799-b547-5c20-64d2-75fa0f64cd9e@opengridcomputing.com>
 <C7922E85-CA43-479A-8021-DADD59FF5BE7@redhat.com>
 <20190223084930.GJ23561@mtr-leonro.mtl.com>
 <VI1PR0501MB2271E8A704DD21EF81C7DC24D1710@VI1PR0501MB2271.eurprd05.prod.outlook.com>
 <20190412193024.GB4690@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="1ddnCX6roxAgyKJ1"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190412193024.GB4690@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Parav Pandit <parav@mellanox.com>, Doug Ledford <dledford@redhat.com>, Steve Wise <swise@opengridcomputing.com>, =?iso-8859-1?Q?H=E5kon?= Bugge <haakon.bugge@oracle.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--1ddnCX6roxAgyKJ1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 12, 2019 at 04:30:24PM -0300, Jason Gunthorpe wrote:
> On Mon, Mar 04, 2019 at 06:27:26AM +0000, Parav Pandit wrote:
>
> > I think we should use rdma_nl_register(RDMA_NL_RDMA_CM, cma_cb_table) which was removed as part of ID stats removal.
> > Because of below reasons.
> > 1. rdma netlink command auto loads the module
>
> This is probably the best argument to stay away from sysctl for module
> parameters.. It is tricky to make sure the rdma module is loaded
> before sysctl runs in boot, and I don't think sysctl autoloads missing
> modules, or somehow copes with dynamic module loading, does it?

As far as I remember, sysctl won't be available till module is loaded,
so autoload won't work because path doesn't exist.

>
> To that end we should probably have the entire sysctl configurable
> available in netlink
>
> Jason

--1ddnCX6roxAgyKJ1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcsO19AAoJEORje4g2clinAIgP/3fDJ2ejyqJ3RWUKefRTl98A
a9xElmkzfHyU5J6wnDPyBqssKwrzz9MCcIXvDPFI55SpoYNVYjmW0HpFOAfZtfF3
Wz6psZh6NqfNUvkkG9h0pGyDgZl/OADpEYNV0Gv1dR5mpM4uTWMYLEBkHoxrTMji
RuA5sueapLvADXUMemD//SiAgLsM3Jckarto0mPfp52sq9Pt41utGjlq4yN+mcXt
Mbz3rQw2Ey5/6gxTr4IvXWDOdOHRkLSpYon06m1PfJPgjhIX+IbxSNbKI9P1l+Xz
m0pRB1mR+7pKGuUzpKZC6WilOab1v0CYaBFpzLOaGL/RwMGUhFjSLI2SO0ecfVD2
fFFY2V7TH9DInTSrHDIcqFlJNYfUd6zmj0QXZ+e6yP8HybkhBgahDF87dbniRrLj
QP/A30ouCVm3oGkS5KuV5ZNL/JusWpFhL48pzqZgEyEZ9F0Px2ILa/nhMUyOQJbr
5hPEwA9gaL8qXbodqphpXLHaBm3i2rL3EqpNdtbiDrFDVHDstLV6sek0/IKNTaiU
EIRutsOTRFoXengQjv/ezKI5pVhjWLoGciVfa4uioiIObqw1YJymdF4qKXG6zQfd
UK/SnWUudr8NyWzFkYK3IX0upw0hkGSGnYvLSU7TkfDbIma/uzPcDTEXYCYZv/Vl
IGe2aZTyxCSckkYSurdy
=RILM
-----END PGP SIGNATURE-----

--1ddnCX6roxAgyKJ1--
