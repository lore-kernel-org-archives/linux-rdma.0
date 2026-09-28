Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828BD30FF36;
	Mon, 28 Sep 2026 11:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790594407; cv=none; b=QXARuVXHQ8cxABSKqZ5QdQYAA2SajxxDKpuBuwgbbXH+yWVbzgSItiyKmOuIJi7LDgRFDqBWSoifCjqUSElWB1kDgTRLNnvIPTYotEYAXk7C3pR43kAXSbTd5X938gdYj6/taW4O5GI/SPEwmPrKGp+o6NGtMRCD1O9/6ivUAMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790594407; c=relaxed/simple;
	bh=4sHP7t4/qYoLXzGS9nC3p7voVPTSl3Ld3e5XlpzoFN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NUDz61mWJL/EFpo+Pnm4PZ9Ip1CEosmNqvwLftuxrCokMYxRCV4rqiBUvLxKxYFK3SUqLFDbIlGwkSIOqomQwcKOHe9yVfArGumPvcyH7RhBCvh+bBwgTvMCzu15fej+krWy/wnehVPReAHC67ZwbxaIXkUFAn32/Y4hPTd6+SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eoT8rD5h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eoT8rD5h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0159E1F0089A;
	Mon, 28 Sep 2026 11:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790594406;
	bh=yOfwH475UIunTVSjhVJApEwqbwhbhTluIDEtUEzcBgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eoT8rD5htORBTBARFTjaR6/ivcn9/EU93xdrc4rqDEEJ0xfnumCJVwKa+80ANWLCc
	 IQNZsdrhm94a0f4b+BnbFUZFDDxtG/N/Ei9Y6fhfavMW8jun33cfhCCCjMM36Deha2
	 bCoSJss3HuaLtQvmmssumvkDEYJuVa7F+h+yS3Vd9k4JT1+aZK8BkguZsEzu5xaOsC
	 A3kKL3SrrcXfu/ZJFnzk6/V14dqiPl/6ilSDd1XN0XqzoYKmqw4X+6N6M/DQRy0BCx
	 MMmcolOIgtPD6BNFiJMfOeutJdBntuSDC2a9wMcucJZO+oCfSE+S1zXxE6mEOiCTB2
	 jNP88mUj2oCcQ==
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
Subject: [PATCH v8 08/23] PCI/P2PDMA: Route Relaxed Ordering Completions directly
Date: Mon, 28 Sep 2026 14:19:12 +0300
Message-ID: <20260928-fix-p2p-acs-v4-0-v8-8-404453b9c435@nvidia.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928-fix-p2p-acs-v4-0-v8-0-404453b9c435@nvidia.com>
References: <20260928-fix-p2p-acs-v4-0-v8-0-404453b9c435@nvidia.com>
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
TLP, so a client whose provider returns such Completions is sent through
the host bridge for a redirect that never happens to it.

Add enum pci_p2pdma_tlp_flags and let a caller state that property.

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Tested-by: Tushar Dave <tdave@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 8ed02d4a5c43..2564d57c5e6b 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -517,11 +517,15 @@ pci_acs_p2pdma_request(u16 ctrl, unsigned int tlp_flags)
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

