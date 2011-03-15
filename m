From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] rdma/cm: Fix crash in request handlers
Date: Tue, 15 Mar 2011 12:29:49 -0400
Message-ID: <1300206589.19018.1573.camel@firewall.xsintricity.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CC6C536C@orsmsx501.amr.corp.intel.com>
	 <AANLkTinE3hzALRn9=5QOHiZCOGJU8RYm77c2vb_qzW5P@mail.gmail.com>
	 <CF9C39F99A89134C9CF9C4CCB68B8DDF25CCB3A08D@orsmsx501.amr.corp.intel.com>
	 <AANLkTi=O+An6XSFR-jWnYjQzsED63=DRnTBGF=itgAR3@mail.gmail.com>
	 <AANLkTi=jDsCFEsfhT0Vwq2APQKmF5ZYFFV91=rEMUe=+@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ceyWWkMq56Y6FIyRiQ8p"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=jDsCFEsfhT0Vwq2APQKmF5ZYFFV91=rEMUe=+@mail.gmail.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-ceyWWkMq56Y6FIyRiQ8p
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mon, 2011-03-14 at 21:22 -0700, Roland Dreier wrote:
> On Mon, Mar 14, 2011 at 7:27 PM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > Doesn't that mean unprivileged userspace could trigger a use-after-free
> > in the kernel?  (and it might be malicious code, not buggy userspace)
>=20
> >From reading the code a bit, I guess ucma is OK in this area.  I do see
> what seems like an exploitable race in ucma_create_id():
>=20
>  - one thread create an id with an invalid userspace pointer
>    (so the copy_to_user in ucma_create_id returns -EFAULT
>    and calls rdma_destroy_id before idr_remove)
>  - another thread guess the id that is going to be returned and
>    call ucma_destroy_id()
>=20
> if the second thread hits the window where the cm_id is
> destroyed but the ctx is still in the idr, it can trigger a double free.
>=20
> But this is a completely different bug.
>=20
>  - R.

Heh, nice.  This would be a good example of why I prefer that rules such
as "cm_destroy_id/rdma_destroy_id/ucma_destroy_id can only be called
once per ID" be coded into the destroy function themselves and enforced.
As long as you are talking about user space guessing ID's, it is
patently impossible to guarantee that we won't call a destroy function
more than once.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband


--=-ceyWWkMq56Y6FIyRiQ8p
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk1/k/wACgkQg6WylM+/8ZRRngCePv2cq8/QF1Q+lqi93f35OMbK
LZUAnRFPaeo19ms7iLgrl68pdMKEgjDj
=z3O5
-----END PGP SIGNATURE-----

--=-ceyWWkMq56Y6FIyRiQ8p--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
