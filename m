Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793873203;
	b=1KGXWq6zGaF2ZsupoNJJQtdgYYdyujWS4utWUO3LPyrZmYfX1vpfpQttuBriarHN4Z5s
	 JopD1BN5xjAkOnafXsS/Rs71xTGKOOz6LW49ql5vsKE8gs+IP2hjFTjDxjBBQuVRMKvOm
	 6ttEfSCcLzou3VFX+0Q6duf821WxxYUgVYCrueDKC3QKFw5VRriXtOvgbXCRcR7Uevu3x
	 zEEt7oZkLG+LvL4RxDLlGooqEtHfd9PKSXSnJlIgvENz71OJvSnfLHbovIrYZUORxuKj7
	 2nYMvhmsPBP8TStXZHyLgmIwwhqhxBUX/ptLAv49Q1P5S7aCinhtbXYiDXMkMYsXBLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793873203;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=a1M4wMytmPB71ALN45nnzq9Xuc76iLOwai4Fxcpgh8s=;
	b=4M+dyevM/jeGwasHk+fKExFH3zkeIcc5spu5HrZ0ytjF4xhgA1QFNSYe4JgL1Ol82OTB
	 EqXCeY7L7L0eCQzshifcmcY4Mjdf05NPe8LEkF3z8hiMOevFtK17hGkS3TRAWyZ9lVPVV
	 PtmpQIairq/WJqxbcTcNgL1dwJIQOVIMwaERBuVeaOAcwGneBaXzDEfS7pVCWgd6DqyO5
	 NBkMvl7niOUr8p4BysLnwXcrkuq44nmN79dlUVExcSEQBSYPOPItlXJ8YJ2L9GS73Kc2Z
	 jh23nOh8mcg6+iGSjthn9JDXpECWTdgrg07FHscqY60XtKLBoar6prfndBM0BQK8hbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g8tfrxPP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E41D606CCBD;
	Thu,  5 Nov 2026 10:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g8tfrxPP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF1B1F000C1;
	Thu,  5 Nov 2026 10:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793873203;
	bh=a1M4wMytmPB71ALN45nnzq9Xuc76iLOwai4Fxcpgh8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g8tfrxPP282AKU55JosjIMU6RHYzO/aDraaE+DIwQ+aAAXH4/Yk7i0Z8+dUnHHCc4
	 OMsp8TXE7Q1bkEsIz5uUH7fmb4b7Orb4JYvvJ2/GW0Q3fFKtR7lWCTNY7YrBULIQlY
	 eXBnI6gayuijPcJokkLMwx6l8PiXJV/4j7z71Cfv2eAbpguKfN56MTJu9MPw3Qsjkq
	 5h2ajaaKc9E9+unNv0XreaQZoZwR8e0sH0ixUQExWp+w0J45q3/gN+v57ZpAnrF6H4
	 iASsmaVtScKa7bkDLMjOb+WAkVkNb5Qd0M3oBFQuwFZn0F+63wJidOpd1/n4ziqd8J
	 GujSIvsd1KC4A==
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
Subject: [PATCH v13 16/19] PCI/P2PDMA: Document TLP-class routing
Date: Thu,  5 Nov 2026 12:04:47 +0200
Message-ID: <20261105-fix-p2p-acs-v4-0-v13-16-3dd065907c3b@nvidia.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261105-fix-p2p-acs-v4-0-v13-0-3dd065907c3b@nvidia.com>
References: <20261105-fix-p2p-acs-v4-0-v13-0-3dd065907c3b@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
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
index 91e6367151f1d..ff7f619616e8e 100644
--- a/Documentation/driver-api/pci/p2pdma.rst
+++ b/Documentation/driver-api/pci/p2pdma.rst
@@ -50,12 +50,68 @@ the host route while leaving direct routes available. The host bridge must
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
2.56.0

