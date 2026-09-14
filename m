Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7AF4483A0;
	Mon, 14 Sep 2026 11:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789385034; cv=none; b=Y1ZY02/GCxBirzSZjkwdQWWZ4RnSp7Hv42zNWOyqDf3kSNaYs+vbtKZ3uWsWYXRq/th1UpvX4crjx6g5H1SCqFnd7ECHYeobWxc5hivMEg88LfSqpniGshk8WYrvdjElPYsaHUR1cN083oX6Ai17itolBCwH66olfy8bOFIbaIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789385034; c=relaxed/simple;
	bh=OmXiaQz8oAAg8BSkVKc3iM7ZxXZ/pDOr0Gp5QWWZ59o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dh7/d7BjUUnBYtM3mlqZFLZtDuRaMVmu2zlJLj6TvTOM1WLhUFGD/jKu1f7gfm5pmx4+ytfwKXRzCjJep0CKggh/2a7ju4+ymAF4aAk/P0TcwNBtA6RejE0VL5EARAUgu1WFa9WPsJqSdhDblcLE3rZxdwljfvpO1wk/pReIjE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JlT0ZyR3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JlT0ZyR3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDAD81F00893;
	Mon, 14 Sep 2026 11:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789385032;
	bh=xO95Pk5XRLE0oFtxojC3cgHS1ScHTkbYcAUHrZA8bgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JlT0ZyR3T4YxaoWD2Gy/8ilH9ZdzDvp8yYkAbLDw18vxgb0xs1z25SKd5SCk/v6Xb
	 2W6J1OORi84LXIaIP6FyM//CxgpOYApjVFD6j/Zf+RxxYBUuWtoMvnPfo7+OHSVTFU
	 5rHbOKZL3uC2Nr/g+/lKqHiZJrBnBqAJyMEeuTwwpRP0CgmDgGH/aLtxa+y+l7rj/T
	 jT8i2UzjTcdKjYthKu1N1fIJ0TDVUEjkvkB/RXgLy7euriCuVma+JaP9Mdfv+4Ppzs
	 mP6z+qXFlhNXNHrisQ2Tl4TIvap0oYRBbnTNZ4v2OPHopn3pAqXgO+7ofmTBH7c8b3
	 7SflxJ9eN1n6Q==
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
Subject: [PATCH v6 16/18] PCI/P2PDMA: Document TLP-class routing
Date: Mon, 14 Sep 2026 14:22:49 +0300
Message-ID: <20260914-fix-p2p-acs-v4-0-v6-16-5ef07ec9ef06@nvidia.com>
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

The P2PDMA documentation stated that the mapping result is not defined for
Relaxed Ordering or ATS-translated Requests. It now is.

Replace that paragraph with what the three TLP-sensitive ACS controls do,
the table of outcomes per class, and the interface a client uses to name
its traffic. Record that a caller claiming Relaxed Ordering Completions is
asserting provider behaviour the PCIe specification leaves optional.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 Documentation/driver-api/pci/p2pdma.rst | 61 +++++++++++++++++++++++++++++----
 1 file changed, 55 insertions(+), 6 deletions(-)

diff --git a/Documentation/driver-api/pci/p2pdma.rst b/Documentation/driver-api/pci/p2pdma.rst
index 42b18610bf7d..96a4c1d1b0fb 100644
--- a/Documentation/driver-api/pci/p2pdma.rst
+++ b/Documentation/driver-api/pci/p2pdma.rst
@@ -28,12 +28,61 @@ through the host bridge when either applicable port redirects. If an ACS
 Control register cannot be read, P2P DMA is rejected because the kernel cannot
 establish a usable route.
 
-This evaluation assumes clients issue strictly ordered Requests carrying an
-Untranslated address. Its result is not defined when clients use Relaxed
-Ordering or issue ATS-translated Requests because those TLP attributes can
-select different routes through the fabric. Unless ACS Translation Blocking
-is enabled, a Port with ACS Direct Translated P2P enabled routes a
-Translated Request directly to the peer regardless of the redirect controls.
+Three of those controls act on TLP attributes that the client chooses rather
+than on the topology, so the same path routes differently for different
+traffic. ACS Translation Blocking rejects any Request whose Address Type is
+not Untranslated, and takes precedence over every other P2P control. ACS
+Direct Translated P2P routes a Translated Request to the peer regardless of
+Request Redirect and Egress Control. ACS Completion Redirect leaves alone
+Completions that carry the Relaxed Ordering attribute.
+
+A client therefore describes its traffic with ``enum pci_p2pdma_tlp_flags``
+and asks ``pci_p2pdma_map_type_tlp()``. ``pci_p2pdma_map_type()`` answers for
+the default: strictly ordered Requests carrying an Untranslated address.
+
+The two directions are decided independently. Translation Blocking (TB),
+Direct Translated P2P (DT), Request Redirect (RR) and Egress Control (EC) on
+the client-side port decide the Request:
+
+=====  =====  =======  ============  ==========
+TB     DT     RR/EC    TLP class     Request
+=====  =====  =======  ============  ==========
+set    x      x        translated    blocked
+clear  set    x        translated    direct
+clear  clear  clear    translated    direct
+clear  clear  set      translated    redirected
+x      x      clear    untranslated  direct
+x      x      set      untranslated  redirected
+=====  =====  =======  ============  ==========
+
+Completion Redirect (CR) on the provider-side port decides the Completions:
+
+=====  =========  ==========
+CR     TLP class  Completion
+=====  =========  ==========
+x      relaxed    direct
+clear  strict     direct
+set    strict     redirected
+=====  =========  ==========
+
+A path is bus addressable only where both directions route directly, so with
+nothing enabled every class is. A blocked Request is not supported, because
+Translation Blocking rejects the Address Type wherever the Request is
+addressed. Anything else goes through the host bridge.
+
+Note that DT only matters where RR or EC would otherwise redirect: it
+overrides them for a Translated address rather than granting a direct route
+that was not already there.
+
+Translation Blocking is not a routing control, so it is evaluated on every
+client-side port rather than at the divergence alone. A Request it rejects
+has no host bridge fallback, because the Address Type is rejected wherever
+the Request is addressed.
+
+The Completer chooses whether a Completion carries Relaxed Ordering, and the
+PCIe specification does not require it to copy that attribute from the
+Request. A caller passing ``PCI_P2PDMA_TLP_RELAXED_CPL`` is asserting that
+its provider does.
 
 However, if the P2P transaction reaches the host bridge then it might have to
 hairpin back out the same root port, be routed inside the CPU SOC to another

-- 
2.55.0

