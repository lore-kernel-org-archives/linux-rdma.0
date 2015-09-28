From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Expire sendonly joins (was Re: [PATCH rdma-rc 0/2] Add
 mechanism for ipoib neigh state change notifications)
Date: Mon, 28 Sep 2015 11:36:11 -0400
Message-ID: <56095E6B.60509@redhat.com>
References: <1442486283-9699-1-git-send-email-ogerlitz@mellanox.com>
 <alpine.DEB.2.11.1509170940270.2052@east.gentwo.org>
 <CAJ3xEMg-h+J=cr2ddWvYUGU=MOBk4Aw-KtkeJutATH0Y17dnjg@mail.gmail.com>
 <alpine.DEB.2.20.1509241158420.21198@east.gentwo.org>
 <CAJ3xEMg2qQ3CXrfTrg=gUX2tQRuPnpxA-8PC98GzoF5iz=j5PQ@mail.gmail.com>
 <alpine.DEB.2.20.1509251140200.31792@east.gentwo.org>
 <CAJ3xEMj9kGaM6s+AqBQ_-ZTB_+cgDk3kefhq_O0V3PM120O9yQ@mail.gmail.com>
 <alpine.DEB.2.20.1509271136570.14486@east.gentwo.org>
 <5608282F.1020507@redhat.com>
 <alpine.DEB.2.20.1509272120090.18678@east.gentwo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NRewSxqt7oULv3OfXbAtVjSNMsMnDuQau"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1509272120090.18678-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NRewSxqt7oULv3OfXbAtVjSNMsMnDuQau
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/27/2015 10:28 PM, Christoph Lameter wrote:
> On Sun, 27 Sep 2015, Doug Ledford wrote:
>=20
>> Currently I'm testing your patch with a couple other patches.  I dropp=
ed
>> the patch of mine that added a module option, and added two different
>> patches.  However, I'm still waffling on this patch somewhat.  In the
>> discussions that Jason and I had, I pretty much decided that I would
>> like to see all send-only multicast sends be sent immediately with no
>> backlog queue.  That means that if we had to start a send-only join, o=
r
>> if we started one and it hasn't completed yet, we would send the packe=
t
>> immediately via the broadcast group versus queueing.  Doing so might
>> trip this new code up.
>=20
> If we send immediately then we would need to check on each packet if th=
e
> multicast creation has been completed?

We do that already anyway.  Calling find_mcast and then checking
if(!mcast || !mcast-ah) is exactly that check.

> Also broadcast could cause a unecessary reception event on the NICs of
> machines that have no interest in this traffic.

This is true.  However, I'm trying to balance between several competing
issues.  You also stated the revamped multicast code was adding latency
and dropped packets into the problem space.  Sending over the broadcast
would help with latency.  However, I have an alternative idea for that...=


> We would like to keep
> irrelevant traffic off the fabric as much as possible. An a reception
> event that requires traffic to be thrown out will cause jitter in the
> processing of inbound traffic that we also would like to avoid.

That may not be optimal for your app, but we also need to try and
maintain proper emulation of typical IP/Ethernet behavior since this is
IPoIB after all.  That's why the app isn't required to join the group
before sending, and also why it should be able to expect that we will
fall back to sending via broadcast if needed.

However, the following algorithm might be suitable here:

On first packet:
  create mcast group
  queue packet to group
  schedule join

On subsequent packets:
  find mcast group
  check mcast state
    if already joined, send immediately
    if joining, queue packet to mcast queue
    if join is deferred, send via bcast

On join completion:
  successful join
    set mcast->ah
    send all queued packets via mcast
    if no queued packets, alloc neigh for default ipv4 ethertype
  on failed join
    mcast->ah remains NULL
    send all queued packets via bcast
    mcast->delay_until is set to future time (used to know join is deferr=
ed)
    schedule deferred join attemp


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--NRewSxqt7oULv3OfXbAtVjSNMsMnDuQau
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWCV5rAAoJELgmozMOVy/dl0cQAIXJxKtLG/T47N1b6zDhsb2R
wPHS3IDDGVIgviQS1T8N0b9VM3+QBmmfIQOQ9+3EfReN+Ay0+kYBohz662WdLOEd
LFjejDZtPq9ybfX6XjmEGUT6C7/fEyh7lTfMc33663O40gG0Bg70d4MlEvtAA6TX
zQenZ5RVjBIgFClJKYAEUEUOL1AdvZ4pD07K2S6En3ZL+IQWONeWpnW5aHHDiRAd
mscnSwhLbnd7TBDEKgRKSu7pUt1GvZmOd76rjY1jvUH40nYYVCzom2WK7LedhNdG
hNEupKuRqUHEMZ0tLQ8TRDVH/An2oArpzEbiHQb2pthKL1uVSmZ4VXRYC2B39Npz
FHSs0QsBtLDLAQp6lexvh+SjfOMCkALZ6d8PZMqL92m3X/qoOviO6P3893BKuadO
RANyTEtUeSv7CeEc8kdDkMxttgtQ2+3AqrH3YnYI0zMNgwPjEsFPl7si3MBGeNLN
ZuX0mEQ0e6XIXOSl2vCDt2cgOOmkNM5FfwLQ3yBwwjayfItHaMKOiAOAL3ZHHElH
wJ8cS/yWRnrY/Y7/Toi8yOdsFYSQ+hVyC0xWgKr6Gbrl/rS5dDMpLD4odDHfJ9FN
vrRMhCyO+CUopDqo0jnuZhBJgdM/aKWkspQmNxf38Dl4BjNMG/qdDP6q0AGmfbQu
rfnind7KqYjw9KSrpZt0
=vKby
-----END PGP SIGNATURE-----

--NRewSxqt7oULv3OfXbAtVjSNMsMnDuQau--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
