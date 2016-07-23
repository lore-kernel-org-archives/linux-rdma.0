From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 2/3] IB/mthca: Less function calls in mthca_reset() after
 error detection
Date: Sat, 23 Jul 2016 12:59:15 +0200
Message-ID: <060a2178-afb2-28a3-9568-25c124972062@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net>
 <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
 <530A086E.8010901@users.sourceforge.net>
 <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
 <530A72AA.3000601@users.sourceforge.net>
 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
 <530B5FB6.6010207@users.sourceforge.net>
 <alpine.DEB.2.10.1402241710370.2074@hadrien>
 <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net> <546CE09B.9090101@users.sourceforge.net>
 <55b7a06e-6bb4-f1bb-e4dd-7812648ecf34@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <55b7a06e-6bb4-f1bb-e4dd-7812648ecf34@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 23 Jul 2016 11:28:30 +0200

The kfree() function was called in a few cases by the mthca_reset()
function during error handling even if the passed variables "bridge_header"
and "hca_header" contained a null pointer.

Adjust jump targets according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/mthca/mthca_reset.c | 41 +++++++++++++++----------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_reset.c b/drivers/infiniband/hw/mthca/mthca_reset.c
index c521654..6727af2 100644
--- a/drivers/infiniband/hw/mthca/mthca_reset.c
+++ b/drivers/infiniband/hw/mthca/mthca_reset.c
@@ -98,7 +98,7 @@ int mthca_reset(struct mthca_dev *mdev)
 		err = -ENOMEM;
 		mthca_err(mdev, "Couldn't allocate memory to save HCA "
 			  "PCI header, aborting.\n");
-		goto out;
+		goto put_dev;
 	}
 
 	for (i = 0; i < 64; ++i) {
@@ -108,7 +108,7 @@ int mthca_reset(struct mthca_dev *mdev)
 			err = -ENODEV;
 			mthca_err(mdev, "Couldn't save HCA "
 				  "PCI header, aborting.\n");
-			goto out;
+			goto free_hca;
 		}
 	}
 
@@ -121,7 +121,7 @@ int mthca_reset(struct mthca_dev *mdev)
 			err = -ENOMEM;
 			mthca_err(mdev, "Couldn't allocate memory to save HCA "
 				  "bridge PCI header, aborting.\n");
-			goto out;
+			goto free_hca;
 		}
 
 		for (i = 0; i < 64; ++i) {
@@ -131,7 +131,7 @@ int mthca_reset(struct mthca_dev *mdev)
 				err = -ENODEV;
 				mthca_err(mdev, "Couldn't save HCA bridge "
 					  "PCI header, aborting.\n");
-				goto out;
+				goto free_bh;
 			}
 		}
 		bridge_pcix_cap = pci_find_capability(bridge, PCI_CAP_ID_PCIX);
@@ -139,7 +139,7 @@ int mthca_reset(struct mthca_dev *mdev)
 				err = -ENODEV;
 				mthca_err(mdev, "Couldn't locate HCA bridge "
 					  "PCI-X capability, aborting.\n");
-				goto out;
+				goto free_bh;
 		}
 	}
 
@@ -152,7 +152,7 @@ int mthca_reset(struct mthca_dev *mdev)
 			err = -ENOMEM;
 			mthca_err(mdev, "Couldn't map HCA reset register, "
 				  "aborting.\n");
-			goto out;
+			goto free_bh;
 		}
 
 		writel(MTHCA_RESET_VALUE, reset);
@@ -172,7 +172,7 @@ int mthca_reset(struct mthca_dev *mdev)
 				err = -ENODEV;
 				mthca_err(mdev, "Couldn't access HCA after reset, "
 					  "aborting.\n");
-				goto out;
+				goto free_bh;
 			}
 
 			if (v != 0xffffffff)
@@ -184,7 +184,7 @@ int mthca_reset(struct mthca_dev *mdev)
 		err = -ENODEV;
 		mthca_err(mdev, "PCI device did not come back after reset, "
 			  "aborting.\n");
-		goto out;
+		goto free_bh;
 	}
 
 good:
@@ -195,14 +195,14 @@ good:
 			err = -ENODEV;
 			mthca_err(mdev, "Couldn't restore HCA bridge Upstream "
 				  "split transaction control, aborting.\n");
-			goto out;
+			goto free_bh;
 		}
 		if (pci_write_config_dword(bridge, bridge_pcix_cap + 0xc,
 				 bridge_header[(bridge_pcix_cap + 0xc) / 4])) {
 			err = -ENODEV;
 			mthca_err(mdev, "Couldn't restore HCA bridge Downstream "
 				  "split transaction control, aborting.\n");
-			goto out;
+			goto free_bh;
 		}
 		/*
 		 * Bridge control register is at 0x3e, so we'll
@@ -216,7 +216,7 @@ good:
 				err = -ENODEV;
 				mthca_err(mdev, "Couldn't restore HCA bridge reg %x, "
 					  "aborting.\n", i);
-				goto out;
+				goto free_bh;
 			}
 		}
 
@@ -225,7 +225,7 @@ good:
 			err = -ENODEV;
 			mthca_err(mdev, "Couldn't restore HCA bridge COMMAND, "
 				  "aborting.\n");
-			goto out;
+			goto free_bh;
 		}
 	}
 
@@ -235,7 +235,7 @@ good:
 			err = -ENODEV;
 			mthca_err(mdev, "Couldn't restore HCA PCI-X "
 				  "command register, aborting.\n");
-			goto out;
+			goto free_bh;
 		}
 	}
 
@@ -246,7 +246,7 @@ good:
 			err = -ENODEV;
 			mthca_err(mdev, "Couldn't restore HCA PCI Express "
 				  "Device Control register, aborting.\n");
-			goto out;
+			goto free_bh;
 		}
 		linkctl = hca_header[(hca_pcie_cap + PCI_EXP_LNKCTL) / 4];
 		if (pcie_capability_write_word(mdev->pdev, PCI_EXP_LNKCTL,
@@ -254,7 +254,7 @@ good:
 			err = -ENODEV;
 			mthca_err(mdev, "Couldn't restore HCA PCI Express "
 				  "Link control register, aborting.\n");
-			goto out;
+			goto free_bh;
 		}
 	}
 
@@ -266,7 +266,7 @@ good:
 			err = -ENODEV;
 			mthca_err(mdev, "Couldn't restore HCA reg %x, "
 				  "aborting.\n", i);
-			goto out;
+			goto free_bh;
 		}
 	}
 
@@ -275,13 +275,12 @@ good:
 		err = -ENODEV;
 		mthca_err(mdev, "Couldn't restore HCA COMMAND, "
 			  "aborting.\n");
-		goto out;
 	}
-
-out:
-	pci_dev_put(bridge);
+free_bh:
 	kfree(bridge_header);
+free_hca:
 	kfree(hca_header);
-
+put_dev:
+	pci_dev_put(bridge);
 	return err;
 }
-- 
2.9.2

