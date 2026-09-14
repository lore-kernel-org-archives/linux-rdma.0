Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12E24503F1;
	Mon, 14 Sep 2026 11:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789385010; cv=none; b=DmxzROx3u7WszGQCUrvaVhBO8rtrrloT90Q2XLoPuZCGDawC+d/Ewkh/dRKDkEbcWXOSRErBD86Z2Em/XPj6Rqv2AjbfTQgMW+6mFvheqfsV2gzvYtclfH/sbkqNHs8Z/oXykYdr/RZOLEp/07oYS37J1IxFjuahjB0rpXY40dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789385010; c=relaxed/simple;
	bh=XiMBk2BktCZForHPeZMnVPWr9BtHOLFfS1HSzNZLaz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E9iR0gICzg3PLQYIzQXiGToyYNl70QfXVKgTYE2lEM6Ket1OepYbEGLuJFajB2gqg7sU5SIpQI7p1ORC5Dtsfi/Q6OT/vBU4ZgNIpIfHwl98iruEWBqD4hLPa4VwgmVRNvmDxZ5OzwG0PuK8xQqpjTtv9WOvBDIbKw01XYhDamM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z72xxq0z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z72xxq0z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF981F000FF;
	Mon, 14 Sep 2026 11:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789385008;
	bh=cAJyIat4limGWSmrmndSZaY7FfmdAnSZ8M1EcuzJ9BU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z72xxq0zCSCvJ3w4bLDGD88k0WuQ3sX3IdtyKxFGt0scAql1MLmQonAPJi0vgMqMy
	 t0aRzwb2iuABHy3x4/GqJWvmZjJ5zCyRJIxHhvYb8k+M8USYq8hkMTzOW+Uv/pLxuG
	 NOmD0OYXo2Eob25bzw5aJiYoVXZKDjDKy31uiSp+4Z1vXZKmHZ0NMvy6nXM6OTlRcy
	 3kAFiKrpQsZxxrSMQ0nr8TyXOK+ukAGCfh6gOIn4fqVjV0DKd5vGFp1N5P4YO2aV2v
	 5YWswQqCbMuQ2rg2HZ68AJ3l3lncD0AR5B79BQ4HyO5irlcTaS/n0fjyqcjoTIpEkb
	 ZeF1geZgBJk9Q==
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
Subject: [PATCH v6 11/18] PCI/P2PDMA: Route Translated Requests under Direct Translated P2P
Date: Mon, 14 Sep 2026 14:22:44 +0300
Message-ID: <20260914-fix-p2p-acs-v4-0-v6-11-5ef07ec9ef06@nvidia.com>
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

