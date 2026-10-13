Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD68C5158A3;
	Tue, 13 Oct 2026 14:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791901597; cv=none; b=uN9+rSB5rTtcrbEiX2ZFXLZSuvrz56fcQEHR3nLrcobawDkvModsj548+/kelVkXjAD1EW/zZBCSVOEFd2LI1Q5uNjsOLiE1DNZsL9EgPbwksSzXyS216HqKc43+SIEOJzAafak3hSstoRtnREcENisijmZYwGDG9Ey/bqXuQrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791901597; c=relaxed/simple;
	bh=po+uZGTtTobpCMNg78cxMdyq67cyC3lHSPkN3/tCiuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LYjTxP/M+93h7ZGI+fG6AO3I23idMyv9ESmrclbBIYoBnczmAjgOOJnykOsBHznUa9UN0Q6Dv6YmLBdBL8CmM1UTVI3PWjvf1L9+20PBidZGmJQI57G/9YZggSnUBcl7DMhVaDwp9nBXdVdwIU2V6e3TSc1SCdMNWLBu9nZ7W3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iTtphctg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iTtphctg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A8A1F00899;
	Tue, 13 Oct 2026 14:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791901595;
	bh=Jf9U+mn4ldcZtGdXm7FaHQeqKC2A3brzgEFku/EAvyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iTtphctgb+MOfe38qDGxO4uzT+zQR9dONHEOkeHsE7J0rrw3YV9hcupuFcnr9Fnoj
	 4b/JR2iQRGKnRrfViCzTSKL/J/7FUQRpkjNOaEMTmdN5wk+9Jjmhio/fnDBs6S5kQL
	 e/wFYG11jI7BEOkLacVVF9uVhQs3mrzK7271czGiBtDtpJ5Xz+NokpaUDrPPimWYw9
	 5SP2wAljmSMkS4nZvYCBYRmnJMymRUMH3XdiEVpHgYV6LeCZ/huBwhMc16EdB7o0B9
	 RRd8iMqueLGcYwugwYVNksljDzf48v8Aj0FhuWpXATu9HuKqYlzmtQhvbQ/HLFa0jX
	 jsG7YRw9/o0fA==
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
Subject: [PATCH v11 16/19] PCI/P2PDMA: Document TLP-class routing
Date: Tue, 13 Oct 2026 17:25:24 +0300
Message-ID: <20261013-fix-p2p-acs-v4-0-v11-16-72cf8c96e617@nvidia.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013-fix-p2p-acs-v4-0-v11-0-72cf8c96e617@nvidia.com>
References: <20261013-fix-p2p-acs-v4-0-v11-0-72cf8c96e617@nvidia.com>
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

The P2PDMA documentation leaves Relaxed Ordering and ATS-translated
Requests undefined, although routing now depends on their attributes.

Describe the three TLP-sensitive ACS controls and the outcomes for each
class. Clarify that Direct Translated P2P and Relaxed Ordering cannot
create an internal route between sibling functions when hardware lacks that
route.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 Documentation/driver-api/pci/p2pdma.rst | 68 ++++++++++++++++++++++++++++++---
 1 file changed, 62 insertions(+), 6 deletions(-)

diff --git a/Documentation/driver-api/pci/p2pdma.rst b/Documentation/driver-api/pci/p2pdma.rst
index 7b11d7d1fdc6..05f896a0814b 100644
--- a/Documentation/driver-api/pci/p2pdma.rst
+++ b/Documentation/driver-api/pci/p2pdma.rst
@@ -49,12 +49,68 @@ rejects a host route without this forwarding support. The host bridge must
 also support P2P. Clearing redirect controls cannot create an internal route
 that the device does not support.
 
-This evaluation assumes clients issue strictly ordered Requests carrying an
-Untranslated address. Its result is not defined when clients use Relaxed
-Ordering or issue ATS-translated Requests because those TLP attributes can
-select different routes through the fabric. Unless ACS Translation Blocking
-is enabled, a Port with ACS Direct Translated P2P enabled routes a
-Translated Request directly to the peer regardless of the redirect controls.
+Three of those controls act on TLP attributes that the Requester chooses rather
+than on the topology, so the same path routes differently for different
+traffic. ACS Translation Blocking rejects any upstream Request whose Address
+Type is not Untranslated, and takes precedence over every other P2P control.
+ACS Direct Translated P2P routes a Translated Request to the peer regardless of
+Request Redirect and Egress Control. ACS Completion Redirect leaves alone
+Completions that carry the Relaxed Ordering attribute, which a Completion
+copies from the Request it answers.
+
+P2PDMA therefore decides each class of traffic separately, and
+``pci_p2pdma_map_type()`` answers for the one a DMA mapping is built for:
+strictly ordered Requests carrying an Untranslated address.
+
+The two directions are decided independently. Translation Blocking (TB),
+Direct Translated P2P (DT), Request Redirect (RR) and Egress Control (EC) on
+the Requester-side port decide the Request:
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
+Completion Redirect (CR) on the Completer-side port decides the Completions:
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
+destination. With no ACS control set anywhere, every class routes directly
+provided that any required internal route between sibling functions exists.
+Neither Direct Translated P2P nor Relaxed Ordering can create such a route.
+
+Some ports without an ACS capability, such as certain Zhaoxin Switch
+Downstream Ports, redirect peer-to-peer traffic anyway, and a device-specific
+ACS quirk tells the kernel so. P2PDMA treats such a port as having Request and
+Completion Redirect set, but with no exception for Relaxed Ordering, so it
+redirects every Completion.
+
+Note that DT only matters where RR or EC would otherwise redirect: it
+overrides them for a Translated address rather than granting a direct route
+that was not already there.
+
+Translation Blocking is not a routing control, so it is evaluated on every
+port the Request passes on its way upstream rather than at the divergence
+alone. A direct route turns around at the divergence and only passes the ports
+below it, while the host bridge route keeps climbing and passes that port and
+everything above it as well. Neither route falls back to the other, because
+the Address Type is rejected wherever the Request is addressed.
 
 However, if the P2P transaction reaches the host bridge then it might have to
 hairpin back out the same root port, be routed inside the CPU SOC to another

-- 
2.55.0

