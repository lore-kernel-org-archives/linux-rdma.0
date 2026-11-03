Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793707109;
	b=l6wyPxYRCGJemvEDV4QqJkC1N02IyfKjV863PyNqm1f7UfVxywls36d/aQtym3FrvIE9
	 KWdK1tIk3eJAYMJawnKv6JMS4JEz7XYUfuPGLJfFpxEjhI/25YSKpVo/tnv897T15lU/4
	 cNtRsJlGxqhyEJmbj80kHYv7xCmXECVDdECoHF4M4K+6v0HyplfvG3Mr/vwJ+g3kwJx4j
	 TlIO5j+L7p9FpJHv/j7QD/GpYyT/BTWt/hC+kpQwPL3GN50HTchvkX9s4bqpgdKzv3RHl
	 EUQ46JThxM/1NOY/czZngsCBMPaS9ZTIdrHtzT/oKY0bJoNbTIAMDbHX+n8H81NJXmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793707109;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=s6xmGZ3xUhukgQni0sDZOjbv8PpzzD3hGUC+eLiqtZk=;
	b=jiAjLBbSwfMgW8Ch/NPToZ/rLx9M9Qfr9DCfnX+Af7gSWABvlUZIgOczjaxxYvB56yQ9
	 rWwzUx+htvjterGrthUZbWGtSQ4GYktWQanQrico2kBMk42eQ9mjJcP+peQy2PYE1fs+I
	 OEkSU4vOOOyogjf+He8Cu+oo3fhalM0yjJf46DhCaayZIQO9QQPJUEmh0Xtofa+aJTLIT
	 6DjlR/D9+BmrULzIvGoPQsD97G8PZtCKic7vw4qgXrFJH8YvydxjSbkwZnTQOMxnZEX8l
	 fvV9iOl8WaWoQBNENXSd+MPXtN8aAh5VeH+Xt4kxQ5SgLd0l4NN1F0je6Bn6owDrwEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q2zIQK3t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1441E606A327
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 11:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q2zIQK3t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0916B1F000C1;
	Tue,  3 Nov 2026 11:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793707108;
	bh=s6xmGZ3xUhukgQni0sDZOjbv8PpzzD3hGUC+eLiqtZk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Q2zIQK3tQ1QdhdEoaY20F3Ti5oCXJB9/DasJ0qBwBitBvVxaUV0vqWvYnPHn9vDTD
	 6/Ygl8xL7Ki6hN2EMbcpES1h6aVrC+vhXic9DESGRZGqXyjaTlaV84MTH6aXUTMa4w
	 vaExkh5kemuF4lM0vJ3UXBTPDmsApDSooTBcI5TWdsYTTF+vzuxr0AQUgL8bxve/5T
	 neQnz9TB9OqvXdBA2i2VTwvxtG23JrqT2Dks2LDFXyEumCCAgjJB3G9xktIZvussaq
	 GAvP/qsIXqpjmtf12s3MzvaxCEzEAs5K/8jBR08CXJf55P2npKCSmJGr7c5rsiJwIQ
	 viErbX8zcLyZA==
Date: Tue, 3 Nov 2026 13:58:25 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Yuho Choi <oss.patchbox@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>,
	linux-rdma@vger.kernel.org
Subject: Re: RDMA/mlx5: question about a failed destroy in the SRQ create
 error path
Message-ID: <20261103115825.GE264423@unreal>
References: <20261028053903.209809-2-oss.patchbox@gmail.com>
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
In-Reply-To: <20261028053903.209809-2-oss.patchbox@gmail.com>

On Wed, Oct 28, 2026 at 01:38:57AM -0400, Yuho Choi wrote:
> Hi Leon,
> 
> I have a question about the error path of mlx5_ib_create_srq() (rdma
> for-next, c3e8e9451e6f) and would appreciate your view. When copying
> the response to user space fails, the result of the destroy is not
> checked:
> 
> 	err_core:
> 		mlx5_cmd_destroy_srq(dev, &srq->msrq);
> 
> 	err_usr_kern_srq:
> 		if (udata)
> 			destroy_srq_user(ib_srq->pd, srq, udata);
> 
> If I read it correctly, a failed destroy here would leave the firmware
> SRQ using the SRQ buffer and doorbell record that are then released.
> Since fd89099d635e ("RDMA/mlx5: Issue FW command to destroy SRQ on
> reentry") the SRQ would also be back in dev->srq_table after the core
> frees the ib_srq, so SRQ events and ODP page faults (odp_get_rsc())
> could find freed memory.
> 
> Thanks for explaining in [1] that DESTROY of kernel-owned objects does
> not fail on working firmware. I wondered whether user SRQs might be
> different, since they carry the uid of their context and a DEVX QP of
> the same uid can use them, which 43d781b9fa56 ("RDMA: Allow fail of
> destroy CQ") mentions as a reason for destroy to fail. For example,
> could user space create such a DEVX QP on the new SRQ number (probing
> for it) 

Userspace does not control QP numbers; firmware assigns them. If firmware
considers a number to be in use, neither the kernel nor userspace can obtain it.

Thanks
