Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDD944605E;
	Mon, 14 Sep 2026 11:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789385025; cv=none; b=W5w/9zfUGEW3n1s+6Grk1a2ve/Am/uDUv9O2z/dMwdAycO6fWQpXAvyviCBxifYRnGcIYiMhjnVKxcLc6zjRklNHQiiChQM7miPtNAk8pNYaNjB8rFkybpR/BOBIqmmcwfE7e/35XLyXO2T8RlqX0z+a9MPQ2MTy4a5z9z3fJlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789385025; c=relaxed/simple;
	bh=/t+DL64LGojkS4yQIOZuTZFiWTkp2eiaWsTM89A9nnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eTTzhh7iFNyA3ItxA8qJ9AmId27yiyyB2100KIf/xip5IoOAm2J7f6DXBYLn/BNASVWuAigS6Lhc39i9Ne/WmIKbFKZAjsuaj/mtdcRcTBn9L03+Oer17hULJ+uG/5Q3ZxNwbiqMHoBXLgtFbo0m+UyF55I8Reiz9kNovrAZESQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cx0yORcu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cx0yORcu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288E21F00893;
	Mon, 14 Sep 2026 11:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789385023;
	bh=Z4R3ZMvcrefwd60N4dKDap5+w8BxOMwsC13REnzGF7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cx0yORcuOY5IVevBTfT/RWXTv7Rnc2btCL/+asRkojSB61usOaqHwO+xDItCz4Rg9
	 y/gFBqPW1LZ+QOolHA3tsr8WItlsyT5e39Cdob1sVf6uvnBKB3Yh43OtitH+yGEpnf
	 pMRWHRnQwBhod0egFXI+l14CnUWxmy3ejWKi3LjDl4tO46rF/Kxfojts42XZ+4r0ti
	 6u6ukpLLo8OK1ocJHY9NAWAoXcSyCZQ+LRieBg4eom3VIpzsNyB+8l/xmzquQ6A7xl
	 5anRvxa6PHPZyTQlQwvV0BlzRDu0axvRZCCtbLiBTHxEXslz0B5SLU/7eegTwWMZfr
	 TJlTUaMgwwrwQ==
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
Subject: [PATCH v6 10/18] PCI/P2PDMA: Reject Translated Requests blocked by Translation Blocking
Date: Mon, 14 Sep 2026 14:22:43 +0300
Message-ID: <20260914-fix-p2p-acs-v4-0-v6-10-5ef07ec9ef06@nvidia.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260914-fix-p2p-acs-v4-0-v6-0-5ef07ec9ef06@nvidia.com>
References: <20260914-fix-p2p-acs-v4-0-v6-0-5ef07ec9ef06@nvidia.com>
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

A Downstream Port with ACS Translation Blocking enabled treats every
Upstream Memory Request whose Address Type is not Untranslated as an ACS
Violation, ahead of "any applicable ACS P2P control mechanisms" per PCIe
r7.0 sec 6.12.1.1. P2PDMA never looks at that bit, so it reports a
bus-addressable path where an ATS client's Requests would be rejected.

Add PCI_ACS_P2PDMA_BLOCKED, and because blocking is not a routing control,
scan the whole client-side path for it rather than the divergence port
alone. A blocked Request has no host bridge fallback, since the Address
Type is rejected wherever the Request is addressed.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c | 105 ++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 96 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 327b6a14e07d..94c0760f27e5 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -519,11 +519,12 @@ enum pci_acs_p2pdma_state {
 	PCI_ACS_P2PDMA_NOT_SUPPORTED,
 	PCI_ACS_P2PDMA_DIRECT,
 	PCI_ACS_P2PDMA_REDIRECT,
+	PCI_ACS_P2PDMA_BLOCKED,
 };
 
 /*
  * Decide how a peer-to-peer Request at an ACS-capable ingress port routes,
- * from that port's ACS Control register.
+ * from that port's ACS Control register and the Request's Address Type.
  *
  * Linux does not read the Egress Control Vector, so Egress Control is treated
  * conservatively as a redirect. Per PCIe r7.0 Table 6-11 the outcomes it
@@ -533,6 +534,18 @@ enum pci_acs_p2pdma_state {
 static enum pci_acs_p2pdma_state
 pci_acs_p2pdma_request(u16 ctrl, unsigned int tlp_flags)
 {
+	if (tlp_flags & PCI_P2PDMA_TLP_TRANSLATED) {
+		/*
+		 * PCIe r7.0 sec 6.12.1.1: Translation Blocking makes every
+		 * Upstream Memory Request whose Address Type is not
+		 * Untranslated an ACS Violation, taking precedence over the
+		 * P2P controls. Sec 7.7.12.5: Direct Translated P2P "is
+		 * ignored if ACS Translation Blocking Enable is 1b".
+		 */
+		if (ctrl & PCI_ACS_TB)
+			return PCI_ACS_P2PDMA_BLOCKED;
+	}
+
 	return ctrl & (PCI_ACS_RR | PCI_ACS_EC) ?
 		PCI_ACS_P2PDMA_REDIRECT : PCI_ACS_P2PDMA_DIRECT;
 }
@@ -572,6 +585,35 @@ static bool pci_acs_p2pdma_ctrl(struct pci_dev *pdev, u16 *ctrl)
 	return !pci_read_config_word(pdev, pos + PCI_ACS_CTRL, ctrl);
 }
 
+/*
+ * Report whether any port between @client and @divergence rejects Translated
+ * addresses. @common bounds the walk; @divergence itself is read along with
+ * the routing controls. A port whose ACS Control cannot be read counts as
+ * blocking, which withdraws only the Translated classes because an
+ * Untranslated Request is routed at the divergence.
+ */
+static bool pci_p2pdma_path_blocks_translation(struct pci_dev *client,
+					       struct pci_dev *divergence,
+					       struct pci_dev *common)
+{
+	struct pci_dev *pdev;
+	u16 ctrl;
+
+	for (pdev = pci_upstream_bridge(client); pdev && pdev != common;
+	     pdev = pci_upstream_bridge(pdev)) {
+		if (pdev == divergence)
+			continue;
+
+		if (!pci_acs_p2pdma_ctrl(pdev, &ctrl))
+			return true;
+
+		if (ctrl & PCI_ACS_TB)
+			return true;
+	}
+
+	return false;
+}
+
 static void seq_buf_print_bus_devfn(struct seq_buf *buf, struct pci_dev *pdev)
 {
 	if (!buf)
@@ -590,14 +632,35 @@ static void seq_buf_print_bus_devfn(struct seq_buf *buf, struct pci_dev *pdev)
  *		than upstream, so it is where the Request controls apply.
  * @cpl_ctrl:	ACS Control of the provider-side divergence port, likewise for
  *		the Completions travelling back.
+ * @tb_below:	A port between the client and the divergence blocks Translated
+ *		addresses.
  * @unreadable:	First port whose ACS Control could not be read, if any.
  */
 struct pci_p2pdma_acs_path {
 	u16 req_ctrl;
 	u16 cpl_ctrl;
+	bool tb_below;
 	struct pci_dev *unreadable;
 };
 
+/*
+ * ACS Translation Blocking is not a routing control, so unlike the redirect
+ * controls it is not decided at the divergence alone. PCIe r7.0 sec 6.12.1.1
+ * has every Downstream Port check the Address Type of each Upstream Memory
+ * Request it receives, ahead of "any applicable ACS P2P control mechanisms".
+ * A port below the divergence cannot redirect the Request anywhere it was not
+ * already going, but it can still reject a Translated address.
+ */
+static enum pci_acs_p2pdma_state
+pci_p2pdma_request_state(const struct pci_p2pdma_acs_path *path,
+			 unsigned int tlp_flags)
+{
+	if (tlp_flags & PCI_P2PDMA_TLP_TRANSLATED && path->tb_below)
+		return PCI_ACS_P2PDMA_BLOCKED;
+
+	return pci_acs_p2pdma_request(path->req_ctrl, tlp_flags);
+}
+
 /*
  * Combine both directions into a mapping type. Only a path that routes the
  * Request and the Completions it generates directly can be programmed with
@@ -607,11 +670,23 @@ static enum pci_p2pdma_map_type
 pci_p2pdma_route(const struct pci_p2pdma_acs_path *path,
 		 unsigned int tlp_flags)
 {
+	enum pci_acs_p2pdma_state req;
+
 	if (path->unreadable)
 		return PCI_P2PDMA_MAP_NOT_SUPPORTED;
 
-	if (pci_acs_p2pdma_request(path->req_ctrl, tlp_flags) ==
-		    PCI_ACS_P2PDMA_DIRECT &&
+	req = pci_p2pdma_request_state(path, tlp_flags);
+
+	/*
+	 * Translation Blocking rejects the Address Type rather than the
+	 * target, so a blocked Request stays blocked however it is addressed.
+	 * No host bridge fallback keeps a Translated address working; the
+	 * caller has to issue a different kind of Request instead.
+	 */
+	if (req == PCI_ACS_P2PDMA_BLOCKED)
+		return PCI_P2PDMA_MAP_NOT_SUPPORTED;
+
+	if (req == PCI_ACS_P2PDMA_DIRECT &&
 	    pci_acs_p2pdma_completion(path->cpl_ctrl, tlp_flags) ==
 		    PCI_ACS_P2PDMA_DIRECT)
 		return PCI_P2PDMA_MAP_BUS_ADDR;
@@ -640,12 +715,19 @@ static void pci_p2pdma_warn_path(struct pci_dev *client,
 		return;
 	}
 
+	if (pci_p2pdma_request_state(path, tlp_flags) ==
+	    PCI_ACS_P2PDMA_BLOCKED) {
+		pci_warn(client,
+			 "ACS Translation Blocking rejects Translated Requests to provider %s\n",
+			 pci_name(provider));
+		return;
+	}
+
 	seq_buf_init(&acs_list, buf, sizeof(buf));
 	if (pci_acs_p2pdma_completion(path->cpl_ctrl, tlp_flags) !=
 	    PCI_ACS_P2PDMA_DIRECT)
 		seq_buf_print_bus_devfn(&acs_list, a_child);
-	if (pci_acs_p2pdma_request(path->req_ctrl, tlp_flags) !=
-	    PCI_ACS_P2PDMA_DIRECT)
+	if (pci_p2pdma_request_state(path, tlp_flags) != PCI_ACS_P2PDMA_DIRECT)
 		seq_buf_print_bus_devfn(&acs_list, b_child);
 
 	/* Drop the final semicolon; the list is not empty here. */
@@ -864,8 +946,11 @@ pci_p2pdma_map_types_unpack(unsigned long val, unsigned int tlp_flags)
  * redirection setting of the ports along the path.
  *
  * The client initiates Requests to provider memory. At the path divergence,
- * check Request Redirect and Egress Control on the client-side port, and
- * Completion Redirect for read Completions on the provider-side port.
+ * check Request Redirect, Egress Control, Translation Blocking and Direct
+ * Translated P2P on the client-side port, and Completion Redirect for read
+ * Completions on the provider-side port. Translation Blocking is checked on
+ * every client-side port instead, because it rejects a Request rather than
+ * routing it.
  *
  * Those controls apply to different TLPs, so every class named by &enum
  * pci_p2pdma_tlp_flags is decided from the one walk and cached together;
@@ -873,8 +958,8 @@ pci_p2pdma_map_types_unpack(unsigned long val, unsigned int tlp_flags)
  *
  * If ACS redirects traffic at either divergence port, return
  * PCI_P2PDMA_MAP_THRU_HOST_BRIDGE. If the ACS Control register cannot be
- * read, return PCI_P2PDMA_MAP_NOT_SUPPORTED. Otherwise, return
- * PCI_P2PDMA_MAP_BUS_ADDR.
+ * read, or Translation Blocking rejects the class being asked about, return
+ * PCI_P2PDMA_MAP_NOT_SUPPORTED. Otherwise, return PCI_P2PDMA_MAP_BUS_ADDR.
  *
  * Any two devices that have a data path that goes through the host bridge
  * will consult a whitelist. If the host bridge is in the whitelist, return
@@ -945,6 +1030,8 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 		if (!pci_acs_p2pdma_ctrl(b_child, &path.req_ctrl) &&
 		    !path.unreadable)
 			path.unreadable = b_child;
+		path.tb_below = pci_p2pdma_path_blocks_translation(client,
+								   b_child, a);
 	}
 
 	/*

-- 
2.55.0

