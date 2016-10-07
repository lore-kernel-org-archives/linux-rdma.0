From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git (tag for-linus-2)
Date: Fri, 7 Oct 2016 18:06:24 -0400
Message-ID: <9ce0c9e1-d303-22bd-8f88-60ff48ad4ea5@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6hcnOvvkdVHLRm7H7PluLxWRqfUikCS98"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6hcnOvvkdVHLRm7H7PluLxWRqfUikCS98
Content-Type: multipart/mixed; boundary="wRuj68osqbS5OrEvrfJlMa0U5fFLFRORb";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
 linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <9ce0c9e1-d303-22bd-8f88-60ff48ad4ea5-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git (tag for-linus-2)

--wRuj68osqbS5OrEvrfJlMa0U5fFLFRORb
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

I have two separate pull requests for you today.  I'll do the simple one
first.

I had originally intended to include the rxe update patches in my main
pull request.  However, on merge tests, there were conflicts against
your tree.  It was because I had forgotten that there were late rxe
driver changes in 4.8, so like the hfi1 driver, those patches needed to
be against a late 4.8-rc kernel in order to apply cleanly.  As a result,
I was forced to make a new 4.9 branch, remove the rxe patches, then
replace the rxe patches onto the for-4.9-hfi1 branch that you already
pulled.  So this first pull request is just a few rxe specific patches
tacked onto that branch.  The incremental pull looks like this:

The following changes since commit 61347fa6087884305ea4a3a04501839fdb68dc=
76:

  IB/rdmavt: Trivial function comment corrected. (2016-10-03 10:55:27 -04=
00)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus-2

for you to fetch changes up to e404f945a6101a6f0f2a29aade6dc32015471daa:

  IB/rxe: improved debug prints & code cleanup (2016-10-06 13:50:04 -0400=
)

----------------------------------------------------------------
Minor updates for rxe driver

----------------------------------------------------------------
Parav Pandit (5):
      IB/rxe: Avoid scheduling tasklet for userspace QP
      IB/rxe: Fix sending out loopback packet on netdev interface.
      IB/{rxe,core,rdmavt}: Fix kernel crash for reg MR
      IB/rxe: Properly honor max IRD value for rd/atomic.
      IB/rxe: improved debug prints & code cleanup

Stephen Bates (1):
      rdma_rxe: Ensure rdma_rxe init occurs at correct time

 drivers/infiniband/sw/rdmavt/dma.c    | 17 +++++++++++
 drivers/infiniband/sw/rxe/rxe.c       | 36 +++++------------------
 drivers/infiniband/sw/rxe/rxe.h       |  5 ++++
 drivers/infiniband/sw/rxe/rxe_av.c    |  4 +--
 drivers/infiniband/sw/rxe/rxe_comp.c  |  6 ++--
 drivers/infiniband/sw/rxe/rxe_dma.c   | 17 +++++++++++
 drivers/infiniband/sw/rxe/rxe_loc.h   |  2 +-
 drivers/infiniband/sw/rxe/rxe_mmap.c  |  2 +-
 drivers/infiniband/sw/rxe/rxe_mr.c    |  2 +-
 drivers/infiniband/sw/rxe/rxe_net.c   | 51 ++++++++++++++++++++++-------=
---
 drivers/infiniband/sw/rxe/rxe_net.h   |  3 +-
 drivers/infiniband/sw/rxe/rxe_qp.c    | 55
+++++++++++++++++++----------------
 drivers/infiniband/sw/rxe/rxe_recv.c  |  3 +-
 drivers/infiniband/sw/rxe/rxe_req.c   | 19 ++++++------
 drivers/infiniband/sw/rxe/rxe_resp.c  | 27 +++++++++++------
 drivers/infiniband/sw/rxe/rxe_sysfs.c | 12 ++++----
 drivers/infiniband/sw/rxe/rxe_verbs.c | 50 +++++++++++++++++++----------=
--
 include/rdma/ib_verbs.h               | 23 +++++++++++++--
 18 files changed, 210 insertions(+), 124 deletions(-)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--wRuj68osqbS5OrEvrfJlMa0U5fFLFRORb--

--6hcnOvvkdVHLRm7H7PluLxWRqfUikCS98
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX+BxgAAoJELgmozMOVy/da1QP/38i4NDYCMGljLcxtSoOhTEW
FOBfYxMDvefjroVAcAG68zBiju5gKTRYhsppGuFEHUF4no/zPJHabE83i6NXhV9o
OagzPyo41Yi5vztxSPRmAdnYOwblExw0+ox/nIgwoDbh9w1ULZvt0Na46HhdUnTx
9i7dFSUIbHknqlf7sGLJvd8losySbQLHNyLf3itKXXdoJBkfGiBvDqk9nCVg3v5f
NtOR4kS5cIs52H+PAfdZUm+DTcxVI2V2N7qMzbO3/0plrmvxeB094AbmwP9Pjx/I
u8C2ROJp1NAIyTvOZHH9DyjtNo7T/v+3LWxyF0ND/EC771SEU1FhlgdROEyXkYSZ
3OcOYw/GS/jyDMLFcjpDOSCoEzfWq8If804uC0k8f2IUV3OBTae6ZKhNfjsrr48l
G0H4/wO/fBSIWNvWR7NMRfpYEiM64SmY9jJk0qbqIu7vd5rMyl7qFi9ZvE6Jrmvk
5QAftOGU6083XA5nQSnK9n/RoJ7ylOhyz7stmu7cRBurbtdPawIDTzAo1IRpwDfL
AiW+8pobs9LMHTa6UL71FLjtmR4azRy02RP506YK8ICM7zVOMNf048yg/ei9lh+P
A3h0CsZR/JWzLeKYDHVxc/blDKQnTOMjdNkjQfP32YQXfTPniXpnCgdL9xF5tKFa
DkFZb3qJ326Igyz0y54h
=xXmW
-----END PGP SIGNATURE-----

--6hcnOvvkdVHLRm7H7PluLxWRqfUikCS98--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
