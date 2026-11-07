Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794083089;
	b=fHmq8Gt4A68VO6HnzAz5y5Zm6xKGfGOrr3IEVN8cnVtEpT+JOv5CP9WWeZs7S9sxOlEf
	 ezQEvZaZNzc3946WGtxg+yVV5+A8PnDkYb4xT4dgLr1+fVXEWeDMNwTtnzuZRsY5KY8CT
	 42uY4ikzaKZItIXPfv3dFxNSdzkDUjoruDec7QU8z/xofFOIH4IOpNvtdUHDLKsB2qx9A
	 FYXPSBzdXoOnHCetc4KeROGO8mukCw8k1gwbXX6sDhgKXcczdan7xqneseqw0yfpxxHyo
	 A1NRipT6M8N9pF8fxb3ALIdQTKgivWQVTwfpfLz7BHp1VFeBfc/Ktlrz7YLCRkmW+Vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794083089;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Unnn47eIJH+VWHbuiao6Wl8xY049BGGS8bKARiEkrUk=;
	b=pT+ytLNJtsDqnRAfQSgQRzR/lUMp/lFa/M42hzivUx+H3pZ6KpqZRVtD/7C06M0mF4kK
	 xrQqw7Wh45j9xrgNZWVeKvffOZzJAf6igbF4i5spm4CUaRCAZZ4B1G3eSqP5F/T+yINeg
	 6WpkPok/xWp5E0xp5fmIltGRaXIsL2kR01pYgUZxYes6y/rQYbeOp5Q/UnHLSDpNl2uiC
	 /BBbgAIuNnnab6UFnXneRPE7J6JdudS5GgWN73O2gPzxuf5s+JVxpqrhVBg5RJgJqc1bJ
	 wV9XWeAwmzJ++MTnabDq0Z4UXwxu6nWZd8/0qPh8RBSRP8l6jYrhTo39rxuxZsqmqDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W0gpbalT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC10606A326;
	Sat,  7 Nov 2026 20:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W0gpbalT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24321F0089F;
	Sat,  7 Nov 2026 20:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794083088;
	bh=Unnn47eIJH+VWHbuiao6Wl8xY049BGGS8bKARiEkrUk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=W0gpbalT/l2tMx3qCy1scnm6UeLUU4v24bTnFhvTV/zYbp1lfSj09YOHe61A0jiVp
	 /WV7TMGigrAhkNjCLz+DBbVwMLUaIU5QnG4U1IKBKtYTe5t3lcyfsigCJW/FntZ7JJ
	 MgWkaSLmia5L0dJGAgmf3ZDIgEHtyhNXeP/XiCe7tgCu//g8i2SmgK2kvwz8RAEBCU
	 nqP8rphQG8sjk9bj1+9PtnF2+tJvMZPwrcYTaZ5LDqit6U084DiA7lSJN1KYPKF/jV
	 iDGweRpBWUbLFTReM+lnqJt3B8NWdbTL3UZ1sMP/I2EXPj5PQy6RpjVe1M44DNsYll
	 jBMWi4ZziBoJw==
Subject: Re: [PATCH rdma-next 06/23] RDMA/mlx5: Require IB_QPT_DRIVER for the
 DC vendor QP types
From: netdev-bot+sashiko@kernel.org
To: yishaih@nvidia.com
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org,
 netdev@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, kuba@kernel.org, pabeni@redhat.com, edumazet@kernel.org,
 davem@davemloft.net, andrew+netdev@lunn.ch, dtatulea@nvidia.com,
 moshe@nvidia.com, maorg@nvidia.com
Date: Sat, 07 Nov 2026 20:24:47 +0000
Message-ID: <179408308744.994134.2975103686531354002@kernel.org>
In-Reply-To: <20261103163949.1554-7-yishaih@nvidia.com>
References: <20261103163949.1554-7-yishaih@nvidia.com>
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The commit "RDMA/mlx5: Require IB_QPT_DRIVER for the DC vendor
  QP types" fixes a regression that userspace can trigger, but its…

--

RDMA/mlx5: Require IB_QPT_DRIVER for the DC vendor QP types

This patch changes process_vendor_flags() in drivers/infiniband/hw/mlx5/qp.c
so that it rejects MLX5_QP_FLAG_TYPE_DCI and MLX5_QP_FLAG_TYPE_DCT unless
the QP was requested as IB_QPT_DRIVER. Without this check, an RC/UC/UD QP
that carries a DC flag becomes a DC QP and skips the dct capability check
in check_qp_type().

> Accept the DC type flags only on IB_QPT_DRIVER, the type userspace
> uses to create DC QPs.
>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

[Severity: Medium]
Should this patch carry a Fixes: tag and Cc: stable? Userspace can reach
the behavior it fixes, and nothing in the message tells stable maintainers
to pick it up.

The problem seems to come from commit 37518fa49f76 ("RDMA/mlx5: Process
all vendor flags in one place"). That commit changed the guard around the
process_vendor_flags() call in the create path from:

    if (init_attr->qp_type == IB_QPT_DRIVER)

to:

    if (udata)

After that, the DCI/DCT type flags were processed for every user QP type.

Commit 7aede1a25f4b ("RDMA/mlx5: Store QP type in the vendor QP
structure") then made the switch in process_vendor_flags() write
qp->type = MLX5_IB_QPT_DCI or MLX5_IB_QPT_DCT directly. It still did not
check which type was requested.

>From then on, an unprivileged verbs user can create an IB_QPT_RC QP with
MLX5_QP_FLAG_TYPE_DCT set in the ucmd flags and get this path:

mlx5_ib_create_qp()
  check_qp_type()          <- dct cap only checked for IB_QPT_DRIVER
  qp->type = IB_QPT_RC;
  process_vendor_flags()
    qp->type = MLX5_IB_QPT_DCT;
  check_qp_attr()
  create_qp()

check_qp_attr(), create_qp() and the modify/query/destroy paths then
dispatch on the mlx5 qp->type. Meanwhile ibqp->qp_type still says
IB_QPT_RC.

Since this goes back to the 2020 refactor (v5.8), would something like
the following be appropriate?

Fixes: 37518fa49f76 ("RDMA/mlx5: Process all vendor flags in one place")
Cc: stable@vger.kernel.org

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261103163949.1554-1-yishaih%40nvidia.com
