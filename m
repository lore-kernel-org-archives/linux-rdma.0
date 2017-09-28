From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v1 rdma-next] RDMA/qedr: Fix rdma_type initialization
Date: Thu, 28 Sep 2017 06:27:25 +0300
Message-ID: <20170928032725.GO2297@mtr-leonro.local>
References: <1505885986-5873-1-git-send-email-Michal.Kalderon@cavium.com>
 <1506518845.82712.15.camel@redhat.com>
 <CY1PR0701MB20126E3E86A45619079DFCAC88780@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <20170927165339.GI2297@mtr-leonro.local>
 <20170927165610.GJ2297@mtr-leonro.local>
 <CY1PR0701MB2012A41A0744D17AD3CD10DB88780@CY1PR0701MB2012.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="SqfawxHnX56H7Ukl"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CY1PR0701MB2012A41A0744D17AD3CD10DB88780-UpKza+2NMNLHMJvQ0dyT705OhdzP3rhOnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--SqfawxHnX56H7Ukl
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 27, 2017 at 08:33:38PM +0000, Kalderon, Michal wrote:
> From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Sent: Wednesday, September 27, 2017 7:56 PM
> On Wed, Sep 27, 2017 at 07:53:39PM +0300, Leon Romanovsky wrote:
> >> On Wed, Sep 27, 2017 at 04:18:50PM +0000, Kalderon, Michal wrote:
> >> > From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >> > Sent: Wednesday, September 27, 2017 4:27 PM
> >> >
> >> > >On Wed, 2017-09-20 at 08:39 +0300, Michal Kalderon wrote:
> >> > >> Initialize the rdma_type (iWARP or RoCE) which is set according to
> >> > >> device configuration in qed.
> >> > >>
> >> > >> Fixes: e6a38c54faf ("RDMA/qedr: Add support for registering an iW=
ARP
> >> > >> device")
> >> > >>
> >> > >> Signed-off-by: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> >> > >> Signed-off-by: Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> >> > >>
> >> > >> ---
> >> > >> This patch applies cleanly on k.o/for-next-merged
> >> > >>
> >> > >> Changes from V0:
> >> > >> - Added Fixes in commit comment.
> >> > >
> >> > >Sorry, I was wrong in my email to the previous posting of this patc=
h.
> >> > >I had pulled this v1 patch from patchworks, not the original patch,=
 and
> >> > >so the Fixes: line was yours.  Patchworks did not add the Fixes: li=
ne
> >> > >to the v0 patch when I downloaded it just now.
> >> >
> >> > >That being said, I still can't build with this patch ;-)
> >> > Are you building against the rdma-next branch ?
> >> > The patch requires the iWARP series, originally this was tested agai=
nst for-next-merged,
> >> > what's the error you're getting ?
> >>
> >> On rdma-next:
> >> drivers/infiniband/hw/qedr/main.c: In function =E2=80=98qedr_add=E2=80=
=99:
> >> drivers/infiniband/hw/qedr/main.c:780:7: error: =E2=80=98struct qedr_d=
ev=E2=80=99 has no member named =E2=80=98rdma_type=E2=80=99; did you mean =
=E2=80=98rdma_ctx=E2=80=99?
> >>   dev->rdma_type =3D dev_info.rdma_type;
> >>        ^~~~~~~~~
> >>        rdma_ctx
> >> make[4]: *** [scripts/Makefile.build:311: drivers/infiniband/hw/qedr/m=
ain.o] Error 1
> >
> >My config:
> >
> >=E2=9E=9C  linux-rdma git:(rdma-next) grep QED .config
> >CONFIG_QED=3Dm
> >CONFIG_QED_LL2=3Dy
> >CONFIG_QED_SRIOV=3Dy
> >CONFIG_QEDE=3Dm
> >CONFIG_QED_RDMA=3Dy
> >CONFIG_INFINIBAND_QEDR=3Dm
>
> Thanks Leon for helping out with this. Unfortunately i'm not seeing this.
> The rdma_type field was added with the following patch:
> https://kernel.googlesource.com/pub/scm/linux/kernel/git/dledford/rdma/+/=
e6a38c54faf38498170e227c82ea25cb8bc1ae71
>
> When running git log on the k.o/for-next I see the patch (last in list be=
low),
> applying this patch on top of  rdma-next works for me and compiles cleanl=
y.
>
> 2e2f2d0 RDMA/qedr: Fix rdma_type initialization
> 1848757 Merge branches 'hns' and 'misc' into k.o/for-next
> 931bc0d IB: Move PCI dependency from root KConfig to HW's KConfigs
> 7ae6f2a Merge branch 'qedr' into k.o/for-next
> bd491d2 RDMA/qedr: fix build error without ipv6
> 89fd257 RDMA/qedr: Missing error code in qedr_init_user_queue()
> 847cb1a RDMA/qedr: fix spelling mistake: "invlaid" -> "invalid"
> 69ad0e7 RDMA/qedr: Add support for iWARP in user space
> e411e05 RDMA/qedr: Add iWARP connection management functions
> de0089e RDMA/qedr: Add iWARP connection management qp related callbacks
> fb1a22b RDMA/qedr: Add support for read with invalidate, supported in iWA=
RP
> f5b1b17 RDMA/qedr: Add iWARP support in existing verbs
> e6a38c5 RDMA/qedr: Add support for registering an iWARP device
>
> am i missing something ?

I refreshed my branches now and it worked, but your git log history
looks strange. Where did you see the commit 1848757 and 931bc0d?

https://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git/log/?h=3D=
k.o/for-next
Age	Commit message (Expand)	Author	Files	Lines
3 days	Merge branch 'qedr' into k.o/for-nextfor-nextk.o/for-next	=EF=BF=BCD=
oug Ledford	11	-91/+1208
3 days	Merge tag 'v4.14-rc2' into k.o/for-next	=EF=BF=BCDoug Ledford	12044	=
-388475/+631018
3 days	Linux 4.14-rc2HEADmaster	=EF=BF=BCLinus Torvalds	1	-1/+1

=E2=9E=9C  linux-rdma git:(iwarp-compile) git log --oneline
f3506957237b (HEAD -> iwarp-compile) RDMA/qedr: Fix rdma_type initialization
7ae6f2a3d552 (rdma/k.o/for-next, grdma/k.o/for-next) Merge branch 'qedr' in=
to k.o/for-next
0d9c2ff1c9f7 Merge tag 'v4.14-rc2' into k.o/for-next
e19b205be43d (tag: v4.14-rc2, rdma/master, origin/master, ml/master, grdma/=
master, grdma/hns, backup/master, master) Linux 4.14-rc2

Thanks

> thanks,
> Michal
>

--SqfawxHnX56H7Ukl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnMbB0ACgkQ5GN7iDZy
WKfQOA/9Ed8bV/em1TmSU8cSpfNABBB/tSHY6dSy2eE18+VFECYHbJmb/+JwOos0
Zw01uaLGaIKuYuPTiNEOEJqCqzBaPIahyXJuKQU5ghdkcZBJLXEuRNdymn8ZfbbZ
iRrKg2eaZM6PtY3Ok9LgH88uah8TZ9Pwqa5tNn/r6tzy3SmkdpLgDXhfyF3+LZFc
pAGj8Uq41z7qOcho7Cfl5VR2+ktM5EFEXYCDcaMsBS4FHmbSGWhG+ocbUUNcH6LH
9Jc/t/brEOTgU3hppK/+e7UM3W/TvLR9YN45+3af8B4vm7OtdLhUBTW1u1ju+jTq
ftrWR5wqkvCx1D5UlCi1Z9OboWxwMxMtkfospRt80fbJTF35NBnzYS5w9cecvcu4
lKWScMShlRW4ngMriBZ548We8qK6gUImhVrwIz3j5tvC1gvdj1nVZHYjjopdcNLx
yPyBvz4snVhJYm9LEQcdEN9g4Jffq+Q9qBgwCnAbGfnQgdmvIYCkgUz7+uikkm5p
5pQmqEYC1hMwKFsyhoNuCJ4phTmczKJMxIqbum/T7vGlSJuPOjqiPiLmtdSE/FeY
uBsPwRYcaQoja+PNg1QJZG5/6t+9HhuujuDyuwLtZa3Mz6mnF7r4eQ8EoZsSXzj5
3DRJqDmg8HsEQyeRKkRq1+gxJNvtdnXeHuWGyUE+ZrJJImkY2l0=
=Izhs
-----END PGP SIGNATURE-----

--SqfawxHnX56H7Ukl--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
