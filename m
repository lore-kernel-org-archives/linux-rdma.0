From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v1 rdma-next] RDMA/qedr: Fix rdma_type initialization
Date: Wed, 27 Sep 2017 19:56:10 +0300
Message-ID: <20170927165610.GJ2297@mtr-leonro.local>
References: <1505885986-5873-1-git-send-email-Michal.Kalderon@cavium.com>
 <1506518845.82712.15.camel@redhat.com>
 <CY1PR0701MB20126E3E86A45619079DFCAC88780@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <20170927165339.GI2297@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vkEkAx9hr54EJ73W"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170927165339.GI2297-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--vkEkAx9hr54EJ73W
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 27, 2017 at 07:53:39PM +0300, Leon Romanovsky wrote:
> On Wed, Sep 27, 2017 at 04:18:50PM +0000, Kalderon, Michal wrote:
> > From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Sent: Wednesday, September 27, 2017 4:27 PM
> >
> > >On Wed, 2017-09-20 at 08:39 +0300, Michal Kalderon wrote:
> > >> Initialize the rdma_type (iWARP or RoCE) which is set according to
> > >> device configuration in qed.
> > >>
> > >> Fixes: e6a38c54faf ("RDMA/qedr: Add support for registering an iWARP
> > >> device")
> > >>
> > >> Signed-off-by: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> > >> Signed-off-by: Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> > >>
> > >> ---
> > >> This patch applies cleanly on k.o/for-next-merged
> > >>
> > >> Changes from V0:
> > >> - Added Fixes in commit comment.
> > >
> > >Sorry, I was wrong in my email to the previous posting of this patch.
> > >I had pulled this v1 patch from patchworks, not the original patch, and
> > >so the Fixes: line was yours.  Patchworks did not add the Fixes: line
> > >to the v0 patch when I downloaded it just now.
> >
> > >That being said, I still can't build with this patch ;-)
> > Are you building against the rdma-next branch ?
> > The patch requires the iWARP series, originally this was tested against=
 for-next-merged,
> > what's the error you're getting ?
>
> On rdma-next:
> drivers/infiniband/hw/qedr/main.c: In function =E2=80=98qedr_add=E2=80=99:
> drivers/infiniband/hw/qedr/main.c:780:7: error: =E2=80=98struct qedr_dev=
=E2=80=99 has no member named =E2=80=98rdma_type=E2=80=99; did you mean =E2=
=80=98rdma_ctx=E2=80=99?
>   dev->rdma_type =3D dev_info.rdma_type;
>        ^~~~~~~~~
>        rdma_ctx
> make[4]: *** [scripts/Makefile.build:311: drivers/infiniband/hw/qedr/main=
=2Eo] Error 1

My config:

=E2=9E=9C  linux-rdma git:(rdma-next) grep QED .config
CONFIG_QED=3Dm
CONFIG_QED_LL2=3Dy
CONFIG_QED_SRIOV=3Dy
CONFIG_QEDE=3Dm
CONFIG_QED_RDMA=3Dy
CONFIG_INFINIBAND_QEDR=3Dm
>
>
> >
> > thanks,
> > Michal
> >
> > --
> > Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >     GPG KeyID: B826A3330E572FDD
> >     Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2=
FDD
> >



--vkEkAx9hr54EJ73W
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnL2CoACgkQ5GN7iDZy
WKd1KxAAniufo0iQceAB/8K5AlMqcmhEJHVIsUPicLaiMww8APwDuoXzseTLLBHm
mfIKxDWyAFAdfGp0j/C1ePk/N815TOmZuOlbcEJbgxO94zbVRk+d8JGtq5h8JlBm
YqwANTVpFFdwNL0le6caDg+aMHODpxx6fZoDo1LScqjMjg0cGFgxwFyWBuxYVL6m
oDzJCRNW58PN/zolUih3JmeKz5YHf0uaBp4cwRG+hI8FJex2X+PJLK7Q4PGt+pwm
h9ZgCOeRxKRLJRSdi1UJtK9voRW/Qgu6seLA0UZrJFuQjrSv8KMCJVOgY70htXIR
ooEyzhSX5tHDGhw0y5EJ8pTo1Ctyc3kajrWaVT+1Fd/dnMjsSeZsh+F03hp87GFT
9MeBrj49JyPXNmROb8F51dobz6sPAQqv9I1P6HMFXxdXsQ4YTX9Dm3Va3nhS1G9e
UF8JHI8KdZAjD/igPAL4o2Bbh1NPJhb6GMZJQ5Rm/ALuqOHTK1xGSZ0O4V3TJIN5
8YnUHNvka2d9OtnoZ71WnxbZDLzU+LBH9xHgHuJBQVTTgo2TlD+B4gCeW6VLzGYl
iKp58uCVAu91Lm2HE+tpmsmJrm9ZkauiiknbDKYmzSGBC59yDFzXcCtKIFBl95P/
jPd2Vsa2GylofO+SPaHkNX0KUb+3u6uwq+GQxriHAFxqOHwGguY=
=pM6h
-----END PGP SIGNATURE-----

--vkEkAx9hr54EJ73W--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
