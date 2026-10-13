Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939E640488C;
	Tue, 13 Oct 2026 14:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791901569; cv=none; b=mjny2/uoRBE87TMTaFBuU/R1wFB2VMry6c/tvg0pldBLGqgMf/OSWM2r4QUxk8qlQDbkmYvd2KjGF5zHBuDflyry610CgtHS/xAvMMzPJ2Y/1Ogw+u8Msn0v8uWru70mM+tVpW8PNA4G+RDDCALhnwXFNh6cYE3nu1uKiKyxekY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791901569; c=relaxed/simple;
	bh=v5jiCpMWkrh07oK0tdtdK+8prjfw/8L9DOyYygoJIQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jcr1HZaL7VKNPyV5bWd2YvMZ5lolJqV2stXOmiHx+EUC7ePqr3SIZXeEWaDKUV09HOVr463OYWLKkVKhH0EipzdX+ScCkzdPKFb8a7Zy3PqZqQmn5IRf+MrQDg46/3JaQQsaMcNq9lrIkNq5Tn1IJTk0Vky92JZsoZxOk38Mfkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fkz4omZn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fkz4omZn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA97B1F000FF;
	Tue, 13 Oct 2026 14:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791901568;
	bh=iTnNZSds8ZTRRmOa1SIjI4wIDkfFIlXh0Hga6rtsbgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fkz4omZnAbDwB2QC7UW2cn2lRIwQsKf3PnktbodOc+jfXFyXU5hQupX+BIdNY/5AP
	 PlUrlccnRRGUsXHG9vdP42GOleM8/R1/tSgo8HwssNx0bK0+ByS8bEQQFJ8Qa46AzR
	 K7+MgawoF8vvhwz3M6QqDQ9nGMAvZ2WXxAi4xNpCtcJiJEQzsYVaFLOjId3+auln1p
	 d57xUeVEV5XoEfjWuJXj0Q7XnuS+xC3a9hXCSD8oMVqMxs1zYne2LNiuwkcPzBZi/g
	 0/uTp33v4VCZGngSIK7gfYnXi9YWxTIrFRE4qcL3C12alBv5cF9kv6OWCwEQvWpm54
	 pFL8SrxNLdosA==
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
Subject: [PATCH v11 09/19] PCI/P2PDMA: Route Relaxed Ordering Completions directly
Date: Tue, 13 Oct 2026 17:25:17 +0300
Message-ID: <20261013-fix-p2p-acs-v4-0-v11-9-72cf8c96e617@nvidia.com>
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
2.55.0

