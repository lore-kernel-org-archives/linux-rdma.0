Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B62249481E;
	Thu,  1 Oct 2026 11:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790855771; cv=none; b=c3ZthQ4cva/KWl3VcMn6S3jiRohxXmlAh8+Qh0omVftFU0UqCfHQAcVpjFSVFFrSjKfUjFSf4U1EFSjKoxx8+EFwfS/qZrEfjDKIWfjPCBeYDtT8feZ3tt/0s9YmxXIWdGvmn9OKGd1vtoM5zGIUj3UmbdV8hiSWMtpiYuNWVWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790855771; c=relaxed/simple;
	bh=71jVaBjyZuoLNNx+bNul7zhaxrvycDU4I/l4vBaY4CA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZrZXANhuOiwvyUt24kfKRWiod+oRX1MUfACQetIGUvhnaWxR4MJ6FNQDcnV3XfAO3BRtdI6tohu6MqLdfz/ujh+Hd4h2WOH5NWYF0ep73L3BwMEfTRaFO4Y8oGS0f+2cYOAXYPUu1EDS5BuJmFtu2CAg0rxvi2ae6SJoieGUt/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ko7cCFGT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ko7cCFGT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE7B1F00898;
	Thu,  1 Oct 2026 11:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790855758;
	bh=NXMIcf51pqX530la2Oa4PtVUCCs8cvksEPgvaOoHW6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ko7cCFGThSB7QGWPP98dxDiIHtjJq6itDER3djdxtsHU1J9BGXu++zNp3huwY6mXY
	 6kIuEbEGG3lUXchbbjc5Tl94zXJrjSjoW9sCQTFtO0z0jMTIdDIkEdZNo6BQaPVSfd
	 DSAZ4q6I1Zsg15AtTvNP1s833/lf/zEcNTvDEh2//v4bfnw9ki2omBZaes+RzYGx1e
	 3vKDrtb+LKYLbNG3HnqQUSlxPymGzd4GrJHU9wD74oIj4HreNgU6NEcCg7HNU7O+hR
	 eJXsUdM2nNBH0t8fyX+4uQZpECijQSFg5NX4YqPvSAItXsA5+9ZosZ3GzPBRi82SrI
	 RA5wLfBlBAXqw==
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
Subject: [PATCH v9 05/18] PCI/P2PDMA: Document directional ACS routing
Date: Thu,  1 Oct 2026 14:55:13 +0300
Message-ID: <20261001-fix-p2p-acs-v4-0-v9-5-1a8e0f50ddd9@nvidia.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261001-fix-p2p-acs-v4-0-v9-0-1a8e0f50ddd9@nvidia.com>
References: <20261001-fix-p2p-acs-v4-0-v9-0-1a8e0f50ddd9@nvidia.com>
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

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Tested-by: Tushar Dave <tdave@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 Documentation/admin-guide/kernel-parameters.txt | 15 +++++++++------
 Documentation/driver-api/pci/p2pdma.rst         | 13 +++++++++++++
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 68647ff4bdd2..bc83e07dd5fc 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5291,12 +5291,15 @@ Kernel parameters
 		disable_acs_redir=<pci_dev>[; ...]
 				Specify one or more PCI devices (in the format
 				specified above) separated by semicolons.
-				Each device specified will have the PCI ACS
-				redirect capabilities forced off which will
-				allow P2P traffic between devices through
-				bridges without forcing it upstream. Note:
-				this removes isolation between devices and
-				may put more devices in an IOMMU group.
+				Each device specified will have the PCI ACS P2P
+				Request Redirect, Completion Redirect, and Egress
+				Control features forced off. This may allow P2P
+				traffic through bridges that would otherwise be
+				redirected upstream. This may allow P2P traffic
+				through bridges that would otherwise be redirected
+				upstream and thus this removes isolation between
+				devices and may cause affected devices to share
+				an IOMMU group.
 		config_acs=
 				Format:
 				<ACS flags>@<pci_dev>[; ...]
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

