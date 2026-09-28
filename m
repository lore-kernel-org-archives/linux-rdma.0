Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5C24E8E0F;
	Mon, 28 Sep 2026 19:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790622933; cv=none; b=sT7WhToWclWWZzHpIPyKEzgaBkfp4pboRfzGGBXeltkzzFY11kVFdHdiLEFydagVyUPuhb9SdvV8655SLtTQpWZE3+YDg8WCgtuCYRUAv1ZecRptctFX1yc+jebiOsdxlwd9FLsSyohqlFA376SKuIvuMfqVMzwFjAvA+RYpCN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790622933; c=relaxed/simple;
	bh=a8dv7ZBOxg9u8J91MSLKO0UdjH8Iwx9Vfg19B6tu3sM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=UaGDyE7Wcykk7eosnawlY4+XA34rSsMLncU4v7Ucwda01TqiJXZ1pl2aZApDGKUUapucn/fCEq2IH2PtJv4R8AjtXeJ5fvm/zXzG4G1evA2DO4tHK5+7gUQK7TaEKHOM6hcxBBgS5O7gCEz8UBbvLWYujOyAbN+tvbxs6919c6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I42bfjmK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I42bfjmK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E321F000FF;
	Mon, 28 Sep 2026 19:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790622931;
	bh=pavSSyd+5COpJ+FcYxjfDIVgJHsCwKFFaC01d4tX+dY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=I42bfjmKYEPkRHi6/P5qfOYiySBGPCQo3hyjWscD2WFbwElDzvhOEArEjKw+QXq+K
	 E6miPc3uHEabIFJHdxx+AHJ7DDls/hfk1DL4IZUb/iHwEhd8RSp9vhTe6N7DjdlCtx
	 Z+MQ5gzlixTfSRfy889DFy+fcHZerD/xaK2AHFkflhyMrTp3vJ93gHvwulxrjWKivl
	 qU4zURbXLJ/mqaPhqj8BeGSGJs8DVAJS9OlAlnFjlP7lhAGXSW1D52aTGILJMf0Cds
	 u64U+UNXD0X1DFPIpzS7s7jYO8w3fYpQN/KRqb6sVU3ugfo03Lbk7qQQzMO7p6vqEI
	 RCyajIT8fcqNQ==
From: Leon Romanovsky <leon@kernel.org>
To: kotaranov@microsoft.com, snsanghvi@microsoft.com, longli@microsoft.com, 
 jgg@ziepe.ca, Konstantin Taranov <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260923131155.4055875-1-kotaranov@linux.microsoft.com>
References: <20260923131155.4055875-1-kotaranov@linux.microsoft.com>
Subject: Re: [PATCH rdma-next v4 0/5] RDMA/mana_ib: Streamline kernel
 UD/GSI posting and completion handling
Message-Id: <179062292875.3940368.14073384996930348094.b4-ty@kernel.org>
Date: Mon, 28 Sep 2026 15:15:28 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 23 Sep 2026 06:11:50 -0700, Konstantin Taranov wrote:
> From: Konstantin Taranov <kotaranov@microsoft.com>
> 
> This series updates the kernel UD/GSI work-request and completion paths in
> the MANA RDMA driver. This series is required for upcoming kernel RC QP support.
> 
> The main idea is to fill in WCs directly from CQEs and do not use shadow Qs
> as proxy. The older code, a CQ had lists of QPs using it, which adds overhead
> on polling when CQs are shared. Instead, CQs now maintain only the list
> of QPs in error state.
> 
> [...]

Applied, thanks!

[1/5] RDMA/mana_ib: Optimize shadow queue bookkeeping
      https://git.kernel.org/rdma/rdma/c/8b55ae7c81f038
[2/5] RDMA/mana_ib: Revise UD send posting and WQE definitions
      https://git.kernel.org/rdma/rdma/c/afcebf3cfa0e84
[3/5] RDMA/mana_ib: Revise UD receive posting with GDMA_WR_IB_SGL
      https://git.kernel.org/rdma/rdma/c/387c51aa0ee0ae
[4/5] RDMA/mana_ib: Make kernel CQ arming robust
      https://git.kernel.org/rdma/rdma/c/9d3fccc58efe4a
[5/5] RDMA/mana_ib: Poll UD completions and flush software error QPs
      https://git.kernel.org/rdma/rdma/c/1d99b7cea29c31

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

