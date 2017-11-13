From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/2] mlx4 RSS fixes for 4.15
Date: Mon, 13 Nov 2017 13:20:13 +0200
Message-ID: <20171113112013.GI18825@mtr-leonro.local>
References: <20171025193935.1075-1-leon@kernel.org>
 <1510337143.3735.6.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="nnfBUBcla7C6E0rv"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1510337143.3735.6.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--nnfBUBcla7C6E0rv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 10, 2017 at 01:05:43PM -0500, Doug Ledford wrote:
> On Wed, 2017-10-25 at 22:39 +0300, Leon Romanovsky wrote:
> > Hi Doug,
> >
> > There are two mlx4 RSS fixes for v4.15
> >
> > Thanks
> >
> > The patches are available in the git repository at:
> >   git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-next-2017-10-25
> >
> > 	Thanks
> > ---------------------------------------
> >
> > Guy Levi (2):
> >   IB/mlx4: Add report for RSS capabilities by vendor channel
> >   IB/mlx4: Fix RSS's QPC attributes assignments
> >
> >  drivers/infiniband/hw/mlx4/main.c    | 17 +++++++++++++++++
> >  drivers/infiniband/hw/mlx4/mlx4_ib.h | 16 +++++++++++-----
> >  drivers/infiniband/hw/mlx4/qp.c      | 16 +++++++++-------
> >  3 files changed, 37 insertions(+), 12 deletions(-)
> >
> > --
> > 2.14.2
> >
>
> Series applied, thanks.

Doug,

I can't find it in your k.o repo.
Where can I find it?

Thanks

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD



--nnfBUBcla7C6E0rv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloJf+0ACgkQ5GN7iDZy
WKfX3g/+Pp1+vkgGfv1W7ihBswRGJBrpD+xbWXyLbc4Je+So+IhZ9aIYCGMdx6Xd
pneKLG1nxdH3StqRm3C8M8hkyzUMOsabZwW37n1+4rdi243CEnm0aYsGoJ5oOCtA
nXVEJ0rz3Sh325hopmY2m9u33/fp9qHsvjaygMuj+aGL+l9xurccQjUklONB3LER
BO98Zkas7szB+KruG0T/v2B1QMPawEfuwywjjC8YfPfBsohCbZV92gctJ4QtqcCx
GIlB6JuecWhUHI4cpVmzacgIivxuZYyFxl2lqb2lVIpFc7RKDRNIN7vfvkOa0XEf
khPA9xjigQ5cVF2P04HQihWC/jr+kb0XXmF5QW/K1CZzVlFK5CcQ1vesuBOth2HD
iuOLgyoI/WnP5VDSouC97NzQLCHPg0qhEsVZaqMpRufLKidbv2BWDFZW73EeyUdL
ZdxBA8ewRMa7fafpMf2Mjiw+iecXcViQGLM9PFBTeGC3KKzPpuudsJ2y5hN++GsC
SChHtRryae9+BSXR36m4fxhonNNyqzIaObDxPQQHtYsNjEMMvCqVm+5wteN2sUZN
QGNuXmkQQ+07GQlt3PIb8BeMABFlOMPV9smFidV7uf53GfvdSxAeEN0HjmlzL36s
R4nRujapPHf83zAh7R28qYsaSOFnlOoCAmteMj+DjQzgCp1T9II=
=qEFS
-----END PGP SIGNATURE-----

--nnfBUBcla7C6E0rv--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
