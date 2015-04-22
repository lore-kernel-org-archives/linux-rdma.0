From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 2/2] IB/qib: use arch_phys_wc_add()
Date: Wed, 22 Apr 2015 12:57:18 -0400
Message-ID: <1429721838.45956.142.camel@redhat.com>
References: <1429653035-19424-1-git-send-email-mcgrof@do-not-panic.com>
	 <1429653035-19424-3-git-send-email-mcgrof@do-not-panic.com>
	 <1429710878.45956.94.camel@redhat.com>
	 <20150422153348.GD5622@wotan.suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-6K3VQHVtfiGWyIVCnpTZ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150422153348.GD5622-B4tOwbsTzaBolqkO4TVVkw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>
Cc: "Luis R. Rodriguez" <mcgrof-3uybbJdB1yH774rrrx3eTA@public.gmane.org>, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cocci-/FJkirnvOdkvYVN+rsErww@public.gmane.org, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, Rickard Strandqvist <rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Suresh Siddha <sbsiddha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Antonino Daplas <adaplas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>, Tomi Valkeinen <tomi.valkeinen-l0cyMroinI0@public.gmane.org>Dave
List-Id: linux-rdma@vger.kernel.org


--=-6K3VQHVtfiGWyIVCnpTZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-04-22 at 17:33 +0200, Luis R. Rodriguez wrote:
> On Wed, Apr 22, 2015 at 09:54:38AM -0400, Doug Ledford wrote:
> > On Tue, 2015-04-21 at 14:50 -0700, Luis R. Rodriguez wrote:
> >=20
> > This:
> > > +	/* MTRR was used if this is non-zero */
> > > +	if (!dd->wc_cookie)
> > >  		vma->vm_page_prot =3D pgprot_writecombine(vma->vm_page_prot);
> >=20
> > And this:
> > > +		dd->wc_cookie =3D arch_phys_wc_add(pioaddr, piolen);
> > > +		if (dd->wc_cookie < 0)
> > > +			ret =3D -EINVAL;
> >=20
> > don't agree on what wc_cookie will be on error.
>=20
> Can you elaborate? The one below is the one that starts things,
> and arch_phys_wc_add() will return 0 on PAT systems. For non-PAT
> systems it will return a number > 0 *iff* a valid MTRR was added.
> It will return negative onloy on error then.
>=20
> The change above is meant to replace a check put in place to see
> if PAT was enabled. The way we replace this is to ensure that
> arch_phys_wc_add() returned 0.
>=20
> If you disagree it'd be great if you can elaborate why.

Maybe I'm missing something, but in qib_enable_wc() you store the return
from arch_phys_wc_add into wc_cookie.  That return is negative, so you
return from qib_enable_wc() to qib_init_one(), they see the ret value,
they print out a warning about bad performance, then they clear the
return value and continue with device initialization.

In all of this though, wc_cookie is never cleared and so it still has
the error condition in it.  Then, much later at run time, you call
mmap_piobufs() and you check the contents of wc_cookie, and if it's
non-0 (which is still will be), you do the wrong thing, right?  And what
about at shutdown when you call qib_disable_wc() and your cookie still
has an error code in it as well?

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-6K3VQHVtfiGWyIVCnpTZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJVN9LuAAoJELgmozMOVy/d3pcQAK6Mz/ourl/oMCPKVwftAKjY
OAwAkmc42nP6olCGP9SJ1tN0W5yTHMjBuE/JVfvR/Uq2YwIudMC5odtUBnX9vZ1M
JGtlJq2jaXxLAa1jRZMQvbEPpjyDjx0WojbALgyNwrkbxewrmBUSeapKAy9wZWNC
5uLxDppwIBrux4XITUCMjVuLsxq8Rl8MViLGvGXskJyDieDe3y515F1gcWr/x3ie
jToi83vFHffdo7w32pkIcbXN+//RZdC3ErUviANjQcY/eT/8CYeMp5M607JuMZPW
Mv479q09+U3lL9/hVyU/z6QpCQyJqcPy7uTtbLAhmBSYZOw5UBR8O1KnQ47+gobI
btbFj3i6H/eBdBybxVi4EIjcffAkIyLmBrxukFIX51FTjmM2QUldMuyK8foQjXVF
dyowAsiCK1pZlQrZXvS1e6fQiIWc4ZccDXs8IiuljhHqmYLCwQvQGa+aoLUnyXp9
ks5EabrE4ERqQuyEp+aYnJQTv/ovtFbzm3hqdCGKKSuYK7IF+N5k+rBZGeqOu8RR
9iisGRhnbT168Jv583zZNaD+CAOami3sVSJULbEXhmOX+YGMKwqsX6DdZNXQYouq
J2YzG5hhHbXzF3SzDt371afOkxJV832fTJ+ngECv655ZmSNo9hyPkrEI4+ZY/kqD
Rznz5ZOwFtkqF5A5Ivk1
=CIyr
-----END PGP SIGNATURE-----

--=-6K3VQHVtfiGWyIVCnpTZ--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
