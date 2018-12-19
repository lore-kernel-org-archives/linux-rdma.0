From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next 0/2] Allocate the per-port Q counter
Date: Wed, 19 Dec 2018 08:08:21 +0200
Message-ID: <20181219060821.GP21086@mtr-leonro.mtl.com>
References: <20181209105236.26233-1-leon@kernel.org>
 <20181219051114.GA26384@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="RwGu8mu1E+uYXPWP"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181219051114.GA26384@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--RwGu8mu1E+uYXPWP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 18, 2018 at 10:11:14PM -0700, Jason Gunthorpe wrote:
> On Sun, Dec 09, 2018 at 12:52:34PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Hi
> >
> > See commit message for the patch description.
> >
> > Thanks
> >
> > Leon Romanovsky (1):
> >   net/mlx5: Add shared Q counter bits
> >
> > Yishai Hadas (1):
> >   IB/mlx5: Allocate the per-port Q counter shared when DEVX is supported
>
> This seems fine, please update the shared branch

Done,
2acc7957dbc3 net/mlx5: Add shared Q counter bits

Thanks

>
> Thanks,
> Jason

--RwGu8mu1E+uYXPWP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcGeBVAAoJEORje4g2clinWS0P/0s/oEG3OeXl4BuWxQOeZHqS
8iMnNkjYnGpQtFHYnIwafOHafYO9aiL9xicdSrePcYxiQKrAvAzWjVfivDVMYN/K
vebb3xxUQbBPE0RH9xJ06YfrPLd0Ob0WAEfp1V2xORM/5agxyjjbAGklmaF1liVg
eVpmdp2paRZeWF6kD9iaGYF2oHkNoQn+EkMCztLXjXdRFJIEEHjZsab+K0JgLITB
+h8I8CwMg7TSTB1OSdP1wbRZHXFKzViyd+lXByZfWFOetsiH1K0drtgdC7qtng0t
ENQj2hVXsO9Z4AIpF6q+C/Kk7Od+KO6GxdwIXwNtbIRslq5ZjIyygnIQ1TH0wahx
nXsjoHc8aVtvQ0jtRk1i/sAK7Z+xXpQvSHBadAaGrTePV6qI3KaUeura6uRz8/jY
tZhPYfsrXsMAkAiveiu+H7PnMd4Cq/phVx4j9gTyvkFOjpNYPmGKP8Oz1Ecz97QE
9HRLZu212z3fhwItA2uLVaxLzj0rKne3CwU+U6KWgqRwofcfrI7F5tq61La9Vc1E
8hZW5kLNRU1RMBbm9GTXL10imUOBIA4cRejfQhP0XT/BrVe2D89D/gCXqQKbZRW4
htCRJbNFhwoFGNVRtZ/pfiaKzgAiVFgkQo88Ho41yuPUMQsJhKtdjcefP0p6XqIH
4Z6rNYIMh0ElEfLnzT+w
=+kOm
-----END PGP SIGNATURE-----

--RwGu8mu1E+uYXPWP--
