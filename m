From: Jason Gunthorpe <jgg@mellanox.com>
Subject: [GIT PULL] Please pull RDMA subsystem changes
Date: Fri, 3 Aug 2018 10:11:02 -0600
Message-ID: <20180803161102.GA21002@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Torvalds <torvalds@linux-foundation.org>, Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Third pull request for -rc

Things are still slow on the RC side, this one patch has been sitting in the
git tree for a few weeks waiting for some friends. I expect this is the last
RC pull for this cycle.

The following changes since commit d63c46734c545ad0488761059004a65c46efdde3:

  RDMA/mlx5: Fix memory leak in mlx5_ib_create_srq() error path (2018-07-11 14:16:13 -0600)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

for you to fetch changes up to addb8a6559f0f8b5a37582b7ca698358445a55bf:

  RDMA/uverbs: Expand primary and alt AV port checks (2018-07-24 15:30:34 -0600)

----------------------------------------------------------------
One bug for missing user input validation:

- Refuse invalid port numbers in the modify_qp system call

----------------------------------------------------------------
Jack Morgenstein (1):
      RDMA/uverbs: Expand primary and alt AV port checks

 drivers/infiniband/core/uverbs_cmd.c | 59 +++++++++++++++++++++++++++++++++---
 1 file changed, 54 insertions(+), 5 deletions(-)

--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJbZH6UAAoJEDht9xV+IJsaxb8P/26p16KMWp5DPGTr5Kk/XxSg
fxkJb0EM2vC2kXmUQROZIIUkYwwkG/tvOYYLuRpu2mKTpPkQnIhI5ksbvOaTqN7m
+8YrfaD4eSfcQ+KVwW/6/VPHDcSHmeeIhp2ldV4TibYv8i9aE4BRk8vmm61OSPq+
k4vqAGdj4fhhWxq6+oLebsRarYgk57oXgqKmcMI6x7VQ86lcyj06Msb7xPXVhQCr
EUyPq5zreRRvgnxAby1yAtt0KV0gtzLRQ5Ko8xMHktxobzgr60fqoy6ZjUClxn8S
lPzjbL+PxOTtz7JvJ2Fu7bcEC8iAmrhxBlSdLp11Oyy7xKL13YeO0LOQnah7/LnD
5e20law3Z1K1BSDqT2FV+WZF6DmaaeqSmMkkV5bZLVLvyFLZ8HhY2XfbIy7kZ+Fs
bOQvovBztVgG3rUZqyvexBx6I7htbaoI3G7951UTR/jA8DKVI1DLobtB57AXEtVj
8A+qSRIvmnO4/IAG2eMPIxAffXlGVz6u23OYcFD9O43lPME4b1jGYLue8Ak91qdc
h/VUBsxkxm1/FaW6l2exb1Ybh69CKmtN0C+nBkL5xrAwzTmEnOreGVjn8zPBa/8W
PzCA5DEk4tWy/d2iese1UIDju781ts4XwHZZdbnphdoipE0BRijcqo0/cxEJ5i7J
+FSwEerK4XeRMr738IU0
=dJZp
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
