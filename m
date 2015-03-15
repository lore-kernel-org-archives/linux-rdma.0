From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/9] IB/ipoib: fixup multicast locking issues
Date: Sun, 15 Mar 2015 11:52:44 -0700
Message-ID: <F42024C5-60A5-4B92-B4AC-4D225E2C0FC3@redhat.com>
References: <cover.1424562072.git.dledford@redhat.com> <CAJ3xEMjHrTH_F=zPDsH9A9qRWo=AYN4sgbsdDKV62nzBkB5kXA@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2074.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_DB21B74D-5EBB-4143-93D6-6F65AF47CE94"; protocol="application/pgp-signature"; micalg=pgp-sha512
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMjHrTH_F=zPDsH9A9qRWo=AYN4sgbsdDKV62nzBkB5kXA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Apple-Mail=_DB21B74D-5EBB-4143-93D6-6F65AF47CE94
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8


> On Mar 13, 2015, at 1:41 AM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>=20
> On Sun, Feb 22, 2015 at 2:26 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =
wrote:
>> This is the re-ordered, squashed version of my 22 patch set that I
>> posted on Feb 11.  There are a few minor differences between that
>> set and this one.  They are:
> [...]
>=20
> Doug, you wrote here a very detailed listing of the changes from
> earlier posts and the testing the patches went through, which is
> excellent. It would be very good if you can also post few liner
> telling the changes done by the series in high level, so we can have
> this test as part of a "merge" commit that says in the kernel logs.

OK.  I would take what I had in the original message and expand upon it =
then:

This entire patchset was intended to address the issue of ipoib
interfaces being brought up/down in a tight loop, which will hardlock
a standard v3.19 kernel.  It succeeds at resolving that problem.

In order to accomplish this goal, it reworks how the =
IPOIB_MCAST_FLAG_BUSY flag is used.  Conceptually, that flag used to be =
set when we started a multicast join, and would stay set once the join =
was complete.  This left no way to tell if the multicast join was =
complete or still in flight.  This allowed race conditions to develop =
between joining multicast groups and taking an interface down.  A =
previous attempt to resolve these race conditions used the flag =
IPOIB_MCAST_JOIN_STARTED, but did not succeed at fully resolving the =
race conditions.  This patchset resolves this issue, plus a number of =
related issues discovered while working on this issue.  The primary fix =
itself is patch 6/9 and a more complete description of the changes to =
how the IPOIB_MCAST_FLAG_BUSY flag is now used can be found in that =
commit log.

=E2=80=94
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
	GPG Key ID: 0E572FDD






--Apple-Mail=_DB21B74D-5EBB-4143-93D6-6F65AF47CE94
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJVBdT8AAoJELgmozMOVy/d9DAQAIB51kOMMjVbT3sMFxjeMM+m
IG2WpL6sBjFAdZRWyEUaLOCv14PYmu6sgRbDtA50HMVA764HedZLgopaOd3aUMct
4unGBKZ+zuhQ0wH3pg5yvWqqk79LICobqlqvFMK7YMPGZIFdCqn974rS9xBTv62f
RkBznjXic12FO3u+2ezFVltB6UvNt+XH+l8IgBTMocGDwJGMW5XIoRcuUDg3V8Ix
lUvWB74ZB9A7tTwJvIdIwvCGQO6Ekd9xZe7+7oXVBQsprch77NLbkuHK+tee2h/q
cXzsLiAwoVQiAwF77T+DppfpRUiq21zKCFRE8guoo4Yofc725/qyzcX2QqwA2SvY
CzcmSmYX7E9xgDGKOkIYk9ohc31alm+IjygvYvfayGM0rDoXMTbO2bMlSEST17pc
GPXYiVFZ589Ga/ZeAzcTLJVzkUL453PqzyNaLbebEdc4l5oG2EK1P0vGNKGCJcSh
MqK8x7rWPl59wCKn0DtuavbeiL1nJy0GowAb6vUR+fQJU6bcTu18oELZ3grEyQ9F
e8kI1vyp0ap8WckYtxeGt+XqDTZa/i88KOKQEIjdxI5NBAfQUNomaVEHUY2b1gfK
Kte7tNyUhje1ZKmZzYJ6PVkhWOfeKKgxQsiN9swwKdCHcfAD9/XWWEUhnyZRQExd
KT6inTZOY8IwifPLPL1o
=mevG
-----END PGP SIGNATURE-----

--Apple-Mail=_DB21B74D-5EBB-4143-93D6-6F65AF47CE94--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
