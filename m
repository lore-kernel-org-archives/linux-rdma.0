Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.7
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794248959;
	b=YYE1T/o3rzbwesi5CaGHorKOvLfDRyLlX3tzqaG9OsIUo9wl3gzFlyoQ85Q3Lmd/6wKW
	 T/75zhy/6P5nUDQ5ix8dxibsan27g/h3aWSZXZo1j9WPWCiG0b3yg3XU2o4mKaxuVU4ik
	 LbQeQQcs8zhB9hTrdCCoNqeHcVroqqc+NBOGPCyqbzOgUX4ciaCG44LoJ9mbOxOrhGB89
	 elRBYuanFW82hECrGIqebGV64E7AA9nm7W64iRY0+fESNhpAudfYr+tMsrRV4J0wjFnNF
	 o9jmT5SzxGXskg8/6RAYFVywtRkR1hz69C0KV/WOWlRfAJAbrloEt183xTpnHc6NoaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794248959;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:Message-ID:From:To:Cc:In-Reply-To:Subject:Content-Type;
	bh=9ABICdwqhmlXu+0O9sYf0hzD9JleqZBucAewgH7hCEo=;
	b=2taSvw3OrTMYjdRxfIxUmNVTa51/NfKs+fSHmpNkxxy2unHxrfuXtVYWxhq6w0HgyuFw
	 BrRMg0VSNHPVeSr/JIgEMu+SqOy1okAkMtpwiF3lYPyq4HipmEwac/BVjZpJMzQQVUr1Q
	 XqnNT5UoBcufVHqFsX53dmYg9bRr1e1OBT3S97kpXfxN3WpZzQl2MJs2KAPq26TwF/cyx
	 8FZJLlGW74SLRM2t6ShDw7KOz3JJoSAclrp4MJh7qpcf5bfScIi8ym3f7sTNzwgoWQ14V
	 rQ0lOOWm60hcjvkj/5jyqIj5C796PCEVUt6Tr9XSVoJRf1PDI9lIBg8XPlN5dyg4brQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jLFcnmT1;
	arc=none smtp.remote-ip=74.125.229.7
Received: from mail-dy2-f7.google.com (mail-dy2-f7.google.com [74.125.229.7])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD65360700B2
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 18:29:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD65360700B2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jLFcnmT1
Received: by mail-dy2-f7.google.com with SMTP id 5a478bee46e88-36c9b5c6faaso930211eec.0
        for <linux-rdma@vger.kernel.org>; Mon, 09 Nov 2026 10:29:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794248958; x=1794853758; darn=vger.kernel.org;
        h=content-type:subject:in-reply-to:cc:to:from:message-id:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=9ABICdwqhmlXu+0O9sYf0hzD9JleqZBucAewgH7hCEo=;
        b=jLFcnmT1udEkBHH8ARZmBU+AHoffdfpm15WgGjDE73KYjuYejVwNQNw4vhBCFbzzSZ
         3HdPMNTl/3sOA+nmNz9n9I3cN0gI1TLo2PuQhNV9jjJ2mdGIaLXQuSR9lEXNTqJtiEGT
         b0ali9Y0D/2oBxr5WuI6PYyCSKic/EPQHdL40/bxKAyTduon4WIMOaG8Czke1mc5FuAn
         7NXD3qXGcob7VykrCwbrZOpUZfPsRvMEcatTaNLvZ4DB/VrDCPWBmccSqLSG4klLZ3zF
         cOKVFzgLV1jlFqnSNxPQQiCRxZa/1qLNeXnSMrUteziGLz6fVM/kBOjY5Xi1sgYAs/5P
         UlqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794248958; x=1794853758;
        h=content-type:subject:in-reply-to:cc:to:from:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9ABICdwqhmlXu+0O9sYf0hzD9JleqZBucAewgH7hCEo=;
        b=tpN51HJa7GJBuGGlLKcuba677kQYUyzQLj+Gzuai3oir2Iryj6OyTTXKUExZTFZPmb
         lyR6RlvW5rGobycB1UNVgRZAK+k5Ps0/t93mWYyqI4P6NvHNjdey4sfDUcBKuckeTCcZ
         bt+Gi3PIaXcm65jJnDHieBZHBUnCHE42eZLcT4pVV2JigtBHSLTI6JDyyxKfSS9YrS4y
         xfujJqPWol0MYnEpYXZyhSwOxKK50iB9wlPJOVk20eZchgomvBaNXLfv02rNo8n+h3n5
         pnhwIfZ1micoCm1wZIb7FNO8YxuRV3PRio4oP7RFk7UJs+JfxDXigMYxEEuozAyShiGs
         Ws9Q==
X-Forwarded-Encrypted: i=1; AL+hErFP38YfNX76v+vTr6ZQ7fJIiPdlcMYgU/E3F5ET01TPsO/vzBjqAcvgkvW/NZaDhFepIqZ8wRAywp/I@vger.kernel.org
X-Gm-Message-State: APuU4Z/k/WsTIIr5kx7cuSOmJ3w4t6XuJEJGo0xaSr4rGyVrP8jldiKM
	ejJNnQTBHs/gMVGp0DTH/OfAT3V1U0GmrKexUBRQHlW52vmwtl1fZ5Nb
X-Gm-Gg: AYBFou3vHqIy9xu3Pufhob99MwkpjuMGj4fRLSci7g1z6PCH2cowUyX797jtT2MqBNK
	VjqE2zBY4MkyOanQy6D7/CyC49o8k4nzji2czmfcbZow40Xnp/MEBtc18szjJHVOSH0IF3LTb1h
	/Cp4pwDVrfnp4/cuJ4ucUNzhE6EUltzLgONlEeplU/4DQDXGtV4RrwrbVgYxj0RHkc1KFtx9842
	3ndK8/hZg3o9Pwl91G+JXux6gg/uubJqaQg6FkXRcE/8okyVCKfXfPEr79SBPu3VH+iVTgTkREz
	DgY8/llwur9QrTnXR69UlUFTF2+FLLDhNQUnp8mVHCLf2PAO9MHPPFn0ZoR4q7hAOwF7X3ChT1/
	fCyMX40PmhbHXdoON/JKr4PT/rEHrWkOqaVNV7UV1tfsO0eiUBhouIWxcTOR0wgchJ19LQ9i3qp
	gG45iUGfa4o3ppZY1jLocANTe22Lw2HwbrMhWkaZc4noDL6R6S6xr1vizqxiIJ6pBmr9JHnZmjI
	a9pcN7P2KboUW3RWc0hTZW3yONxuiIgmbLOq2giV4PCd45WQShfm2VRBLmOHOazsaG/TPS0rN2e
	QwFP00zHZrB3Enhy0C0YkSRgK0bIb1XN0LlJtHSYQbVo
X-Received: by 2002:a05:7022:b90c:b0:1a1:8bac:c1c1 with SMTP id a92af1059eb24-1b3b5fd4344mr353755c88.15.1794248957752;
        Mon, 09 Nov 2026 10:29:17 -0800 (PST)
Received: from localhost ([2a03:2880:9ff:6f::])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5890e04sm722817c88.2.2026.11.09.10.29.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 10:29:17 -0800 (PST)
Date: Mon, 09 Nov 2026 10:29:16 -0800
Message-ID: <3d2b8463b7ea74cde9327a3b8678f1e5@gmail.com>
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
In-Reply-To: <179418738408.994134.12387400537759262351@kernel.org>
Subject: Re: [PATCH net-next v3 8/9] net: devmem: size TX net_iovs from the
 dmabuf sg table
Content-Type: text/plain; charset="utf-8"
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> [Severity: Medium]
> netdev_nl_bind_tx_doit() now passes niov_shift == 0, so a hugepage-backed
> dmabuf gets 2MB TX net_iovs. Can a devmem TX frag then end up larger than
> dev->netmem_tx_max_frag_size?

[..]

> Is a cap applied only at build time enough to keep that contract?

It's not, same as reported for patch 4. In v4 tcp_clone_payload()
won't merge net_iov frags, which keeps the cap with large net_iovs.

> There is also a related issue in the same code. It is pre-existing and
> was not introduced by this patch.

[..]

> Would either of these fix both problems:
> 
>   - compare skb_frag_netmem() and apply binding->tx_max_frag_size in
>     tcp_clone_payload()
>   - don't coalesce unreadable skbs when building MTU probes

Not merging net_iov frags in tcp_clone_payload() fixes both. Mina's
series also compares skb_frag_netmem() there:
https://lore.kernel.org/netdev/20261108013838.1454450-3-almasrymina@google.com/
