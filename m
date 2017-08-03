From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-next 01/33] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Thu, 3 Aug 2017 08:10:32 +0300
Message-ID: <20170803051032.GF13672@mtr-leonro.local>
References: <20170801120536.540-1-leon@kernel.org>
 <20170801120536.540-2-leon@kernel.org>
 <20170801133832.GA11812@ctung-MOBL3.amr.corp.intel.com>
 <20170801141023.GM13672@mtr-leonro.local>
 <1501696661.109555.6.camel@redhat.com>
 <20170802185405.GE13672@mtr-leonro.local>
 <1501719575.117042.4.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="uWPcrH1o85ekjD8l"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1501719575.117042.4.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--uWPcrH1o85ekjD8l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 02, 2017 at 08:19:35PM -0400, Doug Ledford wrote:
> On Wed, 2017-08-02 at 21:54 +0300, Leon Romanovsky wrote:
> > On Wed, Aug 02, 2017 at 01:57:41PM -0400, Doug Ledford wrote:
> > > On Tue, 2017-08-01 at 17:10 +0300, Leon Romanovsky wrote:
> > > > On Tue, Aug 01, 2017 at 08:38:32AM -0500, Chien Tin Tung wrote:
> > > > > On Tue, Aug 01, 2017 at 03:05:04PM +0300, Leon Romanovsky
> > > > > wrote:
> > > > > > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > > > >
> > > > > > The commit cea05eadded0 ("IB/core: Add flow control to the
> > > > > > portmapper netlink calls")
> > > > > > changed netlink to be blocked for all RDMA clients. This
> > > > > > workaround
> > > > > > worked perfectly for portmapper, but is not correct for the
> > > > > > whole
> > > > > > NETLINK_RDMA family.
> > > > >
> > > > > Leon,
> > > > >
> > > > > I've already told you I'm opposed to the revert.  There is a
> > > > > patch
> > > > > that will work
> > > > > with your usage of ibnl_unicast() but you chose to abandon that
> > > > > discussion on June 29, 2017
> > > > > (RDMA/core: Add wait/retry version of ibnl_unicast).  Either
> > > > > you
> > > > > step up with good sound
> > > > > technical evidence to convince me that patch won't work for you
> > > > > or
> > > > > you stop trying to
> > > > > break existing functionality with this revert.
> > > >
> > > > Chien,
> > > >
> > > > You never explained us what exactly your original patch fixed and
> > > > why
> > > > it
> > > > should be fixed in kernel and not in user space. I saw that our
> > > > discussion wasn't useful and brought bad blood instead of good
> > > > will,
> > > > so I stepped out in waited for RDMA maintainer (Doug) step in.
> > > >
> > > > I never heard anything from Doug on the matter, so proceeded and
> > > > resubmitted it.
> > >
> > > What makes you think *I* want to be in the middle of a school yard
> > > squabble like this?
> >
> > It is not "I" want, but "I" expect and "I" demand from the
> > maintainer.
>
> I'm a big fan of the movie Draft Day.  You may not have ever seen it,
> but I really enjoy all of the things that happen in the course of one
> day.  In that movie, Vontae Mack is afraid he won't get selected 7th by
> Sonny Weaver Jr.  When Sonny Weaver Jr. trades up for the 1st pick,
> Vontae assumes it's because he's going to try and take the popular
> pick, and so Vontae takes to his twitter account and tells Sonny Weaver
> Jr. off.  Sonny gives Vontae a call, in which he tells Vontae that he
> needs to put his twitter account down and take a chill pill, because
> "as much as going to twitter is your God given right, General Managers
> hate that shit because now they know that you'll put whatever innane
> thought goes through your mind out there for the entire world to see."
> (or something like that, it's from memory).
>
> You may be wondering what my point here is.  It's simple.  It may be
> your God given right to force a maintainer to make a call like this,
> but maintainers hate that shit, because it's usually a sign of
> dysfunction in the community and failure to work cooperatively to
> arrive at a communally approved resolution.  What's more, it puts the
> maintainer in a bad position of having to deal with possible political
> crap and everything else.  So, yes, it's your God given right, but it
> better be your last resort.

Are you kidding me? Reply to the series from the maintainer that "it is
postponed till both sides are happy" is too much for you?

"Politics" - it is so sticky word here. Every disagreement in the mailing l=
ist
immediately claimed "for politic reasons" and everyone is hiding in the bus=
hes.

So yes, the community doesn't work, and I don't see desire to fix it
=66rom the all participants of this mailing list.

>
> > It is his responsibility to drive to the resolution for the important
> > core patches.
>
> This was really only a core patch of minor importance to begin with,
> and once Chien wrote a patch to give you what you wanted without
> breaking the existing user space packages, it really became a trivial
> core patch.  Hardly worthy of pulling the "I demand you make a
> maintainer call" card.

No, Chien never explained why he needs this fix and what this fix is actual=
ly fixing.

>
> > This revert was discussed for something like month+, as an outcome of
> > it, Chien reviewed and sent much more improved version of their
> > original
> > patch, without socket timeout and with minimal blocking places.
>
> That would have been a perfect moment for you to work with Chien to
> take his patch as the first of your series instead of sticking to the
> revert.

I can't work on the solution if other side didn't explain why it is needed.

>
> > So please, don't say "school yard",
>
> I stand by my statement.  So many school yard arguments make no real
> sense, and given you had every opportunity to resolve this problem with
> a community viable alternative patch, and in so doing would have
> actually fulfilled the edict that "we don't break user space" instead
> of violating it as you were doing, the metaphor seems entirely
> appropriate.

And the fact that the reverted patch broke the user space behavior
before, didn't bother you?

>
> >  especially after your silence.
>
> I want to address this separate from everything else.
>
> With as much hostility and accusations as I saw fly on the original
> submission, several things happened:
>
> 1) The submission got bumped to the bottom of my queue because settling
> squables is not the sort of thing maintainers want to deal with.
> 2) The submission got bumped to the bottom of my queue so you would
> have a chance to work things out and come to a mutually agreed
> solution.  Such resolution is in the best interest of both the
> community and the technical correctness of the fix as, generally, an
> agreed upon fix will have had more community input and refinement prior
> to being accepted.
> 3) The submission will get put on hold for a short while regardless of
> points 1 and 2 just so you have a moment to settle down, rethink things
> a little bit, and decide if you really want to pull that "put the
> maintainer in this position" trigger.  Have you really examined all the
> possible solutions?  Is there really no superior alternative?  Is there
> really no way to come to agreement with the other community member(s)
> you are disagreeing with?

And did you go to the mailing list and write something like that "the
series on hold till solution will be found", like it was with hfi1-vnic
and ipoib?

The Answer is no, you didn't do it, you silently ignored discussion, unders=
tood
that the series is stuck and continued down the road.

>
> In the end, there will always be those things that a maintainer will
> simply need to make a call on because there won't be a clear right or
> wrong side and it just becomes a judgment call.  But I don't think this
> one even came close to being that unclear, so again I'm confused by
> your insistence on going this route instead of just working things out
> with Chien.

Because, I truly believe that they proposed the nasty hack, which
doesn't fix the real problem - inability to deal with losses of netlink
messages.

And I realized it after I started to work on RDMA netlink and read RFC
and design documents and assumptions about netlink.

In my opinion, it is one of the small examples why RDMA subsystem is so
hated. It is full of "custom" solutions to known problems and many of
those "custom" solutions are mix of hacks and band aids.

There is no need to reply on it.
It is my personal opinion and my view of the RDMA subsystem as a newcomer.

I'm OOO till Monday.
Happy weekends.

>
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>

--uWPcrH1o85ekjD8l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmCsEcACgkQ5GN7iDZy
WKeFJBAAhIW+jHmUa+atv9mrGZwmG3KI122YZqMeqD+CErDCNK9l5eFoakNR0YQu
Qk1SG5Sbv3Dd6QGAOm569WPVj8pxGC38AmfPF6iq1mKboqhoZss3x5nPfNDaIRnn
CYfwOalou5j78XaThOlHuNc8A7j3SH9/L/DX3YPecHVGr+Mqj0kJ9hpaaVCgBUb7
Ahyu6MHIlSdkm0YTkDetQo7WCdefB47kuUeWGqcyj10EzRvOx4Ii4RXC4kPQ0/9N
gEjKiwe73UTYscGApV7MMviWWib7XHDgN47oPW4DUoJI18aam4JcAiz8E8qLmrGH
ahcYFM5YBsqkJg7cCirMLAV0/UcrG9vVv+hxuvNUdytDWgJGqdqPpdwqluc6CQ9E
mkrH0mzra2PrHOd1rT2vm2wmgeBPanjtJK5C/TEFBtOm1XbS/e3DunWae636xiH4
h3fPhefDQ4zSiJ1NKXoSra9aeyCP1qMsokron4AMltdtG1BlzQzWU2mZJsq3vfBJ
vHCD+R4cFzimyswoWqdVEPqgwDPfJ/GdEU6I4E/5zpbZ5vmh2n6jdeGie+NRzAPj
h3d2X2g6uLUFAEokSp9OiBX1jy5DBwLz0PDHFD2H6LjrN3ZjIETrx7YdWIlm15/b
IRStN8A9/SwhkBwVJ3zhxXzCh2SMfbLcvYATAqtNkkA3F0doryA=
=SDwC
-----END PGP SIGNATURE-----

--uWPcrH1o85ekjD8l--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
