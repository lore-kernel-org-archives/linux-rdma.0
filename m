From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH net-next 0/4] VLAN tag handling cleanup
Date: Tue, 20 Nov 2018 13:20:30 +0100
Message-ID: <cover.1542716156.git.mirq-linux@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org
Cc: Ajit Khaparde <ajit.khaparde@broadcom.com>, devel@linuxdriverproject.org, Haiyang Zhang <haiyangz@microsoft.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>, Sathya Perla <sathya.perla@broadcom.com>, Somnath Kotur <somnath.kotur@broadcom.com>, Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>, Stephen Hemminger <sthemmin@microsoft.com>
List-Id: linux-rdma@vger.kernel.org

This is a cleanup set after VLAN_TAG_PRESENT removal. The CFI bit
handling is made similar to how other tag fields are used.

Michał Mirosław (4):
  net/vlan: introduce skb_vlan_tag_get_cfi() helper
  net/hyperv: use skb_vlan_tag_*() helpers
  benet: use skb_vlan_tag_get_prio()
  mlx5: use skb_vlan_tag_get_prio()

 drivers/net/ethernet/emulex/benet/be_main.c     | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c | 2 +-
 drivers/net/hyperv/netvsc_drv.c                 | 9 +++++----
 include/linux/if_vlan.h                         | 3 ++-
 4 files changed, 9 insertions(+), 7 deletions(-)

-- 
2.19.1
