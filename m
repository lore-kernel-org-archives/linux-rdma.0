From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: [PATCH 0/3] Clean up users of skb_tx_hash and __skb_tx_hash
Date: Fri, 27 Apr 2018 14:06:22 -0400
Message-ID: <20180427180142.4883.96259.stgit@ahduyck-green-test.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org, davem@davemloft.net
Cc: linux-rdma@vger.kernel.org, dennis.dalessandro@intel.com, niranjana.vishwanathapura@intel.com, tariqt@mellanox.com
List-Id: linux-rdma@vger.kernel.org

I am in the process of doing some work to try and enable macvlan Tx queue
selection without using ndo_select_queue. As a part of that I will likely
need to make changes to skb_tx_hash. As such this is a clean up or refactor
of the two spots where he function has been used. In both cases it didn't
really seem like the function was being used correctly so I have updated
both code paths to not make use of the function.

My current development environment doesn't have an mlx4 or OPA vnic
available so the changes to those have been build tested only.

---

Alexander Duyck (3):
      opa_vnic: Just use skb_get_hash instead of skb_tx_hash
      mlx4: Don't bother using skb_tx_hash in mlx4_en_select_queue
      net: Revoke export for __skb_tx_hash, update it to just be static skb_tx_hash


 drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.c   |   21 ++++++++++----------
 .../infiniband/ulp/opa_vnic/opa_vnic_internal.h    |    2 +-
 drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c  |    2 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |    2 +-
 include/linux/netdevice.h                          |   13 ------------
 net/core/dev.c                                     |   10 ++++------
 6 files changed, 17 insertions(+), 33 deletions(-)
