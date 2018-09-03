From: Alexandru Gagniuc <mr.nuke.me@gmail.com>
Subject: [PATCH 9/9] nfp: Do not call pcie_print_link_status()
Date: Mon,  3 Sep 2018 13:02:36 -0500
Message-ID: <20180903180242.14504-10-mr.nuke.me@gmail.com>
References: <20180903180242.14504-1-mr.nuke.me@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180903180242.14504-1-mr.nuke.me@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-pci@vger.kernel.org, bhelgaas@google.com
Cc: keith.busch@intel.com, alex_gagniuc@dellteam.com, austin_bolen@dell.com, shyam_iyer@dell.com, Alexandru Gagniuc <mr.nuke.me@gmail.com>, Ariel Elior <ariel.elior@cavium.com>, everest-linux-l2@cavium.com, "David S. Miller" <davem@davemloft.net>, Michael Chan <michael.chan@broadcom.com>, Ganesh Goudar <ganeshgr@chelsio.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Tariq Toukan <tariqt@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Jakub Kicinski <jakub.kicinski@netronome.com>, Dirk van der Merwe <dirk.vandermerwe@netronome.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org, oss-drivers@netronome.com
List-Id: linux-rdma@vger.kernel.org

This is now done by the PCI core to warn of sub-optimal bandwidth.

Signed-off-by: Alexandru Gagniuc <mr.nuke.me@gmail.com>
---
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c
index c8d0b1016a64..87dde0f787e9 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c
@@ -1328,7 +1328,6 @@ struct nfp_cpp *nfp_cpp_from_nfp6000_pcie(struct pci_dev *pdev)
 	/*  Finished with card initialization. */
 	dev_info(&pdev->dev,
 		 "Netronome Flow Processor NFP4000/NFP6000 PCIe Card Probe\n");
-	pcie_print_link_status(pdev);
 
 	nfp = kzalloc(sizeof(*nfp), GFP_KERNEL);
 	if (!nfp) {
-- 
2.17.1
