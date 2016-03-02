From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Announce: libibverbs-1.2.0
Date: Wed, 2 Mar 2016 12:19:32 -0500
Message-ID: <56D720A4.1050607@redhat.com>
References: <56D084E3.7040207@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="0vnvXVggA5NAbU5mw4tN2fHPxnlujhTm8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56D084E3.7040207-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Don Dutile <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0vnvXVggA5NAbU5mw4tN2fHPxnlujhTm8
Content-Type: multipart/mixed; boundary="QU16hWuVOpKjCiIccXgEdgd0VCU5E3vh6"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Don Dutile <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Message-ID: <56D720A4.1050607-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Announce: libibverbs-1.2.0
References: <56D084E3.7040207-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <56D084E3.7040207-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

--QU16hWuVOpKjCiIccXgEdgd0VCU5E3vh6
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2/26/2016 12:01 PM, Doug Ledford wrote:
> I left libibverbs-1.2.0-rc1 out for quite a while.  I"ve went ahead and=

> made that the official libibverbs-1.2.0 (with only a few minor changes,=

> most notably just to correct some issues with the version string in the=

> tarball provided RPM spec file, and a fix for one compile warning).
> This is mainly just preparatory for some of the recent patches on the
> mailing list.  I felt those warranted a different version because of
> their complexity.
>=20
> However, the tarball isn't up yet.  I can't push it until I get a new
> login on the new server at OpenFabrics.org (since that's been the
> historical homes of the libibverbs tarballs, although it could be moved=

> to the tarball location on kernel.org in the future).  That request is
> in and I'll update people on the list when I can push the tarball out.
>=20
> The git repo has been pushed though, so if you grab the git repo, have =
a
> recent set of autotools on your own machine, and then run "./autogen.sh=
;
> make libibverbs.spec; make; make dist" then you should end up with a
> tarball for libibverbs-1.2.0.tar.gz that is close enough to the officia=
l
> one to allow you to check it out while waiting on the official one.
>=20
> You might be asking yourself "Why is he announcing this if the tarball
> isn't up?  Couldn't he just wait?"  And the answer to that is that I'm
> currently working on libibverbs patches.  I don't frequently switch my
> concentration and focus away from the kernel to libibverbs, so now is a=

> good time to get any minor patches in that you would like to see in
> libibverbs-1.2.1 (the major patch sets are already on list, and I'm not=

> expecting people to push things like that through based on this notice,=

> but if someone wants to tackle little things like the fact that the XRC=

> version of example programs, which often support test that are not in
> XRC mode, often don't check to see if inline data is supported and
> therefore fail to run on qib cards...we expect it not to work on qib
> cards when doing XRC tests since qib doesn't support XRC, but on non-XR=
C
> tests is would be nice if they worked wherever possible).  Since I woul=
d
> like to have a proposed libibverbs-1.2.1 ready to go by early next week=
,
> I thought I would give people as much notice as possible instead of
> waiting for the login to get finalized.
>=20
> Thanks!
>=20

Push of the official 1.2.0 tarball is complete.


--QU16hWuVOpKjCiIccXgEdgd0VCU5E3vh6--

--0vnvXVggA5NAbU5mw4tN2fHPxnlujhTm8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJW1yCkAAoJELgmozMOVy/dFysP/iwd6ffc7m4QNODaO4eQEBlF
7qmGz+TUEVIRhyAaZe5reMVVTF4OuQUjJuk2BeYmh+Am2M7njAIYOyjFi8gYqHQD
8sA1KgxIC2RGPP3IZIk8DV5pacLUCgz0JdVsdOTQZSD/RAjc6S9dsuR/XkfO8221
8c+yazrqSu9XwZpzTkZDE6nF5J5m9iW9hp/8HsuBflav2g6tEbMFZs++vQ2rnmIl
/jIuxPlS/M7ZU5926g0q4+ek+r1gsMQ+6N4w7+ncLKG3hR4qT4JpNEPpEjQWKxBm
WgXxNUNiznEysyzIWbujxmudEQCmW6zuFn6KGOUq+Ys+DC72q4ryv5kPMYV6Yka6
8FF7hivU5xBXz4vcqL6bplW5VuMhCzYRNV6kqzkfSuwO0nhzHLcVrpaPXsPhHasA
gyxPc0/e8mnaAtKnrtiKnOeD8yK7Cc0hbrAmTaqVP+DuPRIWBWzuSAvJMu/T6Gt6
LFXk89xM1g8zLK4DONNtFFQAnhkqOQ0GtLksTIuBRe1Vor2XH5/5QRzQHAXfzzT5
8o70rurFPWshLFn+h3ZzdR2I6MqToNG2xprxsFWKj3Xeg9Hl8XhepAPoo/F6R5uX
3T1R6fb/OV2COQUsCbSshUFnv7Y0lhIk3tM0K5d27roiAYuQ2KNIAkK5hCfjhEmF
MMGgJ1oijyXqoPJLEU8Z
=bOSN
-----END PGP SIGNATURE-----

--0vnvXVggA5NAbU5mw4tN2fHPxnlujhTm8--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
