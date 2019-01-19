From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 2/4] net/mlx5: Add pci AtomicOps request
Date: Fri, 18 Jan 2019 16:33:11 -0800
Message-ID: <20190119003313.16711-3-saeedm@mellanox.com>
References: <20190119003313.16711-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190119003313.16711-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>, Michael Guralnik <michaelgur@mellanox.com>, Majd Dibbiny <majd@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Michael Guralnik <michaelgur@mellanox.com>

Calling pci_enable_atomic_ops_to_root enables AtomicOp requests to pci
root port.

AtomicOp requests will be enabled only if the completer and all
intermediate pci bridges support PCI atomic operations.
This, together with appropriate settings in the NVCONFIG should enable
PCI atomic operations on the device.

PCI atomic operations were first introduced in PCI Express Base Specification
2.1. The Supported operations are Swap (Unconditional Swap), CAS (Compare and
Swap) and FetchAdd (Fetch and Add).

Unlike other atomic operation modes PCI atomic operations gives the user
the option to do atomic operations on local memory, without involving verbs
api, without it compromising the operation's atomicity.

Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index be81b319b0dc..085e1133b8d5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -693,6 +693,11 @@ static int mlx5_pci_init(struct mlx5_core_dev *dev, struct mlx5_priv *priv)
 		goto err_clr_master;
 	}
 
+	if (pci_enable_atomic_ops_to_root(pdev, PCI_EXP_DEVCAP2_ATOMIC_COMP32) &&
+	    pci_enable_atomic_ops_to_root(pdev, PCI_EXP_DEVCAP2_ATOMIC_COMP64) &&
+	    pci_enable_atomic_ops_to_root(pdev, PCI_EXP_DEVCAP2_ATOMIC_COMP128))
+		mlx5_core_dbg(dev, "Enabling pci atomics failed\n");
+
 	dev->iseg_base = pci_resource_start(dev->pdev, 0);
 	dev->iseg = ioremap(dev->iseg_base, sizeof(*dev->iseg));
 	if (!dev->iseg) {
-- 
2.20.1
