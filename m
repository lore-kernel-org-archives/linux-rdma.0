Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ADB048C3EF;
	Mon, 12 Oct 2026 13:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791810506; cv=none; b=YLbFRHsSLOiIHQ6LgwtVT5Lb/ABG5RhlQ9C6Y/If8PTZcXAJI7vILI3Eti3gxhJKdhrZFCkaFnUhshjyfwgZBhjcj4mferVaJHYv64uVJEp94UX33bVYeWLEk0BgT8vgbmYjkBx5h2RG0xFjh+U5s3qK01vL0rvYngaVUncxi0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791810506; c=relaxed/simple;
	bh=QUzVSRZvTKg2E13vIgCE8+l+zgBTXZofkjJhl+ER15s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b/VvWHUx6whqVBlxstW2q4+zsaW4qW8u0Ml4Dm4uoD+0h+tZvNCb4NkLlTnskwropk+OPdGpaY227OC8L4V2mlL+1OyWIPmnoQXGL4GB8Q4ytCThbzkt5xuhJlroYZ823LM7VnURPTpe5sDEwjT5jShAJQodYu2pUejPL9gxsvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AjD5d71O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AjD5d71O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 125461F0089B;
	Mon, 12 Oct 2026 13:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791810505;
	bh=6I7K2CcZKiNEkj3tMDTHshN0X+VnIpc+D+swyH4+62w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AjD5d71ONQP5SBDsKv5PdUhTnucsGMAMSVdDa4EaP0F9d2scABR8puTTDmx5Gacte
	 XvhlIJDJY38N90JLJ8ggyq/IrcYGblDHn0p8toWQMgdBTZqmCWYeuQ/VVKTBRgdPQ8
	 MrmJhBOy7B3H/RM1CubJWcX0VCV1+D32tSGF4IWy/EVXBjned48+XDzWCKd+tNViH0
	 fOXR+jAcdR7D2J6zKZfX2FVlDAI7JCdJJGr5694Bh4oSCGCdUk3MbEi61zCGf6BumL
	 90EJm1FHP6qXOpA8x87fVSWVmZGUl2ZIrGy+RG6mZNLxEIvItW4Uxa8/c7lOKRBMbm
	 ieYZRkq3SwW/w==
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
Subject: [PATCH v10 01/18] PCI/P2PDMA: Document the TLP attribute assumptions
Date: Mon, 12 Oct 2026 16:07:38 +0300
Message-ID: <20261012-fix-p2p-acs-v4-0-v10-1-6ffe7b7a4517@nvidia.com>
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

