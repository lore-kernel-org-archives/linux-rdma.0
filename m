Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795360267;
	b=f36PE5iT/Xxqcvx2fKcJtS08Exz5nH0qrYNrs7y44tewPY9B1VxMaRKb6TM25l/5VgbB
	 +qs8xX8YcUslIWHxbXOgf/HvHBdG3UL+RwsIIqJiM/J7eMXaKkQf6iMB855RtOx3KxIYq
	 8slLeO6ww2OKJ19eQZnyW2cPffEqpkVW8P4wOK/ezhZhO+ZWJEb59v5aIWCYSre81GkQT
	 t3ZRiRbjKyFI01IKCLQV1dsOssUyvXFKfZjRZW95wC1P6rS1yM5q7AbSav3uMr9kbrrLq
	 AzAYnM5SqWSEYyhQ9zgBsCvx1qzwjph3ttZ0K/bgi7R44KhpL1G3ID4HOBwX8svzXOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795360267;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=oOWBSdyd+P5qWrZDjnKbpdol/JRbqjn1lfFsp2nJQyY=;
	b=DSehlpykBqXbK13ocKIUSlZTWRdReiqtcR3R8kukAavUEKcGAPC+Zc8f9joSQsC98aP4
	 uWAC6pRQKhYm3YoPcYv3zgx49ieI/Kw1c+erGqeV4uoEzcOw7Ia5uwXn8hsWgYxQ8Ixs1
	 2hqaZU7BAW0VY7EKVQuGgHxuveuJHMpi9/UBAe3/e9WFiaOlY57Q2+ZJCoA4sMznD3UiC
	 insecOF4sWD3s30dLXZ6G9MaeHQyVvrBOzIjlUhKJjTEq6tXEmdJ60EU5k/fMlnS/PVS3
	 9l3BUVqPVXtGYKS2bm6NKPYaaC9wFuy3aRUns4u0B18MlTYLxoMfLz06+z9IcLpteQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Odvu/MGQ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFADF606A331;
	Sun, 22 Nov 2026 15:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Odvu/MGQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 983ED1F000C6;
	Sun, 22 Nov 2026 15:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795360267;
	bh=oOWBSdyd+P5qWrZDjnKbpdol/JRbqjn1lfFsp2nJQyY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Odvu/MGQXMbmVSh1r29XhHH1y8pi6g8thjfk0rqprRhwXKs2xjudDUTiOjguOYa10
	 fu7a7ySnjw2aYPnOGP3RCMBYSxJjdsac19Y8dNz290/puAsI14XLeslJwmWaFNLU/d
	 1D/mfJRcVxiyZBGy3a0amD8O48NX+W8hTP/B5My8MWUlsUNRCIHI2ndj7Z4HpACJbX
	 uj0xVE0dtCFWLYBMRAREZu46R/1au24w+qn4NHG6q88ses2dAaEeZmPKuGKL4lUlCF
	 6HmWjjAilEmZ/C/Lbi603stl3Ec+fEFF+rwZI5aq3K1WhzU6CEco+tDoXDf4ed18Wh
	 t6+BSm2g2aLEQ==
Date: Sun, 22 Nov 2026 17:11:03 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Andrew Stellman <astellman@stellman-greene.com>
Cc: Zhu Yanjun <zyjzyj2000@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH rdma-next] RDMA/rxe: Require a responder resource for
 FLUSH
Message-ID: <20261122151103.GG14811@unreal>
References: <20261119151332.95466-1-astellman@stellman-greene.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119151332.95466-1-astellman@stellman-greene.com>

On Thu, Nov 19, 2026 at 10:13:32AM -0500, Andrew Stellman wrote:
> process_flush() keeps its state in a responder resource from
> rxe_prepare_res(), as READ and ATOMIC requests do. check_resource()
> refuses those requests when max_dest_rd_atomic is 0, but it does not
> check FLUSH. With max_dest_rd_atomic 0, qp->resp.resources is
> ZERO_SIZE_PTR, and rxe_prepare_res() writes through it in
> free_rd_atomic_resource().
> 
> A FLUSH sent to an RC QP with max_dest_rd_atomic 0 oopses the
> responder:
> 
>   KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
>   Workqueue: rxe_wq do_work
>   RIP: 0010:free_rd_atomic_resource+0x15/0x50
>   Call Trace:
>    rxe_receiver+0x5f6e/0x9a20
>    do_work+0x144/0x470
> 
> The responder task dies, and destroying the QP later warns on a timeout
> in __rxe_cleanup() and then hangs.

Please resend this patch with untrimmed dmesg stack trace.

Thanks

> 
> Add RXE_FLUSH_MASK to the check, so a FLUSH gets the same Invalid
> Request NAK a READ would, and the requester sees IB_WC_REM_INV_REQ_ERR.
> 
> The issue was found by Claude Opus 5.5 running Quality Playbook, an
> LLM-driven code review tool:
> https://github.com/andrewstellman/quality-playbook
> The fix and this changelog were drafted with the same tool and reviewed
> by me.
> 
> Fixes: ea1bb00ee9a5 ("RDMA/rxe: Implement flush execution in responder side")
> Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>
> ---
> 
> Tested in QEMU with KASAN on v7.4-rc3, and on v7.4-rc3 with the RDMA
> code from rdma for-next (7404c82cbf12). The reproducer is a short
> libibverbs program; I can send it off-list.
> 
>  drivers/infiniband/sw/rxe/rxe_resp.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
> index 1b7f31737225..38b5b0c2abe3 100644
> --- a/drivers/infiniband/sw/rxe/rxe_resp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_resp.c
> @@ -340,7 +340,8 @@ static enum resp_states check_resource(struct rxe_qp *qp,
>  {
>  	struct rxe_srq *srq = qp->srq;
>  
> -	if (pkt->mask & (RXE_READ_OR_ATOMIC_MASK | RXE_ATOMIC_WRITE_MASK)) {
> +	if (pkt->mask & (RXE_READ_OR_ATOMIC_MASK | RXE_ATOMIC_WRITE_MASK |
> +			 RXE_FLUSH_MASK)) {
>  		/* it is the requesters job to not send
>  		 * too many read/atomic ops, we just
>  		 * recycle the responder resource queue
> 
> base-commit: 7404c82cbf1246e0e84e2ec21834d23c26f9a8ed
> -- 
> 2.43.0
> 
> 
