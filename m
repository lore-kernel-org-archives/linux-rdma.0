Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.6
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794248962;
	b=Ls3sRuaRlrmgqo5XOs/sBQ6g6NjsHZZW+0FE8NBYhAuL/BTjkS0jtHPIu6l74WXik2We
	 Z3SmdYKipl37jUNvd/Bg4NcGB5k0O0nF7MoZ6Zf9XT3rYol1OvybGdoTRm/teUx0M2QiY
	 5DCNIgOk9oHrfKhjns7OUWfbrtbhPCpIe1LCSfD0ODIUEKzAFEx5xBdHUg04phoq5dsO9
	 QBY6F2B9XaubmP7buapkD7ZKtx2fHFEruq+eyUkELavd/NYaoBhkjQMm0C/z3Vv56KYLM
	 vt7VvEkSpSkCFuLVxL6myARQZ4jawP44eJ81Rwf6thipxAg+zRI4pNsr5MeD2pDMAkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794248962;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:Message-ID:From:To:Cc:In-Reply-To:Subject:Content-Type;
	bh=eZXah+GU1zYRZgrwJ8SeyJuEq1JV0JX65ZErGIYWKN4=;
	b=2ier4YibEFOqQmGsg5ile1GJkfQcbT1fFA/rOwP6ekUIcTODgjSmEpMaLt/1kaFGYR0C
	 aPc3LMs/eb8NGKBqn0WqAJkIV+gm2nd7IWxNyZN31ZRnunzHqGe6bZSmx+59gdb7ioVFE
	 OVKFxf7Z03n06juYlSq30Gtz39WxITQujKA6Zx5juVQbxRmTP1MMEXabzsT69Js74/cxS
	 pXCSop42ZCm4jUFgKhOJ3+qqfH6Yxn3wJjvWWEa25jQbtdoMQy30/TUI/ACZHm7jXsM+r
	 jkPdihB0GjF1Ot5L8lpGRFWclRJQzLwrbactWRCnardQeUmQBZflaEfBGZrr0zKPKjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=KSJhy7sp;
	arc=none smtp.remote-ip=74.125.229.6
Received: from mail-dy2-f6.google.com (mail-dy2-f6.google.com [74.125.229.6])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDF66070EFD
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 18:29:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2CDF66070EFD
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=KSJhy7sp
Received: by mail-dy2-f6.google.com with SMTP id 5a478bee46e88-35adc681e1aso1649142eec.0
        for <linux-rdma@vger.kernel.org>; Mon, 09 Nov 2026 10:29:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794248961; x=1794853761; darn=vger.kernel.org;
        h=content-type:subject:in-reply-to:cc:to:from:message-id:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=eZXah+GU1zYRZgrwJ8SeyJuEq1JV0JX65ZErGIYWKN4=;
        b=KSJhy7spSVu5bxRcystXBVzm1AoZWAvdpFQsG4ejBx9otx6a4+2dMgf2GDHtdvnAGF
         jA2RS+6Esp+A1s1IsndxuLyW4jjRdT+99xKWuANKBhT7XEBw6JMDu56+D5v78sr+CZQ3
         epMrT3Cb0EOf6gfAYdYs9yft2FRR6cey/8yTtq9j2979h/g75hxWoG4MP8S3dNDq3jTo
         JveOWlD/jjVgTb9h/9sefJef+OQLdIcfAYxIYfK3zpZJFwN+1YZ/gzE45F9G8iGhFOut
         EwlQ0ianw7caxy1nqlGQVzvV5uLTQ9lMZqesTRtpUQ/OFpRz5fRw4c4WhjujA6UhaKph
         H+1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794248961; x=1794853761;
        h=content-type:subject:in-reply-to:cc:to:from:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eZXah+GU1zYRZgrwJ8SeyJuEq1JV0JX65ZErGIYWKN4=;
        b=mQGRDYXMUHJVqYP4SbDeVPXPs1cFFx1B3ashkrvqMLZ53AAD5aKlzd+bDsHaFeMakL
         fKh4yzy6FC7+BXxd2n1JrRmSuEX7KqCITIcxcdsrafG5r7uyU2klqhBW3VmNpiX/p5o+
         MnHou0rJuRO41A0+b4AYsl99q5o/b8VIzJEDTb0HutSgJR6Yq/ax3h5J0veE8hNTlKEe
         r5wU1rPsgqFyZDNzfwkzyutNW4B3voIDG4YSt1yLMqJb/1AnkaAGa9UG6zNITa28dZHD
         bg2Vl1G6jvoYmpCiHMRyPbrP59pIiJd4gweajFJz5Ln8mfFCmedEjfc6tARheaiCoVMY
         qGGw==
X-Forwarded-Encrypted: i=1; AL+hErHfzhYtT57INTPSzWSkJ4UvD5HYrs2pek9en0+9H3M3QaquiyPhmgmf+T0KUkTQ7MjJMbINn87FPTwT@vger.kernel.org
X-Gm-Message-State: APuU4Z/AiISWDu3l4Sm5nt1nlIstEcUaPicnreuv12eNECRwAO6kT810
	r2vGiGh6upWlaFmNXu5qwNPfm/5Wq1AuGPW8PhEU3Gb9PrmB9MVTSiq1
X-Gm-Gg: AYBFou26f6l6tDoCHTo1jeMh9timlXMV5J9yLpK6Zqb7/Ts9HGzX1YUrN2G48V1BdLS
	vM3tag+qVlzW0eQpqDocrTe0nNwdicuzy8qVwZi/zaE6pQdXqebOVqZm5obPGr9Y3Em8eSD0x65
	fiZWu8Mo2neV0mzKWPYgIX9PHxsBbQSMX9ucE191b6fDlQKjkPeYzAjYTpzjuHBIMr/YK2wJWTH
	6oPX0Pz8bffaBwG1+qr+1HDRNGKEtn9wwzj0aQti9nXQx9GLeREihs1sQCKbQzsQp00kRBgJ1Q2
	Q1vtXfpp1pBv+yfF8YqQ3xblY1vdGZx0BBw264J21duXwfm6ES4MgQ9Y7lAuE/fjUrRFyaXumSL
	dM5h6y5S7vjMmPAACxdAX6RELoY3/eA+t4gVECOZ2DEB8f1Qx0ATaofUm9mi134wKyB79UQGWyn
	OZVqEc5CxUxepZkQVYfv3dUOHVj2cfzR+ETQyge8fXW3WbXMPr8psWW7QNPQCA/YRHE2EPElAOW
	t0wV1gKfdSGMXaNSQCSsv8XwYBK1f8ojSAGHtqRuQY2DM0tiftt1RorN9JJ8FJ15d8R09enWm40
	iUOJbhaKf945XXPLdyJIqfA=
X-Received: by 2002:a05:693c:41c5:10b0:372:7af9:b916 with SMTP id 5a478bee46e88-3751ef77c8dmr97324eec.18.1794248961138;
        Mon, 09 Nov 2026 10:29:21 -0800 (PST)
Received: from localhost ([2a03:2880:9ff:6e::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37520608b52sm102777eec.13.2026.11.09.10.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 10:29:20 -0800 (PST)
Date: Mon, 09 Nov 2026 10:29:20 -0800
Message-ID: <e4def2839d68382fd50e4fe1e6b4f116@gmail.com>
From: Stanislav Fomichev <sdf.kernel@gmail.com>
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, andrew+netdev@lunn.ch,
 edumazet@kernel.org, horms@kernel.org, corbet@lwn.net,
 skhan@linuxfoundation.org, rdunlap@infradead.org, michael.chan@broadcom.com,
 pavan.chebbi@broadcom.com, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, alexanderduyck@fb.com, kernel-team@meta.com,
 sdf@fomichev.me, dimitri.daskalakis1@gmail.com, almasrymina@google.com,
 dtatulea@nvidia.com, bobbyeshleman@meta.com, asml.silence@gmail.com,
 daniel@iogearbox.net, razor@blackwall.org, leitao@debian.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kselftest@vger.kernel.org, leon@kernel.org
In-Reply-To: <179418737248.994134.10509157155829463489@kernel.org>
Subject: Re: [PATCH net-next v3 1/9] bnxt_en: let the stack segment GSO skbs
 with too many frags
Content-Type: text/plain; charset="utf-8"
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> > +#if (MAX_SKB_FRAGS > TX_MAX_FRAGS)
> > +	if (skb_shinfo(skb)->nr_frags > TX_MAX_FRAGS)
> > +		features &= ~NETIF_F_GSO_MASK;
> > +#endif
> 
> [Severity: Low]
> Should this patch have a Fixes: tag?
> 
> Commit b91e82129400 ("bnxt_en: Linearize TX SKB if the fragments exceed
> the max") added the unconditional linearize in bnxt_start_xmit():

[..]

> The commit message describes both problems. Without a Fixes: tag, stable
> kernels that carry b91e82129400 won't pick up this fix.

Will add a Fixes tag, but not sure it's worth the backports..

> [Severity: Low]
> Can the segments that the stack produces here still have more than
> TX_MAX_FRAGS unreadable frags?

[..]

> Could the commit message mention this limitation? Fully closing the gap
> would need a fallback that handles unreadable frags, or a frag limit per
> MSS window at sendmsg time, rather than skb_linearize().

Not sure what's suggested here. The example that's given goes via skb_linearize
and fails cleanly (as expected). Handling this in a better manner is out of
scope?
