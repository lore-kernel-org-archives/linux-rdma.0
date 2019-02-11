From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 0/2] Followup changes to mlx5-next branch
Date: Mon, 11 Feb 2019 13:56:06 +0200
Message-ID: <20190211115608.22677-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

There are two small cleanups needed after prefetch MR code was merged.

Thanks

Leon Romanovsky (2):
  net/mlx5: Align ODP capability function with netdev coding style
  net/mlx5: Factor out HCA capabilities functions

 .../net/ethernet/mellanox/mlx5/core/main.c    | 62 ++++++++++++-------
 1 file changed, 39 insertions(+), 23 deletions(-)
