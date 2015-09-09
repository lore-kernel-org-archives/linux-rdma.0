From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Wed, 9 Sep 2015 08:03:18 -0400
Message-ID: <55F02006.5020504@redhat.com>
References: <1441729478-19375-1-git-send-email-dledford@redhat.com>
 <CA+55aFzi+hhHuNcHjne_yYO+Dt4Gdkzs-U5y3fAJ8BDYWw4y=Q@mail.gmail.com>
 <CA+55aFyeLEab0qjNV1+V-mX2ZhExs1z5VtdusgpDnMeNBg-d6Q@mail.gmail.com>
 <55EFA2BF.7060006@redhat.com>
 <CA+55aFwg+QCM=xaoK4ic+4AymqCYrF4Ny8WO9iY2hHFBLNT3VQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xhXPa3iIPi6HPWSGKVc0uelHqdtgV4cjX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFwg+QCM=xaoK4ic+4AymqCYrF4Ny8WO9iY2hHFBLNT3VQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jiri Pirko <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xhXPa3iIPi6HPWSGKVc0uelHqdtgV4cjX
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Side note: it's very annoying to have Time Warner Cable decide to take
your internet down in the middle of writing a reply :-/

On 09/08/2015 11:33 PM, Linus Torvalds wrote:
> On Tue, Sep 8, 2015 at 8:08 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
>>
>> With a comment that said "I can carry this merge forward, no further
>> action is necessary on your part".  That combined with my lack of deep=

>> internal knowledge of what it is that Stephen is doing made me go "Ok,=

>> he says don't do anything, so I won't change it."
>=20
> So quite frankly, Stephen does a really good job at merging and most
> of his merges are very on point. He's been doing a lot of them as part
> of linux-next, and has seen more conflicts than just about anybody
> else.
>=20
> But I think to him it's mostly just an issue of "get the right end
> result". I don't think he goes: "this merge conflict is a result of a
> breakdown of the development process".
>=20
> Conversely, to me, one of the main reasons I want to do those merges
> is exactly because I think conflicts are more about the development
> process issues than about "just getting the right end result". Yes,
> obviously I want to get the rigth end result too, but I very much
> react to how/why the conflict happened in the first place. The end
> result is _almost_ secondary, although 99% of the time the primary
> issue doesn't really even raise its head.
>=20
> So I'm upset not because the conflict is hard to resolve (it isn't),
> but because I feel this was really badly handled.
>=20
> Yes, the fact that Mellanox people sent two different patches to two
> different maintainers that did the same thing in two different ways is
> odd. Matan and Jiri are cc'd, and I think that whole thing just smells
> really bad.
>=20
> But at the same time, I expect more of maintainers, and I don't see
> any sign that David and the networking people were notified about the
> _other_ patch to _their_ subsystem.

Me telling Matan to Cc: netdev on patches related to their subsystem:
http://marc.info/?l=3Dlinux-rdma&m=3D143398479529819&w=3D4

Above was v5 of the patchset.  Both the v6 and v7 of the patchset had
netdev Cc:ed on the cover letter and at least the first three patches.

Here's the v7 cover and the first three patches in the netdev archives:
http://marc.info/?l=3Dlinux-netdev&m=3D143827046913908&w=3D4
http://marc.info/?l=3Dlinux-netdev&m=3D143827047413915&w=3D4
http://marc.info/?l=3Dlinux-netdev&m=3D143827052913936&w=3D4
http://marc.info/?l=3Dlinux-netdev&m=3D143827055013953&w=3D4

Here I am saying I've pulled the patchset in in the netdev archives:
http://marc.info/?l=3Dlinux-netdev&m=3D143834704701705&w=3D4

Here Jason Gunthorpe is asking me if I was going to take netdev stuff
without an ack from netdev in the netdev archives:
http://marc.info/?l=3Dlinux-netdev&m=3D143836033706501&w=3D4

And here is my response to Jason, again, in the netdev archives:
http://marc.info/?l=3Dlinux-netdev&m=3D143836450808174&w=3D4

Here is the initial notification from Stephen on the merge conflict:
http://marc.info/?l=3Dlinux-next&m=3D144072523831647&w=3D4

Here's is Jiri's response (on linux-netdev, but according to my records
also direct Cc: Dave Miller):
http://marc.info/?l=3Dlinux-netdev&m=3D144074372902869&w=3D4

> The fact that you weren't aware of the other patch in the networking
> subsystem is kind of to be expected. You're not the network
> maintainer, so why would you? But exactly because you're not the
> networking maintainer, I would have expected you to check with him
> when you apply patches to generic networking code.

See above.  This was done.

> This time it conflicted, and I noticed, and I went "this is not how
> kernel development is supposed to go".

I didn't switch up for the newer patch, that didn't help.  But
otherwise, I did what was needed.

> But say that the other networking patch hadn't even existed: in that
> case I *still* shouldn't have gotten a patch to net/core/dev.c from
> you without any sign that David had ack'ed it (or at the very least
> been notified, even if he hadn't reacted).

And such a thing wouldn't have happened.

> See?

I see perfectly well Linus.  I am not new to engineering.  You have
stated several times that I'm missing the point, or do I see your point,
please understand mine: I *did* the things you are assuming I didn't do.
 The record is in the public archives.  I didn't make a big deal about
it because it *isn't* a big deal unless you assume that I'm running
around nilly-willy throwing shit at the wall and hoping to make a
painting.  As I knew very well that's not what I'm doing, *I* didn't
have those assumptions, and therefore I didn't think this merge fixup
was a big deal.  As the efforts to bring this to the network
maintainer's attention is in the record above, you will likewise find if
you talk to Greg K-H that I worked with him both publicly and privately
on the changes I made in the drivers/staging area.  I do now how to keep
responsible parties informed when I'm working in their domain.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--xhXPa3iIPi6HPWSGKVc0uelHqdtgV4cjX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV8CANAAoJELgmozMOVy/da1cP/0mwvcZ3vlRv/Sx+Fg67nEWe
l8YI5ocsijOXaAQYMhtp5dpemnDAqxf1npwc/xxpjM7Lo8BiiS0n1fX8usOprdHg
/co83g+YILe/qQLCa9KVbzlysxZQHsf7xbmXlUzZhb90MZBH0jGzu2XTEJIIrr/G
wTkb1MPjU+DBmv8mmkv44z5JnDXn7YOCnB3K8JTJMO54WO3kiWMYLczqhFfHiSf3
GjdMeANU9d9On4bwZadXdgYe40nHZ6tVBisVjxAr/YjkAh4JZkwUO+qmnHvtBv1I
/LkJNd/Z37rCycY3N5IFDuj2F4pH900+b77azG4srIUJiIoFDz+7W7w26eSTeDl1
a22kx6D6FYMfqn4cAWyPuBpPpH2gHrsZ3WVmQvhoozzQ5vtpJmUBKKlynSSjIxtX
bEMsEYxEoqU3FcKrOtrVVCx9s3AzJkzPre6lMxDgjE7MSmjL9etd/Gy8aHrQmqUf
wmX6vJZRdBn0WYB/VfUiJr9hPUzrQ7GeoDduGVUB/hPPskAAUveZy/r6GyQ4Xj8c
fmpeqIBIIZs6IEm9oUb3rYeJXI9Fp54N2oyxlI7OcsEqe3VO4rdO34cXN/9+OIBD
2S4hF0cgR/FlRrtxP0zkyeUjQnspFQfnI3B96V8BX3LvnMD5RVhCmK+Iy2NhE5dP
CDr8dQd7Niy1F8aO6zXk
=jqMH
-----END PGP SIGNATURE-----

--xhXPa3iIPi6HPWSGKVc0uelHqdtgV4cjX--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
