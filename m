Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640D23290C9
	for <linux-rdma@vger.kernel.org>; Mon, 27 Jul 2026 11:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785152987; cv=none; b=CVFuFUYeVJ47KBCG0e+tAxUp3ehfJdLnSdtmjAaKr4GbOJ8pkBDNyrxKjF0MrHGeviFDA50Iwn6ePK8nZqu6hNyd83hJec/rk67ISnEn+hIcGMAGnQe+oDh0EASJyb1R7vv+MDgWhrUWhRzg8fJ1zKvr7ltW/MsQWvMZsSYc7yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785152987; c=relaxed/simple;
	bh=OxQ+g//RPDhYfJmE3+BL9d/lAQ1JPMMeTurJ2p6vD5s=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=XDk7DovU1y7pGgWl3S/bQpTT8q/2ewrrQOiuupZbuB/DEKnLR12mLocDLWHCcmKVN9V/x1wUNncTkov9urDNPGkPIOAzIJ/4TBln1qaaP60X1KMwFNBZ1/lerHJ1V543iIN2WQ/ichCXgzEpKDDE14lq+tWKazBW1ol03KgiXRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F+W4OGmP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F+W4OGmP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC361F000E9;
	Mon, 27 Jul 2026 11:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785152986;
	bh=iw1Qh1LZNX0CBppO8K3x4xQeVhLm1bKAyvg6gYhuvus=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=F+W4OGmPfmvbzilV2QdMG/kwfLY4qOsH6PCApekw+vEwHfjmXSiUP6/gNc6jhEOer
	 osUQhwBUlPHbj6ipDK/E1IPB4u15KptWpRKit8ACSpDKFL06DSUUK9GSUxNLM7lvXU
	 b6IfV3HSYPHy9E3dEcJ/SxoDTGDNIWpIl+SVIkjHzd+ynzYWZ5JUpNxx7cyO6qcwcn
	 EI4vLHMIwj3+uZ/25EiAVUD56TX47Qmm4XKe39XHuenEjGyB2ZOIYJzZQFT4+F/kRF
	 nzFa7JHVRt0C7ppfp/KX4xVaEpuqU+uGhzLGKmzMREP1L5R8EzQmbKV8CM5FpDRUZr
	 6D211c7xcEbMQ==
From: Leon Romanovsky <leon@kernel.org>
To: linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, 
 Yonatan Nachum <ynachum@amazon.com>
Cc: mrgolin@amazon.com, sleybo@amazon.com, matua@amazon.com, 
 gal.pressman@linux.dev, Firas Jahjah <firasj@amazon.com>
In-Reply-To: <20260727090255.1175120-1-ynachum@amazon.com>
References: <20260727090255.1175120-1-ynachum@amazon.com>
Subject: Re: [PATCH for-rc] RDMA/efa: Fix PBL chunk length computation
Message-Id: <178515298300.694655.3812170065175191102.b4-ty@kernel.org>
Date: Mon, 27 Jul 2026 07:49:43 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 27 Jul 2026 09:02:55 +0000, Yonatan Nachum wrote:
> On register MR, when creating the PBL, if it's an indirect PBL we create
> a chunk list to hold the PBL pages pointers. Each chunk is 4KB in size
> and can hold 510 addresses (EFA_PTRS_PER_CHUNK) and has a 12-byte
> control buffer at the end of it holding the next chunk's pointer and its
> length.
> 
> If the PBL number of pages is a multiple of EFA_PTRS_PER_CHUNK, the
> calculated last chunk length is wrongly computed as 0, even though that
> chunk is fully populated with 510 real page pointers. This wrong length
> is used both to DMA map the chunk and is propagated to the device,
> causing the device to see the chunk as empty and reject the memory
> registration.
> 
> [...]

Applied, thanks!

[1/1] RDMA/efa: Fix PBL chunk length computation
      https://git.kernel.org/rdma/rdma/c/983c450ae26317

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

