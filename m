Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793694646;
	b=GyWYXY14jlb3oifmssrXz1T+5ateqKlEm3/8HTkYGpElUi2NU3tey2iU0CXbhZgxjHEB
	 aA3QoS7oCTeVYARL9MrEMtl9FKotHnL54NAeCZVFZ/EUggde5Ka31e1o1QNB/6li8CK+L
	 23rpmREnjzuCNPCLRqTNe+OidN/Sm6sPGKt+TbCBGT13+K/91XzqBBj9UD9+wMnNba5G5
	 AqNkNRDfpTd56x9wRYpZgwLnW3oUuLldPru/ieJbOaLRYKoIjMe4nDCAbxexZwrs2k6uP
	 hdK3Vn8GDdjEOXauWhYmMKgZLAdtzqTHD9i/F5mNRcKZOo/edO8f15Kw8gDj+z4pEag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793694646;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=oRmwUA9XXbjp75BqaqH2h4hUwz1vYNNk0QA5dlorz3M=;
	b=m0VldcYFC4umwM+DrdCFmZfUbaY32wRPFjLDT22oXT5rGeWZYHxsgoZZgXiItytpgDOJ
	 yoT4c209jNJKp/XgvG+1JI17gZ9EgxbtgoIa3uI3HxwhrbTE8qVY6zuT4NoZoAg6pRtBO
	 gntMrq/FVNgupmYyFr/3HS9dIFwcfkMimEBeW1s4Hb0HszEC4vOSG9A2bvws+EoOdEKQr
	 w7EUsKXCy3RE+9tL0cmdpeeorpWF3orJpFz3p0k0PGR1CBJOMUsRHu/3q/kiIo1eRNGic
	 JW9joFiRrlqTOuA34EYefmnR99q4tRfcHqKV4q6lpmv1W8bTYnf07UQj3zfQyDWpLkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l558BARe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32AE6082BC7;
	Tue,  3 Nov 2026 08:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l558BARe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D7E1F000C1;
	Tue,  3 Nov 2026 08:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793694645;
	bh=oRmwUA9XXbjp75BqaqH2h4hUwz1vYNNk0QA5dlorz3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l558BAReY4j9d1+7TD7jQTIiglHmXadNMaP12xGgKQw/j18LdQAcwN+6X0SZV9zYX
	 SLpPxd+9aMfLlykAGqZRns+5eZWxr1XMJOtt1AB3Y3WhHSEUUaoKxq+inINCU7m4lT
	 vU7svRzJz0BoUL9Z0L7Y2oUgqCntUPd54mFBzu21gDowhroZtUhnALpZ86RLgFfQtb
	 V1WwcxeZqlClAotiqPiQoIqguXeQ8sEh6iX4rzFTUl9diZG7kvnBFQT7lIonj2VC84
	 3P0jDt0d2DRL/LgT3q9Rj2M9CRGfz9jjbnmGzVbWR2Aj3NO+hhzESdCfi9m/IAR6Ey
	 iSMSXYMFzcAmg==
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
Subject: [PATCH v12 11/19] PCI/P2PDMA: Route Translated Requests under Direct Translated P2P
Date: Tue,  3 Nov 2026 10:29:50 +0200
Message-ID: <20261103-fix-p2p-acs-v4-0-v12-11-912101f93517@nvidia.com>
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

A Downstream Port with ACS Direct Translated P2P enabled routes a Request
whose Address Type is Translated "to the peer Egress Port without
redirection, regardless of ACS P2P Request Redirect and ACS P2P Egress
Control", per PCIe r7.0 sec 6.12.3. P2PDMA assumes every Request carries an
Untranslated address, so it sends an ATS client through the host bridge
even where the fabric would route it straight to the peer.

Consult Direct Translated P2P for the PCI_P2PDMA_TLP_TRANSLATED classes.

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Tested-by: Tushar Dave <tdave@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index fc4dea28c860..600c3ef7a36a 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -584,6 +584,15 @@ pci_acs_p2pdma_request(u16 ctrl, unsigned int tlp_flags)
 		 */
 		if (ctrl & PCI_ACS_TB)
 			return PCI_ACS_P2PDMA_BLOCKED;
+
+		/*
+		 * PCIe r7.0 sec 6.12.3: ACS Direct Translated P2P routes a
+		 * Request carrying a Translated address to the peer "without
+		 * redirection, regardless of ACS P2P Request Redirect and ACS
+		 * P2P Egress Control settings".
+		 */
+		if (ctrl & PCI_ACS_DT)
+			return PCI_ACS_P2PDMA_DIRECT;
 	}
 
 	return ctrl & (PCI_ACS_RR | PCI_ACS_EC) ?
@@ -1151,10 +1160,11 @@ pci_p2pdma_map_types_unpack(unsigned long val, unsigned int tlp_flags)
  * redirection setting of the ports along the path.
  *
  * The client is the Requester and the provider the Completer. At the path
- * divergence, check Request Redirect and Egress Control on the Requester-side
- * port, and Completion Redirect for read Completions on the Completer-side
- * port. Translation Blocking is checked on every port the Request passes
- * instead, because it rejects a Request rather than routing it.
+ * divergence, check Request Redirect, Egress Control and Direct Translated
+ * P2P on the Requester-side port, and Completion Redirect for read
+ * Completions on the Completer-side port. Translation Blocking is checked on
+ * every port the Request passes instead, because it rejects a Request rather
+ * than routing it.
  *
  * Those controls apply to different TLPs, so every class named by &enum
  * pci_p2pdma_tlp_flags is decided from the one walk and cached together;

-- 
2.56.0

