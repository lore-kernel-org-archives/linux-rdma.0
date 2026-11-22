Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795379634;
	b=2xuW3YOcGKpEAWq2U7oxYv2+DVjteYMgPf14RnYc8jmmOdM5tQfeJHiFW+nH/LIQKZey
	 MjrUpX/vCGg18+oDCheAUuaueH3RKXKfEghgGF7PVEdcwFkl2XqDJH+ZLbPqOFJk4mFqU
	 95ZNrmD1xLIqnvZ2bsqSkITzjhY+xUBJB/a6+2vibYJlCUzKUTXrfP6FpJ67G4yZdtAvI
	 U1pssGswD/tS51Rl+PeEjp2Sx80lI3QLYxo3l9Iln38a0f5UWcsWzSRu3LbJQqc6evOGm
	 2XaqeT28VbDPAbkckQ+ZU4bYIdk6PZbJE/+kjQkqPjse1JqHwwnmbDwxz/Rf59gzzew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795379634;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=RA8x73YPrFGxdZjoHXQbPrziSX/WOKdJXB926WeBtQY=;
	b=rFGxGrITjgomTLFMVwRTsLb9sddQ9f/WjbBqCphuK0/aAawYHah/lVKQLQPEGhkqIVRA
	 8OTsRZGaRmK3p2QzPD4UzApmHvvt00Jnv6jsO445PTkonbn9XefFngfY5vJlRrvGfTfhC
	 6q8fEe5qTjQ5UwZD5gvS2nNzDswnXdVRCapQhTM9swNzvGPRJsTaep2b2wMWLSVnJb37K
	 BBys7X/+paYux1wg4/oOc4v157OltojQtRynub2yPoz/y0aRD0FlJveGGe5rVaRWSf1EL
	 V1FoZbF/UV6PWTLeVXfnMRe1oB6DrasPnndv43xR+qkaUcNhfxIMYzdEev05WR7aFug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=XhHbwF8m;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9CE0606A31A;
	Sun, 22 Nov 2026 20:33:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B9CE0606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=XhHbwF8m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1795379631; bh=1AkORMZI9fsVIs2vr6hJ9ymldCq6J3f7/QD/Oa4DfIM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XhHbwF8mqx6NhCtA6G/mPzI2EfpUxZgJQPgfyss+ngvduypWUxSqkNwAiW6YYZoiB
	 YL5+0QNWA/ELIooQLppESOKsb6/JXB//sno6A4YaRnChIp9WUtOiUAL+NASCPRJbXH
	 rf0C8uCEGc9lahloB5ABzd3cXYmCm29r4LG2ZHi8cqoRrMKJX4d46mGzHLwmWkBUK+
	 CRw6ovrV4R9+69+fZ+9DBNmn092HQ5fl/6jOphyWz2Va7Zh14q078RpR3cJ2Ojkpjh
	 XwBHEbYLWkqULXf5fersIUELt/B5LXdDTTeC58V+lWHJRzGnWc/81nXVxy4ONmKpW2
	 ul5JpZylbZyRw==
Received: from [0.0.0.0] (unknown [213.228.1.188])
	by rcs.proxad.net (Postfix) with ESMTPSA id C990644C0B3E;
	Sun, 22 Nov 2026 21:33:49 +0100 (CET)
Message-ID: <73a9b976-ad73-4793-8444-bcbbf7b2bd8f@corp.free.fr>
Date: Sun, 22 Nov 2026 21:33:49 +0100
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
Subject: Re: [PATCH net-next v2 07/10] selftests: forwarding: tc_flower: test
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
References: <20261117092915.255194-8-acassen@corp.free.fr>
 <179514544037.3136.16339086532983375306@kernel.org>
Content-Language: en-US
From: Alexandre Cassen <acassen@corp.free.fr>
In-Reply-To: <179514544037.3136.16339086532983375306@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 11/20/26 04:30, netdev-bot+sashiko@kernel.org wrote:
> [Severity: Low]
> Which iproute2 change adds the MASKED-KEY-ID token to the flower help
> output?
>
> The kernel tree does not contain MASKED-KEY-ID. It also does not contain
> the "enc_key_id 256/0xf00" dump format checked further down. Released tc
> parses enc_key_id as a plain be32 and rejects 256/0xf00. The commit
> message does not name or link the tc patch that these strings come from.
>
> With any tc that lacks this exact token, the test echoes the SKIP line
> and returns 0 without a TEST: line. The new TCA_FLOWER_KEY_ENC_KEY_ID_MASK
> handling in fl_set_key() and fl_dump_key() is then never exercised.
>
> If the final tc patch uses a different help placeholder, the test would
> skip forever. If tc prints the key in another format, the dump check
> would fail.
>
> Could the commit reference the tc change it depends on? Then the probe
> string and the dump format could be checked against it.


The tc side is the iproute2 pair posted with v1 [1]. v3 drops the help 
probe.
The test now adds a probe filter and reads its mask back. That also checks
the dump format of the pair.

> [Severity: Medium]
> What happens here when a tc that knows the mask runs on a kernel without
> TCA_FLOWER_KEY_ENC_KEY_ID_MASK?
>
> tc answers the flower help probe above by itself and never asks the
> kernel. So the probe only detects userspace support.
>
> TCA_FLOWER_KEY_ENC_KEY_ID_MASK is added just before __TCA_FLOWER_MAX, so
> older kernels have a smaller TCA_FLOWER_MAX. fl_change() parses the
> options liberally:
>
> net/sched/cls_flower.c:fl_change() {
>      ...
> 	err = nla_parse_nested_deprecated(tb, TCA_FLOWER_MAX,
> 					  tca_opts, fl_policy, NULL);
>      ...
> }
>
> In that mode, __nla_validate_parse() skips attributes above maxtype:
>
> lib/nlattr.c:__nla_validate_parse() {
>      ...
> 		if (type == 0 || type > maxtype) {
> 			if (validate & NL_VALIDATE_MAXTYPE) {
> 				...
> 				return -EINVAL;
> 			}
> 			continue;
> 		}
>      ...
> }
>
> So an older kernel would install the enc_key_id 256/0xf00 filter as an
> exact match on key 256. The "Did not dump the mask" and "Did not match a
> key inside the mask" checks would both fail, and tc_flower.sh would exit
> with ksft_fail.
>
> Documentation/dev-tools/kselftest.rst says mainline kselftests should
> skip gracefully on older stable kernels. The test already reads the dump
> back. Could a missing mask in the dump be handled the same way as the tc
> probe, instead of being reported as a failure?


Yes. On a kernel without the mask the v2 test fails with "Did not dump 
the mask".
In v3 the probe filter goes on $h2 first. When its dump lacks the mask, 
the test
logs a SKIP line and returns. It now passes on a kernel with the mask 
and only
logs the skip on a kernel without it, with the new and the old tc alike.


[1] 
https://lore.kernel.org/netdev/20261109131151.960789-1-acassen@corp.free.fr/

