From: Leon Romanovsky <leon@kernel.org>
Subject: Re: linux-next: Please add mlx5-next tree
Date: Sun, 10 Jun 2018 08:40:58 +0300
Message-ID: <20180610054058.GF12407@mtr-leonro.mtl.com>
References: <20180606192500.GZ2958@mtr-leonro.mtl.com>
 <20180608161945.66f4628f@xeon-e3>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="BwCQnh7xodEAoBMC"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180608161945.66f4628f@xeon-e3>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, "David S. Miller" <davem@davemloft.net>, linux-netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--BwCQnh7xodEAoBMC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 08, 2018 at 04:19:45PM -0700, Stephen Hemminger wrote:
> On Wed, 6 Jun 2018 22:25:00 +0300
> Leon Romanovsky <leon@kernel.org> wrote:
>
> > Hi Stephen,
> >
> > Can you please add the branch "mlx5-next" from the following tree to the
> > linux-next integration tree?
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/
> >
> > The mlx5-next branch is used to send shared pull requests to both netdev
> > and RDMA subsystems and it is worth to have linux-next coverage on it
> > before.
> >
> > Thanks
>
> I would hope all network drivers keep getting review in netdev.
> Don't want a path to upstream that bypasses review.

Me too, this branch/tree is intended for patches AFTER they passed review
in netdev and/or RDMA.

Thanks

--BwCQnh7xodEAoBMC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbHLnqAAoJEORje4g2clin8/8QAKUJvH4vO+AGkBQtJOMKp3qL
aLMROb24crqJIUGLmxBtI/K/4xD8V0aDByDEnxhrLrSvO9VYi8yVrO8/c4cDyU+h
CCeQBXRJdIBnwm5RLa4B0rbfMdzfoDJ+2EIIID24DPTHh5U15zhplffCbSm7e0YW
igtpCficxuHwIziVA4LVKvf7QNzGrZhohY9dSu8O6k9AhYCRavAZfei5FMZZHaj5
VjMeMsUN5DWfsSaaILg7lx0nKGl93EMsT4UJDoflD5mrmUxYL7SISUam6uuIzU/m
u5I71S9BGueEwjBE0PmbgK8ezimz6147aCHwH+Ggl6VCi8VdvKCr8sCwbG7JpPnj
SPXolW/QoxxdnHwE31A+X2pUHIaYA7iRUIWubYZSxdY5yn3Kb1YBAs7a7yQsMJIc
A5RoZiyVPj8eDmSijjku+onk3g1znnyWRmCHjCoz7WZhGYsEUKeVFwjtVXqcuD/E
rTksMlmi8Pp8RSvTRxPyHyjRtOVX//6Gf0G3/8vuJilSIl/+uvuaUwoEclWArSmI
qO9YsNJnC9drMNTMped7waCGy+sjM70xDPP3TTq4whOzNHb70edUqGYmSFITg3bj
lgRphZ1ucw423v1BleFWwINBcVUi6Mggl8gTH5Aij5PDIkHBvHheTp5AeuSlym8y
zUwwipFuOM/CFEHOExcD
=BKie
-----END PGP SIGNATURE-----

--BwCQnh7xodEAoBMC--
