Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792473895;
	b=FCN/52ANx1xUTRhpqZzuU4tOivAFcMyZ63egkaJ1crzjTwVOrMIH4DXKk3ck1ZSeZ9fG
	 3680E0Txz8hXjP4KQ0iLMSAQsEVmKHKDx2qeC9BRwUajXvcr6c/R71moSmFzByowN48Gs
	 Vv7/otVgrzy129uFaOAJLCnvv3dicGN7CwMT5W3xL9/V1SkN94OElUdUxB0Ykie6Wdvt8
	 a1Zc9Pn4/+9vs9Etlj80gg25cHeQpsG7y1Z5IHptLrhglWHpbVWBRfHvEwt5WVTq7sneh
	 y4PhHHEjtYPO54uYcgmfghpv0OgczTn0XjIcycUjWLOxkdiJO6oJbCLu8ohB0mvGnkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792473895;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Zbk8md/VajGgyoXOtenq3Hf7Rvp7VVE2/5h3BtiFt+E=;
	b=agu61CVdBOO2ayKSDoGw3MRQp3NyEQfbjvlk61AmEFtaxJ+0OTV7l5mJf1LCIILL1hYW
	 BbzBg+uXdjNYz7TKoCAMOkVLBgcYl5l4q0OeffwIHqxboA699bT4kXkVUOyKfv9snl62i
	 ZnMB59aFsaL6jnlH+2kt16xr+1gMRa78eqAyu3tmmjbC2dG9XgOm75plzl3NCVtUDLSJ7
	 LgTAK2oDFV4O223N77Qwc1IifjVtgWgren1ONuG/BeyRSLqF88xcM0dXqmB3OIXrvixEh
	 f4bWa40v0n3kjFIlvb2hewLFY6Ol3Q3ogAJVZvS6gquS9W5R/VLTIwDGCAkp9SwYtVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oDaH3PMU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6147A606A319;
	Tue, 20 Oct 2026 05:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oDaH3PMU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3813B1F000C4;
	Tue, 20 Oct 2026 05:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792473895;
	bh=Zbk8md/VajGgyoXOtenq3Hf7Rvp7VVE2/5h3BtiFt+E=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=oDaH3PMUSb9Jo49xFSRZW3jkPMblJosKs3mrT/X6hVX7aGPpF6MBeMxG/69rNiZXM
	 1YFdtQSInZ9AHP7lDVYvhviTfYUpjEOHQ5pdgV10vOpwdqHBDmMZq1/UgtU2s5dbKu
	 dsQV050DU82VKZNrAK2SWFNQ4yP6E0YNvavU+pSOsa8grOm7kKCiZsFo5fXmWcihv1
	 J2NVfkyFoFsRqhBzoJe4tviX+Rfc5qunT7+sThRmQo1t0kAlhOen7LE3sks7Sx0RWM
	 eUkIDfZiv6OqWl3BHGDv0gVor68dfwwYjXiLKm9e6+2ZYDWUcC2HclMnqY0mkkO+cr
	 YA+hx/viQs9+Q==
Subject: Re: [PATCH net-next v1 1/4] net/mlx5: Don't free the ASO CQ if
 destroying it fails
From: netdev-bot+sashiko@kernel.org
To: oss.patchbox@gmail.com
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, lariel@nvidia.com, jianbol@nvidia.com,
 valex@nvidia.com, kliteyn@nvidia.com, igozlan@nvidia.com,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Tue, 20 Oct 2026 05:24:53 +0000
Message-ID: <179247389372.3135.9984974260650452930@kernel.org>
In-Reply-To: <20261016045849.813696-7-oss.patchbox@gmail.com>
References: <20261016045849.813696-7-oss.patchbox@gmail.com>
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

- [High] The fix is incomplete within the same object.
- [Low] When DESTROY_CQ fails, the patch keeps the struct mlx5_aso and
  its CQ buffer and doorbell, but nothing ever frees them.

--

net/mlx5: Don't free the ASO CQ if destroying it fails

With this patch, mlx5_aso_destroy_cq() returns the status of
mlx5_core_destroy_cq() and no longer frees the CQ buffer and doorbell
record when DESTROY_CQ fails. When that happens, mlx5_aso_create() and
mlx5_aso_destroy() also skip freeing the struct mlx5_aso that embeds
the CQ.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
> index 614cd57a40d74..2d5f8cae6be19 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c

[ ... ]

> @@ -326,7 +330,9 @@ struct mlx5_aso *mlx5_aso_create(struct mlx5_core_dev *mdev, u32 pdn)
>  	return aso;
>  
>  err_sq:
> -	mlx5_aso_destroy_cq(&aso->cq);
> +	/* An undestroyed CQ may still be in use; keep the ASO that holds it. */
> +	if (mlx5_aso_destroy_cq(&aso->cq))
> +		return ERR_PTR(err);

[Severity: Low]
This may be intentional, but when this branch is taken the only pointer
to aso is dropped. Nothing frees the CQ buffer, the doorbell or the
struct mlx5_aso later.

mlx5_aso_destroy() has the same behaviour further down. It is still
declared void in lib/aso.h, so mlx5e_ipsec_aso_cleanup(),
mlx5e_macsec_aso_cleanup() and mlx5e_flow_meters_cleanup() cannot tell
that the ASO was kept. Each of them goes on to free its own state.

The commit message says keeping this memory is intended. The CQ context
only references the EQ, UAR, doorbell and PAS, so the callers freeing the
PD, MR or ctx afterwards does not affect the kept CQ itself.

Is a permanent leak the intended result here? Would it help to return
the status, or to warn, so the kept object is visible to callers?

>  err_cq:
>  	kfree(aso);
>  	return ERR_PTR(err);
> @@ -335,7 +341,9 @@ struct mlx5_aso *mlx5_aso_create(struct mlx5_core_dev *mdev, u32 pdn)
>  void mlx5_aso_destroy(struct mlx5_aso *aso)
>  {
>  	mlx5_aso_destroy_sq(aso);
> -	mlx5_aso_destroy_cq(&aso->cq);
> +	/* An undestroyed CQ may still be in use; keep the ASO that holds it. */
> +	if (mlx5_aso_destroy_cq(&aso->cq))
> +		return;
>  	kfree(aso);
>  }

[Severity: High]
Is the SQ in the same struct mlx5_aso still exposed to the problem this
patch fixes for the CQ? mlx5_aso_destroy_sq() runs first and always
frees the SQ WQE buffer and doorbell record:

drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c:mlx5_aso_destroy_sq() {
	mlx5_core_destroy_sq(sq->cq.mdev, sq->sqn);
	mlx5_aso_free_sq(sq);
}

mlx5_core_destroy_sq() in transobj.c returns void and ignores the result
of mlx5_cmd_exec_in():

void mlx5_core_destroy_sq(struct mlx5_core_dev *dev, u32 sqn)
{
	...
	mlx5_cmd_exec_in(dev, destroy_sq, in);
}

As a result, a failed DESTROY_SQ is never noticed. Then
mlx5_aso_free_sq()->mlx5_wq_destroy() frees the frag buffer that was
programmed as PAS in CREATE_SQ. It also returns the dbr slot to the
shared pgdir through mlx5_db_free(), and that slot can then be given to
another queue.

DESTROY_SQ can fail in the same ways DESTROY_CQ can: -ENOMEM from the
command message allocation, timeouts, or FW status errors. Only the
internal-error case is turned into success, and
mlx5_internal_err_ret_value() lists MLX5_CMD_OP_DESTROY_SQ alongside
DESTROY_CQ.

The ASO SQ is created with cqn = aso->cq.mcq.cqn, so an SQ that firmware
failed to destroy stays bound to the CQ. That is probably the most likely
reason for the following DESTROY_CQ to fail. In that case the new branch
keeps a struct mlx5_aso whose SQ DMA memory has already been freed. Can
the device then still DMA to freed WQE pages, or use a doorbell slot that
now belongs to another queue?

The create error path follows the same pattern:

mlx5_aso_create()
  mlx5_aso_create_sq()
    mlx5_aso_create_sq_rdy()
      mlx5_aso_set_sq_rdy() fails
      mlx5_core_destroy_sq()     <- result ignored
    err_free_asosq:
      mlx5_aso_free_sq()         <- SQ ring and doorbell freed
  err_sq:
    mlx5_aso_destroy_cq()        <- new CQ-only check

Because mlx5_aso_destroy() still returns void, mlx5e_ipsec_aso_cleanup()
also goes on to dma_unmap_single() and kfree() the ctx buffer that ASO SQ
WQEs target, even when the SQ may not have been destroyed:

	mlx5_aso_destroy(aso->aso);
	dma_unmap_single(pdev, aso->dma_addr, sizeof(aso->ctx),
			 DMA_BIDIRECTIONAL);
	kfree(aso);

Should mlx5_core_destroy_sq() return its status? The SQ buffer, doorbell
and struct mlx5_aso could then be kept when DESTROY_SQ fails, the same way
this patch handles the CQ.

The later patches in this series do not touch aso.c or transobj.c, so
this gap is still there at the end of the series.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261016045849.813696-6-oss.patchbox%40gmail.com
