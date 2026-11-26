Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795694590;
	b=g28RFDSlbwOpq8lxWBcDcT+P+j2QqAGlcx64HA0PnoM+oGXf+uUM7Uvikbl/cyXUP8HM
	 szm2cCkU9bwprM4sgoXvuRi683gZ8e2ETH5QGsGDsOJv0xycm/OsoNFjO0HpvF6A9Q7Wi
	 6eNNyGnzyKCsqtRcaXkpvIoMMORAKm+dpV5QQHP6qnDuWFKGM9I6IB7eaC1L23EzQhgV4
	 mU5ujtR0dl8PbWZEjERJ/xeG7gGagQ0u5X/cSTmIbE8NhaynacsXReRmFwsi7kKodh3/h
	 cxwfF2ZHafJWTIndVL+qtPB0oPjBlU7XwwTCEtkOuW8kK30vKffoJJos7zCQ0UwJx9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795694590;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=a07ecSlpXi9wvQQY4xjQ2z4aQOVr4EyrkPnouh99GpQ=;
	b=TZecNp9GJ5WjAjonZYvtVluzY9QY2Qms39/JphgzMzwf0sEDdSAjFSaz1OY57SvT3hUg
	 poYwy16vYcMC5AO3J5Yu4iMkbJLi2GwbGvfvBPe8nNOeyzxhNVqqnxsgRCELekU9P0cce
	 QtFxR8iwXab1DuGLQoM5VyjuN063UsSmUPoD2WMlYR1Ds2HhyC/QVNwovVH7zpd4coj6p
	 M9J43E8xZrXplwBPeH4EWapegYlUhROrEe+0NPSynl7RJ3amz/6VNzLLTd8LkucZ/OAwP
	 Uecz+HDZy+T1juSqL/gEvN/dnLf+V7DecOspwjt0ZrdI1hRLz4oYcu/qSmLfe+oII7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cd1N+w0e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7E3606A31E
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 12:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cd1N+w0e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B11B1F000D2;
	Thu, 26 Nov 2026 12:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795694590;
	bh=a07ecSlpXi9wvQQY4xjQ2z4aQOVr4EyrkPnouh99GpQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cd1N+w0etA8DQ6kiuRG/tm/p162xdXqmHJ5G9rfnFhDv9c2Xy+Mkf3bSaWJUOlqtd
	 xioCywPr5MaUTCvAdPnUHR6j0Yu74KyD7Z3DgnrDzFmeKhe/g3kqwGcUlMt7IrWWr3
	 oekU4/imFkRgEkSwhaenPAJ7Oz/cYYYGC0FoQ0z4SfNGIFJUuauIxn1OMWaYI/b8dm
	 kUClrub3JiphG3LEuqof3GaZCDETLApVlfjDa6FC68xY689l9Y6UxIXFN2ujeol+Xn
	 pbn+JDxqTjRNF4n/61IdCtAiQnAnqw93N5Z5VQARzAV7apTDkTQge2qjYZUIqnO9VY
	 L1vI8hfx3Bjeg==
Date: Thu, 26 Nov 2026 14:03:06 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Md Haris Iqbal <haris.iqbal@ionos.com>
Cc: linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
	Danil Kipnis <danil.kipnis1@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>
Subject: Re: [PATCH 7/9] RDMA/rtrs-clt: Back off the reconnect delay
 exponentially
Message-ID: <20261126120306.GI774860@unreal>
References: <20261123143719.938876-1-haris.iqbal@ionos.com>
 <20261123143719.938876-8-haris.iqbal@ionos.com>
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
In-Reply-To: <20261123143719.938876-8-haris.iqbal@ionos.com>

On Mon, Nov 23, 2026 at 03:37:17PM +0100, Md Haris Iqbal wrote:
> From: Danil Kipnis <danil.kipnis1@ionos.com>
> 
> A path that loses its link waits out the full, flat reconnect_delay_sec
> (30s on rnbd, + 0-8s jitter) before its first retry, and every retry
> after that, no matter how quickly the far end actually comes back.
> Nothing about that delay depends on how the path went down:
> rtrs_clt_err_recovery_work() runs the same way whether the trigger was a
> CM disconnect, a heartbeat timeout, or a port error, so a transient blip
> pays the same price as a genuinely dead fabric.
> 
> Start the delay at RTRS_RECONNECT_BACKOFF_INIT_MS (1s) after the first
> failure and double it on each further consecutive failure, capped at the
> configured reconnect_delay_sec, which becomes the steady-state ceiling
> rather than a constant. reconnect_attempts already counts consecutive
> failures since the path last came up and already resets to 0 in
> rtrs_clt_path_up() on success, so it doubles as the backoff step with no
> new per-path state. The existing anti-herd jitter (RTRS_RECONNECT_SEED)
> is kept as-is on top of every step. RTRS_RECONNECT_BACKOFF_MAX_SHIFT (8)
> only bounds the shift below reconnect_delay_sec's u8 range (max 255s);
> it is a safety margin, not a behavior knob.
> 
> Signed-off-by: Danil Kipnis <danil.kipnis1@ionos.com>
> Reviewed-by: Md Haris Iqbal <haris.iqbal@ionos.com>
> Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
> Signed-off-by: Md Haris Iqbal <haris.iqbal@ionos.com>
> ---
>  drivers/infiniband/ulp/rtrs/rtrs-clt.c | 35 ++++++++++++++++++++++++--
>  1 file changed, 33 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> index 54d72fa52cb1..7930039dcd32 100644
> --- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> +++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> @@ -34,6 +34,26 @@
>   */
>  #define RTRS_RECONNECT_SEED 8000
>  
> +/*
> + * Delay before the first reconnect attempt after a failure, doubled on each
> + * further consecutive failure and capped at reconnect_delay_sec. Lets a path
> + * that recovers quickly (a transient CM error, a brief port flap) start
> + * retrying off this short initial delay instead of the full configured
> + * delay, while a path facing a genuinely dead fabric still settles at the
> + * same steady state as before. RTRS_RECONNECT_SEED jitter is added on top
> + * of every attempt as before, so the actual first retry lands anywhere in
> + * [RTRS_RECONNECT_BACKOFF_INIT_MS, RTRS_RECONNECT_BACKOFF_INIT_MS +
> + * RTRS_RECONNECT_SEED).
> + */
> +/* Matches RTRS_RECONNECT_BACKOFF's value by coincidence, not by shared purpose. */
> +#define RTRS_RECONNECT_BACKOFF_INIT_MS 1000
> +/*
> + * Shifting RTRS_RECONNECT_BACKOFF_INIT_MS by more than this always exceeds
> + * reconnect_delay_sec's range (u8, so at most 255000 ms); capping the shift
> + * avoids relying on shift-by-large-amount being well defined.
> + */
> +#define RTRS_RECONNECT_BACKOFF_MAX_SHIFT 8
> +
>  #define FIRST_CONN 0x01
>  /* limit to 128 * 4k = 512k max IO */
>  #define RTRS_MAX_SEGMENTS          128
> @@ -1537,11 +1557,22 @@ static void rtrs_clt_err_recovery_work(struct work_struct *work)
>  {
>  	struct rtrs_clt_path *clt_path;
>  	struct rtrs_clt_sess *clt;
> -	int delay_ms;
> +	unsigned int shift;
> +	u32 delay_ms;
>  
>  	clt_path = container_of(work, struct rtrs_clt_path, err_recovery_work);
>  	clt = clt_path->clt;
> -	delay_ms = clt->reconnect_delay_sec * 1000;
> +	/*
> +	 * reconnect_attempts counts consecutive failures since the path last
> +	 * came up (rtrs_clt_path_up() resets it to 0), so it doubles as the
> +	 * backoff step: 0 failures so far -> the initial delay, each further
> +	 * failure doubles it, capped once it reaches the configured steady
> +	 * state delay.
> +	 */
> +	shift = min_t(unsigned int, clt_path->reconnect_attempts,
> +		      RTRS_RECONNECT_BACKOFF_MAX_SHIFT);
> +	delay_ms = min_t(u32, clt->reconnect_delay_sec * 1000,
> +			 RTRS_RECONNECT_BACKOFF_INIT_MS << shift);

Please avoid the min_t() and max_t() macros, as they implicitly cast
operands of different types. Use the correct types from the beginning.

Thanks

>  	rtrs_clt_stop_and_destroy_conns(clt_path);
>  	queue_delayed_work(rtrs_wq, &clt_path->reconnect_dwork,
>  			   msecs_to_jiffies(delay_ms +
> -- 
> 2.43.0
> 
> 
