From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Thu, 14 Jul 2016 09:45:21 -0400
Message-ID: <9ef4cff7-869e-23a2-ded7-f3fb3553e0e3@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="0F3swFGOUrQ9D7rQljbmVdKIraVofaq6J"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0F3swFGOUrQ9D7rQljbmVdKIraVofaq6J
Content-Type: multipart/mixed; boundary="tqqdUXxRl1T4bv2TCXJeTKSl8nVmXGMoV"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
 linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <9ef4cff7-869e-23a2-ded7-f3fb3553e0e3-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git

--tqqdUXxRl1T4bv2TCXJeTKSl8nVmXGMoV
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

This is a fairly small set of late rc fixes.  Nothing very controversial
or needing a lot of explanation.  Here's the boiler plate:

The following changes since commit 9903fd1374e913f5086b58af09d4e3fd6e9e86=
fe:

  Merge branches '4.7-rc-misc', 'hfi1-fixes', 'i40iw-rc-fixes' and
'mellanox-rc-fixes' into k.o/for-4.7-rc (2016-06-23 12:22:33 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to 8e0e7aedadb877d91a6e66611464165c969bc0a9:

  i40iw: Enable remote access rights for stag allocation (2016-07-12
10:46:34 -0400)

----------------------------------------------------------------
Round three of 4.7 rc fixes

- Two fixes for hfi1
- Two fixes for i40iw
- On ommission correction in the port table counter arrays

----------------------------------------------------------------
Christoph Lameter (1):
      IB core: Add port_xmit_wait counter

Mike Marciniszyn (1):
      IB/hfi1: Correct issues with sc5 computation

Nicolas Iooss (1):
      i40iw: do not print unitialized variables in error message

Shiraz Saleem (1):
      i40iw: Enable remote access rights for stag allocation

Tadeusz Struk (1):
      IB/hfi1: Fix sleep inside atomic issue in init_asic_data

 drivers/infiniband/core/sysfs.c           |  4 ++++
 drivers/infiniband/hw/hfi1/chip.c         | 16 +++++++++-------
 drivers/infiniband/hw/hfi1/ud.c           | 23 +++--------------------
 drivers/infiniband/hw/i40iw/i40iw_main.c  |  3 +--
 drivers/infiniband/hw/i40iw/i40iw_verbs.c |  1 +
 5 files changed, 18 insertions(+), 29 deletions(-)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--tqqdUXxRl1T4bv2TCXJeTKSl8nVmXGMoV--

--0F3swFGOUrQ9D7rQljbmVdKIraVofaq6J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXh5dxAAoJELgmozMOVy/d1jYP+wXU9EkE/3AyIbuyRz9Bnu/l
xZz4AFsPJkB82Fa9YcLxDSLW6G3nN1xal1Kq95dAz6/lkRRHRAIx70LaMEskb+eK
tZHORcfg/KRcl6vzGrRBEoL2uDRBRBR/3KpKElslj5Dyo6OWci6+IKDMzUalalOX
uPenblNYLBhBrN595ekBUw4aAw1H+EjGDxV2iJfkf3ZPsK6XN7JsHt2RoULZ3xVZ
zalrhQmVGNtCkgnynMfXQ6Zfd6T3Bd4gChGBLYpC5Tlw0FT6HRGmH9Kqy29BzydI
b9nbMa6apWTtGoaStsxk0OVr4BNDw8zt8GNHpH+I1rGVMGvlg3N5ABeLW07EfVJh
cdMYxbVCndzStDkugg4qKSFg8l8ljE6njEgHtL9xQEhCYzXZod2ZUXPqP3h2IxK3
RmVsZ3ucRNhU+GPqYN4/ge6nDsrfxftHYgh2lV92pHz9STkbYGx16rnjoEyUkFWB
xYDTDNfyO37anARN+Ieohkw0KKTQGLqOj4K/mcCyeB6qJpW7z1Uyl0IFJMiAV90C
a+Fq55eSD6xh7rxIWryWKUN8D+sKT5xPxcTcAe+3u7MAw7NL2Uv7vUfiA6vrh1yH
4imcm7BUoeD4WeK/ZlmwQoO4CjKMbHzcNn7jBp2DYJgicjUlAUM6WAAK+t3/rWwM
X9JeIe3DNdnLjm8dzTWz
=IRR9
-----END PGP SIGNATURE-----

--0F3swFGOUrQ9D7rQljbmVdKIraVofaq6J--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
