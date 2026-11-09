Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.194
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794248963;
	b=BW7k0xo32G64ILdZJ2MBpZAgPVT91VYSfFs3tXCXCdGKK6cxtBYkHcsKCooN4DEYYBzo
	 lB4IoKDEmbh20XFMsRLa6ly3ymfssamKyG/nz/rRp8KtnrmO4880kPDcN6G7IGn66hW+j
	 GYS9Iphw9G8UYU3zeINxtp2Vh8ODRSo97zB3KEjqCC1Cnf75AvapTaKReAjh668Kmui++
	 m5adwDLA75ao5A/LndPfKjNeixcju3YtDFUmLJ2H6ZaxrCehnELW5Zd+pY8CMFmQ4Fsra
	 BlT36Qz3CWoeHY+pplZAFL+QxG1hvwQkZF8W/BBEF++Rdeu4Frsph5JAeiSy7U1/QHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794248963;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:Message-ID:From:To:Cc:In-Reply-To:Subject:Content-Type;
	bh=KcVmoMQgperP1wPlpI/4lZIUWk5pcHjD9u34purQ6ks=;
	b=nooUza5ywTbXQ9ZtjsvamjVcnHrsFHnyI0q/JfAsb/Cw0Qi0nBqD+uQHShbIRp/KaYpX
	 bxh7Y2lH23svtB0VpXo0WjmzYPfXv0tPCvmIG3u0opfsn0Isv+65DFPxAyZbcLvOFEWgk
	 fLlVSrTdSU6u9h9szmoqIb9rQw8o2DUUZS7G7pXOOMacg0+na/ml5z90GfC8EHf6gdkCr
	 ikCNIWKkMsQIDxi3sGTiS/AQwZL8lQKS1qfGXp0BNdb8iAlC66j5k6QhAtMpNPUpGLoZH
	 z0Vkwknb9VXk+x6Lb1yUnZiqb5RZsaNjGJN7pauizc71RwzS+IVIjgf2vk2lGbObj0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=X7wedxBS;
	arc=none smtp.remote-ip=74.125.82.194
Received: from mail-dy1-f194.google.com (mail-dy1-f194.google.com [74.125.82.194])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BCD160A5BC1
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 18:29:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6BCD160A5BC1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=X7wedxBS
Received: by mail-dy1-f194.google.com with SMTP id 5a478bee46e88-36a315ed211so1373858eec.0
        for <linux-rdma@vger.kernel.org>; Mon, 09 Nov 2026 10:29:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794248962; x=1794853762; darn=vger.kernel.org;
        h=content-type:subject:in-reply-to:cc:to:from:message-id:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=KcVmoMQgperP1wPlpI/4lZIUWk5pcHjD9u34purQ6ks=;
        b=X7wedxBSS8iZNbIq3uVV6Lk387o+XeGOfTW6Zk2cySFVKqEWn7Djj69lXsU8s/kpKz
         tJiJ1NC1pNUqxiy43lTvIzQnaR1XWltnvNswRXYTYKvJhMy1Ym9sy/gLTRWhTzeoZy/r
         kf9IurJNAyUB0JwvE50fsKX5uraHf+5WXfCjtNq7xr/i9v+AGqhqYTaRQLpfpje/s44G
         JAaCcBLIk5pgtY0fMS2yln/+byA2YY2Cjh8Vsy4CPhQB/kcoPBKf8PLdF0pQZM0hwa2X
         mCEmy0QrvQXIQcY0xkadgOuk8+FykA/urSyQYxogIANNQn5HVGBPGbcSPTXfDKNUDh9f
         93Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794248962; x=1794853762;
        h=content-type:subject:in-reply-to:cc:to:from:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KcVmoMQgperP1wPlpI/4lZIUWk5pcHjD9u34purQ6ks=;
        b=HmIpu9jf9aGyXKIb+DA/xj49r1xGrOBbCDo3xfQc+Rj0KMYkfqMj3PywyV/fVkfWn0
         asUPttTDd8Kw8bJWlg0//52naizQ7Q1cwgRGW3Dgx+xBp5AIDTjVvBsCIeN1lFRffWw3
         IOnxWsXsgb2pAd5SvguHjOjwSpWMZLQE0GsvKbllanLyKmFRH5AmO3f1lU0KhTeM4Xra
         RSrpeufPgFb8pxJOzqKsFLH8gifXOX4S+FJFaPeEO94HlwSIH+95vND12NQf0RvuBXW0
         Mll4xGr1nkCAAJszD3LPl5qdmts0H0yrgqQaexmSOmQ6R1uo7bVCaYYYGlK/h51CUqRx
         lXXw==
X-Forwarded-Encrypted: i=1; AL+hErEM47FYe0gePK23MlyCB2ETr2fEbuVpikwdfOi7gJ4VfxLjpLV0ZtHPvyD7Rc/Ph06iII9r1wBOaTVf@vger.kernel.org
X-Gm-Message-State: APuU4Z+Dat8uAryrD+1hggoarAhCCLll5JZfkKNdCD8OQ+jFEsoxsDvy
	lv3fSkkC3zcc2BwLrCRIzsSo8VvG6ydeoRJmm2GkuSYk/Clvm/el/tDC
X-Gm-Gg: AYBFou0yHRFjEEPH+ZTNH7q4i6m04UncNUyXkT7rok4M15Vx/GvpjH0ivPi9jQaJxbs
	DOyKRKtKpxAlQSfgAIIz6xdfkH/NiY3HBVCmdIJ2k32YV6oEwS8zCvw8ayaNj8W5p0RSBMEe4VN
	nTEMn0d5ra8U/o8HTSMcreaueS4Fo5U3KCjMgRECY3Li3al6NvapfD70ukzgx/nMcCa5u5TEGz8
	6gGQM0ZJ4N/Tle7jBX6tyScuKuBQl5iiNH3VsCMvJKog0Re6SkJl+5S1aZ5w8PmL4FX1pFTpZoa
	GPxN5MkxUDFYNVeABS33ZCOSCh35jpwuWbQR/RojzAprmWqV5te5nz8EyaQuD5UI1+uhuQqCkhV
	8DPTcWWI25QElYB1bjUt+C921DvdE5RE1WMvXtA2xV+IGXPwdkkTuYZ16fD7Yx8QcIZsJP8Clha
	u3fAJdpCweZfjBdh3WFKChq2m2AVXV8BDZgWfimINXX4UTMujopsL7vIagzhgNRf827jDWGWbRP
	vHFfY/N1QQwibPwnfcQzriBdl/poM7vkQ3t2rg/FYNsjGvQiMSEdCoyMTpgXT5nNoJZl+y2cDHp
	MSKxKLyBsikU0+aeZuhzSFw=
X-Received: by 2002:a05:693c:8312:b0:36a:2473:9b2f with SMTP id 5a478bee46e88-3750a20b93bmr299470eec.23.1794248962308;
        Mon, 09 Nov 2026 10:29:22 -0800 (PST)
Received: from localhost ([2a03:2880:9ff:73::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3752060c4b6sm117168eec.15.2026.11.09.10.29.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 10:29:21 -0800 (PST)
Date: Mon, 09 Nov 2026 10:29:21 -0800
Message-ID: <86219505a92ebc720950d87dc76662f3@gmail.com>
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
In-Reply-To: <179418737701.994134.5100743053640770189@kernel.org>
Subject: Re: [PATCH net-next v3 4/9] net: devmem: add a per-device netmem TX
 frag size limit
Content-Type: text/plain; charset="utf-8"
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> > @@ -734,6 +734,7 @@ zerocopy_fill_skb_from_devmem(struct sk_buff *skb, struct iov_iter *from,
> >  
> >  		size = min_t(size_t, size, length);
> >  		size = min_t(size_t, size, iter_iov_len(from));
> > +		size = min_t(size_t, size, binding->tx_max_frag_size);
> 
> [Severity: Medium]
> Is this the only place the new cap is enforced? The netmem.rst text added
> by this patch says "Devmem TX frags are capped at
> netdev->netmem_tx_max_frag_size". TCP MTU probing looks like it can merge
> the capped frags back together later.

[..]

> Could tcp_clone_payload() compare skb_frag_netmem() and stop merging once
> the binding cap is reached? Another option is to skip MTU probe
> coalescing for unreadable skbs.

Hmm, let me comment on Mina's patches, might be easier not to merge
netmems in tcp_clone_payload at all?

> [Severity: High]
> This isn't a bug introduced by this patch, but the same merge check in
> tcp_clone_payload() looks like it can also combine frags from different
> net_iovs. skb_frag_page() returns NULL for both frags, so the page
> comparison always passes and only the offsets are compared.

[..]

> Should the merge test compare skb_frag_netmem(), the way
> skb_can_coalesce_netmem() does? Nothing later in the series changes
> tcp_output.c.

Mina is gonna take care of this:
https://lore.kernel.org/netdev/20261108013838.1454450-3-almasrymina@google.com/
