Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793097031;
	b=GmJnN2t7HsNmaVCZ1wmMjMBo4f4Lph1xC2JxUI9uzgyyaki9D3IENoU8vky+7UE2PHfw
	 ScvnRuDMJMIb4RJw7rTT8H4IwLfVKavb7p+1WSbcT8gaXX79+KBJ7JR2kDuD/J1pKxmwi
	 ohnVoKXzr2g7AZrKqtyct3iLQPYewewo10qbuDRtmFRZkgfvtpbIyaR3yrXK1j7Ri+JA8
	 eGKohAR4wK3dw2aOIk9tmep4LTRIWTucTJnsNBd7EtE11SySYIkVeo70Nt3NpJPLYcq9l
	 zyCxTr8lxR7KN5TQ6I4GVIGUPjCQNRTrSZEAec/EnxpwKRnP7RptMv2M+t2stB8nRtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793097031;
	h=Received:DKIM-Signature:From:To:Cc:Subject:In-Reply-To:References:
	 Date:Message-ID:MIME-Version:Content-Type;
	bh=atsgBdyBqegGK3OVxmB2Ib4i2Mom+Mos8vzmgTui5jE=;
	b=2jljJjTqSrx3jhHursNnQx1LhaeGPgoFqQ1PmD12mxdwou3GdLqiyWPHoVnbVTmgjbCF
	 jsT4X/p8v8ZA+eatRZAaY8XN7q2uN+ASTaGg3xS3GSHFkCjVfJmdksezXopCHvr0IQ/hP
	 DaJSZ8sFsm/Rkrz31uTW/M8mrco0cfWOPT4mXZBHWuysP+9WNj5U2HQSN6R/E5OMlkDJG
	 4lF4MYN9iN7ZO3Kn/dl+Is7VU0zumZICDzbpa9XvSqNBI8r8kL+MfYgmWKUa33pbE+hcS
	 kZHdV0TMyTk6qCsmilox34nTLlrDChQBaBxp3Ii5QnaggA0a7adfypXPBLuzJ31MZ1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ibEQ5JRM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD8E606A31D;
	Tue, 27 Oct 2026 10:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ibEQ5JRM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA5C1F01825;
	Tue, 27 Oct 2026 10:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793097030;
	bh=atsgBdyBqegGK3OVxmB2Ib4i2Mom+Mos8vzmgTui5jE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=ibEQ5JRM+nfVFJq71Qq0Afypd9bmp6lFF7bzm1lzHy8GqnPTZ5RWE0cE93UKnrNPO
	 tzFqXukA/l1OZRRAbQ/1pnPIUl5Y1u4nGSWS1flr8p/+1Ui9tDabfwD9jnDyOxyhLR
	 k/ALoULdgPTNgeyhhnotKEXWx5FgiiyTZ2yaeJq/yO9fJsb7/z99pNo+8BgC9nKE6d
	 VyDf6gCz/7l68rlWVLMLB/V2a2ZZNU2CrFXmzyB11Egpnq6Z4NrKzrgOY9h3ZABeYU
	 GFLIUyncemQuAtiKBGs68MTnobMNsY5X/WNKqtWQ8PECCsfqXEDWZXqCq86lTxuUxA
	 afsj8Y2pq3oQQ==
From: =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>, Todd Bert Freed <toddfreed@meta.com>
Cc: netdev-bot+sashiko@kernel.org, netdev@vger.kernel.org,
 borisp@nvidia.com, saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
 mbloch@nvidia.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@kernel.org, pabeni@redhat.com, daniel.zahka@gmail.com,
 willemdebruijn.kernel@gmail.com, horms@kernel.org, shuah@kernel.org,
 cratiu@nvidia.com, raeds@nvidia.com, rrameshbabu@nvidia.com,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, dtatulea@nvidia.com
Subject: Re: [PATCH net v3 2/4] psp: support ipv6 extension headers in
 psp_dev_rcv() decap
In-Reply-To: <20261026175805.6d4dcae5@kernel.org>
References: <20261023234640.1459291-3-toddfreed@meta.com>
 <179288570143.3134.8925369868949382653@kernel.org>
 <CADh2yMyYS-PWP4912En9D6B9up6Kz-hnCthNkWot+e7N8-q7ZA@mail.gmail.com>
 <20261026175805.6d4dcae5@kernel.org>
Date: Tue, 27 Oct 2026 11:30:26 +0100
Message-ID: <874ie75tbx.fsf@all.your.base.are.belong.to.us>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Jakub Kicinski <kuba@kernel.org> writes:

> On Mon, 26 Oct 2026 15:05:42 -0700 Todd Bert Freed wrote:
>> > The PSP ICV doesn't cover the outer IPv6 header or its extension headers.
>> > An on-path attacker could take a captured PSP packet, insert one of these
>> > headers, and set saddr to an address they control. This assumes the
>> > device authenticates such packets, which this patch's premise implies.
>> >
>> > Several of those handlers reply with an ICMPv6 error that quotes the
>> > packet. With default sysctls, this happens for an unrecognized routing
>> > header type (type 0, for example) with segments_left != 0:
>> >
>> > Before this patch, all of these packets were dropped at the is_udp check.
>> > Forwarding the decrypted skb itself looks blocked by
>> > sk_validate_xmit_skb() ("unencrypted skb with no associated socket -
>> > dropping"). That leaves the ICMP error path as the open channel.  
>> 
>> Agree with this finding.
>
> If we're leaking cleartext in ICMP responses that's also a problem
> for TLS offload. We should fix that, based on skb->decrypt. right?

Ugh, interesting. Drop ICMP (no, on v6...), or just include up to, but
not including transport headers?
