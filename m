Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C153A381E94;
	Fri, 21 Aug 2026 18:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787337501; cv=none; b=DFyJE+ahScHtJ41oUdhsd4+VEKkYCCyXi03t7WQxCURc/ZEgSwA551jDdUVxX0mTLuPhu+V/Lh7M5KJHlpU3BqyEG58j9nzzeS3ebULibVOnWrqo3lmW8p7pDWwQLHOAwJJTt4SQRqbAtFlAtjlc6RjYI/esDBAUjyIKJUWRg+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787337501; c=relaxed/simple;
	bh=4j8pYSywgvMU2lJIS+Rm10mNROhwBmPrBC8NO4ituEc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=icq2sN6bOXjRV94QyQSUntYKBrnt3+FLHWtpYTstyK7SctNwDpxGtozHrZHmhCLi0FpOsO20Rq2BjobKqepe2celtDd6b7TSYr+TY6+9kyHzA+boYKG4QBvBd4Wl5OIm711flUoEwiVqYWviiyxZDu04gpfWWQ95Bp5SFdhMtNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id A980820B7128; Fri, 21 Aug 2026 11:37:47 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A980820B7128
From: Long Li <longli@microsoft.com>
To: Long Li <longli@microsoft.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	shradhagupta@linux.microsoft.com,
	Simon Horman <horms@kernel.org>,
	ernis@linux.microsoft.com,
	stephen@networkplumber.org
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net] net: mana: Cap MSI-X vectors to the device MSI-X table size
Date: Fri, 21 Aug 2026 11:37:36 -0700
Message-ID: <20260821183736.733296-1-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mana_gd_query_max_resources() sizes gc->num_msix_usable from resp.max_msix
and the CPU count, but never from the device MSI-X table. On a 1792 vCPU
M-series VM that yields 1793 while the table has 1024 entries, and
mana_gd_setup_remaining_irqs() then walks indices 1..1792, running off the
end of the region mapped by msix_map_region():

  BUG: unable to handle page fault for address: ff8e347f8b99800c
  RIP: 0010:msix_prepare_msi_desc+0x7a/0x90
  RAX: 0000000000004000 RBX: ff4330cb164ea780 RCX: ff8e347f8b998000
  Call Trace:
   <TASK>
   __msi_domain_alloc_irqs+0x13a/0x440
   msi_domain_alloc_irq_at+0x149/0x1b0
   mana_gd_setup+0x351/0x890
   mana_gd_probe+0x274/0x390
   </TASK>

RAX is index 1024 * PCI_MSIX_ENTRY_SIZE, one entry past the table.

msi_insert_desc() does range check the index, but only against the MSI
domain hwsize, which matches the table only for devices on an MSI parent
domain. With a global PCI/MSI domain hwsize is MSI_XA_DOMAIN_SIZE, so
nothing bounds the request.

Cap num_msix_usable with pci_msix_vec_count().

Fixes: 755391121038 ("net: mana: Allocate MSI-X vectors dynamically")
Signed-off-by: Long Li <longli@microsoft.com>
---
 .../net/ethernet/microsoft/mana/gdma_main.c   | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index ed9af314e4ede3ea0422694bd1f2f652f9c10478..f92b2d0bf926e1b715ff665d37f8173a2103e6fe 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -182,6 +182,7 @@ static int mana_gd_query_max_resources(struct pci_dev *pdev)
 	struct gdma_query_max_resources_resp resp = {};
 	struct gdma_general_req req = {};
 	unsigned int max_num_queues;
+	unsigned int msix_vec_count;
 	u8 bm_hostmode;
 	u16 num_ports;
 	int err;
@@ -218,6 +219,24 @@ static int mana_gd_query_max_resources(struct pci_dev *pdev)
 		gc->num_msix_usable = min(resp.max_msix, num_online_cpus() + 1);
 	}
 
+	/* MSI-X vectors are allocated by index into the device MSI-X table, so
+	 * never ask for more than the table holds. It can be smaller than both
+	 * resp.max_msix and the CPU count.
+	 */
+	err = pci_msix_vec_count(pdev);
+	if (err <= 0) {
+		dev_err(gc->dev, "Failed to query MSI-X table size: %d\n", err);
+		return err < 0 ? err : -ENOSPC;
+	}
+	msix_vec_count = err;
+
+	if (gc->num_msix_usable > msix_vec_count) {
+		dev_info(gc->dev,
+			 "Limiting MSI-X vectors from %u to table size %u\n",
+			 gc->num_msix_usable, msix_vec_count);
+		gc->num_msix_usable = msix_vec_count;
+	}
+
 	if (gc->num_msix_usable <= 1)
 		return -ENOSPC;
 

base-commit: 746fc0787f616da418ffc04a110296fe95d53491
-- 
2.43.0

