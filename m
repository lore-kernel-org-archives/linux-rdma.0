Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8F04A2E32;
	Mon, 28 Sep 2026 11:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790594395; cv=none; b=aXldBNblx8hpmSn35U3Lc/3SiCk0xkZWoJhBy7sbyrIlUlghyDCoFEUm3oASNKPt3rKqc2jzr68nbZNLxuImYiW4HIaDwjkFGJTn4aBhYZ7keYsDpQ2Yq0jZBaoPCscosKI/vbriMgCPKT0W2W/MTeSSNLQwMTx7pbWzct2h670=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790594395; c=relaxed/simple;
	bh=71jVaBjyZuoLNNx+bNul7zhaxrvycDU4I/l4vBaY4CA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nSCWTDdywsWRFh1mDa1/enzm9GZNcZVOv4329COS579JiTuY2PQA1A0/c1oC+ucjv1lzRmCUshzKtbugTTT420Ux2Nn4JXUcygnLi+qRSjQoPDnNhNE+0WPVIytFBeGmgCwsOTa0nlcRST2GJBtJJQG1JeE7hLrYf8njPZ/o/Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Km8KGdr9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Km8KGdr9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C82E01F0089A;
	Mon, 28 Sep 2026 11:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790594393;
	bh=NXMIcf51pqX530la2Oa4PtVUCCs8cvksEPgvaOoHW6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Km8KGdr9cEnbPlTgvIsYc1R87XbqoF/vWrA7rOTnx8Vx8Rmp5lmyrcRcf/DAHiCUr
	 8rPjcZGVwb8ipbAcIUPho/dNEv931TVkGjni5vqsmO1csOAklo+eZp5xUFsBfMni/R
	 Uc4ez8T7+SQnXGYtgAwwUC58NFX1VKPMjY3gINMKogpCyQMFBsWWjaYs9WW7hxH9Ts
	 w+PqOxpLhyElLZkg7mEF+RmiasWK05/EcejVRD0UGztLQuzWujr4jpCxvcAup7RwqE
	 v/eQ0c5YcA2Z1tbBA8vmlwR+NnTub2IqYKsy/OKQdXAqEkmBXCucx8cUOC6S9nq+ni
	 MQLDBeEwKRYJw==
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
Subject: [PATCH v8 05/23] PCI/P2PDMA: Document directional ACS routing
Date: Mon, 28 Sep 2026 14:19:09 +0300
Message-ID: <20260928-fix-p2p-acs-v4-0-v8-5-404453b9c435@nvidia.com>
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

