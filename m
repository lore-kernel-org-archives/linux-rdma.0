Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3476D3176EB;
	Sun, 25 Jan 2026 14:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769350097; cv=none; b=oDy3WnGfuXF19XywpQq3BpFJsJn9mQGptBAlZIOnzujlDqWTASOgJiOcN0VPvqxP+MdHYmAixjUt0zC7a+uFfITAOwu4Yei10vQsoB0rNgIiJIyNV0wUw9z8FwxFYPDhJ7fWs8YbLP0d0y4Q0GxCYwhYtGL7dd23PATLCwHMkCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769350097; c=relaxed/simple;
	bh=6oFR07hwx2aOR9P/DfM7XQAgzTGPrrVCqYV/CLz3uWM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cr2/Vv4WOfBKhJmbqPAc9LyAtwDq9a+TLiHQwxPahyn8wRxr4WLK9ZVbD8T4WQXpNWk12u0WwZoWs6ADxbTuiIl0Ci8cIApVqEg0lcutXi7ktN4moA4FJEz8z3VUv3IEXcvEEU+X8ZEACddx+sNqYV9Ecyfi/kjVacI8Wt1z7Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kne4pSFN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kne4pSFN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61513C4CEF1;
	Sun, 25 Jan 2026 14:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769350096;
	bh=6oFR07hwx2aOR9P/DfM7XQAgzTGPrrVCqYV/CLz3uWM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Kne4pSFNf2/368M6oqaLQIQO1Vk/UJaj9t0K2ddBf+WiEyKW5i2bt96Ot9L1yKN7F
	 AFG1GHJx41udHfbxiLSsnpW9y2duz2dTFM6W6Vx0BfCqbkjfC7OVLbmgKD3xl/usP9
	 K7ta4krTYlaV1imUigts40Jt8xZFdx/R0n+kW52rLaTjAeTfXY3eqO/OB4LUdMFidw
	 wY/O10mO2at+CE4zd8IoaO/1v2FylS0WpJeWdVZb8Kc8MBOWm7UF4FCIr5GAgUD4uo
	 V7zy5xHLtdZfur9eDAvLmSHx0RtvTq1371BX2xANZDwKvWm5Ul0ozN4zqc8kuXw9kd
	 fLoPQwytt6Upg==
Date: Sun, 25 Jan 2026 16:08:12 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Li Zhijian <lizhijian@fujitsu.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	zyjzyj2000@gmail.com, jgg@ziepe.ca
Subject: Re: [PATCH] RDMA/rxe: Fix race condition in QP timer handlers
Message-ID: <20260125140812.GE13967@unreal>
References: <20260120074437.623018-1-lizhijian@fujitsu.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120074437.623018-1-lizhijian@fujitsu.com>

On Tue, Jan 20, 2026 at 03:44:37PM +0800, Li Zhijian wrote:
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
> The issue is caused by a race condition between retransmit_timer() and
> rxe_destroy_qp, leading to the Queue Pair's (QP) reference count dropping
> to zero during timer handler execution.
> 
> It seems this warning is harmless because rxe_qp_do_cleanup() will flush
> all pending timers and requests.
> 
> Example of flow causing the issue:
> 
> CPU0                                   CPU1
> retransmit_timer() {
>     spin_lock_irqsave
>                            rxe_destroy_qp()
>                             __rxe_cleanup()
>                               __rxe_put() // qp->ref_count decrease to 0
>                             rxe_qp_do_cleanup() {
>     if (qp->valid) {
>         rxe_sched_task() {
>             WARN_ON(rxe_read(task->qp) <= 0);
>         }
>     }
>     spin_unlock_irqrestore
> }
>                               spin_lock_irqsave
>                               qp->valid = 0
>                               spin_unlock_irqrestore
>                             }
> 
> Ensure the QP's reference count is maintained and its validity is checked
> within the timer callbacks by adding calls to rxe_get(qp) and corresponding
> rxe_put(qp) after use.
> 
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>

Fixes line?

Thanks

> ---
>  drivers/infiniband/sw/rxe/rxe_comp.c | 3 +++
>  drivers/infiniband/sw/rxe/rxe_req.c  | 3 +++
>  2 files changed, 6 insertions(+)
