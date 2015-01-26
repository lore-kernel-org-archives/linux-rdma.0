From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH FIX For-3.19 v5 00/10] Fix ipoib regressions
Date: Mon, 26 Jan 2015 13:45:55 -0500
Message-ID: <1422297955.2854.32.camel@redhat.com>
References: <cover.1421936879.git.dledford@redhat.com>
				 <1422031938.3352.286.camel@redhat.com>
				 <54C4E793.2010103@dev.mellanox.co.il>
			 <1422224477.3352.373.camel@redhat.com>
			 <54C616A8.3050804@dev.mellanox.co.il>
	 <1422276712.2854.5.camel@redhat.com>	 <54C6400E.30607@dev.mellanox.co.il>
	 <1422279465.2854.15.camel@redhat.com> <54C64A2A.5070306@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-6G2av/r/yL5mJJa4Fn8H"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54C64A2A.5070306-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-6G2av/r/yL5mJJa4Fn8H
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-01-26 at 16:07 +0200, Erez Shitrit wrote:
> On 1/26/2015 3:37 PM, Doug Ledford wrote:
> > On Mon, 2015-01-26 at 15:24 +0200, Erez Shitrit wrote:
> >>>>>> The main cause is the concept that was broken for the send-only jo=
in,
> >>>>>> when you treat the sendonly like a regular mcg and add it to the m=
c list
> >>>>>> and to the mc_task etc.
> >>>>> I'm looking at 3.18 right now, and 3.18 adds sendonly groups to the=
 mcg
> >>>>> just like my current code does.  The only difference, and I do mean
> >>>>> *only*, is that it calls sendonly_join directly instead of via the
> >>>>> mcast_task.
> >>>> Yes, and i already wrote that it is more than just "only", it change=
d
> >>>> the concept of the sendonly mc packet.
> >>> Be more specific please.  What do you mean by "concept"?  And just so=
 we
> >>> are clear, this all started because the existing multicast code was
> >>> super easy to break and was racy, so if the "concept" you are referri=
ng
> >>> to is what made the original code easy to break and racy, I'm not goi=
ng
> >>> to care one whit that I changed that concept.
> >>>
> >> I agree that you fixed many bugs in your patches to 3.18, where the mc
> >> flow was easy to break, no argue about that.
> >> The only issue that i disagree is about the way now sendonly is handle=
d
> >> (and i think that this is the reason for the regression we see now).
> > It's not.  The patch I sent you off list should be sufficient at this
> > point to finally put your issues to rest.
> >
> >> In general, IMHO, the sendonly join is part of the TX flow and not par=
t
> >> of the  ipoib_set_mcast_list flow.
> > I disagree.  I'll get into that below.
> >
> >> The original meaning of the ipoib_set_mcast_list task that restart the
> >> mc_task is to be used for the kernel in order to add one or more new
> >> mcg's macs to the driver/HW (ndo_set_rx_mode), the sendonly mc is not
> >> such object, its mac should not be part of the "mac" list of the drive=
r
> >> (in IB wards, no qp_attach for it)
> > This part I agree with.
> >
> >>   and from the kernel point of view
> >> whenever it sends packet from sendonly mcg type no need to do the join=
,
> >> it's a regular send, the only reason we have the sendonly join is the =
IB
> >> enforcement for such mcg.
> > This is where you and I differ.  There is a requirement on us from the
> > IB spec that we have to join a sendonly MC group in order to do what th=
e
> > kernel would think of as a normal send if we were on Ethernet.  We
> > aren't on Ethernet though, so acting like we are to the above layer is
> > fine, but in our own layer we should be coding to the realities of our
> > layer.  And that means treating a sendonly MC group like a regular MC
> > group.
>=20
> Just to make it clear, the IB request to do sendonly join was done prior=
=20
> to your changes.

Yes...

>  (stopped after them.)

What do you mean here?  With my changes we still do sendonly joins.

> The IB spec doesn't care if you mix sendonly with full-member,

Correct.

>  the=20
> kernel does care,

Where?  What part of the kernel cares?

>  and by adding them to the mc_list you abuse the kernel=20
> ndo (by adding unnecessary joins to it, as i wrote in my previous mail)

How?  We never add a sendonly during a typical set_multicast call
invocation.  And in fact, we still do the exact same thing we used to do
when the kernel ndo is called, which is to call restart_task which will
scan our currently joined groups (both regular and sendonly, like it
always has), clear out any that don't have a matching address entry set
via the kernel ndo, and rejoin those that do have a matching entry set
via the ndo.

> I think you should not mix between RX operation (like the full-member=20
> join, kernel rx ndo) to TX operation (sendonly join)

And I think having two distinctly different code paths when it doesn't
matter whether the join is sendonly or normal, they still must all be
accurately tracked and reaped on shutdown and various other events, is
wrong and is an invitation to failures for no good reason.

> >
> >> The reason the driver keeps the sendonly mcg in its mc_list is from
> >> others reasons, the first is to handle the case when the kernel decide=
s
> >> to move a mcg from sendonly membership to full-member, one more other
> >> reason is to do the leave operation when needed and not for being
> >> handled as a full-member mcg.
> > It's been a long time since I first started working on this issue, so
> > some of the details are fuzzy in my memory.  I think my first 8 patch
> > patchset is now about 6 months old.  But, I think probably the most
> > important thing you left off this list, and the one that trumps all the
> > others, is that whether a sendonly MC group has a QP attached or not, w=
e
> > still have to account for these groups, we have to track them, and on
> > shutdown we have to reliably leave them without oopsing.  Putting the
> > join of the sendonly groups directly in mcast_send opens us up to
> > problems with synchronizing our mcast list (either due to a dev flush, =
a
> > mcast restart task, or something else).
>=20
> This is the reason the sendonly mcg was added to the mc_list. and should=
=20
> stay there.
>=20
> >    I can't say for certain that
> > the change to how we record the return value from ib_sa_join_multicast
> > in sendonly_join is enough to keep the sendonly join code from racing
> > with the flush code and causing problems.  For that reason, I am highly
> > reluctant to put the sendonly join back directly into the tx path
> > because that could have been part of the original problem in the first
> > place, it's just that my memory of back then is too fuzzy to say that
> > with 100% certainty either way.
>=20
> That fear from the unknown is not a reason to break the original logic=
=20
> of the sendonly.

No, the reason to break the original logic of the sendonly was that it
was a bad design that contributed to other problems.  The reason not to
consider putting that bad logic back in place right now, IMO, is that I
can't remember the details of the breakage better than I do at this
moment.

> if there is such a problem, we need to find it and to fix.

I disagree.  The original logic was an artificial and bad separation of
too more or less identical things in the code that helped contribute to
it being broken in the first place.  We are under no obligation to put
it back to that bad design.  And in the future, I'd like to bring the
sendonly and regular joins more in line with each other, quite possible
doing away with them having separate functions.  I'd also like to
completely deserialize them.  Both of these things will be easier to do
from the starting point we have now versus going back to the old setup.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-6G2av/r/yL5mJJa4Fn8H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUxotjAAoJELgmozMOVy/dhyMQALAZ3crw52xeq8Wb6pnQhaAz
9fI7J6dHJPHDXu4gYLDVkUK/6waMmAjvTvKIFQJiidyHPeIgv6R6ZCDnLPb2Me/q
1Du70unzYmijJkHkbmlDmuqqP+GoiotwiEUOikqk2sShIe2teziv8sE5/zPuVwf4
0p+YnDp9urhkAQzPRlkcJyX74J534eeSAiKGgZXq8EdkhAWRRrFr0J1Scpk2o8sI
n+MJnOXhGj7CDO2L8Oj7uXeknDklET64cjRAgyFqR0xffAzpjtFIRF9+HQ679Lkp
B7iDchVMoo0e26pWWnFgcN5j8DGbV31PxI8T61zvDlkK/Yv0ub5huIz61Po2xi6A
Nv1mC2tKPy2Ro3Oqi0UIedU3yltCctnIGDQ+jSznK7LzBY1IMHLFkaI1ESFRW82d
fFQLLxKm0tG9cXJR8k84IYd+JDlcEvR6rSHZJicGlMphaEC/Pq9tkkBcIPLmlwp+
PLHYzTyuofyGtqDj9/aQoV/q28ddzM02/TQ0Zi/6CrQZwTtrGC8/pazwQsqQ0yEC
i77sBgcWz6tQ/tpAHNvVjKBfbjo1cdjLhtEOanSpZctdsKjcgxrYEfM7I81Hyy6N
daVaA7+kwvHvJuR3+XHoRQGHQHf/SQhDNT9mnsNCjsgr7rPZ/YgnOYcVWWekGkba
NYGrP4NxMQLc1qgjGCLq
=676j
-----END PGP SIGNATURE-----

--=-6G2av/r/yL5mJJa4Fn8H--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
