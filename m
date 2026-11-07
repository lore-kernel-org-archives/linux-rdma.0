Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794083092;
	b=PqkFT2tU8DLuHGlWCbi8kRaGoLalB4vc3/y9cs7Q9tmzz8j5LKL7G2E5HIUtmpHHkAAR
	 gQyr0jJmbJwOQjFet+IsRVKRE5M+gzohVezXgVfSvWVeqcMqO5jw3KOFUZ17v8G0JYUZI
	 duiUlyZkMAv2k6PXMSSILXFCOKTS1wrL5TXyPtEtqGoIA23806CddNRpX5oDghh9okDz+
	 vNZaoXNFc92qaEALfORikQzU1xvl4CZ6DKKkOh7OoLX0YDeUptgmxcWknyHdKlOC4hCgb
	 3mwY85/NAND0TP0lQZ2HWS5OasPYGEeT6Wz6vRzdaumtFCPsBQfdqQdd7vsASuLltLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794083092;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=WOhM+w1STmQwo8qIdMG+8r+QMqyOxbMdRrQAWnI8mck=;
	b=lpyTe15ZZcCtygFxatGBvsC0BrjbBwKL/snjjFB2JPpyIZxxiFNYZAw+pM8wZuNGFdTU
	 HjAbVCGm4j+PYZJHHUNvoATBRcYsoy/PX67Y7inzyXYS1nNmNk7cSLBWIRrk3YbJwDivm
	 R/rMqPP7zn+m7ZRLGQ7wc8dL3Nu7/Z3vy1odKPr1ku378cs/1jGZua+M8WbhbQjt2EcQp
	 vH16CdpnVgj+dTX5njgVal+bSOCm2wol41lClP7kpQsa3sVjOY9GC0kBKMs3za2TBKMdq
	 6n4jt+81QE1mmJkBCnx3ZX4g/DE9gaExEe3EKZguYBAtKeZFLO/FF9ZHvLWIMBokGNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nxpYVk1B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6D0606A33A;
	Sat,  7 Nov 2026 20:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nxpYVk1B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9035A1F0089F;
	Sat,  7 Nov 2026 20:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794083091;
	bh=WOhM+w1STmQwo8qIdMG+8r+QMqyOxbMdRrQAWnI8mck=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=nxpYVk1BsaTpOlhOv2fTrqx/L9Za5IGmTgS2eGO/tEk/6+kgXzGY3s+STHMgTbwyy
	 ZRJfQS1Tj37oWtSeXRL75nRZYZzRriPIyz1Cd7Mn5dwHSeoBUOuMTFw6nYLE6QGs6Y
	 S1SzbAH9y7/j1rMAO0u5baFHgMbx2fRLynORZc1bm/0lxoyxkuhrdoA4h6ehF3RDnJ
	 M3Vo78Y3xZOG9ZstSgd65cOFUYIf6g3QpkkjQVPTvkVyPcCDv2pHyPBkEHJLzGkBEp
	 zt4619J2OCqtXZ5aQFdy9SnScXM63FwVY0XmYeovlWWP1uupt3/9+ozQTmAk4xE0RA
	 7hNPC/b8U3VdQ==
Subject: Re: [PATCH rdma-next 08/23] RDMA/core: Suppress kverbs_provider for
 adversarial_mode devices
From: netdev-bot+sashiko@kernel.org
To: yishaih@nvidia.com
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org,
 netdev@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, kuba@kernel.org, pabeni@redhat.com, edumazet@kernel.org,
 davem@davemloft.net, andrew+netdev@lunn.ch, dtatulea@nvidia.com,
 moshe@nvidia.com, maorg@nvidia.com
Date: Sat, 07 Nov 2026 20:24:50 +0000
Message-ID: <179408309017.994134.8647675751240863438@kernel.org>
In-Reply-To: <20261103163949.1554-9-yishaih@nvidia.com>
References: <20261103163949.1554-9-yishaih@nvidia.com>
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

- [Low] At this commit, nothing in the tree writes the new struct
  ib_device::adversarial_mode field.
- [Low] Clearing kverbs_provider in ib_device_check_mandatory() for
  adversarial_mode devices does more than keep in-kernel ULPs off the…

--

RDMA/core: Suppress kverbs_provider for adversarial_mode devices

This commit adds an adversarial_mode field to struct ib_device. When the
field is set, ib_device_check_mandatory() clears kverbs_provider. After
that, add_client_context() only lets clients with no_kverbs_req (uverbs)
bind to the device, which keeps kernel ULPs off an untrusted NIC.

> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> index 29af9fe860e27..eb6aa567d3652 100644
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
> +		device->kverbs_provider = false;

[Severity: Low]
At this commit, does anything set ib_device->adversarial_mode?

mlx5 has its own module-global flag, set in mlx5_ib_init(), but this
commit does not copy it into the ib_device:

drivers/infiniband/hw/mlx5/main.c:
bool mlx5_ib_adversarial_mode;
...
	mlx5_ib_adversarial_mode = mlx5_is_adversarial();

So the field stays zero, this check never fires, and add_client_context()
still binds every kernel client. The commit message says "the kernel ULPs
never bind to the device", which is not true for this commit on its own.

The last patch in the series, "RDMA/mlx5: Advertise adversarial mode via
ib_device::adversarial_mode", adds this line to mlx5_ib_stage_caps_init():

	dev->ib_dev.adversarial_mode = mlx5_ib_adversarial_mode;

MLX5_IB_STAGE_CAPS runs before MLX5_IB_STAGE_IB_REG in all mlx5 profiles,
so the gate works once the whole series is applied.

The remaining problem is bisectability. Between "RDMA/mlx5: Block generic
CQ poll path in adversarial mode" and that final patch, kernel ULPs can
still bind in a CoCo guest while mlx5_poll_one() returns -EOPNOTSUPP. In
that window mlx5_ib_poll_cq() reports zero completions to every ULP CQ.

Could the patch that sets ib_dev.adversarial_mode be moved before the one
that blocks the CQ poll path?

[Severity: Low]
This also keeps umad and cma from binding, not just the in-kernel ULPs.
Only uverbs sets no_kverbs_req:

drivers/infiniband/core/uverbs_main.c:
	.no_kverbs_req = true,

so add_client_context() returns early for every other client:

	if (!device->kverbs_provider && !client->no_kverbs_req)
		return 0;

Without umad, no /dev/infiniband/umadN nodes are created for the device.

Without cma, the device never joins cma's device list, so ucma and
librdmacm cannot bind or resolve on it.

This looks intended, since the kernel MAD and CM layers interpret
device-supplied data. Should the commit message say that userspace MAD
and rdma_cm are not available on an adversarial_mode device?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261103163949.1554-1-yishaih%40nvidia.com
