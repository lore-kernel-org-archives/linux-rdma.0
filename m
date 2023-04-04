Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D824DC6FD1D
	for <linux-rdma@archiver.kernel.org>; Tue,  4 Apr 2023 21:56:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236265AbjDDV4H (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 4 Apr 2023 17:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236554AbjDDV4D (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 4 Apr 2023 17:56:03 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CB0424EF7;
        Tue,  4 Apr 2023 14:56:01 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 990E39200B3; Tue,  4 Apr 2023 23:55:58 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 96A0992009E;
        Tue,  4 Apr 2023 22:55:58 +0100 (BST)
Date:   Tue, 4 Apr 2023 22:55:58 +0100 (BST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Mahesh J Salgaonkar <mahesh@linux.ibm.com>,
        Oliver O'Halloran <oohall@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lukas Wunner <lukas@wunner.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Stefan Roese <sr@denx.de>, Jim Wilson <wilson@tuliptree.org>,
        David Abdurachmanov <david.abdurachmanov@gmail.com>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        linux-pci@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 1/7] PCI: Export PCI link retrain timeout
In-Reply-To: <alpine.DEB.2.21.2304042200040.37565@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2304042232270.37565@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2304042200040.37565@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Rename LINK_RETRAIN_TIMEOUT to PCIE_LINK_RETRAIN_TIMEOUT and make it
available via "pci.h" for PCI drivers to use.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
---
No change from v6.

No change from v5.

New change in v5.
---
 drivers/pci/pci.h       |    2 ++
 drivers/pci/pcie/aspm.c |    4 +---
 2 files changed, 3 insertions(+), 3 deletions(-)

linux-pcie-link-retrain-timeout.diff
Index: linux-macro/drivers/pci/pci.h
===================================================================
--- linux-macro.orig/drivers/pci/pci.h
+++ linux-macro/drivers/pci/pci.h
@@ -11,6 +11,8 @@
 
 #define PCI_VSEC_ID_INTEL_TBT	0x1234	/* Thunderbolt */
 
+#define PCIE_LINK_RETRAIN_TIMEOUT HZ
+
 extern const unsigned char pcie_link_speed[];
 extern bool pci_early_dump;
 
Index: linux-macro/drivers/pci/pcie/aspm.c
===================================================================
--- linux-macro.orig/drivers/pci/pcie/aspm.c
+++ linux-macro/drivers/pci/pcie/aspm.c
@@ -90,8 +90,6 @@ static const char *policy_str[] = {
 	[POLICY_POWER_SUPERSAVE] = "powersupersave"
 };
 
-#define LINK_RETRAIN_TIMEOUT HZ
-
 /*
  * The L1 PM substate capability is only implemented in function 0 in a
  * multi function device.
@@ -213,7 +211,7 @@ static bool pcie_retrain_link(struct pci
 	}
 
 	/* Wait for link training end. Break out after waiting for timeout */
-	end_jiffies = jiffies + LINK_RETRAIN_TIMEOUT;
+	end_jiffies = jiffies + PCIE_LINK_RETRAIN_TIMEOUT;
 	do {
 		pcie_capability_read_word(parent, PCI_EXP_LNKSTA, &reg16);
 		if (!(reg16 & PCI_EXP_LNKSTA_LT))
