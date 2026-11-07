Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794083110;
	b=AYKkZ1AWxS29pZCMfYa836SOq7DY+1BZ05bdfgNGvMoqagXqp7rKKql3+Y+ehk7OyCsp
	 a/ikLKOicR/bRHTdXdG8J0OJvin/OdXJ+dBV1Ex+TQrcHLynGHcSRNbRGXL980jm4rWPx
	 g48QDNWjBG+En5s8xvCpPNaLFZ+/xhEwHAzEwAqLYgIQ6yH4N5PrHyfxIjWc7xR7DEktD
	 /ztVXH5BMBNV8WUQOLmAcWCIAxGX6OwkcIJzIlBzJMD1eex+bzT5zlS0BCk7FCCkjpRqa
	 B8NnmEarjxO548BTo80DcSAtWi24ybb1GEizqj0chIa1CG95QBwbJWnxU9Xxf8Yhvgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794083110;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=QrM0wRuxSi6AkZLyXsOroSJYFNWLYb5pdHSFzXTWJt4=;
	b=wD359lA1Rf6OYp3hafZsCe6IRyiS3AQHVr93FkTelsi9D9hcxSkRaImBfc0MAuJNRfP7
	 jb/PDZJpWDT9GP2n/LGhy5dh5I+9ncB0C651KPAdwpnxNE+Abtiv9pxcIr+s2ag81hAwB
	 4N/wH/5AOhzn6FIJ7frSdmBQbRRmEpK2nX6MO+Gz8SOWjPu4DJKBMc+AjzxBvKYsrfoFe
	 KeA3aoLCip7x5vDY5qgIAqMJj4qiktyHxADxMyEFS0RlVoFLY9CpjsIMoD5T94WkF7cXr
	 70QgFQQPWT52BCUjFcAj33BdKvVBMSWFycjBa+6WRA4QsDQ6r0+h6jF6cquMJat0NIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bE6to7pg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4022C606EEA8;
	Sat,  7 Nov 2026 20:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bE6to7pg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522451F008AB;
	Sat,  7 Nov 2026 20:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794083110;
	bh=QrM0wRuxSi6AkZLyXsOroSJYFNWLYb5pdHSFzXTWJt4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=bE6to7pgL3r+A1eEEGASfb3u4fs1J1os4O8Sto7Keg7cxUtLpkYRb0sKIgkM9j4Dq
	 ApBf+sH7S4usCjMi/pX86Cj1Z3YDzeNybVsti4xfybK7SwVYRdq1RJCKy5oaiUwSf1
	 Hte+YQaxJ1cSSjgvLcmScEcHblpAJvIq3zXMJi7vSkHuVTVKSYTEHlBVSsSPcvDak6
	 JEB5MQLVnHcnrJKLdTnGvqY0uG6jiD3pQjocFnbgNwk84QJ1oDKyEeuMXwV5uIX4p/
	 RCzOX3yD7p7rbmwGmzKPEUGGauo47v91xAAedILjH4eUEk15nUSp382n8R+NtaDwGE
	 aA3W+PgcbEU1Q==
Subject: Re: [PATCH rdma-next 23/23] RDMA/mlx5: Advertise adversarial mode via
 ib_device::adversarial_mode
From: netdev-bot+sashiko@kernel.org
To: yishaih@nvidia.com
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org,
 netdev@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, kuba@kernel.org, pabeni@redhat.com, edumazet@kernel.org,
 davem@davemloft.net, andrew+netdev@lunn.ch, dtatulea@nvidia.com,
 moshe@nvidia.com, maorg@nvidia.com
Date: Sat, 07 Nov 2026 20:25:08 +0000
Message-ID: <179408310891.994134.2389971836310893033@kernel.org>
In-Reply-To: <20261103163949.1554-24-yishaih@nvidia.com>
References: <20261103163949.1554-24-yishaih@nvidia.com>
X-sashiko-severity: Medium
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

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The series is not bisectable on confidential-computing (CoCo)
  guests.
- [Low] The commit message understates what this one line does.

--

RDMA/mlx5: Advertise adversarial mode via ib_device::adversarial_mode

This commit sets ib_device::adversarial_mode from the
mlx5_ib_adversarial_mode global in mlx5_ib_stage_caps_init(). The uverbs
core can then report adversarial mode to rdma-core and only let
adversarial-mode-aware userspace open a context on the device.

> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index ace4cdc95c9da..f8af90941b53d 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -4778,6 +4778,7 @@ static int mlx5_ib_stage_caps_init(struct mlx5_ib_dev *dev)
>  	}
>  
>  	dev->ib_dev.use_cq_dim = true;
> +	dev->ib_dev.adversarial_mode = mlx5_ib_adversarial_mode;

[Severity: Medium]
Can the series still be bisected on CoCo guests when this assignment
comes last?

An earlier patch, "RDMA/mlx5: Derive mlx5_ib_adversarial_mode global from
mlx5_core adversarial API", sets the global in mlx5_ib_init():

    mlx5_ib_adversarial_mode = mlx5_is_adversarial();

This comes from cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT), so it is true
on any SEV-SNP/TDX guest.

Next, "RDMA/mlx5: Block generic CQ poll path in adversarial mode" adds
this to mlx5_poll_one():

    if (unlikely(mlx5_ib_adversarial_mode))
        return -EOPNOTSUPP;

That patch says this is safe because kernel ULPs don't bind to the device.

However, kernel ULPs only stop binding once ib_device_check_mandatory()
sees the core flag:

    if (device->adversarial_mode)
        device->kverbs_provider = false;

mlx5 doesn't set ib_dev.adversarial_mode until this commit.

That leaves a window from the CQ poll blocking patch up to "RDMA/core:
Report and enforce adversarial mode via GET_CONTEXT". In that window,
kverbs_provider stays true for mlx5 on a CoCo guest.

add_client_context() then binds MAD, CM, rdma_cm, IPoIB, SRP, iSER,
NVMe-oF and the other clients. Their CQs use mlx5_poll_one():

mlx5_ib_poll_cq()
  cq->poll_one() == mlx5_poll_one()
    returns -EOPNOTSUPP

mlx5_ib_poll_cq() stops at the first non-zero return, so it always reports
0 completions. Wouldn't MAD sends time out, the IPoIB TX ring fill up, and
NVMe-oF/SRP I/O hang in those intermediate commits?

In the same window, legacy rdma-core would still get contexts, and uverbs
POLL_CQ would always come back empty.

Could this assignment move into the patch that enables the driver-side
mode? Another option is to place it right after "RDMA/core: Suppress
kverbs_provider for adversarial_mode devices", before any hardening patch
that changes behaviour. Either way, every commit in the series would keep
working.

[Severity: Low]
This isn't a bug, but the commit message only says:

    Set ib_device::adversarial_mode during capability init so that the
    uverbs core layer can report adversarial mode to rdma-core and enforce
    that only adversarial-mode-aware userspace opens a context on this
    device.

In practice, this line turns on the full adversarial policy for every
mlx5 ib_device on a CC_ATTR_GUEST_MEM_ENCRYPT guest. The pf, raw_eth/rep
and plane profiles all run MLX5_IB_STAGE_CAPS.

With the flag set, ib_device_check_mandatory() clears kverbs_provider.
add_client_context() then skips every client that lacks no_kverbs_req:

    if (!device->kverbs_provider && !client->no_kverbs_req)
        return 0;

Only uverbs has no_kverbs_req. As a result, MAD, ib_umad, IB CM, SA,
rdma_cm, IPoIB, SRP, iSER, NVMe-oF, NFS/RDMA, RDS and SMC-R no longer
bind.

Because cma and SA never bind, librdmacm users going through ucma can't
use the device either, even if they are adversarial-aware.

Unmodified rdma-core also gets -EPERM, both from GET_CONTEXT and from the
legacy write() path.

There is no opt-out, since the decision comes only from
cc_platform_has(). Other patches in the series say this is intended, but
this commit is where it takes effect for mlx5.

Could the commit message say that, once this is applied, kernel ULPs and
rdma_cm-based userspace stop working on mlx5 in CoCo guests?

>  
>  	return 0;
>

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261103163949.1554-1-yishaih%40nvidia.com
