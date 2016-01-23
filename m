From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Sat, 23 Jan 2016 11:16:55 -0500
Message-ID: <56A3A777.3@redhat.com>
References: <56A2727B.8040809@redhat.com>
 <CA+55aFziXhmMRk3HqvrUtVv+SaUM0zu3=LKbxo0w9HZPVmDuyw@mail.gmail.com>
 <56A30910.9010002@redhat.com>
 <CA+55aFzhwDNiBr0MKyFYn8WCLxhPrBxU0TPTSskm5B3VkzhD9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Tu84FNVcLmX2XpJpVkxAPIwgDXBXFTJhS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFzhwDNiBr0MKyFYn8WCLxhPrBxU0TPTSskm5B3VkzhD9g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Tu84FNVcLmX2XpJpVkxAPIwgDXBXFTJhS
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 01/23/2016 12:42 AM, Linus Torvalds wrote:
> On Fri, Jan 22, 2016 at 9:01 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
>>
>> I obviously have my understanding of the development cycle here wrong.=

>> I had thought that the merge window was 4 weeks with a following 8 wee=
ks
>> of RC candidates resulting in roughly quarterly pace.  But you tagged
>> v4.4 on 1/10/16, so this Sunday is only 2 weeks.  That certainly chang=
es
>> things.  I did not believe that the merge window was so short when I
>> sent this request.
>=20
> We've had this model now for ten years by now. Yes, it's really been th=
at long.
>=20
> Two weeks of merge window, followed by weekly release candidates until
> it's "ready" (where the most common last one tends to be rc7, but that
> has certainly fluctuated - we had 3.1 go to rc10 before release, and
> we've had a few that only got to rc6).
>=20
> This all is not new,

I never said it was new.

> and it's not undocumented.

There is a schedule document somewhere?

> I have absolutely no
> idea why you suddenly started multiplying all the times by two.

Only the merge window, not all of it.  Probably too many years working
internally at Red Hat and dealing with schedules that fall into
alignment with quarters without seeming to have any effort to make it
that way.

> It's actually been very stable over the years. We've had exceptions
> where travel schedules (or just holidays etc) have moved things around
> by a week here and there, but on the whole it's actually not varied a
> lot.
>=20
>> But also, really?  Even ignoring that misconception,  it's the merge
>> window.  And it has a deadline.
>=20
> It's a *MERGE* window.
>=20
> Not a *DEVELOPMENT* window.
>=20
> See the difference?

I know the difference, there's no need to resort to yelling.

> This is not new either. The rule has been that things should basically
> be ready by the time the merge window *opens*. Things should have been
> in linux-next so that they get some testing, and so that people get a
> heads-up not only about what is coming up, but how it interacts with
> other things coming up.

Certainly.  And most of it was there prior to Dec 23rd when I went on
PTO.  It had linux-next and 0day and other testing.  The things I added
since then were either A) local to the rdma subsystem or B) had been in
linux-next via someone else's tree prior to my going on PTO (the
NFSoRDMA changes qualify here) and were moved to my tree to resolve
dependency issues after I returned.  I made a specific point of
preserving this testing, that's part of why my changes were sent as late
as they were.

> And no, not everything ends up being in linux-next. But I think we've
> been hitting almost 90% most recent releases, so that whole "things
> should be in linux-next beforehand" is not just some theoretical goal,
> it's something we actually hit in practice pretty well.

Indeed.  I strove for that myself.  The only problem here is that there
is no positive result from linux-next, only negative.  So, I just had to
wait and see if I got a notification email about failure or not.

> And yes, I do pull requests until the last minute (although I have
> been known to hurry up the last minute and release -rc1 a day early
> just because I don't want people to game my timing).
>=20
> But generally at the last minute I want to feel that there was some
> _reason_ for the last minute behavior.

Fair enough.  What I'm used to is that a deadline is a deadline and as
long as you meet it, you've done your job, no special explanation
necessary.  As previously mentioned, I *thought* the deadline was later,
that was a mistake.  But regardless of that, I did meet the final
deadline anyway, hence I didn't provide a detailed explanation of my
reasons for being on the latter half of the merge window.  But from what
you just wrote, I get the impression that I should have.  The is a
difference between what you are looking for and what I dealt with in my
previous responsibilities.  Difference noted.

> And no, the reason is not "I am hurrying up to get everything done by
> 5pm on a Friday afternoon, and I didn't even get everything done, so
> I'll send the rest on Monday".

I sent the request when I was reasonably sure I wasn't going to get a
linux-next failure notification, not when I was rushing to get out the
door.  You should have gotten it about 9am your time, so I wouldn't have
expected you to think this characterization would have been accurate.

> Because that just makes me go "ok, this is clearly not ready".

I don't think it's as "clearly not ready" as you think, but that's just
my opinion ;-)

> [ And as to why the merge window is two weeks and not just "one single
> day" if everything is supposed to be ready before-hand..
>=20
>   That's actually a valid question, but it's at least partially about
> _me_ (but also about flexibility for others, so that we don't have to
> make the 90% be 100%).
>=20
>   In particular, just the merging process itself would take me one
> week. I can do about 20-30 merges a day for the first few days, and I
> don't feel I could do more while still actually feeling like I had
> some kind of overview of what I'm merging (the merge itself is often
> quick, it's looking at it and doing a basic build test etc that takes
> time).
>=20
>   So one week would be the absolute minimum with the amount of
> different trees I merge - and that assumes that every single tree is
> ready and done at the beginning.
>=20
>   In practice, things slow down after a few days as I catch up with
> the queue of pull requests.  So in the end the average over the two
> week period is about 10-15 merges per day for me.
>=20
>   By the end of the two weeks, it really should have turned into a
> slow trickle of merges of things that had dependencies or some other
> valid reason to be late.. Or rather, I _wish_ it turned into a
> trickle, but sadly the last Friday afternoon is seldom anything but
> slow.
>=20
>   So two weeks "works" - and has worked for the last ten years. It may
> not be perfect, but I think it has worked exceptionally well in the
> end - certainly better than people thought initially when we started
> trying this whole no-longer-very-new-thing.]

Thanks for the explanation.  It all makes sense to me.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--Tu84FNVcLmX2XpJpVkxAPIwgDXBXFTJhS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWo6d3AAoJELgmozMOVy/dnCgQAKBnI3WKiQTeVe5/2ye9a80I
FsrD2H9hKlKtis+lAswuRgCPoo99MouyhCjNqhOhzMBRHJ37NF2osJxa+dJd8LoT
1m0xIEfuDW4J1eyhGDcZ2in61PGCabXfxJrZVNkBdkoQ8pCuL76nyTBgWuPbTJQs
WtmUZYxroUN+XtojEStMej8/Xc+sf2JhbXX5ts+XgsqHQuAei9NBKgIldebb664W
B/i4qqI/lK42S2LWPVheJl/TkiGYq2VKPVVYEC7KUVBDPnMEJGYJO1GjzZbyPyKG
7vSdZPP0Mi9267HEOdtBc8LuTPo12LNDwHj9J8fObdIXfnSK+yP24dTEnhn76DZS
CSZGSMZgN/pNQu/lWDmrbYxApQIAl22wlbHpXDDfpFRX3Ywlzp39dj00rKjHNqPR
BRYY2DdUR5jqzGxpuFL+Ze7wXgrnSLs1ckvy3RI6ba3iG7XICVjsgXdoZOpbgi4d
Ebd9ie6fnfFX3tYewF+7VcusLn7Cik1Yos6F7P3wDf1LHs8pSMLHBd2IFmpvEoun
bZBGRqosLygx616htgbFUl8XllhkLv3+5OLaC7lOIMau2QbDw4AQjPla0rj56dzZ
vSNYs1QKTcmZD7PjmlB55j0KSVamhrQzG8jIwy05Bf7WOO8azbikaWL/gi4YJlC8
nmLFjD6fskVIQ5GXOC6S
=ktCV
-----END PGP SIGNATURE-----

--Tu84FNVcLmX2XpJpVkxAPIwgDXBXFTJhS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
