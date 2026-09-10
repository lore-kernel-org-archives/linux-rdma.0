Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216844749E0;
	Thu, 10 Sep 2026 11:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789039950; cv=none; b=mTCxa+jNRCBqpaFjQ/l/xxhhxZy2Ys2HWiyHk8ghagRPGtLyt/MipO6+Wf0J1lmP0d3hQOE7S/0mzG/ECErWIXz/Tk4hm6QntN4qZrrw3e1gpQ3EBPhhdRpsRPgwsxxcNhDQDxJ/D4j1hlnBG2JtMMtXQVpfTyoh+Tv3Uq0Js0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789039950; c=relaxed/simple;
	bh=sNSKCsf/sqMm/uW6DJDsKzV+8NFWqca8nOKcDmgRicE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NptTr0JB+IqEN/QURvMQfioRuIOQTwN8IcJWTXe/sRRxheiUHFL0oWM1PDfVSmRyZStoOc4mBR0KNDBuT8JMgf6fgzodd+DODdnq6WvEdkiMrw/GHzpJ655x814I/i6V+PnfOTBoIjUqoQeVeFwi+XgYqSXNVBVxkPJzlor2WM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ra4n7vOl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ra4n7vOl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16EE31F000FF;
	Thu, 10 Sep 2026 11:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789039946;
	bh=mewnXaBKzi2RuajAdR+1gFX2UcD8vJrlfBBh0mRM42E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ra4n7vOl0p6AbaxDDTzha13CuM7FIoHC/LtcZWhlEZa3wjszkfLr9DgxKlCPXomjr
	 EAacQV1plKqvRzGJZDjID8gASAiPZgNBga6H67V9izFK5wOx8pISTAm3C/Pk3Shorb
	 N9RX7Q7UmObdzlwxXhaYViVa3ILf7rYS9cst/BpbxlfD0Fhe7hTQ/dSSX7vVEympXe
	 Z4rzdinSgRHzE+M3wS3EyaHpU/hWIXIFUBzIiQfwYNxaZjRLk+lPJlD8on5WgVncUm
	 EHpGKv3jl9epUY3zUhPzUuEC0+7s+V3zFm3q/ho/qMua8JQ9YqD02sD9LC0Hx2VWSe
	 Oq3wMMCdxpqCg==
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
	kvm@vger.kernel.org,
	Matt Evans <matt@ozlabs.org>
Subject: [PATCH v5 01/18] PCI/P2PDMA: Document pdev->p2pdma lifetime rules
Date: Thu, 10 Sep 2026 14:31:56 +0300
Message-ID: <20260910-fix-p2p-acs-v4-0-v5-1-856087f63c0d@nvidia.com>
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

pdev->p2pdma is normally accessed through provider-owned references, but
pci_p2pmem_find_many() and the p2pmem sysfs attributes may race with driver
unbind.

Document initialization, teardown, and how the release grace period
protects both the P2PDMA state and its optional allocation pool.

Cc: Alex Williamson <alex@shazbot.org>
Cc: Matt Evans <matt@ozlabs.org>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 4e4d2df17a45..d8c9d605b828 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -21,6 +21,29 @@
 #include <linux/seq_buf.h>
 #include <linux/xarray.h>
 
+/*
+ * Lifetime and RCU usage
+ *
+ * Within one driver bind, pdev->p2pdma is set exactly once,
+ * by pcim_p2pdma_init(), and cleared exactly once, by the pci_p2pdma_release()
+ * devres action that the same function installs. It is never changed and follow
+ * same lifetime as parent pdev.
+ *
+ * Most exported entry points reach pdev->p2pdma through a struct pci_dev or a
+ * struct p2pdma_provider owned by the provider driver, and
+ * pcim_p2pdma_provider() requires callers to drop those references before the
+ * driver's remove() completes. Those cannot run concurrently with
+ * pci_p2pdma_release(), and their rcu_dereference() calls are simply how an
+ * __rcu pointer is read.
+ *
+ * pci_p2pmem_find_many() and the p2pmem sysfs attributes are the exceptions.
+ * The first walks every PCI device, so it can reach a provider whose driver is
+ * unbinding: pci_get_device() pins the struct pci_dev, not the driver. The
+ * second is reachable from userspace until sysfs_remove_group() runs at the end
+ * of the release. pci_has_p2pmem() must dereference the object to determine
+ * whether it owns a gen_pool, so even a device without a pool must remain alive
+ * until that RCU reader exits.
+ */
 struct pci_p2pdma {
 	struct gen_pool *pool;
 	bool p2pmem_published;

-- 
2.55.0

