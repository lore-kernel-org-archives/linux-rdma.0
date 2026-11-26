Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795686844;
	b=vfoTcEhHfKk8hhHXXw0t1nw6aUUMeGTTFWq3dAMTK70MHu/ELFRjIdWeZSyiadeYCXsd
	 CWf7UeSWRneXpd/B+u98zDXVXFaUnAFZjax6eUuqz51sn4m8GTAI8No0YBTxzS2igyJLz
	 E4aBNuUUnhrj22QAD6NY0hoQ93dYh35itLxflxjFa7BSgyq3EGHL/8J0T1kVypT0gSWVc
	 FJqQDS8pJiFDfNrtBIX3fE/Uqa5/DlmPXPgwnj5oBwdClFMZyrTHBxc9yToBCu3i8Ihjr
	 PH7KrUHTh+C7JYOhZPnQrb4KzLJ++JUb3OMBCv7L5wn/aTfo+KbPbdqzbA9UKOcUytA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795686844;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:Cc:References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=7CCtYtbFe6le29oXXPU1ooKs9Dx0yxyQEI4GjlG+sf0=;
	b=sV4BNroWv3OQhHse8nIFg49nv+F0SMDveC/LGVnmnQBu/sj8V1NisMNO8FFdDJeseHxg
	 BPsuBe3LWnoSa6ucwWPigIcmQH2dEUMzWACd8kac4fucJh0UlezjiK97us83db3FfwjDl
	 nItVJC/8K/FtRD6EpeB590HwhBjLuT77YxnowNcQwX2jNIcrFxSwZnjN45uLY+v3RLMoI
	 RysWm+Qy4B7Z50a7HH/CR0WA6nfmQFWv01R34jR80TD2Jz9Vis9im0YmY+SLVO/ZN9aWz
	 7wqLj6Q80XRlGt7tTRuEuBD8hnFpUtXhZG3zkX7a6S1FVSQg5UdPrcpEFL6gtVelkaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=RV9FN4OI;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=lLANQDpJ;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9D5606A32C
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 09:54:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED9D5606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=RV9FN4OI;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=lLANQDpJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795686843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7CCtYtbFe6le29oXXPU1ooKs9Dx0yxyQEI4GjlG+sf0=;
	b=RV9FN4OI/ZTrw+N+1q5AxeSan5a/Mc0XQxKdy92oratGqXcj3yBvhwrtqP9sbY0AfA8van
	+x8uF5Gz43fNFcAlobm83Gd7p/TW29gE7YD5prLbbNFdJ34ZwbqpUzxwPFoykVXz6tMoP6
	kGKAJ1P7Uxh2X4M3Tr+UZQXcMJGfi4Q=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-81-dKy6QoPGPP2jJ77qLjoNFg-1; Thu, 26 Nov 2026 09:54:01 +0000
X-MC-Unique: dKy6QoPGPP2jJ77qLjoNFg-1
X-Mimecast-MFC-AGG-ID: dKy6QoPGPP2jJ77qLjoNFg_1795686840
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a16dc2323cso34415405e9.3
        for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 01:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795686840; x=1796291640; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7CCtYtbFe6le29oXXPU1ooKs9Dx0yxyQEI4GjlG+sf0=;
        b=lLANQDpJub1DKFq7TEwFDOcI3TJRHlZmh/96ElOaxlirzCADY6GEeAAS0Ytz4xY9ac
         5B1akJcEHITQjWhDe8R0Pnm0DnHAKpgdvwivbzSVQMYqVO2uQbxzKM/G0ulUAQBFOCbU
         oej8brmCszD1p185zkHyss2sZ+zOsT6Qvgpub0JOaSbzWMrEqPYip1KYARYYkNnFmv6V
         wu+0jdFe5/Tg9vPOBQ2dyGMB4w72BWETBgiI8GoSNbYX9y1MLJLbhsHuR347/DiYP+eO
         njm3nb5bzAMHRw7otWLdk9Gkb8UUOazx9ZrH/dhp1I6vG5mBOSZjRbcjITQEtmneLnVO
         YnsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795686840; x=1796291640;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7CCtYtbFe6le29oXXPU1ooKs9Dx0yxyQEI4GjlG+sf0=;
        b=zd7zGmDWKKbh+Q2jBjKk1B/qLUXtJ2psHJzAmD389LwM7XnqibxTvP7QdxlOpaoCA+
         ixskOAfnZGCIkCvDtwkkrAcoXOjq5crTbUO4//uhHb4uSouaGz+UrPBBlIPpropN2uyl
         f/22NJUmpmgK5yaHyOoPC5hbVL+3U+3eFWHKfxS47EMPP3sC72UQvcnYYzWTkC475tbu
         MgphGnmgUOKm3e46FAtjWhaUXV3dTLYu6oRDQY6G47s/arLm6wIXEjaP7zFkSVB9Rd6C
         E6vJQMciP8FIp4zi5Y7/pjdepZeX0Fi6QE4R4/NTnPYOGVF6R+CyMxIs3hvrUXbIat0n
         8tQw==
X-Forwarded-Encrypted: i=1; AL+hErEddNDb9qIdXe3tC7/7lJohlyQTU8NT6e2D18T67l7JvYe93zXNHxYU7FRVTHZIaTmwhAB6mb6pT7a0@vger.kernel.org
X-Gm-Message-State: APuU4Z+sXyY8jBYwIFUYlii8EccN6jZV2iATNNILkqM4xUG2geHeZI1g
	eCsoP+EjNqWeAAOjy/tlVzb2bVdBF/RKV3jYvSkdhwvN8RW0ltDtxvNCkznEvApw1/GhOYj9+Iv
	74OTlBW7ypCWGk5p89KSDmt6mD6UHh3+9Ezu0ekfKcZmTSwj0vM7/yNVOaOCZTEA=
X-Gm-Gg: AZFdTZcR7G2w7tdCcR77Zjw+WsORMYLC8Yec4WaB6Qnzjc1YrJ/tJs1RIDj+8ei9/a/
	yz49v7MBMobGlafnuV5A8sI2+CvkIDKAZpj6MpH9dXjJ7DaOBJRnHFVD+DnzzkUdsmVBvSijiJ6
	FDaWOq95sUhDVucoLuU9hIMhuIutzfkUgDocxHztCUPQyd8Zp0tfr96rfZoiwyNLBRFUympN73A
	AKXQrvwjkmzY+MkjFwmRaqkUI0X0PttpZ2hNHGXEjJmPpAIFw35zSaSMAfLC5j1wk41hxo1q/rQ
	Z2+NzpfLy/dgVlOwPMhMYFDDdItIR/tCgk+aGPmoqBMJa0t9AFI/d576qu3a4NqwF5qnWQZfU94
	wF7TDb8rL5XhnfFx7TJwuNNHRhOrRIYRN05QzZ9MaN3UG+OdnyfOFak/v4LJjS1eCiesse3KNqE
	ANldutHY6AQ3HUmkNlxOtBTqZuBGrjKAYHSjOYi25BvtaW
X-Received: by 2002:a05:600c:4e16:b0:4bb:6f77:1e35 with SMTP id 5b1f17b1804b1-4bb88810991mr440507415e9.21.1795686839798;
        Thu, 26 Nov 2026 01:53:59 -0800 (PST)
X-Received: by 2002:a05:600c:4e16:b0:4bb:6f77:1e35 with SMTP id 5b1f17b1804b1-4bb88810991mr440506695e9.21.1795686839381;
        Thu, 26 Nov 2026 01:53:59 -0800 (PST)
Received: from [192.168.88.30] (ip231-128-192-82.pool-bba.aruba.it. [82.192.128.231])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab658e2d1bsm41250729f8f.8.2026.11.26.01.53.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2026 01:53:58 -0800 (PST)
Message-ID: <34e77fff-c57b-4ed0-9035-b9682ad3914e@redhat.com>
Date: Thu, 26 Nov 2026 10:53:56 +0100
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
Subject: Re: [PATCH net v3 1/2] net: keep the TCP fixed-ID flags on the header
 they describe
To: Julius Bairaktaris <julius@bairaktaris.de>, netdev@vger.kernel.org
Cc: davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 willemb@google.com, horms@kernel.org, andrew+netdev@lunn.ch,
 dsahern@kernel.org, idosch@nvidia.com, ncardwell@google.com,
 kuniyu@google.com, steffen.klassert@secunet.com,
 herbert@gondor.apana.org.au, richardbgobert@gmail.com,
 ecree.xilinx@gmail.com, andy.moreton@amd.com, alex.austin@amd.com,
 linux-net-drivers@amd.com, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, leon@kernel.org, linux-rdma@vger.kernel.org,
 alexei.starovoitov@gmail.com, ast@kernel.org, daniel@iogearbox.net,
 andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com,
 martin.lau@linux.dev, song@kernel.org, yonghong.song@linux.dev,
 jolsa@kernel.org, emil@etsalapatis.com, ihor.solodrai@linux.dev,
 john.fastabend@gmail.com, sdf@fomichev.me, izaiahsun@gmail.com,
 corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org,
 shuah@kernel.org, bpf@vger.kernel.org, ipsec@lists.linux.dev,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <cover.1795284858.git.julius@bairaktaris.de>
 <7c74b2076dc7dee1d481d39a135e0946d5e04145.1795284858.git.julius@bairaktaris.de>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <7c74b2076dc7dee1d481d39a135e0946d5e04145.1795284858.git.julius@bairaktaris.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/21/26 19:26, Julius Bairaktaris wrote:
> Commit 3271f19bf7b9 ("net: gso: restore ids of outer ip headers
> correctly") made SKB_GSO_TCP_FIXEDID describe the outermost IPv4 header
> and added SKB_GSO_TCP_FIXEDID_INNER for the inner header of an
> encapsulated packet. Every path that adds or removes a header then has to
> move the flags, and none does. A TCP stream that GRO merged with fixed
> IDs and that is forwarded into an IPIP tunnel, or into an ESP tunnel mode
> SA with crypto offload, is segmented with one outer ID for all segments
> and with incrementing inner IDs. A tunnel that decapsulates such a packet
> in iptunnel_pull_offloads() leaves the state of the removed outer header
> on the new outer one, and the inner header of a GRE or UDP tunnel, which
> segmentation reads at encap_level 0, gets the state of the outer header.
> 
> Let SKB_GSO_TCP_FIXEDID describe the innermost IPv4 header again, as it
> did before that commit, and replace SKB_GSO_TCP_FIXEDID_INNER with
> SKB_GSO_TCP_FIXEDID_OUTER for the outermost header of an encapsulated
> packet. Where a header is added in front of a GSO packet, in
> iptunnel_handle_offloads() and in the BPF LWT encapsulation, clear the
> outer flag, so that the new header gets incrementing IDs as it does on a
> packet that was not encapsulated before. Clear it as well where
> iptunnel_pull_offloads() and bpf_skb_net_shrink() remove the outer
> header. ESP transport and BEET mode with crypto offload set
> skb->encapsulation but keep the IPv4 header and its ID, so xfrm_output()
> copies the inner flag to the outer one for them. Convert mlx5 and sfc,
> the two drivers that use the inner flag.
> 
> Two flags cannot describe a header between the outermost and the
> innermost one of a packet with three IPv4 headers: software segmentation
> uses SKB_GSO_TCP_FIXEDID for it, as it used SKB_GSO_TCP_FIXEDID_INNER
> before.
> 
> Fixes: 3271f19bf7b9 ("net: gso: restore ids of outer ip headers correctly")
> Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
This patch is IMHO too invasive for 'net' at this point of the cycle.

I suggest targeting net-next in the next iteration

/P

