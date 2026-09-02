Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888B236F8F5
	for <linux-rdma@vger.kernel.org>; Wed,  2 Sep 2026 16:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788365620; cv=none; b=QxDtI0Hxl44dPLWmTl5TY2gxWIyFKZR3tutkKwpzyH8+YJKUnJcvZFaMYcBrdGftU5n1HpplQaJ8E1CofJKl5vW192ctBdSJQb3lb7U4/IldcE5ROAea+PdKP2ysoJV1c07KN1bGPpehC4XsQ6cg/asSs8ZN7VHhPr5MTxbR8Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788365620; c=relaxed/simple;
	bh=syqS7uO+kxRkxgFkdwt8oiph0sYTscWln0k0de5MgyY=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=mpTPGX1E65anqQRs+92U3INoUByaREwhjQMSeZJ4qb12go0B5TiEmcGLQLZyTOs6PkvNGQ4z1Za2QfTMBwwdDCb6kWm/cvGr01REPngic9TTwKCgU7W1ex9XEgw77cIkYH/7gKgVrUS+9ebV0aLOIw/22EcRaZr4CQko+UflxdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IRa8CKy0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IRa8CKy0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64FD51F000E9;
	Wed,  2 Sep 2026 16:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788365617;
	bh=SeATNSL4jZr5RnlmEDVmI8pLLBEYkjYI00dwZSvsvjg=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=IRa8CKy0im7dumAmAAX/rHCm5eG9zRCNg6BKVYaxT1Yx4hBOTMLa9bLCRQeckQbP1
	 0HgPxmUirlE8ljtyGeTwL386YfGyAOt5tYnOP8bibnZ4jo3L0NT5P6468qT0MOv7CQ
	 azoEuE4YyppeAo009lZNpfu2sQFZ2x6BFE9rO/m9OoOlywuNe8pnEE5dfeJU3n6SNr
	 Dz/F3jOj+D6Dq16lycR8TJ+HVWpA+ivAwCWkLwBxPeIM+SDZWSlIIbQTMS9kL3KgF9
	 IS3FywWzmTMIHb9eR6fZ7ppCO/eQQQBzOgisl14Xcq4GDixC8Ru9CSsU37pkzvewq7
	 XLq84VIRWl0Ug==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, 
 lirongqing <lirongqing@baidu.com>
In-Reply-To: <20260826073146.2203-1-lirongqing@baidu.com>
References: <20260826073146.2203-1-lirongqing@baidu.com>
Subject: Re: [PATCH] RDMA/uverbs: Fix potential leak of
 resources->collection in flow_resources_alloc()
Message-Id: <178836561402.2545652.10202905500535812798.b4-ty@kernel.org>
Date: Wed, 02 Sep 2026 12:13:34 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 26 Aug 2026 15:31:46 +0800, lirongqing wrote:
> The two array allocations are done unconditionally and only checked
> afterwards, so if the counters allocation fails while the collection
> allocation succeeds, the error path frees counters and the containing
> struct but never frees resources->collection, losing the only pointer
> to it.
> 
> 
> [...]

Applied, thanks!

[1/1] RDMA/uverbs: Fix potential leak of resources->collection in flow_resources_alloc()
      https://git.kernel.org/rdma/rdma/c/08d4d9802d58bf

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

