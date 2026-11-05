Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793873153;
	b=KUAFSp0NEG5gp17iAeixTUs7fR1fbqZqElJ1is78P97AlaVLabhYSmnZWx6XOjPMpS7j
	 2twybidKInD7wvjdOKuhZyvcA3fg3KiynahlsUpLIY0TY8lrmfQKLdXV225+dED1Ti39x
	 d233dzDTWPqJy9glwAf2ghSQBya9ji0EjiQOUiBVgHi6pdraXoxCJLSpyEdI8HfjIvcIa
	 QNueyKeuZ/dspOFCmASNKWhsnbMfSWSI0SoSXlwUZYl6Zw7u6l5LtOXM8ikxAHxhsWhed
	 EJVmjlVuypkt+Q0MJdu1ar6foN7x53S0iO/ZQjLFc6xdzRNLuXCUH7CMwdNslKAxM4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793873153;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=25Frt+H276lFJ+KBFYHELlRzdA9/mrN4tKVOcT+Qa/k=;
	b=5DuF/OIFPE8xGbX/wd0LtpXOOV4HQRnWdeIn6FmafNlbUPRFttuG8edlUOJ3N/XZM/9K
	 mwDqqn7Vsv015rBzynz08hatzvSpZulzKKhs6wvB3jgH6ykafNMszLqwrIRxuV12jfgTr
	 dUKswrkcEUssc6PtdgmzcOhpWqxXeF59JpNmeNaXiJ7WMvOuJB1j830HUkDw5NDgXmOsw
	 0bbW7g3zOuMtagBYGiXgIZLWWV6LmhIsJYCguXWUxijEPDVKkwsZnGXrw3JYxOzyO69z4
	 rpCzxplcMgOo2mTLcxBJEFGm6PHMXmOx9YTHMXbG898WrT2JlLfLN0BMKi6RrOTWlqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PcAYERAA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001F4606A328;
	Thu,  5 Nov 2026 10:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PcAYERAA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA6631F000C1;
	Thu,  5 Nov 2026 10:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793873152;
	bh=25Frt+H276lFJ+KBFYHELlRzdA9/mrN4tKVOcT+Qa/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PcAYERAAHI+6+kqEJ5GpcBuWGHAyD08xO/P9aeb+ERaEIGpCFnXEibh+AGp7BUlCT
	 Y1ewrvGs0IoXEohjZGtXCSFQva5McHUssmnP/2tje4FQoCizlRbLidxLdNqt3r9oVc
	 JfrM991JD/7L5MIyybj/2LkQuwUsQhgkUmkgFHlxLiIifM94dELJt4xsZL1Rs7D35e
	 XWJ3lFN+0ec8CtfS0hPpN8QCgom2HlrJaRVwCC3v5gNpehamA0OWeHbouNFqWyrRGY
	 4041ctgzKXAzwSyk4lSmpL7S3LiaUYkX1j1gGTWT96lwT5u1t7tPJmZPGvovFthVSy
	 ECR4PRweR+k4g==
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
Subject: [PATCH v13 02/19] PCI/P2PDMA: Document the TLP attribute assumptions
Date: Thu,  5 Nov 2026 12:04:33 +0200
Message-ID: <20261105-fix-p2p-acs-v4-0-v13-2-3dd065907c3b@nvidia.com>
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
index 63cff9e4d2c9a..80f8fec9b0e90 100644
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

