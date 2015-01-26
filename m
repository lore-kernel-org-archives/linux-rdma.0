From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3 FIX for-3.19] IB/ipoib: Fix sendonly traffic and
 multicast traffic
Date: Mon, 26 Jan 2015 17:00:05 -0500
Message-ID: <1422309605.2854.62.camel@redhat.com>
References: <1422277227-1086-1-git-send-email-erezsh@mellanox.com>
	 <CAJ3xEMjERaEP5d_ZT8RN5+w8Z_Hig4T7dhuq3o+1NOUuQgfJLw@mail.gmail.com>
	 <1422301106.2854.41.camel@redhat.com>
	 <CAJ3xEMg3vYGbGuT+Z-XQMv5YuPws33XHQP_Wcz8gvpBbCg3TSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-r4JfqR/BRKewI13oUr7W"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMg3vYGbGuT+Z-XQMv5YuPws33XHQP_Wcz8gvpBbCg3TSw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-r4JfqR/BRKewI13oUr7W
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-01-26 at 22:57 +0200, Or Gerlitz wrote:
> On Mon, Jan 26, 2015 at 9:38 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> > On Mon, 2015-01-26 at 15:16 +0200, Or Gerlitz wrote:
> >> On Mon, Jan 26, 2015 at 3:00 PM, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wr=
ote:
> >> > Following commit 016d9fb25cd9 "IPoIB: fix MCAST_FLAG_BUSY usage" bot=
h
> >> > IPv6 traffic and for the most cases all IPv4 multicast traffic aren'=
t
> >> > working.
> >>
> >>
> >> Hi Doug + Roland
> >>
> >> Erez was very patiently reviewing and testing all the six (V0...V5)
> >> patch series you sent to fix the 3.19-rc1 regression.
> >
> > Yes he has.
>=20
>=20
> >>  Can you also give this patch a try?
>=20
> > I can test it.  But I need to know how it's supposed to be applied.
>=20
> just apply it on latest upstream and run whatever tests you have, simple.

I used the same base kernel that I used for my patchset.

> > It might fix the regression, it might also reintroduce a race on
> > ifup/ifdown.  I'll test and see.
>=20
> Let's see it in action @ your env

It passed the initial IPv6 after a failed join issue that my own
patchset just finally passes.

However, I didn't get more than 5 minutes into testing before I was able
to livelock the system.  In this case, from machine A running my
patchset, I did

ping6 -I mlx4_ib0 -i .25 <machine B address>

On machine B running Erez's patch, I did:

rmmod ib_ipoib; modprobe ib_ipoib mcast_debug_level=3D1; sleep 2; ping6
-i .25 -c 10 -I mlx4_ib0 <machine A address>

And on the machine rdma-master, where the opensm runs, I did just a few:

systemctl restart opensm

The livelock is in the mcast flushing code.  On the machine that
livelocked, here's the dmesg tail:

[  423.189514] mlx4_ib0.8002: multicast join failed for ff12:401b:8002:0000=
:0000:0000:ffff:ffff, status -110
[  423.189541] mlx4_ib0.8002: deleting multicast group ff12:401b:8002:0000:=
0000:0000:0000:0001
[  423.189545] mlx4_ib0.8002: deleting multicast group ff12:601b:8002:0000:=
0000:0000:0000:0001
[  423.189547] mlx4_ib0.8002: deleting multicast group ff12:601b:8002:0000:=
0000:0001:ff7b:e1b1
[  423.189549] mlx4_ib0.8002: deleting multicast group ff12:401b:8002:0000:=
0000:0000:0000:00fb
[  423.189551] mlx4_ib0.8002: deleting multicast group ff12:401b:8002:0000:=
0000:0000:ffff:ffff
[  423.204570] mlx4_ib0.8002: stopping multicast thread
[  423.204573] mlx4_ib0.8002: flushing multicast list
[  423.213567] mlx4_ib0: stopping multicast thread
[  423.213571] mlx4_ib0: flushing multicast list

The rmmod operation is stuck in ib_sa_unregister_client (one of the
specific fixes my patchset resolves BTW).

On another machine I started another one of my tests:

On machine A:

ping6 I mlx4_ib0 -i .25 <machine C address>

On rdma-master:

while true; do sleep 4; systemctl restart opensm; done

One machine C:

passes=3D0; while true; do ifdown qib_ib0; ifup qib_ib0; echo "Passes $pass=
es..."; let passes++; done

In this test Erez's patch made it through about 5 down/up cycles before
the machine oopsed.

Do I need to keep going?  I was able to crash two different machines on
two different brands of hardware within only a few test cycles.  My
patchset, while large and intrusive, now survives all of this with
flying colors, and now that I've replicated Erez's specific multicast
join failure, I've taken care of that corner case too (and will be
adding that to my long term QE setup so it doesn't regress in the
future).


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-r4JfqR/BRKewI13oUr7W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUxrjlAAoJELgmozMOVy/dtroP/i4UuZj8PMLqJSNkZ05FavEl
C8pjBweVtXVP5wRElV5MtCJX6TAxitzT1hVLSuqfIpLVJNorg9/N7eCN7D/2Zgfz
0aKUYc1dWMCDxQ1h7Br4+O385S/PieKG09hHwS/vQzkdg60D/PeO4cDpGT0sLDZq
rQzyv24mnucIdwvZpRI2dFDAy9xvaKUOs/3UaIbYhPvruYRCinZj+HUL4zIS4J6S
QcGG7hTiBdsAuaoa1UqYoe+tXaAKjzqsr4a+5FjBUUxEO48sDOqVVBRmG9uMSg+3
N46UzrjnctDiYAAwHgobaC0t6GUwpHzDkZ+w0lGH3UrJ70up1hSwbJyDsGKXBQ+x
nCBR0vUiO+5X5nD6uXtAkrP7Ocb/uAQ9hcbiPu6Y/aVu+fw6QMiwjUfFWlCjHSwO
9uykslPYmjZIcI9M3vS0YmJfSIxYQ4iwGrNrS8gwqAJ5X/vp0Yyi4dGkkT6fUFCm
g+Kvm+DlmzsTfA6iIFdERIVMR8NhjgLt61At0lNGthbIA5jSMqIZf9dCuB++O1+L
/MCfJWPAyuW5OI0Zsa0wQ9zuIN+rz0cyXoxkEpsjsKAwdLK8eJYlq8FL/4jZoBhE
RkfTVG+PapDVwk09d5SgnLP4g0RL74piypg2f3q6fDxtmQmyma6/Dm1WMDfSkV6x
1+2IyJ+26R2NoODjEE5q
=vxRa
-----END PGP SIGNATURE-----

--=-r4JfqR/BRKewI13oUr7W--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
