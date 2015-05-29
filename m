From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3] Add const to various core functions
Date: Fri, 29 May 2015 11:47:10 -0400
Message-ID: <1432914430.114391.86.camel@redhat.com>
References: <1432240824-3277-1-git-send-email-ira.weiny@intel.com>
	 <20150529041313.GA1603@phlsvsds.ph.intel.com>
	 <1432904099.114391.61.camel@redhat.com>
	 <20150529151735.GA5372@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-gFi2lnJSuqKUibz529KR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150529151735.GA5372-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-gFi2lnJSuqKUibz529KR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2015-05-29 at 11:17 -0400, ira.weiny wrote:
> On Fri, May 29, 2015 at 08:54:59AM -0400, Doug Ledford wrote:
> > On Fri, 2015-05-29 at 00:13 -0400, ira.weiny wrote:
> > > On Thu, May 21, 2015 at 04:40:21PM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > > > From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > >=20
> > > Doug, Jason,
> > >=20
> > > Were there any issues with these clean ups?
> >=20
> > I haven't gotten to them yet.  Your 14 patch OPA addition and this were
> > on my queue for getting to relatively soonish.  I *thought* this touche=
d
> > stuff that your 14 patch set also touched and so thought it needed to b=
e
> > on top of it, so that's part of the reason why I hadn't even looked at
> > it yet (these emails are part of the "still new and unread" emails in m=
y
> > Inbox that seem to never get to 0 ;-).
>=20
> I understand.
>=20
> >=20
> > > I think they stand on their own but I can add them to the OPA series =
if you
> > > prefer.
> >=20
> > Double check that they stand on their own.  If they do, I'll review the=
m
> > separately.
>=20
> They do stand on their own and they are improvements even without the OPA=
 code.
>=20
> They became precursors to the next OPA series because I am changing some =
core
> functions.  In order to declare parameters of those core functions const =
the
> entire call chain required updating.  Rather than mix that call chain cle=
an up
> with the new OPA code I felt it would be easier to review these as separa=
te
> clean up patches.
>=20
> If this is an unorthodox procedure, is there a better way to handle somet=
hing
> like this?

No, you did it fine.  However, if this is to be a precursor to your next
OPA patchset, then it is helpful to mention that in the cover letter
(helps me make sure I do things in the right order).

> As more and more clean up becomes necessary in the core I don't want the =
OPA
> changes to become a huge patch series which is unwieldy to review and mos=
tly
> cleanup.  (If you count Michaels changes the "clean up" to the core which=
 OPA
> now relies on count for more patches then the actual OPA changes.) I'm tr=
ying
> to reduce the review workload by making clear which patches are clean up =
vs
> actual OPA code.

Yep, makes perfect sense.

> Apologies,
> Ira
>=20
> >=20
> > > Ira
> > >=20
> > > >=20
> > > > In order to support some of Jason's comments to add const to the fu=
nctions I am
> > > > adding for OPA the following patches clean up the call trees of the=
 currently
> > > > defined functions.
> > > >=20
> > > > They stand on their own as clean up patches.  Therefore, I am submi=
tting them
> > > > separately from the OPA patches.
> > > >=20
> > > > Ira Weiny (3):
> > > >   IB/core: Add const to RDMA helpers
> > > >   IB/core: Add const to device process_mad
> > > >   IB/core: Add const to agent_send_response
> > > >=20
> > > >  drivers/infiniband/core/addr.c                |  4 +--
> > > >  drivers/infiniband/core/agent.c               |  8 +++---
> > > >  drivers/infiniband/core/agent.h               |  4 +--
> > > >  drivers/infiniband/core/cache.c               |  8 +++---
> > > >  drivers/infiniband/core/verbs.c               |  9 ++++---
> > > >  drivers/infiniband/hw/amso1100/c2_provider.c  |  6 ++---
> > > >  drivers/infiniband/hw/cxgb3/iwch_provider.c   |  6 ++---
> > > >  drivers/infiniband/hw/cxgb4/provider.c        |  5 ++--
> > > >  drivers/infiniband/hw/ehca/ehca_iverbs.h      |  4 +--
> > > >  drivers/infiniband/hw/ehca/ehca_sqp.c         |  4 +--
> > > >  drivers/infiniband/hw/ipath/ipath_mad.c       |  8 +++---
> > > >  drivers/infiniband/hw/ipath/ipath_verbs.h     |  6 ++---
> > > >  drivers/infiniband/hw/mlx4/mad.c              | 21 ++++++++-------
> > > >  drivers/infiniband/hw/mlx4/mlx4_ib.h          |  8 +++---
> > > >  drivers/infiniband/hw/mlx5/mad.c              |  8 +++---
> > > >  drivers/infiniband/hw/mlx5/mlx5_ib.h          |  8 +++---
> > > >  drivers/infiniband/hw/mthca/mthca_cmd.c       |  4 +--
> > > >  drivers/infiniband/hw/mthca/mthca_cmd.h       |  4 +--
> > > >  drivers/infiniband/hw/mthca/mthca_dev.h       |  6 ++---
> > > >  drivers/infiniband/hw/mthca/mthca_mad.c       | 10 +++----
> > > >  drivers/infiniband/hw/nes/nes_verbs.c         |  4 +--
> > > >  drivers/infiniband/hw/ocrdma/ocrdma_ah.c      |  6 ++---
> > > >  drivers/infiniband/hw/ocrdma/ocrdma_ah.h      |  6 ++---
> > > >  drivers/infiniband/hw/qib/qib_mad.c           | 10 +++----
> > > >  drivers/infiniband/hw/qib/qib_verbs.h         |  4 +--
> > > >  drivers/net/ethernet/mellanox/mlx5/core/mad.c |  2 +-
> > > >  include/linux/mlx5/driver.h                   |  2 +-
> > > >  include/rdma/ib_addr.h                        |  6 ++---
> > > >  include/rdma/ib_cache.h                       |  8 +++---
> > > >  include/rdma/ib_verbs.h                       | 39 ++++++++++++++-=
------------
> > > >  30 files changed, 116 insertions(+), 112 deletions(-)
> > > >=20
> > > > --=20
> > > > 1.8.2
> > > >=20
> >=20
> >=20
> > --=20
> > Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >               GPG KeyID: 0E572FDD
> >=20
>=20
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-gFi2lnJSuqKUibz529KR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVaIn+AAoJELgmozMOVy/daM8P/jPGVzQqMvHFaTyd+fvnJQGV
FN+NFIyF8b3LHsyhO1sfIOyLBnueFAG93SHfyuYhptEz2F+dTLtEkl8Rq5EZU1Nu
i7Iw3UQPHdz0x9/qLZ/bgbO9zH4ei/oSnYT25vv+6u0JsmbAJl2KfV+wjBRZ36ml
NJW7lf2ck8XAphl+ozDm+bQTObyc6YrgR4k7W0SXOm7RXmcvr6d7D+EvvHvVdRkH
KCNuIVyqc6F9ERwKQKKA064rqDj2FJQ537tlLsOwb0Kqu/n/H6P2rhlFY/cZHRvv
Z5a9Xoqxbv9gVSoM2iZM+QmA01UsZlsvhQMhvQhYvb+o1aeCbbYxrBYIDH5R2JgA
4pyStqqSUrWAHFVMjqimKtDVwn5gef3YdtAsgW/wQTIGREPk12Nv1lfafTjXn1vM
sfYkU1PATonAs93vOgNcFEXnOFIOOlxLEkyIv+iFajYVv7F8sVOx1+2g8bQnuXS9
30LKXdxWT4JgNnlpPItyFJqp77H0Qnq4Rb+1G2kkmqYsZlUzKd0HGDZVJfQgSWjk
ottXldeLoIDlsrwBSQLLLVTzkM5LZi1+FzThJLhx1H+AmhOH6XdkknYFaj4rd7ih
GBTy/i/JEHGgRls5Wpzu5TdyUeCDrOwoZAMoIPdkjwjTqIXgtYGKyax7Iumeb89i
EhTAltQPKNs7h4kZnYin
=pKpd
-----END PGP SIGNATURE-----

--=-gFi2lnJSuqKUibz529KR--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
