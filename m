From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH mlx5-next 4/4] net/mlx5: Remove spinlock support from
 mlx5_write64
Date: Mon, 21 Jan 2019 18:22:08 +0000
Message-ID: <20190121182200.GI25149@mellanox.com>
References: <20190119003313.16711-1-saeedm@mellanox.com>
 <20190119003313.16711-5-saeedm@mellanox.com>
 <20190119074308.GH15600@mtr-leonro.mtl.com>
 <20190121164551.GF25149@mellanox.com>
 <CALzJLG9Lr4VcOpYLXKNHmHLzjxDCMN6AvaTRjW7ZZEMukPdZ4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CALzJLG9Lr4VcOpYLXKNHmHLzjxDCMN6AvaTRjW7ZZEMukPdZ4w@mail.gmail.com>
Content-Language: en-US
Content-ID: <9A673E6E6DF7C94F93AEAD9C776FCC60@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@dev.mellanox.co.il>
Cc: Leon Romanovsky <leonro@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Maxim Mikityanskiy <maximmi@mellanox.com>, Eran Ben Elisha <eranbe@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 21, 2019 at 10:12:58AM -0800, Saeed Mahameed wrote:
> On Mon, Jan 21, 2019 at 8:46 AM Jason Gunthorpe <jgg@mellanox.com> wrote:
> >
> > On Sat, Jan 19, 2019 at 12:43:14AM -0700, Leon Romanovsky wrote:
> > > You need to do one of two things:
> > > 1. Require CONFIG_64BIT and delete this 32bit code.
> > > 2. Declare global mlx5 DB spinlock and use on 32bit systems, somethin=
g
> > > like this:
> > > #if BITS_PER_LONG =3D=3D 64
> > >  __raw_writeq(*(u64 *)val, dest);
> > > #else
> > >   spin_lock_irqsave(doorbell_lock, flags);
> > >   __raw_writel((__force u32) val[0], dest);
> > >   __raw_writel((__force u32) val[1], dest + 4);
> > >    spin_unlock_irqrestore(doorbell_lock, flags);
> > > #endif
> >
> > And why is this code using the __raw_ versions? Seems wrong too...
> >
>=20
> for 64 and 32 as well?

yes

> what is wrong with the raw version ?

It should only be used by arch code (or in drivers linked to a
specific arch). The actual properties of the 'raw' version are arch
specific and make it hard to know if the driver will work on different
archs. ie some arches may not byte swap their raw accessors, or may
omit barriers.

Most likely this just wants to be writeq for 64 bit and
writel_relaxed() & writel() for 32 bit - unless there was some reason
to have used __raw versions in the first place (in which case a
comment is missing).

Jason
