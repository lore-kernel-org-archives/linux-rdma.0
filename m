From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Announce: libibverbs-1.2.0
Date: Fri, 26 Feb 2016 12:01:23 -0500
Message-ID: <56D084E3.7040207@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="VjjbDDhkftKkvIoRRwAuC6P7qTAbQTCmg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Don Dutile <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VjjbDDhkftKkvIoRRwAuC6P7qTAbQTCmg
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

I left libibverbs-1.2.0-rc1 out for quite a while.  I"ve went ahead and
made that the official libibverbs-1.2.0 (with only a few minor changes,
most notably just to correct some issues with the version string in the
tarball provided RPM spec file, and a fix for one compile warning).
This is mainly just preparatory for some of the recent patches on the
mailing list.  I felt those warranted a different version because of
their complexity.

However, the tarball isn't up yet.  I can't push it until I get a new
login on the new server at OpenFabrics.org (since that's been the
historical homes of the libibverbs tarballs, although it could be moved
to the tarball location on kernel.org in the future).  That request is
in and I'll update people on the list when I can push the tarball out.

The git repo has been pushed though, so if you grab the git repo, have a
recent set of autotools on your own machine, and then run "./autogen.sh;
make libibverbs.spec; make; make dist" then you should end up with a
tarball for libibverbs-1.2.0.tar.gz that is close enough to the official
one to allow you to check it out while waiting on the official one.

You might be asking yourself "Why is he announcing this if the tarball
isn't up?  Couldn't he just wait?"  And the answer to that is that I'm
currently working on libibverbs patches.  I don't frequently switch my
concentration and focus away from the kernel to libibverbs, so now is a
good time to get any minor patches in that you would like to see in
libibverbs-1.2.1 (the major patch sets are already on list, and I'm not
expecting people to push things like that through based on this notice,
but if someone wants to tackle little things like the fact that the XRC
version of example programs, which often support test that are not in
XRC mode, often don't check to see if inline data is supported and
therefore fail to run on qib cards...we expect it not to work on qib
cards when doing XRC tests since qib doesn't support XRC, but on non-XRC
tests is would be nice if they worked wherever possible).  Since I would
like to have a proposed libibverbs-1.2.1 ready to go by early next week,
I thought I would give people as much notice as possible instead of
waiting for the login to get finalized.

Thanks!


--VjjbDDhkftKkvIoRRwAuC6P7qTAbQTCmg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJW0ITqAAoJELgmozMOVy/d0zEP/1O1jVERq149wM828OTyrqWz
JiFeJ3CJF8gLJcJuXexdtMo+ByhHGeVlw3hK7snJycVd+f25xCuTwDGnWqD3Svs3
J5669/9U1pBbLrvazeqdPMEzDUW3w5ahASpIHIT/FJJcj30zBzSAE/QPWeZ78lWp
FTZ3StVxkidSVlJhIBnFhn96ThvqxnUBsFrndE9NDwrOCKyd+9bDOeruJ1vdHvwT
DKpRtwWWYJ/V4ts1eJ5IaeoMHT+u/d9jPrY3RwZOW6Hb3doYuhFrW4ODiYhXcrby
YMoge1BNK3tJfIzg/GBIc0GbVtbksI+czYZFVId76VQzsx8FZ+cbEUEch2ebOMFu
NwAfscovkqcWuF6bgWSKZ1cVyH4L5la7kjHzs+rXOE/g4YRCncAG8qKGTh7xWm6y
XyilDuwjnSNPETeXRQukHPOkV8YVYB1rNhTYy465gxjpJXKLn/JUGra2p32hn3P4
d1W5l4IUM4T1zDXj6rzdB54fmaIOwtXu7BS3jmOhOwgtE3EVHi/wIiCRrVv7S3gn
CH51vWqAj8cJPgMX7vkhLZb7lcfedOdOapmE7j1fJclGymryXPUmz7M9HYd8zkhV
NiPt7Ie9thf+WAexxmesvact8OSZIWfvQK+NhymYbv8wM6Lua1AAuTIVNbsLlKX9
VbMx2FCUNKjV+CAYPosS
=nPR0
-----END PGP SIGNATURE-----

--VjjbDDhkftKkvIoRRwAuC6P7qTAbQTCmg--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
