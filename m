Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795818486;
	b=j4W9RBVEaN8WtGanEYYY7GioqyYPNqb8QykkHAI06vrf9OEv0eAVZTSoIf/AxEFizWy/
	 YrlNFWGu7akRwKR9duKyMEhObmQ3rsecGWvaCc1JsnZ9eRY4jt4Gd4x56WTcwIaTgGT0q
	 hVvZCJWL25p1yxg6L7NRytsfVMIAX8S7jqrUY/y82EkTJdEZqFmLvZuZUb4aBJG98Yeew
	 LYqSMtelpIspLgeJb0FBuU4YlTEDZjJT2+2yr94xV1lEcOOA7B0/Oz3w2VyFvLY3Ybay4
	 GCI4uH6agaBEDLHsgLtMAEIuNYpbSLU+JB6oJpnV/wyglXighyADU8Gjia1V6gDah6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795818486;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=MoDoW5TcR6bdLCM0d1UScBuGr3A3WzhkwpOzQR3lmfU=;
	b=siInN1niupvLdGMvzI4spEIUJt5ZjELo1Fcphi7pBiFmfjU15eki8vjwlCVQBytHGJri
	 z5Lwb1zpH83nVcgT/u2RcKDAf7LxdWZynZLswmdc7LYd2Ado7gRgzU6VNZFFyrSImoP/w
	 l4ghfs7QgqYazm9bT8GKJkimToq3BfZ1GOs/SKyJUbWHGdYQ6m14KxN3FIHkJqSOgArmk
	 qRkoHVEOApY1cUhlqaHUtRc2SpsVCzqCtQ6bibv1vi6y2oSu5aoNQUc0JNXzZ6wA2c+MP
	 ZJLFMmPSpn9GyBe9SCITi+NhRm/fDL6pYDpOMostj5DyTBnvIA7dfo56e6hQK7gPtng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=JED486N3;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9E5606A31C;
	Fri, 27 Nov 2026 22:28:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B9E5606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=JED486N3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1795818483; bh=jtZGXvdsN1gOM5FmcrO2xM28wDYuuwBnTAQnJvObioc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JED486N3iPEUirBuCSzHy34NVRVOWD1s50E5Nu5HZWEmtLNFLYQSaRZM6Xpqr5SPN
	 nZzWQjqp5AajQZO3c4mhVg8kBvf1vZjxbyqnQ+8KusENets+/cRpkwBGZI/oN8UtRt
	 rPMrIZGM9kO9VyrapcrECMiOSlV1FFYCgyMymkNaYQ9Dgue292eSwe/ESjj3esryef
	 8JLRA1O10zM7vwo9XoqBMzjGihfy3eIQ7Ngco/PydQW1PoNNmx+oYG9QUlNRdyRMGR
	 YcYVVhAz5ARsg9GOCvbyyiIc07Jq5Ms5M0L26i37bhe/dSHMEggh9ermPiWKFEE/AC
	 tdcxGGhjP7AYQ==
Received: from [0.0.0.0] (unknown [213.228.1.188])
	by rcs.proxad.net (Postfix) with ESMTPSA id 0272244C0E90;
	Fri, 27 Nov 2026 23:28:01 +0100 (CET)
Message-ID: <6a02f731-b883-471e-bc15-01e82433479f@corp.free.fr>
Date: Fri, 27 Nov 2026 23:28:01 +0100
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
Subject: Re: [PATCH net-next v3 07/11] selftests: forwarding: tc_flower: test
 the enc_key_id mask
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
References: <20261122213200.3207385-8-acassen@corp.free.fr>
 <179546966804.3135.7021273084185929997@kernel.org>
Content-Language: en-US
From: Alexandre Cassen <acassen@corp.free.fr>
In-Reply-To: <179546966804.3135.7021273084185929997@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/23/26 22:34, netdev-bot+sashiko@kernel.org wrote:
> [Severity: Low]
> Is this comment accurate as a general statement? The commit message makes
> the same claim:
> 
>    "A tunnel device takes no skip_sw filter."
> 
> Several drivers offload flower rules on gretap devices through indirect
> blocks. In drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c:
> 
> mlx5e_get_tc_tun() {
>      ...
> 	else if (netif_is_gretap(tunnel_dev) ||
> 		 netif_is_ip6gretap(tunnel_dev))
> 		return &gre_tunnel;
>      ...
> }
> 
> mlx5e_rep_check_indr_block_supported() then accepts such devices via
> mlx5e_tc_tun_device_to_offload(). The nfp driver
> (nfp_fl_is_netdev_to_offload()) and ice also handle gretap devices.
> 
> The limit seems to come from this test's topology: an external gt-ex
> device, no enc_src_ip/enc_dst_ip match, and frames generated in software.
> It doesn't seem to apply to tunnel devices in general.
> 
> Could the comment and the commit message say that instead? This path also
> returns without log_test or log_test_skip, so nothing in the skip_sw pass
> shows that the hardware enc_key_id mask paths had no coverage.


yes, some drivers offload a tunnel device. The test only need the sw 
match. will reword both if there is a v4...





> [Severity: Medium]
> Can this probe hide a regression in the kernel's enc_key_id mask handling?
> 
> The kernel side is already in this tree. TCA_FLOWER_KEY_ENC_KEY_ID_MASK is
> in the flower policy, and fl_set_key() parses it:
> 
> net/sched/cls_flower.c:fl_set_key() {
>      ...
> 	fl_set_key_val(tb, &key->enc_key_id.keyid, TCA_FLOWER_KEY_ENC_KEY_ID,
> 		       &mask->enc_key_id.keyid, TCA_FLOWER_KEY_ENC_KEY_ID_MASK,
> 		       sizeof(key->enc_key_id.keyid));
>      ...
> }
> 
> fl_dump_key() dumps it through fl_dump_key_val().
> 
> If either path breaks, the grep fails and the function returns 0 before
> log_test. RET and EXIT_STATUS stay unchanged, so the script still reports
> PASS instead of FAIL. The result of the filter add is also not checked, and
> its stderr is discarded.
> 
> The commit message is right that log_test_skip would turn the whole
> script's exit status into a skip. But a silent return makes an in-tree
> kernel regression look the same as an old tc.
> 
> By comparison, check_tc_erspan_support() in forwarding/lib.sh only checks
> whether tc accepts the syntax:
> 
> 	tc filter add dev $dev ingress pref 1 handle 1 flower \
> 		erspan_opts 1:0:0:0 &> /dev/null
> 
> It does not use the kernel's dump output to decide whether to skip.
> 
> The probe also depends on the exact text "enc_key_id 256/0xf00". That
> output format comes from an iproute2 change that the commit message
> doesn't reference. Released tc prints enc_key_id as a bare value. If the
> final iproute2 output formats the key or the mask differently, wouldn't
> the main test never run anywhere, with no failure reported?
> 
> Would it work better to probe only whether tc accepts the syntax? A mask
> missing from the dump, or a failed match, on the current kernel could then
> go through check_err and log_test.

No! v2 only checked tc. The review of v2 asked to skip on a kernel 
without the mask... Such a kernel ginore the attr without any error 
(only the dump show it). bridge_fdb_learning_limit.sh also skips on a 
dump since 863ff546fb62.

A broken parse or dump doesn't read as a pass in netdev CI. A "SKIP:" 
line turns the result into a skip there. The test runs and passes in CI 
today [1]. The probe text is the dump format of the iproute2 pair [2].


[1] 
https://netdev-ctrl.bots.linux.dev/logs/vmksft/forwarding/results/924466/46-tc-flower-sh/stdout
[2] 
https://lore.kernel.org/netdev/20261109131151.960789-1-acassen@corp.free.fr/


