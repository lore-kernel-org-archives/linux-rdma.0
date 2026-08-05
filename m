Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE25389114
	for <linux-rdma@vger.kernel.org>; Wed,  5 Aug 2026 14:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785940624; cv=none; b=hLazJ7sYTEGXWqmxl22pklsdEbBmqatTH7suhOqGsYGG+KtB9BBE6fT5g4eU7z8lurlhE4foyffoInFSjo0LzrJ3Seo1cnt3cnZa8m54s9iB+TFQ7//pR8ZT8KErjgenW4lSW9XJDL6p0Qs3UKz8Aa8MHYWl3PlL2ZqLOd72DN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785940624; c=relaxed/simple;
	bh=BD+8KnA5BZyOtahL2bpnQME1e0z7Lkyr4d+qHN4wp04=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=AqLgUFL2X54xU6N7sqbriI54BfrPJUY9sat1WMzJCU9ybeJz50IxfTl8Y9AZTDuJQ0aoyYqBSMW5TaPj97qhofZ3iYwA8rF3EbcXkxt5ONaTJaME86oviHRyA67oFHq6YQCN3Ts8tjmIvPSOV6nfGuf2dJajZTKDG4aUFj+60bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YEKHWABr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YEKHWABr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 122D11F00A3F;
	Wed,  5 Aug 2026 14:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785940616;
	bh=reCtzq/MsuQ76L79y0eW72jp+YuH4HeclNhKgWE/kgQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=YEKHWABrLXSPRjDmy9nsAXBeh+0tbogVI0WnWSvgHCERofoMTNz0KPyuQljvLNxy4
	 3pwNlT+DgQVZSEbYDIUIxMbOOnRyTQ6GsO0ADwA/rdDl7M6vsP8HgkUJ+jQVJe8Hvy
	 yLow860Ed5mx2Phm7rNVIolvoMz+edqYnBQANzn8BRmg543Ft7mAyQt0asUuhBS3Bm
	 WsC7usw4T7TD+2vvSkH/BaZ2bN7cpSwDG9MO5jLepoJ05nZinrxe5PLDYZ+Uf2ZVXJ
	 rlPF1orpy3WEoIEmf+BL+4zNz7UXSjHja6S1A+Op12XvZxoUv9GrKWEv0jmUQZIFYf
	 R2coehLyh3dIA==
From: Leon Romanovsky <leon@kernel.org>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, 
 Jacob Moroni <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260728141501.1425737-1-jmoroni@google.com>
References: <20260728141501.1425737-1-jmoroni@google.com>
Subject: Re: [PATCH rdma-next 1/2] RDMA/core: Prevent rereg_mr for dmabuf
 umems
Message-Id: <178594061374.4130143.14955655427689493937.b4-ty@kernel.org>
Date: Wed, 05 Aug 2026 10:36:53 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Tue, 28 Jul 2026 14:15:00 +0000, Jacob Moroni wrote:
> The rereg_mr method has always been explicitly blocked in
> rdma-core for dmabuf MRs anyway, so add a check to the
> ib_umem_check_rereg helper so that each driver doesn't need
> to handle it.
> 
> Depending on how the driver handled rereg_mr, this also
> has the benefit of preventing rereg_mr from being used
> to add the IB_ACCESS_MW_BIND flag to a dmabuf MR. This
> flag is not allowed during registration, so it seems
> sensible to prevent it from being added back with rereg_mr.
> 
> [...]

Applied, thanks!

[1/2] RDMA/core: Prevent rereg_mr for dmabuf umems
      https://git.kernel.org/rdma/rdma/c/09d09e5d79f317
[2/2] RDMA/irdma: Remove dmabuf checks in rereg_mr
      https://git.kernel.org/rdma/rdma/c/d24ce259185e76

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

