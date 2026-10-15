Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF68654B1A0
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 15:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792078715; cv=none; b=KU6FFqZgaAG2Xbr847unLnaSK3dr6J4vKKkgircD79SGid8AgwIY9dvVApUF9YefgRbS0R9FJ3kfJv9m/GqbhRNoExRQLVrPtuiFPKUfxpwSLSs0ebd10AAMA82Lhboa4/OYIcx+aEsxzMQf8lheasRTDjIrNMOxu9fOLeHXCtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792078715; c=relaxed/simple;
	bh=pzjR1m7UP397J6+IwUGcSoax5AxyKTyznnFiz5fde3I=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=u9lSAdTIZDYMttWWVku/vtAcQqGMiMCInpHVnmY0+eKObg2LlVIhf2AZs7pLYkjqpYezPop6Q7UjnA7/dkRP4a/QwUFk8RdLsOkjS0BgkEgLCGHqonawK07H2E6SDBhbQzSBlF13shETi4+D/nIy6K3gDH6XTMGumfntq4OeKn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IKpZntM7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IKpZntM7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B131F000C5;
	Thu, 15 Oct 2026 15:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792078704;
	bh=/XWZGzOP4rdKclC0k4dFAdt/HZ3PHkD+IBZkHYUn60I=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=IKpZntM7XuykRjfJXrE3o7Y6zbG7ECLh4pQrF8HjzMi06P0NhUFYTACPllsrlkqAL
	 98jOQ5qg8KwH2zgCx6iCJqFrIsDPGFv05X+5w6QOrpRmrS2DGIaWVLOHXYkz92/swa
	 Bp/ZIRQ7P9zC0L6yhp/9j7phWNFF49X7R3ooc9HuRgrzxQ1qkMeVWMZwqG/V9tWqGi
	 Lu4NsGwpT75Bf1gd8bwJtYLpB6P57iijGWupr6RJFuye8uhNop+UzeCoMQQOULwkIu
	 Uc/tPDyu+9dL7W/zfdf8xWEEqJM2CUiYm+XGFdQVOFuZ/KgekqFoGDnUyK4Ii7Q0N+
	 WsGSeQhpLDcfA==
From: Leon Romanovsky <leon@kernel.org>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, 
 Jacob Moroni <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261014162144.4053279-1-jmoroni@google.com>
References: <20261014162144.4053279-1-jmoroni@google.com>
Subject: Re: [PATCH rdma-next v2] RDMA/irdma: Check MR contiguity before
 PBLE alloc
Message-Id: <179207870129.258436.14759593587513062607.b4-ty@kernel.org>
Date: Thu, 15 Oct 2026 11:38:21 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 14 Oct 2026 16:21:44 +0000, Jacob Moroni wrote:
> The original logic would attempt to allocate PBLEs, then would
> check whether the region was contiguous _after_, and if so,
> would free the PBLEs and use a direct mapping instead.
> 
> These unnecessary temporary PBLE allocations can technically
> fail (PBLEs are a finite resource), which can cause an MR
> registration failure even if the region is contiguous and
> should have succeeded.
> 
> [...]

Applied, thanks!

[1/1] RDMA/irdma: Check MR contiguity before PBLE alloc
      https://git.kernel.org/rdma/rdma/c/9165b3f7372bc1

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

