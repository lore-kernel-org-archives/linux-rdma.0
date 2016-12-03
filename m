From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 00/17] Remove debug prints after allocation
 failure
Date: Sat, 03 Dec 2016 13:30:49 -0500
Message-ID: <1480789849.15032.65.camel@redhat.com>
References: <1478184265-9620-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-0fo132aXek6ta1smDPhZ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478184265-9620-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro a <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-0fo132aXek6ta1smDPhZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2016-11-03 at 16:44 +0200, Leon Romanovsky wrote:
> Hi Doug and all,
>=20
> This is semantic cleanup of infiniband stack from printks immediately
> after allocation failure. It doesn't get rid from all printks, but
> only from
> the ones which were found by the following grep construction.
>=20
> =E2=9E=9C=C2=A0=C2=A0linux-rdma git:(topic/clean-alloc-prints) grep -rI
> "[k|v][m|z|c]alloc(" drivers/infiniband/* -A5 | grep "n\""
>=20
> The patchset consists from the 16 almost identical patches and from
> one fix
> which was discovered during the cleanup work.
>=20
> The fix is presented in the patch "IB/core: Release allocated memory
> in cache setup failure"
>=20
> Available in the "topic/clean-alloc-prints" topic branch of this git
> repo:
> git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git
> Or for browsing:
> https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/
> ?h=3Dtopic/clean-alloc-prints
>=20
> CC: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> CC: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> CC: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> CC: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> CC: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> CC: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> CC: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> CC: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> CC: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>a
> CC: Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
>=20
> Changes v0 -> v1:
> =C2=A0* Patch 17: Return brackets removed by mistake.

Sorry, I replied to the v0 thread when in fact I applied the v1
patchset.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-0fo132aXek6ta1smDPhZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYQw9ZAAoJELgmozMOVy/dYxUP/0EsCLrmyFhEV8ehjDrL19TX
ABD2xrUYz6RbAWi1zyeGRnfbhGvg8NuogJuXsgPgq9/NjAodHEcIemN/l9Kp3pI6
riuAB++uKxRWOWvhWLXWbIO+9RzQ3vb2i6KqLNCKFKO1i39RKpXAxqPKm5hDpDSr
jEt6+keZBzEzPB64V2XHXTmlQKHRoxXA4lKfidmuuPAH4gGKDzn+K97xzIf+qU4q
piocceyegc6l6cq9CZTiZ5xURaHCMELH3vMzUyp4MrbDkXD4ouwrWIB7j/lImHjJ
ky8+kVeg03vZwLAyJ9uiN0dUqs0c7H7nZChGLAvgQUOWp6QiredtYcqXoJcRiy2i
shcMUIyx9/2ckC5ix5fxCgIIIqKvTEREcoU3bcSvOgrlKrAdEHbUNP35ZR0FnO0+
2g+QUSTW4p5kqIK9sPFoVNETLegwop0TyZJ9o9Vedb6BEMz1A2ImtGAEpXDzO50b
4DFsiEbed8hQG4Cft1XLZMLKHOe0CSsA/BWz3Bcu9ijOfam1B+RXp+XvCfZ0pqK5
MtT0924VYGdvxhgG36qSB6Eh/Ee2OAsbNi9jP/90itSQyM371su3CLNz5xpSrBku
AD6T8EckKt16fl5mCU835KQeXySzjbpV6BPYiok+Bh/j0eKB3sibIlE8XmWE/bJf
jYRD08p6SrrPe4r6LX52
=ce9/
-----END PGP SIGNATURE-----

--=-0fo132aXek6ta1smDPhZ--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
