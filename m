From: Parav Pandit <parav@mellanox.com>
Subject: RE: linux-next: manual merge of the net-next tree with the rdma tree
Date: Tue, 31 Jul 2018 21:12:00 +0000
Message-ID: <VI1PR0502MB3008076016496152D4898D8ED12E0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <20180727123301.3ac97ddc@canb.auug.org.au>
        <20180727024832.GA30023@mellanox.com>
        <20180727132847.2be8563b@canb.auug.org.au>
        <VI1PR0502MB3008702AFA64F44DE57DC9F5D12A0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20180727150903.0f2816ba@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180727150903.0f2816ba@canb.auug.org.au>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jason Gunthorpe <jgg@mellanox.com>, David Miller <davem@davemloft.net>, Networking <netdev@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ursula Braun <ubraun@linux.ibm.com>, Leon Romanovsky <leonro@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hi Stephen,

> -----Original Message-----
> From: linux-rdma-owner@vger.kernel.org <linux-rdma-owner@vger.kernel.org>
> On Behalf Of Stephen Rothwell
> Sent: Friday, July 27, 2018 12:09 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: Jason Gunthorpe <jgg@mellanox.com>; David Miller
> <davem@davemloft.net>; Networking <netdev@vger.kernel.org>; Doug
> Ledford <dledford@redhat.com>; Linux-Next Mailing List <linux-
> next@vger.kernel.org>; Linux Kernel Mailing List <linux-
> kernel@vger.kernel.org>; Ursula Braun <ubraun@linux.ibm.com>; Leon
> Romanovsky <leonro@mellanox.com>; linux-rdma@vger.kernel.org
> Subject: Re: linux-next: manual merge of the net-next tree with the rdma =
tree
>=20
> Hi Parav,
>=20
> On Fri, 27 Jul 2018 04:57:41 +0000 Parav Pandit <parav@mellanox.com> wrot=
e:
> >
> > >  	for (i =3D 0; i < smcibdev->pattr[ibport - 1].gid_tbl_len; i++) {
> > > -		memset(&_gid, 0, SMC_GID_SIZE);
> > > -		memset(&gattr, 0, sizeof(gattr));
> > > -		if (ib_query_gid(smcibdev->ibdev, ibport, i, &_gid, &gattr))
> > > +		gattr =3D rdma_get_gid_attr(smcibdev->ibdev, ibport, i);
> > > +		if (IS_ERR(gattr))
> > >  			continue;
> > > -		if (!gattr.ndev)
> > > +		if (!gattr->ndev)
> > >  			continue;
> > This requires a small fix.
> > If (!gattr->ndev {
> > 	rdma_put_gid_attr(gattr);
> > 	continue;
> > }
>=20
> Thanks, I have fixed this up for Monday.
You might want to consider this compatibility patch in Linux-rdma tree to a=
void a merge conflict of smc.

https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/commit/?h=3Df=
or-next&id=3D7aaa1807e698f73094b78f0ef25b1a37a4409a55
