Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793694638;
	b=EZFMfmDgS7bDYEKk1PuYLYz34xTNGZ0gCWGhBHZcw2wsAJ9XQkO7dgPV4dEqPX3K0Eb1
	 LCdVNZUBq4Kx0I/X1wXhCAboy/SoAQHl/Pd0LDGA7I0kgR1XKE376HXsYPhU+N0UtXq4G
	 S3ZaQQAQ20iIdjbjPEhQrh9eH3PXuT9c3d9o8ATyh8sxgkYtxo+Sb9Z4y+BzNOn/OLAIc
	 FLtu63Sc/h2hewf2pJaHWCsm7Pbb3OjSCUs7xliU0w2i4tB9/FFxiu4TlimbL/GHKNA31
	 fS7MvgUGQ3n9025bJhlxV1IMfHsFVN5JdVY4EVJNQwmDUEe1tJeNfJrzUSO3vpZKXBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793694638;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=PmDjqu8cLkPviHiNjMUUQIVJ2jpv6ZvNX41K9VUO8WU=;
	b=QcxQIV/MVgl0mpWsbiPFhgTSjfGzh79XOUA2ZIVpBchD6EHWYxBN1nt9rC0+udIqne3V
	 nhhne6Ok0mKsSy9yzsgQOEGposBXlo0IjT4RZnxD6145IyYFLZiINHG9xL2bfhplvJwij
	 lJ76AQ0VMLziWWuZk/qfzhZRgDT8ZDd7qHJajH4/rp5YlWGvqFwclD/OMm/rhNahEK3rj
	 32er4TSJfIYUiGO9TVCq7C1wHUBU0Wyv66uUMOAkl8QKAjsPUTWt3kS/9iVdSar8FkzmD
	 JZ1GHM0Dmtgqqry8UoVi/tNabPovsW/LP/wfSh5WTx4nkx7Xf5czaZnSrcdtdxSUvaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MXX0w2fQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400896082BC7;
	Tue,  3 Nov 2026 08:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MXX0w2fQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D6721F00A1A;
	Tue,  3 Nov 2026 08:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793694637;
	bh=PmDjqu8cLkPviHiNjMUUQIVJ2jpv6ZvNX41K9VUO8WU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MXX0w2fQsfVxVWK0KooDW/yUdbe2C1laSplOJSfxmPGbcfVs/NGrNIDZLTzcTboDk
	 iiljwU5fFhWR48hfg0VuHqkKEf6vuc0TMWVp++GXM4KJbzFVpy9xO0DZqoG1oA8ajD
	 45UcQl+0wbL/+93NhTI8trgPryZaztfpUSO+kWwVX3ZlWTxPfP2m/iB7WfyPFI7ECy
	 XPQbFqA9Ttyrp/AkE1dG1UAqTCi/c3WFlurY8aAF3u9zGj4R+aPdNJCRrEP+UhFwuy
	 00teU0FfhwVwIXhngWnWCck0OpNHEtGAFnasw9A0NTq4TQDODvOm08DVHUcMJpkx3J
	 4pORahJtHDm9g==
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
Subject: [PATCH v12 09/19] PCI/P2PDMA: Route Relaxed Ordering Completions directly
Date: Tue,  3 Nov 2026 10:29:48 +0200
Message-ID: <20261103-fix-p2p-acs-v4-0-v12-9-912101f93517@nvidia.com>
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

ACS P2P Completion Redirect leaves Completions carrying Relaxed Ordering
alone, per PCIe r7.0 sec 6.12.1.1. A Completion copies that attribute from
its Request, so a client setting it on Non-Posted Requests need not use the
host bridge solely because Completion Redirect is enabled.

Route Completions directly for PCI_P2PDMA_TLP_RELAXED_CPL unless a device
quirk redirects them or the Completer lacks an internal route to its
sibling. Neither restriction promises a Relaxed Ordering exception. No
caller selects these classes yet.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 9d416329aa4b..785e4668a2af 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -580,11 +580,15 @@ pci_acs_p2pdma_request(u16 ctrl, unsigned int tlp_flags)
 /*
  * Decide how a peer-to-peer Completion at an ACS-capable ingress port routes.
  * PCIe r7.0 sec 6.12.1.1: no ACS control other than P2P Completion Redirect
- * affects a Completion.
+ * affects a Completion, and that one leaves Completions carrying the Relaxed
+ * Ordering attribute alone.
  */
 static enum pci_acs_p2pdma_state
 pci_acs_p2pdma_completion(u16 ctrl, unsigned int tlp_flags)
 {
+	if (tlp_flags & PCI_P2PDMA_TLP_RELAXED_CPL)
+		return PCI_ACS_P2PDMA_DIRECT;
+
 	return ctrl & PCI_ACS_CR ? PCI_ACS_P2PDMA_REDIRECT :
 				   PCI_ACS_P2PDMA_DIRECT;
 }
@@ -737,6 +741,7 @@ static void pci_p2pdma_warn_redir(struct pci_dev *client,
  *		than upstream, so it is where the Request controls apply.
  * @cpl_ctrl:	ACS Control of the Completer-side divergence port, likewise for
  *		the Completions travelling back.
+ * @cpl_quirk:	A device quirk reports Completion Redirect at that port.
  * @req_upstream: The Requester has no internal route to its sibling.
  * @cpl_upstream: The Completer has no internal route to its sibling.
  * @unreadable:	First port whose ACS Control could not be read, if any.
@@ -745,6 +750,7 @@ static void pci_p2pdma_warn_redir(struct pci_dev *client,
 struct pci_p2pdma_acs_path {
 	u16 req_ctrl;
 	u16 cpl_ctrl;
+	bool cpl_quirk;
 	bool req_upstream;
 	bool cpl_upstream;
 	struct pci_dev *unreadable;
@@ -761,11 +767,16 @@ pci_p2pdma_request_state(const struct pci_p2pdma_acs_path *path,
 	return pci_acs_p2pdma_request(path->req_ctrl, tlp_flags);
 }
 
+/*
+ * ACS P2P Completion Redirect leaves Relaxed Ordering Completions alone. A
+ * device quirk that reports Completion Redirect does not promise that, so
+ * treat every Completion through that port as redirected.
+ */
 static enum pci_acs_p2pdma_state
 pci_p2pdma_completion_state(const struct pci_p2pdma_acs_path *path,
 			    unsigned int tlp_flags)
 {
-	if (path->cpl_upstream)
+	if (path->cpl_quirk || path->cpl_upstream)
 		return PCI_ACS_P2PDMA_REDIRECT;
 
 	return pci_acs_p2pdma_completion(path->cpl_ctrl, tlp_flags);
@@ -1132,6 +1143,7 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 	if (a_child && b_child) {
 		if (!pci_acs_p2pdma_ctrl(a_child, &path.cpl_ctrl))
 			path.unreadable = a_child;
+		path.cpl_quirk = pci_acs_p2pdma_quirk(a_child, PCI_ACS_CR);
 		if (!pci_acs_p2pdma_ctrl(b_child, &path.req_ctrl) &&
 		    !path.unreadable)
 			path.unreadable = b_child;

-- 
2.56.0

