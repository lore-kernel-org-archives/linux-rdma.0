Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF47493D5D;
	Mon, 12 Oct 2026 13:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791810524; cv=none; b=IKx3i7uUO8ZzMtyfZ7mUBpKV2rwViFL8nhkwOvn3ODCSvO3uYCmOmAuLqCIq0K1XVqo6/PRB79XnVdhPm9Go4apzAXSs7KOG8oCfjG8BVbCnwDpZwu626vHGGSZ1vTTka9ICJlv7dFiGwSljMp9UhWh/b28Qo+g90fx6SK8o4ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791810524; c=relaxed/simple;
	bh=jeYW+ZRQGv4qjF4rQsYtYYlh4cZFsWJS/5Qwu2/vTwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l1s+fCL+U1hbwUwOI1mi9dSrgDC67D4FIm+RimWr7zYfW7LVFg/RhfM6IFZ4i2V1OYZffzlJlvKBfUiWmoXYejOlxRwvX4W2opWLoTl06lzYR9aGKCxT1lVrtQKF7ync0ePj2CEkOOfNQa0RwVqzvTXNxxTsXnXM7SSkpi7HQLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QtSOrXfk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QtSOrXfk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE891F0089B;
	Mon, 12 Oct 2026 13:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791810522;
	bh=Lfe+1ERzgvtSzL1O8LkNkhmE+OpOLVM3bIE5raJxWS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QtSOrXfk/wCHEc+O6x4haxMtPvhBBS6y6uzkDZabOXzZ5P0sNRmrLKWhd4vOLfaTt
	 x4MeuoUQj8haEKA7sZWKZtwY+FQ1X/J+5BOzx504mQ5xo3OoSvLxTEfz6h+VMCJTGH
	 pj/GMk62GIoXk3J//kCF4ElqZqnUdxCjGQ0WJpQSb00rcJKoLo9L0ju1Is5AkcyZXO
	 fBlaoAeKPpGvAEMG6UOoi8NWG5sapL8mdKEeDWZo2NJkqdql5Los55juKBXyuMbrBy
	 5RLmPXLOzlQXFONQC1uJYNpJakrr1Mj2BTJcPgUIOmrBvAIim0mhmoTiHGFKFkyUKW
	 Xk0t7QC9m+0NQ==
From: Leon Romanovsky <leon@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	=?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
	=?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Cc: linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	iommu@lists.linux.dev,
	Tushar Dave <tdave@nvidia.com>,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-rdma@vger.kernel.org,
	kvm@vger.kernel.org,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH v10 08/18] PCI/P2PDMA: Route Relaxed Ordering Completions directly
Date: Mon, 12 Oct 2026 16:07:45 +0300
Message-ID: <20261012-fix-p2p-acs-v4-0-v10-8-6ffe7b7a4517@nvidia.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261012-fix-p2p-acs-v4-0-v10-0-6ffe7b7a4517@nvidia.com>
References: <20261012-fix-p2p-acs-v4-0-v10-0-6ffe7b7a4517@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

ACS P2P Completion Redirect leaves Completions carrying the Relaxed
Ordering attribute alone. PCIe r7.0 sec 6.12.1.1 redirects only those "that
do not have the Relaxed Ordering Attribute bit set", and sec 7.7.12.5
describes the enable bit as "applicable only to Completions whose Relaxed
Ordering Attribute is clear". P2PDMA reports one answer for every kind of
TLP, so a client that sets Relaxed Ordering on its Non-Posted Requests,
and therefore receives such Completions (sec 2.2.9.1), is sent through
the host bridge for a redirect that never happens to it.

Route Completions directly for the classes that set
PCI_P2PDMA_TLP_RELAXED_CPL.

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Tested-by: Tushar Dave <tdave@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 479bf58104ca..e6482467e121 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -542,11 +542,15 @@ pci_acs_p2pdma_request(u16 ctrl, unsigned int tlp_flags)
 /*
  * Decide how a peer-to-peer Completion at an ACS-capable ingress port routes.
  * PCIe r7.0 sec 6.12.1.1: no ACS control other than P2P Completion Redirect
- * affects a Completion.
+ * affects a Completion, and that one leaves Completions carrying the Relaxed
+ * Ordering attribute alone.
  */
 static enum pci_acs_p2pdma_state
 pci_acs_p2pdma_completion(u16 ctrl, unsigned int tlp_flags)
 {
+	if (tlp_flags & PCI_P2PDMA_TLP_RELAXED_CPL)
+		return PCI_ACS_P2PDMA_DIRECT;
+
 	return ctrl & PCI_ACS_CR ? PCI_ACS_P2PDMA_REDIRECT :
 				   PCI_ACS_P2PDMA_DIRECT;
 }

-- 
2.55.0

