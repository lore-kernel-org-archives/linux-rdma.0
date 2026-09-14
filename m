Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC1A443319;
	Mon, 14 Sep 2026 11:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789384983; cv=none; b=ZdiJdvAPIwduDMscaUzSeceTXFvJL71XIwOsLvUDc9eOydXEeE4fcQHp1axE6gFwxqk4r64IjxO2uIJCAy3uGdEcYSr3/yS4VLY9joLy5ybjVnrJR9pb0OyFl9LpwBLS80SvxBSwOoam64PUD1hcWwMsoj+eFfZmmyi2AJzX6j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789384983; c=relaxed/simple;
	bh=Lf8pxsTHkin8iU9aiJA0CK4BtBgEr+wkCX1jxEk/GQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DeWcrVCCBOfULOntpV9sBaAFMMn9N9Yevm783RC8kcspwU1CzOwcXiy3WmidknHHckKqwazcXvUIqLnzh6TAQgriPuXYpIPBMhAIL/wQwXbCcVdG/HUyzZk8RWykBTvIBVYD0VKUF3vWcSj7XgZrc+AZxmB8v48k5mCbRi2+epI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XMgsQvj3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XMgsQvj3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC3D1F008A6;
	Mon, 14 Sep 2026 11:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789384982;
	bh=3YMYg7jFStAT+n5lMS0MTimOeAZfs69FZvv3CJKO2+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XMgsQvj3K5rws68/eFnBYiAuvk85o/9SefhDekY02xrFSN6Gd0O9SwDkr2CQoyVgm
	 8LxY3Ryd1naC2j3HGuAvBEUDY9mV96LJ0GXmzQ3y+kQbunnaScRa95b2bzdiO/RABs
	 Fr9jg0U8ZtoDyoK9CKxnBJv7zhCRDOfx3traXPBqSfgJMRY+PRc9IxWCv2YhxuiwL0
	 n3iIxXbZx1dlOjrqeOImlE8Pigp5Y9xGtgjJPu6GjF5k1U78Pv2zZKGLYrNKPcA/vX
	 g+elhASfV1JJ4F7kPOs2bSE29TNjv6sbnutHsgFfp90lo3jC8CmIPGpJ4mlPsg6Ckz
	 j6b0G+Ia2GSBg==
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
Subject: [PATCH v6 02/18] PCI/P2PDMA: Document the TLP attribute assumptions
Date: Mon, 14 Sep 2026 14:22:35 +0300
Message-ID: <20260914-fix-p2p-acs-v4-0-v6-2-5ef07ec9ef06@nvidia.com>
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

P2PDMA selects a mapping without receiving the Request's ordering or
Address Type attributes. Its ACS handles only strictly ordered Requests
carrying an Untranslated address.

Document that the result is not defined for Relaxed Ordering or
ATS-translated Requests because those TLP attributes can select different
routes through the fabric.

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
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

