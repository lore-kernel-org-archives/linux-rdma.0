Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0A833993
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 12:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790167322; cv=none; b=HzzOkyveHd0XpQE9mBiW1xwWxWKXskzFI9FSKoRPyhSkfcrIe8H6l5W/I12ui6sNNV0uxjyFrVvZN0syWKlR5IpYOVfgwgFXQfNdtNtPw9rnOXbwSwoP/rRp1Vu7KBisbnNDFds9kLIpqhTAk28NSaz9AyIcENnnkX7uayYyxoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790167322; c=relaxed/simple;
	bh=+Q8EQKJtmTC1ugPOpM8xSC5rD8eFEN2xzBZyWoDOtfw=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=DtCfVgIxginaPwF05xl6oE8/RnHr6nYkYP6JXQall3VAcs0BJqsLQQJC8o3mHTIZSruyAUxBEpM2vU1uSfd/bIFzYD9f8TyLhthtHhk/2MAcQakas70nYig10BpZ2KqeWDdsHYCojijQM15e0D+MAAIJgQzEysmJGRR8vcco3t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E67W+xv8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E67W+xv8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A371F000FF;
	Wed, 23 Sep 2026 12:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790167311;
	bh=HH9T7imAIgzFZHT+dkH4mxifR9Cs/iuyi1z0yyFJnfQ=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=E67W+xv82/KiOu51u8gywDlyMIGsQRzKE+UK65VUCHtv0LjMv2oJySVHRsuCFILtS
	 su9Ng5cj1zNB4r+apVRo/SxDWLVDg0X/QCLcqxwp458K5pYvmOIrYGW9SovG0jSDIV
	 mVA5AqDXpW6eEVOkSpdn6bC/l43wbyz/Yhpx2nFPOvggReMcvrQVfvk8nPvuf2AHMG
	 h73BrmaSIpsdRzmDV+ZzGStK9Pi2+6cP97QuvUS2cAuv1o/uHLdvMWj3K87nQjgdGj
	 6XZXE4hk/JCFL0Jnltc+q8PuYuGvmBrfHl413W2FbQUBtmtatQpJ16Pq90DXNYWgXY
	 Z65Bwo5UZ6yxw==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Zhu Yanjun <yanjun.zhu@linux.dev>, 
 linux-rdma@vger.kernel.org, lirongqing <lirongqing@baidu.com>
In-Reply-To: <20260917111722.1723-1-lirongqing@baidu.com>
References: <20260917111722.1723-1-lirongqing@baidu.com>
Subject: Re: [PATCH] RDMA/mlx5: Restore flow_attr-first layout in leftovers
 flow rules
Message-Id: <179016730862.3410790.15823629589301922889.b4-ty@kernel.org>
Date: Wed, 23 Sep 2026 08:41:48 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 17 Sep 2026 19:17:22 +0800, lirongqing wrote:
> Commit e91fb8b9d0ed ("RDMA/mlx5: Avoid flexible array warning") split
> the leftovers_specs[] array into two separate structs to silence the
> "array of flexible structures" sparse warning, but in doing so
> reversed the member order: eth_flow was placed before flow_attr.
> 
> _create_flow_rule() locates the flow specs with:
> 
> [...]

Applied, thanks!

[1/1] RDMA/mlx5: Restore flow_attr-first layout in leftovers flow rules
      https://git.kernel.org/rdma/rdma/c/c1212a3c7ccd46

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

