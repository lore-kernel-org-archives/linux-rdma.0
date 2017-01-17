From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: ANNOUNCE - New release of rdma-core
Date: Tue, 17 Jan 2017 15:09:04 -0500
Message-ID: <1484683744.2406.29.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-akROtZftfbnGkDRbarPu"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-akROtZftfbnGkDRbarPu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The final upstream release of version 12 of the rdma-core package has
been tagged and pushed to github.

This marks the first official release of the rdma-core package, and
also the first release of libibverbs not to be hosted on kernel.org and
openfabrics.org.

For the libibverbs git repo, I have deleted all of its contents and
left behind a README file to point people to the new rdma-core repo on
github. =C2=A0I would suggest maintainers of the other components pulled
into rdma-core do the same thing. =C2=A0I did a similar thing in the
download area for verbs, modifying the README file to let people know
about the new package.

This also marks a new means of verifying the contents of releases.
=C2=A0Unlike tarballs with uploaded sha1sums or the like, we are using the
git tag mechanism to uniquely identify the code that makes up a
release. =C2=A0If you don't see a validated PGP signature on the tag, then
don't trust it. =C2=A0The github interface makes it easy to tell if a given
release is verified as it throws a "Verified" badge up on the release
when it is PGP signed. =C2=A0You can then download either a zip or tar.gz
file from the github release. =C2=A0I don't know if the contents of that
tarball are subject to minor changes (such as file ordering, or access
timestamps), so a tarball sha1sum is not necessarily even possible when
using the git repo tag mechanism to denote releases. =C2=A0However, the git
scm in general makes tags so reliable that this should not be a concern
to anyone.

The release is version 12, and the tag is:

tag rdma-core-12
Tagger: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date:=C2=A0=C2=A0=C2=A0Tue Jan 17 14:17:36 2017 -0500

This is the final version 12 release of rdma-core

- Merge all upstream sources into the single rdma-core package
- Provide nice packaging for RPM and Debian based systems
- First release of combined package, targetting the 4.9 kernel as
=C2=A0 a matched release.=C2=A0=C2=A0This package will work with other kern=
els,
=C2=A0 but fully supports all of the features in the 4.9 kernel.
- Move upstream to github
- Add libqedr provider
- Add libi40iw provider
- Add librxe (SoftRoCE) provider
- Add libhns provider
- Straighten out copyright files and make license consistent across
=C2=A0 source code portions
- Introduce flow steering improvements
- Replace code taken from linux kernel (and possibly under the GPL,
even
=C2=A0 though at least some of it seemed to possibly be not copyrightable
due
=C2=A0 to the Merger Doctrine) with undoubtedly license compatible CCAN cod=
e
=C2=A0 (list.h and a few other minor library type code bases)
- Drop use of autotools for building and libtool for library building
=C2=A0 and instead use CMake and ninja build tools
-----BEGIN PGP SIGNATURE-----
iQIcBAABAgAGBQJYfm/RAAoJELgmozMOVy/doBMP/jyqxfkUd/eweDIeUHX7werD
l16cT3hHNHUx2T0XnGejT0UTSQgUKDbO6WLOg3+1bC2uKY7Cue0bmV5+VYbs53i8
Q8ifMiARXZKQwR0Q4XI504T0cTkwHYw+y6nzG35exs7dp2rtAclL5gM/YfaonbPs
G38VUV3v4m4+1BpIgMSg7YQngtALVT9uyLjHYv7ppXu1sKCQJ92uaLQfGhvGM4aA
sWDDODJt+mxC2scg0eU1Fy170edc13+styjRk8SXdRk02c6XWDMyKZ8USzN5Gwvq
QoMhxlia/+qzO1LFOcrNLP7AJMYQ1o+fho6yJQoP94EqdFVwNicgt38FGaHJ5aKw
tVVBe7hVHLtJLXrh+G2RBvHuFeQ8/w319QQxTExQYPJ37nnPF4vL8OnyOketntET
+z11Yxa8Jx8gTf+qvv0f7HlWhdtu5rJOUNW19u8vnyrgvFsFwTQcVDDqJsQSK0xS
6gtx3dZc9NpLQtFEIHkZSXUV8FD82GHeFqkLJ1Ee+MR68Tp4/7g0ZHdIwsV/dU1D
kzbdWVnVVWCzJhbEdABl3loNzazD5BIzhrm+C9v69X86hGbGPQY4Wct9izCWk0VP
Y2BuAyMoPeanXssak0n9Bd8dYcKbtVQdg9ijAIiOjoDbyxFmLpY1N0PVXv84o7L8
lqzBuqC1aZOWtqS7CJGV
=3D6REJ
-----END PGP SIGNATURE-----

commit 26398cbf74de32f622ae86ad4cbfa6a3792ba616
Merge: fc645ff22e54 5fc5b4e26307
Author: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date:=C2=A0=C2=A0=C2=A0Tue Jan 17 16:00:14 2017 +0200

=C2=A0=C2=A0=C2=A0=C2=A0Merge pull request #54 from bdrung/master
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0debian: Improve packaging


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-akROtZftfbnGkDRbarPu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYfnngAAoJELgmozMOVy/dmTIP/R2xLLSJppIz0Shjm1I+A1TW
qCb9m0sg+aXAiHYOpkTTizZTbSbFGTLtyBrRt1ry/iTtRYhPJhpj8rMxj6/6P7P1
bcjv+oVQYZV/0KF9tU0G6VodFVWaqY9ka++hN/kliIvDMpjVZfarKo1/eqkKJe6A
UfqAJt6uN63IjIpgDpbDW+wOht8JuBE7RFOkjPTckKvAYaKZ9JOH243Ybt/pntlp
mfyXPDUekqwXoNaU/4jLhnzecAsKeEHKrjuhpXbY6oudErS3ikv6fUANE+FcslI0
pfHzDPL4+BbwLxETO5aKp5+S4OTKHF1GOG7I6sAX4bY3yvARl5yeZ+OaElG+d0N2
C7o0eQW1G+nGktMKYtE2xItL34s5ia84nvuQp4woCN9hQNblSklNb9NfYjWrYgSB
xqoT/SsbrKa9fDsyj5MQBQPp4GdI2pSQOxxTFtNBfGYvXqnY7HZ/w8VrUWe40Dvy
rzFIq/EIkCQG6zoeDcLFHJ8TnuOLRxkFshLOAE1GzWjpHzMNqeW5HlNokyIe720q
J0dRsUw0LhNdosQAtwWbKGBiPoY5yoW+SGQa2cK9ylm58wMidFCDctVTYy0C6Cec
6XyF6rYiCnuAqfz5e4auqXYoGl0DM3xy9yYXNAXuTnodQX/yIT66krV6NsOkT6tD
hSvBm+JES6vmvyzA2GqH
=31Ft
-----END PGP SIGNATURE-----

--=-akROtZftfbnGkDRbarPu--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
