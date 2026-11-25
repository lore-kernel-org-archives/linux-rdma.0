Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795638839;
	b=U3H6qu1w2e+Ze615wXj5xQjCOZ+ewiKsijO35Jnjj17sc2k3jPl48f983/JfQFSEMu8s
	 ykB5lZ3vEfKb4SCfzsuwW8Uck/Mci60P3BlHO/ZnGwcpKAPo5cVp7bEbzhJxOv6cs6hA3
	 PfAy3E1wX4XbuRkQPz1njZPt8TpJepGs7LZ6GlwywBmmFgewM4FAf9NLcuF7kl94jKYJS
	 9OtBJ0m7QKQ39y3rKU01I7lEB+Fk7MlQR2wKfG/0PEN8GowgXv68CYTwOImzpuLHJE5tl
	 uLXBRM6ltw8sXrSg1gJfIMuoAzReeonK3x7DGCIO3ABR/wWrJ1qVn3TvPUhLxQzJ6Vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795638839;
	h=Received:DKIM-Signature:From:To:Cc:Subject:In-Reply-To:References:
	 Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ANh8y3HJAaHJLKduPLINj2dJygHOEpMXMM0zpKq2/2Q=;
	b=wv0zt8HHrPWqm+bsobMgkGGkUc1fvVwXzW1D5i5h/E9LYqqXg6PlcNGh7AxhyR5i0L7K
	 C/XdRp17AmD5QhfwvajdM/RdM2OFM9x7TofijlPlKTSbWzwlFObuQidmyV3KBm5BgZGOd
	 9s0Ae3Ln1h/b04fxe2y1+2z+RoaVDFWLUWTcdkgPJRyLuHN7vAD8cl0KNPqm75PTav91B
	 ILcN5wOR87x+Iu16JX9XSR+YhuLfYAy2HLI7pxHiiM6eZ5ZC5FW82S7eqYg5iC/V/KSKi
	 XLi6KxgEnxRY8bfdNLuKWVYlAg9dFbODVve8jNf1tc8KwxPmZ5+YlPPhkow0Vf2TyPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DHzfOI9E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547A3606A332;
	Wed, 25 Nov 2026 20:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DHzfOI9E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABDD21F000CA;
	Wed, 25 Nov 2026 20:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795638838;
	bh=ANh8y3HJAaHJLKduPLINj2dJygHOEpMXMM0zpKq2/2Q=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=DHzfOI9EHnabFLk9oQd27pLnF/AJFFlkbmxZbfzTPP7AMHDlnk9NXETc53fULAYCD
	 e/p/E3D48BeVf5UgL8Lz0nZOwcGoxW7jsNQctxfzLhVjpp5/Qd+Z6bam0HF+rzbRml
	 MQl6A4i0rpIxh6k5OTUNd9huZ8GjMRue5zvz4xKoNVpLpYJ63Ebjk9TNoisbwGm1BE
	 p7KNG4OXoJNbYJ4sePoODXnb67SL9Y6kbRiyTKSvZc7CjOF0JQ8EEAD4TDV0CFIi/E
	 IXiESH2MrkQYxaXEQqdxXNMSWBMfhosYP4iFmC0LZH15G1qqYyUO3I9DNFb/4TNnku
	 3FJt2ni2k4cyg==
From: =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To: netdev-bot+sashiko@kernel.org
Cc: magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, andrew+netdev@lunn.ch, ast@kernel.org,
 daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
 andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com,
 ilias.apalodimas@linaro.org, alexanderduyck@fb.com, saeedm@nvidia.com,
 tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org,
 michael.chan@broadcom.com, pavan.chebbi@broadcom.com, corbet@lwn.net,
 shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
 stuclar@meta.com, sdf@fomichev.me, horms@kernel.org, martin.lau@linux.dev,
 almasrymina@google.com, song@kernel.org, yonghong.song@linux.dev,
 jolsa@kernel.org, emil@etsalapatis.com, ihor.solodrai@linux.dev,
 rdunlap@infradead.org, kernel-team@meta.com,
 dimitri.daskalakis1@gmail.com, bobbyeshleman@meta.com,
 mohsin.bashr@gmail.com, kees@kernel.org, leitao@debian.org,
 maxime.chevallier@bootlin.com, cuitao@kylinos.cn,
 vadim.fedorenko@linux.dev, mike.marciniszyn@gmail.com, kuniyu@google.com,
 jiayuan.chen@linux.dev, mkarsten@uwaterloo.ca, razor@blackwall.org,
 dw@davidwei.uk, asml.silence@gmail.com, linux-rdma@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 13/15] eth: bnxt: Receive into XDP-only memory
 providers
In-Reply-To: <179561571294.3135.1261628874481958794@kernel.org>
References: <20261124125654.183091-13-bjorn@kernel.org>
 <179561571294.3135.1261628874481958794@kernel.org>
Date: Wed, 25 Nov 2026 21:33:55 +0100
Message-ID: <87jym0lkgc.fsf@all.your.base.are.belong.to.us>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

netdev-bot+sashiko@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider.
>
> Critical: 0 =C2=B7 High: 0 =C2=B7 Medium: 1 =C2=B7 Low: 0
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
>
> - [Medium] eth: bnxt: permanent RX queue stall when XDP-only FILL ring is
>   empty at setup
>
> --
>
>> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/eth=
ernet/broadcom/bnxt/bnxt.c
>> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
>> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
>> @@ -3969,7 +3951,8 @@ static int bnxt_alloc_rx_page_pool(struct bnxt *bp,
>>  	pp.dma_dir =3D bp->rx_dir;
>>  	pp.max_len =3D PAGE_SIZE << pp.order;
>>  	pp.flags =3D PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV |
>> -		   PP_FLAG_ALLOW_UNREADABLE_NETMEM;
>> +		   PP_FLAG_ALLOW_UNREADABLE_NETMEM |
>> +		   PP_FLAG_ALLOW_XDP_ONLY_NETMEM;
>>  	pp.queue_idx =3D rxr->bnapi->index;
>>=20=20
>>  	pool =3D page_pool_create(&pp);
>
> [Severity: Medium]
> With PP_FLAG_ALLOW_XDP_ONLY_NETMEM, rxr->page_pool can now be backed
> by the AF_XDP sink, and the sink takes its buffers from the userspace
> FILL ring. What happens if that ring is empty when bnxt fills the RX
> ring?
>
> bnxt_alloc_one_rx_ring_skb() breaks out of its loop on the first
> bnxt_alloc_rx_data() failure. With an empty FILL ring, rx_prod is
> left at 0, and rx_agg_prod is left at 0 by
> bnxt_alloc_one_rx_ring_netmem(). bnxt_queue_mem_alloc() still returns
> success, and bnxt_queue_start() rings the doorbell with nothing
> posted.
>
> As far as I can tell, bnxt only refills RX buffers from bnxt_rx_pkt()
> while it handles a completion. With no descriptors posted, the NIC
> never produces a completion. When userspace later fills the ring and
> xsk_sink_wakeup() schedules NAPI, __bnxt_poll_work() finds no work
> and returns without allocating, so the queue stays wedged.
>
> This is the normal AF_XDP order: bind first, then populate FILL.
> xsk_sink_bind() expects it by setting need_wakeup, and
> testapp_stats_fill_empty() in this series exercises it. It can also
> happen on netdev_rx_queue_reconfig(). There, new_mem is allocated
> before the old queue's buffers go back to the sink, so FILL can be
> dry at that point even if userspace keeps it topped up.
>
> Does bnxt need a refill pass at the end of NAPI poll when the RX ring
> is short, like mlx5 and fbnic have? Or did you have another way in
> mind to prime the ring for an XDP-only provider?

This is how bnxt fills its rings today. Rings stop at the first failed
allocation with a warning, and after that refills one buffer per
completion.

devmem and iouring zcrx feed works the same way. A ring that starts
empty never fills, wakeup or not. If it starts short, it stays short (I
think!)

But... a sink makes an empty start likely as FILL can be dry when the
queue restarts while bound. The docs says FILL before bind, but that
only cover bind.

I'll add a refill pass for rings with page pool providers, so it covers
devmem and iouring zcrx as well.
