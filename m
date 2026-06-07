Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E30D3FFD;
	Sun,  7 Jun 2026 19:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780860738; cv=none; b=o0MH487FbDDj53CoDYLeoOUylyW+qnnwMSpAqSYGLafp7WhN1zKzKAqT3scn/Sbz73DyVgcLi5JnkGbycL4kLefyt0190eQqdFyzJqxqOQPPhDmjS7o7FoDnyGsifPJhhbKlom8i2AxM0qJpkz5yIAVA8vTnFBE59j0lgawINZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780860738; c=relaxed/simple;
	bh=0CL0LpYY71PFAf0+GCT4CUN73l3MpK4SmyHk3tTPOu0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tpJsN/KbqrqGtcyYJIg4dVt5yPwoLzssgxnfblnkqeBslW4Zk8LS08wwg2DjrPUV1GnXzTIl64nPYSIsfyvfWIgmLqr2s5YgPWGsCtQxE+GYMyKO9pSN21gDcKJSODKEXbeYzUPcRHBQjkBo1TGYPPK6yjuBll8b7ZlgqXvFn8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d85Promd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d85Promd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A12041F00893;
	Sun,  7 Jun 2026 19:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780860737;
	bh=Ha9Hmh5rF02wsMuPsCKqS/tkDi5MaZZ5kGu0z2TbIb0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=d85PromdyaTj834q9gv73RnZggzjtGaVKJPmm9PrtzkOVLGVpNUztSQhHqoDiXwDC
	 6jhUtvc0rANu+eKFBud0pZ3NIodrLrL4CeNf8D85ByOrthFnv89/obfYz8tnR0NsNE
	 JoICLGJWqRXjICtrt7KcdQP3kZ6JKwxNPV1KN8AZWauL/pevUmd5pZGDiss2Rk3yt1
	 9XlJIHyH8+aUt5PKXjXfkYpLKcsx/adwmcxkezZiax2i2gTlxfPUxiR2PtFUG7F9sp
	 qW+fyDKIlRcIF9jEdPjah+1Iwr9Ym1MVkZ/QhbRdBhpQ8PB1AjuLBqdqk8ztnIr4Qx
	 ZQJL9Ygfhdt2g==
Message-ID: <73dcc08ff744364c097ec63bf81a26bd15e8f2af.camel@kernel.org>
Subject: Re: [PATCH net] net/rds: fix NULL deref in
 rds_ib_send_cqe_handler() on masked atomic completion
From: Allison Henderson <achender@kernel.org>
To: Weiming Shi <bestswngs@gmail.com>, netdev@vger.kernel.org
Cc: Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>, Eric
 Dumazet <edumazet@google.com>, "David S . Miller" <davem@davemloft.net>, 
 linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, Xiang Mei
 <xmei5@asu.edu>
Date: Sun, 07 Jun 2026 12:32:15 -0700
In-Reply-To: <20260606192447.1179255-2-bestswngs@gmail.com>
References: <20260606192447.1179255-2-bestswngs@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sat, 2026-06-06 at 12:24 -0700, Weiming Shi wrote:
> rds_ib_xmit_atomic() always programs a masked atomic opcode
> (IB_WR_MASKED_ATOMIC_CMP_AND_SWP or IB_WR_MASKED_ATOMIC_FETCH_AND_ADD)
> for every RDS atomic cmsg.  But the completion-side switch in
> rds_ib_send_unmap_op() only handles the non-masked opcodes, so a masked
> atomic completion falls through to default and returns rm =3D=3D NULL whi=
le
> send->s_op is left set.  rds_ib_send_cqe_handler() then dereferences the
> NULL rm via rm->m_final_op, oopsing in softirq context.  An unprivileged
> AF_RDS sendmsg() of an atomic cmsg over an active RDS/IB connection
> triggers it; on hardware that natively accepts masked atomics (mlx4,
> mlx5) no extra setup is needed.
>=20
>   RDS/IB: rds_ib_send_unmap_op: unexpected opcode 0xd in WR!
>   Oops: general protection fault [#1] SMP KASAN
>   KASAN: null-ptr-deref in range [0x0000000000000190-0x0000000000000197]
>   RIP: rds_ib_send_cqe_handler+0x25c/0xb10 (net/rds/ib_send.c:282)
>   Call Trace:
>    <IRQ>
>    rds_ib_send_cqe_handler (net/rds/ib_send.c:282)
>    poll_scq (net/rds/ib_cm.c:274)
>    rds_ib_tasklet_fn_send (net/rds/ib_cm.c:294)
>    tasklet_action_common (kernel/softirq.c:943)
>    handle_softirqs (kernel/softirq.c:573)
>    run_ksoftirqd (kernel/softirq.c:479)
>    </IRQ>
>   Kernel panic - not syncing: Fatal exception in interrupt
>=20
> Handle the masked atomic opcodes in the same case as the non-masked
> ones: they map to the same struct rds_message.atomic union member, so
> the existing container_of()/rds_ib_send_unmap_atomic() body is correct
> for them.
>=20
> Fixes: 20c72bd5f5f9 ("RDS: Implement masked atomic operations")
> Reported-by: Xiang Mei <xmei5@asu.edu>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Weiming Shi <bestswngs@gmail.com>

Hi Weiming,

Thanks for the thorough writeup, I've traced through the logic and the
fix looks correct to me as do the tags.  Thanks for catching this!

Reviewed-by: Allison Henderson <achender@kernel.org>
Allison

> ---
>  net/rds/ib_send.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/net/rds/ib_send.c b/net/rds/ib_send.c
> index fcd04c29f543..d6be95542119 100644
> --- a/net/rds/ib_send.c
> +++ b/net/rds/ib_send.c
> @@ -170,6 +170,8 @@ static struct rds_message *rds_ib_send_unmap_op(struc=
t rds_ib_connection *ic,
>  		break;
>  	case IB_WR_ATOMIC_FETCH_AND_ADD:
>  	case IB_WR_ATOMIC_CMP_AND_SWP:
> +	case IB_WR_MASKED_ATOMIC_FETCH_AND_ADD:
> +	case IB_WR_MASKED_ATOMIC_CMP_AND_SWP:
>  		if (send->s_op) {
>  			rm =3D container_of(send->s_op, struct rds_message, atomic);
>  			rds_ib_send_unmap_atomic(ic, send->s_op, wc_status);

