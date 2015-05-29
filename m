From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3] Add const to various core functions
Date: Fri, 29 May 2015 11:48:53 -0400
Message-ID: <1432914533.114391.88.camel@redhat.com>
References: <1432240824-3277-1-git-send-email-ira.weiny@intel.com>
	 <20150529041313.GA1603@phlsvsds.ph.intel.com>
	 <1432904099.114391.61.camel@redhat.com>
	 <20150529151735.GA5372@phlsvsds.ph.intel.com>
	 <20150529153231.GA10432@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-WF9Gka93VJurw8v/afCY"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150529153231.GA10432-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-WF9Gka93VJurw8v/afCY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2015-05-29 at 11:32 -0400, ira.weiny wrote:
> > >=20
> > > Double check that they stand on their own.  If they do, I'll review t=
hem
> > > separately.
> >=20
> > They do stand on their own and they are improvements even without the O=
PA code.
>=20
> After responding to this email I found a 0-day build email which shows a
> build warnings on this patch building ehca on PPC:
>=20
> IB/core: Add const to device process_mad
>=20
> I'm not sure why but sometimes my 0-day build results are delayed for qui=
te
> some time?  I'm guessing the servers prioritize kernel.org over github
> accounts???  Or I'm just doing something wrong...  :-/

I've seen that too.  I can't tell you what the issue is.

However, I should take this to mean there is a both a v2 of this series,
and a new OPA series on the way?

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-WF9Gka93VJurw8v/afCY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVaIplAAoJELgmozMOVy/dB2QP/1hZX8XMEkXygA5+zC8GhKt1
+KQ8gURw0/HTIr7T9vCLYOiECcHh2Ylx+fXBRNJsvdAPFpPU6pgmWjgI3rgs6wHk
M/+Ik00EzTkepI7FnUfyf3zAukaCZ1D0eb3cbqwkn4wHXR3MUVrJNxhDahoCm9s0
5X3XneIvpAhHDs83MkRdxkIC6N5/KmE3UUpETjm9nbP/m5wkXHA0nA9qb+W50NiI
FwkSHgrYWEcmt9T8Sic3UtOCqNP4DpiEJVowDJpQcmRsgmcn1+VKUsNNZSA0CR1o
M3LkUM/gjTeU2wLWMBhqiVBj0957fj/UXChZxzxSCB6EPp+9aPUDdNEBhRE4QNUa
3hzO6+egtoCxHYOa9BTZxM9YIynAkmsNUHMK2fnVzcRSA2aD8u5Fzwo8SLR5Q9yB
Epj1aDrdT1JgKPxiYTgqGDa+tHnBNeQ/JmPw0XiUbSaR75ilk9ldTMu1aJm0QfQb
E30thBV88C6ZVgap4oic5n1WCZ/rqnEEyCk4k5nNwm/zEhjn7XbHyGOrtHLIRgui
N8XtOLUEcOKG1Aa1i3VgvyJmrdijMQA7N33lkKitnGoD8OJBJygURn4hFcEUFy8A
jE1ioCsko6FDWJULFNhWQARqYfth+mpfgpAmvs5P9kuoxAzvzZxNgjhDRlXKYDAF
bteWY7gciZpfGj37myHO
=AYmz
-----END PGP SIGNATURE-----

--=-WF9Gka93VJurw8v/afCY--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
