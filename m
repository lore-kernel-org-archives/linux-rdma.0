Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793873178;
	b=M46doPBAdUS+oK1ihq+UJh9l+DQg4g7l6l8Kp8z9xhnk1LMI3tSNoWoY3V7f/cTa89k1
	 BgglziKH++XNQOWb6oaWFX4X9lC7QQApNR5NdihpcCjAMd7zhuH4tNZ3bx5SAnm3Hgh16
	 GBN/a5c6I1UuTNPyx8WzLanyy/6PVUxePun8f3axMvecqUTbfaa/ChscbXhbp8SlRhET7
	 yeq5m2nG+05RWSC0JAltFmuU/POLmNhtTdttw+b/DYi6kSPzeFIBp8qME8ZatoXzl6O3p
	 IVuIEeMuy1wSrV1suMD3nIYiLhZSeqcUZHuhcF+P3JNQnp9QD7Wtn4uvy1n+kpghb9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793873178;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=rhtql+vM6ZB/bHRf54yo/Qw/22uUqR/sQ/wTnHlHfSc=;
	b=EUZ+votAK+FqL4IjQLWozJ2DuuRIueoUFhO8fx6aMkSr002mLUpemwepIQkf8PHXWw+6
	 pm8T1oke44o5+qtlPFZMA+Z+xHhehdyE3mCRQUj7sIv7fKgbbQF8eWTmCchs9vzszTkdk
	 tGvvSN3ShuubUBn41YW/chrwfN4nsJj+0DVxoPFLbGClWi9Q0AIdRlVzJ5nmcj/aIugz7
	 aPlwKdZmA5+V7dUUIo1P1tVGi1nwkcaVg2qjHG5BUcHJ5p1Q+E9Q5NygANk1ENZIXv14E
	 3JC5oNBMSsRKHKPE8w7GtO1QcZx8oulElCHMmnAulpd0fzH0/97YtMQBL0gCekwFPCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Np4LXNrj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F43606D835;
	Thu,  5 Nov 2026 10:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Np4LXNrj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DA51F00A28;
	Thu,  5 Nov 2026 10:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793873177;
	bh=rhtql+vM6ZB/bHRf54yo/Qw/22uUqR/sQ/wTnHlHfSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Np4LXNrj5tooHkTa/RKVOyul+SA6Al/nreoDiRzorsc2iV3dsCUIC2v8j810BFesd
	 nS0+JybOrlTKY+rHhGBSHKMaqfYhtrFK40mAxxZQlfyD5CzPdRMi12gnXieTbdcEQ2
	 8HRvd5IJ5CWfw0eqTT+kKhhdTuAG+b5uwB/0b7HFthRebazpchRf15cVV3HOXqPsIM
	 Ip+dpe1HMjdvie+CcFvS3/jnfpfjUa/doUPUANbXF9dL4Al+lgSGpv2oQgCUJ3orvD
	 mWaTQ3N5Y7kJj2a81WxoNjrdEmYx4u9IagBwdTo3xYhgt3+HyoFH7lqMMsFZQy97CA
	 128PpaHPDAyPQ==
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
Subject: [PATCH v13 09/19] PCI/P2PDMA: Route Relaxed Ordering Completions directly
Date: Thu,  5 Nov 2026 12:04:40 +0200
Message-ID: <20261105-fix-p2p-acs-v4-0-v13-9-3dd065907c3b@nvidia.com>
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
index 35d4aafbed260..2d5a9488da41b 100644
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
@@ -740,6 +744,7 @@ static void pci_p2pdma_warn_redir(struct pci_dev *client,
  *		than upstream, so it is where the Request controls apply.
  * @cpl_ctrl:	ACS Control of the Completer-side divergence port, likewise for
  *		the Completions travelling back.
+ * @cpl_quirk:	A device quirk reports Completion Redirect at that port.
  * @req_upstream: The Requester has no internal route to its sibling.
  * @cpl_upstream: The Completer has no internal route to its sibling.
  * @unreadable:	First port whose ACS Control could not be read, if any.
@@ -749,6 +754,7 @@ static void pci_p2pdma_warn_redir(struct pci_dev *client,
 struct pci_p2pdma_acs_path {
 	u16 req_ctrl;
 	u16 cpl_ctrl;
+	bool cpl_quirk;
 	bool req_upstream;
 	bool cpl_upstream;
 	struct pci_dev *unreadable;
@@ -766,11 +772,16 @@ pci_p2pdma_request_state(const struct pci_p2pdma_acs_path *path,
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
@@ -1141,6 +1152,7 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 	if (a_child && b_child) {
 		if (!pci_acs_p2pdma_ctrl(a_child, &path.cpl_ctrl))
 			path.unreadable = a_child;
+		path.cpl_quirk = pci_acs_p2pdma_quirk(a_child, PCI_ACS_CR);
 		if (!pci_acs_p2pdma_ctrl(b_child, &path.req_ctrl) &&
 		    !path.unreadable)
 			path.unreadable = b_child;

-- 
2.56.0

