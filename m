Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793698931;
	b=tLaZDFeLVP0b06Ip6G/flEYxudPsfB7pUNoRPWQExqgzwopQ/iNDx0F460XhJOEyrDbR
	 F/w0tiMCajpr0K7ouOqf6j9BQx2xzM5WG73xrhmaZLU32jPEc4hjXE3Ldvji9S1+WgqUV
	 xbt7VNfm1F8BetrR3SY3ynlHoLZ0gtOZrKkZ8aeM6KgoaEpXHKtdjoGyKbBKp07bRoQfd
	 hMvuAA+snfoQwRs5ftQyWgzA/loenSAyqRP3mzmYbAOFMvUxHmK6tBBFggZXCkg3C/HYe
	 MxLjAhbd+Ne23XhWr1df/8DPnnLAEMdZdsW6bMyCp/3VH1nSzBkYlx++QREFPRqqr2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793698931;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Type:X-Change-ID:X-Mailer:
	 Content-Transfer-Encoding;
	bh=Q6huOVjpXzdiG1Dm5N7Lgt8ABR0hut+OKCrUTExPU9s=;
	b=yqTP8cznEFTxDasNFBZW2ozfWongjzcPS9x5MjL+KhVLCSA92Ih0zu1+h5LNPfzBVV/U
	 IUn+W+7wO1UHzJLuQZIiuQXRiUdQSpMDoHPnf0P9OG1YS3T0a5fGBZVGhbqygdp7C85V6
	 AIVesh8xxsySEkiym+xn7sJSXVZpBubscOTXJe6EB5tD//GwCCnzYdOVizEa0aJ06Y/mO
	 rYR7rq9Qw6qw2pXlK1aR9ED/gzfjTrZqvg+SAJSZvQIAkX0483kwC9tIjv5vkBi3mwBxU
	 L63tovqcyjhVOg3/JKyK8HwsGTS4IU90fWbSllVE58D3QraPyhB/2ZFT3+AfqiL0+0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fCd0Sk78;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9590606A324;
	Tue,  3 Nov 2026 09:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fCd0Sk78
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7EAF1F000C1;
	Tue,  3 Nov 2026 09:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793698930;
	bh=Q6huOVjpXzdiG1Dm5N7Lgt8ABR0hut+OKCrUTExPU9s=;
	h=From:To:Cc:Subject:Date;
	b=fCd0Sk78HqgFqmvbyeae6YrEZHkSwDEKDHGFPDuhPBDAX+7Fcp+rN3P37gMauJUSp
	 /W+L9EkED9Dks2O5rADGqRWWgYi4aF1X6NreCsSYpfJW5IIZbHzBVqGSvj6s+jH1me
	 PT2J+aLgRT9jY0QkFgizBWm2ajlhucadikkQwdImFNuF/O6teV4ARYY7C/Xr6oXST+
	 iuNT3U/LKuQUfzvHr850Nw5hW6E0X7KwRZFxv721IrLqqOCrRSb8w30arKKDn4a/BJ
	 ubgzRIrzahegYDqFXN0yQpJglD864dnqHHgjOaxSLOtt1Z1Lwb1cHqf8p69sVPMO19
	 uFtkWuORl/OEQ==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-rc 0/4] RDMA: Clean up the MAINTAINERS file
Date: Tue,  3 Nov 2026 11:41:56 +0200
Message-ID: <20261103-rdma-branches-v1-0-763c07cc14aa@nvidia.com>
X-Mailer: git-send-email 2.56.0
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
X-Change-ID: 20261101-rdma-branches-9cebcd4601f0
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

Clean up the RDMA-related sections of the MAINTAINERS file.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
Leon Romanovsky (4):
      RDMA: Rely on the generic Patchwork instance
      RDMA: Add missing UAPI files
      RDMA: Clean up the INFINIBAND subsystem entry
      RDMA: Remove pointless links

 MAINTAINERS | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261101-rdma-branches-9cebcd4601f0

Best regards,
--  
Leon Romanovsky <leonro@nvidia.com>

