From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 for-next 0/7] Add support for multicast loopback
 prevention to mlx4
Date: Wed, 7 Oct 2015 11:28:12 -0400
Message-ID: <56153A0C.4040006@redhat.com>
References: <1440081275-15864-1-git-send-email-eranbe@mellanox.com>
 <CAKHjkjnQNqeLu+irEg97a1hcKp_ziXsDOFaTRwcaPpZAX_fMng@mail.gmail.com>
 <560AD75A.7080700@redhat.com>
 <CAJ3xEMiuPEJZ5EQueC=8wQyok2QbEaywQ3gRYVpqOwSaFQcj0A@mail.gmail.com>
 <5613F145.3040204@redhat.com>
 <CAJ3xEMhsr5uRLZ=Ur56TOpZy5XT3UbK=M1kcgjt=zx_x3HNcSQ@mail.gmail.com>
 <56143C8E.9090407@redhat.com>
 <CAJ3xEMiNk2ZXgg_Ji5dg+ahL_D5_RAvEzEEhMsPDjC-PJYDu7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="u954jPTNBPq2233axtDnoJI0xwJ3AwlkV"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMiNk2ZXgg_Ji5dg+ahL_D5_RAvEzEEhMsPDjC-PJYDu7Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--u954jPTNBPq2233axtDnoJI0xwJ3AwlkV
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 10/06/2015 05:49 PM, Or Gerlitz wrote:
> On Wed, Oct 7, 2015 at 12:26 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
>=20
>> Nothing so simple unfortunately.  And it isn't an IB/RoCE cluster, it'=
s
>> IB/IB/OPA/RoCE/IWARP cluster.  Regardless though, that's not my proble=
m
>> and what I'm chasing.
>=20
> To be precise no two transports out of IB/RoCE/iWARP/OPA are
> inter-operable, so these are "just" different cards/transports under
> the same IB core on this cluster.

Except that some machines have links to as many as four of the different
fabrics and so a problem in one can effect testing of others.

>> Yes, I know how to do DOA testing.
>=20
> So what's dead in your env after (say) 59m of examination?

It's not dead after 59m, it's DOA immediately.  And it's iSER.

But the details are much more complex than iSER is DOA.  It was DOA when
running a rhel7 kernel (internal, for next kernel, not a release
kernel).  That kernel is pretty close to upstream.  When I went to put
an upstream kernel on there to see if it had the same issue, the
upstream kernel on that machine oopses on boot.  It oopses in list_add,
but the backtrace doesn't list any usable information about who called
list_add with bogus data.  However, reliably, right before the oops, the
ciostor driver fails to load properly, so I'm going with that being the
likely culprit.  But each iteration is slow because when the rhel7
kernel iSER does it's thing, it causes a hung reboot, but it also
crashes the iDRAC in the machine (errant drivers crashing a baseboard
management controller is never a good sign), so the reboot must be done
via a hard power cycle.  When the upstream kernel oopses on boot, at
least the iDRAC is still working.  As a result, each test iteration is
pretty slow.

There we go, bootup on a 4.3-rc4 kernel with cxgb4 FCoE driver disabled
succeeded.  A hurdle passed.  Now I can test upstream iSER.

With an upstream kernel, the drive is still read-only with iSER (it's
not configured that way to the best of my knowledge, but I'm using auto
generate ACLs, I'm getting ready to switch the system to specific ACLs
instead), but the thread isn't stuck in D state, so that's an improvement=
=2E

However, the machine is still crashing the iDRAC on reboot.  I can't be
certain if it's the SRP target or iSER target causing this as they both
were brought up live at the same time and reboot cycles without either
of these work fine.  So I have more investigation to go before I know
exactly what's going on.  And as I pointed out, each iteration is slow :-=
/

>>> What we do know that needs fixing for 4.3-rc
>>> --> RoCE, you need the patch re-posted by Haggai few hours ago
>>> "IB/cma: Accept connection without a valid netdev on RoCE" -- without=

>>> it, RoCE isn't working.
>=20
>> I have that already.  It's available on both github and k.o and just
>> waiting for a pull request.
>=20
> Maybe wait to get the fixes for the non-default pkey on mlx5 (see more =
below)?
>=20
> Did you actually note that before Haggai posted the patch?!

No.

> once I realized how deep was the breakage, I became sort of very
> worried re your testing env not shouting hard on us this something is
> broken even before 4.3-rc1

My test environment has been down for upgrades.  In the last little bit
we've brought a second rack online, added 10 new machines, 3 new
switches, and moved existing machines around between the two racks in
order to more evenly balance the need for each port type across switches
in the two racks.  There's been more than that going on behind the
scenes here too, but it's not really worth getting into all of it.
Suffice it to say I've been working on A) expanding the cluster, B)
expanding the things the cluster is configured to do and therefore able
to test, and C) finding a way to get upstream code into this testing
framework since it was previously all rhel/fedora centric.

And this test infrastructure goes down by COB Thursday of this week and
won't be back for a week because it's being used for NFSoRDMA testing at
this fall's Bake-a-thon.

>>> --> **mlx5** devices and no-default IB pkeys, Haggai and Co are
>>> working on a fix since this isn't working since 4.3-rc1. I told them
>>> we need it till rc5.5 (i.e few days before rc6 and if not, will have
>>> to revert some 4.3-rc1 bits.
>=20
>> I already have on patch related to this in my repo as well.  The 0day
>> testing just came back and it's all good.
>=20
> I suspect that you don't...

I meant build tests passed, not run tests.

> do you have rping up and running between
> mlx4 and mlx5 on non default pkey? the breakage is a bit tricky and
> you might not see it if you run mlx5 against mlx5, BTW which patch is
> that?


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--u954jPTNBPq2233axtDnoJI0xwJ3AwlkV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWFToMAAoJELgmozMOVy/dzb4P+wVT6douMvwqDF9cMDW74CWq
G9pxFG7FjxK40P4DaDdy0CGD6HV/k9jEDzAKHotIZ2lxGR7lOwBLF5jg9eauPoni
bV5UgHjRLr52cYrhWf+4Y991NJJFUOc9LOFs23fxo3fsZDBtjgph4wxI5cXkGXLj
IIaDlKJNAp1EC0+fdbGvq3DBo/PnsB5fnKaDZNzAQlCECTK33/nSWFmIJBSJw+tz
63lsdFON2+X49/tZ9TN4zB1TJxuTAMaQomSeDmkI1sLvAB+d91YdVDU57Xxh/8ll
5Uw2OVjQr/ES+Fu4HNV6mPXRcWwNHXFN0iHUhZ80BPZI1M8Am6+/hIwwSfO6DuA3
hJe9MfjKmhqIvu95mqculySiKj477umjWla8ro2ZKqHEsbn7G7tvtDaeA9czIazo
W34xip3IpQNcK0XXiHnSBaQSNuPH4YSc5w3mQppD0nfPuLwe1/FYeuqMyab6dgyW
GiPYY7Ul/SpLdpUGDYDiE2G3dbg1jaseptb+T5fkZEpQ+30L/ZpOczdCzp0TFhQu
FRKF7tdALmE4fNSQH0iOJwMNoZjki7JGEUNBTjWZU6CFQx+dYpGbTQIx5hyA1TFU
wsBuEu684wZnYscQTTrxfHGQ08U1nwC4nvCcd/fE+KqdIf+ZP81z22xvLF5y5yCd
eFAIVJTxsWV24WyhRzyZ
=KaF9
-----END PGP SIGNATURE-----

--u954jPTNBPq2233axtDnoJI0xwJ3AwlkV--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
