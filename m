From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Mon, 28 Dec 2015 16:43:59 -0500
Message-ID: <5681AD1F.7080903@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="C8fwRo3ixBOFkLm0Kd2JqwSTwjhc8hluF"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--C8fwRo3ixBOFkLm0Kd2JqwSTwjhc8hluF
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

This should be the last pull request for the 4.4 cycle.  There are three
fixes here.  The first two were very small in terms of number of lines,
the third is more lines of change than I like this late in the cycle,
but there are positive test results from Avagotech and from my own test
setup with the target hardware, and given the problem was a 100% failure
case, I sent it through.

The following changes since commit ab5cdc31630c7596d81ca8fbe7d695f10666f3=
9b:

  IB/mlx5: Postpone remove_keys under knowledge of coming preemption
(2015-12-08 16:55:31 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to f41647ef06536199d3366530da050b411546979d:

  RDMA/be2net: Remove open and close entry points (2015-12-28 11:45:55
-0500)

----------------------------------------------------------------
Three late 4.4-rc fixes

- A previous patch updated the mlx4 driver to use vmalloc when there was
  not enough memory to get a contiguous region large enough for our needs=
,
  so we need kvfree() whenever we free that item.  We missed one place,
  so fix that now.
- A previous patch added code to match incoming packets against a specifi=
c
  device, but failed to compensate for devices that have both InfiniBand
  and Ethernet ports.  Fix that.
- Under certain vlan conditions, the ocrdma driver would fail to bring up=

  any vlan interfaces and would print out a circular locking failure.  Fi=
x
  that.

----------------------------------------------------------------
Devesh Sharma (4):
      RDMA/ocrdma: Fix vlan-id assignment in qp parameters
      RDMA/ocrdma: Dispatch only port event when port state changes
      RDMA/ocrdma: Depend on async link events from CNA
      RDMA/be2net: Remove open and close entry points

Matan Barak (1):
      IB/cma: cma_match_net_dev needs to take into account port_num

Wengang Wang (1):
      IB/mlx4: Replace kfree with kvfree in mlx4_ib_destroy_srq

 drivers/infiniband/core/cma.c               | 16 ++++----
 drivers/infiniband/hw/mlx4/srq.c            |  2 +-
 drivers/infiniband/hw/ocrdma/ocrdma.h       | 10 +++++
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 49 ++++++++++++++++++++---=
--
 drivers/infiniband/hw/ocrdma/ocrdma_hw.h    |  4 +-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  | 57
+++++++++++++----------------
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   | 49 +++++++++++++++++++++++=
--
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |  2 +-
 drivers/net/ethernet/emulex/benet/be.h      |  2 -
 drivers/net/ethernet/emulex/benet/be_main.c |  4 --
 drivers/net/ethernet/emulex/benet/be_roce.c | 36 ------------------
 drivers/net/ethernet/emulex/benet/be_roce.h |  4 +-
 12 files changed, 134 insertions(+), 101 deletions(-)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--C8fwRo3ixBOFkLm0Kd2JqwSTwjhc8hluF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWga0fAAoJELgmozMOVy/dT7MP/RpQiK4+PucDRv9k3OkfoCNu
8KOijnGKNlujuRyCj+n/liRtceVqn5FN6hd2y2vp2SKXZAbs1WGC4jpDfczJHuDg
U3j5mfAjA/5b1f2sT5jUIB4/8zXQm4gTBxIt1icIYlItTcg/dCOMP2r7RWo4AwfC
Dr79KAmi1d6TRZWTy4/dCsdHMonHhwT9kOg+tauL6RpANh8PfcweHbKd7Sj+SuL6
XJd0U7pbBsUa0KPDJlVld8u0wrQrK8UuyOukBzMUjoW4uwI4O2aiNplrsbCl4HVU
OXk8lA+YyBhppKUkmd0aEa63AqdDLTjapHnVyTQNXFAh3TEkITEXdakJw7WRfgkg
j77Xkig0X4uGzW2LW2412bKj2EoixHGnRlq3DU9gU0Nc++96JUnsH6BCYM1P0TXE
iZ6SyfiCEKRBIzb05mBT+ahom/OlfyIQ9kJ17sOdChQbSjtMjbzfNnnydkSpjaBr
jZwE5i9BNejWnzzstzk7BgIydGLSlNZOcqPsfKkyx1RyZE91IXyFMY3eY27GwCpR
KYv4HDcguoo9rq289jyriGPXuREcIXvcSyT4p55jMPQubitb05i/ZGTehDpRczPE
GuxPHorG0kYooXw4owx6Bd7uKqv4xaCz9bRdKwIhk+uo20QgzJ+wpfvqSNl+sZpB
LLpTxFKpkspYy8Ww3JSu
=yZX4
-----END PGP SIGNATURE-----

--C8fwRo3ixBOFkLm0Kd2JqwSTwjhc8hluF--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
