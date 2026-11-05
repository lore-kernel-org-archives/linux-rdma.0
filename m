Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793873200;
	b=PCSNecRY/vVtIH/S4hlci6Tkj1y3J4KLaho9bQXAD2k2dUn0LIMyf/j1ng1/dOUpkn8b
	 BSYuKkYvoH3QCyn6ujZZAWYtNu886lZ6C49YTqdThxNJXmBrifWM4b+wSB063k/D/b2i6
	 1t0GtiBu25daf1qxaPAo0Z2s+EpCAyft0MIhjOgaIY4PZ2agGqHBT3vKrcRF5HO1GWpXV
	 pxQQuWzQTg1o9pdPBEpz0BHvBvBup27DDr3gwzPB9S8R8l10+TBLwmPQaHmxa/gLW+IDb
	 jnxvG6YNou4UXTJSZIKWzqAIM1DPPK9HJ0wf16DTq2Oz1ASMbgkCd70BsT+AX8hEmLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793873200;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=LaYzpsCCRr6dDFFy5lOeqh2YQbctkAJ2fuKMyjsC5Y0=;
	b=ncRbvsDV6WE8CenN3D1izrz0zcTev4QWNI7ueLw8Bmr8L5j73G3ACj6LYUw1F4KSNtNT
	 fa4Hc126AcJdLK+Z/q/ImK8Stwl8i6TKZmYLxUGT41J3J26YJMsBUft8V8fhyOC6WILE4
	 F8wVu80i9+rFMnrXGvDyWQHp5pS/XYB1fc2knAu+XxkFM+uyMwQHQ+g/p7hrgw5z9+Vmd
	 ES8IfYLTGbukh99bEEOdhZvpYgGI+lQaI8dtSZBEXfpm+OkcNmdJkWzt3rAI4ggn6mvfR
	 lzyVBrS/ommiA26oKOUssv1YefFQfHG3Q4ImS4vx+iNce/M0n6zAu1z1ykO8GCxiaeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Lm1phVRU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16DE360A6F61;
	Thu,  5 Nov 2026 10:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Lm1phVRU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F82C1F00919;
	Thu,  5 Nov 2026 10:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793873199;
	bh=LaYzpsCCRr6dDFFy5lOeqh2YQbctkAJ2fuKMyjsC5Y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lm1phVRUMdcLIgqXobpIYJmxQFRCFPJBIxkQWU2c+A+ateH1VjMkpPru0+pjWxOPY
	 VA7KKe9f2OfgCTfrjA3BpaZL5FmMSEvnmcpH+yqVs71Cz9p8IA/U+HX7Xv79In1Sr4
	 x7GLxmRHe6+IWNboG+V6Vt8peeu/22k06+Nqir8E0CEvgnmXOBFXLEnwUxdrz2IiWm
	 f38AlhwHbZBqFr1jm0m1EqzZgD/8ocACIdapH1LPzCy0SFAYbwcDCVQIp2xPRJAQRN
	 IlVwgFUks2VkX2kjoBseV2kX0p47rvd9ny3m9zhz02exu3bpqwRELkXLm9RQjJT2YK
	 rXDhVTi9vbe2A==
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
Subject: [PATCH v13 11/19] PCI/P2PDMA: Route Translated Requests under Direct Translated P2P
Date: Thu,  5 Nov 2026 12:04:42 +0200
Message-ID: <20261105-fix-p2p-acs-v4-0-v13-11-3dd065907c3b@nvidia.com>
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
index 0203ef86fa86a..f4ef51e10d79c 100644
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
@@ -1162,10 +1171,11 @@ pci_p2pdma_map_types_unpack(unsigned long val, unsigned int tlp_flags)
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

