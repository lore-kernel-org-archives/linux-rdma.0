From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Thu, 22 Oct 2015 10:34:41 -0400
Message-ID: <5628F401.2030805@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="jDAVKxKEt5asJFauFTFR7cbXW9ULFeH3d"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jDAVKxKEt5asJFauFTFR7cbXW9ULFeH3d
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

It's late in the game, I know, but these fixes seemed important enough
to warrant a late pull request.  They all involve oopses or use after
frees or corruptions.  Explanation of each in the tag message.  Thanks!

The following changes since commit 0b5c9279e568d90903acedc2b9b832d8d78e82=
88:

  IB/ipoib: For sendonly join free the multicast group on leave
(2015-10-13 16:43:59 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to 0ca81a2840f77855bbad1b9f172c545c4dc9e6a4:

  IB/cm: Fix rb-tree duplicate free and use-after-free (2015-10-21
15:43:12 -0400)

----------------------------------------------------------------
Changes for 4.3-rc6

6 serious fixes:

1) Hold the mutex around the find and corresponding update of our gid
2) The ifa list is rcu protected, copy its contents under rcu to avoid
   using a freed structure
3) On error, netdev might be null, so check it before trying to release i=
t
4) On init, if workqueue alloc fails, fail init
5) The new demux patches exposed a bug in mlx5 and ipath drivers, we need=

   to use the payload P_Key to determine the P_Key the packet arrived on
   because the hardware doesn't tell us the truth
6) Due to a couple convoluted error flows, it is possible for the CM to
   trigger a use_after_free and a double_free of rb nodes.  Add two
   checks to prevent that.  This code has worked for 10+ years.  It is
   likely that some of the recent changes have caused this issue to
   surface.  The current patch will protect us from nasty events for
   now while we track down why this is just now showing up.

----------------------------------------------------------------
Doron Tsur (2):
      IB/core: Fix memory corruption in ib_cache_gid_set_default_gid
      IB/cm: Fix rb-tree duplicate free and use-after-free

Haggai Eran (2):
      IB/cma: Potential NULL dereference in cma_id_from_event
      IB/cma: Use inner P_Key to determine netdev

Matan Barak (1):
      IB/core: Fix use after free of ifa

Sasha Levin (1):
      IB/ucma: check workqueue allocation before usage

 drivers/infiniband/core/cache.c         |  2 +-
 drivers/infiniband/core/cm.c            | 10 +++++++++-
 drivers/infiniband/core/cma.c           |  6 +++---
 drivers/infiniband/core/roce_gid_mgmt.c | 35
+++++++++++++++++++++++++--------
 drivers/infiniband/core/ucma.c          |  7 ++++++-
 5 files changed, 46 insertions(+), 14 deletions(-)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--jDAVKxKEt5asJFauFTFR7cbXW9ULFeH3d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWKPQBAAoJELgmozMOVy/dOhwP/1/8dR9n2ACIkOR5ECMfe8eS
HXYICIsu+PGqFratIxUFWwuEmdWyBRUZMRIMUfQbbXStO1i8vwJ/rxvf3PXLXQkc
ped+Fw025cAQQtwlkCfHrPE3mjWtkJitAS0cH41ms58aKKMYfRVRppYqlNzZ4NL5
GN+4FnKfUBhyG4FB0peEd3PZHlNnLy8fA0ZhzDJK0uisAJRbbTSJg7k4Usx/obar
5DQ1V9eCLNcG1FDUmXjWXxvUj0Abz40aunuJ/hVAOIA5vIHOAGBYJxMXqvFbhOMM
h+5bWoZvVZB9Djv4v88p6yeoaH0W90BfMCo3prXdc7Viyn59FP6/48c81BxBU/Gv
TyJ+PtMUtmzq5X9Sc/Q03TRMx5RCRp/hmTAXcePcKOc6C4Hh2T2Q8YkoN/eyLc0g
oIIeMNuP+xJA9y5+hS4dJe3GiU0evSBlTzgD0+Qn863ZVDckGwQIQRZC19v/Kwtc
ZVr7w00c/laSQGy6tE4SgJ0Yww+pg8r9dkCiooTkku9NhPT/EuzZwMhCNDVECU0F
917XVAACVgGR+e/AyRciw+ldmkljtWraxP76tO7l1WpONZawzVhlFI0+Zj2WklZv
3o/RVOr/aLKYHcYgOlRwm7CdB8pJN0/L4nqXBQES0oEUfkewCNarmq/Z/wR46Eit
h1cNlZew//0OiSL8B17B
=jvUQ
-----END PGP SIGNATURE-----

--jDAVKxKEt5asJFauFTFR7cbXW9ULFeH3d--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
