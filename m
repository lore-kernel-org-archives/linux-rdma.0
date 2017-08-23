From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: small patches to librdmacm
Date: Wed, 23 Aug 2017 19:32:17 +0300
Message-ID: <20170823163217.GU1724@mtr-leonro.local>
References: <C50D9A8A-457A-4DA6-B727-43B77117ED15@lanl.gov>
 <20170823042927.GH1724@mtr-leonro.local>
 <20170823153728.GB22775@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wQ8ANTl3uYPVjUZt"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170823153728.GB22775-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Jeff Inman <jti-YOWKrPYUwWM@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--wQ8ANTl3uYPVjUZt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 23, 2017 at 09:37:28AM -0600, Jason Gunthorpe wrote:
> On Wed, Aug 23, 2017 at 07:29:27AM +0300, Leon Romanovsky wrote:
> > On Tue, Aug 22, 2017 at 01:47:18PM -0600, Jeff Inman wrote:
> > > Hi folks,
> > >
> > > I=E2=80=99m new to this.  Please let me know, if you need a different=
 format, etc.
> >
> > Yes,
> >
> > 1. Please send them with git send-email command, so they will be
> > threaded together.
> >
> > 2. The commit messages should include description and you already have =
it
> > here, just copy/paste to the commit message itself.
> >
> > 3. Fixes lines should be in the kernel format and not hand-made as it i=
s now.
> > The following git alias in your .gitconfig can create the proper Fixes =
line for the
> > specific hash.
> >
> > [alias]
> > 	fixes =3D log --abbrev=3D12 -1 --format=3D'Fixes: %h (\"%s\")'
> >
> > For example: git fixes ac3a949fb2f in the kernel will produce:
> > Fixes: ac3a949fb2ff ("IB/CM: Set appropriate slid and dlid when handlin=
g CM request")
> >
> > 4. No extra space between Fixes and your Signed-off-by signature.
> >
> > 5. Don't forget to add Sean's acked-by.
> >
> > Hope to see it merged.
>
> Since we are so close to a release I made all the required changes and
> sent a PR:
>
> https://github.com/linux-rdma/rdma-core/pull/187

Almost,
The commit sha1 should be 12 digits and not 7 digits.
Please fix.

Thanks

>
> Jason

--wQ8ANTl3uYPVjUZt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmdrhEACgkQ5GN7iDZy
WKeJ3BAAzmYVMg7mvpClAFEWx6jqt1wY6lp0FKsVZdWh+760n7VqvtbJZjxOFnyx
G4oHBGH2HEOSgvcRCTYBOGgLLPwhtrCAPz/vka2Ue2SK8xE1mXaQsnZ1CB+cy5yq
ebTdCtrmdxXlTzZljzcvu5T3Z5aC6Bk2R1AjNcFXszg+1zbgfCbvzjKhQT3yoAqd
pNEd7uHobu232WST2oJUgCZqmeNkYXgO9PrjbFfa9RFjdR68RiCeAIFPfhgkDDrh
DpnplkibifliTjdj5bpF6lK+X00AkL5fZans4ToOQ3pBtq5UffC4CQ75k6zvO50+
6vqCnrIFH4YExvBYTFqiQBi2S0QFRz/sJX24KUDI6AqKcz6zlhBVaDSzz/S8gGHV
ITZUgBg+N4oIm6+56AYZa+hXQrOsTNoKLhBWIgX9uqsGpgsEgH9AwcIRxYTI78d4
jCmbvyc2eN5bj6ZjPmqmzttBZES5sM7KeUVyCkZC1VBn0yn9ojBBrwe9zD4vxCSI
LaK4Df9Kn+9F3fsqEBlWXbhMdid0KYTGD0OTLQ40UFh1dhwutLuConmAezl/3XLI
qCcY3xJACZz5KSr2ZxC3nHTZlZi99RYUgcMQZ6DXvzmLHOeu13smMiP2nhSWoyAE
/mR2cqXtbadpz0VFJU60mZxjo9+0MF5bwhoJxO11dFhRR/V995w=
=DdOn
-----END PGP SIGNATURE-----

--wQ8ANTl3uYPVjUZt--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
