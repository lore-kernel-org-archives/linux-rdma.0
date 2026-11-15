Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794733958;
	b=LONoRWs+KIkCjyHcZz8VxVbVRa/ho1h4QJ3qQj29c4B4PnsN0NEChv/OW5/aOWRFdh+m
	 vy8/jwwVbzLbj/LblroTo5vqnpfVulTvj16LaXshaX9A8/xUIPDoEz5RVeL2+c8Tyh80L
	 1pAI5/1m5gX3VBNzr4YsXUaaKbbaYod4SbOrfAzCJAzlQS8ifTNeEIqdnUpa3bX+8Xr5U
	 w2ONuIJiXpHeRtcDRrBizW+oElN6HS4vvuk2h423yhcY9dZ5j6VkO2IEsUITfPuwuqOaV
	 6cNX3UY5FFovOV7kWZvBjCN1zY7at2+K+34Cad8Po4ypcchn6+R4Tk35n4vkNahjlmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794733958;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=piiE22xv0xGL3gROIseeffI3wkFOnIrt2HjrT+WVEtY=;
	b=odwrBxQHgxNwmhAXQhcqGnP8im1zBDi90N/mv2mpzbWvebpta0NrX6wygISdYF1IsnvF
	 F/78ZIonket4KzwGXSEON7B6N9sKslre2uC5GvMDJ+J0usyM08kYEvtAK1zAHqxmTOmGf
	 DH8c4RNJQfk3E3p7XHsXB+emurMgAInffw0qkiHoJqoSBKe7U7qwFr1jmggvFNNcNtyb5
	 hrfpUhArZwDXQec3ad/Rek244zrMqm4Kp1WkdojRuQEZ+DRI6reLsoWZx99DSxyEaMNeC
	 LiLptsexdVNMhIPnrixwzsU+lL6Ee7kxOPT2AP7RfMhW2lJpWMYagA0Tp1G2r6v/Ysw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=Lpe+xlXw;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6665C606A327;
	Sun, 15 Nov 2026 09:12:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6665C606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=Lpe+xlXw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1794733955; bh=knNerm4NzgP/1OVjd5qxFFn/jiM+2oOHlxvMrgv8jjM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Lpe+xlXwcUB+aK/U31cGfr8D30yo2LodaMWvq4BWgMgdVc0sdJzh/9mj4gQVdltHP
	 XMBlXzpaQAaDn4bAC3SKpn00Atc56wRii6+3VmwG9Hs8BBGTNm1QJLgGwnqamYsagv
	 aFTXVx3TjLEvr6zBADxXzzW6QijBmhIiQfAcC4RuHr387snMREk+HvoQMCLOxud5a5
	 LMIrvpApqlGSLgcf2BTUOkMY9DiLUlwt/lRJccryeg8sk4o3HsIx26MBYTbsCSyA8t
	 /obYFB0J6SdMhjDyywJohgVG+cuhV8GsK8vvThBTgJDShUrDfjm+t5nSUNuXQFxAZx
	 h2fuy3HOObdLA==
Received: from [0.0.0.0] (unknown [213.228.1.188])
	by rcs.proxad.net (Postfix) with ESMTPSA id A996244C02BC;
	Sun, 15 Nov 2026 10:12:33 +0100 (CET)
Message-ID: <35bf2a1f-7f65-45fa-a854-dd4f4c4c0d90@corp.free.fr>
Date: Sun, 15 Nov 2026 10:12:33 +0100
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
Subject: Re: [PATCH net-next 05/10] net/mlx5e: TC, reject a partial tunnel key
 with tunnel mapping
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
References: <20261109131039.959438-6-acassen@corp.free.fr>
 <179442432587.2199510.12038956805266142950@kernel.org>
Content-Language: en-US
From: Alexandre Cassen <acassen@corp.free.fr>
In-Reply-To: <179442432587.2199510.12038956805266142950@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/11/26 20:12, netdev-bot+sashiko@kernel.org wrote:
> [Severity: Low]
> Should the full-mask width here depend on the tunnel type?
> 
> On VXLAN and GENEVE the tunnel key is a 24-bit VNI. The parsers in the
> same driver already refuse wider keys and program the 24-bit match
> fields:
> 
> drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c:mlx5e_tc_tun_parse_vxlan() {
>      ...
> 	if (be32_to_cpu(enc_keyid.key->keyid) >= MLX5E_TC_TUN_N_VNI) {
>      ...
> 	MLX5_SET(fte_match_set_misc, misc_c, vxlan_vni,
> 		 be32_to_cpu(enc_keyid.mask->keyid));
>      ...
> }
> 
> mlx5e_tc_tun_parse_geneve_vni() does the same with geneve_vni.
> 
> That means a mask of 0x00ffffff programs the same hardware criteria as
> 0xffffffff. The masked key stored in the tunnel mapping is also equal to
> the full VNI, so mlx5e_tc_restore_tunnel() would restore the correct
> tunnel id.
> 
> Once the later series commit "net/sched: cls_flower: add enc_key_id mask"
> lets userspace send a mask, a rule like enc_key_id N/0xffffff on a VXLAN
> or GENEVE device would be refused with -EOPNOTSUPP here. This happens in
> any chain > 0, and in chain 0 with goto or sample. Is that intended?


Yes. On VXLAN and GENEVE, N/0xffffff matches the same packets as the 
exact key N, and the exact key works in chains. Accepting the mask would 
need the key width of each tunnel in a check that serves them all.



> The extack text "Partial match of tunnel key in chains isn't supported"
> also seems misleading for that case, because the mask covers the whole
> VNI.
For flower, 0xffffff is still a partial mask of its 32 bit key. The 
message follows that view.



