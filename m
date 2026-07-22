Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32EF338237F;
	Wed, 22 Jul 2026 08:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784709420; cv=none; b=J7XfqhMgv4kze2xTvEIWK4LDqirVQS3rUShG2sLsvxAGN7WgkeuJySHW9il3gfENVvCyaNq2pKcxynq4upKRYesgPWQ6dOxT7q/K4kSWB2moZy3qz34IYt6BEhTGA1cO0LrRvVNiWApmCfCsE23LUAIH2YT0mrSwktAF68PNhdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784709420; c=relaxed/simple;
	bh=8QmaDEx0A5zYMInWSgUNm3VxCoSeKnVcuyUZFmAgswM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=rX/vQmEfAu+Uz7X945cDasJZlh4DssE3GtuegVHDG+bGEvlu9nefZ4CpDZi9sZOnvSffmz22H6bGLpoc2VCdp8IzZy3OFuwYgqD9KwZhRJsSJ7iTzmNxk3UgI6WpuzkiDPKMPyxqAIwT1bRHA1K3hAR+PCRvE/ROGhV1Yp0Pk2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J537f0vl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J537f0vl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D301F000E9;
	Wed, 22 Jul 2026 08:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784709419;
	bh=+gcNO6BqpAQmDPw0mB1hx9VRSkUAOCXr0r9RmbVWOHY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=J537f0vlyCq1cjpNdez2iE4hrKsJCvAB5X+8rdlRS1mwtXbok3CXGVip+cIzLZbuT
	 OhvfdYbDLclJ4jfNal3ANaGJY6RjH9S7wUXme2WuD1LCyi3IlT2gockR2yrOjIfql2
	 Rd2K34j3h0hz7bQBgl5iwjJNtxDOOdMtPA+bFW17ALBXnfF95hxzC8wgjLJ52Au/Pa
	 7NTJ/eal5DvIN1crkpFNLkyL/fETSnEUf5cclumWMHqgqz4UXZNCsRM6ykep7AmbEj
	 kAfjGlCfetyr2QAuC3oMInzpXgZt29oruDWSxcmeCnRZfYbaspA+/PRnQqsLL2b8rp
	 3JImcmiFUxAug==
From: Leon Romanovsky <leon@kernel.org>
To: Cheng Xu <chengyou@linux.alibaba.com>, 
 Kai Shen <kaishen@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Myeonghun Pak <mhun512@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Ijae Kim <ae878000@gmail.com>
In-Reply-To: <20260721082545.47395-1-mhun512@gmail.com>
References: <20260721082545.47395-1-mhun512@gmail.com>
Subject: Re: [PATCH] RDMA/erdma: Fix CEQ tasklet use-after-free on removal
Message-Id: <178470941606.2823975.4498529572458233425.b4-ty@kernel.org>
Date: Wed, 22 Jul 2026 04:36:56 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Tue, 21 Jul 2026 17:25:45 +0900, Myeonghun Pak wrote:
> Each CEQ interrupt handler only schedules eqc->tasklet. The tasklet calls
> erdma_ceq_completion_handler(), which reads the DMA-coherent EQ ring
> through get_next_valid_eqe() and updates eq->dbrec through notify_eq().
> 
> erdma_ceqs_uninit() frees each CEQ IRQ and then destroys its EQ.
> free_irq() prevents another hard IRQ and waits for an in-flight handler,
> but it does not drain a tasklet that the handler already scheduled. The
> tasklet can therefore access eq->qbuf or eq->dbrec after
> erdma_eq_destroy() frees them.
> 
> [...]

Applied, thanks!

[1/1] RDMA/erdma: Fix CEQ tasklet use-after-free on removal
      https://git.kernel.org/rdma/rdma/c/0ca79979384f03

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

