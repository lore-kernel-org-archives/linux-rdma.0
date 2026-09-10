Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E748F47CA9F;
	Thu, 10 Sep 2026 11:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789039976; cv=none; b=djVODIeOGM4rPv4jq/92i3yu/QI61mWIl/bJc9YpVQbluJ8OleqPKWrWukG+bFCxLEWwB8IFRPu9IJC0VVSO3s8hrJJYBkDJC7TfTQEphb+xbZ/b7ntTlP98BiFdjUau+N4X6a5JGog9GSOkijV1Qlbhb5IiBUNkCW9ck6/CX/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789039976; c=relaxed/simple;
	bh=XiMBk2BktCZForHPeZMnVPWr9BtHOLFfS1HSzNZLaz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ld0/cJzCISebp75/F0dp99oMhgTzncXMCJ+SDZtH00JObvSllEMpJfNAnYv3HYhHs23WpxfWsaZXH6fAF+M/2L/6wnkWNlBFauBgfTiCwq+N1ePvT8hDfDuaKwlJeP+s45eCoCUTGD18eeapU0lhfb/cXLBAI7jGNsoncZjgAxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ccb3Piqx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ccb3Piqx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45BE1F00893;
	Thu, 10 Sep 2026 11:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789039974;
	bh=cAJyIat4limGWSmrmndSZaY7FfmdAnSZ8M1EcuzJ9BU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ccb3PiqxnrWAaVZDisld7hOwJ9PKqmHnfV7oR7h+sntAWIYV5I6F9QhyJx+Cd++XI
	 VLT0kOSwl5CbzDhctzj2GZk1oFXizQ8rV6z1ab8LzJZk5IuQALQDCQ7oRnRA2ERZeb
	 IqlU0Ymq6XfdOd016tt6R6ShrqgBdiv8/9Wez3ja9XOHul10Gyfx8U595ENSy3unZJ
	 IuJOs3Nm/J1cLFudydh3Corm0GIHsHBXWdQFIfq+4QuDMt648o3IrOfRCYKoJr/AuB
	 xsdNJrT8DZ0WBLJFEgJh7BDLzz5glE3mVHcuctp4rdv7R9tZ301S5rWBaENzwGzwMh
	 XFqn/HhhQpB4w==
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
Subject: [PATCH v5 11/18] PCI/P2PDMA: Route Translated Requests under Direct Translated P2P
Date: Thu, 10 Sep 2026 14:32:06 +0300
Message-ID: <20260910-fix-p2p-acs-v4-0-v5-11-856087f63c0d@nvidia.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910-fix-p2p-acs-v4-0-v5-0-856087f63c0d@nvidia.com>
References: <20260910-fix-p2p-acs-v4-0-v5-0-856087f63c0d@nvidia.com>
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

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 94c0760f27e5..77ff5cda8292 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -544,6 +544,15 @@ pci_acs_p2pdma_request(u16 ctrl, unsigned int tlp_flags)
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

