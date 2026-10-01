Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704D249502E;
	Thu,  1 Oct 2026 11:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790855766; cv=none; b=L9HAKTT+d+nKHg3b+5Blvg2H0rdLKVcyxbnw2KVtJnD/Tj00wSz8y5ke2mwlEybIOXkymhZDq/na4HoZh0SiO77yFN0JkRIIP8acDArPxIZX+YGE+2yOwx3g02mApF361ZZLr+hPzPWVsxsUpX3p7E4Y8MLx3d3yHz5sBYcDpV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790855766; c=relaxed/simple;
	bh=QUzVSRZvTKg2E13vIgCE8+l+zgBTXZofkjJhl+ER15s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PGc3e502x7403lorvi+AWyeHgkKS/IKnAipVQRq9zt69x9JmWkkcFyptPnTkjVpuYTM3HZH5Y2+I73rCiSk15Kiw2rH5mFIpzX5VZYoACWe06g/Ji4zAsfoM5ApelvQ6QiumzWCc3QxHhD3pY0jOUNwJxMa5jOkAIcxb4yoU0Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SYyBAVTM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SYyBAVTM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D86FB1F0089B;
	Thu,  1 Oct 2026 11:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790855753;
	bh=6I7K2CcZKiNEkj3tMDTHshN0X+VnIpc+D+swyH4+62w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SYyBAVTMATTgP32jhxtK8pbxbDx+7kBZwHk10JJz2gklHghGGK/V+jDN33lrKEjTm
	 wUpeWoXqGA6kQBlTicv1wjTbUViwV57vqRmI4iQSc5DunVh78xyKBfwVPo8e/Yuv2O
	 8zXckZAMCnexPgF/Uo6ZcL1UsK3DqIjR4lwC7/lXM2aa8Q4kPs6zgRpJyM/9/V8Qz8
	 A+pn1NW0PLYcoyUCsuFmLKV+V4vfNuWmGC7hE14Xx+SI46CnNKsXWYn5Oy08fBUHAJ
	 Bic4sdYk7VxgQCBDQ9e/5fzUkTnSr0SnZga9wNqyfomoD2o4qO0GTUMtnc92sBNhYO
	 rbUskcEg/iSWg==
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
Subject: [PATCH v9 01/18] PCI/P2PDMA: Document the TLP attribute assumptions
Date: Thu,  1 Oct 2026 14:55:09 +0300
Message-ID: <20261001-fix-p2p-acs-v4-0-v9-1-1a8e0f50ddd9@nvidia.com>
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

P2PDMA selects a mapping without receiving the Request's ordering or
Address Type attributes. Its ACS handles only strictly ordered Requests
carrying an Untranslated address.

Document that the result is not defined for Relaxed Ordering or
ATS-translated Requests because those TLP attributes can select different
routes through the fabric.

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Tested-by: Tushar Dave <tdave@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 Documentation/driver-api/pci/p2pdma.rst | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/driver-api/pci/p2pdma.rst b/Documentation/driver-api/pci/p2pdma.rst
index 63cff9e4d2c9..80f8fec9b0e9 100644
--- a/Documentation/driver-api/pci/p2pdma.rst
+++ b/Documentation/driver-api/pci/p2pdma.rst
@@ -15,6 +15,13 @@ then based on the ACS settings the transaction can route entirely within
 the PCIe hierarchy and never reach the root port. The kernel will evaluate
 the PCIe topology and always permit P2P in these well-defined cases.
 
+This evaluation assumes clients issue strictly ordered Requests carrying an
+Untranslated address. Its result is not defined when clients use Relaxed
+Ordering or issue ATS-translated Requests because those TLP attributes can
+select different routes through the fabric. Unless ACS Translation Blocking
+is enabled, a Port with ACS Direct Translated P2P enabled routes a
+Translated Request directly to the peer regardless of the redirect controls.
+
 However, if the P2P transaction reaches the host bridge then it might have to
 hairpin back out the same root port, be routed inside the CPU SOC to another
 PCIe root port, or routed internally to the SOC.

-- 
2.55.0

