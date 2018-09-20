From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH mlx5-next 07/25] net/mlx5: Update mlx5_ifc with DEVX UID
 bits
Date: Thu, 20 Sep 2018 07:51:01 +0300
Message-ID: <20180920045101.GB3519@mtr-leonro.mtl.com>
References: <20180917110418.18937-1-leon@kernel.org>
 <20180917110418.18937-8-leon@kernel.org>
 <20180919173147.GO11367@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="s/l3CgOIzMHHjg/5"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180919173147.GO11367@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--s/l3CgOIzMHHjg/5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 19, 2018 at 11:31:47AM -0600, Jason Gunthorpe wrote:
> On Mon, Sep 17, 2018 at 02:04:00PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Add DEVX information to WQ, SRQ, CQ, TRI, TIS, QP,
> > RQ, XRCD, PD, MKEY and MCG.
> >
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > ---
> >  include/linux/mlx5/mlx5_ifc.h | 67 +++++++++++++++++++++++++++----------------
> >  1 file changed, 43 insertions(+), 24 deletions(-)
>
> It is weird that we sometimes have these IFC bundle updates and
> sometimes the IFC is inlined in the patch..
>
> Why not just do one big IFC only patch with everything the series
> needs?

Nothing fancy, this "ifc change" came from my need to put all mlx5-next
related code in separate patches from IB and those definitions were
sprinkled in all following IB-specific patches.

Thanks

>
> Jason

--s/l3CgOIzMHHjg/5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJboyc1AAoJEORje4g2clinohcP/24n7hdmBFdLvMg2+N/RW+em
YqTX71C5TXDu+DH49WbvpZ1p8uKDAMF649piA/YexuUC2X0sJOxV1CUygCllonuZ
cK0TqpXiDE7EbYZU4otFuz7PJQQyvfBqZ/NkgcX4cmcegx1wpbcBLDanzgLfRDA2
f/j/oQjnhQj/rZxjochlHNzUXdPqQqhKd3AK9NlGHunWs/1S8T1jaC0XFqjo87Yo
g+hE9dgLtm4orJOtUUjXF0tWvrFDMJXARcGz3IAhKqzdca2CECuYsyMTpkbe5dYo
Z6UmgcMlbneB2V+xqjpmwp9ZXdyea0++1dwnEXINFJPMuBFSemf/rHokXiEuMR/D
R++7Rkx10DkqNBlaCZeRGWF6FCwdXX09n2dH9nBeZ/QOsRtH0h0KVkSc6ZrItTZa
hV9ZzEEza3qXBmgVGSpYkBN1FIIf7JYrGD4aiWbAWEvza2gkVSu3oUnIEkMYDQES
Nx5id3f5IJ33ZlMHSoZ0EUFjbG+o0jX3g2E3gi9FVZRRRr17GlmhgOo0tUctJawv
uqHlIoujpz5UxJBczARhXIegAGWlLh3/lkojcrPSRdrNto4ca8R3gA/2Pq/ODz81
8ZFJ0rfNthktlYPd/KvfPlwcsthG3qmDH2PTOKn6mVHV+dyWucqUrDVcWQy8GdcF
xseftWG7My+rdY0yEK6m
=uz6o
-----END PGP SIGNATURE-----

--s/l3CgOIzMHHjg/5--
