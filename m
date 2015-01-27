From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3 FIX for-3.19] IB/ipoib: Fix sendonly traffic and
 multicast traffic
Date: Tue, 27 Jan 2015 12:51:20 -0500
Message-ID: <1422381080.2854.142.camel@redhat.com>
References: <1422277227-1086-1-git-send-email-erezsh@mellanox.com>
	 <CAJ3xEMjERaEP5d_ZT8RN5+w8Z_Hig4T7dhuq3o+1NOUuQgfJLw@mail.gmail.com>
	 <1422301106.2854.41.camel@redhat.com>
	 <CAJ3xEMg3vYGbGuT+Z-XQMv5YuPws33XHQP_Wcz8gvpBbCg3TSw@mail.gmail.com>
	 <1422309605.2854.62.camel@redhat.com> <54C78D36.7050700@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-X0wIoikk6ZIpsoMg4d0C"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54C78D36.7050700-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-X0wIoikk6ZIpsoMg4d0C
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-01-27 at 15:05 +0200, Or Gerlitz wrote:
> On 1/27/2015 12:00 AM, Doug Ledford wrote:
> > However, I didn't get more than 5 minutes into testing before I was abl=
e
> > to livelock the system.  In this case, from machine A running my
> > patchset, I did
> >
> > ping6 -I mlx4_ib0 -i .25 <machine B address>
> >
> > On machine B running Erez's patch, I did:
> >
> > rmmod ib_ipoib; modprobe ib_ipoib mcast_debug_level=3D1; sleep 2; ping6
> > -i .25 -c 10 -I mlx4_ib0 <machine A address>
> >
> > And on the machine rdma-master, where the opensm runs, I did just a few=
:
> >
> > systemctl restart opensm
> >
> > The livelock is in the mcast flushing code.  On the machine that livelo=
cked
>=20
> Doug,
>=20
> The tests you are running and the issues you are seeing fall well into a=
=20
> to-be-fixed-in-some-kernel-rc1 category but by NO means as something=20
> which should be an rc6 fix.
>=20
> You must do the distinction between Erez's patch that fixes the=20
> regressions introduced on 3.19-rc1 to your attempts to fix many more=20
> instabilities in the IPoIB driver, which are seen under whatever nasty=
=20
> test you are running (and it's good we want to reach there).
>=20
> Roland, the V3 patch solves the rc1 regression and I think we should=20
> pick it up, by no way we can allow to pick eleven patches @ this point.
>=20
> Thoughts?

As I said in my other email to Erez, and as Erez points out, not all 11
patches of mine are needed to resolve the specific regression you are
talking about.  However, my fix resolves the regression without
reverting to splitting the multicast joins down two separate code paths,
which I think is the wrong thing to do and something that actually makes
hardening the driver harder.  If you *really* don't want my patchset
because it's 11 patches (something I couldn't care less about, and I
don't think you should either...the content of the patches is much more
important than the count), I could certainly do some squashing.  And I
could split out just the regression fix from all the rest too.

But in a situation like this, what I'm *really* concerned about is the
final result.  And here's how it breaks down under the various options:

v3.18 plain - ifconfig down/ifconfig up on ib0 can easily lock machine

v3.18 + 8 patches for above issue - initial multicast bringup works, but
additional joins attempted later (after the multicast task had decided
it was done with the initial join set) did not.  there were multiple
symptoms of the multicast join issue, one of which was failure of ipv6
or ipv4 multicast, but another was hangs in ib_sa_unregister_client on
shutdown which could just as easily be classified as a regression as the
ipv6/ipv4 multicast support

v3.18 + 8 patches + Erez patch - subsequent multicast joins now work
again, but other symptoms of the 8 patch series not addressed at all,
including other regressions, and in adding this patch in, it reverts
part of the changes made in the original 8 patch series and quite likely
reintroduces instability on ifconfig down/ifconfig up cycles (making one
wonder if this fix is better or worse than just reverting the original 8
patch set)

v3.18 + 8 patches + 11 fix patches - multicast joins now work again,
ifconfig down/ifconfig up fix continues to work, other regressions such
as hangs in ib_sa_unregister_client on shutdown fixed, overall
considerably harder to cause the kernel to behave badly than with any of
the above alternatives.  I don't claim that it's perfect and that there
isn't additional hardening to be done, but I believe it is considerably
harder/less likely to trip this kernel up than all of the rest above

If there hadn't been a flurry of testing around my patches, then I
wouldn't suggest them at all.  But they have been getting testing.  Lots
of it.  And so have the alternatives.  And out of the bunch, regardless
of patch count, my patchset has fared best under testing.  But if we
don't want to do that, then I would probably recommend reverting the
original 8 patches and then dropping the whole bunch early into 3.20.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-X0wIoikk6ZIpsoMg4d0C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUx9AYAAoJELgmozMOVy/dvWoP/0GePouFKy41DDOEhD3zVIA2
G+P2Ivwy9jHH4oOkVyyqKRT2Oh7xmTUFVKNsMJ1jon7DrhiClwXRbQY0R3hRxspD
NkIWRPK6Ri4BPjNW6eK+2CY0EwZmWpmBmKgGSNdxCZbX7uwvjXWsNGmM6fQfs8Mu
0rWbNzfwCbZA71qof62pIWBGSIq0EZBupFCfDImJLVLEmFZLQJPCFw0/kH756vwo
hMbKiCkCwKZ60gphYeKUrMl7ToEWMufRxjTUp8ytDe1VfpMntqixrQldH/KZv6XJ
jZ3kY6xNVePvcaGoQj89NZQO6/yfm3lEKEpwEEKXzWlEoxBwgvGVPZDXT8lKpowZ
Z3fxYRrdnT9Ya48KnVSreJlwY/kFzViTsfNsImBU1Fm2atSnhIKw65D+SQPBVJya
c/I564GNauVyYDfGjKYtK6iXos4nniQv+wJYDdYBHfAkuUU8LSka90OrJ4eDSuo1
pj2CxvSf2KRBrHAAHFahxja/KCCH0+ETy6Mgtm8IJrTd4uPutnASqFmDYY/D36XM
A6dscc1dXSbCpgKVbveTojmHFxCyu3p0C1m9Z1qt9MPPpt+2Z7DYcyDSYnuAgse2
vM0J0vlR76kTekYbJF2GEdOeFNm/yZMMoKkOJ/iDZyBXMoq0gTdKDsAnvfM0NAXH
6pLBU0D7u/R1zl+Z3ab/
=dcAY
-----END PGP SIGNATURE-----

--=-X0wIoikk6ZIpsoMg4d0C--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
