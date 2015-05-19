From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: rdma kernel tree
Date: Tue, 19 May 2015 15:49:53 -0400
Message-ID: <1432064993.3114.80.camel@redhat.com>
References: <1828884A29C6694DAF28B7E6B8A82373A8FD8CF5@ORSMSX109.amr.corp.intel.com>
	 <1431485563.43876.93.camel@redhat.com>
	 <CAJ3xEMhRY6nLPFR8qT8S7KJvxRDmw6JwhsSKw7pTvFc5PpnrhQ@mail.gmail.com>
	 <1431530845.2377.30.camel@redhat.com> <5554B7E8.4020902@mellanox.com>
	 <1431615776.3276.14.camel@redhat.com>
	 <CAJ3xEMjgpegf+D2BBZ8RPERkdUO3yH4U1LjiK+i4iF=_PtpQkA@mail.gmail.com>
	 <555ABD9D.3080303@mellanox.com> <1432038160.3114.16.camel@redhat.com>
	 <CAJ3xEMjkECDrbCFksSMMTSUusOhrU+qvMnXjkg=OuFaeYKoT0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-hrCngxald3DeDxPJiZo+"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMjkECDrbCFksSMMTSUusOhrU+qvMnXjkg=OuFaeYKoT0Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-hrCngxald3DeDxPJiZo+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-05-19 at 21:47 +0300, Or Gerlitz wrote:
> On Tue, May 19, 2015 at 3:22 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> > On Tue, 2015-05-19 at 07:35 +0300, Or Gerlitz wrote:
> >> >> I pulled that via a bundle from patchworks.  I'll double check it.
> >> > Did  you check it out? fixed it out?
> >>
> >> I took a look now, you've rebased to-be-rebased/for-4.2 to 4.1-rc4 and
> >
> > Correct.
> >
> >> it seems this is what you are going to push into the kernel.org treem
> >
> > Correct.
> >
> >> but this series is still there with the zillion tested/reviewed/etc
> >> signature per one 2-3 patch, I think we've agreed this needs to be
> >> addressed prior to the upstream push, right?
> >
> > Incorrect.  What you objected to before was the large Cc: list in the
> > patches.  That is gone.  What is there now is just the reviewed-by: lis=
t
> > of three people, and the tested-by list of two people.  As the entire
> > patch set as a whole was reviewed and tested by those people, it seems
> > accurate to me.
>=20
> Doug, I have never ever seen a patch set (specifically the 15~23 part
> of it) with that level of simplicity

That portion of the patchset didn't start out with that level of
simplicity per patch, it evolved to that because it made review
*significantly* easier.  It's very simple to review a patch that does:

Add 1 helper
Replace tests in code with just that 1 helper

because you can scroll through that patch and know that every line being
replaced is related to that one helper.  If you want to know every line
that was replaced with rdma_cap_iw_cm, you go to that one patch and it's
all listed very easy to read.

On the other hand, when you squash all those patches together, review
becomes much harder because if you want to see what a single helper
does, you have to sift through all of the other helper changes and hope
you find the right ones, and that you found all of the right ones.

>  and
> signature/reviewers/tested-by/etc inflation.

I added those myself as part of an automated addition.  It applied to
the entire series, so it was put on each patch.  The people that
tested/reviewed the series did not do so to individual patches, they hit
all of them.  And as was pointed out a couple of weeks ago on an earlier
patchset I picked up, it is generally good behavior to give attribution
where it is due to encourage people to participate.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-hrCngxald3DeDxPJiZo+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIbBAABCAAGBQJVW5PhAAoJELgmozMOVy/ddU4P+LGRFFv+GULjtLGiLo/Nb1eP
FS2eq2Fn6to2B7t4yqsBG+5rdpwc/Cax3G7b/pRyvpv4McA8HO092sEElOpOsCV4
tpdFnAd1dm6KeWjU1TfLTRjQAZiZ1zWe7CQ/CEPM7vpi8FD+fS/vKfAyWfMfZzMP
jGeHsf/daWtx5nY3ajh3Dgopq9BPna1bavA8BjGkg8lGKxd1i7L3jal3ZDxCJOkb
0N7BqLTCLNrCNY6BBIWQdQMSIMcDS+98EL2lDTJ/1DZ2OSAXsHNLw3LfZsS9htiT
rJyaybEcBJ0wWEqZFtIbMvn0xpt67K2TOm3kLhcqdPqWU3ri1197UuievmEw+M+x
qqwqtt9zz7v4kagu4criZB+pSkyMKRyJNN6aIIQnTnl+tP3PmtPVlfGwiTapMbae
CVFB/FHvwmq+iQcRcfET9WX4Q8ZjbbodBD8swbSVc1bvi/OowAqbm911KVj5wNKc
KC+ELBALqnKssiOUh57S5+6jNsTBhkAJjy+ttMZiGkW2WszpHqNU+vDN2ANGMbO8
esErWrZOQg2CCkRIyjwbVsvBsFO/p4dtMdBk8WSJFuLPiaPOQAH+84Aclq/ak9B2
Gq5GWM6ijzPBhzjEfpVGil1hFIi+1E8igKykYw+7J1UqWuxm7YdaNhXOmGaJ48iJ
aKhb02l4JyKcFsXndyE=
=f4tb
-----END PGP SIGNATURE-----

--=-hrCngxald3DeDxPJiZo+--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
