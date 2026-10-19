Received: from mx1.secunet.com (mx1.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF604F4CFC;
	Mon, 19 Oct 2026 12:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.96.220.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792413356; cv=none; b=EMtNqOF0QiKyBvQV/JC8m1w5hhfZHG1D/VlfAQN+UFSnzgdT9acvuM/NsyPtMK9XdId8Fzn5V22LiWhoEWoT8EB+Wa8/F/aog/kPPyDisOHPXGKaRoyDtqfG9KOX4JO9uCmX7EJ+GyM3UMsYHzbBKHs8e8ZGqFnwWoQU5JDTTKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792413356; c=relaxed/simple;
	bh=DG8qOUM3s2Jq4j/7qWK7+ZrC2H8JkYbWV7LSbwzpcS0=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gR8RC+hCMaQ+Z/gWgYxI2S2jXt/hyaUpmCTN8GfCWCKVklw4g34WwcvuFwl5pdPRGFql/7Ztx4kwADaDAk5ar7g921UZbSHbh3snkMHP/wCAzHgIGO2QQhF5OiUuYw0tM5g8EEwu2CRFiW/zOGm+vH2rx2Xkr9MMan56YC51bRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=secunet.com; spf=pass smtp.mailfrom=secunet.com; dkim=pass (2048-bit key) header.d=secunet.com header.i=@secunet.com header.b=kkTbXb2k; arc=none smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=secunet.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=secunet.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=secunet.com header.i=@secunet.com header.b="kkTbXb2k"
Received: from localhost (localhost [127.0.0.1])
	by mx1.secunet.com (Postfix) with ESMTP id 572C52068C;
	Mon, 19 Oct 2026 14:35:36 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from mx1.secunet.com ([127.0.0.1])
 by localhost (mx1.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X4cdWsqtRB0w; Mon, 19 Oct 2026 14:35:35 +0200 (CEST)
Received: from EXCH-02.secunet.de (rl2.secunet.de [10.32.0.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.secunet.com (Postfix) with ESMTPS id 48B33207BB;
	Mon, 19 Oct 2026 14:35:35 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.secunet.com 48B33207BB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=secunet.com;
	s=202301; t=1792413335;
	bh=qJbBG8sntIX/S4wxb2GyFknVKn1OGpfR83ukZlTz9Bg=;
	h=Date:From:To:CC:Subject:Reply-To:References:In-Reply-To:From;
	b=kkTbXb2kjSD/XdxMPgl+OnJdQS50tNn1ncFgxwR4sLNEGGzPS7opJ+Xyxvp0h7Jom
	 Jr9nJH/M/LG4BBB6Grpg2qlylojdARBck7OmprLW7bC3tXWJJh9aJwkeKtd68LVyv6
	 RutbKHly2ZsGco+hie7bq/ZieIFUPGsEPbkwIEoFH4ze0jAPzX2QCk9Lo+J7K64MUu
	 /CZ2Oucc4n8RonBtofyoEFkV/8v53pe721merZjwJIj8IvBHNyaDQg7xO8Q/BDZPgy
	 XEVTZq/fDSd4EkKS4r7ct1S7DyFCouPsxS4qT3xCQXVzbnbQ76R8D9lCNwREdmJyKp
	 qzJYacTMAMGUg==
Received: from moon.secunet.de (172.18.149.1) by EXCH-02.secunet.de
 (10.32.0.172) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Mon, 19 Oct
 2026 14:35:34 +0200
Date: Mon, 19 Oct 2026 14:35:25 +0200
From: Antony Antony <antony.antony@secunet.com>
To: Mina Almasry <almasrymina@google.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, <bpf@vger.kernel.org>, Ayush Sawal
	<ayush.sawal@chelsio.com>, Andrew Lunn <andrew+netdev@lunn.ch>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub
 Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Tariq Toukan
	<tariqt@nvidia.com>, Simon Horman <horms@kernel.org>, Steffen Klassert
	<steffen.klassert@secunet.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>,
	John Fastabend <john.fastabend@gmail.com>, Sabrina Dubroca
	<sd@queasysnail.net>, Eric Biggers <ebiggers@kernel.org>, Kees Cook
	<kees@kernel.org>, Aleksandr Loktionov <aleksandr.loktionov@intel.com>, Petr
 Machata <petrm@nvidia.com>, Uwe
 =?iso-8859-1?Q?Kleine-K=F6nig_=28The_Capable_Hub=29?=
	<u.kleine-koenig@baylibre.com>, Jakub Raczynski <j.raczynski@samsung.com>,
	Wang Zhan <wang.zhan@smartx.com>, Willem de Bruijn <willemb@google.com>,
	Antony Antony <antony.antony@secunet.com>, Stanislav Fomichev
	<sdf@fomichev.me>, Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov
	<ast@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>
Subject: Re: [PATCH net-next v3 4/6] net: skbuff: replace __skb_frag_ref()
 with symmetric skb_netmem_ref()
Message-ID: <atYOjaLywUNzjijW@moon.secunet.de>
Reply-To: <antony.antony@secunet.com>
References: <20261014173945.373295-1-almasrymina@google.com>
 <20261014173945.373295-5-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261014173945.373295-5-almasrymina@google.com>
Precedence: first-class
Priority: normal
Organization: secunet
X-ClientProxiedBy: EXCH-02.secunet.de (10.32.0.172) To EXCH-02.secunet.de
 (10.32.0.172)

On Wed, Oct 14, 2026 at 17:37:18 +0000, Mina Almasry wrote:
> Previously, __skb_frag_ref() and skb_frag_ref() unconditionally
> incremented the non-pp backing refcount via get_netmem(), while
> skb_frag_unref() decremented pp_ref_count whenever skb->pp_recycle was
> set. Ref-ing a page_pool fragment into a pp_recycle=1 SKB (or clearing
> pp_recycle=0 on an uncloned SKB while clones still held pp_recycle=1)
> leaked the backing non-pp refcount and underflowed pp_ref_count across
> IP-TFS, skb_split(), skb_shift(), and cloned unclone paths.
> 
> Replace __skb_frag_ref() with skb_netmem_ref(netmem, recycle) as the
> exact counterpart to skb_netmem_unref(netmem, recycle):
> 
> - Keep skb->pp_recycle intact in skb_release_data() so uncloning paths
>   (pskb_expand_head() and pskb_carve_inside_{header,nonlinear}()) keep
>   trading pp_ref_count references symmetrically across clones.
> - Propagate pp_recycle and call skb_frag_ref() on the destination SKB in
>   __pskb_copy_fclone(), skb_zerocopy(), skb_split(), skb_shift(), and
>   skb_segment().
> - Linearize an output segment's existing frags in skb_segment() before
>   attaching frags from a frag_list SKB with a different pp_recycle bit,
>   since each output segment carries a single pp_recycle bit.
> - Use skb_frag_ref() in xfrm_iptfs, chcr_ktls, and cassini, and call
>   get_netmem() directly in veth and tls_device_fallback where callers
>   explicitly take a raw non-pp reference.
> 
> Found by code inspection while reviewing the IP-TFS pp_ref_count fix [1]
> and confirmed with the KUnit tests added later in this series; not
> observed in production. The xfrm_iptfs, chcr_ktls, cassini, veth, and
> tls_device_fallback changes are compile-tested only.
> 
> Link: https://lore.kernel.org/netdev/xfrm-iptfs-pp_ref_count-underflow-v4-1-912fa72106f0@secunet.com/ [1]
> Cc: Antony Antony <antony.antony@secunet.com>
> Cc: Stanislav Fomichev <sdf@fomichev.me>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Jesper Dangaard Brouer <hawk@kernel.org>
> Cc: bpf@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Mina Almasry <almasrymina@google.com>

Tested-by: Antony Antony <antony.antony@secunet.com>

I tested for IP-TFS virtio. 

Steffen, if this patch is applied, the following will become redundant:
https://patchwork.kernel.org/project/netdevbpf/patch/xfrm-iptfs-pp_ref_count-underflow-v5-1-c25508ec9160@secunet.com/
-antony
