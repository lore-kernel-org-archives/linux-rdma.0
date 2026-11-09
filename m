Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794235712;
	b=LGIx74otAIMoOulbL8cQYtU5O5Df+fdJinMqxYOpep42h88TPNmbmDeGhwww0IoGNf4s
	 xfIY6zBl8Zi63QW+q6PPs1cw5WPvfrjtGEQb0MVZNbDjgxH9CXx7+898dTlEilymJAelb
	 gBrF3jXjZEXu6QtVttC05HcEF1hLrXrKJszm45zXNYusUaGdRbYpF5RtcSIORF/rTQmLI
	 HTmcfP4/cW/n+FEwi/rt/Ba9vBGUauzqKjw3zm3wT+iFlS9FnHqbSEtqdPeQcSnqzgWAv
	 sJy3ZttWWroVV14AUiwbwnpn39vNOBOKCtavYjjyvsGVkwVkt3nK2fp5PiXABNdY2CA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794235712;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=M7mjVSswzFiYPoD6QT1qC2YywjNa1eCvKgF70U0xhrg=;
	b=eylVitqcEF5efoD40liZu6xaUjWusLibQFzvAiR/Y69+P4XxN9kOyTS6hhN0e+FpxFFn
	 SyBfaUCyDvNS2wER66LwSiVrAs33C7rNYTjtosQ3No5qRMHp7tFPQfo5Q5UWynnse0UW5
	 0PLGOpxSztowkGoxEaXCtJnFpuW7iKF+ZaQNUqxq+4NK8wDG8eW4/Rws4TXRQXvmmDaY1
	 fIfp4hXpSG5mRuMcu4y+08XNSMQNfQa7o9nJAaeIaY3j0JPGfl+v1qvYX0FF8gEV5C5w/
	 XqkXOGQM+Xyu2t6xYR63b/m1XyXzeCU8+JjLbavj7b3FYCT6CtZxbndPCHkOAa/Jdnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=oNUecxHC;
	arc=none smtp.remote-ip=209.85.222.172
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88003606A323
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 14:48:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88003606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=oNUecxHC
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-93e515769d3so94686585a.3
        for <linux-rdma@vger.kernel.org>; Mon, 09 Nov 2026 06:48:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1794235710; x=1794840510; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=M7mjVSswzFiYPoD6QT1qC2YywjNa1eCvKgF70U0xhrg=;
        b=oNUecxHC4848KNAA26lHQ2G+BYpWGFvGSyUdQl59xdkTLL68nrj101K5yWsvlahxtJ
         NjIy7n4cPKvogrm33G94/yLTrcNabAnbH9oaO9/fqlPdqMhETQ2ody+fek6SSMiHM7lK
         1DB/dDCxqHNrel53IXnnPdTTAasHGJTssEOZ+Ca0HANmvndcE7KPej/d1lzOUgobuQGh
         U3BAlPeubxLio1DWsA623BiUEwqpep+ErKLxc2x4bBU8vHIhgqvUYPLdowJ7w6+mEe2z
         HPHXw8Gvah2ZH/r1bnklT6b2NoK+Vi3kDWqd3gtj/SvPFzgaYABt+HWB3Wqw26RfkEqh
         rcAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794235710; x=1794840510;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M7mjVSswzFiYPoD6QT1qC2YywjNa1eCvKgF70U0xhrg=;
        b=sZMqPhwsHavG7t0aTA1aZTFeU0vIeDGMM3dl5PNJEu6PKXypOHzm9VaOJ6MlT2xefH
         EQ990CTGCEZkUX6qVT9l2MnjW6uvrh3+u9/PwGGD0uHCf7KTcLKBgeI+PmF8tAqJBq7P
         tdXO8V3DjRobQHr3sjZSyP0devNxkMzK4jf/lwywVIMCJg1R6SZ20AEKmqMNhClFIdk8
         fDSVG0iCX/gVN0CRBgZRpUGFnxrLNVMjZdN47fnFT0eIG6b507Ujydim6bJq+W1AfH6e
         E7IJkLWAczCztkEpyfpukN+U0DCsHy0nq0mlY9n154F0S8wog4W1+V68Ol4dYgbpQXId
         UNFQ==
X-Forwarded-Encrypted: i=1; AL+hErHVkeSJC9ep5KBmqFBKsCaXGA2ir6dqWbXNIMrB33PdV2sT+sZkgUxdI3NC3W42uJEXywDApwGtNT7V@vger.kernel.org
X-Gm-Message-State: APuU4Z+z+HFZUzso1N2PjqbmiJLxdhqtSqQTqzcbgkik01LyQRv5x9V8
	lQZSk2JrGWjJEcniOoY+eAs5bo8Hwb6/cVLmMReF01gCCaSqCHuGyWD4mqabFZxp6S0=
X-Gm-Gg: AYBFou3BhQFJFnCiOCIlWYZfR7JD4ljR+hZzFH5KxeSVeFVX4adXA3DtwfOLlqdAZh2
	veNsMNIx3k98Km8LUbFWhVVaGd7Vv4IYMnJwosZHliJb6AWZz6ah3rcW/5c8QVkwRUEK0PvE7uL
	8IbRQZvmc/mtMeDMp7yGPDOXEjQ2pkv8uaakFA6X/MbiAoqELxtMaAzYSY8Wmu28extqrO/sGq6
	HF1blXV2fS304pfmnexPncoYG8IuWEOqXr/dTK/JNLSeC4NXrc/Dvr/VqtCyMY2mT9Zjn6HtBZ9
	OAbIdBOngLubLh77MYNzHMYF+WOHb/SLpEbaYulOM66RSFhwpBXHif+9llM9Y6GJMZO3OMfB6Aq
	XPFn0JtKf+C4kGWjo3Jd6BOjAdhUwM/mDWc8kzITKWfebuv59MJ75rU8CiqtBikCShy3+Sct62V
	sKDXCaOs2XsQcnVy2hrfZe3XRwc17SstDby1OI30AaeItalbBqhWE3eRAJwhBj38j0jYMCadVd+
	ndhnLqlvWXuFQS66kPXUKzRdes4moKw9f3R4/ymEN4BJBlO/mK5EiGNmYJZbxydNCjoi/MX3csX
	WUr8QZ93awHkSMfAPBYmQkckhhidYou3RK1Xzrfzkl7LBoRBewaEYsT+7PTAelhzB0hmV6MQbRf
	M3SSVVxBxnA==
X-Received: by 2002:a05:620a:28d6:b0:947:1d0a:c89c with SMTP id af79cd13be357-947848d1cfamr570972285a.56.1794235710297;
        Mon, 09 Nov 2026 06:48:30 -0800 (PST)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91eceea05a2sm43886796d6.39.2026.11.09.06.48.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 06:48:29 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xQQfd-00000001QiU-0CrP;
	Mon, 09 Nov 2026 10:48:29 -0400
Date: Mon, 9 Nov 2026 10:48:29 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Edward Srouji <edwards@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>, Yishai Hadas <yishaih@nvidia.com>,
	Yishai Hadas <yishaih@mellanox.com>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, Uri Dar <udar@nvidia.com>,
	stable@vger.kernel.org, Michael Gur <michaelgur@nvidia.com>
Subject: Re: [PATCH rdma-next 1/2] RDMA/mlx5: Fix DEVX UMEM mailbox size
 truncation
Message-ID: <20261109144829.GM663069@ziepe.ca>
References: <20261109-devx-umem-mailbox-overflow-v1-0-4a63baab25dc@nvidia.com>
 <20261109-devx-umem-mailbox-overflow-v1-1-4a63baab25dc@nvidia.com>
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
In-Reply-To: <20261109-devx-umem-mailbox-overflow-v1-1-4a63baab25dc@nvidia.com>

On Mon, Nov 09, 2026 at 04:42:32PM +0200, Edward Srouji wrote:
> From: Uri Dar <udar@nvidia.com>
> 
> devx_umem_reg_cmd_alloc() stores the CREATE_UMEM mailbox size, a header
> plus 8 bytes per MTT, in the u32 cmd->inlen. The number of MTTs is
> derived from the user-supplied length and pgsz_bitmap, so a UMEM of about
> 2TB registered with 4KB pages wraps the size, the mailbox is
> under-allocated and mlx5_ib_populate_pas() writes past its end.
> 
> Store the size in an int, the in_size type of mlx5_cmd_exec(), where a
> larger value would turn negative, and compute it with overflow checks so
> a UMEM whose mailbox does not fit is rejected.
> 
> Mailbox sizes within 512 bytes of INT_MAX still overflow the block count
> in mlx5_calc_cmd_blocks(), but the command then fails with -ENOMEM
> before reaching firmware. This predates the change.
> 
> Fixes: aeae94579caf ("IB/mlx5: Add DEVX support for memory registration")
> Cc: stable@vger.kernel.org
> Signed-off-by: Uri Dar <udar@nvidia.com>
> Reviewed-by: Michael Gur <michaelgur@nvidia.com>
> Signed-off-by: Edward Srouji <edwards@nvidia.com>
> ---
>  drivers/infiniband/hw/mlx5/devx.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
> index fc6f793dcc6584e6a22b40c57e2df8f24579eb14..1da6c0e440d6e19d8791b012a148f479cfdddad7 100644
> --- a/drivers/infiniband/hw/mlx5/devx.c
> +++ b/drivers/infiniband/hw/mlx5/devx.c
> @@ -113,7 +113,7 @@ struct devx_umem {
>  
>  struct devx_umem_reg_cmd {
>  	void				*in;
> -	u32				inlen;
> +	int				inlen;

Do not change things which must be unsigned into signed values.

Jason
