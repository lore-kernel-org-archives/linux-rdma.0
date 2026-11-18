Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.133.104.62
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026432;
	b=0N35oAWhC4pVtaUakTVdTGRV85kl9jHfZM7VMHBU1yv+BHxFz0aFQ6ZOHwMLqdqg9pLk
	 BdrGWZ7XI/+cQzXID4qWakGGwa6ADJ/OIDcilYb0jQG2+zr6qZIc3slWfXEq3tO+oAOBP
	 MeRm0Nbpiva0fA/PPebwikqnM+7I+mUSI7vBRAky+kPoatGjwpM2PhQ/Gi4BjY2G/IHp0
	 7y4yWZnygaswJClU9QRJSQ89IjEfrVUil4U9QYBcjSPWr7r+iUE1zkNPpt+O9i34/Z/Qa
	 Aj1yaZ9zyEnAUfrGLUdf/tBB6cMfXu5ufP1pCKcq61llUOn6VW5Nxfa8M18vwJhe6WA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026432;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Virus-Scanned;
	bh=kQ8DyF1/v6HIM+JWWjYVxIs1gLifqeg4BwJopfCzUy8=;
	b=kE2GRsv8QwhxMVuWWRtyBaRtD4bpJCcdKdBAAHbhIAEHY4TABf00xZJhNM6hWW+Rml54
	 vaPUArVeGNBYYjmrn0pptHB7xQCIqz3WygG/9BySsa6yrpFLzhvHkqszcDT+InaKxlS7/
	 5bPiqMDiW0OervUWebzdLGsMT+vggOa+lcrk4EsKI2RRtepvK2IXXyOpo6cuBWLr1YqgP
	 Hi80qP7n262Sxy8lsemtPEqSLDNlrSTANEoQHt73Tt7RSYTqC+wXt/MqR4NNubp0Qej0n
	 SLjTZt4MGB6h0xYT+Sftd0sHc4vf+t/FZSktwA2Gch0xtYTNqt+8VlFq5vKKmtLAWkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=iogearbox.net;
	spf=pass smtp.mailfrom=iogearbox.net;
	dkim=pass header.d=iogearbox.net header.i=@iogearbox.net header.a=rsa-sha256 header.s=default2302 header.b=pcPNb8Ve;
	arc=none smtp.remote-ip=213.133.104.62
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF44606A337;
	Wed, 18 Nov 2026 18:27:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2BF44606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iogearbox.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iogearbox.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=iogearbox.net header.i=@iogearbox.net header.a=rsa-sha256 header.s=default2302 header.b=pcPNb8Ve
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=kQ8DyF1/v6HIM+JWWjYVxIs1gLifqeg4BwJopfCzUy8=; b=pcPNb8Ve0lfmKj5OjcQoE5P4F8
	Wc3bdDQWed8zDgTEnKafoYEkUR8YDZrP4sVmPz62AWiOBALYxPbZshN2fpAbWqjcd0ujNh0WUg5Im
	taBJOdHVWjUrOYSlRkuwGPtuoH3NArKN9ocuTwt1yVi59h8Gb8PvGlpgMi1dWwAvypaNQmAdPR+Dh
	v93C+3chhfmjLoB9Zf+mN3BiSvIyIIDob8K2gwDeaD9/bPqoW9bNq5x4x176cUqh5X/NWxkdl/pYL
	PclxpqOvNTkiTjNLR49M6XWYm/JOazfBHWZiylBcQHqXMqBT+bXm+MY+uq2oxbs9DIrOO1EtnTWJY
	5EFpXrew==;
Received: from sslproxy07.your-server.de ([78.47.199.104])
	by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <daniel@iogearbox.net>)
	id 1xTkMx-0004Wo-1d;
	Wed, 18 Nov 2026 19:26:55 +0100
Received: from localhost ([127.0.0.1])
	by sslproxy07.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <daniel@iogearbox.net>)
	id 1xTkMw-000Hvj-08;
	Wed, 18 Nov 2026 19:26:54 +0100
Message-ID: <4d271539-b2f5-4fb9-a4dd-32becd02ce5e@iogearbox.net>
Date: Wed, 18 Nov 2026 19:26:53 +0100
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
To: Todd Bert Freed <toddfreed@meta.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
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
 <ea8a18e0-12cc-48e0-903e-325a8ece5a0f@iogearbox.net>
 <CADh2yMxffQ3cywT3aNg3SkVfog5CFnUSp34F1esyun-xUBVa9g@mail.gmail.com>
Content-Language: en-US
From: Daniel Borkmann <daniel@iogearbox.net>
In-Reply-To: <CADh2yMxffQ3cywT3aNg3SkVfog5CFnUSp34F1esyun-xUBVa9g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: Clear (ClamAV 1.4.6/28187/Wed Nov 18 07:28:39 2026)

On 11/18/26 6:46 PM, Todd Bert Freed wrote:
>>> +     /* On transmit, decrypted asks the device to encrypt the packet. Sent
>>> +      * to ingress, the packet would read as decrypted by the device.
>>> +      */
>>> +     if (unlikely((flags & BPF_F_INGRESS) && !skb_at_tc_ingress(skb) &&
>>> +                  skb_is_decrypted(skb))) {
>>> +             kfree_skb(skb);
>>> +             return -EINVAL;
>>
>> This check should rather live in the bpf_redirect (and friends) helper e.g. after
>> we check for invalid params, etc, rather than here which feels off. Also, it would
>> probably make sense to refactor this condition into a small inline helper so you
>> don't have to open code it multiple times.
> 
> Sounds good I will move this check into the two callers
> (bpf_clone_redirect() and
> skb_do_redirect()) under a helper.

But why under skb_do_redirect? I meant just here:

diff --git a/net/core/filter.c b/net/core/filter.c
index 532405988fd9..ba112111de22 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2471,6 +2471,8 @@ BPF_CALL_3(bpf_clone_redirect, struct sk_buff *, skb, u32, ifindex, u64, flags)
  
         if (unlikely(flags & (~(BPF_F_INGRESS) | BPF_F_REDIRECT_INTERNAL)))
                 return -EINVAL;
+       if (...cond...)
+               return -EOPNOTSUPP;
  
         /* BPF test infra's convert___skb_to_skb() can create type-less
          * GSO packets. gso_features_check() will detect this as a bad
@@ -2563,6 +2565,8 @@ BPF_CALL_2(bpf_redirect, u32, ifindex, u64, flags)
         if (unlikely(!bpf_net_ctx_get() ||
                      (flags & (~(BPF_F_INGRESS) | BPF_F_REDIRECT_INTERNAL))))
                 return TC_ACT_SHOT;
+       if (...cond...)
+               return TC_ACT_SHOT;
  
         ri = bpf_net_ctx_get_ri();
         ri->flags = flags;

> FYI this patch was moved to the net series "net: don't redirect
> decrypted skbs to
> ingress, psp time-wait validator", so you will see this applied to v3 there.
> 
> -Todd

