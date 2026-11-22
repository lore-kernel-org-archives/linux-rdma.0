Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795378639;
	b=LeTKhCcfYD5OnpQ63dHXVR/GzgFy/CMsgwv2z1HXSSBwwHytBBGAOrx1jKmb+D7TwLQr
	 0CFWY3nk84q97p/5v1E0sy/ypFZHSNESAg9DEqvpltln9JVGlUr7l8L9i+olYfMKXcUig
	 Hes8iacm3auYEmogkCNY78OhzMbKcQBM1gMHqDM6gbM4OgjFLeIMLwRcpKOcZHPP+QwtP
	 relguKrq56hlw0U3GWDeUkf4vPAaZHeNNgmhiwrFfU021oTgMDIm0MbGgWqqqZZbQA3E9
	 tMw8NFuzuR5OofYPK+YoogvRSVaam2c6CYPsbufno3J+L6GPpw0GJJGmI4UcLer71QQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795378639;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=eRHsra6RBQdHsm+/rz4srEJmAl36q57hdP0Dh3GlsWw=;
	b=CH07x0RV/Fvo02a9k04qtUtcmF5U6MZsoTF2ZnBpylfZCA8nJQPXkSjAYZm8aYIaUqY1
	 11pDqgZoTLtPG8jx3XwW5jTV0k2KUpmvXdQ3zlU5FBzLpWjejdi8oMsFNKMi1sxXOsTQR
	 wYKe1+u630YBLkmZ9xeuxRW4eSdG7PhknzLK/l5LwO7tKir8W4i+WcLFY4lGhxDGvy5Or
	 fe5iUMu1g7mfkKRmBzdVkA2KpezEr78cTsQx4aaRF8d1dNEtsDdLqz3Vl2JQcscjBOLfR
	 znvDGEF6/NlpKGGuorJ+B2qgmpmiA2mJ/U49ZP3/s1+/lSeMd819ml2QUFCTVGnGqZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b="KV6a/Ax0";
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A65606A31E;
	Sun, 22 Nov 2026 20:17:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E9A65606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=KV6a/Ax0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1795378630; bh=reaXzdgyMMqRj1zA2Esagitp1XJA0FQvEzoZ17ZFMmI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KV6a/Ax0sBJ8OshW7PRXLVfGl41wyZ6N/c3AOKxOLU/ncq+3wpMoUzOF1cgQam+X0
	 gSlsHOJC9VonxEVes6wxFuYhlz4oAyN/vy17UgWpyJLXYG3BVax7T3gXf+W07SCZ/R
	 OLtU4KJcK3Vz0AjJguVkD0M8M+xGCf903Z6/vwWmb0ecxVsd/ePR9pFJaK5+Pb7aRm
	 i2ZmCGKRc8Acw3APo5oSKUxemfDzfFF4g7FpUNsd6zrKlcE597REeOHXftyoVjlsyl
	 uG3Rq9STohXFHqb2T8HVOuQuyErCFnFeRzQSBgWOwnwA4K/KrwCzBQneySRRSzuY84
	 OKZ7imniFQ22A==
Received: from [0.0.0.0] (unknown [213.228.1.188])
	by rcs.proxad.net (Postfix) with ESMTPSA id 895A944C036C;
	Sun, 22 Nov 2026 21:17:08 +0100 (CET)
Message-ID: <3b3dff0d-e879-4a14-9f17-2b3015b6da39@corp.free.fr>
Date: Sun, 22 Nov 2026 21:17:07 +0100
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
Subject: Re: [PATCH net-next v2 05/10] net/mlx5e: TC, reject a partial tunnel
 key with tunnel mapping
To: netdev-bot+sashiko@kernel.org
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 jhs@mojatatu.com, jiri@resnulli.us, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, michael.chan@broadcom.com,
 pavan.chebbi@broadcom.com, bharat@chelsio.com, donald.hunter@gmail.com,
 corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org,
 dsahern@kernel.org, idosch@nvidia.com, shuah@kernel.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 oss-drivers@corigine.com
References: <20261117092915.255194-6-acassen@corp.free.fr>
 <179514543838.3136.15751272244504735479@kernel.org>
Content-Language: en-US
From: Alexandre Cassen <acassen@corp.free.fr>
In-Reply-To: <179514543838.3136.15751272244504735479@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 11/20/26 04:30, netdev-bot+sashiko@kernel.org wrote:
> [Severity: Low]
> Should this check depend on the tunnel type? For VXLAN and Geneve the
> tunnel id is a 24-bit VNI, but this check requires all 32 mask bits.
>
> The VXLAN and Geneve parsers already refuse keys that do not fit in 24
> bits:
>
> drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c:mlx5e_tc_tun_parse_geneve_vni() {
>      ...
> 	if (be32_to_cpu(enc_keyid.key->keyid) >= MLX5E_TC_TUN_N_VNI) {
>      ...
> 	MLX5_SET(fte_match_set_misc, misc_c, geneve_vni, be32_to_cpu(enc_keyid.mask->keyid));
>      ...
> }
>
> mlx5e_tc_tun_parse_vxlan() has the same check. The mask is then written
> into the 24-bit vxlan_vni or geneve_vni field of fte_match_set_misc, so
> MLX5_SET() cuts it down to 0xffffff. On the VXLAN-GBP path,
> tunnel_header_1 gets mask << 8, which is 0xffffff00 for both masks.
>
> As a result, enc_key_id <vni>/0xffffff and enc_key_id <vni>/0xffffffff
> program the same hardware match. Also, key & 0x00ffffff equals key for
> every key the parser accepts. So the wrong-tunnel-id case from the commit
> message does not seem possible with this mask.
>
> After "net/sched: cls_flower: add enc_key_id mask" later in this series,
> a VXLAN or Geneve rule with the natural full-VNI mask 0xffffff would get
> -EOPNOTSUPP on every tunnel-mapping path. That covers rules in a chain
> greater than 0, and chain 0 rules with goto or sample actions.
>
> Would it work better to compare against the id width of the tunnel (24
> bits for VXLAN/Geneve, 32 for GRE)? Another option is to compare the mask
> only over the bits the device actually programs.


No. This is the question of v1 [1]. On VXLAN and GENEVE, N/0xffffff matches
the same packets as the exact key N and the exact key works in chains.
A check per tunnel width would only accept a second spelling of the same 
rule.

[1] 
https://lore.kernel.org/netdev/35bf2a1f-7f65-45fa-a854-dd4f4c4c0d90@corp.free.fr/


