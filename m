Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793694627;
	b=XZNV/vO0nuh+XtQJrQaTE097dzgoc8kcH62UF35eurxv1K0fWRwYl9P+j3vKImbI1Yqt
	 8MzL0XXUswccadP1/zedK/EuXROOLNImGGY7DGCdqYA5AWaTxiTcJDBkvJHdwnVkMVQf9
	 5qQT4QUY0RPNSrBCzf3Qq5l0gAya0iG9+dtpJKt/lDYnHca8tHGG7s4UNglR5qTXLocs4
	 Z/cTpdAwkMxPAX/SokLvuQAZTkw0wQnLMzpRSelrXlJdiaIKDlelHsF7RuflG3FGKpK3U
	 cqCnfrotYg7yCbhoyKBgGziSkqUlioF8+nZu61L3uqoVFPHtIx3NBN4/Qqaub2JD6jQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793694627;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=P2pPRn/WYNVkwFiThHJgOgvfKgNeTN83hXLhzykmr/w=;
	b=R5y0iSHJC/Tlry2mvh75ITXaT/ldV/PGlNv/6l/+1R2YeiJ3dg24+8fa6wXJG5s5Yef6
	 ZKIIntchPkq9R3u3j2L0/z4K4rQKnYcFtGVmu0aReib8A9Rp2PxFO7+CxLlje/zHDChth
	 Rdu8++nO7ieiBrFVaJxNpLZFs68EJfSxBcZixcbBhy7McAHUztIRsn6mOLyMgNbiKMJQi
	 KoiscOe/scVd+JH1xm/5X6nnYeB/DzxixJmqexu6gw7tvgoa42IDDUfQVYZVuyr7dYgAg
	 QcasMSx8WAtGm0x+kBGA2V1LJ4D+aJPBDi6TeWPlvNbKyl6t+DXXyv+Ov1XBqrMllrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gGpYcG8+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2965606EE9A;
	Tue,  3 Nov 2026 08:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gGpYcG8+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 963D41F00A2A;
	Tue,  3 Nov 2026 08:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793694626;
	bh=P2pPRn/WYNVkwFiThHJgOgvfKgNeTN83hXLhzykmr/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gGpYcG8+KpY3FKHqN2QEMzGYUKpuicz6q0WlJ7O0wkN64cSxQBrm8GwU+B8OuPtgP
	 DrLWx02gPHxR9fMEQ+iestcpSZZYtF0AH+5wIn9kC9SJc7ZoBpKSF3jbgYoN+6s0v1
	 CfKE5eeD3PKDWLPWucq/+x4g+6FJe4WiITeII3yiFlVR/7WmGVfCXZ2CuNWCiITFJ9
	 +xURZYRkOD3Dsbb3QqDMfY/u/rCDyZkBqNPZxMxK/obKKOJf2e37/2VCAhSHTMayYt
	 ParCgAYXhPL7Mv8FiZBf3bJJFGf24Mslsnkx531duqzdRZD3rt26CFe4s6M0jPgqec
	 oPg84CnjBKzAQ==
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
Subject: [PATCH v12 06/19] PCI/P2PDMA: Document directional ACS routing
Date: Tue,  3 Nov 2026 10:29:45 +0200
Message-ID: <20261103-fix-p2p-acs-v4-0-v12-6-912101f93517@nvidia.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103-fix-p2p-acs-v4-0-v12-0-912101f93517@nvidia.com>
References: <20261103-fix-p2p-acs-v4-0-v12-0-912101f93517@nvidia.com>
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
index 0b3c140babd9..f7e116703ffc 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5251,11 +5251,12 @@ Kernel parameters
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
2.56.0

