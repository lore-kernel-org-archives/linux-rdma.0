From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/2] iwarp device removal deadlock fixes
Date: Tue, 02 Aug 2016 13:24:16 -0400
Message-ID: <1470158656.18081.17.camel@redhat.com>
References: <cover.1469824577.git.swise@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-0L/8wMhFA3EvAiSlp4PT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1469824577.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-0L/8wMhFA3EvAiSlp4PT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2016-07-29 at 13:36 -0700, Steve Wise wrote:
> This series fixes the deadlock issue discovered while testing
> nvmf/rdma
> handling rdma device removal events from the rdma_cm.=C2=A0=C2=A0For a
> discussion
> of the deadlock that can happen, see
>=20
> http://lists.infradead.org/pipermail/linux-nvme/2016-July/005440.html
> .
>=20
> For my description of the deadlock itself, see this post in the above
> thread:
>=20
> http://lists.infradead.org/pipermail/linux-nvme/2016-July/005465.html
>=20
> In a nutshell, iw_cxgb4 and the iw_cm block during qp/cm_id
> destruction
> until all references are removed.=C2=A0=C2=A0This combined with the iwarp=
 CM
> passing
> disconnect events up to the rdma_cm during disconnect and/or qp/cm_id
> destruction
> leads to a deadlock.
>=20
> My proposed solution is to remove the need for iw_cxgb4 and iw_cm to
> block during object destruction for the refnts to reach 0, but rather
> to
> let the freeing of the object memory be deferred when the last deref
> is
> done, which is SOP in the much of the linux kernel. This allows all
> the
> qps/cm_ids to be destroyed without blocking, and all the object
> memory
> freeing ends up happinging when the application's device_remove event
> handler function returns to the rdma_cm.
>=20
> This series is needed along with Sagi's fixes from:
> https://www.spinics.net/lists/linux-rdma/msg38715.html
>=20
> Hey Faisal, it would be great to get some review/test tags from Intel
> on the iw_cm change.=C2=A0=C2=A0Thanks!
>=20
> Changes since v1:
>=20
> - reworded commit text for the iw_cm patch
>=20
> - added a iw_cm_id flag to drop pending events when the cm_id has
> been marked for destruction.
>=20
> ---
>=20
> Steve Wise (2):
> =C2=A0 iw_cxgb4: don't block in destroy_qp awaiting the last deref
> =C2=A0 iw_cm: free cm_id resources on the last deref
>=20
> =C2=A0drivers/infiniband/core/iwcm.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0| 54 +++++++++++-------------
> ----------
> =C2=A0drivers/infiniband/core/iwcm.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A02 +-
> =C2=A0drivers/infiniband/hw/cxgb4/iw_cxgb4.h |=C2=A0=C2=A02 +-
> =C2=A0drivers/infiniband/hw/cxgb4/qp.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0| 21 ++++++++-----
> =C2=A04 files changed, 33 insertions(+), 46 deletions(-)
>=20

Series applied, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-0L/8wMhFA3EvAiSlp4PT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXoNdAAAoJELgmozMOVy/dUEsQAJemf7+SZiJLqOQmDFbbPTZ7
NcO3G5v4UEMzoD+Za0HZZu8hDQVwX5P/lc1Clm2o1cwK7vEodeGKOnQ7SDZa/b1j
3knjlE7H4fEmMydjO5xN3ZzaCI1GUOhprdIaaKeCwmqFghcGqfxC+BkFxNXozfAd
O832QykOA42W97vvys8ZRGKK4p07RAF1aYGhTabN9w4A85H3hh4plvgR+f4yjpKl
dEe0+MK4ylSAWZCkQ2WvItFiP2f6L9P2qlRuWRf0Wecxrxehbpn2bS6epit6bLo1
4Jq6lSd45P4hHvfD4D4w+TIH44yMIOieXBGWSo/LMERVOJPe+kP9m0b4ClqqWWc1
iP2uQKuMIYqMnO8ESCFS5H//UvlUTMt0jCcelUQmVr1Df0w7woFcIxdb9gUUnci1
MRY82Sw/EHgTo9V3vd3NPpORpVAkqCjnV2YI80YymUyO+HMV5ftZw04Y5EyGjIUC
CDNt8Rx2gv15AG0xUm4TQgilsoTS1JykbPafxh5t8TyU2d6ed7XPBoy9Pg0lWixy
g5arjzznmzrj8fyKS8P5YmenOU0kR2yaB9p/CkmK1l1uj4AU/pUT8lFJx9zdIpQn
962i3zi21tYqEN3SNHEd2wtXwAeUiinPk6zU7WeQV0KitqnxBJwnfDZ0g9mwYVxG
4yUouo6rJBn9fSA7C5nS
=ViAG
-----END PGP SIGNATURE-----

--=-0L/8wMhFA3EvAiSlp4PT--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
