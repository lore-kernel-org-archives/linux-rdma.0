Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794404294;
	b=ZkGB5ImfCy0zlnCzYY6x1bhCCoJS6rKsB2qwcW/EWSNx+rc0R/99Bc0+hw4DsAKULYPl
	 NqlRyslzNta1EwG8LUAeVYoxa8scn6dhio8QIOAyueBWCoeHsZAB0OAI4PMOgibGMl3xa
	 wzLEDUVwoWKcC9bJJZphgOTWDV4MwbffG2eyWGAn+ehgdYJcudUjyjcNdDWWZ0xm8+peh
	 mOm5seaT5qOXaR4O18z1RjFTN8lMIlrimqQNBHBOQDGLF7oohExDQFfyQxnvDz+FFfWEQ
	 mdB7Vgt8XMaOPva/z5f1oRUPpWdmUeYbLsms0lEZ8fn4RuYFrqrnT/G4+/+fNg4jfqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794404294;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=u5UXXfLjdcD8s36JEwM0JvoXfnr0525eeXKE1fUsHhA=;
	b=ZNjpndKC8671E0fXZMr352UG9NozPZas0sXYIZgJtoQYaRJJVo0Rxl3torfkz6mBRSf8
	 Dr0/BkDf5AD4q14GsU9ZG2DkCsCQYWJY9GO413TWQqIYLP/Iv1l2F/K/bKSuK5i9aEsa9
	 ee9M7pd0UC0qfDTZXEoi+r/n6+s5ckIaxFFcJ6Ys38Qk9dGEa3cwFqSdBXzAqC4JOfll8
	 /y45gK4ncSW/21j5JiGQ2vrFW7he6bGyz/kydSojYendup5pCRtwVQTm7wwhhYmg4LbOv
	 HDad0+tWNbXFsa1VHbshwa1eQXTV1sdyzUg3GcGlppgSKZzAJs9+SMNsXwaC8hka8yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dYWewhp+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C42606A32D;
	Wed, 11 Nov 2026 13:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dYWewhp+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F091F00A05;
	Wed, 11 Nov 2026 13:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794404294;
	bh=u5UXXfLjdcD8s36JEwM0JvoXfnr0525eeXKE1fUsHhA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dYWewhp+8DTAc7QQsC9lhI++VogBEsco6/bbPQoEzK2t+wYzgvvkyklkf6YL4Mb5C
	 XDQAy1cU0FqpvbveGG3zUhcc0R6tEiySV+V9CDtzusSosJl/oyGZu2h8jM7Za8GHtn
	 Eaa/ZklFLlFTt9QDce7aPzs2vP4h3Mvs3PP1f3F9nOZL/RfL7D3Jl/vqKi2Ad5Ffh6
	 woinDOICekSskNZSnFcHfNxsc/k3ke5NTlfQA/CSYD12gPr6je/UHwXgiOJPk/Fj8d
	 SjOrQfIxYiW9YhEsqdJWzFczQTn8RuG0eow7KASY4j/AQDrwjUk7Uqm92OOtsXXwoW
	 Pn9viK+BfTqlA==
Date: Wed, 11 Nov 2026 15:38:10 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Yuehong Wu <wuyuehong@cmss.chinamobile.com>
Cc: linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH rdma-rc] RDMA/ucma: free a queued CONNECT_REQUEST with
 its new context
Message-ID: <20261111133810.GS8635@unreal>
References: <20261109-ucma-conn-req-ctx-1-yuehongwu@cmss.chinamobile.com>
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
In-Reply-To: <20261109-ucma-conn-req-ctx-1-yuehongwu@cmss.chinamobile.com>

On Mon, Nov 09, 2026 at 11:20:00AM +0800, Yuehong Wu wrote:
> ucma_cleanup_ctx_events() only frees the events that belong to the
> context being destroyed.  A CONNECT_REQUEST uevent that has not been
> delivered to user space belongs to the listening context, but it also
> keeps the newly created connection context in uevent->conn_req_ctx, and
> that context is already reachable from user space because
> ucma_finish_ctx() published its id before the event was queued.
> 
> If user space destroys the new id while the event is still queued, i.e.
> before it fetches it with get_event, the event is skipped here and stays
> in the listener's event list with a pointer to a context that
> ucma_destroy_private_ctx() then frees.  Destroying the listener later
> (which is what closing its file does) reaches the
> uevent->conn_req_ctx->id lookup in the xa_cmpxchg() below with a
> dangling pointer, and when the freed context was reallocated the
> comparison can match an unrelated live context, which is then detached
> from the id table and freed.
> 
> The match in commit 8ae291cc95e4 ("RDMA/ucma: Do not miss ctx
> destruction steps in some cases") replaced "uevent->ctx == ctx ||
> uevent->conn_req_ctx == ctx" with a plain "uevent->ctx != ctx" test and
> lost the case where the new context is the one being destroyed.
> 
> Free the event in that case and return the backlog slot it consumed: it
> was never delivered to user space, so it can no longer be acted upon.
> 
> Fixes: 8ae291cc95e4 ("RDMA/ucma: Do not miss ctx destruction steps in some cases")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Yuehong Wu <wuyuehong@cmss.chinamobile.com>
> ---
> Validated in a QEMU/KVM guest running this tree with CONFIG_KASAN=y and
> CONFIG_RDMA_RXE=y.  A reproducer creates an rxe device, queues a
> CONNECT_REQUEST, sees it with poll() without fetching it, finds the new
> connection id by trying the small integer ids that belong to its own
> file, destroys that id and then the listener.  The unpatched kernel
> reports
> 
>   BUG: KASAN: slab-use-after-free in ucma_destroy_private_ctx+0x1c0/0x4f0
>   Read of size 4 at addr ff11000102295a00 by task c9repro/302
>   Allocated by task 12:
>    ucma_alloc_ctx+0x2b/0x170
>    ucma_event_handler+0x1ad/0x3a0
>   Freed by task 302:
>    ucma_destroy_private_ctx+0x468/0x4f0
>    ucma_destroy_id+0x180/0x1e0
> 
> With this patch the same sequence run four times produces no report, and
> a probe shows the queued event is dropped when the new context is
> destroyed.
> 
> Note: ucma_migrate_id() can move the new context to another file, which
> leaves its queued CONNECT_REQUEST in the original file's event list.
> That cross-file case predates 8ae291cc95e4 and is left for a separate
> fix.
> 
>  drivers/infiniband/core/ucma.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
> --- a/drivers/infiniband/core/ucma.c
> +++ b/drivers/infiniband/core/ucma.c
> @@ -534,8 +534,23 @@ static int ucma_cleanup_ctx_events(struct ucma_context *ctx)
>  	/* Cleanup events not yet reported to the user.*/
>  	mutex_lock(&ctx->file->mut);
>  	list_for_each_entry_safe(uevent, tmp, &ctx->file->event_list, list) {
> -		if (uevent->ctx != ctx)
> +		/*
> +		 * A CONNECT_REQUEST that has not been delivered to user
> +		 * space belongs to the listening context but also holds the
> +		 * new one. 

I don't understand this sentence. conn_req_ctx is created and added to
event_list at the same function without any conditions.

Please explain with function call chain how your claim is possible.

Thanks
