Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B1249505C;
	Thu,  1 Oct 2026 11:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790855808; cv=none; b=IOvafigYhydGYhn6s1CWOhen4vq2KkR/boYYYaokHgotI6H0oAnpWL7jJCti8dt5ZS0+oB4YOfSXxTDBmYzlsWtfNjL+gWdO/mlpL+q6KMdNKnWRFLqsXEJs2P6RhMOFaebEhcu1eXs1Y/yPn3kMEuF/SPWaetN4INRFv6H008Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790855808; c=relaxed/simple;
	bh=z6a4KYJgZ6sSTILLyhYPmyLYZ3UwcEyyFjuMxqbvfiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dhTh7a+BNoZIciEdx783wHEktyN7paXMqoA/0P6p1mIhjF1lGmii4SGZUk0RODplQbmmrB4OSBf6m/BxkyHXho73mp7kvNd84Kic3XMNKZs72BZh8/iFkaeV5pZHUsC1rmBjz5TAl4CRnP6zkqPnDyTUem1uXqrpTWG/mRWW4ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m37rOJ9v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m37rOJ9v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A441F0089C;
	Thu,  1 Oct 2026 11:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790855796;
	bh=FJiSzgsjWJTKuHSDD3BgssMes6luTH/QucCnOlpO4ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m37rOJ9vwSpy2w5vyFgpZ5cwzBGY9fZV0e0xpsoyAV86czqsAeW/Ym8lbtODjoAcJ
	 Sht88J8FJMBcxNhf1XcXvGNxM3ky6kUIwpyVObdnHSWll5IE4N7jvP/Ob2DsrOGAUQ
	 kZ1POJXtHoP3gHm59LG4+hIS149xcA5w5n/lWNqMdxsS5ZQdMuRGqqjqQemxuFm4Ib
	 e5O/UifP9qxZ28Eer1Pd2mKQ7cANVJ7B1FwoH4c2e4b/lUR8nyYUX8M9ZI34PBBq04
	 r1MCLEdKduvsESFvk1KtjRL62zJjHjtSw4D6MVJ5nNl2sKgW9aGfLqpjW+Ro8+0Mb5
	 HlUOc9PEHLpQA==
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
Subject: [PATCH v9 10/18] PCI/P2PDMA: Route Translated Requests under Direct Translated P2P
Date: Thu,  1 Oct 2026 14:55:18 +0300
Message-ID: <20261001-fix-p2p-acs-v4-0-v9-10-1a8e0f50ddd9@nvidia.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261001-fix-p2p-acs-v4-0-v9-0-1a8e0f50ddd9@nvidia.com>
References: <20261001-fix-p2p-acs-v4-0-v9-0-1a8e0f50ddd9@nvidia.com>
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

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Tested-by: Tushar Dave <tdave@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 569a74de3b3a..3fd2cb8d16f0 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -548,6 +548,15 @@ pci_acs_p2pdma_request(u16 ctrl, unsigned int tlp_flags)
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

