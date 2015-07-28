From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Tue, 28 Jul 2015 10:37:08 -0400
Message-ID: <55B79394.1090305@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WTaXfaK0KDREMmmXkCRMDftaANfknliGg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WTaXfaK0KDREMmmXkCRMDftaANfknliGg
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

The following changes since commit d8b2ba7c5928173fe1c12bd2545f5ed85d1c3c=
7a:

  IB/core: Destroy ocrdma_dev_id IDR on module exit (2015-07-14 13:20:16
-0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to b8f5595eb96c9fce1c907d13e89581e5061edf2e:

  RDMA/ocrdma: update ocrdma module license string (2015-07-24 11:34:41
-0400)

----------------------------------------------------------------
Changes for 4.2-rc

- Two minor bug fixes
- Relicense ocrdma driver to dual license, GPL or BSD

----------------------------------------------------------------
Devesh Sharma (2):
      RDMA/ocrdma: update ocrdma license to dual-license
      RDMA/ocrdma: update ocrdma module license string

Jason Gunthorpe (1):
      IB/ipoib: Fix CONFIG_INFINIBAND_IPOIB_CM

Steve Wise (1):
      RDMA/cxgb3: fail get_dma_mr on 64 bit arches

 drivers/infiniband/hw/cxgb3/iwch_provider.c |  4 +++
 drivers/infiniband/hw/ocrdma/ocrdma.h       | 53
+++++++++++++++++----------
 drivers/infiniband/hw/ocrdma/ocrdma_abi.h   | 53
+++++++++++++++++----------
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c    | 53
+++++++++++++++++----------
 drivers/infiniband/hw/ocrdma/ocrdma_ah.h    | 53
+++++++++++++++++----------
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 53
+++++++++++++++++----------
 drivers/infiniband/hw/ocrdma/ocrdma_hw.h    | 53
+++++++++++++++++----------
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  | 55
++++++++++++++++++-----------
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   | 53
+++++++++++++++++----------
 drivers/infiniband/hw/ocrdma/ocrdma_stats.c | 53
+++++++++++++++++----------
 drivers/infiniband/hw/ocrdma/ocrdma_stats.h | 53
+++++++++++++++++----------
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 53
+++++++++++++++++----------
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h | 53
+++++++++++++++++----------
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c  |  3 +-
 14 files changed, 415 insertions(+), 230 deletions(-)


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--WTaXfaK0KDREMmmXkCRMDftaANfknliGg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVt5OUAAoJELgmozMOVy/dEuMQALNYiK/1qlOIvUvnpGoQuyK+
xnZWMrsQ7XQsW6zfiog/+qo7DGMyHmDmJodUprTqg9QoFZlFWaFDqGGWbVFiABhd
/Qs8XrM12n25D4j3k8wyptoCC0HKDxZYnbIQRqYY4L5efiUgVjEKjJ7MvfYlmNkB
b/up50rEelO5HGRIZnV3L4sGxHS0pS16thWEV1dbosw0XYBHubOL7BuAUUWAyymV
+J7+NIIFpiL8VlnGeRi5DkRYfnB3JvgSCH5RO64wlV2qtf/sYwB/acSHdftpeu64
j6Mptk4+SgVTsT09+9KLs2wN0I8eSb9egVGmcd/Yk7WArARr68oVxWngJMT5xx2P
REJf1GlD+t6jX+v+vXe5u6Un+W9IAK7m2IOq+IJPW4gcv8oyC4h+MP9Al2MMlVis
qGSWNl8hXHBnFAMmMo29ClR51bc335+6umaewoAFCokJ1lvMooGGkUGsaCRgYwHf
0eS0vk/4xAdmQvtkudQVetbX4/SKEBTjP2qHZBs89gsx81r2Xkpbv3KM64ZK9TJ8
Vw8m2rfCmKJ76izrlf+M8jrGhF7VkI0rznSAJUunAFs2MX5Yqyz5qQH6J7DZvLks
XN75NThudCy2WLgLVIQClHptSUdGmW0i5AL7pKzs3ynQnGSZpQ3Gl2IRq+QxDmlY
4bp79E/jXWIc3QuvKh1I
=62VW
-----END PGP SIGNATURE-----

--WTaXfaK0KDREMmmXkCRMDftaANfknliGg--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
