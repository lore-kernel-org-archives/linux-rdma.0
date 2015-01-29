From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3 FIX for-3.19] IB/ipoib: Fix sendonly traffic and
 multicast traffic
Date: Thu, 29 Jan 2015 14:27:39 -0500
Message-ID: <1422559659.2854.288.camel@redhat.com>
References: <1422277227-1086-1-git-send-email-erezsh@mellanox.com>
	 <CAJ3xEMjERaEP5d_ZT8RN5+w8Z_Hig4T7dhuq3o+1NOUuQgfJLw@mail.gmail.com>
	 <1422301106.2854.41.camel@redhat.com>
	 <CAJ3xEMg3vYGbGuT+Z-XQMv5YuPws33XHQP_Wcz8gvpBbCg3TSw@mail.gmail.com>
	 <1422309605.2854.62.camel@redhat.com> <54C74D49.3080201@dev.mellanox.co.il>
	 <1422378130.2854.119.camel@redhat.com> <54CA2CE0.30107@mellanox.com>
	 <1422545677.2854.260.camel@redhat.com>
	 <CAL1RGDV30SRUv0oxZCQW0e+tziO0g+iDha8DSWeM56PiWtnRwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-IpZLETzp+GqRbxeFQeV7"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDV30SRUv0oxZCQW0e+tziO0g+iDha8DSWeM56PiWtnRwA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-IpZLETzp+GqRbxeFQeV7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-01-29 at 11:23 -0800, Roland Dreier wrote:
> On Thu, Jan 29, 2015 at 7:34 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> >
> > > So lets close the 3.19 saga, again, either revert your eight patches
> >
> > I would support that option.
>=20
> I think at this point we have to do the revert, and get it right for
> 3.20.  There's just too much noise floating around and I can't tell
> whether all the regressions are dealt with or not, and we're running
> out of time.
>=20
> I will ask Linus to pull in the reverts, and then let's try to agree
> on a patch set for 3.20 ASAP.

Works for me.  Thanks!

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-IpZLETzp+GqRbxeFQeV7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUyomrAAoJELgmozMOVy/dQLwP/iAGuxNb4NLveEfOd60CdY5k
t4aYawfRqYmleG61ojbOigxXhdCdDG2kDfOBUGhmL7HhV6ACMCKqxp+2B03Cu6Mw
gyMnPXcGhi02M44bxmrhm5WvRfqJF/PBuwGy7C5LR3BC2u8T35vnwYGUe7nUbEmY
zCxA2zmDITTQUngCwfE10cSflwTBKKlFj0zG+nKEwnCbM16pHki7frU4LYsWzRZP
JVm7h45a/UYbcf8VYwBrWUZRYligonwsVFVEy8FaBc1O4g4FuES+ERAg6/hSHjJ3
M412xCWvJFRGKJtb0WL5Z1bCv68oALUF3kM1xvg+UaBdSqeJwsZf+fQH8V7y/MjJ
A8dXVES6PUX++267IWg2D513brjR+wg7+Rzx0nNFoPxl0qniHPtnB+PXdPbW6jiT
vO1mGbd80u6mj9nCnVKSvsnG/mavBazsQf4ggh03M1aPH56D0FZKlTlVPL5du76D
DtNnqr8kkVfEAqTsSXvHHVo7+Qo8U+weqVnGJQVOKCnziVtGWPhqJri7cpz0ajLk
ny3+YSEj4vuEfCc0aiyE+21zAUzab9lsZL0gRW93DuHWeF6w++LRF1wG/2Fp5aHe
C0tlmx9DfHUTSxqEK/GP0LoX8ALDIkfBLit0redqKyM6Ae/70F2odPalZkoqUHsL
dav/nrs4LjwRv9WU/3i3
=oGPz
-----END PGP SIGNATURE-----

--=-IpZLETzp+GqRbxeFQeV7--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
