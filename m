Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150594756BC;
	Wed, 29 Jul 2026 11:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785324663; cv=none; b=be4yY8gHRGsfAfIgDoDO6Au1TSl07RoakmVUQKC8xWmE+IuJXTu/xKkQZCSdR9wEXspZA0QXF47dIiaPJ0x9zGgSsAH5GZ4Mw5/86V5RrhwQKrgU5+FiC1mZkeBr4K7wMFZs94LvktSvDHTFjRDK9F8EcD647Pbr8mb1ZKG28+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785324663; c=relaxed/simple;
	bh=T4CBINrbLYPiby1ukgxM5yfu3WJ0i55mq+8TlNoU45M=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=r76FKBCACMskaLDZvE7Qsn2/yYgVVE9ULaHk/tbju11qSZosaSZV2sFrWQ25LvnpngTqWqWy2Sys9dCBkVff8e8YcJAZSaD1/rXzosdjWCnbLyUJ6YlM+ZmK0gzPBjBwwPWn2f1SxaAC88JVB5ztLma7hDdP3m/jRs2DoJj1EK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335CD1F000E9;
	Wed, 29 Jul 2026 11:31:01 +0000 (UTC)
From: Leon Romanovsky <leonro@nvidia.com>
To: Potnuri Bharat Teja <bharat@chelsio.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, 
 Hariprasad S <hariprasad@chelsio.com>, 
 Steve Wise <larrystevenwise@gmail.com>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260726-leaked-mhp-dereg-skb-in-c4iw-dereg-m-v1-1-ebd6df364d53@nvidia.com>
References: <20260726-leaked-mhp-dereg-skb-in-c4iw-dereg-m-v1-1-ebd6df364d53@nvidia.com>
Subject: Re: [PATCH rdma-next] RDMA/cxgb4: Fix dereg_skb leak and double
 free in write_tpt_entry()
Message-Id: <178532465867.1579818.11355307138267404838.b4-ty@nvidia.com>
Date: Wed, 29 Jul 2026 07:30:58 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Sun, 26 Jul 2026 11:58:08 +0300, Leon Romanovsky wrote:
> When the device is in the fatal error state, write_tpt_entry() returns -EIO
> before handing the caller's preallocated skb to the transmit path; its
> allocation-failure returns do the same. c4iw_dereg_mr() ignores the error
> and frees mhp, leaking mhp->dereg_skb. c4iw_get_dma_mr() instead frees the
> skb a second time after dereg_mem() already consumed it, a double free.
> 
> Make write_tpt_entry() the sole owner of a non-NULL skb, freeing it on
> every return preceding handoff to c4iw_ofld_send(): fatal error, tpt and
> stag allocation failure. c4iw_ofld_send() consumes the skb on success and
> error alike, so drop the redundant kfree_skb() in c4iw_get_dma_mr() after
> dereg_mem().
> 
> [...]

Applied, thanks!

[1/1] RDMA/cxgb4: Fix dereg_skb leak and double free in write_tpt_entry()
      https://git.kernel.org/rdma/rdma/c/373f3716a2de7a

Best regards,
-- 
Leon Romanovsky <leonro@nvidia.com>

