Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794836371;
	b=McYTGRg2bVAIhb0vpAww0Y+kPzYvAQJRjLsiGTiphcPipF/N+3o8ZoURL8/GAP0MH20K
	 /4dnPDZIC6hMVZNk1bBJNUTPdBLjfOcjU0hvcUDsyZuCl6SyPFmxKlw9pZY06y9n4pwmD
	 vJ95KhGQGVCEPrm1dmnZQhoH18JtXi5DfDSrEzaQs4HVOCiNHS56nKBVINlpZ9O5gs6+Q
	 mqDLy5CyPk163SCsi1kulEqYug+RS3J1BzYc/8rzeM9jUj7XP0B9Z9Vq92PXsg67LMnyS
	 bSOApMV0ux4fHw3OPT+HegkgxqlqdLgN36oIGpPyghVjrNbSHocPXOwIV2c3iEP6iDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794836371;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=xUMcU6InNjFuagAC4oUc1Sj3n5LV6evCKxL3yNMP3sY=;
	b=ZPtu9O33Jzh6jVdBt0Ug/2Fu/7xanF9MRPoHc8MRWz9NlGFZOmWrTSpHmEP+M0bbzIEf
	 gp9ctokpLYdd1QJ/8fhP+Zm/BIUEA4ohfMF2jLlwJvxMxu5BAdyu4fFAWfVt2y7qr8FDY
	 5f3wseQQTNlLpf4irA9g03OjI2B9uP/r5lzLbC36iD1uyZujLGrfr2qbDEOoTIfNjGy53
	 B1CrzLnl0wNi6dMcXm9gO0u7A2gyUH3cVmwzXoq1v/Ic8oSzx+S3HX1OwbleqniHweI7Q
	 YIQH4mQk8Jovk6aQCjFBPDn3QuBBnCqyzJs3q28DJIlT329I0dmdDTXQaFp9hIM3cgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HGYGTo6b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F429606A323;
	Mon, 16 Nov 2026 13:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HGYGTo6b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD2E1F000C4;
	Mon, 16 Nov 2026 13:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794836370;
	bh=xUMcU6InNjFuagAC4oUc1Sj3n5LV6evCKxL3yNMP3sY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HGYGTo6bLWHgaeUm4xUr4uQoOMOqG0TNe7SFpqCFWSfw7NtmTYz/eWN02udZrzpkF
	 qmF5ZeX/0oMTKjS0bhLrvf5ClGfObUoOjtk+DeCJAy3ijnUtTYgGe1ESCFaOS/5vrs
	 Z++NE7sSon351PJqtsJZ1MUKZno2gYcYIzlnPjf8BFqSzizP4wbcT96D9qJw1OFum3
	 CdJ9A3SASdhw1baMAt5YEEOkdMW49utOsAnrJQcLaSQGw+Euw1es20J54DFRnllpAY
	 rwzvlOnMCC3P1GDLiv0l+uk74CJR6HAKiKFmkc6+SwqlPmvSXCl7MD6Z4nJMRfmlxv
	 HvmGx1xcXOaYw==
Date: Mon, 16 Nov 2026 15:39:27 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Hungyu Lin <dennylin0707@gmail.com>
Cc: jgg@ziepe.ca, yishaih@nvidia.com, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/mlx5: Validate the DEVX command length before
 setting umem valid bits
Message-ID: <20261116133927.GO11319@unreal>
References: <20261115164658.88420-1-dennylin0707@gmail.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261115164658.88420-1-dennylin0707@gmail.com>

On Sun, Nov 15, 2026 at 04:46:58PM +0000, Hungyu Lin wrote:
> devx_set_umem_valid() sets the umem valid bits in the command supplied
> by user space, at offsets that depend on the opcode. The DEVX object
> create and modify methods only require the command to be as long as
> general_obj_in_cmd_hdr, which is 16 bytes, so when the command is
> shorter than the layout of its opcode the bits are written past the end
> of the command buffer. For MLX5_CMD_OP_CREATE_QP the modified words are
> 232 and 268 bytes into the command.
> 
> The command buffer is allocated with uverbs_alloc(), so the write lands
> either past the internal buffer of the bundle, which normally lives on
> the stack of ib_uverbs_cmd_verbs(), or past a separate allocation.
> 
> Fail with -EINVAL when the command does not cover the layout that is
> modified, as devx_handle_mkey_create() already does for
> MLX5_CMD_OP_CREATE_MKEY.
> 
> Fixes: ba1a057da2f1 ("IB/mlx5: Set valid umem bit on DEVX")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
> ---
>  drivers/infiniband/hw/mlx5/devx.c | 44 ++++++++++++++++++++++++++++++++-------
>  1 file changed, 37 insertions(+), 7 deletions(-)

Thanks for the report. We are aware of this issue and are working on a fix.

Unfortunately, the proposed solution would require DEVX userspace applications
to provide a size that is already known to the kernel, preventing us from
extending these structures in the future.

Thanks
