From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v1 rdma-next] RDMA/qedr: Fix rdma_type initialization
Date: Wed, 27 Sep 2017 19:53:39 +0300
Message-ID: <20170927165339.GI2297@mtr-leonro.local>
References: <1505885986-5873-1-git-send-email-Michal.Kalderon@cavium.com>
 <1506518845.82712.15.camel@redhat.com>
 <CY1PR0701MB20126E3E86A45619079DFCAC88780@CY1PR0701MB2012.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="0NB0lE7sNnW8+0qW"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CY1PR0701MB20126E3E86A45619079DFCAC88780-UpKza+2NMNLHMJvQ0dyT705OhdzP3rhOnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--0NB0lE7sNnW8+0qW
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 27, 2017 at 04:18:50PM +0000, Kalderon, Michal wrote:
> From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Sent: Wednesday, September 27, 2017 4:27 PM
>
> >On Wed, 2017-09-20 at 08:39 +0300, Michal Kalderon wrote:
> >> Initialize the rdma_type (iWARP or RoCE) which is set according to
> >> device configuration in qed.
> >>
> >> Fixes: e6a38c54faf ("RDMA/qedr: Add support for registering an iWARP
> >> device")
> >>
> >> Signed-off-by: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> >> Signed-off-by: Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> >>
> >> ---
> >> This patch applies cleanly on k.o/for-next-merged
> >>
> >> Changes from V0:
> >> - Added Fixes in commit comment.
> >
> >Sorry, I was wrong in my email to the previous posting of this patch.
> >I had pulled this v1 patch from patchworks, not the original patch, and
> >so the Fixes: line was yours.  Patchworks did not add the Fixes: line
> >to the v0 patch when I downloaded it just now.
>
> >That being said, I still can't build with this patch ;-)
> Are you building against the rdma-next branch ?
> The patch requires the iWARP series, originally this was tested against f=
or-next-merged,
> what's the error you're getting ?

On rdma-next:
drivers/infiniband/hw/qedr/main.c: In function =E2=80=98qedr_add=E2=80=99:
drivers/infiniband/hw/qedr/main.c:780:7: error: =E2=80=98struct qedr_dev=E2=
=80=99 has no member named =E2=80=98rdma_type=E2=80=99; did you mean =E2=80=
=98rdma_ctx=E2=80=99?
  dev->rdma_type =3D dev_info.rdma_type;
       ^~~~~~~~~
       rdma_ctx
make[4]: *** [scripts/Makefile.build:311: drivers/infiniband/hw/qedr/main.o=
] Error 1


>
> thanks,
> Michal
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>

--0NB0lE7sNnW8+0qW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnL15IACgkQ5GN7iDZy
WKeMdw/+Oy/7W5BnRIiqYZj3KfDuIC8kKH72PrV0bjyaNPXcsH0bwTPawOujhkri
CNAzrU/MSD+9DxBG6hlKU70d5GgXDCHhMxz4VUV9OS4mF9GShdwEkU7Kybdj4Kcr
gJk6KfiCvf3Ib34DjIF/He0XHMrpYclJWIsFEjQVC7iiFjD9pv3ptgK9mo1p0ptb
k6UqXH+vWAJxpZa5aoCz+/zes0z7no0aiP3iDXy7UPb5NzZ0GacJz8Z8FkYPM+jK
x496IRkpLRG3r25baV/T2Gi3Pv9diTiw/BN35Oc7PTXkNUsmRd4Sbe3Zw2LUZGrA
BZCh4LBFJD012qXnXpoS97lBfo+ZolFk0cTt9XCHVbb2WJvFhM23u8U209JSp5XT
FJVFI2P21kBIkvRs/8oEG8Wgnmr6zhBndusjU32B7jps5TcB1syD89C3KHGE6NQC
5d6+HHHTwAg74du2h6b6K5Of9AQgrJI7iCvq1j+Mr0eAE3HjDDF2K6cw6IRAL4p1
R0cEPdjxva6Dxx48dQnp7HFekHoiXfPVNO6tiQvmvVzF9nA3sdGaJFEWIT8kU58X
zNySdIiYpJgQizkE6r7czIoKLwUH/azavjunzOONupFf2AsKjMtyT93q+Z2UCX1M
Sg1unfd77lECspWqCIp4sgm6NwoDWaX919JiSI1nyFNgTlydD1A=
=vfTC
-----END PGP SIGNATURE-----

--0NB0lE7sNnW8+0qW--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
