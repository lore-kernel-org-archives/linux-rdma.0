Received: from mail-pj2-f6.google.com (mail-pj2-f6.google.com [74.125.227.134])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD61F4F68D2
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 21:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.134
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792100213; cv=none; b=MvLKgF9WiJAWCtSK7+UfyxEuw6CB99gpAuTNjeV4W0FU5yQCqmayqJWqnQUSdw/MxA8sUOpVMjU4ohUzbNcbaeiyo1b4G0UeqvcUt7Jtwbr+XivsSmzI9RyAcGTHOGSJ1+02q7XYwy2rxVL0Sv6hoswt9kEN4jaAQOgWGcIDVg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792100213; c=relaxed/simple;
	bh=/mThlAxqOQ/illGXXCKqwpofgrrCmo0z6UJR5iZDmek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VhpTln6h3IZFagBmZZuNCd6oHIRposx82B7A3VQb2QkxqPR3yWxsm97/+HGO4GmkBXWTV5+Z7SGISUmUIZ1VvPU6bgILc5BOa6RjdCnJjMLKFlMwYZ1v7o2aWU9gp3fv4ajqVp9hm4qeAoVMx9AchzWdKJJv2yugbbgJF8Nl8tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L5Gw+2rH; arc=none smtp.client-ip=74.125.227.134
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L5Gw+2rH"
Received: by mail-pj2-f6.google.com with SMTP id 98e67ed59e1d1-3964e7720afso2866025a91.1
        for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 14:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792100210; x=1792705010; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TFWHGN7cklsMWKCyO/CrNxAqmD+l+5aS8n56/ZuYuKE=;
        b=L5Gw+2rHfKE35YiYPy1ol+Mo3zNmcIrTcm+mx5+BQacp1HSFNELcpJ6qmDp0QHOg3n
         eSTwG/f5uRWvuhiLEoPNh2WZHfLDYhdc00wODroEGA2Jc0PUIZSOtUVfQ3SU5Dd+N1b3
         HfocrloFYZ3lGJ7lihdL3QuZoGxvCIZUeYtCKnnitqPWwkoC3y9LMKNscFi4lcdLoARf
         dICo26do3vBcP09lvRkDSgOyDefSdm2vtCqzdztqSCrp4FhXpYa7AuOEDh/TM4RQHd2X
         DWgUOL8szfRsiHPSZtukg6KSbYtG8pwMW6DMaZLbQdoHydZz3/N8YgC0ahh0Q0IejlQs
         25Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792100210; x=1792705010;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TFWHGN7cklsMWKCyO/CrNxAqmD+l+5aS8n56/ZuYuKE=;
        b=nM9jzM1e3zCgL1rN7L0/YOr1X9o1Mcm2kn8SDR9PFgSDBsQbWlCbzZqPoR8y3pkoB1
         U9oLCPyN1dnJWVjKkXXzEi1xq415IJ13RhX60TibZyvcubWWvDoXfXdpLm4Tm/pQWj5D
         rYpesljXYI0DTFNnoY5DghkD9jTSh3IdlcdbA6M9n1GcUWCoDFB0PyyvxhJ4asPLyNgo
         +kQSzRrQPUMsHwj9ls3GugZRgDAzZnUqAaaMS6MMDAWHqp4Owe0SzId6P/9Hsp6zmJ+S
         oxdILthmYew78TMeFuxa3CRcxVd264Q2iKvfHgaILaVIH+OaFQajWtbx/JbVi/sw3Ztk
         c6iQ==
X-Forwarded-Encrypted: i=1; AKwUvBwuQ+HoxqWwSxVGYEE5hZ4BYFCKmIG7pasWTVokt7/8LWdZT7CV882DNJ91EqQnQeU4mb+kKbX3h884@vger.kernel.org
X-Gm-Message-State: AFq9FYIpIVUciIU545ppY+n9L7EJrplTQ+8SLq4LvFx3YM0hw+4VYo3/
	yJ6I3V9LyFB30DmsdLPr8lxJY2CeuvKeAR4wLAz8ey/2KFtF2RCBvIDq
X-Gm-Gg: AYBFou1ie8BVjsnYBZZRf5NLobWsN86x1fOfEjfxg6NKkaUXTgEQI1Bt4ZL1P5rrns3
	lfkkknnxfjEs4SdzwJIZ2dYVNPwOhttS7Gx2x+OjjhOOB4QbpJiMEKRpLYGBgzMkK5cayzipiG9
	eyVyoCnCARLnRBo06M/EgwI0Kful9BHLMTBbK9MwYeTvK0qPgBBRdFsjgjXMMyzEJewd1VjhECO
	iiVFOXwCb8sKHevpZLOcnuzWVqnjco1D7x2D3NOfvz/RshsE/SAVRO0FaCn8tBkgjF7HoPVXUXx
	uDQ4UoqSswZwoBIbPbZgw5WrBVtrCftb5lbeS4no404R20BGmKD5Ajo/5We7xeg02K5w/j3Fcsb
	8FD7Nzxe+yfqJTYL9w4mtM60jYwD+aCpvgr5Y6e7PxiLxHlhpfN1m2psd6TfmVSPJFkcBEjqVHK
	lIWVrEKGYtCA9HpO9UwbWzkamUAx9dkGPU4D7FS3uSl3WRkOEFg6e20qAjJwUjUFka
X-Received: by 2002:a17:90b:48c5:b0:3a4:b418:94cf with SMTP id 98e67ed59e1d1-3ab3a7366bfmr18636143a91.14.1792100210060;
        Thu, 15 Oct 2026 14:36:50 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff:46::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acd05fb680sm23372a91.2.2026.10.15.14.36.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 14:36:49 -0700 (PDT)
Date: Thu, 15 Oct 2026 14:36:38 -0700
From: Stanislav Fomichev <sdf.kernel@gmail.com>
To: Mina Almasry <almasrymina@google.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-rdma@vger.kernel.org, bpf@vger.kernel.org, Ayush Sawal <ayush.sawal@chelsio.com>, 
	Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Tariq Toukan <tariqt@nvidia.com>, 
	Simon Horman <horms@kernel.org>, Steffen Klassert <steffen.klassert@secunet.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Neal Cardwell <ncardwell@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, John Fastabend <john.fastabend@gmail.com>, 
	Sabrina Dubroca <sd@queasysnail.net>, Eric Biggers <ebiggers@kernel.org>, Kees Cook <kees@kernel.org>, 
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>, Petr Machata <petrm@nvidia.com>, 
	Uwe =?utf-8?Q?Kleine-K=C3=B6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>, Jakub Raczynski <j.raczynski@samsung.com>, 
	Wang Zhan <wang.zhan@smartx.com>, Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH net-next v3 0/6] net: unify symmetric netmem and
 page_pool refcounting
Message-ID: <atFHX4ryLonqXpn4@devvm7509.cco0.facebook.com>
References: <20261014173945.373295-1-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261014173945.373295-1-almasrymina@google.com>

On 10/14, Mina Almasry wrote:
> netmems (pages and net_iovs) have two independent refcounts: a non-pp
> refcount (page._refcount or binding->ref) governing backing memory
> lifetime, and pp_ref_count governing recycling within a page_pool while
> page_pool holds a single backing non-pp reference. SKBs with
> pp_recycle=1 own pp_ref_count references on page_pool fragments; SKBs
> with pp_recycle=0 own non-pp references.
> 
> Core helpers currently mix these two refcounts asymmetrically:
> skb_frag_ref() always increments the non-pp refcount via get_netmem(),
> whereas skb_frag_unref() decrements pp_ref_count when skb->pp_recycle
> is set. Any path that refs a fragment on a pp_recycle=1 SKB (or unrefs
> with a hardcoded recycle=false) increments one counter and decrements
> the other, leaking the backing memory while underflowing pp_ref_count
> (e.g., IP-TFS [1], skb_split(), skb_shift(), and cloned SKB uncloning).
> Unclear core APIs also led drivers and ULPs to open-code pp_ref_count
> manipulations or add one-off helpers like skb_pp_frag_ref().
> 
> Unify fragment refcounting into symmetric pairs where each layer clearly
> specifies which refcount it touches:
> 
> - Non-PP refcount: get/put_page(), get/put_net_iov(), get/put_netmem()
> - PP refcount:     napi_pp_get/put_page()
> - SKB netmem:      skb_netmem_ref/unref(netmem, recycle)
> - SKB fragment:    skb_frag_ref/unref(skb, f)
> 
> Found by code inspection while reviewing [1] and confirmed with the KUnit
> tests in patch 6; not observed in production. Driver and ULP call-site
> changes are compile-tested only.
> 
> Link: https://lore.kernel.org/netdev/xfrm-iptfs-pp_ref_count-underflow-v4-1-912fa72106f0@secunet.com/ [1]
> 
> ---
> v3:
> - Linearize straddling output segments in skb_segment() when frag_list
>   SKBs mix pp_recycle flags instead of clearing NETIF_F_SG, and add a
>   KUnit regression test (Sashiko).
> - Link to v2: https://lore.kernel.org/netdev/20261012082148.1698596-1-almasrymina@google.com/

Acked-by: Stanislav Fomichev <sdf@fomichev.me>
