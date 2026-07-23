Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963D33382F4;
	Thu, 23 Jul 2026 11:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784806545; cv=none; b=sKqxSez9ui9n643wADpgwlxlbWArG9HiqhI3+qoy2k6oGd1MXam+FJIxEX3da6S9TiFqhFulQR/JLpjetZffK1+WaFwi+2nRl/RpbVnMEjG/43xEH3wXc6+sFohXuLIBW96lvMF/vJlq3AFguXQpCROufSb7UvJXOloW0OJKivA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784806545; c=relaxed/simple;
	bh=djpqoYlzVVUPL93q+wkGJmgyo2+riZSSkzyD0DAubek=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=AT2MmD2kPCAkP7fSbpL+pYkl4Vs3mZ+Pf2z4oCqa8VyBW26obwY982noZME/lVMauz95eYFC/+qeyhjqzGE6XhU5KBgPWX6aFjMhcTshqCgkI5HJHEyIXU26NAAp/uEN2+FztPVzeyrwQDYjJQJq4kI0p//jnPhFtLsdYxIGMe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D671F000E9;
	Thu, 23 Jul 2026 11:35:43 +0000 (UTC)
From: Leon Romanovsky <leonro@nvidia.com>
To: Cheng Xu <chengyou@linux.alibaba.com>, 
 Kai Shen <kaishen@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Wei Yongjun <weiyongjun1@huawei.com>, Yang Li <yang.lee@linux.alibaba.com>, 
 Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260722-b4-qp-and-cq-memory-are-leaked-if-the-d-v1-1-97e223dc1c96@nvidia.com>
References: <20260722-b4-qp-and-cq-memory-are-leaked-if-the-d-v1-1-97e223dc1c96@nvidia.com>
Subject: Re: [PATCH rdma-next] RDMA/erdma: complete object teardown when
 the destroy command fails
Message-Id: <178480654122.3446076.3232842095123320652.b4-ty@nvidia.com>
Date: Thu, 23 Jul 2026 07:35:41 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 22 Jul 2026 16:13:54 +0300, Leon Romanovsky wrote:
> erdma_destroy_qp(), erdma_destroy_cq(), erdma_dereg_mr(), and
> erdma_destroy_ah() returned early when erdma_post_cmd_wait() failed,
> leaking the queue buffers, MTTs, doorbells and the STAG, QPN, CQN and AHN
> identifiers. A command timeout clears ERDMA_CMDQ_STATE_OK_BIT and
> permanently disables the command queue, so no retry can succeed; the RDMA
> core keeps the object after a failed destructor and forced uverbs cleanup
> then nulls the pointers, making the resources unreachable.
> 
> [...]

Applied, thanks!

[1/1] RDMA/erdma: complete object teardown when the destroy command fails
      https://git.kernel.org/rdma/rdma/c/652befcba956ef

Best regards,
-- 
Leon Romanovsky <leonro@nvidia.com>

