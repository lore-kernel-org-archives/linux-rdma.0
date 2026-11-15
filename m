Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794733808;
	b=oLlstX3l9jyCgz7a9BWWQ42NdpdcYiQS7YdxPItYe4qn0VJNHx5r5KZRvRD3FSVWekPJ
	 p0/1H+fm8/FVylYYOHdJ0gG36OdBKsZ3Tu51PH7pVB8l3hL9x9Hrr20m72Z+zoqOC0qcu
	 S3bwKtBl2aQ07/920U+kXUqVmGvrmdyQDg3bfjpplve9NtL0IGikxxl96KH47qIkbyIcw
	 M9N+hiWqumVaXRAPRYUGxnSxLx3pTi+x7hmBgnCj84mvBXHxRS4IdoCuTEGIlLY968QmY
	 71CfT8z4cRLBWgW+4uPs8QionoKoCmJSJ9GJFvblXPmAm5SIa9LpVG74CZuN0JTJbAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794733808;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=GDbKjw2zYrrhLWmvqxa/QL+sQBlzT+HT64ai1BN7vIA=;
	b=yOk6wCyRCCft0+4g68pfrgPH0YaiGlXPbGPeNt0zuG0ZIeG8/Ul5+i59oVAgln8X7LAw
	 uupnu9eoDqrX9arDxLyriK2pCdG4iVHjTFEoWEwNTUGei5f/o+2sLSui1OyEutPITPu9A
	 dcAnY/61H8pIEPeRzN17jgPpQC62wbbUYpiZc+IfRktoK1FcfaoEImuTohlyJEb//hBRu
	 A5AXzKFp8SGJbqJSP7ej63z9gJWJIsfea+g6ktZ6n/oaLUshvKKQaHGY3CHfJrdePdnHO
	 kygwgfyhnIwNLq8ytqmYhf7bFfedW53MXusn7LChpWhSMlQAQshGhdbm4+zYZ3Y+exQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=GIZASXuq;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B218606A31A;
	Sun, 15 Nov 2026 09:10:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B218606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=GIZASXuq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1794733806; bh=hsiAKW8RObdKWucm0HbAf9+FVwSRO5DEpMI7eRA2Rtk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GIZASXuq/Hclhh/Tl1fosY0vvtMqxPWvWvt9+mg0+59vrNqM481qBhFSZl1oMOrSN
	 +7LBA6oMgXICyaI/vNabCWtGElkxe53sUlRVMZBXP/E31LYJ7Cssf5fkEb0MG9BBjP
	 hEM0S71EGsXNjVRWTtZahgOqNmF3QY5a4ahywgDVEnAkXfTXH+yzwkYwcPnbTNVu+K
	 K9HbYPFRICqZfxD0UxQ8CJnZeYzAljZrhhQjKM31M8ADmbcFqrEBlyHlz8IgmB3dLT
	 +N8uHL0+wPKIE3GM101lKljtDEE7FmwWJTVDdBdvH25nhqZ4UCTGAArN0xnIz698Hn
	 CmM9PeKNlEgHA==
Received: from [0.0.0.0] (unknown [213.228.1.188])
	by rcs.proxad.net (Postfix) with ESMTPSA id BC03444C0083;
	Sun, 15 Nov 2026 10:10:04 +0100 (CET)
Message-ID: <a8ac012c-dd21-4974-99d5-ae037163ff6b@corp.free.fr>
Date: Sun, 15 Nov 2026 10:10:04 +0100
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
Subject: Re: [PATCH net-next 04/10] net/mlx5e: TC, refuse a tunnel key wider
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
References: <20261109131039.959438-5-acassen@corp.free.fr>
 <179442432378.2199510.219572665710096354@kernel.org>
Content-Language: en-US
From: Alexandre Cassen <acassen@corp.free.fr>
In-Reply-To: <179442432378.2199510.219572665710096354@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/11/26 20:12, netdev-bot+sashiko@kernel.org wrote:
> [Severity: Low]
> The commit message says the problem exists today ("An exact key above bit
> 23 already selects the wrong VNI"). Should the patch carry a Fixes: tag,
> and maybe go through net?
> 
> The truncation does look reachable in the current tree. Flower parses
> TCA_FLOWER_KEY_ENC_KEY_ID with TCA_FLOWER_UNSPEC as the mask type, so every
> enc_key_id rule is an exact 32 bit match. The parsers then write the key
> into 24 bit fields:
> 
> mlx5e_tc_tun_parse_vxlan() {
>      ...
> 	MLX5_SET(fte_match_set_misc, misc_v, vxlan_vni,
> 		 be32_to_cpu(enc_keyid.key->keyid));
>      ...
> }
> 
> mlx5e_tc_tun_parse_geneve_vni() {
>      ...
> 	MLX5_SET(fte_match_set_misc, misc_v, geneve_vni, be32_to_cpu(enc_keyid.key->keyid));
>      ...
> }
> 
> In mlx5_ifc.h, vxlan_vni and geneve_vni are 0x18 bits wide, so MLX5_SET()
> masks off bits 24-31.
> 
> The VXLAN-GBP path in mlx5e_tc_tun_parse_vxlan() also loses those bits. It
> shifts the key left by 8 into the 32 bit tunnel_header_1:
> 
> 	MLX5_SET(fte_match_set_misc5, misc_v, tunnel_header_1,
> 		 be32_to_cpu(enc_keyid.key->keyid) << 8);
> 
> As a result, a skip_sw rule with enc_key_id 0x01000001 is offloaded as a
> match on VNI 1. Software never matches that rule.
> 
> Because this fixes a mismatch that already exists, a Fixes: tag would tell
> backporters which stable trees are affected. These look like the
> candidate targets:
> 
>    9272e3df3023 ("net/mlx5e: Geneve, Add support for encap/decap flows
>    offload") for the geneve_vni MLX5_SET()
> 
>    the original en_tc.c commit that added VXLAN VNI matching, for the
>    vxlan_vni MLX5_SET(). d386939a327d ("net/mlx5e: Rearrange tc tunnel code
>    in a modular way") later moved that code into tc_tun_vxlan.c.
> 
>    eacc77a73275 ("net/mlx5e: Use custom tunnel header for vxlan gbp") for
>    the tunnel_header_1 path


v2 adds Fixes tags for 9272e3df3023 and for bbd00f7e2349 ("net/mlx5e: 
Add TC tunnel release action for SRIOV offloads"), the en_tc.c commit 
that added the vxlan_vni match.

eacc77a73275 gets no tag. Before it, a GBP rule went through the 24 bit 
vxlan_vni field. That commit moved the same truncation to 
tunnel_header_1, and bbd00f7e2349 covers it...


> Would it also make sense to send this to net as a standalone fix, rather
> than untagged as part of the net-next series that adds flower partial
> masks?

No. The bug needs a key that no VNI can carry, the rest of the series 
depends on these checks. v2 keeps the patch on net-next with the tags.


