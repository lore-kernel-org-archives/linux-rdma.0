Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794083099;
	b=aCqQOwp70g9Db4ZsEynm/Q2lKpjyw7jwttc03qpBJNNVgcNIwEDgQxgYUVo0QqMT7WYL
	 uMzW7OWj03M7rQFtOuZxUgIzSMdDlEZ9y3P2KrxwtCEa0WgG1hBGssg6XmWFgSTMXu0kF
	 riQxNud48MKEeD4XMat5CaxJfdETET9B8vdzTND9OCoBrqPwIBzVu7/85j6mxKCxUSgDR
	 ILu6T97d2TjLHeg/yve9T2A8nKqqcuT2eSXWzxsjRE1Oc/uRISU2TzJsMt1zG+RmNJ0LJ
	 5p6no+v4NQoSgpwZUJSFqYXCYeS79C7083Nux5lkD50Ws/aEYPF4EEF6O18RfMFw6wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794083099;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=4fCGgazJKFdZDmvhViTFIBsaBbB0idRarQju6kAmmNU=;
	b=dbut+bNA3I6lqdtPD25feOY8iXNzq2K+d9M/JBsu+yCLTPScp3s5Cm7lkP8c153OaDjL
	 /CuQkRwWdpGzj+Elo2MVawp9Z04ABye1bf0/mBpIeNFqcIwmoHgAOT7zHoVJaNQH+nKMc
	 97jH9AdzzGfIou3b5pU6WT9g8lgNBLMW0eomZTp0835DD9t3dg43Oosx3ZdULdT8a37Qr
	 t3TMlqozVGBvPLkUVPxqbjWA5/gg8q4dMrtPNGCYKG3jXUnU+hOmnaKApuQhXndRFRhc/
	 /uobQFyrzig3E3tbMXS7jTnXsppgvibGRx9R84cqX/0qayb8f5J5KpxXNKB1YtFbu0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Aa/S9TSY";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA75606D809;
	Sat,  7 Nov 2026 20:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Aa/S9TSY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C978A1F008A1;
	Sat,  7 Nov 2026 20:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794083098;
	bh=4fCGgazJKFdZDmvhViTFIBsaBbB0idRarQju6kAmmNU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Aa/S9TSYwDd1iVH3wltz6Mkfo0oW8Bw2MX3UMP8c8xJIQmmDNO5c9VRmfSNoI1ZTH
	 73iVGNG3HbHIWMXswydxCeby5yCQrQiry7AcMLfGxVrWonucmxg6A2qxfk0nU6mtHa
	 v0ztWmvK/Iyeh/LVJE3TaKy12WrcxY125GnmMQze4EXOhNk7HVeX8XYqPZOwoRn8aN
	 VZzB5o+oKgK7LCed37gGkZplEtdbuxCoE+Ifjq3WlCLWGGvz/mJ9wOoQkvd2+YTjhj
	 MWLiR11nnGDbWcus+VYeZbP40GgQ5IIg1EKCuq/N2iFqk7+IcqhB9EIiMrgOP+ivu2
	 Bi9Ar4+9Cmkxg==
Subject: Re: [PATCH rdma-next 14/23] RDMA/mlx5: Block generic CQ poll path in
 adversarial mode
From: netdev-bot+sashiko@kernel.org
To: yishaih@nvidia.com
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org,
 netdev@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, kuba@kernel.org, pabeni@redhat.com, edumazet@kernel.org,
 davem@davemloft.net, andrew+netdev@lunn.ch, dtatulea@nvidia.com,
 moshe@nvidia.com, maorg@nvidia.com
Date: Sat, 07 Nov 2026 20:24:57 +0000
Message-ID: <179408309736.994134.11736251866287600894@kernel.org>
In-Reply-To: <20261103163949.1554-15-yishaih@nvidia.com>
References: <20261103163949.1554-15-yishaih@nvidia.com>
X-sashiko-severity: Low
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

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The commit message and the new comment in mlx5_poll_one()
  (drivers/infiniband/hw/mlx5/cq.c) give the wrong example of the…

--

RDMA/mlx5: Block generic CQ poll path in adversarial mode

This commit makes mlx5_poll_one() return -EOPNOTSUPP when
mlx5_ib_adversarial_mode is set. The generic CQ poller trusts CQE
content, so with this change it never interprets a CQE from an untrusted
NIC. The UMR CQ is expected to use its own validating poll_one instead.

> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
> index 1a98263ec3111..5cc86c3f93f3e 100644
> --- a/drivers/infiniband/hw/mlx5/cq.c
> +++ b/drivers/infiniband/hw/mlx5/cq.c
> @@ -464,6 +464,15 @@ static int mlx5_poll_one(struct mlx5_ib_cq *cq,
>  	void *cqe;
>  	int idx;
>  
> +	/*
> +	 * This path trusts the CQE, so refuse it in adversarial_mode. Only an
> +	 * unexpected caller gets here, e.g. the uverbs POLL_CQ command or an
> +	 * event on the UMR CQ before its own poll_one is installed. Nothing is
> +	 * consumed, so such a CQE is left for that poll_one.
> +	 */

[Severity: Low]
Can the uverbs POLL_CQ command actually reach mlx5_poll_one() on mlx5?
The commit message uses the same example:

  "Refuse it there, so an unexpected caller, such as the uverbs POLL_CQ
  command, finds the CQ empty and no CQE is interpreted."

_ib_alloc_device() builds the default uverbs_cmd_mask without
IB_USER_VERBS_CMD_POLL_CQ. mlx5 never adds that bit; only bnxt_re and
rdmavt set it. As a result, uapi_create_write() disables the write
method:

drivers/infiniband/core/uverbs_uapi.c:uapi_create_write() {
    ...
	method_elm->disabled = !(ibdev->uverbs_cmd_mask &
				 BIT_ULL(def->write.command_num));
    ...
}

uapi_finalize_disable() then removes the method from the uapi tree. So
POLL_CQ doesn't appear to be reachable on mlx5.

The case that can be reached seems to be the UMR CQ during setup.
mlx5r_umr_resource_init() arms the CQ here:

	cq = ib_alloc_cq(&dev->ib_dev, NULL, 128, 0, IB_POLL_SOFTIRQ);

mlx5_ib_create_cq() sets cq->poll_one = mlx5_poll_one.
mlx5_ib_poll_one_umr is only installed later, after ib_create_qp() and
mlx5r_umr_qp_rst2rts().

If a completion event with a forged CQE arrives in that window, the
softirq poller calls mlx5_poll_one(). The earlier "Verify UMR CQ polling
against a hostile NIC" patch leaves this window open, and it looks like
the case this patch really closes.

The code comment mentions this window, but the commit message doesn't.
Could the commit message describe the UMR setup window as the case being
fixed? Could both the commit message and the comment drop the POLL_CQ
example?

The commit message also says:

  "kernel ULPs don't bind to the device"

ib_device::adversarial_mode is only set by the later "RDMA/mlx5:
Advertise adversarial mode via ib_device::adversarial_mode" patch. Is
that statement accurate at this commit?

> +	if (unlikely(mlx5_ib_adversarial_mode))
> +		return -EOPNOTSUPP;
> +
>  repoll:
>  	cqe = next_cqe_sw(cq);
>  	if (!cqe)

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261103163949.1554-1-yishaih%40nvidia.com
