From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-rc 0/7] IPoIB and IB core fixes for 4.7
Date: Tue, 7 Jun 2016 10:18:31 +0300
Message-ID: <20160607071831.GC3663@leon.nu>
References: <1465042524-25852-1-git-send-email-leon@kernel.org>
 <302ea695-7b9f-7c94-4930-acdb77ae8649@redhat.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8X7/QrJGcKSMr1RN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <302ea695-7b9f-7c94-4930-acdb77ae8649-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--8X7/QrJGcKSMr1RN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 06, 2016 at 08:02:15PM -0400, Doug Ledford wrote:
> On 6/4/2016 8:15 AM, Leon Romanovsky wrote:
> > Hi Doug,
> >=20
> > Please find below the patches with fixes for IPoIB and IB core.
> >=20
> > This patchset is generated against Linus's v4.7-rc1 tag.
> >=20
> > Available in the "topic/fixes-ib" topic branch of this git repo:
> > git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git
> >=20
> > Or for browsing:
> > https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=
=3Dtopic/fixes-ib
> >=20
> > Thanks
> >=20
> > Aviv Heller (1):
> >   IB/core: Fix removal of default GID cache entry
> >=20
> > Eli Cohen (1):
> >   IB/core: Fix query port failure in RoCE
> >=20
> > Erez Shitrit (2):
> >   IB/IPoIB: Don't update neigh validity for unresolved entries
> >   IB/IPoIB: Fix race between ipoib_remove_one to sysfs functions
> >=20
> > Mark Bloch (3):
> >   IB/IPoIB: Disable bottom half when dealing with device address
> >   IB/core: Fix incorrect array allocation
> >   IB/core: Initialize sysfs attributes before sysfs create group
> >=20
> >  drivers/infiniband/core/cache.c                | 10 ++++++++--
> >  drivers/infiniband/core/device.c               |  3 +++
> >  drivers/infiniband/core/sysfs.c                | 10 ++++++++--
> >  drivers/infiniband/ulp/ipoib/ipoib.h           |  1 +
> >  drivers/infiniband/ulp/ipoib/ipoib_cm.c        |  4 ++++
> >  drivers/infiniband/ulp/ipoib/ipoib_ib.c        |  8 ++++----
> >  drivers/infiniband/ulp/ipoib/ipoib_main.c      | 15 ++++++++++-----
> >  drivers/infiniband/ulp/ipoib/ipoib_multicast.c |  6 +++---
> >  drivers/infiniband/ulp/ipoib/ipoib_vlan.c      |  6 ++++++
> >  9 files changed, 47 insertions(+), 16 deletions(-)
> >=20
>=20
> Thanks Leon, I applied 5 of the 7 (the two rejected patches were replied
> to individually).

Thanks Doug.

>=20




--8X7/QrJGcKSMr1RN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXVnVHAAoJEORje4g2clinxyQP/1C0kBLDGKIfANJ1yCKjtfcJ
lTlGiMATYvy49T4N5LfrjzyJYBMFXCiNJia/ZHWPwwOt/D02FCN1gMd2ZOjha/yV
yZkSyUWe6xqRRW4ocYi0HAdcaMMEstvPEJNPkZOUhexORxpyB847PMr6r6EPTQDK
AIrX8Wsew8gf8ulBwjuHWsUwZe89d3fQwpApN+SPZycGxD71uAgiL2Ua6cAwb31d
4b4LCk39BpDORwc5OyLE6Bn+yZIRUOIA6HbfnBXwsEJWvfzqI8rDMd1c/RGlToDU
k8lGIiyxtb90ikdFq3eXyZT1PwIEtT7FrJSM84bWU+9RAX0W9hhWCwIdRXC0NOaj
0PNiS3jd7ybdOBz0I2ADP8EWFAFedlG7oY2+G9ZHASoP7k8ZZ4CDuozan6MlIxCD
KGGtNHZDvDvtnKsFrndK9kTJF6brQj3fSe4MfNi07n87SizM4wCuPXBMfKkPpqw3
P0h5yMv6aGSJ1VUS0El+gywhNkwWoUfIYROIQ/enQlDk2p7wf1/RhW984SfTnt+l
w/BysA+lwws06CgfMZEBbpphkNHPrt+njwDTFsJrCQlOPj/C/wkbUwa44K4BK9RC
81ZD1N6EmSQAe3t6CaZbzDkzuI6HIhVd4iC8X1OOPP189VBKhaBaY6fq+SYwfIAG
j8iGZgrxRaFznAr6ziu8
=05vT
-----END PGP SIGNATURE-----

--8X7/QrJGcKSMr1RN--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
