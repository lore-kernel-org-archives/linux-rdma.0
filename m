Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A484A5EBE;
	Mon, 28 Sep 2026 11:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790594433; cv=none; b=V6vuB622O2TJ6QHeNC6MPr6Mvr6ZmD6Jcwg4+c5cyN25kZ2YFimJF379isoq9Ij2Hkn4m/YSybADf3kMxWvRQCVi98tRcUxUHV9DGphouwX8Av2lbvDXEsSa4Z/6pH1qIK2cpmdIv2WhJMx0sGUON67LC17nWmQCvFuuS/qQbP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790594433; c=relaxed/simple;
	bh=hsOaNMgZF4K6PNDLbTYKY3Air9K033eNgZW7hh64csU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TMcxd4abY770X+yBW+jZtbt19Ntz9ssZZJvNhWrvRs/AyKfLmQPgg7JB2ZHcgY/MH5BK6DeM/Dzlo3HfFCBHGYsPjqjQQD9xpjEC0ldqgCujdeRAnyMKYgyRSxSKzLCrbWA54eoj4YnTsfp+KZnTTbyykPhMeK6gzb8YIe0lc0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AT8Qc+BL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AT8Qc+BL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 185601F000FF;
	Mon, 28 Sep 2026 11:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790594431;
	bh=k5AzZq77W/+uL6WkM7SacqZNfH5pE74CtXeXm+rW4Gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AT8Qc+BL11yJ9OQbQnjzdKeK6HWYAAvBrlfNOBzLNwoBCY78fdqnhNKG82a3ZxLZ0
	 DD6XiAVKJaEozAP9y69MZoU09jrzdIHCLgbI5bj7ByndgaNxJct9gfIAvnbLJYb7KL
	 f71y6jJGkwI3h/evIgmoyO9/tLDw3aR5B645jEdv7jhqvrrwDGWTTd9COBfIPaSUDd
	 9e1HYGrnZ+enzB5pQ6jv8Z8ravD+V5eeFjfDKqSggbeDVDXgfnRSbqFC/RpBPYYexQ
	 0inhC2hmGTpxIVk0/2xkW07SRAwrxF2xf0tgQ2CEpicq2Ew1Ry1N6RqTySUQ1C9x6N
	 ypHHnRMpL0asg==
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
Subject: [PATCH v8 15/23] PCI/P2PDMA: Document TLP-class routing
Date: Mon, 28 Sep 2026 14:19:19 +0300
Message-ID: <20260928-fix-p2p-acs-v4-0-v8-15-404453b9c435@nvidia.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928-fix-p2p-acs-v4-0-v8-0-404453b9c435@nvidia.com>
References: <20260928-fix-p2p-acs-v4-0-v8-0-404453b9c435@nvidia.com>
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

Tested-by: Tushar Dave <tdave@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 Documentation/driver-api/pci/p2pdma.rst | 64 +++++++++++++++++++++++++++++----
 1 file changed, 58 insertions(+), 6 deletions(-)

diff --git a/Documentation/driver-api/pci/p2pdma.rst b/Documentation/driver-api/pci/p2pdma.rst
index 42b18610bf7d..7a7f29f455b0 100644
--- a/Documentation/driver-api/pci/p2pdma.rst
+++ b/Documentation/driver-api/pci/p2pdma.rst
@@ -28,12 +28,64 @@ through the host bridge when either applicable port redirects. If an ACS
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
+Combining the two tables gives the mapping type. A class is bus addressable
+when its Request and its Completions both route directly, and anything else
+goes through the host bridge. A blocked Request has neither route, because
+Translation Blocking rejects the Address Type itself rather than the
+destination. With no ACS control set anywhere, every class routes directly.
+
+Note that DT only matters where RR or EC would otherwise redirect: it
+overrides them for a Translated address rather than granting a direct route
+that was not already there.
+
+Translation Blocking is not a routing control, so it is evaluated on every
+port the Request passes rather than at the divergence alone. A direct route
+turns around at the divergence and only passes the ports below it, while the
+host bridge route keeps climbing and passes that port and everything above it
+as well. Neither route falls back to the other, because the Address Type is
+rejected wherever the Request is addressed.
+
+The Completer chooses whether a Completion carries Relaxed Ordering, and the
+PCIe specification does not require it to copy that attribute from the
+Request. A caller passing ``PCI_P2PDMA_TLP_RELAXED_CPL`` is asserting that
+its provider does.
 
 However, if the P2P transaction reaches the host bridge then it might have to
 hairpin back out the same root port, be routed inside the CPU SOC to another

-- 
2.55.0

