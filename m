From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Fri, 6 May 2016 16:11:54 -0400
Message-ID: <3b794d06-5ad6-f163-6bc6-df0200129dd0@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="h5snOVcsoP7P8xVWP4c52UuhiJlfLHEMr"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--h5snOVcsoP7P8xVWP4c52UuhiJlfLHEMr
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

I have one more fix queued up for -rc.

The following changes since commit 4c8bb95921e9ac01b9dd0c3abbaf6514ce88af=
92:

  RDMA/nes: don't leak skb if carrier down (2016-04-28 21:11:09 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to 9c674815d346305068b27bf03b5e86b659a1b111:

  IB/iser: Fix max_sectors calculation (2016-05-05 12:41:24 -0400)

----------------------------------------------------------------
Late 4.6-rc fixes

- Fix for max sector calculation in iSER

----------------------------------------------------------------
Christoph Hellwig (1):
      IB/iser: Fix max_sectors calculation

 drivers/infiniband/ulp/iser/iscsi_iser.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--h5snOVcsoP7P8xVWP4c52UuhiJlfLHEMr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXLPqKAAoJELgmozMOVy/dIQ0QAIQzSE3E1TPlhZJYfTdFyYfE
2iNKU+JcYDI2hERnjEimxZ6BnV9lVWk2W5BZFzByfJ49DKRnnTSwhxkGOEAHbnjU
2hI5zgEU4keusB3g7tJEPhjQ8G5sNo0fKOXI6Xc0VPXizCa6VPZwdd4Qdrwx9cUd
D1BYK3VY0yxHDMDF5A55pfsjHvPD7gDjUCDzEa1JWgCth5xP8NGj10g8wEYv5ayH
8sDB59unS+IALbAGF+rC0TAoQ+ex9LB5UEVNewT+QJzVA2FO4ixjeixFZy7Xh9Ew
57RSEzJUU/7JXQ+xWE4jdRFpIucP3c6H1s17NHqNeFXh/3u8uPZkFmwcMPS6xuQg
H9Z7bV2UZe8O6EzqRjcKMkgDLp6hHlEd8B/Z35EpXKyIPnjYN2XoULpkics4uPVS
3a0kvTj14wgT0jlSZXE9sLMHYBquJ0rKlBpLVfY1XDEdSiljXH4K2+ieb2/jET3x
rT0oyOXvDhVSWn1SJ0AlJuDzVGd62w0+enfsWl0Sq5/NMLbq6DGDVvbEKzvZiqcg
P2zldtTOhHWqoQW1MCkbXUXU86T4Whq6jnhFMdyy0q1MFr3+VGcJ0AkcbneEuicA
qK+r4XJO0n7grOQiMPo+JFeyNa1qvaEpEpmHnwcrPeErIFTRO2O9IzrnqbV7o0wh
7sAC9r6B6Xael+UA1t0f
=lUha
-----END PGP SIGNATURE-----

--h5snOVcsoP7P8xVWP4c52UuhiJlfLHEMr--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
