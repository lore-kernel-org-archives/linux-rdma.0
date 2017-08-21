From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [ANNOUNCE] rdma-core-15-rc2 has been pushed/released
Date: Mon, 21 Aug 2017 09:39:57 -0400
Message-ID: <518ecaa3-26d8-aff7-2a1a-c7cd50ae20ef@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Ld1J7T9ftJrxHtiqlHr0W6hNK1lXQw48q"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Ld1J7T9ftJrxHtiqlHr0W6hNK1lXQw48q
Content-Type: multipart/mixed; boundary="7pmgo0eSfBKo2OAKWNv75PPuHAta0D0jr";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <518ecaa3-26d8-aff7-2a1a-c7cd50ae20ef-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [ANNOUNCE] rdma-core-15-rc2 has been pushed/released

--7pmgo0eSfBKo2OAKWNv75PPuHAta0D0jr
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Only a few minor changes from -rc1, and I really expect this to be close
to the official release.  The only reason I didn't make it an official
release is that I still haven't been able to run the tests on it to make
sure it works across all the hardware and that confirmation really needs
to happen before it is pushed as final.

Here's the updated tag info:

rdma-core-15-rc2

Updates from rdma-core version 14:

- Add flow steering drop action
- mmio_flush_write fixes
- Fixes for uclibc
- Add common mmio accessor routines and remove per provider mmio
  routines
- qedr fixes
- Lots of fixes for debian packaging
- Copyright fixes
- Properly conflict with infiniband-diags
- Add direct verbs support to mlx4 provider
- Improvement to Travis CI checking
- Enforce kernel coding style in rdma-core
- Add initial verbs hotplug support
- Sparse annotations
- Systemd updates for srp_daemon and iwpmd
- Red Hat packaging fixes
- Properly make the entire rdma-core support udev hotplug activation
- Packaging fixes related to the joining of packages and globs that are
  no longer valid
- Minor fixes to mlx5 and srq ping-pong

https://github.com/linux-rdma/rdma-core/releases/

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--7pmgo0eSfBKo2OAKWNv75PPuHAta0D0jr--

--Ld1J7T9ftJrxHtiqlHr0W6hNK1lXQw48q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZmuKtAAoJELgmozMOVy/da10P/1r/Izus/c6Kgkv1xF3fbomM
fnj7FrrUtEuawPwfrKQrWjVUBI2oKGHggLwTaHSKj8VMuWI0qyZrrlVb054zJQQO
Nt1zuNdEhwow7Rn0xArof2QRtifFN8BiGE3ygBbUWv+tcJoshX6Vzbawtn9E7bL2
xnBrg5d4d5uYQa30bTJ+kho51rZc7GCSbxk1j1TRxkN2gBsoPqRGwkB9kMjqAXi0
eFpSOMt2Ct/GhYtAOEh57VjA2KQxSI1z42SrEzbjKmfp1S/6Z7Tjxt+EWvV59LvJ
wlkfaHo1xRTWtBg8OjOhdGe/rtsIa61b6M74vVefyiYv88ZF1B/a2WoppEw0haWZ
jSdBRVRpw3iiUIIGzZNSgK+ukZ8tLmI1lTi/hceQQcjQb7VVMCiZTqcPwlpaO2Zl
zGpNM3Yvv1IglJin7ltEVjhRO446I5tNbXVPHQRxReTfe/MtCG2y4m7fU0JZP83Q
liWH7gNztoqWhJTTFQ+c0qR7hdFufx2wLy0AgN4c/gvcgNGWb75wviCpRrq/zz6l
1eXD0TnuOPyV4YSNYO3ZduBk4d+8Om2lWNV+BTVB1nY6u8mm3mUogmAVOTNgyOlB
9+ib4f750lid9R2w7m44zZid8x1YKOaB3MuVJmxCyAJFTzR0mT7sA150vYyDi1Oy
APQoRduUMCZy90FyMr3X
=YCO1
-----END PGP SIGNATURE-----

--Ld1J7T9ftJrxHtiqlHr0W6hNK1lXQw48q--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
