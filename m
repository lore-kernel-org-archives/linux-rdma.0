From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH rdma-next 2/5] RDMA/core: Don't depend device ODP
 capabilities on kconfig option
Date: Thu, 20 Dec 2018 23:22:53 +0000
Message-ID: <20181220232247.GV29267@mellanox.com>
References: <20181220092318.32672-1-leon@kernel.org>
 <20181220092318.32672-3-leon@kernel.org>
 <20181220172045.GG29267@mellanox.com>
 <20181220172956.GC3940@mtr-leonro.mtl.com>
 <20181220173306.GI29267@mellanox.com>
 <20181220175020.GD3940@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181220175020.GD3940@mtr-leonro.mtl.com>
Content-Language: en-US
Content-ID: <E3E9D4D56A7A354582A658E189620E79@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Haggai Eran <haggaie@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 20, 2018 at 07:50:20PM +0200, Leon Romanovsky wrote:
> > > > > -#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
> > > > >  	if (MLX5_CAP_GEN(mdev, pg))
> > > > >  		props->device_cap_flags |=3D IB_DEVICE_ON_DEMAND_PAGING;
> > > > >  	props->odp_caps =3D dev->odp_caps;
> > > > > -#endif
> > > >
> > > > But shouldn't this be protected? If the driver has compiled out ODP=
 it
> > > > shouldn't set the cap flag...
> > >
> > > I see those capabilities as device properties and not as kernel ones.
> > >
> > > Current situation looks bad for me, when I have same device which
> > > reports differently information depends on some compilation flag.
> >
> > It is not device capabilities, it is a kernel API capability if the
> > API is not available the bit should not be set.
>=20
> Is it better? Should I resend the series?

Hrm.. I think I'm inclined to keep the the if() in the same place as
the ifdefs. We can revise it later.

I noticed other busted up stuff:
 - IB_DEVICE_ON_DEMAND_PAGING is apparently UAPI but not in a uapi
   header (grr)
 - ucontext shouldn't have a driver callback, that should be moved to
   ops (ie to mlx5_ib_dev_odp_ops)
 - IB_DEVICE_ON_DEMAND_PAGING should be set in core code based
   on ops.invalidate_range being present, drivers shouldn't set it..

Jason
