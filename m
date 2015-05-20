From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mad: Clean up ib_find_send_mad to use only the
 ib_mad_hdr
Date: Wed, 20 May 2015 12:50:09 -0400
Message-ID: <1432140609.3114.87.camel@redhat.com>
References: <CAJ3xEMjtndfHJOh-JSTzaXuXTNrx2wzDkBcS67T6AwFztcckgQ@mail.gmail.com>
	 <20150514173557.GB10941@phlsvsds.ph.intel.com>
	 <555ABF9E.6010502@mellanox.com> <1432054868.3114.67.camel@redhat.com>
	 <20150519182730.GA6737@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-jSyFc8MHU5gQfu3kohhp"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150519182730.GA6737-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-jSyFc8MHU5gQfu3kohhp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-05-19 at 14:27 -0400, ira.weiny wrote:
> > >=20
> > > 6f430b IB/mad: Add const qualifiers to query only functions
> > Ok
> > > 67b3b05 IB/mad: Clean up rcv_has_same_class
> > Ok
> > > fcd6ebf IB/mad: Change ib_response_mad signature to take const=20
> > > ib_mad_hdr rather than ib_mad
> > IB/mad: Change ib_response_mad signature arguments
> > > 3b53339 IB/mad: Change validate_mad signature to take const ib_mad_hd=
r=20
> > > rather than ib_mad
> > IB/mad: Change validate_mad signature arguments
> > > b78d28a IB/mad: Clean up comments in smi.c
> > Ok
> > > c597eee IB/mad: Rename is_data_mad to is_rmpp_data_mad
> > Ok
> > > 81836bc IB/core: Change rdma_protcol_iboe to roce
> > Ok
> > > 6f9ab33 IB/core: Convert management helpers to core capability bits
> > IB/core: Convert core to use bitfield for caps
> > > 23ceb15 IB/core: Formalize the creation of immutable per port data=
=20
> > > within the ib_device object
> > IB/core: Add per port immutable struct to ib_device
> > > cb3ed7b IB/user_mad: Fix bug in ib_umad_remove_one when rdma_cap_ib_m=
ad=20
> > > implementation changed
> > IB/user_mad: Fix buggy usage of port index
> > > 42997f2 IB/user_mad: Remove local start/end port variable and use the=
=20
> > > new common functions
> > IB/user_mad: Use new start/end port functions
> > > 0cf18d7 IB/core: Create common start/end port functions
> > Ok
> > >=20
> > > Maybe submit them all again with more proper commit titles? it's not =
too=20
> > > late, Doug, what's your
> > > thinking here?
> >=20
> > I try to stick within the recommended length of git log subject as
> > indicated to me by vim when I'm editing my commit messages.  Whatever
> > happens to fit inside that limit (or at least close to it, I'm not a
> > real stickler on it) I go with unless you really need to capture some
> > important detail in the subject.
> >=20
> > However, there's no need to resubmit these.  I can always edit the
> > subjects in place.  Ira are you OK with the changes I made above?
>=20
> Yes thank you.  I will do better in the future.

No worries.  They're all edited.  I changed just a couple of the more
detailed descriptions too, just because once the subject was simplified
the body deserved a little more explanation.

>=20
> Ira
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-jSyFc8MHU5gQfu3kohhp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVXLtBAAoJELgmozMOVy/dXWUP+wdtxHcXy72Za3afZPMLP97+
tEVo4g2WuLgaRGfwUxCT74LsC2rQAeJW7E+c12v0GDIPlZE1IUY0SGbEX7J9I3pK
X+YUZm2y2/LHsLn9xf0uVlExhSnFIJxqq5ZR6I95p7D2h4KLOdS8bEO+N2MEZ7Ju
0OPBQX5pYOO8TGVXDRLCyb3wbkMFSbnxVAvGRHOUHHsZYeoBmHiNqKwN8F7XM7Hp
lYb3nEKmuAZh09wzER5TGaTgGEEA7d0G4bFrZc4R/Ikv6DxN5xedXgw50UMAkV/W
Rl0s92JsywU0s38OUzbswaVfZAxg8GnHSJV0wg5yTp1vAlrdLJm+sj3SPHf26NnC
zqXbZ+RXn0wDbepfhcIm9PPaLyrHfiZC74qWog3Byi8Qeg75eUAeCr93CL2Dd918
58p1wKR2TzLP55EGPQgDDpoVxS6oLT8H9nCt5StCGQxsOJGhE1YXFQJ9VfaU9M8A
7OORxMgpVPWlwrKEprQXM+qn5VBN+BG4Q8HyZzonU+odltJVjM/kNKoY/Phe/c24
pkcn406AiHQHk5v/voMKAC8e+Sht8eo2UCYW7He2Jz5r4kl1Hz6y3X8BK5Gr88CE
xNczGL0SP8SHiRsUjy2AU7/tCmccNgAhk03Ju/4fPpUBo+d+0tD5l5YjQeIgJSCC
UWcunefUZwJGLdHQ8W2+
=fSAK
-----END PGP SIGNATURE-----

--=-jSyFc8MHU5gQfu3kohhp--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
