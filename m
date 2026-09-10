Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79798477293;
	Thu, 10 Sep 2026 11:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789039959; cv=none; b=W+BNLjlpG5qZ0vzuaBZ0BeBtg7zi5CfOgAIrGIQU9xP6DjNriZ/B3YztckhsJXSbGo7LHoflBVIGpb+itSVHD1H7hUimDUIiwnuHsIAsKCLpuXLWvwlnFTpTzG1ViG4g/4j71noWYcm+Nqhomj0ZIi8F7oE93hmqEVtRCS0cJTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789039959; c=relaxed/simple;
	bh=3mMax6tEtS6HXskdbg5O/HITyZZjE2ilSYcvfQJ/HWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A6FY7b3OCaKmyGsJhIWXt7lZ8Ogrbt/EUi06dZ+QTpB7Y/QG1CjCGpJplG8YBdJaQHDnAnzrilXUSDbYcfrvQ4FhFau4S1M+2BC8U2hLV3xn7dcaP9x0WdhpJSPAa6bcMtNj4SooVr7MxMFgrS5H6+aQWELTFMxxILd/ti+kNb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nbZTW7V3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nbZTW7V3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9751F00893;
	Thu, 10 Sep 2026 11:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789039957;
	bh=Ry6T6D/pwfGxSb4X1rqr80n4nBDGwc9qJPxAeSwSHa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nbZTW7V3P5yPRRsbgyZgxp7OUOwRc67JgbPEYDoLs0qcYrwwKEvORuFN3a1YH35eP
	 fY0Hqlx4wkcBYPFEfEEVhvwSTaLyJdixCB6jJ0IaKvKX80I6qYYAl5OiRZ4dRHglT3
	 dmjXp1St7OGpHDo/y7wA+xhlrYqpTTvUCy4mT2W7LGh6gFJ3HfHt5fCIXJ8bsehACx
	 hjX/MSbz/dd26fp/xSrAjo3F4Jdmf5zOy9rvqQmAP3/BdoTKIq4hHbMe9bH5kvcrY0
	 t35VnJkLE8MKgx9ewS8rB0mlcwImuyzmaC0TETOPxFl/QZu3nxDkxTXmPKT5OfRXjK
	 lGREuBycRNLcw==
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
Subject: [PATCH v5 06/18] PCI/P2PDMA: Document directional ACS routing
Date: Thu, 10 Sep 2026 14:32:01 +0300
Message-ID: <20260910-fix-p2p-acs-v4-0-v5-6-856087f63c0d@nvidia.com>
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

P2PDMA documentation describes ACS controls as path-wide, although Request
and Completion controls apply to different transaction directions and only
affect peer-versus-upstream decisions at the path divergence.

Document the fixed client and provider roles, the divergence port checked
for each TLP direction, and the conservative handling of unreadable ACS
state. Clarify which controls disable_acs_redir changes.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 Documentation/admin-guide/kernel-parameters.txt |  9 +++++----
 Documentation/driver-api/pci/p2pdma.rst         | 13 +++++++++++++
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 68647ff4bdd2..43a25f3f94fd 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5291,10 +5291,11 @@ Kernel parameters
 		disable_acs_redir=<pci_dev>[; ...]
 				Specify one or more PCI devices (in the format
 				specified above) separated by semicolons.
-				Each device specified will have the PCI ACS
-				redirect capabilities forced off which will
-				allow P2P traffic between devices through
-				bridges without forcing it upstream. Note:
+				Each device specified will have the PCI ACS P2P
+				Request Redirect, Completion Redirect, and Egress
+				Control features forced off. This may allow P2P
+				traffic through bridges that would otherwise be
+				redirected upstream. Note:
 				this removes isolation between devices and
 				may put more devices in an IOMMU group.
 		config_acs=
diff --git a/Documentation/driver-api/pci/p2pdma.rst b/Documentation/driver-api/pci/p2pdma.rst
index 80f8fec9b0e9..42b18610bf7d 100644
--- a/Documentation/driver-api/pci/p2pdma.rst
+++ b/Documentation/driver-api/pci/p2pdma.rst
@@ -15,6 +15,19 @@ then based on the ACS settings the transaction can route entirely within
 the PCIe hierarchy and never reach the root port. The kernel will evaluate
 the PCIe topology and always permit P2P in these well-defined cases.
 
+The client remains the PCIe requester when it reads or writes provider memory.
+Where the paths diverge, the kernel therefore evaluates P2P Request Redirect
+and Egress Control on the client-side port, and P2P Completion Redirect on the
+provider-side port for completions from a read. An enabled Egress Control is
+conservatively treated as a Request redirect.
+
+Below the divergence, the route toward the other branch is already upstream,
+so those P2P redirect controls do not affect it. Redirect controls for the
+reverse transaction directions do not affect the mapping. P2P DMA is routed
+through the host bridge when either applicable port redirects. If an ACS
+Control register cannot be read, P2P DMA is rejected because the kernel cannot
+establish a usable route.
+
 This evaluation assumes clients issue strictly ordered Requests carrying an
 Untranslated address. Its result is not defined when clients use Relaxed
 Ordering or issue ATS-translated Requests because those TLP attributes can

-- 
2.55.0

