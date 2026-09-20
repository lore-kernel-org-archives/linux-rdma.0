Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A91434980;
	Sun, 20 Sep 2026 11:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789904557; cv=none; b=XkZ9NLWKkwOw/2CkeGXvn/4Xf6ynex6tmpKWrqFGJPQLmPSV5Tdqg/Q5SMuDwgADkBtf539JtF0PsFamZnqx9oicjhhV5G8EwLzX7zWiaLMIhwPsSlxX714ciWPMsPPiSwRaJ9mDK+/FwN+kLSADS/EmufevGpwOgo7+CRT7SSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789904557; c=relaxed/simple;
	bh=WJ8vDmq5Rqo9zAbKzJaD08931Vbczj72A909B5+v1IY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Oy09zfysPsb3/ntAkvombtgilxtZMk64+ZI7uNLV8pstjxTayRZ2ARo2y1cMYSZhvcybk4h51CPZuqOd7NDNYFdKpXR3Mvs1RCXLPvd2LnDh3ZykQkkg8FUFjRSDRb1DPN1LUi4rqU1s/dbIcrAAbrgqf1F7TEo6iBV0KLZH+gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TMwH4kQt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TMwH4kQt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CAC21F000FF;
	Sun, 20 Sep 2026 11:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789904556;
	bh=68FZjmCCs1UD6FDyhk+W02Nb/KkrZwWXOELgmkfWKag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TMwH4kQt7AERs1SAKegLtBr5ODxXNlErREEp3vPn02AZxzlY/b6odiS66tZHTf7D+
	 vUaan1LgCy+T+9jIYm7RQ0yZwNm2nKFTWFGkP8VjYxKi5/aB5zHDAVl9g8HOk3hSBL
	 GQCsmT2bDBz+6KJuGOChe9T0Av/pzhspUBZNUWJVema4LZoV3+LOZ92PQAg8QNYX6/
	 6Uey4KMJGJlvBMo+WDgGyheiZMM7Q47L2NIcRUApxcnwWl+0iEKHs8TYhF8Sl6M/oz
	 GAvNMZJQmijSSwA4Rwai9kpKIlQzzYW/Gk1Bz00aDd/fEeTCkgJ9Qgg6AGwCN0HA72
	 cBVzwBM39s66w==
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
Subject: [PATCH v7 15/19] PCI/P2PDMA: Document TLP-class routing
Date: Sun, 20 Sep 2026 14:41:27 +0300
Message-ID: <20260920-fix-p2p-acs-v4-0-v7-15-ca0828ab697c@nvidia.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260920-fix-p2p-acs-v4-0-v7-0-ca0828ab697c@nvidia.com>
References: <20260920-fix-p2p-acs-v4-0-v7-0-ca0828ab697c@nvidia.com>
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
 Documentation/driver-api/pci/p2pdma.rst | 63 +++++++++++++++++++++++++++++----
 1 file changed, 57 insertions(+), 6 deletions(-)

diff --git a/Documentation/driver-api/pci/p2pdma.rst b/Documentation/driver-api/pci/p2pdma.rst
index 42b18610bf7d..b4ec53d74089 100644
--- a/Documentation/driver-api/pci/p2pdma.rst
+++ b/Documentation/driver-api/pci/p2pdma.rst
@@ -28,12 +28,63 @@ through the host bridge when either applicable port redirects. If an ACS
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

