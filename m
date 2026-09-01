Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4166E64;
	Tue,  1 Sep 2026 13:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788269927; cv=none; b=iDlgJllUyzbXgkdu4EWVUVvtuhi8kE7fyWGvSKM5PZ/qSwn0rhFuuYqxFzTh1h/BM3f3rVmOnNskWs0D9U59Fxa04/Ud9KWhUpfzt6Xuc9JaxrsdFnBc3Ty+CxKEj6FksrYazZlHHbPRpJPKqHEHFFX9kGqLBkxM2jMqrx+iYoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788269927; c=relaxed/simple;
	bh=wnEx4rDNkziZBTzK4aZ7qaCWiw57NIRKirHCSXvWtSg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=s7t+dLbhGaaMLGtKRYDgDvDmNAnGp6GtukmXcpSSxbiPw0u6Im2/rKMn/TiT+MmCGMPahHrJAEWU0znt3hfmvXcaHmET2WV6aHxiJmZqxYNjm4LaJ8VRbncqidAMJWjGJzh13vwpLfKsmKHgJL7dbioW1bXvPRziq7SQC9+op9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E1KlXXTu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E1KlXXTu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BAFE1F00A3D;
	Tue,  1 Sep 2026 13:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788269926;
	bh=jCOmXUqUA0JFX/6v0B8YEvtU3s0Uus/ZFSIva0GOO3M=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=E1KlXXTuq1zN2r8vbLV2O20CQIu/+R49FhOl8Dw9a0dt/DMvSS4fA1N47wOoD+sNm
	 pMM08fhmeXJ10nVpNqXTJ9EC8p7K1sMFiHWr3+cIS8GbshzD8FuuvTfPR3ZOI7hgqf
	 MslrySwSwfJWC9iARh0NmPk3YS24WkMIwHz/pV0od4Ay13LW2CFX/bPmGRXb8JNuc6
	 QSY3vciEulvqMp5RM5XGHaeqjMBf8tB4GmHwSCQIbYCG9mGgDRFKhgc3HEEkGvCBaN
	 B9zg7nYZpoBlqClPdkr/fJghBaf/eHtyfgHHZVlMB25+BMBuQqe23gt42HQhdgH0Ry
	 qYRcGRK2VqbKw==
From: Leon Romanovsky <leon@kernel.org>
To: linux-rdma@vger.kernel.org, Ruizhe Zhou <zhouruizhe@resnics.com>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org
In-Reply-To: <20260812033647.2281547-1-zhouruizhe@resnics.com>
References: <20260812033647.2281547-1-zhouruizhe@resnics.com>
Subject: Re: [PATCH 0/2] RDMA: Remove obsolete 32-bit DMA mask fallbacks
Message-Id: <178826992328.1353295.521040898136090856.b4-ty@kernel.org>
Date: Tue, 01 Sep 2026 09:38:43 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 12 Aug 2026 11:36:45 +0800, Ruizhe Zhou wrote:
> hfi1 and mlx5 data direct both set a 64-bit DMA mask and retry with a
> 32-bit mask if the first call fails. This treats the return value of
> dma_set_mask_and_coherent() as an indication that the platform requires
> a narrower DMA width.
> 
> That is not a correct interpretation of dma_set_mask_and_coherent().
> The mask describes the DMA addresses the device can accept and constrains
> subsequent mappings to that range. A 64-bit mask includes every address
> permitted by a 32-bit mask, including addresses from a platform that only
> produces 32-bit DMA addresses. Retrying with 32 bits therefore adds a stricter
> constraint and cannot correct a failure to establish the 64-bit mask.
> The DMA API HOWTO explicitly calls this fallback pattern incorrect [1].
> See [2] and [3] for details.
> 
> [...]

Applied, thanks!

[1/2] RDMA/hfi1: Remove obsolete 32-bit DMA mask fallback
      https://git.kernel.org/rdma/rdma/c/901c15a2099d43
[2/2] RDMA/mlx5: Remove obsolete 32-bit DMA mask fallback
      https://git.kernel.org/rdma/rdma/c/08a978db86e877

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

