From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Thu, 22 Dec 2016 16:40:22 -0500
Message-ID: <19b0b1bd-8760-2c71-6932-b2834db9687b@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="IoF7jlfi8UvxOtoNFKfBaX8ogF0uCWjj1"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IoF7jlfi8UvxOtoNFKfBaX8ogF0uCWjj1
Content-Type: multipart/mixed; boundary="K85kiDm9P6d9pRBUkFGb34fRe1kvBflKx";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
 linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <19b0b1bd-8760-2c71-6932-b2834db9687b-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git

--K85kiDm9P6d9pRBUkFGb34fRe1kvBflKx
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

This is the first 4.10 rc cycle pull request.  There are a smattering of
fixes I have queued up so far.  This can be pulled now or wait until
after the New Year, I just wanted to get this off my plate so I could
enjoy my down time next week ;-)

Here's the boilerplate:

The following changes since commit 6f94ba20799b98c8badf047b184fb4cd7bc45e=
44:

  Merge branch 'vmw_pvrdma' into merge-test (2016-12-14 14:56:21 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to 5cc8fabc5e4c588c75a5ec21423e7c3425f69f48:

  IB/rxe: Don't check for null ptr in send() (2016-12-22 11:36:12 -0500)

----------------------------------------------------------------
First round of -rc fixes for 4.10 kernel

- Series of qedr fixes
- Series of rxe fixes
- One isolated i40iw fix
- One isolated cma fix
- One isolated cxgb4 fix

----------------------------------------------------------------
Amrani, Ram (8):
      qedr: configure the number of CQEs on CQ creation
      qedr: return error if destroy CQ failed
      qedr: return correct value on modify qp
      qedr: modify QP state to error when destroying it
      qedr: ignore inline flag in read verbs
      qedr: post_send/recv according to QP state
      qedr: clear the vendor error field in the work completion
      qedr: Always notify the verb consumer of flushed CQEs

Andrew Boyer (3):
      IB/rxe: Use BTH_PSN_MASK when ACKing duplicate sends
      IB/rxe: Drop future atomic/read packets rather than retrying
      IB/rxe: Don't check for null ptr in send()

Bart Van Assche (2):
      IB/rxe: Fix a memory leak in rxe_qp_cleanup()
      IB/cma: Fix a race condition in iboe_addr_get_sgid()

Chien Tin Tung (1):
      i40iw: Set 128B as the only supported RQ WQE size

Steve Wise (1):
      iw_cxgb4: set correct FetchBurstMax for QPs

 drivers/infiniband/hw/cxgb4/qp.c             |  5 ++--
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c     | 25 ++++++++++++++++----
 drivers/infiniband/hw/i40iw/i40iw_puda.c     |  2 +-
 drivers/infiniband/hw/i40iw/i40iw_type.h     |  4 +++-
 drivers/infiniband/hw/i40iw/i40iw_ucontext.h |  4 ++--
 drivers/infiniband/hw/i40iw/i40iw_uk.c       | 17 ++++++++++----
 drivers/infiniband/hw/i40iw/i40iw_user.h     |  4 +++-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c    | 21 +++++++++--------
 drivers/infiniband/hw/i40iw/i40iw_verbs.h    |  1 +
 drivers/infiniband/hw/qedr/verbs.c           | 35
++++++++++++++++++++--------
 drivers/infiniband/sw/rxe/rxe_comp.c         |  2 +-
 drivers/infiniband/sw/rxe/rxe_net.c          |  3 +--
 drivers/infiniband/sw/rxe/rxe_qp.c           |  1 +
 drivers/infiniband/sw/rxe/rxe_resp.c         |  3 ++-
 include/rdma/ib_addr.h                       |  6 +++--
 15 files changed, 90 insertions(+), 43 deletions(-)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--K85kiDm9P6d9pRBUkFGb34fRe1kvBflKx--

--IoF7jlfi8UvxOtoNFKfBaX8ogF0uCWjj1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYXEhGAAoJELgmozMOVy/dxxQP/16cT+e594bDTBKE8xyWuxnt
cIoz2o5mbTpGgKE8ZXWduwTfs0p3ZJdjMOjo3zdAsXEueld2HRbBGYBAL9YfGtcl
C0d9Lak3cPGqSDcCnfmZ7YTPXFipc5U7XFEPJV7b38X3fxICVYlzJw99gPdYyYa3
JKsdG30urInDYKlKY8FOPYMzzLpOofQgZ47ETwpB6khhMA46rXFJuaEWZqmPw/lX
1KvX+Unq9UB5x79cFjU6vCQB/at1y3q4AvI9xGcVLZzae2AT6HWEO9NsjlHdXAz8
TExYcLbc6DZQQRXaMFXAGzC88KT7A/nLLevXRIMO1XttGu+CgLSFEc3QtgZ0nFGE
gesz/WNuFehXHgvRjm3InoWhjxJGTwrlLlLr/+M/Fia0oqbwLUd1S34eq7d8m3es
j2oRgJUXFA5U3gPg4OraNbry4uGwjBP7aIAYQi0vfxxYY5sGV38aAwlZNhvcQv4b
3ZR97RblTKPu1JYut75hHsp+iSelWR5UNEk+3ib266IZV8OuETjeG2ByWC00pBsY
PhjTWbwc/iYci/N3w6M81Z7TVUBzjGNiB+KRHU+DzIHX754HunUgFooY8XohBN8I
nkT34uTrM2F+C2/BKw2f0vHugS/pjYS6HdqbzOyTH7N0sQWTdzVtGKSHxZ/EMprf
tq93bEn7PmCOFe7pjOSH
=qJ5T
-----END PGP SIGNATURE-----

--IoF7jlfi8UvxOtoNFKfBaX8ogF0uCWjj1--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
