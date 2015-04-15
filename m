From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 0/4] Misc. fixes and cleanup for iw_cxgb4
Date: Wed, 15 Apr 2015 16:33:29 -0400
Message-ID: <1429130009.2980.399.camel@redhat.com>
References: <1426783410-5128-1-git-send-email-hariprasad@chelsio.com>
	 <552EB35B.2060805@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-kXmOQb0UCFVcvgkqy13h"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <552EB35B.2060805-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-kXmOQb0UCFVcvgkqy13h
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-04-15 at 13:52 -0500, Steve Wise wrote:
> Hey Doug/Roland,
>=20
> Please include this in the 4.1 merge...

These patches no longer apply cleanly.

> Thanks,
>=20
> Steve.
>=20
>=20
>=20
> On 3/19/2015 11:43 AM, Hariprasad Shenai wrote:
> > Hi,
> >
> > This patch series changes a macro definition to be consistent with othe=
r
> > register macro defines. Fixes for 32b platform, use BAR2 register for k=
ernel
> > mode CQ's and enforces qp/cq id requirements.
> >
> > The patches series is created against 'infiniband' tree for-next branch=
.
> > And includes patches on iw_cxgb4 driver.
> >
> > We have included all the maintainers of respective drivers. Kindly revi=
ew the
> > change and let us know in case of any review comments.
> >
> > Thanks
> >
> > Hariprasad Shenai (4):
> >    iw_cxgb4: Cleanup register defines/MACROS
> >    iw_cxgb4: 32b platform fixes
> >    iw_cxgb4: use BAR2 GTS register for T5 kernel mode CQs
> >    iw_cxgb4: enforce qp/cq id requirements
> >
> >   drivers/infiniband/hw/cxgb4/cm.c          |    6 +++---
> >   drivers/infiniband/hw/cxgb4/cq.c          |   21 ++++++++++++++------=
-
> >   drivers/infiniband/hw/cxgb4/device.c      |   29 ++++++++++++++++++++=
++++++---
> >   drivers/infiniband/hw/cxgb4/mem.c         |   10 +++++-----
> >   drivers/infiniband/hw/cxgb4/qp.c          |   14 +++++++-------
> >   drivers/infiniband/hw/cxgb4/t4.h          |    7 ++++---
> >   drivers/infiniband/hw/cxgb4/t4fw_ri_api.h |    4 +++-
> >   7 files changed, 62 insertions(+), 29 deletions(-)
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-kXmOQb0UCFVcvgkqy13h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJVLssaAAoJELgmozMOVy/dhvUP/j4CG9m18xavREVDI/6l+G4T
dC3SYt/aJsBRTrXCoaeoFLItsVmqzjco+YM3cZox4u4gvgGntL8nGd7ZtFNuLyxd
d6CxMosIxFI5wuwf2wPQ9u0/B16E97SO+mBwcsP3qp83ioyn7vj6glmQqMEGcsiq
XElixT+0GzDPAJXjm/tquFiJDRgl7BIJ5uBLz9PjCT7+f6DzyTTfGOM7y2XpoiCl
NCikgKh3Jy7xAGTbaQfSen4QIG8Mj/ko+zXIwoa2Snc7xfrrFlJ/rdZ89Nienupe
qTxOMYZnWhUI/DF4zU7yLXSti1bK6wQsWNdjCWisUHcCJf9OL4ZTJEmJeZIXmdJu
mhPqcEaVHXwsllgiHsOq1pipbCo49IwZF/3A1333n8d0SkVre3wqZjwAfiSZSdva
BvUMsHzMll/k7/fAa3WfTSbSzXhiwuP8dOqiCZl0iW2xPVF+csHPPqwK2twfyo05
Tydooq+BA6oKNBTmIOjrpWEjs992+sLaQywttds1tQN4GKIQv3nnM2LRGaT6ZRgl
3p6je6Lxmkc4jSBu2JQro1y4tJxBOPXymEK53MUzBf9a7Ug38fXZqxNlrOa/OXtg
tp/j8I8zZmz7uRsqrjP/yFfRYbZ7pX1hYZ3wuCY5GvluPuZ/CPtbpbfnM71Bh1is
OFFh+huU5sePBE9TIMhu
=5HP3
-----END PGP SIGNATURE-----

--=-kXmOQb0UCFVcvgkqy13h--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
