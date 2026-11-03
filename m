Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793706821;
	b=h454ksVU/Y12dGVKVDxOnM+Y6LA3R4rllbELLBewGu0wdeGhCyWQeAYy44P+/o0zGeyj
	 Hkwy9XnGBFTXYnwfKbDmCrb4FTtEiqvO9Py0JD5T4DVsFKuPIkv7jFK6r2g+MaQMU14Km
	 Xlv3BWPai6E1uuENH3dqvSIr0P3C5cj+Ad99225hBZ76YFFDNYsOsVw3y+YzswD5gNnOO
	 p441ttBoij+ySZMdHDDCUcaYo3idJfCHPc/DP+fg4JjpL9/c/jPjU67pF/juYG/7e5tPB
	 mDYV3uaM7+6taWr1+SkiGhu8AZUTn+y5c/TMb/q58FE/l+ftuQUEapgcp4B6+mpg//g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793706821;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=BLyWnx5KrphGZSaKtIGtHa2uKNejnd4vAGdj4kaX22c=;
	b=QnT+hhyZQ+VgxcGqPjs5fp4MGDAzj13TJeuEdnLKKsEqtat2EqQzfKvhuwtFuB2AEdad
	 30FYS1osEFZoXfVWXeL0gvvWY+TBTrf4fZD01nSF/ywNak9FOQaSWLj8qPqZLLUdVTlSo
	 T33rWe76n2TVbcf2eMBnvhgQBhNoc20oa2+lCULVQf8agiw4vf/DrP6xxUu4zU1x+OsF8
	 giTsgit5L7eJvomcGJ/dbbYxDXvCFWnyC9p0KX9kwdhWFLmJzewdA/96zOyjIZI4ITaPh
	 MH46zrUrctuSxmgdbNDp3KTJPV8mYK6bbwzE5u34XxVWmO1BKMdRgRfKS3NKNWtSOYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="X/V8PD1t";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37300606A337;
	Tue,  3 Nov 2026 11:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X/V8PD1t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED3E1F00A16;
	Tue,  3 Nov 2026 11:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793706821;
	bh=BLyWnx5KrphGZSaKtIGtHa2uKNejnd4vAGdj4kaX22c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=X/V8PD1ts7qAbefPlo5sEllimPrlHTuTucR7mrGPn2hpna100SAltxQzpUy43W7x6
	 QzSuaeHJ/nlcpFLm3odLVDSD8yOC0/oxNhKXePhCgKTqDJR4uj5Fhqyf03+OHpb3iu
	 mTB/7Cj/XTfrbXCrvYw5ul16kvTuQH/JA85/xDSvsrmXn+R4MJqQLHwPnJ3R8B+HGg
	 QVpbN6FlqRka198fgOeSmuRrasEKjGzoK7Jweb6bNK0jVMUl02n28RQGmWhbQbZzJf
	 btK2PZMKtbgU1eyZPgBZqv4exnQcfZbflHDoiTAa6AjLugypQoUpVhIQ/8D4Qt2sR+
	 tvlrcAuBaPcHQ==
Date: Tue, 3 Nov 2026 13:53:36 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jiale Yao <yaojiale02@163.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Parav Pandit <parav@mellanox.com>,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] RDMA/core: skip compat cleanup for init_net
Message-ID: <20261103115336.GD264423@unreal>
References: <20261028050245.125370-1-yaojiale02@163.com>
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
In-Reply-To: <20261028050245.125370-1-yaojiale02@163.com>

On Wed, Oct 28, 2026 at 01:02:44PM +0800, Jiale Yao wrote:
> rdma_dev_init_net() does not allocate an rdma_nets XArray entry or
> create compatibility devices for init_net.  rdma_dev_exit_net() still
> runs the common cleanup, using the zero-initialized rnet->id to hide and
> erase an entry and removing compatibility devices with that ID.  ID zero
> may belong to a non-default network namespace.

No, it can't

Thanks

> 
> Handle init_net separately on exit, mirroring the initialization path.
> Only tear down its netlink state and leave the XArray and compatibility
> devices untouched.
> 
> Fixes: 1d2fedd8561d ("RDMA/core: Support netlink commands in non init_net net namespaces")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jiale Yao <yaojiale02@163.com>
> ---
>  drivers/infiniband/core/device.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> index 29af9fe860e2..74460850ccba 100644
> --- a/drivers/infiniband/core/device.c
> +++ b/drivers/infiniband/core/device.c
> @@ -1153,6 +1153,11 @@ static void rdma_dev_exit_net(struct net *net)
>  	unsigned long index;
>  	int ret;
>  
> +	if (net_eq(net, &init_net)) {
> +		rdma_nl_net_exit(rnet);
> +		return;
> +	}
> +
>  	down_write(&rdma_nets_rwsem);
>  	/*
>  	 * Prevent the ID from being re-used and hide the id from xa_for_each.
> -- 
> 2.34.1
> 
