From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v4 2/2] IB/qib: use arch_phys_wc_add()
Date: Wed, 22 Apr 2015 13:48:27 -0400
Message-ID: <1429724907.45956.165.camel@redhat.com>
References: <1429653035-19424-1-git-send-email-mcgrof@do-not-panic.com>
	 <1429653035-19424-3-git-send-email-mcgrof@do-not-panic.com>
	 <1429710878.45956.94.camel@redhat.com>
	 <20150422153348.GD5622@wotan.suse.de>
	 <1429721838.45956.142.camel@redhat.com>
	 <20150422173728.GJ5622@wotan.suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-mUb+md5QGxnoy+1rVFBw"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150422173728.GJ5622@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, infinipath@intel.com, roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, luto@amacapital.net, mst@redhat.com, linux-kernel@vger.kernel.org, cocci@systeme.lip6.fr, Toshi Kani <toshi.kani@hp.com>, Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Roland Dreier <roland@purestorage.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Suresh Siddha <sbsiddha@gmail.com>, Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>, Juergen Gross <jgross@suse.com>, Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Airlie <airlied@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Antonino Daplas <adaplas@gmail.com>, Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>Dave
List-Id: linux-rdma@vger.kernel.org


--=-mUb+md5QGxnoy+1rVFBw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-04-22 at 19:37 +0200, Luis R. Rodriguez wrote:
> On Wed, Apr 22, 2015 at 12:57:18PM -0400, Doug Ledford wrote:
> > On Wed, 2015-04-22 at 17:33 +0200, Luis R. Rodriguez wrote:
> > > On Wed, Apr 22, 2015 at 09:54:38AM -0400, Doug Ledford wrote:
> > > > On Tue, 2015-04-21 at 14:50 -0700, Luis R. Rodriguez wrote:
> > > >=20
> > > > This:
> > > > > +	/* MTRR was used if this is non-zero */
> > > > > +	if (!dd->wc_cookie)
> > > > >  		vma->vm_page_prot =3D pgprot_writecombine(vma->vm_page_prot);
> > > >=20
> > > > And this:
> > > > > +		dd->wc_cookie =3D arch_phys_wc_add(pioaddr, piolen);
> > > > > +		if (dd->wc_cookie < 0)
> > > > > +			ret =3D -EINVAL;
> > > >=20
> > > > don't agree on what wc_cookie will be on error.
> > >=20
> > > Can you elaborate? The one below is the one that starts things,
> > > and arch_phys_wc_add() will return 0 on PAT systems. For non-PAT
> > > systems it will return a number > 0 *iff* a valid MTRR was added.
> > > It will return negative onloy on error then.
> > >=20
> > > The change above is meant to replace a check put in place to see
> > > if PAT was enabled. The way we replace this is to ensure that
> > > arch_phys_wc_add() returned 0.
> > >=20
> > > If you disagree it'd be great if you can elaborate why.
> >=20
> > Maybe I'm missing something, but in qib_enable_wc() you store the retur=
n
> > from arch_phys_wc_add into wc_cookie.  That return is negative,
>=20
> If and only if the system was non-PAT and mtrr_add() failed.
>=20
> >  so you
> > return from qib_enable_wc() to qib_init_one(), they see the ret value,
> > they print out a warning about bad performance, then they clear the
> > return value and continue with device initialization.
> >=20
> > In all of this though, wc_cookie is never cleared and so it still has
> > the error condition in it.  Then, much later at run time, you call
> > mmap_piobufs() and you check the contents of wc_cookie, and if it's
> > non-0 (which is still will be), you do the wrong thing, right?
>=20
> Originally the code had it to run pgprot_writecombine() if PAT was going =
to be
> used. After the code changes we check for !cookie which will be true when
> cookie is 0 only. In case the cookie was an error, that is if mtrr_add()
> failed, then this code would not run because (!negative) is false. The go=
al was
> to trigger a run if the cookie was 0, which can only happen if PAT was en=
abled.

OK, the logic works, but as much as anything, it's the comment that's
misleading.  The code would be clearer with a comment like this:

/* We used PAT if wc_cookie =3D=3D 0 */
if (!dd->wc_cookie) {

That would be more accurate as well since the original comment didn't
account for the possible error code in wc_cookie, so it's possible you
didn't use either PAT or wc if you have that error code.

> Please let me know, I'd like to get this right too.
>=20
> > And what
> > about at shutdown when you call qib_disable_wc() and your cookie still
> > has an error code in it as well?
>=20
> Well fortunately arch_phys_wc_del(negative) and arch_phys_wc_del(0) will =
be
> a no-op. Its what helps us remove so much clutter.

OK.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--=-mUb+md5QGxnoy+1rVFBw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJVN97rAAoJELgmozMOVy/d9Y8P/07TkWrVkEoMDEsXnLTYVNoq
j9svu9XpPvwG29YrUpo+R4jxsTQDyT8R4nHR9yNfHhhLqUbBsLDsnmV2qqSIZ5x4
O4Kkq3jRR6AQd6i0D+1Z5Dt7CAeVvVmOEDL1cxlPb8lVDkv+PDk78kpll6xk6zuJ
l4yc50Nft/bih7UWS3mBf9CIm32uZnE2FRR1OyY3dWNBXHm9pMCF4NFZ2knZksKI
pdfyj9p8Ou1/81bZQhj9vEY9EBZmUf5wBjnYiXu3fivB6wyHRtT9fxTfWLamh4Br
QsX3oOdzoX+t4s+/v5CCQgUxSmOvnMTZcun6NsP/6y3YncoYphElSwnpQYYtoVvl
KNzR4Rz/FNdomFIuKOkHx+5h6cESWw+nYdgXBdH3q2EfSzmYeMRw7/9+ujg2O2Vz
wCanomKr6UuhjrcU5A7Ik16CAY+QRDkCUzSHftYOI8/1RnP7bX6U7uAox+8uauyO
IJZTt3TKL73b8R1kWY1DJTXmVXo0fNPDfjMswBNozGfz5nAnAQcWHvbSkA4Wg0Aa
BStoCDY42k4K032ex7ZYcJ83hc9CQqAoXhS2dXng30FhsBJb5O9tj2NK/t1yuV/X
MZFKXKc8Z5R9HnIYAcsCsiqEs3xYEffaYRntPHhVPqloMNpU5tMmp2xDP4ALJrPj
QRmDchWCzTM2KNc1JfbL
=niM5
-----END PGP SIGNATURE-----

--=-mUb+md5QGxnoy+1rVFBw--
