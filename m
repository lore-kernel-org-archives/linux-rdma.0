From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V1 FIX for-3.19] IB/ipoib: Fix broken multicast flow
Date: Wed, 14 Jan 2015 01:01:02 -0500
Message-ID: <1421215262.43839.225.camel@redhat.com>
References: <1420643066-3599-1-git-send-email-ogerlitz@mellanox.com>
	 <CAJ3xEMh60SGsK43b49MSozqmL8PDzTevs5CMGCvhPfmL3kHHVQ@mail.gmail.com>
	 <1421167544.43839.190.camel@redhat.com>
	 <CAJ3xEMgJ_+b1avw6vacagSw0bxNVzLW064rztvJ6w3Y9Th0GRg@mail.gmail.com>
	 <1421182860.43839.214.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-fJTT4yehqrRjZ+ZzzgFC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1421182860.43839.214.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-fJTT4yehqrRjZ+ZzzgFC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-01-13 at 16:01 -0500, Doug Ledford wrote:
> On Tue, 2015-01-13 at 22:13 +0200, Or Gerlitz wrote:
> > On Tue, Jan 13, 2015 at 6:45 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > > On Fri, 2015-01-09 at 10:32 +0200, Or Gerlitz wrote:
> > >> On Wed, Jan 7, 2015 at 5:04 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> w=
rote:
> > >> > From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > >> >
> > >> > Following commit 016d9fb25cd9 "IPoIB: fix MCAST_FLAG_BUSY usage"
> > >> > both IPv6 traffic and for the most cases all IPv4 multicast traffi=
c
> > >> > aren't working.
> > >>
> > >> Doug, can you ack the breakage introduced by your commit and the fix=
?
> > >
> > > I haven't double checked the breakage, I'll take your word for it
> >=20
> > just try ping6 or iperf multicast and see it for yourself, please.
>=20
> I have.  I have them working now.
>=20
> >=20
> > > (at the time I did my work, I had multicast debugging on and I verifi=
ed the
> > > join/leave process, but I had assumed that the process would work the
> > > same for optional multicast groups as it does for the IPoIB broadcast
> > > group and other default IPoIB groups, so I didn't specifically test
> > > additional multicast groups above and beyond the broadcast/etc groups=
).
> > >
> > > However, the fix is not workable.  In particular, as soon as this pat=
ch
> > > is added to the kernel, you will start getting messages like this:
> > >
> > > mlx4_ib0: ipoib_mcast_leave on an in-flight join
> >=20
> >=20
> > I don't see it on my systems, is that upstream you're running? what ent=
ity does
> > ,;x4_ib0: prefixed prints and under what settings, is that the IPoIB dr=
iver?
>=20
> No, that's my internal rhel7 tree, but it's so close to bare upstream
> when it comes to IPoIB that there really shouldn't be any difference.

I've tested my patch on a plain upstream kernel and it resolves the
problem there too.  So, I feel confident that the issue is resolved
properly with this patch.

Roland, do you need a different submission, or can you take the patch
from my last email?

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-fJTT4yehqrRjZ+ZzzgFC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUtgYeAAoJELgmozMOVy/dB6YP/0LCBhuDI4lKwhuNTxzX8RSP
TF0fSSnUSja84GW+aGVXSGN6SJL21b+oesg5XViAETQgM1pnCwLefdR11rVznnBa
Ll7qHOdhqicAUqFTXKgROkL9lVTU3Nd+i5CHJlEB26YYr9YQpRVLt2B+XVa7vzxW
DVVDBxQSsDY1KsF2GurXipdhBaNQ4uWYa+yQjgA5QxZGUWRyGwOXO+PQejQGptZx
qRXrf+t6Cb1JaD4j7bTsfPc+EOvzHsIT5Dm6vgprBioa3wev9pTlM6Sz7wMbFPfX
qxZj4oiwDdpLuwV2WTuhhEDNxJ9hrgYb9YoPDRja3PH85UcYz9d7LsVanGzvBDHU
T6AWKqNPZzqRgyeiYbq2w727kpBls7ng/dQ4IxgBGybCNax4G7IgkmrKjP6CmZu4
MPbui2NwdfvIS1VAGc/84G8yzz5mgOwOZ7HU5gz0ht2AjqEGZ/WuVWqj5B3iocRT
7EmgEDQke/lcc7r2yUK98qXAck+6uwmWqiL6IwGCqgn9A5iOaggGfjiBofCXxRCU
34NqERl+pRTSEIzyIVYXSzi0fz2hZZCzeYJNXrSAssEioOa//tyzv5YLRMCe28ub
MdaIoeWqxsTM+hjS1kzfvzXq/0+3I7QSO6qXeZb4pe59UWxkWSDA3g1qLjUQQp0R
4bPfGiD+Bo1C/dsq9C4D
=7Qt6
-----END PGP SIGNATURE-----

--=-fJTT4yehqrRjZ+ZzzgFC--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
