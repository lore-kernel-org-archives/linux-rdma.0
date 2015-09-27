From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Expire sendonly joins (was Re: [PATCH rdma-rc 0/2] Add
 mechanism for ipoib neigh state change notifications)
Date: Sun, 27 Sep 2015 13:32:31 -0400
Message-ID: <5608282F.1020507@redhat.com>
References: <1442486283-9699-1-git-send-email-ogerlitz@mellanox.com>
 <alpine.DEB.2.11.1509170940270.2052@east.gentwo.org>
 <CAJ3xEMg-h+J=cr2ddWvYUGU=MOBk4Aw-KtkeJutATH0Y17dnjg@mail.gmail.com>
 <alpine.DEB.2.20.1509241158420.21198@east.gentwo.org>
 <CAJ3xEMg2qQ3CXrfTrg=gUX2tQRuPnpxA-8PC98GzoF5iz=j5PQ@mail.gmail.com>
 <alpine.DEB.2.20.1509251140200.31792@east.gentwo.org>
 <CAJ3xEMj9kGaM6s+AqBQ_-ZTB_+cgDk3kefhq_O0V3PM120O9yQ@mail.gmail.com>
 <alpine.DEB.2.20.1509271136570.14486@east.gentwo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8IwSOam1CU0WcVBUqbd4FGbJGsWNTkCnx"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1509271136570.14486-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8IwSOam1CU0WcVBUqbd4FGbJGsWNTkCnx
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/27/2015 12:39 PM, Christoph Lameter wrote:
>=20
> On Sat, 26 Sep 2015, Or Gerlitz wrote:
>=20
>> It's possible that this was done for a reason, so
>=20
>> sounds good, so taking into account that Erez is away till Oct 6th, we=

>> can probably pick your patch and later, if Erez proves us that there's=

>> deep problem there, revert it and take his.
>=20
> Ok but if Erez does not have the time to participate in code developmen=
t
> and follow up on the patch as issues arise then I would rather rework t=
he
> code so that it is easily understandable and I will continue to follow =
up
> on the issues with the code as they develop. This seems to be much more=

> important to my company than Mellanox.
>=20

Currently I'm testing your patch with a couple other patches.  I dropped
the patch of mine that added a module option, and added two different
patches.  However, I'm still waffling on this patch somewhat.  In the
discussions that Jason and I had, I pretty much decided that I would
like to see all send-only multicast sends be sent immediately with no
backlog queue.  That means that if we had to start a send-only join, or
if we started one and it hasn't completed yet, we would send the packet
immediately via the broadcast group versus queueing.  Doing so might
trip this new code up.

Right now, we start a join, we queue the packet on the mcast struct, and
in join_finish we create an ah, but that's it.  We then restart the send
by calling dev_queue_xmit on the skb we put in the backlog queue, which
takes us back around to mcast_send, where we not have both a mcast and a
mcast->ah, so *then* we alloc a new neigh entry, attach this mcast to
it, and send using it.

If I change mcast_send so that we start a join, but immediately send the
packet in the broadcast group, then I would have to change the
join_finish routine to alloc a neigh that has the right daddr so it can
be found in the future, without the benefit of the daddr passed into the
function mcast_send so missing the ipoib header and instead only having
the raw mgid in the mcmember struct.  But, we would have to have that
neigh struct so that the timeout would work in the case were we had a
packet or two that triggered a join but were all sent prior to the join
completing and so we never got a neigh alloc via mcast_send for this
mcast group.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--8IwSOam1CU0WcVBUqbd4FGbJGsWNTkCnx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWCCgvAAoJELgmozMOVy/drtcQALNglpAcV2zyucq1Ymcj4OZQ
/sFXx1UUvVezUg17Ao5+cScRulryREpgZ331tiwWD5fw8iB2yMyv9PaW57jDNVOq
vN8LrTu9YTQ/pnpdoFbgX6ZpymGVWmVHtOVTflP2Z2i7u8rwmlTaHp/jNb6a5VZi
G4VvHTVgU45Ow3rZgkzMpMd0Gin0fZiVtVK0lM1v+5mI6YoGrALEVhQB7sFhZydb
jD3v8Ji0XG0MD8DVftMVl7F3p241sY1vzmbg/75JCP47y5Fn0VmEtl7GFJ26Pg7N
FLHXCUs4ivH3Hm7SK+AR3ysLaW6R5Bvs8fHrUuJTpAn2vbkVweyAp6DkuuGhvOAz
XquNVwRpXxKP422Cyw2midsqNazjZ9M/LHDDcQBvMvLcAweZW8rVBd2dbfhoC0fu
dcbhOaLuNpbshUGR/xgRqntop+HrIOIN3qhH9jP2EC0zw8OsuyxiEiUOZ/3u7UrW
gDKLiKXSYGiJK6BmdZPyfC5Vzjxjp63TD9CLK1bfoEPtSZDqd0f4IOVuEuqgQNgh
Tyz1R9Wf5xl1PaK8T33IYpe2LSPHcpRALUvUAvt4nSQ8wPZibFZIczC/1qmiyI9l
g1UFGkZIh0lUh/XVfMJSp6z9jgo17UoSlaqHVQLeTnaKlutVRpp1pwhkQ6E6QC34
y6t8ki/8+Ngn7/VPaI4r
=p109
-----END PGP SIGNATURE-----

--8IwSOam1CU0WcVBUqbd4FGbJGsWNTkCnx--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
