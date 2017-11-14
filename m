From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: vmw_pvrdma: Add SRQ support - broke rdma-core
Date: Tue, 14 Nov 2017 21:00:29 +0200
Message-ID: <20171114190029.GI18825@mtr-leonro.local>
References: <20171114085143.GS18825@mtr-leonro.local>
 <20171114182720.GC18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4Wcu3uPC65WqUq/x"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171114182720.GC18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--4Wcu3uPC65WqUq/x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 14, 2017 at 08:27:20PM +0200, Leon Romanovsky wrote:
> On Tue, Nov 14, 2017 at 10:51:43AM +0200, Leon Romanovsky wrote:
> > The commit 25f07300bfb7 ("vmw_pvrdma: Add SRQ support") causes to build
> > failures in Travis CI [1] and on my system too [2].
> >
> > Please fix.
>
> I reverted the commit, please fix compilation error and resubmit.
>
> Commit: 32bf4efb8605 ("Revert "vmw_pvrdma: Add SRQ support" because it causes build failures")

Just as a pointer, it fails on the systems with kernel's include/uapi/rdma/vmw_pvrdma-abi.h
file available, so fixup is not applied but without your definition yet.

> Thanks



--4Wcu3uPC65WqUq/x
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloLPUwACgkQ5GN7iDZy
WKcauA//VjkDZflDyXQs+q99iGyMC7M7TU2Qgp1U23ZZiExyPwPnwuEraZrUiczY
CQLR4afPBim5qokesXIvh8QPJePVHBYJo44JrfNz53kxFWdl/ar6S5rgyw/g7GYj
6bjyUQP76pOmVsohH0fZwol8eX/bjjVutTyn3UrEYfrE6h4UIyd+lbUmOFOelKDb
lCjltbOVE7oBOmAMYTw2o1moWpOEScpET9Ow5Okjg16I+74/xLe8ud7RUNOs7R0c
Th+tLky6kMCZ+U1n93mHKkR/IThW0+T0ZKmK4erJ2jfijmRyO0gkfiX7cF5amZE1
7TNfkJPevo9F1fhaJbyHarGMH4LWndFS114l5eeUlfDYo/vNBuCnS1XNG2ZeHYG5
6ztMHEJZ4zr+nPmv28i48l0KiSgCdkOjaj/0U4SN2HKTngUrnqd96S78wSUr2kO/
u5qNmKD77sfitYzCaeBCpoMBGiIGur3r1Bmg2+aP7NYb1LhSChhDUa39pYdvQSXT
6n7Pdge+NMKsGSWnktp4g/LKSaorXCcj0CuX1XBqfxq1LykhCF8SN/Kbv8q6ffuN
S89uTpGEbhGRGKEiDKooDaQG9lEEkj/EX0AUanyoKlC7sMk239Dt8OQjQZu202gg
vM+QdY97ut7BSx04LJlDdhjjxx5WmOsvygHNkxZ1CPbu1JX6J7w=
=N7cI
-----END PGP SIGNATURE-----

--4Wcu3uPC65WqUq/x--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
