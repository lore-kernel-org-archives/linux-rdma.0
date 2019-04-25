From: Parav Pandit <parav@mellanox.com>
Subject: RE: [PATCH] IB/mlx5: add checking for "vf" from do_setvfinfo()
Date: Thu, 25 Apr 2019 06:15:13 +0000
Message-ID: <AM4PR0501MB2260DF0BBBC528A147F07E0DD13D0@AM4PR0501MB2260.eurprd05.prod.outlook.com>
References: <20190412175504.GA20857@kadam>
 <VI1PR0501MB22714D465D6CD60511FDFFD5D1280@VI1PR0501MB2271.eurprd05.prod.outlook.com>
 <20190415094610.GO6095@kadam>
 <VI1PR0501MB22713CCB1141529CCB6934B1D12B0@VI1PR0501MB2271.eurprd05.prod.outlook.com>
 <20190416082112.GA27670@kadam>
 <AM4PR0501MB22609E4C9D126A096DD7F614D1240@AM4PR0501MB2260.eurprd05.prod.outlook.com>
 <20190420095102.GA14798@kadam>
 <VI1PR0501MB22713B232B3CF42B849F959BD1220@VI1PR0501MB2271.eurprd05.prod.outlook.com>
 <20190423154943.GC14820@kadam>
 <AM4PR0501MB2260ADC1DA37E87D01979969D1230@AM4PR0501MB2260.eurprd05.prod.outlook.com>
 <20190424140820.GB14798@kadam>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190424140820.GB14798@kadam>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc: Leon Romanovsky <leon@kernel.org>, Eli Cohen <eli@mellanox.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Dan Carpenter <dan.carpenter@oracle.com>
> Sent: Wednesday, April 24, 2019 9:08 AM
> To: Parav Pandit <parav@mellanox.com>; netdev@vger.kernel.org
> Cc: Leon Romanovsky <leon@kernel.org>; Eli Cohen <eli@mellanox.com>;
> Doug Ledford <dledford@redhat.com>; Jason Gunthorpe <jgg@ziepe.ca>;
> linux-rdma@vger.kernel.org; kernel-janitors@vger.kernel.org
> Subject: Re: [PATCH] IB/mlx5: add checking for "vf" from do_setvfinfo()
>=20
> I think I'm just going to ask netdev for an opinion on this.  It could be=
 that
> we're just reading the code wrong...
>=20
> I'm getting a lot of Smatch warning about buffer underflows.  The problem=
 is
> that Smatch marks everything from nla_data() as unknown and untrusted
> user data.  In do_setvfinfo() we get the "->vf" values from nla_data().  =
It
> starts as u32, but all the function pointers in net_device_ops use it as =
a
> signed integer.  Most of the functions return -EINVAL if "vf" is negative=
 but
> there are at least 48 which potentially use negative values as an offset =
into
> an array.
>=20
> To me making "vf" a u32 throughout seems like a good idea but it's an
> extensive patch and I'm not really able to test it at all. =20

I will be try to get you patch early next week for core and in mlx5, tested=
 on mlx5 VFs, that possibly you can carry forward?
