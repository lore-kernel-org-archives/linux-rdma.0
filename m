Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795107023;
	b=4/ZlRtpaft7BD43MkEyrU8FaGgOGmknFCYOKD0yJjL3I8UmYSQffxD4POK0DSWp3XSx4
	 QVgtX8T9WiX5T5n7bvgPfqNQKGUcDWcyherpeelMhlPeY1KBOvSqrJnDeYMOUDCCLt1zS
	 koW5wBwmIuW3qHXc6e6uD5Bk4JLjV58vC70nEzvdrxNva72DG0aC4EWmnmJ8Mb+QfOPGQ
	 H9/9jR4B481PqEjTRc66Q+KwCRX7q5H4yyR5BaYGBHFWAPHs1WrNBK8UMRnGZp6QRXPb7
	 khkUm1yZPyRPw3804JprOKD5isjHqGE/C63QUrDhWm9vK62W5HdmuSRAv+PSwCvbXjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795107023;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=hUa6qtyR+bKsAjDIc2Frk2r+gPhHATaP3VnRqdLJXZc=;
	b=CKvYpFkpds9M6sMmEXgK3Hc72bBm3EpAPRdbM1XBFw/wwQAcd0koDwU8GXwbUlRtI9kJ
	 QxehI+2w5gDw9OYcYnR7D/rrpjvVEM/2JUDBCA/MCPx5/e2AmFYSELJScBF5Vnj8Bwaxu
	 pDJX3p7n9WRhH1bVoY1G4LJyvhXjFRM9n3vlNyR9fLwrERBbFgakpP7vgb/ciOWrQPzNH
	 Nqtc7r6qoxJ22oHGgNrjRNtVP/6XatHFpSESRs1caHIHtLG/3a0u0zPy+BZm4pQc4Np1I
	 4Nsq2pSbuYUY5il8Sr1xuKcvP6hfUh9BovnYEb+E2e7lIsrd0daoYBrn+CQ1pMCk1yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="iVHon8/h";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C6060A2601;
	Thu, 19 Nov 2026 16:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iVHon8/h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EEF31F000C5;
	Thu, 19 Nov 2026 16:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795107023;
	bh=hUa6qtyR+bKsAjDIc2Frk2r+gPhHATaP3VnRqdLJXZc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iVHon8/hQ0lCib8xtzWqtEYQnvShVsVRaKPJyMC9Zr4szBXFQjfBUp9xP5GPRKHpc
	 lyCd4M7E36MoVUsr8CdhJhxF5tFWNwrbmb2MuRbvVSvlt5GZJ3NMI4PAQROQgp3FbH
	 sktGMeK84iyJujHGF5T1+z8ToYq21E4T4XBPTyooDO05KegTTTwTZbFnf0ANu2zWf2
	 250FOM4RzwP3e7C9kflNE3XKIicGLM2FpDzX7VOgtmqbfa0Jno6RmOwEXrXUMkqx3w
	 Yb+V52OQGzyQTXA8cHiYAwA7YaWBY1GjRgSiC9HWTrT6XDkHyHCcxramFJR5g74bAA
	 AJ4YfEaHkLNPQ==
Date: Thu, 19 Nov 2026 16:50:16 +0000
From: Simon Horman <horms@kernel.org>
To: Haiyang Zhang <haiyangz@linux.microsoft.com>
Cc: linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Wei Hu <weh@microsoft.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Aditya Garg <gargaditya@linux.microsoft.com>,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Manish Awasthi <mawasthi@linux.microsoft.com>,
	Breno Leitao <leitao@debian.org>, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, paulros@microsoft.com,
	stable@vger.kernel.org
Subject: Re: [PATCH net] net: mana: Set 1 usec / 1 comp as default and
 minimum interrupt moderation
Message-ID: <20261119165016.GA860048@horms.kernel.org>
References: <20261113204427.1922848-1-haiyangz@linux.microsoft.com>
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
In-Reply-To: <20261113204427.1922848-1-haiyangz@linux.microsoft.com>

On Fri, Nov 13, 2026 at 12:44:04PM -0800, Haiyang Zhang wrote:
> From: Haiyang Zhang <haiyangz@microsoft.com>
> 
> The existing code sets interrupt moderation defaults to 0 usec and 0
> completions, which may cause CQ starvation of our NIC HW, and TX time
> out error like:
> mana 7870:00:00.0 ens1: NETDEV WATCHDOG: CPU: 14: transmit queue 4 timed out 63434 ms
> 
> To fix, change the default and minimal rx/tx usecs and frames to 1.
> When the HW supports interrupt moderation, reject ethtool rx/tx usecs
> and frames below 1.
> Also clamp the values written by mana_gd_ring_dim() to [1, max], so
> no caller, including the DIM work, programs a zero value.
> On the HW without interrupt moderation support, do not request CQ
> moderation, the usecs and frames stay at 0, and cannot be modified by
> ethtool.
> The PF capability is queried again when the device resumes from a
> reset or suspend, so re-initialize these settings before re-attaching
> the vPorts.
> 
> Advertise this change to the PF with the new driver capability flag
> GDMA_DRV_CAP_FLAG_1_SET_MIN_INTR_MOD_VALUE.
> 
> Cc: stable@vger.kernel.org
> Fixes: 433f482add31 ("net: mana: Add Interrupt Moderation support")
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  .../net/ethernet/microsoft/mana/gdma_main.c   |  5 ++
>  drivers/net/ethernet/microsoft/mana/mana_en.c | 76 +++++++++++++------
>  .../ethernet/microsoft/mana/mana_ethtool.c    | 26 +++++--
>  include/net/mana/gdma.h                       |  6 +-
>  include/net/mana/mana.h                       |  9 ++-
>  5 files changed, 88 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> index ab942d5bfe05..10be69e97ceb 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> @@ -646,6 +646,11 @@ void mana_gd_ring_dim(struct gdma_queue *cq, u32 mod_usec, bool mod_usec_vld,
>  	struct gdma_context *gc = cq->gdma_dev->gdma_context;
>  	u32 dim_val;
>  
> +	mod_usec = clamp_t(u32, mod_usec, MANA_INTR_MODR_USEC_MIN,
> +			   MANA_INTR_MODR_USEC_MAX);
> +	mod_comps = clamp_t(u32, mod_comps, MANA_INTR_MODR_COMP_MIN,
> +			    MANA_INTR_MODR_COMP_MAX);

mod_comps is u32 and MANA_* are positive constants.
I believe that clamp() is sufficient here. And if so it's preferred.

That notwithstanding, this looks good to me.

Reviewed-by: Simon Horman <horms@kernel.org>

...
