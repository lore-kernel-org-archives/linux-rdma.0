Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794819501;
	b=FIeK+UJPl/jlESR8QvugYoctN+jqlU86b++DQxrWXZuQwbZGuQX/4OTLhFXReX9mpboz
	 ZLuml/BtGCzuSze33TMHA1hmzIewuUhgqifE4JRUeGRA3LL/JrbL/TOuX4Rgp63RjYVaQ
	 hFp8o/6EpOQx9gnkxOXbvarvusrxJ6PsWvT9ur5SMxXU9Kmo/vdTMxCXvpWDaSV7oTN3/
	 xVY0uqvvan/O/19hB4JE36zWav35yiNDv8ycBYWFdE/L+bH+cd8bIXfzxpbVlmP4zQunu
	 wyUNipEvxkfxEUARiywFKEMwv/6iSB3dPGX4/7s3leTVK0w5zRTDXFwLbviGqB1iVGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794819501;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=jTw0z7j7ixfVgy+ekqc6oztblUCg4IwIkezDOKgUmN4=;
	b=KwHrtaWYbdc0i5zGknGJ+UC2hiMdlie6w5zXvoRKsYPw9KB38CqWZYLlZo6gYlovie+w
	 hp5tjwJCZ5diAWym1+ojNmIwfokeRgfghuyQjYJW3Fo8HlXPNprO124c82B9VchL638+C
	 gOLWq3l4zqf8bT2i0+m5xmQbBxmk4T1K2x8yFmtAUzVbZ9rWGWZ+Sad7Vc5Rw88yelaiS
	 S0MMwIHv/pDnSkmIfgWXZqxLbTVAtntWhpRuYTAIPRHr6swgKf9LA0EP8Rd5o+trV+3fv
	 OJqINnFqgjuTpWBx4PBidawitWaVOhwu8BWQ2YuDVBtiwZefwzFFiiJ8u8dA1NDr0lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CgVlUaF1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA48606A323;
	Mon, 16 Nov 2026 08:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CgVlUaF1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D96981F000C4;
	Mon, 16 Nov 2026 08:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794819500;
	bh=jTw0z7j7ixfVgy+ekqc6oztblUCg4IwIkezDOKgUmN4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CgVlUaF1I9JnRZg+RLy+Vozz7/TOpmafLYsbHg0XbUEBhqHcJhfQ9nPO7DYkfiMRv
	 W9loe2mlpjbfkvsHlgxDHsDVexDgI4z2JTDUu3z7Sbyl59D8Rr6ft2CN8kpbJgrgcl
	 rxZ4IwX/uCsZjd4pDPv0fQtAfv61rRIIncj2HcPPQ7juuTFMMlxsWwaO0PhUrxLtaV
	 63RjdPgQW0v3npHqOFgAL0two/L7PwHqtB/dpiIcSWxPwjEoXt51HHCvszG6oOTN8h
	 5oify4pElaLQxDH/cXuV+4TVsCInFggJP9Ze5zShnFtStO5TvLAP1Kn5oAxWg4kmXE
	 7Ytj+W/DmJYDQ==
Date: Mon, 16 Nov 2026 10:58:17 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
	saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com,
	kuba@kernel.org, pabeni@redhat.com, edumazet@kernel.org,
	davem@davemloft.net, andrew+netdev@lunn.ch, dtatulea@nvidia.com,
	moshe@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V1 rdma-next 09/24] RDMA/core: Suppress kverbs_provider
 for adversarial_mode devices
Message-ID: <20261116085817.GB11319@unreal>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-10-yishaih@nvidia.com>
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
In-Reply-To: <20261110134320.34408-10-yishaih@nvidia.com>

On Tue, Nov 10, 2026 at 03:43:05PM +0200, Yishai Hadas wrote:
> In adversarial mode the NIC is not trusted. Kernel ULPs such as MAD,
> IB CM, rdma_cm, IPoIB, SRP, iSER and NVMe-oF trust what the device
> reports, its completions and the data it writes, so they must not use
> such a device.
> 
> Add an adversarial_mode field to struct ib_device and clear
> kverbs_provider when it is set. add_client_context() then skips every
> client but uverbs, the only one that sets no_kverbs_req, so the kernel
> ULPs never bind to the device.
> 
> The driver still implements the kverbs ops, as the uverbs path shares
> them, so kverbs_provider can't be cleared by the existing check of the
> mandatory ops.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/infiniband/core/device.c | 8 ++++++++
>  include/rdma/ib_verbs.h          | 2 ++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> index 29af9fe860e2..eb6aa567d365 100644
> --- a/drivers/infiniband/core/device.c
> +++ b/drivers/infiniband/core/device.c
> @@ -312,6 +312,14 @@ static void ib_device_check_mandatory(struct ib_device *device)
>  			break;
>  		}
>  	}
> +
> +	/*
> +	 * Kernel ULPs must not bind to an adversarial_mode device. Its kverbs
> +	 * ops are still present, as uverbs uses them, so clear kverbs_provider
> +	 * explicitly. uverbs sets no_kverbs_req, so it still binds.
> +	 */
> +	if (device->adversarial_mode)

In previous patch, you talked that adversarial is global for all
devices, but here you add per-device flag.

Thanks

> +		device->kverbs_provider = false;
>  }
>  
>  /*
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index d6eaa3fee66e..6209a5166f0d 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -3008,6 +3008,8 @@ struct ib_device {
>  	u16                          use_cq_dim:1;
>  	/* CoCo guest with DMA bounce buffering required */
>  	u16                          cc_dma_bounce:1;
> +	/* Untrusted-NIC, adversarial mode is required */
> +	u8			     adversarial_mode;
>  	u8                           node_type;
>  	u32			     phys_port_cnt;
>  	struct ib_device_attr        attrs;
> -- 
> 2.18.1
> 
