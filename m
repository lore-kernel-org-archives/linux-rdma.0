From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH mlx5-next 00/10] Collection of ODP fixes
Date: Mon, 19 Nov 2018 22:25:02 +0000
Message-ID: <20181119222455.GP3599@mellanox.com>
References: <20181108191017.21891-1-leon@kernel.org>
 <20181112204310.GI3695@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181112204310.GI3695@mtr-leonro.mtl.com>
Content-Language: en-US
Content-ID: <6FCE607F4152004E9FA9BA751BA4A74D@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Majd Dibbiny <majd@mellanox.com>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 12, 2018 at 01:43:15PM -0700, Leon Romanovsky wrote:
> On Thu, Nov 08, 2018 at 09:10:07PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Hi,
> >
> > This is collection of fixes to mlx5_core and mlx5_ib ODP logic.
> > There are two main reasons why we decided to forward it to mlx5-next
> > and not to rdma-rc or net like our other fixes.
> >
> > 1. We have large number of patches exactly in that area that are ready
> > for submission and we don't want to create extra merge work for
> > maintainers due to that. Among those future series (already ready and
> > tested): internal change of mlx5_core pagefaults handling, moving ODP
> > code to RDMA, change in EQ mechanism, simplification and moving SRQ QP
> > to RDMA, extra fixes to mlx5_ib ODP and ODP SRQ support.
> >
> > 2. Most of those fixes are for old bugs and there is no rush to fix the=
m
> > right now (in -rc1/-rc2).
> >
> > Thanks
> >
> > Moni Shoua (10):
> >   net/mlx5: Release resource on error flow
> >   net/mlx5: Add interface to hold and release core resources
> >   net/mlx5: Enumerate page fault types
> >   IB/mlx5: Lock QP during page fault handling
> >   net/mlx5: Return success for PAGE_FAULT_RESUME in internal error stat=
e
> >   net/mlx5: Use multi threaded workqueue for page fault handling
> >   IB/mlx5: Improve ODP debugging messages
>=20
> Applied to mlx5-next
> b02394aa75e3 IB/mlx5: Improve ODP debugging messages
> 90290db7669b net/mlx5: Use multi threaded workqueue for page fault handli=
ng
> ef90c5e9757d net/mlx5: Return success for PAGE_FAULT_RESUME in internal e=
rror state
> 032080ab43ac IB/mlx5: Lock QP during page fault handling
> c99fefea2cc9 net/mlx5: Enumerate page fault types
> 27e95603f4df net/mlx5: Add interface to hold and release core resources
> 698114968a22 net/mlx5: Release resource on error flow
>=20
> >   IB/mlx5: Avoid hangs due to a missing completion
> >   IB/mlx5: Call PAGE_FAULT_RESUME command asynchronously
>=20
> Dropped to address feedback.
>=20
> >   net/mlx5: Remove unused function
>=20
> Dropped, because it depends on dropped commit.

Okay, merged into for-next

Jason
