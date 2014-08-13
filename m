From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/8] IB/srp: Use P_Key cache for P_Key lookups
Date: Wed, 13 Aug 2014 10:15:24 -0400
Message-ID: <1407939324.21533.26.camel@firewall.xsintricity.com>
References: <cover.1407885084.git.dledford@redhat.com>
	 <6555e716eda21a03577e5e1e0bfb6bbadbb592d3.1407885084.git.dledford@redhat.com>
	 <CAG4TOxM5xUh3gLx5wEixuhro7131JxfZHviPm1EgZArJy7+Y4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-P398PUH5eUOxHNjvNgYd"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG4TOxM5xUh3gLx5wEixuhro7131JxfZHviPm1EgZArJy7+Y4w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-P398PUH5eUOxHNjvNgYd
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On Tue, 2014-08-12 at 21:56 -0700, Roland Dreier wrote:
> On Tue, Aug 12, 2014 at 4:20 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> > -       ret =3D ib_find_pkey(target->srp_host->srp_dev->dev,
> > -                          target->srp_host->port,
> > -                          be16_to_cpu(target->path.pkey),
> > -                          &attr->pkey_index);
> > +       ret =3D ib_find_cached_pkey(target->srp_host->srp_dev->dev,
> > +                                 target->srp_host->port,
> > +                                 be16_to_cpu(target->path.pkey),
> > +                                 &attr->pkey_index);
>=20
> I consider the "cached" operations to be a deprecated interface,

I disagree.

>  and
> I'd rather remove uses than add new ones.

This isn't practical.  For the ib_get_* cache operations, you could
theoretically do away with the cache and not suffer too bad.  But this
is one of the ib_find_* operations.  These functions can not be done
away with.

>   I have a vague dream of
> fixing everything up so the normal interfaces (ib_find_pkey() etc)
> don't sleep and are usable everywhere,

Sleeping isn't the problem.  And that's probably part of why you are
still dreaming about this instead of accepting reality.  The problem is
the latency required to query the firmware on a card.  Some IB adapters
might keep their tables in kernel memory and can access them fast, but
some cards use firmware and the tables are there and when you query the
driver you are actually doing a query to the card via a firmware and a
mailbox and you have to wait for a return.  *That's* the problem.  And
specifically as it relates to the ib_find_* functions as this function
is, when the P_Key you're searching for isn't one of the first found,
the difference between the cache and direct to the card is very
significant.

>  although that dream will
> probably never come true.

No offense Roland, but not if I have anything to say about it ;-)  Not
because I don't want you to have your dreams of course, but this
particular dream is more nightmare for the rest of us than the unicorns
and rainbows raining skittles on the world that you envision it being.

> But is there any practical benefit to this change?=20

Absolutely yes!

>  I don't think
> saving a few milliseconds at log in time counts

You can't think that way Roland....it breaks real world usage in very
unexpected ways.  Ways that took me, 3 support engineers from two
companies, and top level admins at a joint customer's sight over a month
to finally figure out.  So, let me be clear, this particular dream of
yours has wasted well over 4 man months of support/engineering time.
Email me off list if you want more details of how this nightmare dream
of yours did it.

>  -- I would think it's
> lost in the noise of how long it takes to actually log in, scan for
> LUNs, etc.

No, it's really not.  The simple case of finding the right element in
the first lookup or two is OK.  But this is the ib_find_* function, and
if it doesn't find the right element at first, it searches all available
elements until it does.  There are 128 slots (like there are for GID
indexes), so it's a few ms times 128 in the worst case scenario.  That's
not noise.  It's so far from noise that it kills real world
applications.  Things start timing out and resetting when you have more
than just a few items search the table for an element that isn't there.
It really can't be thought of in the terms you are thinking of it, which
is the common/best case scenario.  You *have* to consider worst case
scenario, and in that scenario, the cache functions are absolutely
essential to scalability.  Especially the ib_find_* variants.  And since
they are essential, they *must* be maintained and kept working properly,
and so there is no reason not to use them when they can be used.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-P398PUH5eUOxHNjvNgYd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJT63L8AAoJELgmozMOVy/dKicP/19j4Qsmu54XNM6AQ5KWk6Ki
zqxQFp7FTBSlmHwmc9L9dkqVj1kQ74rDmBw77HMi6HrUHbGWuwq5wSrFtO03uhR+
nhBcU38W5djRr/JyioQBva3ejMD4+KXEtXktE1EmB8B0mqHD2hy2pW3Q35509jqv
iRoZ50xbnw9Ul4SREg8QSazxsCkBciKVjaN6EUCKNh2IvBwXqlBqiS99Bw1jBipM
McI05d2v7466dUpeO2Z/GdVjkIlkHpboi7DdbjMMYGg0qmZ1jC9BUEnnW7kksbzK
8TxkuyTdwIP1QvUF18K7B2LZGh+3MEpzO+MJPtqwCsXaNXTwgnYG80axToK29YB+
AuZRU6ssv009GEU4eh4SWjXAw/q6thX09UbSAIAUcUWhfpBMVUg8InEIqlKk+Kel
38R3/fym1FXpk4N1q4VVrOqtgrP9w5PWVAjur/ybqzZKMG/JBgoWLIcBBQ9mkPrb
zshX3RMSi3mK71gCpQrqftM8UYvtxNV58BmEqc05g9zPQeufF7AuEmw7Cu0+23Y/
fOjsh68V691UUnaGsbGGWBndr+Sne1XG/WsaZknD0BeQhe+SbCzKZlU0XU+GvzRV
VMDmhAy//7Mn3O6YGxdiRNP66vhSbgd02jgCNfVXwTRpSM2DFWZuhS0EYPDjhp1k
G2LPqr+xW/C9h6giPn9t
=/dnD
-----END PGP SIGNATURE-----

--=-P398PUH5eUOxHNjvNgYd--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
