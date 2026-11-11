Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794397061;
	b=diKNV3UKcahoLTeVGgvHGaDKThO7p3fsk9h+MMWyU155ZtR1WBTJVADOS7rgPZE5FSMp
	 dcJ5WqxYGHIJM5ECfOLaXkT44ehuP1KS+umGOXlxJvd8m6sPPvz6M4vnykF2l8L8/c08T
	 AfpZevts58KMV72eohzdmqfT+sRdsxQDYwwRfdFtqdgwm6vB13ZpXjdYfnUagNJvqfDTF
	 8Sk54BkRa+CEKD9x2YF7ZAYeemhU3ywJVQCLCZ3gsonVk6N8ELaj5gk2eW8/FqJSZaJlV
	 08oinLOyNEmISF70YrmHN51W+1XkKzSJ5EKNBKosCeHMrywE8zwEjOFKS2p4UWz2aQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794397061;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Message-Id:
	 Cc:Subject:From:To:X-Mailer:References:In-Reply-To;
	bh=GWmJbLCR3Z0PWF883WQy0SlXPcx6C4wxGpgsQpGnChg=;
	b=s6HtObhnwAX/WSswefPHXbX7z/nfqpQqpUK7WrUghfq59Xui4YENLWiJoPL7iLeouwgJ
	 JYifYsbyqJz8B3ZtMAW8CAKHYbnvjRsc2APJ7dsdg2eTuqWTxSK8jUlWJdLrorky3tYEm
	 nkCcHokuJR1VQA5pWTkpLxl5LnkhjXZXjIyAknA9xm+q7PtyanCM+so43J/gmJZlGemDL
	 ZXeyrfPIxjX6ZayXdzX40FDQxgbOwAo3+SR3PycKhDxANw4O0Ozd7Nbxjz+DqpIe7LrTQ
	 HTMCKtopHQs+HjyOr/YnbkitEFmBAIYc8jURE6zBGZexwRtYuH1OQgUz1fyTZN7xMbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BlC5Gblx;
	arc=none smtp.remote-ip=209.85.160.178
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A001606A324
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 11:37:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4A001606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BlC5Gblx
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-535179e995bso33216501cf.0
        for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 03:37:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794397060; x=1795001860; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=GWmJbLCR3Z0PWF883WQy0SlXPcx6C4wxGpgsQpGnChg=;
        b=BlC5GblxeuC6mh7E5mlcHWaa6FbwL7M5zsHQyzNo0ElWDR1HAb/10OXHf4NPTjJrYZ
         28qVLgXYI0cEYMl1lacrKBU6nz6AUicANfMZJzE7tO5nUNNb/YLGhvSTEHQIGzEOAuHd
         nVuqyNnNQTSTYCKjeMB9T9GmTGazkGf9pwsNZ07qbwteqNGC2d7g3SsUnHMTDJ/U9yLA
         UNk/kC7bqqiC/S3ciUXpdExCDcSYSMdftZTBSKD4owXddH4eUYyHOmIyppHH6JwIk37s
         OAcw2gv8gQOn9dcZudYcQ7SMmXcsyH1a+VEFKbwnhezz+4FwBTNzgzrVoz9I0rpjutiu
         fZ8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794397060; x=1795001860;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GWmJbLCR3Z0PWF883WQy0SlXPcx6C4wxGpgsQpGnChg=;
        b=0lydAE9xIrBoroINZYMs/NAPUdwkVkTk8G8FMG2HutHnmPjz5mjubYboDg5DFVaM4J
         075r0Rg0/1r84cd15QMiDV+dMOptf4PAT54FF0uGNk+nR6S9FStkYm/xqQVHB78Ff8Yh
         MvpoxLYXgAZ5dw9znT9+K5SMab8sLUFjHbQl0q2VnunEYlWu8waT05t9tmXJIxLzrT9I
         9/vbhY+RWCbXhGY45M79RdlyMG0iMIwhJxtjgrP2x3RvC0yBtkAnsuNkq5cdmCUXpNjB
         Ylx/WWUNKfrCNoRaEabvtwrcGZOc5vBef2KalZvlInleossZV09y3T2CeXPTf8IaaLD5
         NjsA==
X-Forwarded-Encrypted: i=1; AL+hErHhIbOY80fQ29dKWzDT4DtXfDrfuj/3UHMdZydd2AvsQ33qVXy0IobVkCPhXs6ddTkzehmQw9SnZdQA@vger.kernel.org
X-Gm-Message-State: APuU4Z+jp9zGFDRqnZ03uao9iwGR1JGXLiwXlon1s41KCGt+bVJmUyzK
	Ng412heN9SCy28II3shDOkquX++LybCkEWIZBn8uQ4mHkIWz0Q0y6bLk
X-Gm-Gg: AYBFou22Ci++DEX4TuY1AJdSxKS0bGRVK/LuCLugBOvn+toy2SGB+f/fIHuoDlchksA
	9RQzdd2bPv9gdtGJHkHbIQyDfx30VWHquaXXOb5EVlVqsoiuYv3FT904NMuq/11hAe8NTO1phtI
	Ga7tBrNSQA82fbUF7gdSsizsVLMIwUIuFnEytPfKyisgGNtks5JhiLLpNG9Ef1+tLsXh0VQpw+8
	oqpe1yVZE39p5Bz3W8FTY5eGXLlDuqBEV4xV7M0rjsPAGrvpWixp47sCIPjF8I7sess7L+gViqF
	Cg75zssWSKLiQfsLXgUAfKaHLzt7VvtqObF/2WpQSSTkZEyk1llQI2wNftO4ddPWdm2lRx5ol/v
	e1mrkXiY35jxt7t/6KSxNwFElaZbtqK8OPMPfQths3tNrMVxFxw3wcXQN66LoT2UXfe6UOGnzFc
	OzuFzSHcVc/acfWN7ORevgeiEIwj+pYIz8yA3BSI6FT0f6DFt6dvyPG2SJa8eqU8BPyrmoEqsoT
	2i/RB3oWwX6yh/3G/+3weo2Zk1b8vTCkkckqntQdkPs5kJ7Jx07ldJtVClQBbl2Lv1PzMkVPCXt
	uj85aZXz4rRcJIC49LP/bggtykgDJsmSm8D+4vgaJ7a37bq8p/KVK5Y=
X-Received: by 2002:a05:620a:4444:b0:93f:3e45:a419 with SMTP id af79cd13be357-947b002af5bmr318209785a.38.1794397060199;
        Wed, 11 Nov 2026 03:37:40 -0800 (PST)
Received: from localhost ([2600:4040:9399:4000:e553:72e5:7d37:c7ef])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9479e7dc398sm462686385a.35.2026.11.11.03.37.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2026 03:37:39 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 11 Nov 2026 06:37:38 -0500
Message-Id: <DMSCO4I434TK.15MMEZI0V4UZR@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, "Andrew Lunn"
 <andrew+netdev@lunn.ch>, =?utf-8?q?Bj=C3=B6rn_T=C3=B6pel?=
 <bjorn@kernel.org>, <bpf@vger.kernel.org>, "Daniel Borkmann"
 <daniel@iogearbox.net>, "Daniel Zahka" <daniel.zahka@gmail.com>, "Donald
 Hunter" <donald.hunter@gmail.com>, "Eric Dumazet" <edumazet@kernel.org>,
 "Jakub Kicinski" <kuba@kernel.org>, "Jamal Hadi Salim" <jhs@mojatatu.com>,
 "Jiri Pirko" <jiri@resnulli.us>, "John Fastabend"
 <john.fastabend@gmail.com>, <linux-doc@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
 <linux-rdma@vger.kernel.org>, "Martin KaFai Lau" <martin.lau@linux.dev>,
 "Paolo Abeni" <pabeni@redhat.com>, "Saeed Mahameed" <saeedm@nvidia.com>,
 "Simon Horman" <horms@kernel.org>, "Tariq Toukan" <tariqt@nvidia.com>, "Wei
 Wang" <weiwan@google.com>, "Willem de Bruijn"
 <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH net-next v1 08/15] psp: only give time-wait sockets of
 psp connections a validator
From: "Daniel Zahka" <daniel.zahka@gmail.com>
To: "Todd Freed" <toddfreed@meta.com>, <netdev@vger.kernel.org>
X-Mailer: aerc 0.21.0-threadmapfix
References: <20261111005533.6436-1-toddfreed@meta.com>
 <20261111005533.6436-9-toddfreed@meta.com>
In-Reply-To: <20261111005533.6436-9-toddfreed@meta.com>

On Tue Nov 10, 2026 at 7:55 PM EST, Todd Freed wrote:
> psp_twsk_init() sets tw_validate_xmit_skb on tcp time-wait sockets.
> today, that becomes set whether or not the socket has psp offload, which
> is not needed but is harmless. psp_validate_xmit() passes such packets.
>

This can get sent as a standalone patch. I would probably tag it as a
fix too, even though it is benign. I can't remember why we (I) didn't
put the validation hook under the branch, but looking at it now, it just
looks like a bug.

> but a validator makes a socket look like it has an encryption offload of
> its own, and the tc psp action, added in the next patch, relies on that:
> encap refuses the packets of such a socket, and sk_validate_xmit_skb()
> drops a packet with a psp association whose socket has a validator.
>
> set the validator only when the socket has a psp association.
>
> Signed-off-by: Todd Freed <toddfreed@meta.com>
> ---
>  net/psp/psp_sock.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/net/psp/psp_sock.c b/net/psp/psp_sock.c
> index 609b06c7af65..664955bfb4fd 100644
> --- a/net/psp/psp_sock.c
> +++ b/net/psp/psp_sock.c
> @@ -330,10 +330,14 @@ void psp_twsk_init(struct inet_timewait_sock *tw, c=
onst struct sock *sk)
>  {
>  	struct psp_assoc *pas =3D psp_sk_assoc(sk);
> =20
> -	if (pas)
> +	if (pas) {
>  		refcount_inc(&pas->refcnt);
> +		/* Only for PSP connections: a validator makes the socket
> +		 * look like it has an encryption offload of its own
> +		 */

comment nit: for my taste, having a comment that starts with "Only for
PSP connections:" two lines under an if (pas) branch feels unnecessary.

> +		tw->tw_validate_xmit_skb =3D psp_validate_xmit;
> +	}
>  	rcu_assign_pointer(tw->psp_assoc, pas);
> -	tw->tw_validate_xmit_skb =3D psp_validate_xmit;
>  }
> =20
>  void psp_twsk_assoc_free(struct inet_timewait_sock *tw)

