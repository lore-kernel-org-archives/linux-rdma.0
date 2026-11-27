Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795817995;
	b=b8xYJKXLLUVzJB9G6sXTDo8DUBQnhshPCcxSvmvNp80jtbxLevxfFTtog5yeJ5f0HFfZ
	 3lehchDBfbFJwBbxKa8Hovx+wwIIhKOojAlNbQWtre1DbYV0TB9U4s/ilCmBi3DkJpeyd
	 AB6PTjZ+vb4Yx5K1pJJaMX40sbbzmofBWhBhhqEKYWo3ul85RJgTAJx9KEwnxp8y4QvO9
	 UQWo9ktj3+OM6VuEWHwQ9hc+/RpHu1BSmuy1FUPk6BTZRkgsHWZe05Q0JCsXeM77CzhcY
	 lxYCjGlz9zHW92/H6NzS9+KexQdmkThZIvje/pAr1EyHPLcAtADTX7zHlk5rTiWsOUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795817995;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=Vcatt8Yseeu3grJzN3DTmydm5PfHsbdoMOyAc0A57NA=;
	b=T7CwTpz2+pYjUNbqyOfnxB8WKwQJecaxyWQb+ARKkmtPd6hnuyGZ3lUa9mgDAGDsQKwr
	 6RWcZ+1B1d8/9xcciocBiBj4Le/hjUh7zmBU3IoEasn2N4FdzkW2Z9BpdviIG5G7FPu3/
	 JXZDPx6VgfSrp/4USzUP/J6rgJDDIhrhzmLCHz7lIuNnyAX3/J15jwtgtY9uxTtVubdb4
	 zNizpS9KUpyo3u8v4MZ+srHglk0+pjgD0kvzfKYgnBRaHxFo2LDQKK+UhgykNH5zRUUux
	 oxlDzfYBhUo48J6v4GQpS7/BWuGesyTk2O/ZyT+sx0g4d02ZEoL+fX6MkmOSsI0wzdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=Nx1oBwoL;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEFAC606A323;
	Fri, 27 Nov 2026 22:19:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BEFAC606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=Nx1oBwoL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1795817986; bh=VeQyV1mK6VqRPBq7e4DAfTGfLV31JYzS0eyZ60VjWkc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Nx1oBwoLHoI7ZVYWfrmJtNjkBGdp2lVkR/VnEedfRGU1jG69wYyIRZ8zQ+bhCYt1y
	 DAdiYW9jXt1H1vhddY2NB5kk1rsV8ygcp9W4TT+HK6oVDiARIeZbLCaFbhP2IbQF2P
	 M5fJtldf7n4O3HeNL1B1Ws/luqWAupjpm1cXRIOrOlQh28hzoAxwNk/5Qz7ByTlvBb
	 0PVZtUJn7frCZFCxJwtocycW+pSl1Nnc4i5TE5pOVIThXSu/HijWT9kbs6HfIa8ckA
	 Cn5ct07ehiJVFUmZnhBB9vVbMRaJb8xk10ixVsvVt9WpxLB1UMaP5NLRLAWHTqTOdP
	 hwPfnq4NAzzzg==
Received: from [0.0.0.0] (unknown [213.228.1.188])
	by rcs.proxad.net (Postfix) with ESMTPSA id 45D0344C0E09;
	Fri, 27 Nov 2026 23:19:44 +0100 (CET)
Message-ID: <3c82dec8-e3b9-4095-ad40-232dcc811f13@corp.free.fr>
Date: Fri, 27 Nov 2026 23:19:43 +0100
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
Subject: Re: [PATCH net-next v3 05/11] net/mlx5e: TC, reject a partial tunnel
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
References: <20261122213200.3207385-6-acassen@corp.free.fr>
 <179546966530.3135.14742631609975673237@kernel.org>
Content-Language: en-US
From: Alexandre Cassen <acassen@corp.free.fr>
In-Reply-To: <179546966530.3135.14742631609975673237@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/23/26 22:34, netdev-bot+sashiko@kernel.org wrote:
> [Severity: Low]
> Is this check too strict for VXLAN and Geneve? It compares against a
> 32-bit all-ones mask for every tunnel type. Those tunnels carry a 24-bit
> VNI, so a mask of 0x00ffffff already covers every bit a packet can carry.
> 
> Both parsers run before mlx5e_get_flow_tunnel_id(), and they already
> reject keys that don't fit in 24 bits:
> 
> mlx5e_tc_tun_parse_vxlan() and mlx5e_tc_tun_parse_geneve_vni():
> 	if (be32_to_cpu(enc_keyid.key->keyid) >= MLX5E_TC_TUN_N_VNI) {
> 		NL_SET_ERR_MSG_MOD(extack,
> 				   "Tunnel key does not fit the 24 bit VNI");
> 
> The mask is then written into fte_match_set_misc.vxlan_vni[0x18] or
> geneve_vni[0x18]. Both fields are 24 bits wide, so 0x00ffffff and
> 0xffffffff program the same hardware match.
> 
> This means the masked key stored in the tunnel mapping is the full VNI.
> key32_to_tunnel_id(key.enc_key_id.keyid) in mlx5e_restore_tunnel() would
> give back the packet's real tunnel id, so the wrong-id restore described
> in the commit message can't happen with this mask.
> 
> Once the flower enc_key_id mask patch later in this series is applied, a
> VXLAN or Geneve rule such as "enc_key_id 42/0xffffff ... action goto
> chain 1" would fail here with -EOPNOTSUPP. The same goes for a sample
> action, or for any such rule in a chain above 0. With skip_sw the rule
> is refused, and otherwise it stays in software. Only GRE uses all 32
> bits of the key.
> 
> Could the check instead require that the mask covers the full key width
> of the tunnel type? No later patch in the series changes
> mlx5e_get_flow_tunnel_id(), so this limit is still there at the end of
> the series.
No as on v1 and v2 [1]. The exact key matches the same packets and this 
works in chains.

[1] 
https://lore.kernel.org/netdev/3b3dff0d-e879-4a14-9f17-2b3015b6da39@corp.free.fr/
