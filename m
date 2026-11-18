Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.133.104.62
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795006729;
	b=Co9dTaOVCfqnULECVAvXSgk1DvCydVj/gT33bNQKNclW7utGkg8LZQaT9Vs9wN3Uu6yQ
	 QjTS+EGs7XE8E8UkHcFqJj3lx04GfvTEAXtHmPt9MSOBFSp1z0cfvYpJMmLcb7sUBM8wR
	 bKvO1rFtnhFYVe/xIc3YWAxP2S6N4WaWK3JHwgzFH6PJgrn/uI+IkGRcJLRrXuLsEaAQ2
	 IKvtL1T8JaY7NVYvDs/YwpzkUCiH5W/eASYLgrVVs4meEHITMpwN2Fg/HZpn3ApDTa+xh
	 CoF01U4IVUiDQJcqsa0/vlSYRkg8qogFl9EdmyQR5A676ydEDxxOy6cxpEOU9FpYDCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795006729;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Virus-Scanned;
	bh=zmvoEpqpabGUDsHZXTw1VbdurVjwfR2E9sHZpTo3HYM=;
	b=WKmPttozYCo1Wp7TV45T+E+PUvBptnxDcEEZphLzFlEk94mVYS3OWdUfm0v3jZ3KGxqq
	 XG+t5FUXYHAkMtALlo0fBpOiPSNgLAFPCcznsUsSaJjEsFhu4XJvDDHXHtqQzGuRs0pfz
	 MRopzYTXSeLgNCzFXNAYgccrHtwkvvkAFc8GAfWqlj3+eFFGT6z3eLQ6bzxlMZEg6EYI+
	 FQE7X8wHKneW3Xi+cmgxrR6ckZyYypWxQAjNkGYieUvVx8u6x0okegxVP6wVRYF0gLGCB
	 1ylGJ/4IimIWkIF5gxurNrEhQ41yzzpzfANicabmJnfAWN3QRv9oep5JQFWkM/LUcNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=iogearbox.net;
	spf=pass smtp.mailfrom=iogearbox.net;
	dkim=pass header.d=iogearbox.net header.i=@iogearbox.net header.a=rsa-sha256 header.s=default2302 header.b=IMyNwftp;
	arc=none smtp.remote-ip=213.133.104.62
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2101F606A31C;
	Wed, 18 Nov 2026 12:58:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2101F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iogearbox.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iogearbox.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=iogearbox.net header.i=@iogearbox.net header.a=rsa-sha256 header.s=default2302 header.b=IMyNwftp
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=zmvoEpqpabGUDsHZXTw1VbdurVjwfR2E9sHZpTo3HYM=; b=IMyNwftpJQEBaOtzIEomo/t7jA
	vkVKeXPQoA7pYiC+2twrNnhLQd0YAs50KQTXzTqZiThLSUfCT1V4bIO7I5nMCrTp/q3y126Ybxpxc
	ZMTMSnsF6ALNVgk7NgX+3RbTNP3WiPz2npr/YzHgA0+l3ke+Z609hcLwKu4Iy6BGCSTtfB/AFrSI5
	hIh/fW5DPOyJSsCCTwsSeNRzviEHBJ8FA6IHpNfLZKc4EZ+EkVuYyRoYck4Yse4V6JB0cLquUNXpE
	UZduZCDYsp+NWVFgNswnfYTezTQ6PBxc45a+Ic7sGpfxKmSVwd7Hwh/XuxD3cn3RHh5IxdTd8AdxK
	TchBa8SQ==;
Received: from sslproxy01.your-server.de ([78.46.139.224])
	by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <daniel@iogearbox.net>)
	id 1xTfF7-000KaM-0J;
	Wed, 18 Nov 2026 13:58:29 +0100
Received: from localhost ([127.0.0.1])
	by sslproxy01.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <daniel@iogearbox.net>)
	id 1xTfF6-000PVf-0a;
	Wed, 18 Nov 2026 13:58:27 +0100
Message-ID: <ea8a18e0-12cc-48e0-903e-325a8ece5a0f@iogearbox.net>
Date: Wed, 18 Nov 2026 13:58:26 +0100
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
Subject: Re: [PATCH net-next v1 07/15] bpf: don't redirect decrypted skbs from
 egress to ingress
To: Todd Freed <toddfreed@meta.com>, netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
 Andrew Lunn <andrew+netdev@lunn.ch>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?=
 <bjorn@kernel.org>, bpf@vger.kernel.org,
 Daniel Zahka <daniel.zahka@gmail.com>,
 Donald Hunter <donald.hunter@gmail.com>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Jamal Hadi Salim <jhs@mojatatu.com>,
 Jiri Pirko <jiri@resnulli.us>, John Fastabend <john.fastabend@gmail.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org,
 Martin KaFai Lau <martin.lau@linux.dev>, Paolo Abeni <pabeni@redhat.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Simon Horman <horms@kernel.org>,
 Tariq Toukan <tariqt@nvidia.com>, Wei Wang <weiwan@google.com>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>
References: <20261111005533.6436-1-toddfreed@meta.com>
 <20261111005533.6436-8-toddfreed@meta.com>
Content-Language: en-US
From: Daniel Borkmann <daniel@iogearbox.net>
In-Reply-To: <20261111005533.6436-8-toddfreed@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: Clear (ClamAV 1.4.6/28187/Wed Nov 18 07:28:39 2026)

On 11/11/26 1:55 AM, Todd Freed wrote:
> on transmit, skb->decrypted means the device must encrypt the packet.
> For example, a packet of a ktls or psp offload socket, or, with the tc
> psp action added later in this series, one which psp encap attached a
> tx association to.
> 
> on receive, skb->decrypted means the device decrypted the packet.
> 
> bpf_redirect() and bpf_clone_redirect() with BPF_F_INGRESS send the
> packet to a device's receive path with the bit still set, where it
> indicates the packet was decrypted by the device.
> 
> this is less of a problem with socket offloads, whose packets are by
> definition generated locally; more of a problem with socket-less psp,
> which can also apply to forwarded traffic.
> 
> in addition, the redirect drops the dst (skb_scrub_packet()), which for
> socket-less psp carries the tx association.
> 
> drop decrypted skbs which bpf redirects from egress to ingress. this
> matches the behavior of mirred, since the previous patch.
> 
> Signed-off-by: Todd Freed <toddfreed@meta.com>
> ---
>   net/core/filter.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index aca8160b26a1..a178a9dd3007 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -2226,6 +2226,15 @@ static int __bpf_redirect_common(struct sk_buff *skb, struct net_device *dev,
>   static int __bpf_redirect(struct sk_buff *skb, struct net_device *dev,
>   			  u32 flags)
>   {
> +	/* On transmit, decrypted asks the device to encrypt the packet. Sent
> +	 * to ingress, the packet would read as decrypted by the device.
> +	 */
> +	if (unlikely((flags & BPF_F_INGRESS) && !skb_at_tc_ingress(skb) &&
> +		     skb_is_decrypted(skb))) {
> +		kfree_skb(skb);
> +		return -EINVAL;

This check should rather live in the bpf_redirect (and friends) helper e.g. after
we check for invalid params, etc, rather than here which feels off. Also, it would
probably make sense to refactor this condition into a small inline helper so you
don't have to open code it multiple times.

> +	}
> +
>   	if (dev_is_mac_header_xmit(dev))
>   		return __bpf_redirect_common(skb, dev, flags);
>   	else

