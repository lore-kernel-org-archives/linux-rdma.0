Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B8F444706;
	Mon, 14 Sep 2026 11:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789385004; cv=none; b=tx17usmt4wCW3ire6BJRyCgOBFj+uqaSZ0cvtwT4mhzkIrCTzSwYacbzBFSYu/OCkbfFXUjOxk9C9djSRjknUvJOmxz7HTtPOD6ce9e6hZtEyNYcw8DCvS2kvFBP0RXD61O5D1gsMqOBWdeVU0L/eN9GBxSXnck+pInn2enirWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789385004; c=relaxed/simple;
	bh=P2xPREMOgoBKZLanV7o7qaQOyqC/Ow4GhPacLX4idWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rr+GmUb867e/ApyZY57P3ztDGbHlwd/dRQz9Vwq515HMageZeIo0fwlf3QmC4rSQmxzwjJPiV0XnhcCRtzTCAMBT2dYamI1oUJpcyRSmonSFLG2uND/MwPblZLRxWhdX4tqxKVs0P1ZyRePauE9jB0SSRxU9WkR+EaWGes1NRnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HZjgcUDm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HZjgcUDm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4341F000FF;
	Mon, 14 Sep 2026 11:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789385002;
	bh=6iVQXJrfzqj9H9Mn6XbNg8yLfGKcJ/HPEopWBqbnUfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HZjgcUDmQoemxu3yyuba1CrxPC9tc56Roe+HAso0zn5HwJY8rfDKjKowC9lKAKeXT
	 sRi/K0DKCZXtsX1lQ99POieHZ+esz5ANwQoIWhAGo3jBbfk6UvBxrVwB89tZHfRhSi
	 h9aO6Slz+PM1gtQ7Rv5saKB4Tn9A/h4Z/frLDtO235KnIUZp/rel+hl6M38bPc11qF
	 igl2MF2qT2lu8/Fl3lqP6d5YQEAxfoClUuqRfxapz503LZ8EgPHYMKq7ujAoIFEVQf
	 iF3HbThRXcrDrht5KZC+zJaKaq8kXfmKVZVliCUXW0UydX+MHupwD9BDrTi/8X5+gM
	 n84a+GYXSy5nQ==
From: Leon Romanovsky <leon@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	Alex Williamson <alex@shazbot.org>,
	Leon Romanovsky <leon@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	iommu@lists.linux.dev,
	Tushar Dave <tdave@nvidia.com>,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-rdma@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH v6 09/18] PCI/P2PDMA: Route Relaxed Ordering Completions directly
Date: Mon, 14 Sep 2026 14:22:42 +0300
Message-ID: <20260914-fix-p2p-acs-v4-0-v6-9-5ef07ec9ef06@nvidia.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260914-fix-p2p-acs-v4-0-v6-0-5ef07ec9ef06@nvidia.com>
References: <20260914-fix-p2p-acs-v4-0-v6-0-5ef07ec9ef06@nvidia.com>
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

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index fac765d0a16f..327b6a14e07d 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -540,11 +540,15 @@ pci_acs_p2pdma_request(u16 ctrl, unsigned int tlp_flags)
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

