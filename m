Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.75
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795660386;
	b=1eFY/jvKIygCEZK/qG1sQ5czyb3gwISlUB6/kiY/USKrDvIE0g9Up1oNgk8oS1S+BYnG
	 9Yorfs1bLfMXPqxE7399wfsneQQFqvNKVbb8GW+jlkTxK9HZ7xC0H2aD7UFSdahX/Vfln
	 Yj3uAFVcMxTdJF3JzAUv8DYdTN13UbD69lp2baOqwK4WlBBwTg5YuL5ggIM6ZhgIOXKzZ
	 XnRyNDv34McsA02+0VTGLSrODO3pCZUfEzaxFWbE2ZETnjdb8MOo15EKr1N2jZH91kT4v
	 7DkCK5tEK6pimJga08I14NExVQkW7yYu5uWpNJeEMxOjHq6DHt3OGyTrAi5FIkUThuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795660386;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=HiD1u36Sh655aUUtC1qomsVPCJ8WLORnRRt/rJBwQhg=;
	b=xDIjFlRFGXGA+6UZ3/Q9PK+fm0wrc1v7SblSG7xQTp06S2OP0VFZe+y8KTW3D7UQTGXm
	 WnWeYOISWCgb7TiyFa/y9k7zzs3rSh3BzuQRfLZ4xAxQUKqTE2AE20F069G7fsTvtyVzk
	 8WvEMYldzXufbvnXSpIt0H3Aud+tp3qLLwtwwY83jx4Xt5yDcrzsQcf4lRf9Z5YBan+59
	 1FgBu6TyPdrSU4EN58A+LvA68NEQDlhid27U85TVzU0/UcPUyCUO92coAFPhjdAXfmnmo
	 Bykzdqq/LV3iqT3TlhQcwKa8Yxnx12rChOZ7o4Eaq6v7I0d7KHI0cliRklCnkgiCg/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LN07QGUu;
	arc=none smtp.remote-ip=91.218.175.75
Received: from mta0.migadu.com (out-75.mta0.migadu.com [91.218.175.75])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BA8606A321
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 02:33:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57BA8606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LN07QGUu
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=IMVdEzKWNpKOqlmEHdSpYMl54ZmgvLStDfPo/U9GPOg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795660383; v=1; x=1796265183;
 b=LN07QGUuW+4+FNVzKGfwCPNCb7Ht+B0T5ldYP0mYBMuuse+BUJZFKGd1JNMbH7GGqEIO7GN8
 LW3YljpBPrXAkHPNyDNidnf7iJ9FxnWmPxpaQxGljsOm2IESFuLjtiduW7aLUtcbuBBddba9On2
 zgdPM9OYyyc8Bgb6vq1zF8rw=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 10347b5feeec9f22;
	Thu, 26 Nov 2026 02:33:03 +0000
X-Mizu-Trace-ID: 10347b5feeec9f22
X-Migadu-Flow: FLOW_OUT
Message-ID: <2981e641-4f68-421c-b09e-fedc485e9cbb@linux.dev>
Date: Wed, 25 Nov 2026 18:32:59 -0800
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rdma-rc] RDMA/rxe: Zero the AtomicETH compare field in
 fetch-and-add requests
To: Andrew Stellman <astellman@stellman-greene.com>,
 Zhu Yanjun <zyjzyj2000@gmail.com>,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261125132605.44412-1-astellman@stellman-greene.com>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20261125132605.44412-1-astellman@stellman-greene.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2026/11/25 5:26, Andrew Stellman 写道:
> init_req_packet() fills the AtomicETH compare field for compare-and-swap
> requests but leaves it unwritten for fetch-and-add requests. The field is
> eight bytes in the transmitted packet.
> 
> With init_on_alloc=0, all 200 fetch-and-add requests captured between
> two rxe devices had nonzero bytes in that field, including printable
> text. After this change, all 200 had zero there. Compare-and-swap
> requests sent their compare value before and after the change.
> 
> Set the unused compare field to zero when constructing fetch-and-add
> requests.
> 
> The issue was found by Claude Opus 5.5 while checking rxe for other
> unzeroed memory, as Zhu Yanjun asked in his review of the rxe_mmap_info
> patch. The fix and this changelog were drafted with OpenAI GPT-6
> (Codex) and reviewed by me.
> 
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>

Thanks a lot. I am fine with this commit.
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>

Zhu Yanjun

> ---
> A reproducer is available on request.
> 
>   drivers/infiniband/sw/rxe/rxe_req.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
> index 4f353abd76f5..a1e7fa48c665 100644
> --- a/drivers/infiniband/sw/rxe/rxe_req.c
> +++ b/drivers/infiniband/sw/rxe/rxe_req.c
> @@ -483,6 +483,7 @@ static struct sk_buff *init_req_packet(struct rxe_qp *qp,
>   			atmeth_set_comp(pkt, ibwr->wr.atomic.compare_add);
>   		} else {
>   			atmeth_set_swap_add(pkt, ibwr->wr.atomic.compare_add);
> +			atmeth_set_comp(pkt, 0);
>   		}
>   		atmeth_set_rkey(pkt, ibwr->wr.atomic.rkey);
>   	}

