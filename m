From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Wed, 6 Apr 2016 11:23:14 -0700
Message-ID: <57055412.70907@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="eV0iC13GDuWhMoOJLI1faR1blSoFivMTP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Torvalds Linus <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--eV0iC13GDuWhMoOJLI1faR1blSoFivMTP
Content-Type: multipart/mixed; boundary="qng4K9BViAN5okA5BM1a0Qp58XxqBHmEQ"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Torvalds Linus <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
 RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <57055412.70907-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git

--qng4K9BViAN5okA5BM1a0Qp58XxqBHmEQ
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

I'm back from PTO.  These issues cropped up while I was gone and are
simple fixes.  I'll have more after I've caught up, but I wanted to get
these in quick.

The following changes since commit 9735a22799b9214d17d3c231fe377fc852f042=
e9:

  Linux 4.6-rc2 (2016-04-03 09:09:40 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to 2fe7857176ad6b70e8b2a318506525410e774f34:

  i40iw: avoid potential uninitialized variable use (2016-04-06 10:37:16
-0400)

----------------------------------------------------------------
Two minor fixes for 4.6-rc2

- Fix mlx5 build error when on demand paging is not enabled
- Fix possible uninit variable in new i40iw driver

----------------------------------------------------------------
Arnd Bergmann (2):
      IB/mlx5: fix VFs callback function prototypes
      i40iw: avoid potential uninitialized variable use

 drivers/infiniband/hw/i40iw/i40iw_cm.c | 10 +++-------
 drivers/infiniband/hw/mlx5/mlx5_ib.h   | 18 +++++++++---------
 2 files changed, 12 insertions(+), 16 deletions(-)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
     GPG Key ID: 0E572FDD


--qng4K9BViAN5okA5BM1a0Qp58XxqBHmEQ--

--eV0iC13GDuWhMoOJLI1faR1blSoFivMTP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJXBVQSAAoJELgmozMOVy/dJi8P/0PAEAeQCttD4fMR2qM+HFmu
GjMM+QP0IWKjVaUuUpSFzw21L90NvvBjttKtETkCAeJxyZ4WSWLtCLTjl23Z6fvE
v1HnGuTO8hHUl0U+oQy2MMmLxX6CNITmc700CBiCZb++7/57X0TX9h/GOjsuffdK
WVI76GDk8CJyh2AwpJcIgeuRoMvN28Q8icc/yXnBbJAT+5aB//0X9wnQNMCuF3Qj
wkNdbdm9DLgj5DLd+hkBZwmRYATq+kBBnTAbtH5BOuF3a1sEbV9vQpsmALm2bpfN
hKb0UHLUVTelDT+3L/q+xQ0nbyczNOIZd/F8dbrlwYzPy9KtKps/cwcBjkuWzzFr
nDtDS/Dtt/kb37o+uDGfvNaLLVde1NQqultsf8sLpBpKH/c4yS2XYe9mHVVf5Pth
GKKX8ufZz1ZMKBpOGVYsmAlZclycVDyG0mU2DtrBrmW/L6J75AylZkSxjPy4XMCG
FZpXmFiNKrbEHDE2Ea1+QeOCSzbF3bpZ0VzNDOQZIZpPLXgJ+FHL7fu5CS3fj1d2
Ca6m9fG3n38FmNupkh53PI9/akWkPVp8Y6QwQn1DkPjo/rszU4KI3l6fxCWiX/Ra
62V4RP3K+AJv2qxlE8N5Aex9pTOHER/UHq84m+AugHJk73XkJjCS5KaJHCY1MLTb
BwJy5RNS5ihFUrDkB833
=wlgD
-----END PGP SIGNATURE-----

--eV0iC13GDuWhMoOJLI1faR1blSoFivMTP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
