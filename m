Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793694642;
	b=QrF30u2KrQK7UcIt+A34cGROmyeUks1b4gLqifGcWVge/YipRbhoYfN6trrqf5glE3mR
	 ySFRJTThrirndkGjVmq1OOqfAasWNlb1tQKwzgQ1h1zR0c+IGTTwrjAAZAtA+srlgH7Gj
	 D1AWyDMj1JliLhIl8FVHHPh0MBaQXnPVOLrdZ2tPrHtcDb3ixkhAtnPs4oz5RyJkVEz07
	 Ak6whvr/6QObIYD9Ox5YK27XO0FxkFOH6QGqtWqwKn25V5Hk5hSw8NQOaUhjAXQIZSYRW
	 WaczNxiC4UVudBtR7n3YLL8CDbfWTwyDuhiaKZxhXrCl5WavbFKkpA/miHGgsWLRCMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793694642;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=aBj+Li623i5XbMwFCjcnSkFl6GFgUM0A9oqrK/j4HHA=;
	b=ibSLrsLqz6bHNKHPTY5gvZq7ntSenTQzomsFGn/0mvdPe8LQH7hXwPjLKjPjtfvCRlVD
	 HS3BpxDUsVEHSlicfAaw67sLFepZdffKEp+KIec37vyunsJ+MqHhx5S2J2SJKOdraBF2L
	 IWxI0Ku/PWjwvWcpDOdYGyATRtZZwYcRPb4nNn6fa/EUNbpC7rzYrwwWR+yzavTaB+gNZ
	 +0H7YJuVMV3C+7AeHaVyPU5HiE7Er4ilwoMezatv1ubKPlHmFguCT3InUG99w6E63qqUI
	 fP87XEMaEbnzsgs1vdd2ezzij+7pMWlq6O9VfO5dbt3n8GTx4uV2Xh08bkc0zoyH3gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lzIB7FVY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6473A6082BD1;
	Tue,  3 Nov 2026 08:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lzIB7FVY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C9FF1F000C1;
	Tue,  3 Nov 2026 08:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793694642;
	bh=aBj+Li623i5XbMwFCjcnSkFl6GFgUM0A9oqrK/j4HHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lzIB7FVY3QjrUcAvFALOJMUtvszwTMJgIp5E1oJCaLPWfyUZ4CuchUw64FAjwjGg1
	 x29F5LIy0VDopicfjj20DeRevLRfAsl/hHezgxCBo1oMAUZaIts5Wo/tlfx8jDLCKQ
	 SznViouBjL9LY5I3SBI0BEQ0a43EnnFRkRdZlX2BO7FrPTy0qSyq40ayQsjiM0tna5
	 KK7N6sBjGNgL6zXU3KO59j4wMfEy1+dPzBHD5AU7MgWU3zTHAm29/oKHPKiyDE9Oxx
	 g7FtVxgz6IIk7gRLizrNCwbdS2u2pbbrlDb3RMqYbGrX5eRJfBexUJPkkJlQVSEkUT
	 sgzV5Eh4yOy+Q==
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
Subject: [PATCH v12 10/19] PCI/P2PDMA: Reject Translated Requests blocked by Translation Blocking
Date: Tue,  3 Nov 2026 10:29:49 +0200
Message-ID: <20261103-fix-p2p-acs-v4-0-v12-10-912101f93517@nvidia.com>
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

ACS Translation Blocking rejects upstream Memory Requests with a Translated
address before any peer-routing controls apply, per PCIe r7.0 sec 6.12.1.1.
P2PDMA ignores that bit and can report a route whose ports reject the
Requester's address type.

Add PCI_ACS_P2PDMA_BLOCKED and scan the ports traversed by each route. A
direct route passes only ports below the divergence; a host-bridge route
also passes the common port and its ancestors. Reject the affected class
without falling back to another route, and preserve blocking precedence
over internal-route restrictions.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c | 109 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 102 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 785e4668a2af..fc4dea28c860 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -559,11 +559,12 @@ enum pci_acs_p2pdma_state {
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
@@ -573,6 +574,18 @@ enum pci_acs_p2pdma_state {
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
@@ -678,6 +691,39 @@ pci_acs_p2pdma_no_upstream_forwarding(struct pci_dev *common)
 	return NULL;
 }
 
+/*
+ * Report whether any port between @client and @common rejects Translated
+ * addresses. If @common is NULL, every port up to the host bridge is walked.
+ * A port whose ACS Control cannot be read counts as blocking, which withdraws
+ * only the Translated classes because an Untranslated Request is routed by the
+ * redirect controls instead.
+ */
+static bool pci_p2pdma_path_blocks_translation(struct pci_dev *client,
+					       struct pci_dev *common)
+{
+	struct pci_dev *pdev;
+	u16 ctrl;
+
+	/*
+	 * @common is @client itself when the provider is the client or sits
+	 * below it. The Request never travels upstream then, so no port sees
+	 * it and none can reject its Address Type.
+	 */
+	if (client == common)
+		return false;
+
+	for (pdev = pci_upstream_bridge(client); pdev && pdev != common;
+	     pdev = pci_upstream_bridge(pdev)) {
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
@@ -744,6 +790,13 @@ static void pci_p2pdma_warn_redir(struct pci_dev *client,
  * @cpl_quirk:	A device quirk reports Completion Redirect at that port.
  * @req_upstream: The Requester has no internal route to its sibling.
  * @cpl_upstream: The Completer has no internal route to its sibling.
+ * @tb_on_path:	A port below the divergence blocks Translated addresses.
+ *		Every route out of @client passes those, so none carries them.
+ * @tb_above_divergence: A port at or above the divergence blocks Translated
+ *		addresses. Only a Request continuing to the host bridge passes
+ *		those, so a direct route is still open to them.
+ * @no_common_bridge: The two paths share no upstream bridge, so no direct
+ *		route exists for ACS to gate.
  * @unreadable:	First port whose ACS Control could not be read, if any.
  * @uf_blocked:	First shared port without usable Upstream Forwarding, if any.
  */
@@ -753,14 +806,28 @@ struct pci_p2pdma_acs_path {
 	bool cpl_quirk;
 	bool req_upstream;
 	bool cpl_upstream;
+	bool tb_on_path;
+	bool tb_above_divergence;
+	bool no_common_bridge;
 	struct pci_dev *unreadable;
 	struct pci_dev *uf_blocked;
 };
 
+/*
+ * ACS Translation Blocking is not a routing control, so unlike the redirect
+ * controls it is not decided at the divergence alone. PCIe r7.0 sec 6.12.1.1
+ * has every Downstream Port check the Address Type of each Upstream Memory
+ * Request it receives, ahead of "any applicable ACS P2P control mechanisms".
+ * A port below the divergence cannot redirect the Request anywhere it was not
+ * already going, but it can still reject a Translated address.
+ */
 static enum pci_acs_p2pdma_state
 pci_p2pdma_request_state(const struct pci_p2pdma_acs_path *path,
 			 unsigned int tlp_flags)
 {
+	if (tlp_flags & PCI_P2PDMA_TLP_TRANSLATED && path->tb_on_path)
+		return PCI_ACS_P2PDMA_BLOCKED;
+
 	if (path->req_upstream)
 		return PCI_ACS_P2PDMA_REDIRECT;
 
@@ -791,11 +858,23 @@ static enum pci_p2pdma_map_type
 pci_p2pdma_route(const struct pci_p2pdma_acs_path *path,
 		 unsigned int tlp_flags)
 {
+	enum pci_acs_p2pdma_state req;
+
 	if (path->unreadable)
 		return PCI_P2PDMA_MAP_NOT_SUPPORTED;
 
-	if (pci_p2pdma_request_state(path, tlp_flags) ==
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
+	if (!path->no_common_bridge && req == PCI_ACS_P2PDMA_DIRECT &&
 	    pci_p2pdma_completion_state(path, tlp_flags) ==
 		    PCI_ACS_P2PDMA_DIRECT)
 		return PCI_P2PDMA_MAP_BUS_ADDR;
@@ -803,6 +882,14 @@ pci_p2pdma_route(const struct pci_p2pdma_acs_path *path,
 	if (path->uf_blocked)
 		return PCI_P2PDMA_MAP_NOT_SUPPORTED;
 
+	/*
+	 * A Request that turns around at the divergence never reaches the
+	 * ports above it, but one that keeps climbing to the host bridge
+	 * does, so that route has to clear their Translation Blocking too.
+	 */
+	if (tlp_flags & PCI_P2PDMA_TLP_TRANSLATED && path->tb_above_divergence)
+		return PCI_P2PDMA_MAP_NOT_SUPPORTED;
+
 	return PCI_P2PDMA_MAP_THRU_HOST_BRIDGE;
 }
 
@@ -1066,7 +1153,8 @@ pci_p2pdma_map_types_unpack(unsigned long val, unsigned int tlp_flags)
  * The client is the Requester and the provider the Completer. At the path
  * divergence, check Request Redirect and Egress Control on the Requester-side
  * port, and Completion Redirect for read Completions on the Completer-side
- * port.
+ * port. Translation Blocking is checked on every port the Request passes
+ * instead, because it rejects a Request rather than routing it.
  *
  * Those controls apply to different TLPs, so every class named by &enum
  * pci_p2pdma_tlp_flags is decided from the one walk and cached together;
@@ -1074,8 +1162,8 @@ pci_p2pdma_map_types_unpack(unsigned long val, unsigned int tlp_flags)
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
@@ -1128,8 +1216,10 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 	 * request can only get to the peer through the host bridge.
 	 */
 	*dist = dist_a + dist_b;
+	path.no_common_bridge = true;
+	path.tb_on_path = pci_p2pdma_path_blocks_translation(client, NULL);
 	for (flags = 0; flags < PCI_P2PDMA_TLP_CLASSES; flags++)
-		map_type[flags] = PCI_P2PDMA_MAP_THRU_HOST_BRIDGE;
+		map_type[flags] = pci_p2pdma_route(&path, flags);
 	goto map_through_host_bridge;
 
 check_paths_acs:
@@ -1162,6 +1252,11 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 		}
 	}
 
+	path.tb_on_path = pci_p2pdma_path_blocks_translation(client, a);
+	if (b_child)
+		path.tb_above_divergence =
+			pci_p2pdma_path_blocks_translation(b_child, NULL);
+
 	/*
 	 * The walk and the config reads above serve every class; only the
 	 * decision below depends on the kind of TLP being routed.

-- 
2.56.0

