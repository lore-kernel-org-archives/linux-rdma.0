From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3] Add const to various core functions
Date: Fri, 29 May 2015 08:54:59 -0400
Message-ID: <1432904099.114391.61.camel@redhat.com>
References: <1432240824-3277-1-git-send-email-ira.weiny@intel.com>
	 <20150529041313.GA1603@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-jSl8KEzqQoVp4iWP9VqP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150529041313.GA1603-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-jSl8KEzqQoVp4iWP9VqP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2015-05-29 at 00:13 -0400, ira.weiny wrote:
> On Thu, May 21, 2015 at 04:40:21PM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> Doug, Jason,
>=20
> Were there any issues with these clean ups?

I haven't gotten to them yet.  Your 14 patch OPA addition and this were
on my queue for getting to relatively soonish.  I *thought* this touched
stuff that your 14 patch set also touched and so thought it needed to be
on top of it, so that's part of the reason why I hadn't even looked at
it yet (these emails are part of the "still new and unread" emails in my
Inbox that seem to never get to 0 ;-).

> I think they stand on their own but I can add them to the OPA series if y=
ou
> prefer.

Double check that they stand on their own.  If they do, I'll review them
separately.

> Ira
>=20
> >=20
> > In order to support some of Jason's comments to add const to the functi=
ons I am
> > adding for OPA the following patches clean up the call trees of the cur=
rently
> > defined functions.
> >=20
> > They stand on their own as clean up patches.  Therefore, I am submittin=
g them
> > separately from the OPA patches.
> >=20
> > Ira Weiny (3):
> >   IB/core: Add const to RDMA helpers
> >   IB/core: Add const to device process_mad
> >   IB/core: Add const to agent_send_response
> >=20
> >  drivers/infiniband/core/addr.c                |  4 +--
> >  drivers/infiniband/core/agent.c               |  8 +++---
> >  drivers/infiniband/core/agent.h               |  4 +--
> >  drivers/infiniband/core/cache.c               |  8 +++---
> >  drivers/infiniband/core/verbs.c               |  9 ++++---
> >  drivers/infiniband/hw/amso1100/c2_provider.c  |  6 ++---
> >  drivers/infiniband/hw/cxgb3/iwch_provider.c   |  6 ++---
> >  drivers/infiniband/hw/cxgb4/provider.c        |  5 ++--
> >  drivers/infiniband/hw/ehca/ehca_iverbs.h      |  4 +--
> >  drivers/infiniband/hw/ehca/ehca_sqp.c         |  4 +--
> >  drivers/infiniband/hw/ipath/ipath_mad.c       |  8 +++---
> >  drivers/infiniband/hw/ipath/ipath_verbs.h     |  6 ++---
> >  drivers/infiniband/hw/mlx4/mad.c              | 21 ++++++++-------
> >  drivers/infiniband/hw/mlx4/mlx4_ib.h          |  8 +++---
> >  drivers/infiniband/hw/mlx5/mad.c              |  8 +++---
> >  drivers/infiniband/hw/mlx5/mlx5_ib.h          |  8 +++---
> >  drivers/infiniband/hw/mthca/mthca_cmd.c       |  4 +--
> >  drivers/infiniband/hw/mthca/mthca_cmd.h       |  4 +--
> >  drivers/infiniband/hw/mthca/mthca_dev.h       |  6 ++---
> >  drivers/infiniband/hw/mthca/mthca_mad.c       | 10 +++----
> >  drivers/infiniband/hw/nes/nes_verbs.c         |  4 +--
> >  drivers/infiniband/hw/ocrdma/ocrdma_ah.c      |  6 ++---
> >  drivers/infiniband/hw/ocrdma/ocrdma_ah.h      |  6 ++---
> >  drivers/infiniband/hw/qib/qib_mad.c           | 10 +++----
> >  drivers/infiniband/hw/qib/qib_verbs.h         |  4 +--
> >  drivers/net/ethernet/mellanox/mlx5/core/mad.c |  2 +-
> >  include/linux/mlx5/driver.h                   |  2 +-
> >  include/rdma/ib_addr.h                        |  6 ++---
> >  include/rdma/ib_cache.h                       |  8 +++---
> >  include/rdma/ib_verbs.h                       | 39 ++++++++++++++-----=
--------
> >  30 files changed, 116 insertions(+), 112 deletions(-)
> >=20
> > --=20
> > 1.8.2
> >=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-jSl8KEzqQoVp4iWP9VqP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVaGGjAAoJELgmozMOVy/dBvYP/RWqnjbQHU/b3zSXw8rzMZS/
+Cm/HQAEWOBOVLK6mZXtmBEJa+hX4jC16gd6DLw3WyZdu8RE2wpFBDr0QkH46cYx
I2e5w94LC1AZBvFCvayuVZU/o0yGDcf9NKVOWQq9POxw/ohP8/kXyA787I8hcIpF
CzHsWZRS288JNY/MJSZGlyEk5UUdtHVp8oZbqFV5FGMGtmugmxbRDvqSJ3rE2moQ
bsW2Jqd/RX/wDBGYwnK5oKKcc9offnqjgB9RLI1RkQaNEbXTrnz0SiIv+3iAVNnz
Gp3IIV6Oy7fRUE0+clLsZGEfiH9IC3SBOKoQcOMLgyn1MM6c7XT8uzwvppAzMaD9
oviqU5i3JuOQfGc0/U92JrJoQyXUXRg9fTytNkvvfy4rnUy3SY5KQphWkHfkQT1m
huQ2Scdhs5OKLy/0bY39z4XS4g32yEo3LYyC9LdfBfZt1nGawpvPD+PkkXtl0mTd
AXqEmkxiSQcER7kAP9w4BGT+86W7KoUZhQZeF/GrF3ysKB1UPb+9mVDJexaTHK6w
sqaApQ1LSpggt79tEfnLtn99yRHnNYSGaUzD5pwxcnZrks9u0s1+eYEUNZ2QisNn
81Lwubxe17N6z6h1B+SwSqAP9suD/Wlpk1+byzenpLhu9QqpNacrvKz2YYk37QB2
0OdY04l7E0aNJRXsLlZo
=qIlX
-----END PGP SIGNATURE-----

--=-jSl8KEzqQoVp4iWP9VqP--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
