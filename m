Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C6241F5C4;
	Sun, 20 Sep 2026 11:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789904540; cv=none; b=uhWZLzdOamW5HbHUtrLaUmJoM4xen9w0xL++nfns59M3ejrxIS9aELFuG+wy0ToIShVtZS+i0KgPsgMRR18ekKlz+TRY8yCgRdeSfGMHuwIKChCTsjJX2q0UEkSVk5ZHzJfK0q8cvZtCSALgjU6mhIceGV+fz0PPA2C9OBh/zHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789904540; c=relaxed/simple;
	bh=2Jhej95EvZHHpMD58ypT4GYun4rflR2PnJqMWtNqsE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dgoN+FMBhiYG6CqFosdR/8cZvV3MJVnDs0mAjIWkZLpjj/j/D3wgvugW7cp7QzwW2DazFQ3i/iYsVo5LOF2lzGDZJVwH3xLhWW2b/PSEpEEQe5STv4G3sqjKIY1GOD09slkaYsqKAMzUl6H+F/UbF9T1mJMBTpQlkvDDk2EhaGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kgNLFcpX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kgNLFcpX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B5A1F000FF;
	Sun, 20 Sep 2026 11:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789904539;
	bh=VFMFmLWutyr/vRpCG+vwDoBVNtSGdEDDoC9Rg8S2X/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kgNLFcpXFj84PHhVf+qQxtx7eyHLOL4cTQnIkN8E9oA4wRSWuF/ST3nmYGLRVXSWO
	 ofsnZ+U3KAEK7X62jEV6m66vXZZ0muIPNh0LHXGXQqfaxCNUTPnYrcfgi0PGZnb/wI
	 UEivb2fnZvI/QcdcxNWc05KjDtvFw9fCcWbMusfOfNZoN8Xequdm8SybFWNTFKrAax
	 3zMYuFcodtlcUt6kCVvTFsUiZzpR67frim4mfPnKkie7QYt9rjHjaL4cVINCCwAqlP
	 gIUE9c0HG1tNblj9snPl3BvqxU825AlmPWQcn0ONPkBN1xOfvbsGdsz12AflbBMdAq
	 ie8b4S5u21aJA==
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
Subject: [PATCH v7 10/19] PCI/P2PDMA: Route Translated Requests under Direct Translated P2P
Date: Sun, 20 Sep 2026 14:41:22 +0300
Message-ID: <20260920-fix-p2p-acs-v4-0-v7-10-ca0828ab697c@nvidia.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260920-fix-p2p-acs-v4-0-v7-0-ca0828ab697c@nvidia.com>
References: <20260920-fix-p2p-acs-v4-0-v7-0-ca0828ab697c@nvidia.com>
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

A Downstream Port with ACS Direct Translated P2P enabled routes a Request
whose Address Type is Translated "to the peer Egress Port without
redirection, regardless of ACS P2P Request Redirect and ACS P2P Egress
Control", per PCIe r7.0 sec 6.12.3. P2PDMA assumes every Request carries an
Untranslated address, so it sends an ATS client through the host bridge
even where the fabric would route it straight to the peer.

Add PCI_P2PDMA_TLP_TRANSLATED and consult Direct Translated P2P for the
Requests it describes.

Tested-by: Tushar Dave <tdave@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 839285b77b62..13fe83142c71 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -521,6 +521,15 @@ pci_acs_p2pdma_request(u16 ctrl, unsigned int tlp_flags)
 		 */
 		if (ctrl & PCI_ACS_TB)
 			return PCI_ACS_P2PDMA_BLOCKED;
+
+		/*
+		 * PCIe r7.0 sec 6.12.3: ACS Direct Translated P2P routes a
+		 * Request carrying a Translated address to the peer "without
+		 * redirection, regardless of ACS P2P Request Redirect and ACS
+		 * P2P Egress Control settings".
+		 */
+		if (ctrl & PCI_ACS_DT)
+			return PCI_ACS_P2PDMA_DIRECT;
 	}
 
 	return ctrl & (PCI_ACS_RR | PCI_ACS_EC) ?

-- 
2.55.0

