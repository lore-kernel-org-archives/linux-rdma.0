Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794475037;
	b=ZkYm4a1qQi/2nrzU/rIBp62cFi+gxbUQhi9yvYt5tXpy3UB8PdLCfUuMogK4SNDaMauO
	 5adQPfRwc2wciWiDm8aNpJwtznO6A8Z6sIQkcDDJjk/TW72e59cn5cMqk2yl7sZaNjfA2
	 rItO/r6QSXucTsUCBdXRNy4MalkGKEJQUmfWZL7/Tr/3ZIzCYkjuNuviinMV7qVTCdWKH
	 I+TDPk84tilZAZJCue0sQWHX5SUfejazfcAJQO7c426evAkVJnZLTwQZ5pT91GBnrXn7S
	 wDVJp/YYQK1Elfx4awwtrKjnrosJhtSzeAv/fTJWBPdLhzfhX0lsMoAxhyeXC2QZVsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794475037;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=TpfKQ6rG8Wt3gju4As05ucJ2UDsSpfpZcchjxK/wBJM=;
	b=Gud8ItvsdjS9jFf7l5urEu+0TCDcGZ/RpFjBRaMb2m9WYOcsFSugae6A9aB4YrIqxXGk
	 V5G7i7fJnbrHXcm2QPPKHOD2C5oGlL0QWQqIUzaIQYE0fCf7m6Aw5hU0omZ7TZU0Jyszg
	 LgsDNVlLJx1CWMkC37M2StoYWvis9ZznXrzg9/J17N9AcyeyIT1zRVcIpqQUcr1eMlhzh
	 4Z5F1ZOMvy4HwHNAJUpPDROhvFQFQateakvV9BDIx2Gj5VW/Hxg0meP3jNNcNpxiOLsJf
	 DvQbMs2euImV0bz0naxbYYH8ZgMdszgBXJxqNVN4jfEQeFXx0842LonGdQlnV54TL6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KelS4Yzv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A149F606A321
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 09:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KelS4Yzv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A0D31F00A06;
	Thu, 12 Nov 2026 09:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794475037;
	bh=TpfKQ6rG8Wt3gju4As05ucJ2UDsSpfpZcchjxK/wBJM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KelS4YzvwdqW6zUkJ3mkr6ynVxK/nzn3O9aZhpgKDiJv8Z2wYgDloLGvTemG+7hQ/
	 e9Bl6bT82R2QSo9qsjCappiDqKfZSiKYAwFTjVyH0gHqdMesCW4Ggmrtj1I/1u9FFY
	 Qskfj7+dWOGTvbkXUM0CKlO28Sqi2jHbmfw6TUOekw+0lFQNcVRTOAPGlGhMZCHIYQ
	 xhKEuIh8iXXTve/RTtNSlcBqi4D+S+Mw4egeVnH8uGcgGPIMLS2KBs53JD0EKULrP7
	 5kdSKXQq0QUX3TLy1XxiRQXo7ww5vN3fCd88NVaqsfAim6wpeibjS2zL0ToVAapj8g
	 mkYLEC5JQ1NQg==
Message-ID: <sashiko-outbox-210859@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v11 9/9] RDMA/mana_ib: Handle error CQEs for
 kernel QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261112084716.1483342-10-kotaranov@linux.microsoft.com>
References: <20261112084716.1483342-1-kotaranov@linux.microsoft.com>
 <20261112084716.1483342-10-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 09:17:16 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] RDMA/mana_ib: wrong WC status in vendor_error_to_wc_error()
--

commit 3890146d1e1c2dc4555e62f3e8c6c195602b6f98
Author: Konstantin Taranov <kotaranov@microsoft.com>

RDMA/mana_ib: Handle error CQEs for kernel QPs

This commit decodes hardware error CQEs for kernel QPs, defers moving
errored QPs to the ERR state via a workqueue, and cleans up pending CQEs
when resetting or destroying kernel QPs.

> diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana=
/cq.c
> index 3d09ff5e5414c..24dca3b6e5bfc 100644
> --- a/drivers/infiniband/hw/mana/cq.c
> +++ b/drivers/infiniband/hw/mana/cq.c

[ ... ]

> @@ -37,12 +40,30 @@ static enum ib_wc_status vendor_error_to_wc_error(uin=
t32_t vendor_error)
>  	case VENDOR_ERR_TX_ATB_WQE_ACCESS_VIOLATION:
>  	case VENDOR_ERR_TX_ATB_WQE_ADDR_RANGE:
>  	case VENDOR_ERR_TX_ATB_WQE_CONFIG_ERR:
> +	case VENDOR_ERR_TX_RDMA_ATB_CMD_MISS:
> +	case VENDOR_ERR_TX_RDMA_ATB_CMD_IDX_ERROR:
> +	case VENDOR_ERR_TX_RDMA_ATB_CMD_TAG_MISMATCH_ERROR:
> +	case VENDOR_ERR_TX_RDMA_ATB_CMD_PDID_MISMATCH_ERROR:
> +	case VENDOR_ERR_TX_RDMA_ATB_CMD_AR_ERROR:
> +	case VENDOR_ERR_TX_RDMA_ATB_CMD_PT_OVF:
> +	case VENDOR_ERR_TX_RDMA_ATB_CMD_PT_LENGHT_MISMATCH:
> +	case VENDOR_ERR_TX_RDMA_ATB_CMD_ILLEGAL_CMD:
>  	case VENDOR_ERR_RX_ATB_SGE_ADDR_RANGE:
>  	case VENDOR_ERR_RX_ATB_SGE_MISSCONFIG:
>  		return IB_WC_LOC_PROT_ERR;
>  	case VENDOR_ERR_RX_ATB_SGE_ADDR_RIGHT:
>  	case VENDOR_ERR_RX_GFID:
>  		return IB_WC_LOC_ACCESS_ERR;
> +	case VENDOR_ERR_RX_OP_REQ:
> +		return IB_WC_REM_INV_REQ_ERR;
> +	case VENDOR_ERR_RX_ATB_RKEY_MISCONFIG_ERR:
> +	case VENDOR_ERR_RX_ATB_RKEY_ADDR_RIGHT:
> +	case VENDOR_ERR_RX_ATB_RKEY_ADDR_RANGE:
> +	case VENDOR_ERR_RX_REMOTE_ACCESS_NAK:
> +		return IB_WC_REM_ACCESS_ERR;
> +	case VENDOR_ERR_RX_INVALID_REQ_NAK:
> +	case VENDOR_ERR_RX_REMOTE_OP_ERR_NAK:
> +		return IB_WC_REM_OP_ERR;

[Severity: Medium]
Should VENDOR_ERR_RX_INVALID_REQ_NAK return IB_WC_REM_INV_REQ_ERR instead
of IB_WC_REM_OP_ERR?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112084716.1483=
342-1-kotaranov@linux.microsoft.com?part=3D9
