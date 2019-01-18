From: Jason Gunthorpe <jgg@mellanox.com>
Subject: [GIT PULL] Please pull RDMA subsystem changes
Date: Fri, 18 Jan 2019 03:56:44 +0000
Message-ID: <20190118035637.GA19600@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Doug Ledford <dledford@redhat.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Just a small batch of patches for -rc today. Thanks

The following changes since commit bfeffd155283772bbe78c6a05dec7c0128ee500c:

  Linux 5.0-rc1 (2019-01-06 17:08:20 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

for you to fetch changes up to d6f4a21f309dfe10a5693ad236358dd6fcc46f7a:

  RDMA/uverbs: Mark ioctl responses with UVERBS_ATTR_F_VALID_OUTPUT (2019-01-14 14:02:22 -0700)

----------------------------------------------------------------
First 5.0 rc pull request

Not much so far, but I'm feeling like the 2nd PR -rc will be larger than
this. We have the usual batch of bugs and two fixes to code merged this cycle.

- Restore valgrind support for the ioctl verbs interface merged this window,
  and fix a missed error code on an error path from that conversion

- A user reported crash on obsolete mthca hardware

- pvrdma was using the wrong command opcode toward the hypervisor

- NULL pointer crash regression when dumping rdma-cm over netlink

- Be conservative about exposing the global rkey

----------------------------------------------------------------
Adit Ranadive (1):
      RDMA/vmw_pvrdma: Return the correct opcode when creating WR

Gal Pressman (1):
      RDMA/uverbs: Fix post send success return value in case of error

Jason Gunthorpe (1):
      RDMA/uverbs: Mark ioctl responses with UVERBS_ATTR_F_VALID_OUTPUT

Leon Romanovsky (2):
      RDMA/nldev: Don't expose unsafe global rkey to regular user
      RDMA/mthca: Clear QP objects during their allocation

Steve Wise (1):
      RDMA/cma: Add cm_id restrack resource based on kernel or user cm_id type

 drivers/infiniband/core/cma.c                |  5 ++-
 drivers/infiniband/core/nldev.c              |  4 --
 drivers/infiniband/core/rdma_core.h          |  2 +
 drivers/infiniband/core/uverbs_cmd.c         | 11 ++++-
 drivers/infiniband/core/uverbs_ioctl.c       | 62 ++++++++++++++++++++++------
 drivers/infiniband/core/uverbs_main.c        |  1 +
 drivers/infiniband/hw/mthca/mthca_provider.c |  4 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma.h    | 35 +++++++++++++++-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c |  6 +++
 include/uapi/rdma/vmw_pvrdma-abi.h           |  1 +
 10 files changed, 109 insertions(+), 22 deletions(-)

--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfB7FMLh+8QxL+6i3OG33FX4gmxoFAlxBTnIACgkQOG33FX4g
mxp/Ng//S3v33wYj5OI5rTMVeWrMm8F/FJxidLJt43v+AH9SmMF6jdvMQZ5s6ekU
tll7poTvZj3tnv040o7G6kumH2GOcx5i2CzqJ/hSmSha/7Ir3PEas7zhgMZSJMx2
r0jFFy/VikTIXLN9hJIWs6J3X2Thvz72JScDPlY4Y7muxTgeXWCVFQ4HLK3htG52
q1WKw0xLhokF8C8DNUnwr4SjHLfFxyJAbA0Bo2YgPML05a7uY+fVnRJQMo3nuuCC
zY+PHmiYpCnubl7SEc9iUzRNsvm0k3fetqJymx1KPltpJnja7mjAu0JbFcFFWVB8
ToWo21N3O1Mg7focHauvbTH5iy8V9vLad4eqmmbIjHDGMEzy544lAcz2flf1OI7T
MjAOdPIM26JyKOmsyLSC0k6WJlwotaDNSyRjqnLDSXrZmQZi1NmWtdg/toicKo5r
MGDYivM5WxrfAzPcQbnD6w/jhTnOVJMAcgtgEYsL4yQAvBHFO168kDpyGYkVtnzL
6kSmW54bclhBhHk7llGDjUsBIN+fhKe+jw2gF6AW7O9b1acxdPe+fMsQCLty36gh
jdTIm9cq82276tgE0AZQGF1EN5j4STF7+DqZqxLIAK3MhZkMhIK83hyYyaULrxbE
2uNjEW64edf7MeTjWjizHpAvbUMbtbAlueipKTCNGYVz+dP9bfU=
=gd17
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
