From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/16] Fix SDMA/TID caching code
Date: Tue, 02 Aug 2016 23:04:13 -0400
Message-ID: <1470193453.18081.55.camel@redhat.com>
References: <1469733687-31738-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-S/ay/3RmiOLFml7zDMqb"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469733687-31738-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-S/ay/3RmiOLFml7zDMqb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2016-07-28 at 15:21 -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> This series fixes a number of bugs found while debugging the use of
> the
> mm_struct "current->mm".=C2=A0=C2=A0When PSM jobs were stopped unexpected=
ly
> (for example
> control-c) it was possible for the wrong mm struct to be used in
> mmu_notifier_unregister.=C2=A0=C2=A0This was causing memory corruption.=
=C2=A0=C2=A0In
> addition, a
> number of might sleep conditions were found when mmap_sem needed to
> be taken
> while a spinlock was held.
>=20
> The following are stand alone fixes which can probably be reordered
> if
> necessary:
>=20
> 	IB/hfi1: Prevent null pointer dereference
> 	IB/hfi1: Use the same capability state for all shared contexts
> 	IB/hfi1: Validate SDMA user request index
> 	IB/hfi1: Validate SDMA user iovector count
> 	IB/hfi1: Release node on insert failure
> 	IB/hfi1: Fix error condition that needs to clean up
> 	IB/hfi1: Fix user SDMA racy user request claim
>=20
> The use of mm and locking issues are fixed with the following commits
> (they
> depend on the previous commits and must be ordered among themselves):
>=20
> 	IB/hfi1: Make use of mm consistent
> 	IB/hfi1: Make the cache handler own its rb tree root
> 	IB/hfi1: Fix TID caching actions
> 	IB/hfi1: Add evict operation to the mmu rb handler
> 	IB/hfi1: Use evict mmu rb operation
> 	IB/hfi1: Consistently call ops->remove outside spinlock
> 	IB/hfi1: Remove unneeded mm argument in remove function
> 	IB/hfi1: Fix memory leak during unexpected shutdown
> 	IB/hfi1: Add cache evict LRU list
>=20
> Special thanks to Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org> for suggestions on
> how to fix
> the main issues.
>=20
> This series requires the clean up patch series sent previously.

Thanks Ira, series applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-S/ay/3RmiOLFml7zDMqb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXoV8tAAoJELgmozMOVy/dHX0QAIABMvzgiOhzXq3CY7UnDEO0
WbgWfH8sh9LhnBHB3D83q70d9aEMLyguoWASEXQPPnY+AOP2JHGrpz8BR0dPokmq
QestSe28RYg0/CpxFy7hugGeeIOHHgTR6VRkWrb1wY5yWVwc4dVnIOnH3Grnmk5S
bznTHdOedWIf3ADuZY/nMnShtTfQHhDvpq5/ii0ivdgsJqB0Oh3vnjfJtFptttqA
g1J5331Uri6Je70UJ/LC0vN5xgk2AEOlHVX1V/qi5UV2WybiFub1t6f6ML9hUKqs
eFli05uvsF6mVrtBk0D5FgEyD6U0QGCQgag7LMa+ZTbGdQnL/rbni89o3PFY25z7
eqtZYsFU5RDP5Vl9nQbYyT+bfcztjAvD8lEg0ZgUy2oa1wozLdwp5wAwUKkxQSAc
oGKNzZChNd8/+0VOwCRfr6tAvCHpOVjluqKiVU62mTaRJ+Wgt4P3x2ps4geO0cWu
P0CLYpeJBlE2ETiegtKrwL2v+D2n3C44lW6U0entEsnaoJT46DRDK6vFyv3+/wwd
qNGNCkyFS40M1HBu5fs5zA2o0AObBlTAJ/4qgIwMDti65hRJb7Pof9m43tZOlPT9
5HtBHQEVEbN/ucNhqlWodgF5hW5gQEoUJN/0U2qDq4rkcZ3ZQ1nUeAyXZCftUI8Q
B0GuQ9BatekuH18nKW5e
=aTqu
-----END PGP SIGNATURE-----

--=-S/ay/3RmiOLFml7zDMqb--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
