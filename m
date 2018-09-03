From: Alexandru Gagniuc <mr.nuke.me@gmail.com>
Subject: [PATCH 0/9] Export PCIe bandwidth via sysfs
Date: Mon,  3 Sep 2018 13:02:27 -0500
Message-ID: <20180903180242.14504-1-mr.nuke.me@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-pci@vger.kernel.org, bhelgaas@google.com
Cc: keith.busch@intel.com, alex_gagniuc@dellteam.com, austin_bolen@dell.com, shyam_iyer@dell.com, Alexandru Gagniuc <mr.nuke.me@gmail.com>, Ariel Elior <ariel.elior@cavium.com>, everest-linux-l2@cavium.com, "David S. Miller" <davem@davemloft.net>, Michael Chan <michael.chan@broadcom.com>, Ganesh Goudar <ganeshgr@chelsio.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Tariq Toukan <tariqt@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Jakub Kicinski <jakub.kicinski@netronome.com>, Dirk van der Merwe <dirk.vandermerwe@netronome.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org, oss-drivers@netronome.com
List-Id: linux-rdma@vger.kernel.org

This is a follow-on series to
Commit 2d1ce5ec2117 ("PCI: Check for PCIe Link downtraining")

The remaining issues was that some pcie drivers print link status directly,
sometimes resulting in duplicate system log messages with degraded links.

>From my understanding, the maintainers of these drivers are fine with
removing the duplicate prints as long as the bandwidth information is
readily available. sysfs seemed to be the consensus.

Example:

	$ cat /sys/bus/pci/devices/0000:b1:00.0/available_bandwidth
	7.876 Gb/s


Alexandru Gagniuc (9):
  PCI: sysfs: Export available PCIe bandwidth
  bnx2x: Do not call pcie_print_link_status()
  bnxt_en: Do not call pcie_print_link_status()
  cxgb4: Do not call pcie_print_link_status()
  fm10k: Do not call pcie_print_link_status()
  ixgbe: Do not call pcie_print_link_status()
  net/mlx4: Do not call pcie_print_link_status()
  net/mlx5: Do not call pcie_print_link_status()
  nfp: Do not call pcie_print_link_status()

 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  |  1 -
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  1 -
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  3 ---
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c  |  3 ---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 26 -------------------
 drivers/net/ethernet/mellanox/mlx4/main.c     |  7 -----
 .../net/ethernet/mellanox/mlx5/core/main.c    |  4 ---
 .../netronome/nfp/nfpcore/nfp6000_pcie.c      |  1 -
 drivers/pci/pci-sysfs.c                       | 13 ++++++++++
 9 files changed, 13 insertions(+), 46 deletions(-)

-- 
2.17.1
