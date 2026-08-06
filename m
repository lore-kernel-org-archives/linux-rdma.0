Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D837544E65F;
	Thu,  6 Aug 2026 11:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786016076; cv=none; b=eOf7rJH+bxlmq7VkO/79bnZNB/thEYYQ/8vm8GxDFtCLlyGZFdFj8jVvecN99wRzjGOH7BxcGDZ8ghtQLqJW/6obYPGUVGgF+z/b5iyj+pSNZQOhP2tkvQO3bpnh9ciRf9RAMVfrrnUzjouk9/ckDbhZXWelzQnCWHLjH0uavDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786016076; c=relaxed/simple;
	bh=ay8j/3IOwqwVVELuAcUshCc86uiFXZxrNNMg16qAHoA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Rp0SfWp6iwTlJEsGKmrwnsArsh7xaMr1dfL2iCq57LZwrxdSKS9aDf+C4lZXhkFR8wS/3fB6dpNTKP8dkPXpgweODW5TYK/CYlAEW4prUCe6t4Zgi+3Py3dLiNFujhhXYnlhWTI+Avzz8Gg7duddrkh7LEMFmnlsyK7mW8mLUtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C68B21F000E9;
	Thu,  6 Aug 2026 11:34:33 +0000 (UTC)
From: Leon Romanovsky <leonro@nvidia.com>
To: Cheng Xu <chengyou@linux.alibaba.com>, 
 Kai Shen <kaishen@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260806-missing-endianness-conversion-for-64-v1-1-896327c1aff1@nvidia.com>
References: <20260806-missing-endianness-conversion-for-64-v1-1-896327c1aff1@nvidia.com>
Subject: Re: [PATCH rdma-next] RDMA/erdma: restrict the driver to
 little-endian systems
Message-Id: <178601607144.523410.1759876990282209997.b4-ty@nvidia.com>
Date: Thu, 06 Aug 2026 07:34:31 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 06 Aug 2026 11:48:56 +0300, Leon Romanovsky wrote:
> The eRDMA device interface requires explicit byte ordering, but several
> DMA-visible values that should be little-endian remain native-endian.
> Command request payloads are copied verbatim, data-path SQE headers are
> written without cpu_to_le64(), and kernel doorbell records are assigned
> plain u64 values. The command completion path also reads a little-endian
> SQE header without conversion.
> 
> [...]

Applied, thanks!

[1/1] RDMA/erdma: restrict the driver to little-endian systems
      https://git.kernel.org/rdma/rdma/c/a12d9145145b21

Best regards,
-- 
Leon Romanovsky <leonro@nvidia.com>

