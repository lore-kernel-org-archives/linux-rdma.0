Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792473897;
	b=So1JUodSndUFwqdzt+A4Oklfi1Nt978r6NX8Dcf3qrEXq92zBDhwJHeKBvCYaDUlwmo6
	 u3yICCDL66R79ldBB0OBokEkF9a1L2+iPL5aSaFCQocxRy8w8IxXKVS3yGCHpWZaUDtoG
	 URhetu9dZGOC4YR2nv1rCaFXt0JsPDv+dW1AaCR5xyd2mJHNIwMpOLtcdc9l3nF5WuyVO
	 Wk/VoLOSEJwYqhuHJ+VNHSXIyhQ+2s87T6PBu+TVm3WmP73lLh3NgzOGSArsLkhPug+uk
	 YuaSeUBLX5+Dl/MtJAUSs78vLXqLBFWfJIXsJEqT0Jn2ZNewchnZxKHW6irCOEdtrZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792473897;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=WgU3tTWV6lbRlYg7TAKMkx9YxxtM8QnErb6eOW1atQA=;
	b=wR14XIgfsug2KyBOz+Gdy0ea0ncozzuyjWJ0HwMS6DTtchWYeIfNi2DP+B+qBOxUx6lS
	 +AMyNLN6kM/a7CXSl0gcV7i3VzjpG0vPEIBxi+ChcLtB03Y9jTWhH6CoGZbQn0Kah7IYP
	 Pswy8WXY0L0blav7jzWPTFy+E8XfM/8LVbgLzBqOq/fwOq7WmtoakwIQ6qWS3mB5kGBFL
	 vrvhRMv+d5NKsge+iU8V0zAKLaYQl2a/qp5E6kcHvrK2Em0v6v8PO89IlY2Y+UaI+3r0N
	 9Zifb2zfTUYZCFS9qBGTSQlKaAwl7Ob6fknHxWd8HVj0DP6uqBx5ObUD53T2dyfuYbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZcJNfbQe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFCB606A323;
	Tue, 20 Oct 2026 05:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZcJNfbQe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD82E1F000C4;
	Tue, 20 Oct 2026 05:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792473896;
	bh=WgU3tTWV6lbRlYg7TAKMkx9YxxtM8QnErb6eOW1atQA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ZcJNfbQeyLYuPCmogWo3MrvvThz3FwNrQTHxARegZ78meZEgrgW90wibqiMnS/0+N
	 gnpp/0yYS/k1LVcYoyIuzv7iN1PvdRJunPVftDuTdfxAdzgdt0ksYeKIsoVoOs6tQa
	 g+OI1QJdC7anLPaZ/Cuo5btD5F5WZb9e2w550dZb5VNJPRL5UMcKssU+GOdRlt6IhF
	 zTuVCFtzhgnKz1AgXg+HXalMY9KW+EvgANBGWqPL3XAdv7cHhrcUDX3arF63LWvr2M
	 3hf0Df+A2eqjebl6dE6iWIUDmkfDUBfTE4MUv6PftGDX14M97l5KsS3rTw3JPEAG2F
	 /XN2/pNBUMq6g==
Subject: Re: [PATCH net-next v1 2/4] net/mlx5: Don't free the WC test CQ if
 destroying it fails
From: netdev-bot+sashiko@kernel.org
To: oss.patchbox@gmail.com
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, lariel@nvidia.com, jianbol@nvidia.com,
 valex@nvidia.com, kliteyn@nvidia.com, igozlan@nvidia.com,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Tue, 20 Oct 2026 05:24:55 +0000
Message-ID: <179247389536.3135.6864822792166805555@kernel.org>
In-Reply-To: <20261016045849.813696-8-oss.patchbox@gmail.com>
References: <20261016045849.813696-8-oss.patchbox@gmail.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] net/mlx5: SQ DMA use-after-free due to dropped DESTROY_SQ error
- [Low] When DESTROY_CQ fails, mlx5_core_test_wc() now deliberately leaks
  the struct mlx5_wc_sq, the CQ frag buffer and the CQ doorbell record.

--

net/mlx5: Don't free the WC test CQ if destroying it fails

This patch makes mlx5_wc_destroy_cq() return the result of
mlx5_core_destroy_cq() and skip freeing the CQ buffer and doorbell record
when DESTROY_CQ fails. mlx5_core_test_wc() then also keeps the struct
mlx5_wc_sq that embeds the CQ instead of freeing it.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/wc.c b/drivers/net/ethernet/mellanox/mlx5/core/wc.c
> index 7d3d4d739e2cd..01e9800ff6fd9 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/wc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/wc.c

[ ... ]

> @@ -396,11 +401,13 @@ static void mlx5_core_test_wc(struct mlx5_core_dev *mdev)
>  	mlx5_wc_destroy_sq(sq);
>  
>  err_create_sq:
> -	mlx5_wc_destroy_cq(&sq->cq);
> +	/* An undestroyed CQ may still be in use; keep the SQ that holds it. */
> +	keep_sq = mlx5_wc_destroy_cq(&sq->cq);
>  err_create_cq:
>  	mlx5_free_bfreg(mdev, &sq->bfreg);
>  err_alloc_bfreg:
> -	kfree(sq);
> +	if (!keep_sq)
> +		kfree(sq);
>  
>  	if (mdev->wc_state == MLX5_WC_STATE_UNSUPPORTED)
>  		mlx5_core_warn(mdev, "Write combining is not supported\n");

[Severity: High]
The commit message argues that a failed DESTROY_CQ can leave the CQ
alive in firmware with access to its buffer and doorbell record. Does
the same argument not apply to the SQ that is torn down just before
this?

mlx5_wc_destroy_sq() frees the SQ work queue unconditionally after
asking firmware to destroy it:

	mlx5_core_destroy_sq(sq->cq.mdev, sq->sqn);
	mlx5_wq_destroy(&sq->wq_ctrl);

mlx5_core_destroy_sq() in transobj.c returns void and discards the
result of mlx5_cmd_exec_in(). A DESTROY_SQ failure, such as a command
timeout, is therefore never visible here.

sq->wq_ctrl.buf and sq->wq_ctrl.db are then freed while the SQ may
still be live in the device. Once that memory is reused, the device
could read whatever lands there as WQEs or doorbell values and issue
DMA based on it.

The err_modify_sq path in create_wc_sq() has the same shape. It calls
mlx5_core_destroy_sq(), and the SQ buffer is freed on the error return
whether or not the destroy succeeded.

This also seems to weaken the new keep_sq handling. The struct
mlx5_wc_sq is kept when DESTROY_CQ fails, but mlx5_wc_destroy_sq()
has already released its SQ buffer.

If DESTROY_SQ failed silently, an SQ still bound to the CQ might even
be what makes DESTROY_CQ fail. In that case the CQ buffer would be
carefully kept while the SQ buffer that firmware still references has
already been freed.

Fixing this properly looks like it needs mlx5_core_destroy_sq() to
return an error, which affects callers outside wc.c. Would you be
willing to cover that in this series, so mlx5_wc_destroy_sq() can keep
sq->wq_ctrl on failure the same way mlx5_wc_destroy_cq() now keeps
cq->wq_ctrl? Or should that be a separate fix?

[Severity: Low]
Could this leak the struct mlx5_wc_sq, the CQ frag buffer and the CQ
doorbell record again on every retry?

When mlx5_wc_destroy_cq() fails, sq, cq->wq_ctrl.buf and cq->wq_ctrl.db
are kept. Nothing records this, and mdev->wc_state is not changed.

wc_state is only set in mlx5_wc_poll_cq() when a REQ CQE arrives. If the
poll times out, or if mlx5_wc_create_sq() fails, it stays
MLX5_WC_STATE_UNINITIALIZED. The create_sq failure path is also where
DESTROY_CQ is most likely to fail.

mlx5_wc_support_get() only skips the test when wc_state has been set:

	if (mdev->wc_state != MLX5_WC_STATE_UNINITIALIZED)
		goto unlock;

So the next call runs mlx5_core_test_wc() again.

Userspace can reach mlx5_wc_support_get() repeatedly through mlx5_ib.
Examples are mlx5_ib_alloc_ucontext(), the WC page mmap path and the UAR
alloc uverbs method.

Suppose firmware keeps rejecting DESTROY_CQ while the create commands
still succeed. Would each of those calls then leak another sq struct,
another DMA-coherent CQ buffer and another doorbell slot, with no upper
bound? Before this patch these were freed, unsafely, on each run.

Would it make sense to latch wc_state when the CQ has to be kept, for
example to MLX5_WC_STATE_UNSUPPORTED, so the test is not retried?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261016045849.813696-6-oss.patchbox%40gmail.com
