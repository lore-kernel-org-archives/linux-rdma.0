From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 3/3] IB/mthca: Delete unnecessary variable initialisations in
 mthca_reset()
Date: Sat, 23 Jul 2016 13:00:22 +0200
Message-ID: <3700e687-f8e5-edd9-2f93-54839673bb14@users.sourceforge.net>
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
Date: Sat, 23 Jul 2016 11:54:06 +0200

Three local variables will be set to an appropriate value a bit later.
Thus omit the explicit initialisation at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/mthca/mthca_reset.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_reset.c b/drivers/infiniband/hw/mthca/mthca_reset.c
index 6727af2..0a458c6 100644
--- a/drivers/infiniband/hw/mthca/mthca_reset.c
+++ b/drivers/infiniband/hw/mthca/mthca_reset.c
@@ -42,12 +42,12 @@ int mthca_reset(struct mthca_dev *mdev)
 {
 	int i;
 	int err = 0;
-	u32 *hca_header    = NULL;
+	u32 *hca_header;
 	u32 *bridge_header = NULL;
 	struct pci_dev *bridge = NULL;
 	int bridge_pcix_cap = 0;
-	int hca_pcie_cap = 0;
-	int hca_pcix_cap = 0;
+	int hca_pcie_cap;
+	int hca_pcix_cap;
 
 	u16 devctl;
 	u16 linkctl;
-- 
2.9.2

