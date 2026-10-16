Received: from mta1.migadu.com (out-66.mta1.migadu.com [95.215.58.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DE1471CE4
	for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 12:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792153050; cv=none; b=N1pAkLcl//da6R0huNOQyrcroL3G/Rx+em3BQdvkBhqvn/7FsIE+4rSfCKlwTnwMAyg9mIsyhlXsxlOsppQE++Fhf6wMj0zKA4AMcihUQrIwhiMEDGlqct/EyHAnbmyjtgLHkA5FQHnnB69paygoubjv0/5DH77T1rTph4QvvNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792153050; c=relaxed/simple;
	bh=DAem93gFc4FtDkc44LklFXhKCt1vx53adKVHzsaWu54=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d7hw5/uF8ycas12Z/i2fBHC9G4Mre6XG50T1S21VO4Ghp70a/Yi/PNIiFGlrkmJjuuKP7UBV38te+KACDgA1We6kzopfAsOLXHKOSj0ystlBkTrNuOPvfYpY05bVwnxRSZXzqSGkanfRruCVl/g6/Q0jY4mXSq6yJS8WqHqQq2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PZJvz83r; arc=none smtp.client-ip=95.215.58.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PZJvz83r"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=DAem93gFc4FtDkc44LklFXhKCt1vx53adKVHzsaWu54=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792153045; v=1; x=1792757845;
 b=PZJvz83r2V3YeZ/o4oAdHShzAHJPBcjDDefi1NVu3SDBl0G0sTRI/18ZqtZ0B+pLj1DKMgPQ
 5LFhwMUu4SpCqQCbLw/ZUngkz+31kQBobHXT8/S26xCmjGMcSYZoDxsCE3KroGWpCReRcjxnWok
 5FjAV0GO3NUfJI81B8fwGJuc=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d90c56671d5fcd56;
	Fri, 16 Oct 2026 12:17:24 +0000
X-Mizu-Trace-ID: d90c56671d5fcd56
X-Migadu-Flow: FLOW_OUT
Message-ID: <4a0d6901-0099-4d49-b9a2-97b09cd6418a@linux.dev>
Date: Fri, 16 Oct 2026 13:17:20 +0100
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5e: Fix NULL deref in PTP TX timestamp
 recovery warn
To: Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>
Cc: Alex Lazar <alazar@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>,
 Cosmin Ratiu <cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>,
 Gal Pressman <gal@nvidia.com>, Kees Cook <kees@kernel.org>,
 Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
 Richard Cochran <richardcochran@gmail.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Shahar Shitrit <shshitrit@nvidia.com>
References: <20261015080218.1102172-1-tariqt@nvidia.com>
Content-Language: en-US
From: Vadim Fedorenko <vadim.fedorenko@linux.dev>
In-Reply-To: <20261015080218.1102172-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15/10/2026 09:02, Tariq Toukan wrote:
> From: Carolina Jubran <cjubran@nvidia.com>
> 
> PTP SQs are allocated via mlx5e_ptp_alloc_txqsq(), which never sets
> sq->channel. The excessive port timestamp delta recovery path
> incorrectly used sq->channel->netdev for netdev_warn(), causing a NULL
> pointer dereference. Use sq->netdev instead.
> 
> Fixes: 391dad2e686f ("net/mlx5e: Recover SQ on excessive PTP TX timestamp delta")
> Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
> Reviewed-by: Alex Lazar <alazar@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
> index 723f66a6bd63..2e1c3bb5a959 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
> @@ -98,7 +98,7 @@ static void mlx5e_skb_cb_hwtstamp_tx(struct sk_buff *skb,
>   		ptpsq->cq_stats->abort_abs_diff_ns += diff;
>   		if (diff > (NSEC_PER_SEC >> 1) &&
>   		    !test_and_set_bit(MLX5E_SQ_STATE_RECOVERING, &sq->state)) {
> -			netdev_warn(sq->channel->netdev,
> +			netdev_warn(sq->netdev,
>   				    "PTP TX timestamp difference between CQE and port exceeds threshold: %lld ns, recovering SQ %u\n",
>   				    (s64)diff, sq->sqn);
>   			queue_work(sq->priv->wq, &ptpsq->report_unhealthy_work);
> 
> base-commit: 513444cc62e231a11c9b15ea88de0890da9b2b4f

Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
