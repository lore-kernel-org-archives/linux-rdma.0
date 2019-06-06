From: Jason Gunthorpe <jgg@mellanox.com>
Subject: [GIT PULL] Please pull RDMA subsystem changes
Date: Thu, 6 Jun 2019 20:14:24 +0000
Message-ID: <20190606201420.GA9763@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Doug Ledford <dledford@redhat.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Things are looking pretty quiet here in RDMA, not too many bug fixes rolling
in right now. Here is the first batch of proposed rc fixes.

Thanks,
Jason

The following changes since commit a188339ca5a396acc588e5851ed7e19f66b0ebd9:

  Linux 5.2-rc1 (2019-05-19 15:47:09 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

for you to fetch changes up to 4f240dfec6bcc852b124ea7c419fb590949fbd4c:

  RDMA/efa: Remove MAYEXEC flag check from mmap flow (2019-05-29 13:13:03 -0300)

----------------------------------------------------------------
5.2 First rc pull request

The usual driver bug fixes and fixes for a couple of regressions introduced in
5.2:

- Fix a race on bootup with RDMA device renaming and srp. SRP also needs to
  rename its internal sys files

- Fix a memory leak in hns

- Don't leak resources in efa on certain error unwinds

- Don't panic in certain error unwinds in ib_register_device

- Various small user visible bug fix patches for the hfi and efa drivers

- Fix the 32 bit compilation break

----------------------------------------------------------------
Gal Pressman (2):
      RDMA/uverbs: Pass udata on uverbs error unwind
      RDMA/efa: Remove MAYEXEC flag check from mmap flow

Jason Gunthorpe (1):
      RDMA/core: Clear out the udata before error unwind

Kamal Heib (1):
      RDMA/core: Fix panic when port_data isn't initialized

Kamenee Arumugam (1):
      IB/hfi1: Validate page aligned for a given virtual address

Leon Romanovsky (2):
      RDMA/srp: Rename SRP sysfs name after IB device rename trigger
      RDMA/hns: Fix PD memory leak for internal allocation

Michal Kubecek (1):
      mlx5: avoid 64-bit division

Mike Marciniszyn (3):
      IB/rdmavt: Fix alloc_qpn() WARN_ON()
      IB/hfi1: Insure freeze_work work_struct is canceled on shutdown
      IB/{qib, hfi1, rdmavt}: Correct ibv_devinfo max_mr value

 drivers/infiniband/core/device.c              | 49 +++++++++++++++++++--------
 drivers/infiniband/core/rdma_core.h           |  2 ++
 drivers/infiniband/core/uverbs_cmd.c          | 30 +++++++++++-----
 drivers/infiniband/core/uverbs_std_types_cq.c |  2 +-
 drivers/infiniband/core/uverbs_std_types_mr.c |  2 +-
 drivers/infiniband/hw/efa/efa_verbs.c         |  1 -
 drivers/infiniband/hw/hfi1/chip.c             |  1 +
 drivers/infiniband/hw/hfi1/user_exp_rcv.c     |  3 ++
 drivers/infiniband/hw/hfi1/verbs.c            |  2 --
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c    |  1 +
 drivers/infiniband/hw/mlx5/cmd.c              |  9 +++--
 drivers/infiniband/hw/mlx5/main.c             |  2 +-
 drivers/infiniband/hw/qib/qib_verbs.c         |  2 --
 drivers/infiniband/sw/rdmavt/mr.c             |  2 ++
 drivers/infiniband/sw/rdmavt/qp.c             |  3 +-
 drivers/infiniband/ulp/srp/ib_srp.c           | 18 +++++++++-
 include/rdma/ib_verbs.h                       |  1 +
 17 files changed, 95 insertions(+), 35 deletions(-)

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfB7FMLh+8QxL+6i3OG33FX4gmxoFAlz5dBkACgkQOG33FX4g
mxqKzA/6A4oEKSMyJt3TMx2Z6sJoHYWqibV/AZsra4wgA0rzGPdV3cpIwg7qeccD
dMAecHl6GILXs3dCZVKs/C5cLL9YDBBpwFWlVR4eu4BppeDA9dKt66rI2a+JFbUb
taSjmTnNUAiBWG9HhZAy2KQMARgNcvwQ+4z5USMzUXclDTTQ3w2s4hjtxDrxOb2V
24Xnep5VGS7ca0wNocypa1SwbilRR0Z+3axHbKvMFXT0LsJsDf52VRcX2JaxMNXG
7L/HKI78PVQLiz0Y8qJjTiiHeM8RDpgrf8pEIa+XnUKXvTn5YoVDI8RwOyZ3qC9G
5dLVOXOAvvJ8pLRXGwsAwvxwqHkV2EbbsODXqwXx8tqlvID7ENVMn3sZDIc9l9cp
j3aEuh1mL3iQLxuLz9Ye2cWgUEEzrQkpIGfI25lV5VFZ/G1h77aUIANkB561jWM+
TiVMo3/2qbY/KBQ8M7chYCx+EgrCisd6Yw4l7ghbVR5q69RMWdhNT7QP9frblva4
p1kRW2FyQcstLol87jQJn5eSngU9lF9W4C+o28mG97Nn6pIFX7pivTwrRFi9A6LE
5OvTvYjB7kuJNNtGmG/H1DWLBv7TIw/0Xp9X/bJs2ULG9tjYuS17gNhmH0YnX2NK
tY59L6/d849+9Nn+28uOOoB76cugQHG6qFe2e5TzuqZMAFmxKbI=
=FV44
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
