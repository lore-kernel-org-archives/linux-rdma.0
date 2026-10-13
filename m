Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624A24F93BC;
	Tue, 13 Oct 2026 14:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791901558; cv=none; b=ZTsklmOBoiXuoxWES42elfdq/HTsA1giSmMu5wM72v+HK2yroAd4bwYbjMNVHFdEcCYHb9oPPpa00/p9kN8qZPrCGvDPxbqloEn4me+x+PaeoupkZIYxST+b/mHlZcNl0221ZZ9n2Q28yZhgvJonCW9Wf0ZrMI5qi/Q3GLi2K9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791901558; c=relaxed/simple;
	bh=ydIDOdCqoMaT838buxImYNrNpIkaLuM3MREB/JTHIMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JiZ1uAYP3RacQemzNt4helD/nXE8w2ZtQm5i2khhsoEhp1GBsL0pt6PKFMbBAzk80k8x96GW9iMHOzrFQ9y5tkVTRbPPC5A5dWOLezBlYWtw5fmAaMKFdkulmdDCX8Xy2avxvVktrHPfwrIDpCBVTUwp1rTnxgyiKwNKPU1l5g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AAYt5LV+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AAYt5LV+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D2771F000FF;
	Tue, 13 Oct 2026 14:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791901557;
	bh=SleO4Y4j4tArPmM5s91MwfFdTPepML+5PCBY+x0KZX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AAYt5LV+qO7FAM9XaLugcz0A+OLlFzejip8lAt3mZ9ZSwftiVuHIDLcOJ2AkQX2pA
	 klaa9YmnP2srXG+E/rvxtQRPCCQkUocBN6EDoNJjZsxRHTChA5HZNZnDdRvGHTcnz7
	 a/EqcF4MGr3+hWg3HiN0lv0dK33CQt11ekdR22eTb/970X5XtdMwHKrj12tJIz8U52
	 yGKUyRlgdeGGO2Zd2a+NWC3N1itrHlXdElk6+LLGDd94Mtqyyjk8bLmBqo9Os36pBe
	 E2UCy6+Q/pHDOqhpuLg4dAyyf8XFkq7o4ZPJLoBVXZttnV8gMTKpw3FBqPVAjC95vv
	 eqXQ4t30kmKzQ==
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
Subject: [PATCH v11 06/19] PCI/P2PDMA: Document directional ACS routing
Date: Tue, 13 Oct 2026 17:25:14 +0300
Message-ID: <20261013-fix-p2p-acs-v4-0-v11-6-72cf8c96e617@nvidia.com>
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

P2PDMA documentation describes ACS controls as path-wide, although Request
and Completion controls apply to different transaction directions at the
path divergence. Functions sharing one PCIe link may instead have no
internal peer route even with redirect controls clear.

Document the Requester and Completer roles, the directional controls and
the separate requirements for sibling functions. Explain that a missing
internal route requires upstream forwarding and host-bridge support, and
cannot be created by clearing redirect controls.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 Documentation/admin-guide/kernel-parameters.txt | 11 ++++----
 Documentation/driver-api/pci/p2pdma.rst         | 34 +++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 68647ff4bdd2..8507ac79a919 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5292,11 +5292,12 @@ Kernel parameters
 				Specify one or more PCI devices (in the format
 				specified above) separated by semicolons.
 				Each device specified will have the PCI ACS
-				redirect capabilities forced off which will
-				allow P2P traffic between devices through
-				bridges without forcing it upstream. Note:
-				this removes isolation between devices and
-				may put more devices in an IOMMU group.
+				P2P Request Redirect, Completion Redirect, and
+				Egress Control features forced off. This may
+				allow P2P traffic through bridges that would
+				otherwise be redirected upstream. Note: this
+				removes isolation between devices and may
+				cause affected devices to share an IOMMU group.
 		config_acs=
 				Format:
 				<ACS flags>@<pci_dev>[; ...]
diff --git a/Documentation/driver-api/pci/p2pdma.rst b/Documentation/driver-api/pci/p2pdma.rst
index 80f8fec9b0e9..7b11d7d1fdc6 100644
--- a/Documentation/driver-api/pci/p2pdma.rst
+++ b/Documentation/driver-api/pci/p2pdma.rst
@@ -15,6 +15,40 @@ then based on the ACS settings the transaction can route entirely within
 the PCIe hierarchy and never reach the root port. The kernel will evaluate
 the PCIe topology and always permit P2P in these well-defined cases.
 
+The client is the PCIe Requester and the provider is the Completer, whether
+the client reads or writes provider memory. For devices on separate links
+below the same Root Port, their paths first meet in a Switch, where they
+diverge.
+A Request enters that Switch through the Downstream Port above the
+Requester, the Requester-side port. If ACS P2P Request Redirect is enabled
+there, the Request is routed upstream; otherwise it is routed back
+downstream through the Downstream Port leading to the Completer, the
+Completer-side port. The path of Completions from a read likewise depends on
+ACS P2P Completion Redirect in the Completer-side port. An enabled Egress
+Control is conservatively treated as a Request redirect.
+
+Below the divergence, the route toward the other branch is already upstream,
+so those P2P redirect controls do not affect it. Redirect controls for the
+reverse transaction directions do not affect the mapping. P2P DMA is routed
+through the host bridge when either applicable port redirects. If an ACS
+Control register cannot be read, P2P DMA is rejected because the kernel cannot
+establish a usable route.
+
+Functions sharing one PCIe link can instead route internally within their
+device. An ACS capability without Request or Completion Redirect support
+means that the corresponding internal route does not exist. Device-specific
+ACS quirks can report the same restriction for functions without ACS, and
+SR-IOV functions without ACS cannot support internal peer traffic. These
+restrictions apply only between functions sharing the link, including ARI
+functions and VFs; they do not redirect traffic to a separate device.
+
+When traffic between sibling functions goes upstream, ACS Upstream Forwarding
+must be enabled, or provided by a device-specific quirk, at every shared
+Downstream and Root Port on the way to the host bridge. The topology walk
+rejects a host route without this forwarding support. The host bridge must
+also support P2P. Clearing redirect controls cannot create an internal route
+that the device does not support.
+
 This evaluation assumes clients issue strictly ordered Requests carrying an
 Untranslated address. Its result is not defined when clients use Relaxed
 Ordering or issue ATS-translated Requests because those TLP attributes can

-- 
2.55.0

