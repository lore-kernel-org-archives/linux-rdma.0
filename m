Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794733567;
	b=eZhe5fKn2zK/GwVVIaCmaIQD9ASAKAjmNiV/phW4X0pWuu2mMZmglOuPFawjhcQNva3O
	 Fr7zd3SPXPhyAl8xyysh91/ZzyAbSrzdQGptsRFCr78u1deDkzhV4j8YOmuzUqZqkIdJ3
	 OHDZZ5todVBzHRRv787PHwFRpMFHVfNhCzoWxTH4EOVj1MqjTwco1/FBU5V3gXk7zzWZ5
	 4j8FqNI2583XRbXbU/Bc03xq6LoDBXCfRgFFvXanGcX0ZyD3NknNQ691FEVWrInTSRMEX
	 yh3rZWDHnHQlXs8TmiDet/gw/qgGQ8VXVyMHZ7/Irm8YpOJ78EnRMvoLNeDlWVsoYKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794733567;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=ACgMyAp+PVuoyaP7vV3K9eaa7uolKbG2QsFYyIeRFH8=;
	b=zKhOlLojYzosS/7anXSIvX159nFtZxn4+Zh+qMWGClpNPuFDPiZW2MX21YgosBIh3qo+
	 Rq3UdLG7c12GtDUG6FGU1KysqeOZJ1+wRRpnYxr7RcUcyMhsc5l+jFYegWY/45jNVSzu5
	 vddq6VG9KAYyZq2ECvAVwc9h/Re6jtHNC9Q+wF0PNrNSU4r09OE33UMejIVlXY3+MNCrt
	 A017KMeU10QtULgDQO4hRXfwfDKFs3WQQWPkPGZJCea6orRLwBuVzOTMAXghLKXYo1dDS
	 hBQ2gLuTQ8W+EhsasGcK2wInWhf8upVWiwYjlUC91K+nwytQpisv/50ZPmTBYv3X9dQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=hqS4o0fy;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EABE606A31A;
	Sun, 15 Nov 2026 09:06:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8EABE606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=hqS4o0fy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1794733564; bh=imesrF7DpucA94oI4NcLSjSMEoFs1fSO+z/B8tR2Jh0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hqS4o0fyma/0I0FJO991ng2V9zwNR4GujN2O6PsXv94veBGFkY9t1VPVsmb52WMEI
	 w/zzgtmzm1Ju+b6refDVK2dHhSWTDBDeOBIxZsXcAAUp/AsTbCHd07YBZPnSliFOux
	 BOS/swYihouO94j0ZxL4Q1oE4UYpAiBrxcAD1Jd0BHM4WbEa7ElMaQYCiT3LfZE/TZ
	 x+m8gqWpVqem5pSd72lB6rokJyYynGB4P5WMqEyLsa7gJ+rOEOrrRT5gGxhHrgEmTA
	 S5tZSLENmBQVOsWRwel/Zrz4pUpSi/vZJZkMrEC4V2Gqi1WqkiTbGlKTUHTEKK+fUY
	 k+g6zBC/d9o0Q==
Received: from [0.0.0.0] (unknown [213.228.1.188])
	by rcs.proxad.net (Postfix) with ESMTPSA id A81C544C0933;
	Sun, 15 Nov 2026 10:06:02 +0100 (CET)
Message-ID: <3c188745-3c7e-4105-be09-60a8f9d435e9@corp.free.fr>
Date: Sun, 15 Nov 2026 10:06:02 +0100
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
Subject: Re: [PATCH net-next 03/10] nfp: flower: refuse a tunnel key wider
 than the VNI
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
References: <20261109131039.959438-4-acassen@corp.free.fr>
 <179442432180.2199510.17732935950535223359@kernel.org>
Content-Language: en-US
From: Alexandre Cassen <acassen@corp.free.fr>
In-Reply-To: <179442432180.2199510.17732935950535223359@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/11/26 20:12, netdev-bot+sashiko@kernel.org wrote:
> [Severity: Low]
> The commit message says "An exact key above bit 23 already selects the
> wrong VNI", so this check also fixes a bug that exists today. Should the
> patch carry a Fixes: tag and a stable Cc so that stable trees get it too?
> 
> Before cls_flower accepts an enc_key_id mask, fl_set_key() passes
> TCA_FLOWER_UNSPEC as the mask attribute. That means any enc_key_id that is
> present always gets an exact mask:
> 
> net/sched/cls_flower.c:fl_set_key() {
>      ...
> 	fl_set_key_val(tb, &key->enc_key_id.keyid, TCA_FLOWER_KEY_ENC_KEY_ID,
> 		       &mask->enc_key_id.keyid, TCA_FLOWER_UNSPEC,
> 		       sizeof(key->enc_key_id.keyid));
>      ...
> }
> 
> nfp_flower_compile_tun_udp_key() then shifts the key and the mask left by
> NFP_FL_TUN_VNI_OFFSET (8), which throws away bits 24-31:
> 
> drivers/net/ethernet/netronome/nfp/flower/match.c:nfp_flower_compile_tun_udp_key() {
>      ...
> 		vni = be32_to_cpu((match.key->keyid & match.mask->keyid)) <<
> 		      NFP_FL_TUN_VNI_OFFSET;
> 		*key |= cpu_to_be32(vni);
> 		vni = be32_to_cpu(match.mask->keyid) << NFP_FL_TUN_VNI_OFFSET;
> 		*key_msk |= cpu_to_be32(vni);
>      ...
> }
> 
> So on current and stable kernels, a VXLAN or GENEVE rule with enc_key_id
> 0x01000005 gets programmed into the NIC as VNI 5 with mask 0xffffff00. The
> hardware then matches VNI 5 traffic. In software the rule never matches,
> because VXLAN and GENEVE tunnel ids are only 24 bits wide.
> 
> The Fixes: tag would need to point at the commit that first added
> VXLAN/GENEVE VNI matching to nfp flower. Commit 77a5f73a8b33 ("nfp: flower:
> move udp tunnel key match compilation to helper function") only moved this
> code and says it makes no functional change, so the original commit is
> older than that one.

v2 adds Fixes tags for 611aec101ab7 ("nfp: compile flower vxlan tunnel 
metadata match fields") and bedeca15afd8 ("nfp: flower: compile Geneve 
match fields"). Both predate 77a5f73a8b33.

The series stays on net-next, with no stable Cc. The bug needs a key 
that no VNI can carry, the rest of the series depends on these checks.



