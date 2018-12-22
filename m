From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] IB/mlx5: Fix error handling in UVERBS_HANDLER
Date: Sat, 22 Dec 2018 10:41:23 +0200
Message-ID: <20181222084123.GJ3940@mtr-leonro.mtl.com>
References: <20181222081335.GA13088@embeddedor>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="3CAnR4CLEnEWqRMR"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181222081335.GA13088@embeddedor>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Moni Shoua <monis@mellanox.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--3CAnR4CLEnEWqRMR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Dec 22, 2018 at 02:13:35AM -0600, Gustavo A. R. Silva wrote:
> Currently, if uverbs_attr_ptr_get_array_size() fails, the returned error
> turns into a huge value, once it is being store into a variable of type
> size_t (unsigned long), hence never actually reporting such error and
> causing unexpected behavior when executing function
> mlx5_ib_create_modify_header().
>
> Fix this by changing the type of variable num_actions from size_t to
> int.
>
> Addresses-Coverity-ID: 1475957 ("Unsigned compared against 0")
> Fixes: cbfdd442c43e ("IB/uverbs: Add helper to get array size from ptr attribute")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  drivers/infiniband/hw/mlx5/flow.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks for fixing it, but I see that Dam already sent fix for that.

--3CAnR4CLEnEWqRMR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcHfizAAoJEORje4g2clinTKYP/R3gmbow9BwPZ/P0wzi+dHgP
Mo+DZ6OTUYJwo0laRvsUxZOAZQIXWIfUTmHu2fFhblGM1W0jGB7yLqDJZnbxSsqs
j7H7yfa/A16u16sKIzLOUMP+hUE8o6PY/YAnePDG5glslSy4EAMOnPdJqYf7rFtS
DTcnycP/4XlquXqybg5vT8dYbqQ8kMVSYozvBEmMgfaQw0Bmd9ndyWJuXllFvtDh
w/4HW/36xZ35fvubTQKTvXYvJA3YzUmG0cSJNjKRITUOzNhfJ+bjrVpBony1xOHr
8b7bwlH3+FgmV1IU64NKP76x95CYatM60Z3TxdW6PaUxJB0fC9YvlQlf831Nzd3H
1WRcR34XOLaE6l+aBtecmRRj0BCtXCJI3lwgLkt9ZjR0iLD9nMqqs2jAD0EAEBD0
9E23lHj0XMER+mGOL4FGCfRiVO8mkykskziHEeHZHUezdcRCm892ncdfwM6oel0l
VRS+F83T2b3uV8Qm2K0BF9RZv46oZq+Qbz6tVthSznjCvPjitIYwm8l2kKEWQWIf
GenObXOsy5e4JK/hgzNL0ASGIzB0HlPSrKjZHmIOGOKGHERMlqHPopO31ZpWX5tt
YROR5RuGtBOFwuDoDUHxwOtyGIEdu+Ct7sYwkwuaPST9Oz6co17p6KI0dsrFJYHS
ArWAqzzwNKawEjSlMLiK
=y/w2
-----END PGP SIGNATURE-----

--3CAnR4CLEnEWqRMR--
