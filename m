From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v8 00/23] IB/Verbs: IB Management Helpers
Date: Mon, 11 May 2015 20:27:00 -0400
Message-ID: <1431390420.43876.4.camel@redhat.com>
References: <1430830240-32389-1-git-send-email-yun.wang@profitbricks.com>
	 <20150511234910.GA20027@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-/jmN2+qP0NzeivfxXhFI"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150511234910.GA20027-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-/jmN2+qP0NzeivfxXhFI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-05-11 at 19:49 -0400, ira.weiny wrote:
> I have run with this series and the only issue I have found is not with t=
his
> patch set directly.
>=20
> This patch:
>=20
> >   IB/Verbs: Use management helper rdma_cap_ib_mad()
>=20
> causes an error when you actually use the port passed from the ib_umad mo=
dule.
> I have a patch to fix that which I found while trying to build on this se=
ries
> for the use of a bit mask.
>=20
> Doug, I don't know what you would like to do for this fix.  I am submitti=
ng it
> shortly with a new version of the core capability bit patches.  If you wa=
nt to
> just add it after this series or force Michael to respin with the fix?

As I recall, there was a comment from Or requesting to squash some of
the individual patches down, but I no longer have that email in my Inbox
to double check.  And it seemed like there was one other review comment
not yet addressed.  Do I have that right Michael?  And if so, are you
working on a v9?

>   Frankly
> I vote for the former because as it stands this series does not break dir=
ectly.
> It was only after I changed the implementation of rdma_cap_ib_mad that it
> broke.
>=20
>=20
> For the rest of the series.
>=20
> Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Tested-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 	-- Limited to mlx4, qib, and OPA (with additional patches.)
>=20
>=20
> On Tue, May 05, 2015 at 02:50:17PM +0200, Michael Wang wrote:
> > Since v7:
> >   * Thanks to Doug, Ira, Devesh for the testing :-)
> >   * Thanks for the comments from or, Doug, Ira, Jason :-)
> >     Please remind me if anything missed :-P
> >   * Use rdma_cap_XX() instead of cap_XX() for readability
> >   * Remove CC list in git log for maintainability
> >   * Use bool as return value
> >   * Updated github repository to v8
> >=20
> > There are plenty of lengthy code to check the transport type of IB devi=
ce,
> > or the link layer type of it's port, but actually we are just speculati=
ng
> > whether a particular management/feature is supported by the device/port=
.
> >=20
> > Thus instead of inferring, we should have our own mechanism for IB mana=
gement
> > capability/protocol/feature checking, several proposals below.
> >=20
> > This patch set will introduce query_protocol() to check management requ=
irement
> > instead of inferring from transport and link layer respectively, along =
with
> > the new enum on protocol type.
> >=20
> > Mapping List:
> > 		node-type	link-layer	transport	protocol
> > nes		RNIC		ETH		IWARP		IWARP
> > amso1100	RNIC		ETH		IWARP		IWARP
> > cxgb3   	RNIC		ETH		IWARP		IWARP
> > cxgb4   	RNIC		ETH		IWARP		IWARP
> > usnic   	USNIC_UDP	ETH		USNIC_UDP	USNIC_UDP
> > ocrdma  	IB_CA		ETH		IB		IBOE
> > mlx4    	IB_CA		IB/ETH		IB		IB/IBOE
> > mlx5    	IB_CA		IB		IB		IB
> > ehca    	IB_CA		IB		IB		IB
> > ipath   	IB_CA		IB		IB		IB
> > mthca   	IB_CA		IB		IB		IB
> > qib     	IB_CA		IB		IB		IB
> >=20
> > For example:
> > 	if (transport =3D=3D IB) && (link-layer =3D=3D ETH)
> > will now become:
> > 	if (query_protocol() =3D=3D IBOE)
> >=20
> > Thus we will be able to get rid of the respective transport and link-la=
yer
> > checking, and it will help us to add new protocol/Technology (like OPA)=
 more
> > easier, also with the introduced management helpers, IB management logi=
cal
> > will be more clear and easier for extending.
> >=20
> > Highlights:
> >     The long CC list in each patches was complained consider about the
> >     maintainability, it was suggested folks to provide their reviewed-b=
y or
> >     Acked-by instead, so for those who used to be on the CC list, pleas=
e
> >     provide your signature voluntarily :-)
> >=20
> >     The 'mgmt-helpers' branch of 'git-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org:ywang-pb/infiniband-wy=
.git'
> >     contain this series based on the latest 'infiniband/for-next'
> >=20
> >     Patch 1#~14# included all the logical reform, 15#~23# introduced th=
e
> >     management helpers.
> >=20
> >     Doug suggested the bitmask mechanism:
> > 	https://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg23765.html
> >     which could be the plan for future reforming, we prefer that to be =
another
> >     series which focus on semantic and performance.
> >=20
> >     This patch-set is somewhat 'bloated' now and it may be a good timin=
g for
> >     staging, I'd like to suggest we focus on improving existed helpers =
and push
> >     all the further reforms into next series ;-)
> >=20
> > Proposals:
> >     Sean:
> > 	https://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg23339.html
> >     Doug:
> > 	https://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg23418.html
> > 	https://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg23765.html
> >     Jason:
> > 	https://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg23425.html
> >=20
> > Michael Wang (23):
> >   IB/Verbs: Implement new callback query_protocol()
> >   IB/Verbs: Implement raw management helpers
> >   IB/Verbs: Reform IB-core mad/agent/user_mad
> >   IB/Verbs: Reform IB-core cm
> >   IB/Verbs: Reform IB-core sa_query
> >   IB/Verbs: Reform IB-core multicast
> >   IB/Verbs: Reform IB-ulp ipoib
> >   IB/Verbs: Reform IB-ulp xprtrdma
> >   IB/Verbs: Reform IB-core verbs
> >   IB/Verbs: Reform cm related part in IB-core cma/ucm
> >   IB/Verbs: Reform route related part in IB-core cma
> >   IB/Verbs: Reform mcast related part in IB-core cma
> >   IB/Verbs: Reform cma_acquire_dev()
> >   IB/Verbs: Reform rest part in IB-core cma
> >   IB/Verbs: Use management helper rdma_cap_ib_mad()
> >   IB/Verbs: Use management helper rdma_cap_ib_smi()
> >   IB/Verbs: Use management helper rdma_cap_ib_cm()
> >   IB/Verbs: Use management helper rdma_cap_iw_cm()
> >   IB/Verbs: Use management helper rdma_cap_ib_sa()
> >   IB/Verbs: Use management helper rdma_cap_ib_mcast()
> >   IB/Verbs: Use management helper rdma_cap_read_multi_sge()
> >   IB/Verbs: Use management helper rdma_cap_af_ib()
> >   IB/Verbs: Use management helper rdma_cap_eth_ah()
> >=20
> >  drivers/infiniband/core/agent.c              |   2 +-
> >  drivers/infiniband/core/cm.c                 |  20 ++-
> >  drivers/infiniband/core/cma.c                | 257 +++++++++++--------=
--------
> >  drivers/infiniband/core/device.c             |   1 +
> >  drivers/infiniband/core/mad.c                |  43 +++--
> >  drivers/infiniband/core/multicast.c          |  12 +-
> >  drivers/infiniband/core/sa_query.c           |  30 ++--
> >  drivers/infiniband/core/ucm.c                |   3 +-
> >  drivers/infiniband/core/ucma.c               |  25 +--
> >  drivers/infiniband/core/user_mad.c           |  26 ++-
> >  drivers/infiniband/core/verbs.c              |   6 +-
> >  drivers/infiniband/hw/amso1100/c2_provider.c |   7 +
> >  drivers/infiniband/hw/cxgb3/iwch_provider.c  |   7 +
> >  drivers/infiniband/hw/cxgb4/provider.c       |   7 +
> >  drivers/infiniband/hw/ehca/ehca_hca.c        |   6 +
> >  drivers/infiniband/hw/ehca/ehca_iverbs.h     |   3 +
> >  drivers/infiniband/hw/ehca/ehca_main.c       |   1 +
> >  drivers/infiniband/hw/ipath/ipath_verbs.c    |   7 +
> >  drivers/infiniband/hw/mlx4/main.c            |  10 ++
> >  drivers/infiniband/hw/mlx5/main.c            |   7 +
> >  drivers/infiniband/hw/mthca/mthca_provider.c |   7 +
> >  drivers/infiniband/hw/nes/nes_verbs.c        |   6 +
> >  drivers/infiniband/hw/ocrdma/ocrdma_main.c   |   1 +
> >  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |   6 +
> >  drivers/infiniband/hw/ocrdma/ocrdma_verbs.h  |   3 +
> >  drivers/infiniband/hw/qib/qib_verbs.c        |   7 +
> >  drivers/infiniband/hw/usnic/usnic_ib_main.c  |   1 +
> >  drivers/infiniband/hw/usnic/usnic_ib_verbs.c |   6 +
> >  drivers/infiniband/hw/usnic/usnic_ib_verbs.h |   2 +
> >  drivers/infiniband/ulp/ipoib/ipoib_main.c    |  15 +-
> >  include/rdma/ib_verbs.h                      | 167 +++++++++++++++++
> >  net/sunrpc/xprtrdma/svc_rdma_recvfrom.c      |   4 +-
> >  net/sunrpc/xprtrdma/svc_rdma_transport.c     |  45 ++---
> >  33 files changed, 477 insertions(+), 273 deletions(-)
> >=20
> > --=20
> > 2.1.0
> >=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-/jmN2+qP0NzeivfxXhFI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVUUjUAAoJELgmozMOVy/dhTUQAKucQnJFM0TziqVyFc7HZiHh
eJAxkwErkORLzbUmuqkLpZTKpQm+05ytDD5tDZJXQF0EYCVch7sgT1AugHcTUcnw
qZun7LtfVi4XyEbXUT4nzgXugIm2n1lwdskk/k6VHiGAj041pB2QMVkWXbPbVaFM
uhmnDKnWN/ncyNNfx4S5CH29HyGxKmTbbKpFl8prVd9jV7yX4RMMDK5VaQdxNOZN
2ydnd52tsgwZ6OlFJ7z5gb7dIWDidw2mlKm0xifrCyI9MOu69DB48TiQxw7rhET8
+L+SCLoyy3yiQ7jlnfBhd5jJIBAOtKC11PqyK0GEW4Erev/MpTIz6jaQtpQWRq+t
RZpSvkuNmjO9Gqjwy50N+/KBnK3WiXduIgLO6Mdvg8h7eaEQ32xuYg56HOdS8Kto
5BlwpEhGm1GBSXzmYaHX6MoCvGhBhAxQ7hm2KFjF4g3w9q6xWF32WC9i0MauRFyG
wAuerBarVIuK51iStgCqA5oJlQ2yHZ6Hyqjsahu1zxy3gArNDp5FRxH6WofZOwG3
8PACCP3kHaDFovBCLwD7KOdePQXNUuVxhh7rxx5Z6Ek95YI444uo3KCKoft3S4Dx
080d+nYj7EfEHbrN4Yxeq1LJodUFz8IuXFU2v9noV9PyVtKihW1wQjxt8lsYSMDw
0VYC3e9WOPcbmxycuf7a
=RBx0
-----END PGP SIGNATURE-----

--=-/jmN2+qP0NzeivfxXhFI--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
