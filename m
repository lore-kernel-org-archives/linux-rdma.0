Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44462315D35;
	Mon, 23 Feb 2026 19:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771876204; cv=none; b=MXWjLTiuaNnLEmioTuACsFXzMKcNyexJjvf/dP5o//2S1vecyULgItptnoyMyXVGZiSe+glnH2OO/WZwKS8jy6sCKbZ8dio0h33oTp1dPLQ/JmKIPJ4McBZCtRjMubMr9Aa44MnOFVLY6k3gE71mXVAcIf3SIRcjdGT4FqRkD7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771876204; c=relaxed/simple;
	bh=iYFv9uffdc1353d/mu4doNKo+qfCfXL3UKlPfNTLUa4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=FEyDD2Y0jmRttUFs9vkYlhIfybmtEfdfbBbYZMb+51mkZLlfV3TOC+a6os5wTIHRDIqwDgx0GC1CVbGjzum5QRlZ5UiXxvYqtXcgSvGgDHPuPvBRisZ7A617X1KxpfyDZf7Y8hoIkacOo8eXPhQTkzxYxIfk/otUXdxfNwYebLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ADHTVpI4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ADHTVpI4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA00C116C6;
	Mon, 23 Feb 2026 19:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771876203;
	bh=iYFv9uffdc1353d/mu4doNKo+qfCfXL3UKlPfNTLUa4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=ADHTVpI4GdHIGqtF8D9lfV1gCBM/Pn5qlN28ykEvwocOZIbGKQ8scfyJiD7rwnDDu
	 NudvaeJMQv8RHuLwSsw5v9FDgRNQIwjMoRrxBtZg5LNbI3Nd3IMOe5aVVxj993QmlO
	 0Pl6qO3wqSCu/fD2t25R0mDuq2WaC03Ut/QOnk6KSMdXsaHh7c4Y5bHqq6zKgXxE+c
	 k0W5wpPnx4GNYiqxfKyKV89KQGg0TLPUcVjrm7cBY5qGhHrKVPIWQGgX9SqGHHkejM
	 /mTm+89GXSKntLJrxlPeunzxZiGVaFDvlGpwwPK0EURIDKOJk6kLJMMORZpy3UrxuD
	 oHLHqb0O10sqA==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Edward Srouji <edwards@nvidia.com>, 
 Yishai Hadas <yishaih@nvidia.com>, Arnd Bergmann <arnd@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Allen Hubbe <allen.hubbe@amd.com>, 
 Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
 Usman Ansari <usman.ansari@broadcom.com>, 
 Siva Reddy Kallam <siva.kallam@broadcom.com>, 
 Abhijit Gangurde <abhijit.gangurde@amd.com>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260216121213.2088910-1-arnd@kernel.org>
References: <20260216121213.2088910-1-arnd@kernel.org>
Subject: Re: [PATCH] RDMA/uverbs: select CONFIG_DMA_SHARED_BUFFER
Message-Id: <177187619948.677494.13268132845432486651.b4-ty@kernel.org>
Date: Mon, 23 Feb 2026 14:49:59 -0500
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-47773


On Mon, 16 Feb 2026 13:12:00 +0100, Arnd Bergmann wrote:
> The addition of dmabuf support in uverbs means that it is no
> longer possible to build infiniband support if that is disabled:
> 
> arm-linux-gnueabi-ld: drivers/infiniband/core/ib_core_uverbs.o: in function `rdma_user_mmap_entry_remove.part.0':
> ib_core_uverbs.c:(.text+0x508): undefined reference to `dma_buf_move_notify'
> (dma_buf_move_notify): Unknown destination type (ARM/Thumb) in drivers/infiniband/core/ib_core_uverbs.o
> ib_core_uverbs.c:(.text+0x518): undefined reference to `dma_resv_wait_timeout'
> (dma_resv_wait_timeout): Unknown destination type (ARM/Thumb) in drivers/infiniband/core/ib_core_uverbs.o
> 
> [...]

Applied, thanks!

[1/1] RDMA/uverbs: select CONFIG_DMA_SHARED_BUFFER
      https://git.kernel.org/rdma/rdma/c/16cb1a64dce567

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

