From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Wed, 10 Feb 2016 17:34:37 -0500
Message-ID: <56BBBAFD.20406@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="n7Wheu0POutLo6jcGAMPw73dqaAQ9A3sM"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--n7Wheu0POutLo6jcGAMPw73dqaAQ9A3sM
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

A few more minor fixes for rc3:

The following changes since commit b85d9905a7ca128f24e3a4e60ff2a1b0cd58ae=
7c:

  staging/rdma: remove deprecated ipath driver (2016-02-03 11:10:58 -0500=
)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to 7425f410ca6cffe81400906286f80e8e15d9b301:

  RDMA/ocrdma: Fixing ocrdma debugfs directory remove (2016-02-05
15:14:28 -0500)

----------------------------------------------------------------
4.5-rc3 fixes

- One fix to ipoib
- One fix to core sysfs code
- Four patches that resolve an oops found in testing of ocrdma and a coup=
le
  other ocrdma issues

----------------------------------------------------------------
Carol L Soto (1):
      IB/IPoIB: Do not set skb truesize since using one linearskb

Colin Ian King (1):
      IB/sysfs: remove unused va_list args

Selvin Xavier (4):
      RDMA/ocrdma: Initialize stats resources in the driver before ib
device registration.
      RDMA/ocrdma: populate max_sge_rd in device attributes
      RDMA/ocrdma: Fix pkey_index returned by driver in rq work completio=
n
      RDMA/ocrdma: Fixing ocrdma debugfs directory remove

 drivers/infiniband/core/sysfs.c             |  2 --
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  |  6 ++++++
 drivers/infiniband/hw/ocrdma/ocrdma_stats.c | 16 +++++-----------
 drivers/infiniband/hw/ocrdma/ocrdma_stats.h |  2 ++
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |  7 +++----
 drivers/infiniband/ulp/ipoib/ipoib_ib.c     |  2 --
 6 files changed, 16 insertions(+), 19 deletions(-)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--n7Wheu0POutLo6jcGAMPw73dqaAQ9A3sM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWu7r9AAoJELgmozMOVy/dlY0P/itLTRTCpvGhrXr2Vv2nRF4p
YIbxbCIB8ST9I1uPeQKzfVqDjWLqiFv4T5DgeYJDoZHJkYTH5MKlL/SHBiBrycBr
N2ahu2774eZjk+3aO5riTJIxxlpM9AiBmnVhDOqo8yyyYOmAnFIcsnfYQSkZ8FUH
NR7Nm0BN9tbGu9gCcabynzVfIINvZxXaxfBFCb+AvzgmXAqAUSQpVAmn1T1fgSxi
BQkSgAlnBFk0UpOFeiTFDrD9JWdT30UEQGlU7Yy4QeGpo41VTFiK3ydFfE+Ww0fe
xnl/dYZ5jKdeEdOZzIjhWb6D9j8TCzpdzyKHOa+Oka2RB1dCUTImgTCBG9D3fdH9
ywzoPhjHCie8paQRoAA6Vxvi5IOLw+h84N8cybf3CZg76aoR7iNhp5vpeYGiWyQK
SqQ7oPsGeDuaJ+EPc98zpZvSpgQm7Dd2SiLdMPetCFf+xh2qVAmdllL4pkVhjG6l
PNpAJOcd5ijVAiA0czTiwKy6O5woFrau128/6HrMwRk/lJ/AglMa7zgw71/QjcDH
1ODzrOiZziZHz42u4D2iroC0Qs7vJ8P294O0Axcp59zT+/CVsa0hkm6qg6G9E+ei
UD0vuPJZPZ+U5zysAO+vF7syG29uJEcYbU0aApYTp0RlGVkXkUPvqhWFQa48Z5k5
2fkOadupjOJW1raYqw+S
=xvtU
-----END PGP SIGNATURE-----

--n7Wheu0POutLo6jcGAMPw73dqaAQ9A3sM--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
