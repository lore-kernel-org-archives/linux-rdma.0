From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Wed, 20 May 2015 18:35:21 -0400
Message-ID: <1432161321.28905.11.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-H4t3o1mkSzfyNji0M9Tu"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-H4t3o1mkSzfyNji0M9Tu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

This should hopefully be the last request for 4.1-rc for the RDMA stack.
It contains some late ocrdma fixes that I'm including because they are
small and self contained.  It also contains two bug fixes that are
simple and easily verified.


  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git tags/for-=
linus

----------------------------------------------------------------
Changes for 4.1-rc4

  A number of small, well contained bug fixes for ocrdma driver
  A simple fix for the connection negotiation sequence on IB
  Fix for broken AF_IB address on UD queue pair support

----------------------------------------------------------------
Devesh Sharma (3):
      RDMA/ocrdma: Report EQ full fatal error
      RDMA/ocrdma: Fix QP state transition in destroy_qp
      RDMA/ocrdma: Use VID 0 if PFC is enabled and vlan is not configured

Matthew Finlay (1):
      IB/cma: Fix broken AF_IB UD support

Mitesh Ahuja (3):
      RDMA/ocrdma: Fix the request length for RDMA_QUERY_QP mailbox command=
 to FW.
      RDMA/ocrdma: Prevent allocation of DPP PDs if FW doesnt support it
      RDMA/ocrdma: Fix dmac resolution for link local address

Naga Irrinki (1):
      RDMA/ocrdma: Fail connection for MTU lesser than 512

Selvin Xavier (2):
      RDMA/ocrdma: Fix EQ destroy failure during driver unload
      RDMA/ocrdma: Update ocrdma version number

Ted Kim (1):
      ib/cm: Change reject message type when destroying cm_id

 drivers/infiniband/core/cm.c                |  2 +-
 drivers/infiniband/core/cma.c               | 32 +++++++----
 drivers/infiniband/hw/ocrdma/ocrdma.h       |  4 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c    | 12 ++++-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 83 +++++++++++++++++--------=
----
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   |  9 ++++
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 12 +++--
 7 files changed, 101 insertions(+), 53 deletions(-)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-H4t3o1mkSzfyNji0M9Tu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVXQwpAAoJELgmozMOVy/dUNMP/ii3cgGmydl8a4kFD41UyJgJ
t6h5uAn3VoibTyM4TZNLee07PDzee56zLLl0uIQsjmkKAXjr6uh1u1EBQIGo6II0
VI7FAH7kBRpCw3KSmMElBSYWN6Kw+wwzV2P+0b5WC+lSLWSHuJL13aSwijPsHvjJ
joCstKLbbptg7GD00Fyq8QbpOjWvTouw98kC9j5nnG/rSQHC03HZGfhZal1JgZSv
aL1y8v8eD8f95Fezq3szM2QuLlXWWT6RInl07DMhV2KeUWWki1fBOh0MwU2XX5JH
Sq7w3vF86SIGdEMyWIvk8ordCCp3ZMLS278izKmNY3CrMl1Q7YRmtUf7bfSblMbQ
45XqOuSB29pmkhGLi1xCDm+WD07ijaXeUrF1tSf03cpXw1BuJ24tFf5W5TYQRsoz
BSR8NDvkUkMfoQXUwY08LvOwk2+n6f8xOZwy6qqiSJ4pdnuDsox9+KWHX5ToWQwJ
uf74H1fI32Y8QW33o17wNZbtgQiH4LnURKk+DplVe/UjYrGC8g6KTBd6h28dDnZk
VEFeh0go1vFVKNgXbWhnlJUKQJ+tnYNqw3t0vwhT5M1zipf9D3myC5HdYUtOE6TV
pex0+EgPviCF4v02eFy6pdOYfWsaRmMddT/YA9YTHakRZ7BZEaVVN76Y3b5iOOMJ
5Kaqo0OvrNFVJSM9oFuW
=dRHk
-----END PGP SIGNATURE-----

--=-H4t3o1mkSzfyNji0M9Tu--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
