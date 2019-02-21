From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH mlx5-next] net/mlx5: Separate ODP capabilities
Date: Thu, 21 Feb 2019 12:21:46 +0000
Message-ID: <20190221122143.GC17501@mtr-leonro.mtl.com>
References: <20190219130638.21981-1-leon@kernel.org>
 <20190221121003.GB17501@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="S1BNGpv0yoYahz37"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190221121003.GB17501@mtr-leonro.mtl.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Moni Shoua <monis@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

--S1BNGpv0yoYahz37
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 21, 2019 at 12:10:06PM +0000, Leon Romanovsky wrote:
> On Tue, Feb 19, 2019 at 03:06:37PM +0200, Leon Romanovsky wrote:
> > From: Moni Shoua <monis@mellanox.com>
> >
> > ODP support for XRC transport is not enabled by default in FW,
> > so we need separate ODP checks to enable/disable it.
> >
> > While that, rewrite the set of ODP SRQ support capabilities in way
> > that tests each field separately for clearness, which is not needed
> > for current FW, but better to have it separated.
> >
> > Signed-off-by: Moni Shoua <monis@mellanox.com>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > ---
> >  .../net/ethernet/mellanox/mlx5/core/main.c    | 29 ++++++++++---------
> >  1 file changed, 15 insertions(+), 14 deletions(-)
> >
>
> Thanks, applied to mlx5-next
> f1463b9f1a97 net/mlx5: Separate ODP capabilities
>
> Doug, Jason,
>
> Can you please merge this branch into rdma-next as a preparation
> to pull request?

Sorry, it was a mistake, I dropped it.

>
> Thanks



--S1BNGpv0yoYahz37
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcbpfXAAoJEORje4g2clinJtYP/1+kNlqLY4S+xWlmT6Fsot0D
Nk8y4DOg4R8ddGi5oLPxOOXpRXvDtWO0yAL2lOCKqAld91DmVJq6viEY1V5zDFN7
cW6VXwT2db0/AXvlYO7b0C1ts7KcckxFE8Hg+THjSt5GpuZN9OzBSKNe/6cAJqc0
+zT6EGFdpE39YYc6ShLOMOV1+RMJ+4Tzxv4/qDluOsk36ml1mfu5QyRNCnQr1lq4
ewKPrOPJhdouRPuw15t89L4vEe7HngsSmD0i+Sg+sK46du8ddlc5lJqW0GRqdYKN
HI4nodaKx4wjH4QP7LCqRYGEGyRLrvXh3neE3hSHXUwVitB/X7DFIECi1WuZrPK1
DYbAxAmoWT3N94bEiGSVTN3SvwnYxjJRpN7sZ4P95Evr66ycfGH7JzMvzY5e0DJK
qLosoMNv+ZAdACHCHSborB/d0zQjIq0f/9Ev8v9Dc5NZmGFMXyDtgErC+Vaefn8r
N1A3d/bZfErqlNMaK5JMYBqL1+bl79aFKNsepY2Q3i99eDAIkUNb99YdoJUI74b4
WfjDxCtIPKXKuoIfQ/KCyJBXd5siYHnOHLUN8j5jrGGOEJQUTBxZfesaB8XYc2ZH
Zz399lsC3jrIpjo4BV1kvVSK8xDIRjSXsiPguF7s2/0zL8tJjAiHg4VxJLu9nf4v
As439fAkl6dE00Pgsn3T
=eFtq
-----END PGP SIGNATURE-----

--S1BNGpv0yoYahz37--
