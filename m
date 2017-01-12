From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 0/9] IPoIB fixes for 4.11
Date: Thu, 12 Jan 2017 21:24:20 +0200
Message-ID: <20170112192420.GM20392@mtr-leonro.local>
References: <20161228124728.26619-1-leon@kernel.org>
 <1484247737.123135.21.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vJI8q/aziP9idhqk"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1484247737.123135.21.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--vJI8q/aziP9idhqk
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 12, 2017 at 02:02:17PM -0500, Doug Ledford wrote:
> On Wed, 2016-12-28 at 14:47 +0200, Leon Romanovsky wrote:
> > Hi Doug,
> >
> > This is secnd version of 8 patches from Feras for IPoIB.
> >
> > The patchset was generated against v4.10-rc1 and targeted for 4.11.
> >
> > The patch "IB/ipoib: Fix deadlock between rmmod and set_mode" which
> > fix kernel panic
> > is marked as candidate for stable tree inclusion.
> >
> > Available in the "topic/ipoib-fixes-4.11" topic branch of this git
> > repo:
> > git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git
> >
> > Or for browsing:
> > https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/
> > ?h=3Dtopic/ipoib-fixes-4.11
> >
> > Thanks
> >
> > Changelog v0 -> v1:
> > =A0* Patch 2,5,6 - add Yuval Shaia's ROB tags
> > =A0* Patch 7 - remove __func__ prints
> >
> > Feras Daoud (9):
> > =A0 IB/ipoib: Add warning message when changing the MTU in UD over the
> > max
> > =A0=A0=A0=A0range
> > =A0 IB/ipoib: Set device connection mode only when needed
>
> I fixed up both of these patches according to my comments.
>
> > =A0 IB/ipoib: Fix deadlock over vlan_mutex
> > =A0 IB/ipoib: Fix deadlock between rmmod and set_mode
> > =A0 IB/ipoib: rtnl_unlock can not come after free_netdev
> > =A0 IB/ipoib: Add detailed error message to dev_queue_xmit call
> > =A0 IB/ipoib: Use debug prints instead of warnings in RNR WC status
> > =A0 IB/ipoib: Replace list_del of the neigh->list with list_del_init
> > =A0 IB/ipoib: Change list_del to list_del_init in the tx object
> >
> > =A0drivers/infiniband/ulp/ipoib/ipoib_cm.c=A0=A0=A0=A0=A0=A0=A0=A0| 30 =
++++++++++++++
> > ---------
> > =A0drivers/infiniband/ulp/ipoib/ipoib_main.c=A0=A0=A0=A0=A0=A0| 34
> > +++++++++++++++++---------
> > =A0drivers/infiniband/ulp/ipoib/ipoib_multicast.c |=A0=A06 +++--
> > =A0drivers/infiniband/ulp/ipoib/ipoib_vlan.c=A0=A0=A0=A0=A0=A0| 10 ++++=
+---
> > =A04 files changed, 52 insertions(+), 28 deletions(-)
>
> Thanks, series (after modifications) applied.

Thanks Doug.

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> =A0 =A0 GPG KeyID: B826A3330E572FDD
> =A0 =A0
> Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =A01274 B826 A333 0E57 2FDD



--vJI8q/aziP9idhqk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlh31+QACgkQ5GN7iDZy
WKcEyxAAskF7faaDRDlEnQ2LUwp+Cx4PP8+bbAN7ltlY1PiKCDkca/vhPP/SYSIY
rA6uoaaC0AH5zrLk60nXz7w0hJc/AuBy8OoQ8eTA91HLznX88x7zhvhft2h41I/Z
B3CALccUP2hxeBy+zWVlQ8c9vMKpKKEn+TGbu8QoWOVdk3OFhRyDBcp0eoi/xwIc
Cj8hXuEHUmRbdmhsQHn1fsHLTkzDkO+aib1QM2QXTt9+5V1BXSahGgH4YafbCngJ
+hgvKFsA20KWPgTPPIjNjhyW3gcvLa3zdyZRM9Y+iy6e8z9+VsfXpi53FY6eOCrU
S2w1gLYm40SshcJbuztsQXDrmeAEhEsk/B7T/Cy/olxbO4mVwg/+XRPLI2sqcq5/
lEAyKZTSzrOHwkTumwmHrxFqvcSk+FuG4ZERUkjPLUEFsO8rTO1Es3okGDb6MMYq
mIx1JCumOOmddcu85dCzjFBt2bZE3S2JuWQ2XGX6GOnXreydy/U+6FjR2uP/Bbm5
AtLEp1LNBcd6XrDxU2QP0r8LoSVOz8pw4Tx5On21FJzK97nJr6lKsghlgm/mIG2h
kFPwPFgi9z19jU6v+8gS/8RSIkqQRZFrbtRphyMlLlGcNTjHhq6QE1AQ87S+41g0
u9gMO+V/dJ1Kepn7y6F24KYrP6Tt0C7jU/HfiKIceJGwtpZqezg=
=ral/
-----END PGP SIGNATURE-----

--vJI8q/aziP9idhqk--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
