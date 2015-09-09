From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Tue, 8 Sep 2015 23:08:47 -0400
Message-ID: <55EFA2BF.7060006@redhat.com>
References: <1441729478-19375-1-git-send-email-dledford@redhat.com>
 <CA+55aFzi+hhHuNcHjne_yYO+Dt4Gdkzs-U5y3fAJ8BDYWw4y=Q@mail.gmail.com>
 <CA+55aFyeLEab0qjNV1+V-mX2ZhExs1z5VtdusgpDnMeNBg-d6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bdOSASsl9NtJHLOOsTQxbD15Wva1qps6S"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFyeLEab0qjNV1+V-mX2ZhExs1z5VtdusgpDnMeNBg-d6Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jiri Pirko <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bdOSASsl9NtJHLOOsTQxbD15Wva1qps6S
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 09/08/2015 08:35 PM, Linus Torvalds wrote:
> On Tue, Sep 8, 2015 at 5:21 PM, Linus Torvalds
> <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
>>
>> This needs a good explanation, because for now this pull request is de=
ad to me.
>=20
> Just to clarify: it's really the combination of:
>=20
>  (a) you were told about this

With a comment that said "I can carry this merge forward, no further
action is necessary on your part".  That combined with my lack of deep
internal knowledge of what it is that Stephen is doing made me go "Ok,
he says don't do anything, so I won't change it."

>  (b) you rebased your commit series after it

Yes.  I rebased my tree a bunch of times.  I keep two different git
repos.  The one on kernel.org and one on github.  I rebase the one on
github.  I don't rebase the one on kernel.org.  I had *thought* that
Stephen had pointed the for-next setup at my kernel.org stuff, but he
evidently has it pointed at my github setup.  That's something I need to
address with Stephen.

>  (c) you didn't fix it and never even mentioned the issue

Because I thought it was handled.

> that makes me just go "I want to have absolutely nothing to do with
> this disaster area of a pull request".
>=20
> The conflict itself? Big deal. Conflicts happen. But that patch
> shouldn't have gone through your tree in the first place, and it damn
> well should have had an ack from David or something if it did.

I agree.  The entire patch series that this patch came from went through
about v7 during review process.  The early versions had the patch mixed
in amongst the others and no Cc: to netdev.  I specifically requested
that all of the netdev related patches be sent to netdev (they were),
and I had every intention of making sure that Dave acked the patch.
Until Stephen's setup caught the two identical patches, resolved it in
favor of Dave's tree's patch, rendering the issue moot.

> And the *same* company sent two different patches for the same thing
> to two different submaintainers?  WTF guys?
>=20
> Kernel development isn't a sport where you throw shit on the wall to
> see what sticks.
>=20
> This could have been done correctly. You could have cc'd David, and
> you could also have just said "sorry, there's a conflict due to me
> taking a different version of a patch that also went through the
> networking tree". Or you could have tried to synchronize to begin
> with, and just used the same version of the patch from day one. Or if
> you had to rebase your patch series (why was that done, anyway?) you
> could just have fixed it to do what the networking tree already did.
>=20
> So this could have been done so much better in many ways. But none of
> that happened.
>=20
> Cross-subsystem conflicts do happen, and patches that cross said
> subsystems aren't evil per se. I have lost count of how many conflicts
> I've resolved in just this merge window. I do it all the time. But
> this one made me just go "Eww".
>=20
> The rebase and the complete lack of communication here just makes me an=
gry.

As mentioned in my previous email, the rebase is because Stephen is
pointing at my github repo and not my k.o repo.  The lack of
communication is because I thought it was handled and didn't need to be
flagged additionally.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--bdOSASsl9NtJHLOOsTQxbD15Wva1qps6S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV76K/AAoJELgmozMOVy/du8wQAL76x2Zutku5TnYM/yy/puvH
s5H8ogf25vf30doJ0YzXzgGo3vb2d+aFEZZ9Ag4Os475+Nwm2Y+7ysLFV6/Epo/H
p5bSfQGxmn515M89+pIVVJSbVLU7Ft7bjp7DcFvBOJajfsqY8hp9kCwzEYfd/YSF
j7bIi8pk8JUTO7wuuX30UKnL0+waZNbQmO5e864GsDehT4AhxEWHlZK/rTug0fCS
eKU5RMpxRKBWkgif02KpV0Go0lEfb339LWLlChDePLUksyOe5WcTcauHz7Mh4zXd
1gkDy7VP2uqeGuriOHvVP9Vyzm+om0WlM9rpyZExo979JKhnTP/VWKCGgHMaIUD3
UdKF8VGgKeFz8e+4DA65UQZh0+fqwaVL9Q7GNioWncEB+wdCktvKW5go6Pi7AxqW
1DVSYxJb55diiLZKLu2yu8IawjgODyv6ZG/cJ10EvwtggxEJ8oZeu9pSCIHi3Ptr
1VdhzWlbeOVoY6ttzlfJHLPlf2YBfTrZvuwnHG0hJPwGRcoNks7dNpFOW0axzRPL
1jZNI263WgqTKEnJanHriIK6q4m/BrRh/qVxBIVGkKAu4OhhvrG/6dDzhYqi5C6J
eUziFdxlgMootlcOBjfq5ujyE+2JlAQgbPpXY2DpxpvNP699pfK4UqOADWwJjrwm
JAl6r0Ryot4ecKt9fGJx
=aKbN
-----END PGP SIGNATURE-----

--bdOSASsl9NtJHLOOsTQxbD15Wva1qps6S--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
