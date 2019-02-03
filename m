From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next 00/12] Add SRQ and XRC support for ODP MRs
Date: Sun, 3 Feb 2019 12:54:30 +0200
Message-ID: <20190203105430.GF3634@mtr-leonro.mtl.com>
References: <20190122064851.6032-1-leon@kernel.org>
 <20190131232739.GA13446@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="kA1LkgxZ0NN7Mz3A"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190131232739.GA13446@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Majd Dibbiny <majd@mellanox.com>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--kA1LkgxZ0NN7Mz3A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 31, 2019 at 04:27:39PM -0700, Jason Gunthorpe wrote:
> On Tue, Jan 22, 2019 at 08:48:39AM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Hi,
> >
> > This series extend ODP to work with SRQ and XRC. Being both per-operation
> > (e.g. RDMA write, RDMA read and atomic) and per-transport (e.g. RC, UD and XRC),
> > we extend IB/core and mlx5 driver to provide needed information to user space.
> >
> > Thanks
> >
> > Moni Shoua (12):
> >   IB/mlx5: Fix locking SRQ object in ODP event
> >   IB/core: Allocate bit for SRQ ODP support
> >   IB/uverbs: Expose XRC ODP device capabilities
> >   IB/mlx5: Remove useless check in ODP handler
> >   IB/mlx5: Clean mlx5_ib_mr_responder_pfault_handler() signature
> >   IB/mlx5: Add XRC initiator ODP support
> >   IB/mlx5: Let read user wqe also from SRQ buffer
> >   IB/mlx5: Add ODP SRQ support
> >   IB/mlx5: Advertise SRQ ODP support for supported transports
>
> I applied these patches to for-next
>
> >   net/mlx5: Add XRC transport to ODP device capabilities layout
> >   IB/mlx5: Advertise XRC ODP support
> >   net/mlx5: Set ODP SRQ support in firmware
>
> This might need some re-organizing - the last patch could be split
> (possibly merge with the first) so the header changes can go to the
> shared branch, but the handle_hca_cap_odp() stuff must only be applied
> to the rdma tree.
>
> I'm fine either way, if you don't want to split it send a commit ID
> for the first patch on mlx5-next.

I applied two following patches,

46861e3e88be net/mlx5: Set ODP SRQ support in firmware
dda7a817f287 net/mlx5: Add XRC transport to ODP device capabilities layout

Thanks

>
> Thanks,
> Jason

--kA1LkgxZ0NN7Mz3A
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcVshmAAoJEORje4g2clinpXQP/jytoqy2h5YgWqnB9HsAXG63
Ltgr4kd9qQZFmC7mQrUrZ6ZTeImDeVIYAYkOLvTLG90isVRCy8XkI+2V/hr7Owwi
aHG3ReaNdnXYmpEmkdmrYLJaSG6Q0LJlLL6a7Bvugn0hjArw4l7CGFYdPoPq4gGd
DQSJ33mLhyj5XHf+oZlfdOBHsN+AxDYvm1Ei+QGB59elWM9vXQea01QANEWzaScD
c9BVnGjg6GdFbjrrXzU93VACklMgkOIlF4GnqA77VcCRB6IV7bXiO5LIAxq04aia
igb92SFdRB9baJ9NCekQzWQAGr5odOI4QHKkX1MUKid8BrKUh0Vu70hL5Asyd0bO
A+/2/lkbKN9oPC4JtW3y2ghoDIyeLVCvQvzBXgMxuv/JM97s3xADNsAbBhSKnVtk
A/RjfxWy79muGilhCneNYJjpbJf5Xj5uf3rcYyPv7W4m6lZMTrwnSD/WxcP0N2bf
jjUZvCPChGVrv4twTvIM4VJAsyszUyQXu3v25vQm6HDTgngylWMJEDLXHsv59PIq
6wcbKgJH0swZvHMMU3t80Fw3asijnDoRYwgeqxvRnQ2hdFxAdGKHmKvJFN5nlFit
cC69Wrh/ilZOLD6Ke1hdZOS/zKIWexKuzORZAVyKY2UEs/N1YOTA09jK9rysGybS
7hAmIHhwzAU1bfel9psb
=2uRC
-----END PGP SIGNATURE-----

--kA1LkgxZ0NN7Mz3A--
