From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: crash in 4.14-rc1 with IPoIB
Date: Sun, 24 Sep 2017 07:00:12 +0300
Message-ID: <20170924040012.GA21110@mtr-leonro.local>
References: <20170920163237.GD536@obsidianresearch.com>
 <1506101272.5172.11.camel@redhat.com>
 <20170922194834.GA26479@obsidianresearch.com>
 <1506114386.120853.2.camel@redhat.com>
 <20170922211727.GA2348@obsidianresearch.com>
 <1506120161.120853.10.camel@redhat.com>
 <20170923073843.GX5788@mtr-leonro.local>
 <F3529576D8E232409F431C309E29399336CD972A@CRSMSX102.amr.corp.intel.com>
 <20170923172935.GZ5788@mtr-leonro.local>
 <F3529576D8E232409F431C309E29399336CD9762@CRSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <F3529576D8E232409F431C309E29399336CD9762-8k97q/ur5Z1cIJlls4ac1rfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Estrin, Alex" <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Bogendoerfer <tbogendoerfer-l3A5Bk7waGM@public.gmane.org>, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 23, 2017 at 07:20:53PM +0000, Estrin, Alex wrote:
> > > Hello,
> > >
> > > One minor note regarding the original commit 523633359224
> > > that broke the core.
> > > It seem it was let through without trivial validation,
> > > otherwise it wouldn't pass the checkpatch.
> >
> > Can you be more specific? Are you referring to "WARNING: line over 80
> > characters" or to something else? If yes, I feel really bad for you and
> > your workplace.
> Please don't be. Keep doing a great job at your workplace, I will do the =
same at mine.
>
> > Readability is a first priority for the submitted code.
> I can agree with you on that, considering easy readable submitted code
> does not introduce a trivial bugs.

It will be very helpful to everyone if you stop to throw claims without any=
 actual support.
1. Doug allows enough time to respond on the patches and neither you and ne=
ither your
colleagues didn't see such "trivial bug" back then.
2. It fixed another "trivial bug" introduced by your colleague which
broke RoCE (one of the most popular fabric in the stack) and we didn't
cry other the internet about it.

Before you are rushing to reply me, please consult with Denny, he can
give you a short update on how hard the recent OPA changes in AH and
LIDs broke the stack and RoCE/IB devices.

>
> > =E2=9E=9C  linux-rdma git:(rdma-rc) git fp -1 523633359224 -o /tmp/
> > /tmp/0001-IB-core-Fix-the-validations-of-a-multicast-LID-in-at.patch
> > =E2=9E=9C  linux-rdma git:(rdma-rc) ./scripts/checkpatch.pl --strict /t=
mp/0001-IB-core-Fix-
> > the-validations-of-a-multicast-LID-in-at.patch
> > WARNING: line over 80 characters
> > #45: FILE: drivers/infiniband/core/verbs.c:1584:
> > +			if (qp->device->get_link_layer(qp->device, attr.port_num) !=3D
> >
> > total: 0 errors, 1 warnings, 0 checks, 62 lines checked
> >
> > NOTE: For some of the reported defects, checkpatch may be able to
> >       mechanically convert to the typical style using --fix or --fix-in=
place.
> >
> > /tmp/0001-IB-core-Fix-the-validations-of-a-multicast-LID-in-at.patch ha=
s style
> > problems, please review.
> >
> > NOTE: If any of the errors are false positives, please report
> >       them to the maintainer, see CHECKPATCH in MAINTAINERS.
> >
> >
> > >
> > > Thanks,
> > > Alex.
> > >
> > > > On Fri, Sep 22, 2017 at 06:42:41PM -0400, Doug Ledford wrote:
> > > > > On Fri, 2017-09-22 at 15:17 -0600, Jason Gunthorpe wrote:
> > > > > > On Fri, Sep 22, 2017 at 05:06:26PM -0400, Doug Ledford wrote:
> > > > > >
> > > > > > > Sure, I get that, but I was already out on PTO on the 30th.  =
What
> > > > > > > sucks
> > > > > > > is that it landed right after I was out.  But I plan to have =
the
> > > > > > > pull
> > > > > > > request in before EOB today, so the difference between the 20=
th and
> > > > > > > today is neglible.  Especially since lots of people doing QA
> > > > > > > testing
> > > > > > > prefer to take -rc tags, in that case, the difference is non-
> > > > > > > existent.
> > > > > >
> > > > > > My thinking was that people should test -rc,
> > > > >
> > > > > Great, with you here...
> > > > >
> > > > > >  but if they have problems
> > > > > > they could grab your for-rc branch and check if their issue is
> > > > > > already
> > > > > > fixed..
> > > > >
> > > > > They can do this too...
> > > > >
> > > > > But if that still doesn't resolve their problem, a quick check of=
 the
> > > > > mailing list contents isn't out of the question either.  In that =
case,
> > > > > they would have found the solution to their problem.  But, when y=
ou get
> > > > > right down to it, only one person reported it in addition to the
> > > > > original poster, so either other people saw the original post and
> > > > > compensated in their own testing, or (the more likely I think), m=
ost
> > > > > people don't start testing -rcs until after -rc2.
> > > >
> > > > I don't know about other people, but our testing of -rc starts on -=
rc1
> > > > and we are not waiting for -rc2. From my observe of netdev, they al=
so
> > > > start to test -rc immediately.
> > > >
> > > > Otherwise, what is the point of the week between -rc1 and -rc2?
> > > >
> > > > > Which is why I try to set -rc2 as a milestone for several purpose=
s.
> > > > > For getting in the bulk of the known fixes, but also as a branchi=
ng
> > > > > point for for-next.
> > > > >
> > > > > --
> > > > > Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > > >     GPG KeyID: B826A3330E572FDD
> > > > >     Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 =
0E57
> > 2FDD
> > > > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnHLa0ACgkQ5GN7iDZy
WKfrkg/6AuHlL3iMyXX9ceXTXcg5hD6weoTNNa1QvEH87KEt5yAnMhkgUgtXBWlm
Q04XorZQw67Vxatwf+M67gi1Bq+zISmW6i7Fb+twceU+LxvDIOFD65UOXRMr63HI
IxL0L4NKFIInvcfeEctVgH0B8DLXoSOMXdgE37a9eihUsC3ZBvBdGfYHvRffgsHq
rA5pqel3WgXmvshsHhBuX4E4jS7+Ic0siw3Yt38QAvUWxWFxbB4B1uL4BMIjZvYC
ygO+4HSuFsP57PhhmpihL6503gPLBj1UI7WsgKas9l/asK4jkL4UX+DovmxLAPD/
Suc2ow8KKwlnLbkc1SwVCEsbBc60yDLPwJ5w0DL8rFUiuSK+buwZS/kDUgx/Wokr
AIogSb1uIW5xPm5F1WsaRovJBHbtBbE2FuAePSvpVDs73exg9dLPfKAm74MAt91d
9lqKX0ybd3p8PQL8aeeN2gBBuEpgI0M1NN4WwHfzQPsQrZI4dxtj/BJ/s27GqT01
ndspH3k7/G6za7jw/r3aTYUH4vEAl3AeCUDcGhHDM0FeT7mIGM3S5Nj/oqtaatyz
po7Pyovocc56EWXyYYwDPDRFMIiEMaZwXtS26LJhDuBPYZr4mtE+vwRa8rqYzuGr
BFzmMbEuR/QhulzJqg5kuXBzZUrb6d3Uzy77XPAJo6MzN2Ixa9g=
=XuwK
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
