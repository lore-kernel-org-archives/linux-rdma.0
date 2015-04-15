From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 0/4] Misc. fixes and cleanup for iw_cxgb4
Date: Wed, 15 Apr 2015 17:00:46 -0400
Message-ID: <1429131646.2980.411.camel@redhat.com>
References: <1426783410-5128-1-git-send-email-hariprasad@chelsio.com>
		 <552EB35B.2060805@opengridcomputing.com>
	 <1429130009.2980.399.camel@redhat.com>
	 <014201d077be$833e63a0$89bb2ae0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-AJ4MTg0/e1t4C9CU3QxA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <014201d077be$833e63a0$89bb2ae0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, 'Hariprasad Shenai' <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-AJ4MTg0/e1t4C9CU3QxA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-04-15 at 15:55 -0500, Steve Wise wrote:
> Ok, Hari can you please resubmit.   Should it be based on your github for=
-4.1 branch?=20

Yes please.

>=20
>=20
>=20
>=20
> > -----Original Message-----
> > From: Doug Ledford [mailto:dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
> > Sent: Wednesday, April 15, 2015 3:33 PM
> > To: Steve Wise
> > Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org; Hariprasad Shenai; linux-rdma-u79uwXL29TbrhsbdSgBK9A@public.gmane.org=
rg; nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org; kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
> > Subject: Re: [PATCH for-next 0/4] Misc. fixes and cleanup for iw_cxgb4
> >=20
> > On Wed, 2015-04-15 at 13:52 -0500, Steve Wise wrote:
> > > Hey Doug/Roland,
> > >
> > > Please include this in the 4.1 merge...
> >=20
> > These patches no longer apply cleanly.
> >=20
> > > Thanks,
> > >
> > > Steve.
> > >
> > >
> > >
> > > On 3/19/2015 11:43 AM, Hariprasad Shenai wrote:
> > > > Hi,
> > > >
> > > > This patch series changes a macro definition to be consistent with =
other
> > > > register macro defines. Fixes for 32b platform, use BAR2 register f=
or kernel
> > > > mode CQ's and enforces qp/cq id requirements.
> > > >
> > > > The patches series is created against 'infiniband' tree for-next br=
anch.
> > > > And includes patches on iw_cxgb4 driver.
> > > >
> > > > We have included all the maintainers of respective drivers. Kindly =
review the
> > > > change and let us know in case of any review comments.
> > > >
> > > > Thanks
> > > >
> > > > Hariprasad Shenai (4):
> > > >    iw_cxgb4: Cleanup register defines/MACROS
> > > >    iw_cxgb4: 32b platform fixes
> > > >    iw_cxgb4: use BAR2 GTS register for T5 kernel mode CQs
> > > >    iw_cxgb4: enforce qp/cq id requirements
> > > >
> > > >   drivers/infiniband/hw/cxgb4/cm.c          |    6 +++---
> > > >   drivers/infiniband/hw/cxgb4/cq.c          |   21 ++++++++++++++--=
-----
> > > >   drivers/infiniband/hw/cxgb4/device.c      |   29 ++++++++++++++++=
++++++++++---
> > > >   drivers/infiniband/hw/cxgb4/mem.c         |   10 +++++-----
> > > >   drivers/infiniband/hw/cxgb4/qp.c          |   14 +++++++-------
> > > >   drivers/infiniband/hw/cxgb4/t4.h          |    7 ++++---
> > > >   drivers/infiniband/hw/cxgb4/t4fw_ri_api.h |    4 +++-
> > > >   7 files changed, 62 insertions(+), 29 deletions(-)
> > >
> >=20
> >=20
> > --
> > Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >               GPG KeyID: 0E572FDD
> >=20
>=20
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-AJ4MTg0/e1t4C9CU3QxA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJVLtF+AAoJELgmozMOVy/dtX4P/3VvVET6oRFlTJYipLBaeJTK
vrJhVzs/1FZZhnf6bJf2KXD03USFkpJ46r94EYHk9LH4oLmI3W0GTYbbjAVJ/C6a
ht+VJoVxarJ0OYLi4FoL2ZSAhs93loVXIY3D2961IFBUkoeot4EmeTwt5WhO4K5R
1XagXzbQuPLHoTiYJxHFVXuik1jlxpVQarEZrOx3H8Kk4TuBW2wsXMdH1Nht4h45
2WMBE9DKM71LVq+lm9Lg9+xb+PvVWJGXre2Pc1xPIvWoU+WKmEYwwz1s6JMTBoYe
v5hL6IsPq55x+tDIsEy9T6qE3BKgRX0uhnkgq1he10BHfF3YvHFgVf0EZjZGTWMy
aN5bOIxO009A+a5O4YtKT1Hw8KkbgxFbqnz76yvToKxAL9KD0GX33RueILcPA5u9
q6te5XohUb8B8mTZlAJuitJwAi10gTwIxaxEcD1HwRV0NLHnufyZIHJPlI8FQ9QK
s8r29J6DdqfDIWMxfcxt/yWmpW4i0B33mrsAOLz2YD7MvvtcQUPFQ6HSYzLnFN90
1b4Mp7NdeaSR2WGQCEquKS63PAIe415WuGkhasWjmcq8YLluCSONAS2XWUjen4UA
y/cBVRQWITOIINzswa+vnvj5sZnmcmZbuuOUNyFqqCyVlo6qJVS+CjE0OESiNLYD
Q2BqiBBY8bQOaf1VOzjH
=PpKo
-----END PGP SIGNATURE-----

--=-AJ4MTg0/e1t4C9CU3QxA--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
