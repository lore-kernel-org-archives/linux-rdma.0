From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: rdma kernel tree
Date: Wed, 13 May 2015 11:27:25 -0400
Message-ID: <1431530845.2377.30.camel@redhat.com>
References: <1828884A29C6694DAF28B7E6B8A82373A8FD8CF5@ORSMSX109.amr.corp.intel.com>
	 <1431485563.43876.93.camel@redhat.com>
	 <CAJ3xEMhRY6nLPFR8qT8S7KJvxRDmw6JwhsSKw7pTvFc5PpnrhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-zEBoM1Zm2whSodS8PX1u"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMhRY6nLPFR8qT8S7KJvxRDmw6JwhsSKw7pTvFc5PpnrhQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-zEBoM1Zm2whSodS8PX1u
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-05-13 at 17:46 +0300, Or Gerlitz wrote:
> On Wed, May 13, 2015 at 5:52 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> > On Tue, 2015-05-12 at 21:31 +0000, Hefty, Sean wrote:
> >> Doug,
> >>
> >> Do you plan on only using your kernel.org tree going forward, or will =
you maintain your github tree as well?
> >
> > I plan to keep both repos.  The one on github will have stuff sooner,
> > but it is likely that portions of it will see rebases.  I've taken to a
> > very obvious branch naming scheme if I think that I'm going to rebase a
> > branch.  I'm also keeping the github repo as the one I have in the 0day
> > testing framework so that more of the stuff gets tested sooner.
> >
> > When I'm satisfied that a branch has passed all of the 0day testing and
> > I'm no longer going to consider any changes to the patches in that
> > branch, then I'll make a k.o/<branchname> branch and I only push those
> > branches to the kernel.org repo.  Once a branch lands there, it is a
> > fast-forward only branch and will not see any rebases or edits of
> > patches.
> >
> > I'm doing this because of the large number of interrelated patches that
> > different people are working on right now.  This makes it easier for
> > people to be able to base their work off of the latest interrelated
> > patches from other people.  Once this backlog clears out, it might be
> > possible for me to drop the github repo.  Right now it's the only way I
> > have to provide the sort of early access sandbox that people need to ge=
t
> > their patches in without taking too many consecutive release cycles.
>=20
> Doug,
>=20
> Still, as things are now, you've already accepted patches for 4.2
> which are dependent on other patches which you've accepted too (e.g
> Ira's patches on top of Michael's patches)

Actually, no, this isn't true.  I accepted Ira's cleanup patches, and
they applied cleanly without Michael's patches.  The follow-on patches
to Michael's v8 patchset have not yet been posted since the last round
of review and requested changes.

>  --> @ this point (post
> 4.1-rc3) **something** has to be in your kernel.org branch for 4.2 --
> else the chain of dependencies can become really non-traceable.

They will land at kernel.org when I know they won't change again (which
really means when I have the final kdoc patch and Ira's dependent
patches and everything there is merged properly).  For now, they are
present at the github repo as:

mwang-v8
ira-cleanups
to-be-rebased/for-4.2 (which is nothing but a merge of the two above
branches)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-zEBoM1Zm2whSodS8PX1u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVU21dAAoJELgmozMOVy/dZgcQAI1TkFGFmoRZaq76GSVh8iyb
1bP2ETeAXR2JnfFshzvhMDNy/K6miYjavUw7UhJoRvbpJLaFSgkTRjYV/cW0D+le
DiLszrFB6c1lP7Zzdsv7lKTuJgYN8mDat1JXTjHGPKUvrwp5bCDmdub/bCydv5v6
3Zq8psUSJ5mJ3miI2onO1SF9BCirYlYlrD5DYBWJQtfqG0qkGEE/baKmO8wCFBPn
6XLw1OgChjqQIUuOP1xgR3BDZIJKL1UUr9nLPQeUo6UNvfhIfSs0f2w0sNnq5ejX
BcG+RXGOXlWRyYoLn3O3xVeEsSDBjCIjL5ldEr/X+LuWDc/ie9wXprbZ0OZ6CTQf
TmgiWYlIvGOAMxPPyyyNU81HgfI7rQKZD16p4BsldOynmsYP754fCVam9b2+umF1
QN4lYdlbOU+PYv47v2W8a9B8ZxQSaujZh9kLqm3cQEesbmDa8O5uVmFETf4jJ43/
bbWFJ9iwrQrTsVpsK0xmG9bNz1jH3GgMcH0xON+kwZYZNV07FBrX0j7eYn0mMpv2
OZ+e6PzOE51FWk2M4KC8wM2cyDuCXtBY9IAKYqu8YkBIEe9fxJnAARkMp3Vxzw2N
cXD9DGMzDenjyHIXta18y/pHhJbXMUzbUMCW1O24GG5nAadlA8uRqoMmyOWx/tuL
jQPKdu/TWvz6WKsg5d7E
=r0F1
-----END PGP SIGNATURE-----

--=-zEBoM1Zm2whSodS8PX1u--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
