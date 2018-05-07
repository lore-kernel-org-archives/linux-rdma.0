From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][for-next 0/6] Mellanox, mlx5 updates 2018-05-07
Date: Mon,  7 May 2018 16:52:58 -0700
Message-ID: <20180507235304.25085-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>, Jason Gunthorpe <jgg@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Hi Dave & Doug,

This pull request includes misc updates and cleanups for mlx5 core
driver for both net and rdma next branches, for more information please
see tag log below.

Please pull and let me know if there's any problem.

Thanks,
Saeed.

---

The following changes since commit 60cc43fc888428bb2f18f08997432d426a243338:

  Linux 4.17-rc1 (2018-04-15 18:24:20 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git tags/mlx5-updates-2018-05-07

for you to fetch changes up to a8408f4e6db775e245f20edf12b13fd58cc03a1c:

  net/mlx5: fix spelling mistake: "modfiy" -> "modify" (2018-05-04 12:11:51 -0700)

----------------------------------------------------------------
mlx5-updates-2018-05-07

mlx5 core driver misc cleanups and updates:
 - fix spelling mistake: "modfiy" -> "modify"
 - Cleanup unused field in Work Queue parameters
 - dump_command mailbox length printed
 - Refactor num of blocks in mailbox calculation
 - Decrease level of prints about non-existent MKEY
 - remove some extraneous spaces in indentations

----------------------------------------------------------------
Colin Ian King (2):
      net/mlx5: remove some extraneous spaces in indentations
      net/mlx5: fix spelling mistake: "modfiy" -> "modify"

Leon Romanovsky (1):
      net/mlx5: Decrease level of prints about non-existent MKEY

Moshe Shemesh (2):
      net/mlx5: Refactor num of blocks in mailbox calculation
      net/mlx5: Fix dump_command mailbox length printed

Tariq Toukan (1):
      net/mlx5: Cleanup unused field in Work Queue parameters

 drivers/net/ethernet/mellanox/mlx5/core/cmd.c     | 28 ++++++++++++-----------
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/mr.c      |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/qp.c      | 18 +++++++--------
 drivers/net/ethernet/mellanox/mlx5/core/wq.h      |  1 -
 6 files changed, 27 insertions(+), 27 deletions(-)
