From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: rdma kernel tree
Date: Tue, 12 May 2015 22:52:43 -0400
Message-ID: <1431485563.43876.93.camel@redhat.com>
References: <1828884A29C6694DAF28B7E6B8A82373A8FD8CF5@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-7UOLvBGnB8ceXx4L1Mjq"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FD8CF5-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-7UOLvBGnB8ceXx4L1Mjq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-05-12 at 21:31 +0000, Hefty, Sean wrote:
> Doug,
>=20
> Do you plan on only using your kernel.org tree going forward, or will you=
 maintain your github tree as well?

I plan to keep both repos.  The one on github will have stuff sooner,
but it is likely that portions of it will see rebases.  I've taken to a
very obvious branch naming scheme if I think that I'm going to rebase a
branch.  I'm also keeping the github repo as the one I have in the 0day
testing framework so that more of the stuff gets tested sooner.

When I'm satisfied that a branch has passed all of the 0day testing and
I'm no longer going to consider any changes to the patches in that
branch, then I'll make a k.o/<branchname> branch and I only push those
branches to the kernel.org repo.  Once a branch lands there, it is a
fast-forward only branch and will not see any rebases or edits of
patches.

I'm doing this because of the large number of interrelated patches that
different people are working on right now.  This makes it easier for
people to be able to base their work off of the latest interrelated
patches from other people.  Once this backlog clears out, it might be
possible for me to drop the github repo.  Right now it's the only way I
have to provide the sort of early access sandbox that people need to get
their patches in without taking too many consecutive release cycles.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-7UOLvBGnB8ceXx4L1Mjq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVUrx7AAoJELgmozMOVy/dmE8P/RGjaW6b1n3d65099/KlwKBf
wAM3lijC45kTx4nAjb2TYilQ0idMnIbw98+TZ9ptRrrZk1P3ol+lIXWdv0+paxPl
OlW30a8frmVd3+yFQ/QF+brrtSlePC5K+G34qpHHLVw1gLZ+1wetb5795rEBYfEQ
BFok9I6MXfshRKceBfrUMqi6qdtkpaCYi2vY+aiXyVeHmYvaJ5jmWPq3ObYzdSqo
hlZPknGaxZwJk3w+/XN0NdyIOqcZkWnNi8pOMPtgR2l5RgHnyKsZdBO/WRbYmWVk
F6+22yoYe9BYjLA0/C7MEY7KMfxNQg4iXRyBv7JNhJTS2siOvw9O8g3xAQiy3ON0
nKFMMZ965lYAn+1lIaIxUQD0MplRrAXtye0z5RqniCNjMIfBO8WC5AFc/f/ICl8u
xqyPBFamzhJPBcMKLSvIlK/wTYXtkY2rl2wqdH9PzBVmCSb0HRsoGHsNZl4EN7wi
+GzZh9JW/HX5OjB3+sEceVxQYoneFp3lGGZux5blAQLt5Ssd+3X1Dj6RSjAgvkc7
aNhuNAZrPLK/9uECL7dkvR/LnjoD9+rQ+smIwwIBlwLTrYViP8glwqHs5nZyKyk7
0/J+LXwSE78Ar1tGbYD7OkdB2aYNRDJ3l2PuLzmwB74t5ufXNLQBFTpjRk/f9UYm
qKtYAUOT742gI2reL6NV
=pgye
-----END PGP SIGNATURE-----

--=-7UOLvBGnB8ceXx4L1Mjq--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
