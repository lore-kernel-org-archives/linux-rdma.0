From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 1/1] IB/ipoib: fix for rare multicast join race
 condition
Date: Fri, 12 Feb 2016 16:48:50 -0500
Message-ID: <56BE5342.7000902@redhat.com>
References: <20160211213051.29589.31877.stgit@phlsvlogin03.ph.intel.com>
 <CAJ3xEMgRxXx8kijLZK072oiN=_gYUXjqdUS=KtTKjk_BfKuXOw@mail.gmail.com>
 <CAJ3xEMh-F7HNZ73G9HojJOHww5GPo3VMDa9ffiFq3NXKUi69sQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SxgiU5Bxn8IGm8qLSrmiMIwb8RnmH3lUo"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMh-F7HNZ73G9HojJOHww5GPo3VMDa9ffiFq3NXKUi69sQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SxgiU5Bxn8IGm8qLSrmiMIwb8RnmH3lUo
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 02/12/2016 04:47 PM, Or Gerlitz wrote:
> On Fri, Feb 12, 2016 at 10:45 PM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wro=
te:
>> On Thu, Feb 11, 2016 at 10:30 PM, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> =
wrote:
>>> Proposed patch should prevent multicast join task to continue
>>> if link state change is detected.
>>>
>>> Signed-off-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>
>>> Changes from v4:
>>> - as suggested by Doug Ledford, optimized spinlock usage,
>>> i.e. ipoib_mcast_join() is called with lock held.
>>> Changes from v3:
>>> - sync with priv->lock before flag check.
>>> Chages from v2:
>>> - Move check for OPER_UP flag state to mcast_join() to
>>> ensure no event worker is in progress.
>>> - minor style fixes.
>>> Changes from v1:
>>> - No need to lock again if error detected.
>>> ---
>>>  drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   24
>>> +++++++++++++++++-------
>>>  1 files changed, 17 insertions(+), 7 deletions(-)
>>>
>>
>>
>=20
> Alex, for next times... please put the Vx --> Vy history either in the =
cover
> letter or in a case where this is single patch (as was here) after the =
---
> line, else we'll have this listing present in the upstream kernel git f=
or
> the rest of the human/linux history, since when the maintainer uses git=
 am,
> it goes in.
>>
> Doug, I see now in your github that this indeed went in, could you made=
 a
> small git rebase rewording and remove this review history?
>=20

It's not an important enough issue to warrant rebasing a tree that's
already hit my k.o repo where I don't rebase except under dire need.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--SxgiU5Bxn8IGm8qLSrmiMIwb8RnmH3lUo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWvlNCAAoJELgmozMOVy/dpK0P/2u1E3dC35u/7go7o1kObWsM
Cx5othbmXyd+6Ev8EXs8yauoUbPupZVWYpK6cboM5sSVlogkd7xKaUiwFBRsIM7j
h6HIX7aGowF5cbvBZSKV92rSzXtWLZYApnR1ZNrsVsRsbT6j89s5DGJfquGkZSOO
b2mkQ0R+eAHQliY7O6fWlHfzStaaeHMgUXcWF1TAwzD+dy+KyXVrxQuRzIjUctMM
Cgw5tJfyNy1Na3rL0io+EmFlqXh2HkumI1900cfusRTaFglZXKPLXOtjX/vB3vP+
mYSvyqteBSjaQSmUcW1mFNNtzT7b19hTq4KJ0aYQZKbd8YLyfVzXorPCCiPoYK2Z
mL0GDDpFrriHFMEnxwBB0mwECoa34mecT4nfRwmmBgw2bwBrb2QVGgKDYY1+/FDa
BUXmvFQ+wImNTsG8q0iWGMt2+g/6AzVlItEHiklcN+57E+5BAEG3ey5H/hS0etGR
pnb8Y0hJUiUsyWEA0pxx6rdNnj7Rcu8KneR9cidPIQk5PHR/ZWpODXLlLZJYUVoE
rNy6INhqENzu3H3u9zrseu1taJY4bc8oDmwGJ0eCOXLcoVJcaBy0VqzDLLL2I46p
XzCH7g3B3D4kwa+Kgwk0RVeo0Xmw5nKV+GPuncHuqx6AkQWTSm9u+mis0MTkWazm
PKXJr6G6/QsBYW2BYEwx
=oUVg
-----END PGP SIGNATURE-----

--SxgiU5Bxn8IGm8qLSrmiMIwb8RnmH3lUo--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
