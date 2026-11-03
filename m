Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793694613;
	b=fm3vwPIiAsM3cAffPLyt1DuhtVJHKO9thAlamtmjIUMth8gXdn6wZ1UNWS/YHL5n/2j4
	 RDBqKOB8hQrRQaTfiNjlntvyN3kNiH82+JPPmVu4MjGLha0zk+gvJ/aSZ+SoQflr2nSOi
	 TcgDCWgv4XBICtor19iuNIr12EFF7pbkWdUHYgsp/VvTfEXvuJ28q/cLRyyNf65totIEL
	 2BtKKLh8/iOt99E1W5rsAXa5+otb9MUls0G9bdCqnEJqZ2+e7bCjkYq9BglXJKWkUyS9C
	 P0qoKLWa76E5FgGHTgB4yGNOGDHojPem2/+cvCo1LLKew6Br7CWECHaVCy/ZtsCvlWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793694613;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=jMsCflS36xjM5xM77gmQxJkejXiZCOlxvrxpfrVWc+Y=;
	b=VCvxabUrjUmHMePj9ftlVnr/V4y27s3nG3a2lmHhhvSO+vnKhi7e1MpJEPwxHZe8II3o
	 DM0VniqfyQV0eWfhebv+aCH0c4nvonDEBrXJOzC5P+zQcY1byDPHtemcc6uOkctPb8OGZ
	 wge+pGfGFNOdTUmCWRGnZlaOzz0G4H53B/IV13JmUGxFzHsnaIkTVXbZlpdhKPxLlIV39
	 XiM5Hyh0R3b3D8h0NGbR7TgUW/H5BDgcao7Fu77MUtLIPl2gfbAq/964NzxJ3CFdpBgcl
	 v4jL+l2MbzEGwh7Z/Yx3OApzg9LC9gtLSntBkZtxX1uV+83za9KOenVCI4LB+I5jsng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A5dxzOoN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC429606EE95;
	Tue,  3 Nov 2026 08:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A5dxzOoN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDC021F00A23;
	Tue,  3 Nov 2026 08:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793694612;
	bh=jMsCflS36xjM5xM77gmQxJkejXiZCOlxvrxpfrVWc+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A5dxzOoNkDrW4pNqVVyZoklt9Azfg+rSlnLM4mi3BebvkCaa++F/7TpjYlr5zu8wy
	 4yDD9HfFhTwRuQ0eI0YVHiBgutbM9gl7+BpiJGKoDjUmx0Qh4+3hUkGhTMZigaVRAj
	 FGz1gAGtbH6SL8KlkVBpzELQqjEAbyBJ+yEaL6UPWLkvk1rnxyKpHitCPg7rU6LpM4
	 U5/XE9JUJh/38SEUypc8pmzSmAG5aixgcrLNvM4qkWWIVZxHDvvcn3icojD1C4n6n4
	 SIaWmfGIIrE7TQ8Rv5n12j6VtykfdpxzYYfC3OwRfvoeKfTn33lMic2wRCr7yPaOFQ
	 eZYtkej6XWYFA==
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
Subject: [PATCH v12 02/19] PCI/P2PDMA: Document the TLP attribute assumptions
Date: Tue,  3 Nov 2026 10:29:41 +0200
Message-ID: <20261103-fix-p2p-acs-v4-0-v12-2-912101f93517@nvidia.com>
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

P2PDMA selects a mapping without receiving the Request's ordering or
Address Type attributes. Its ACS handles only strictly ordered Requests
carrying an Untranslated address.

Document that the result is not defined for Relaxed Ordering or
ATS-translated Requests because those TLP attributes can select different
routes through the fabric.

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Tested-by: Tushar Dave <tdave@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 Documentation/driver-api/pci/p2pdma.rst | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/driver-api/pci/p2pdma.rst b/Documentation/driver-api/pci/p2pdma.rst
index 63cff9e4d2c9..80f8fec9b0e9 100644
--- a/Documentation/driver-api/pci/p2pdma.rst
+++ b/Documentation/driver-api/pci/p2pdma.rst
@@ -15,6 +15,13 @@ then based on the ACS settings the transaction can route entirely within
 the PCIe hierarchy and never reach the root port. The kernel will evaluate
 the PCIe topology and always permit P2P in these well-defined cases.
 
+This evaluation assumes clients issue strictly ordered Requests carrying an
+Untranslated address. Its result is not defined when clients use Relaxed
+Ordering or issue ATS-translated Requests because those TLP attributes can
+select different routes through the fabric. Unless ACS Translation Blocking
+is enabled, a Port with ACS Direct Translated P2P enabled routes a
+Translated Request directly to the peer regardless of the redirect controls.
+
 However, if the P2P transaction reaches the host bridge then it might have to
 hairpin back out the same root port, be routed inside the CPU SOC to another
 PCIe root port, or routed internally to the SOC.

-- 
2.56.0

