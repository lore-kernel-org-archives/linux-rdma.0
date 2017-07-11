From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: This merge window...
Date: Tue, 11 Jul 2017 15:28:07 -0400
Message-ID: <824b3771-78a6-7c80-50d9-a34383169185@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QVewqromv510XqCuhvoQT2XjUNlFnav5W"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QVewqromv510XqCuhvoQT2XjUNlFnav5W
Content-Type: multipart/mixed; boundary="495QWjiwipwE4xtojO2mUS5thOeS8Mwop";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <824b3771-78a6-7c80-50d9-a34383169185-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: This merge window...

--495QWjiwipwE4xtojO2mUS5thOeS8Mwop
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

RESEND: I sent this *hours* ago, but accidentally from my personal
account.  I haven't seen it show up on the list yet, so I'm resending
from my work account where my emails seem to make it to the list in a
timely fashion.

As some of you no doubt noticed, when Linus decided to make the last rc
cycle of 4.12 -rc7 and open the merge window last week (on a holiday
week for people in the USA no less), it caught me off guard.  I didn't
have my for-next branch ready to go (it's mostly there, but not all
there), so at Linus' request I'm holding the merge until 4.14.  That
means I'm going to rework my branches entirely (so it's a good thing
I've only pushed them to github so I can rebase at will).  I'll be
moving things that are high priority and fixes from my for-next area
over to my for-rc area and I'll push those through this cycle.  I'll
end up pushing the first round of -rc moves later today, but if you
feel the need to check my for-next area to see if your favorite bug fix
patch is already there and drop me an email off-list to tell me that
you really want that patch in -rc this cycle, then please feel free to
do so.  Otherwise, if you want to just trust in my judgment, in a day
or two I'll have it all sorted and you can just double check then to
make sure your patch made it where you wanted it to go.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--495QWjiwipwE4xtojO2mUS5thOeS8Mwop--

--QVewqromv510XqCuhvoQT2XjUNlFnav5W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZZSbHAAoJELgmozMOVy/dryMQALtQ2F2lSXE+Hs/F+oF4MJdb
iZmKcvTpKP5KREI03vScvH1KLVFId9DaLFAVBKSahRV4SVw6MW9+UfLeZukbXKMu
E6BA7Fuufvtn6aHoQQQGc75/p40xUw6sy1UIMQp9AM0VrGp4nxmiMSWtoeDvwf2j
dI9HxrihrX9g/V75mx3qt9W4n1nGLH7p10/qP0I2QVfdfxfuybXxMKXEtYA+XXVH
EtHBAHaJjeUk2rA3MbufqFkDsW36J2GtisR9QDDJEcTmrNsB+iK02aYKwrGDSO8O
P0Lwcv0MShxWspg0yrIQsS9Qek6o+akYEy8ZDx1Tm/mH+Y45OeunwvXZXytWxPDB
lBxHzlFnhHM2UUXDPhS+efpAYyWUcEjWdHw8/UM7O55hwiGz7Jlt/hU24rAQUuU/
gXhodqQV1yHdHJzt3yCUqd4kvZ6P2YhJFAkniVNnWNl5/NR+275v/kL2mlZDEIb8
6VNxkte8ckNq4MP3QpcvsRhgZ5BFWbnm81KZkXy7sL6soRsaJDFUZ7DwgezTuOZ0
a70/a1hfCMymEbrAroZJPVQTjpVIl7I/5BOR0ttVg73new2jRQIVZl7ef2XRQwhn
kb/yfyZrREBbBfK71zUqoYKKK+obeRHmao5peW86A3vcjjfpp2aKJKWGHHQrdS1U
Jzxe94CkP8EJdIVC8FtN
=FYss
-----END PGP SIGNATURE-----

--QVewqromv510XqCuhvoQT2XjUNlFnav5W--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
