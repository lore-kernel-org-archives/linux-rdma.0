From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-rc 0/7] RDMA core, IPoiB and mlx5 fixes
Date: Fri, 29 Sep 2017 18:01:33 +0300
Message-ID: <20170929150133.GD2965@mtr-leonro.local>
References: <20170924184635.31948-1-leon@kernel.org>
 <1506697001.2919.12.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="RhUH2Ysw6aD5utA4"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1506697001.2919.12.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--RhUH2Ysw6aD5utA4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 29, 2017 at 10:56:41AM -0400, Doug Ledford wrote:
> On Sun, 2017-09-24 at 21:46 +0300, Leon Romanovsky wrote:
> > The following patch fixes struct name wrongly exposed
> > in UAPI, number of crashes in various part of infiniband
> > stack and mlx5 driver.
> >
> > Thanks
> >
> > Alex Vesker (1):
> >   IB/ipoib: Fix inconsistency with free_netdev and free_rdma_netdev
> >
> > Ilya Lesokhin (2):
> >   IB/mlx5: Simplify mlx5_ib_cont_pages
> >   IB/mlx5: Fix NULL deference on mlx5_ib_update_xlt failure
> >
> > Leon Romanovsky (1):
> >   IB/core: Fix typo in the name of the tag-matching cap struct
> >
> > Parav Pandit (2):
> >   IB/core: Fix qp_sec use after free access
> >   IB: Correct MR length field to be 64-bit
> >
> > Shalom Lagziel (1):
> >   IB/ipoib: Fix sysfs Pkey create<->remove possible deadlock
> >
> >  drivers/infiniband/core/security.c        |  4 ++-
> >  drivers/infiniband/core/uverbs_cmd.c      | 14 ++++-----
> >  drivers/infiniband/hw/mlx5/main.c         | 10 +++----
> >  drivers/infiniband/hw/mlx5/mem.c          | 47 +++++++++++--------
> > ------------
> >  drivers/infiniband/hw/mlx5/mr.c           | 27 +++++++++++-------
> >  drivers/infiniband/hw/nes/nes_verbs.c     |  4 +--
> >  drivers/infiniband/ulp/ipoib/ipoib_main.c | 15 +++++++---
> >  drivers/infiniband/ulp/ipoib/ipoib_vlan.c | 30 ++++++++++++++------
> >  drivers/infiniband/ulp/iser/iser_memory.c |  2 +-
> >  include/rdma/ib_verbs.h                   |  6 ++--
> >  include/uapi/rdma/ib_user_verbs.h         |  2 +-
> >  net/sunrpc/xprtrdma/frwr_ops.c            |  2 +-
> >  12 files changed, 90 insertions(+), 73 deletions(-)
> >
> > --
> > 2.14.1
>
> It appears I failed to send notification that this series had been
> applied for rc.  You probably noticed it was in the pull request and
> has already been taken, but just in case you hadn't, here's your notice
> ;-)

indeed, I saw it.

Thanks for the update.

>
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>

--RhUH2Ysw6aD5utA4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnOYE0ACgkQ5GN7iDZy
WKc/Qw/9GkjZylhldndmC8AZxDIJUhoHWg6dUntB0eA5q5MUYv+PGEdCNGx2Wvn3
iw8jZDZr4gEnPu/zlNPkX6zpWiWE3gZVi1EEbkj5EaIpSmGuCSHCrhazxM7QlBOI
5EYc8JsDSQAZNYq2RpG1RZ3+HfeI0vHXpaImMHra/+VO7gV+QmFPnR6CZl4o2Ome
EnZ6ZL3fPNyjnLZ4QaaMDoheG1xMi8ID8KU6Q6835QcciTrUKFCJ3a5WK17Y56lS
7WHrAhv1EKRDNW0PKsF4PeaL4X223SJR4cTDZaMdCNYzZhlnVltqCnb90DOAQJ07
QS5xRnl+g1AbGvIKK0LSHhwZ7dvm7vhRLXh2wKtYJaH+az6FIKZhzQRHDwcCgURf
uO4Y/0B2y0aBBgZCAyi0jkb6RFsXSxzhxw0l6pOy+RWMTJrtUkWaJWFGR2UCXr/9
WycuLUvTtPPGZ3Oz9GF2MVsCI9Ksk8BxaT6g3TrC/d9uD1SswBrCIjqkk24dAedh
gcbw13hnfrWd+3gFP5OqMQmaLNl7TJqm4xBcik3RJsZeI6zzkcB4b10/ntsJ8+2u
zxIldWcUo8AffjCrvk6PyDeFBxEUG+JqCoUBcNhyMHC65ZuJd0WWfVkNtmNfarca
srMU2cl7iuongnm66QD+81/7K7rSuvQ5yRGYgBMVCSbNw/FC9TI=
=lFOS
-----END PGP SIGNATURE-----

--RhUH2Ysw6aD5utA4--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
