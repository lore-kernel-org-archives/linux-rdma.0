From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: rdma kernel tree
Date: Tue, 19 May 2015 23:04:15 +0200
Message-ID: <1432069455.3476.12.camel@dworkin>
References: <1828884A29C6694DAF28B7E6B8A82373A8FD8CF5@ORSMSX109.amr.corp.intel.com>
	 <1431485563.43876.93.camel@redhat.com>
	 <CAJ3xEMhRY6nLPFR8qT8S7KJvxRDmw6JwhsSKw7pTvFc5PpnrhQ@mail.gmail.com>
	 <1431530845.2377.30.camel@redhat.com> <5554B7E8.4020902@mellanox.com>
	 <1431615776.3276.14.camel@redhat.com>
	 <CAJ3xEMjgpegf+D2BBZ8RPERkdUO3yH4U1LjiK+i4iF=_PtpQkA@mail.gmail.com>
	 <555ABD9D.3080303@mellanox.com> <1432038160.3114.16.camel@redhat.com>
	 <CAJ3xEMjkECDrbCFksSMMTSUusOhrU+qvMnXjkg=OuFaeYKoT0Q@mail.gmail.com>
	 <1432064993.3114.80.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432064993.3114.80.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le mardi 19 mai 2015 =C3=A0 15:49 -0400, Doug Ledford a =C3=A9crit :
> On Tue, 2015-05-19 at 21:47 +0300, Or Gerlitz wrote:
> > On Tue, May 19, 2015 at 3:22 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>=
 wrote:
> > > On Tue, 2015-05-19 at 07:35 +0300, Or Gerlitz wrote:
> > >> >> I pulled that via a bundle from patchworks.  I'll double chec=
k it.
> > >> > Did  you check it out? fixed it out?
> > >>
> > >> I took a look now, you've rebased to-be-rebased/for-4.2 to 4.1-r=
c4 and
> > >
> > > Correct.
> > >
> > >> it seems this is what you are going to push into the kernel.org =
treem
> > >
> > > Correct.
> > >
> > >> but this series is still there with the zillion tested/reviewed/=
etc
> > >> signature per one 2-3 patch, I think we've agreed this needs to =
be
> > >> addressed prior to the upstream push, right?
> > >
> > > Incorrect.  What you objected to before was the large Cc: list in=
 the
> > > patches.  That is gone.  What is there now is just the reviewed-b=
y: list
> > > of three people, and the tested-by list of two people.  As the en=
tire
> > > patch set as a whole was reviewed and tested by those people, it =
seems
> > > accurate to me.
> >=20
> > Doug, I have never ever seen a patch set (specifically the 15~23 pa=
rt
> > of it) with that level of simplicity
>=20
> That portion of the patchset didn't start out with that level of
> simplicity per patch, it evolved to that because it made review
> *significantly* easier.  It's very simple to review a patch that does=
:
>=20
> Add 1 helper
> Replace tests in code with just that 1 helper
>=20
> because you can scroll through that patch and know that every line be=
ing
> replaced is related to that one helper.  If you want to know every li=
ne
> that was replaced with rdma_cap_iw_cm, you go to that one patch and i=
t's
> all listed very easy to read.
>=20
> On the other hand, when you squash all those patches together, review
> becomes much harder because if you want to see what a single helper
> does, you have to sift through all of the other helper changes and ho=
pe
> you find the right ones, and that you found all of the right ones.
>=20
> >  and
> > signature/reviewers/tested-by/etc inflation.
>=20
> I added those myself as part of an automated addition.  It applied to
> the entire series, so it was put on each patch.  The people that
> tested/reviewed the series did not do so to individual patches, they =
hit
> all of them.  And as was pointed out a couple of weeks ago on an earl=
ier
> patchset I picked up, it is generally good behavior to give attributi=
on
> where it is due to encourage people to participate.
>=20

I agree with all the above replies from Doug:

- small patches are easier to read and review: I prefer reviewing 10
littles patches than one big patch.

- Signed-off-by:, Reviewed-by:, Tested-by: and Cc: are required too
so that when it come to modifying existing code, we can contact people
previously involved for reviews, tests, advice, etc.

(I usually add Link: with a reference to the e-mail so that one commit
 can be traced back to the related patch submission and discussions =20
 (cover-letter !), and, to be able to trace back all patch iterations,
 I add a link to the previous patchset submission, and so on).

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
