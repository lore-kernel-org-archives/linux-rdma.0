From: Parav Pandit <parav@mellanox.com>
Subject: RE: [PATCH] IB/mlx5: add checking for "vf" from do_setvfinfo()
Date: Wed, 24 Apr 2019 22:12:42 +0000
Message-ID: <AM4PR0501MB22605B8B202CCE1D9B06350AD13C0@AM4PR0501MB2260.eurprd05.prod.outlook.com>
References: <VI1PR0501MB22714D465D6CD60511FDFFD5D1280@VI1PR0501MB2271.eurprd05.prod.outlook.com>
 <20190415094610.GO6095@kadam>
 <VI1PR0501MB22713CCB1141529CCB6934B1D12B0@VI1PR0501MB2271.eurprd05.prod.outlook.com>
 <20190416082112.GA27670@kadam>
 <AM4PR0501MB22609E4C9D126A096DD7F614D1240@AM4PR0501MB2260.eurprd05.prod.outlook.com>
 <20190420095102.GA14798@kadam>
 <VI1PR0501MB22713B232B3CF42B849F959BD1220@VI1PR0501MB2271.eurprd05.prod.outlook.com>
 <20190423154943.GC14820@kadam>
 <AM4PR0501MB2260ADC1DA37E87D01979969D1230@AM4PR0501MB2260.eurprd05.prod.outlook.com>
 <20190424140820.GB14798@kadam> <20190424142426.GH16061@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190424142426.GH16061@ziepe.ca>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>, Dan Carpenter <dan.carpenter@oracle.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Leon Romanovsky <leon@kernel.org>, Eli Cohen <eli@mellanox.com>, Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Wednesday, April 24, 2019 9:24 AM
> To: Dan Carpenter <dan.carpenter@oracle.com>
> Cc: Parav Pandit <parav@mellanox.com>; netdev@vger.kernel.org; Leon
> Romanovsky <leon@kernel.org>; Eli Cohen <eli@mellanox.com>; Doug
> Ledford <dledford@redhat.com>; linux-rdma@vger.kernel.org; kernel-
> janitors@vger.kernel.org
> Subject: Re: [PATCH] IB/mlx5: add checking for "vf" from do_setvfinfo()
>=20
> On Wed, Apr 24, 2019 at 05:08:20PM +0300, Dan Carpenter wrote:
> > I think I'm just going to ask netdev for an opinion on this.  It could
> > be that we're just reading the code wrong...
>=20
> I don't think you are reading it wrong.
>=20
> Allowing the compiler to implicitly cast a user controlled u32 to an int =
is
> simply wrong in all cases, IMHO.
>=20
> If the value was intended to be signed from the user it should have been =
a
> s32. Allowing an unsigned value to become interpreted as negative so ofte=
n
> leads to security bugs.
>=20
> IMHO it would be a good thing for smatch to warn on the general case of
> implicit casting of user controlled data to a smaller range type. Particu=
larly it
> can do a bounds analysis to show the control flow hasn't somehow
> restricted the bounds to be compatible.
>=20
> I've seen more that a few real world security bugs that are caused by wro=
ng
> use of 'int' like this :(
>=20
> Jason

Hence we should fix the type to be u32 in ndo ops to match netlink type cor=
e and in driver, instead of < 0 check.
