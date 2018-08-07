From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 00/33] net: ethernet: Mark expected switch fall-throughs
Date: Tue, 7 Aug 2018 18:09:00 -0500
Message-ID: <cover.1533675546.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Solarflare linux maintainers <linux-net-drivers@solarflare.com>, Edward Cree <ecree@solarflare.com>, Bert Kenward <bkenward@solarflare.com>, Jes Sorensen <jes@trained-monkey.org>, linux-acenic@sunsite.dk, Michael Chan <michael.chan@broadcom.com>, Nicolas Ferre <nicolas.ferre@microchip.com>, Derek Chickles <derek.chickles@caviumnetworks.com>, Satanand Burla <satananda.burla@caviumnetworks.com>, Felix Manlunas <felix.manlunas@caviumnetworks.com>, Raghu Vatsavayi <raghu.vatsavayi@caviumnetworks.com>, Ganesh Goudar <ganeshgr@chelsio.com>, Santosh Raspatur <santosh@chelsio.com>, Sunil Goutham <sgoutham@cavium.com>, Robert Richter <rric@kernel.org>, linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, Sathya Perla <sathya.perla@broadcom.com>, Ajit
List-Id: linux-rdma@vger.kernel.org

Hi all,

In preparation to enabling -Wimplicit-fallthrough, this patchset aims
to add some annotations in order to mark switch cases where we are
expecting to fall through.

Thanks

Gustavo A. R. Silva (33):
  8390: axnet_cs: Mark expected switch fall-through
  alteon: acenic: mark expected switch fall-through
  bnx2x: Mark expected switch fall-thoughs
  net: macb: Mark expected switch fall-through
  liquidio: mark expected switch fall-through
  cxgb4/l2t: Mark expected switch fall-through
  cxgb4/t4_hw: mark expected switch fall-throughs
  cxgb3/l2t: Mark expected switch fall-through
  net: thunderx: mark expected switch fall-through
  net: tulip_core: mark expected switch fall-through
  net: tulip: de4x5: mark expected switch fall-throughs
  be2net: Mark expected switch fall-through
  net: hns: Mark expected switch fall-through
  net: hns3: Mark expected switch fall-through
  i40e_main: mark expected switch fall-through
  i40e_txrx: mark expected switch fall-through
  net/mlx4/mcg: Mark expected switch fall-throughs
  net/mlx4/en_rx: Mark expected switch fall-throughs
  igb_main: Mark expected switch fall-throughs
  igb: e1000_82575: Mark expected switch fall-through
  igb: e1000_phy: Mark expected switch fall-through
  igbvf: netdev: Mark expected switch fall-through
  vxge: Mark expected switch fall-throughs
  net/mlx5e: Mark expected switch fall-throughs
  qed: qed_dev: Mark expected switch fall-throughs
  netxen_nic: Mark expected switch fall-throughs
  qede: qede_fp: Mark expected switch fall-through
  qlcnic: Mark expected switch fall-througs
  qlge: mark expected switch fall-through
  net: ethernet: sxgbe: mark expected switch fall-throughs
  net: sfc: falcon: mark expected switch fall-through
  net: tlan: Mark expected switch fall-through
  net: ethernet: ti: cpts: mark expected switch fall-through

 drivers/net/ethernet/8390/axnet_cs.c                    | 1 +
 drivers/net/ethernet/alteon/acenic.c                    | 1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c               | 2 +-
 drivers/net/ethernet/cadence/macb_ptp.c                 | 1 +
 drivers/net/ethernet/cavium/liquidio/lio_main.c         | 1 +
 drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c     | 1 +
 drivers/net/ethernet/chelsio/cxgb3/l2t.c                | 1 +
 drivers/net/ethernet/chelsio/cxgb4/l2t.c                | 1 +
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c              | 3 +++
 drivers/net/ethernet/dec/tulip/de4x5.c                  | 6 ++++++
 drivers/net/ethernet/dec/tulip/tulip_core.c             | 1 +
 drivers/net/ethernet/emulex/benet/be_ethtool.c          | 1 +
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c        | 1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c         | 1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c             | 1 +
 drivers/net/ethernet/intel/i40e/i40e_txrx.c             | 3 ++-
 drivers/net/ethernet/intel/igb/e1000_82575.c            | 1 +
 drivers/net/ethernet/intel/igb/e1000_phy.c              | 1 +
 drivers/net/ethernet/intel/igb/igb_main.c               | 2 ++
 drivers/net/ethernet/intel/igbvf/netdev.c               | 1 +
 drivers/net/ethernet/mellanox/mlx4/en_rx.c              | 2 ++
 drivers/net/ethernet/mellanox/mlx4/mcg.c                | 2 ++
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c        | 2 ++
 drivers/net/ethernet/neterion/vxge/vxge-config.c        | 3 +++
 drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c | 3 ++-
 drivers/net/ethernet/qlogic/qed/qed_dev.c               | 4 ++--
 drivers/net/ethernet/qlogic/qede/qede_fp.c              | 2 ++
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c     | 3 ++-
 drivers/net/ethernet/qlogic/qlge/qlge_mpi.c             | 1 +
 drivers/net/ethernet/samsung/sxgbe/sxgbe_ethtool.c      | 2 ++
 drivers/net/ethernet/sfc/falcon/ethtool.c               | 1 +
 drivers/net/ethernet/ti/cpts.c                          | 1 +
 drivers/net/ethernet/ti/tlan.c                          | 1 +
 33 files changed, 52 insertions(+), 6 deletions(-)

-- 
2.7.4
