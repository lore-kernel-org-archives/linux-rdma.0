Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F422DC35F;
	Wed, 28 Jan 2026 10:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769595916; cv=none; b=duUNUzLVrXxswnMkAtd1iqcK72TmpD4EdNDaGpmQlfUVr0l7P4FbZ9HnYWTgMKsqid/Dl46wT/AYxwxuzp+bpfJGQI32U8iW6NLTg/NilorKdjBl+zxZmsYQ0FOykf1ZtEqwGf8RnBJmWk2zdzQzCEUejVW6j7uodd20a+HQ9VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769595916; c=relaxed/simple;
	bh=dzl0aSJisa0yEWxjSxLPS6VD8xhxf55JGzx0Uswr2+c=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ojrtYf7j3XwxtBSysQPb+M9javMMDH9LIMsjXBes0akj7gdoNSiQBpj7ExDIUI5gJy/unrOgpN74qv22/vFmILdlWc2hjqxaQsV3qLaJyOezBhAAIC6OJMmFtSfHU9x13vK6o4mOQV+/bWxfXbI1K/EmD+tfaD301qFKX+/qeRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=muoELubT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="muoELubT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E170AC4CEF1;
	Wed, 28 Jan 2026 10:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769595916;
	bh=dzl0aSJisa0yEWxjSxLPS6VD8xhxf55JGzx0Uswr2+c=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=muoELubTbsiVUEuOAAxhn9L4aeSfaMQf5y873imj8vtEl0225Yy14XjZhnU1bQeUa
	 cLxOn4ET05PpZfar3X5DI8Lqrnv7fU6XcidMqBDUCvDFCt2cF5O60H/dKobaoYqx+P
	 7Y/ramM/jHmoVWPdYs1RB9ZqQVcdq8BRZMm2ZhRfeEmMVYzH6nRM21f+HzRDjnq1pW
	 qgFlAH0AijfMtCDkdqP5AxCJvRYGv9Km7h4EXvTszIltR/NGrblP4XtLvtbrjPdDoi
	 qXHw7fl7fyz+c1JNSKDu1UImP6By8N8ZXpVQq96RL9ireCgjMvVeZTXIhRo+uDp1cj
	 VihN09BOvPb7g==
From: Leon Romanovsky <leon@kernel.org>
To: linux-rdma@vger.kernel.org, Li Zhijian <lizhijian@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, zyjzyj2000@gmail.com, jgg@ziepe.ca
In-Reply-To: <20260120074437.623018-1-lizhijian@fujitsu.com>
References: <20260120074437.623018-1-lizhijian@fujitsu.com>
Subject: Re: [PATCH] RDMA/rxe: Fix race condition in QP timer handlers
Message-Id: <176959591332.19472.2038436434809316961.b4-ty@kernel.org>
Date: Wed, 28 Jan 2026 05:25:13 -0500
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-47773


On Tue, 20 Jan 2026 15:44:37 +0800, Li Zhijian wrote:
> I encontered the following warning:
>  WARNING: drivers/infiniband/sw/rxe/rxe_task.c:249 at rxe_sched_task+0x1c8/0x238 [rdma_rxe], CPU#0: swapper/0/0
> ...
>   libsha1 [last unloaded: ip6_udp_tunnel]
>  CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Tainted: G         C          6.19.0-rc5-64k-v8+ #37 PREEMPT
>  Tainted: [C]=CRAP
>  Hardware name: Raspberry Pi 4 Model B Rev 1.2
>  Call trace:
>   rxe_sched_task+0x1c8/0x238 [rdma_rxe] (P)
>   retransmit_timer+0x130/0x188 [rdma_rxe]
>   call_timer_fn+0x68/0x4d0
>   __run_timers+0x630/0x888
> ...
>  WARNING: drivers/infiniband/sw/rxe/rxe_task.c:38 at rxe_sched_task+0x1c0/0x238 [rdma_rxe], CPU#0: swapper/0/0
> ...
>  WARNING: drivers/infiniband/sw/rxe/rxe_task.c:111 at do_work+0x488/0x5c8 [rdma_rxe], CPU#3: kworker/u17:4/93400
> ...
>  refcount_t: underflow; use-after-free.
>  WARNING: lib/refcount.c:28 at refcount_warn_saturate+0x138/0x1a0, CPU#3: kworker/u17:4/93400
> 
> [...]

Applied, thanks!

[1/1] RDMA/rxe: Fix race condition in QP timer handlers
      https://git.kernel.org/rdma/rdma/c/87bf646921430e

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

