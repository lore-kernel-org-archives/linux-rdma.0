Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795145442;
	b=qTAGQlgMrRDkxSy/sGxjrpSaBbyZ4TBrh6RcOwiKaimA9FFB+M51iei940LYnC9nGBXl
	 Vo7sledNt1ADOfHvPGyRprI7mFCpqhqEpeYMpFVuCp74jpKo37z0Vj70X9kPqhvigBEhZ
	 ZfTlcMFmNEvqBVzjCH5FmfST0CZRc5AnT6NR6c18mBsCFuSTri2CU0IKv+OmsABddrnib
	 ChPMjvvhLP7c9auJEFNMGznW3nbdvRCGysrrnGaOjyFn4hiU96NkNfZnZnlUiSJPS+sGh
	 C/LX63DrM9RAyWaGeZL7L3nVJ18q4Dg99zQ0QWPFr0YHHMCfGX1+aCtw11Vzymx00zA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795145442;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=zCwn2O6yZcQVzA3x/FT5d2tM7t7yzAkteMtRQdaOy44=;
	b=PTRH7/KvZbXtUA59y1Pd61XKnD+A0g+KcJexa0y6U+eY/Z/Vu/Vz43jztWQt6HVzfA9X
	 HlenqV0FVCx58DKyKHRDVKpYtq5WArUYy/zkKOPrLk4p/82tYmAQvQTcWaZ5nvYoHl/ji
	 QdIvd9aB731RqZ2uE2pS24Oz9Am6qjG72nQxrmGUSpqB24CQZvxvasRM3FbRQtrA5nhrq
	 +ZW9SXFPayEsMMVFwNuNY9BEoF7uR791t881MOLtBK92+qT2Jt8CbaWoXqXfLmu22xp7h
	 iSC1osliZuIWIOtqpc5DXylJTfQ9Cc+wVMfjmeNExroZvHwWoDKWZCe60MPCPKeapvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qx61MwNd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B1A606A339;
	Fri, 20 Nov 2026 03:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qx61MwNd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1AEE1F000C4;
	Fri, 20 Nov 2026 03:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795145442;
	bh=zCwn2O6yZcQVzA3x/FT5d2tM7t7yzAkteMtRQdaOy44=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Qx61MwNdO7CwMx4EQj7j2/ZCRD5LrX+/2DfAZMhmOpl1ow32DZitnpsEgbI0+uhO9
	 clOS2dfsul/i1/pFjCqzp6Xu6iPQQ0vn+Ga5pB6quydKwnK6BjYt4dViNpnJBYztiP
	 GapdBW1wB1Ul+TXUp5Jf7Oy5xH31WKeuO8nMTeUARTgYsrSTqDLQ1dSO82oSn2n807
	 /bf1pOG1dANXtbbA2B3rNsDBtpHt18qQnoldlMRNbfp44HO/CYZlVoguILPw5atRQt
	 Oq9irn4i6rnk+ofnx/tmqz1t4ZvYP2EXaVTxT/j84m6cf/LjYLXn5tWazNf7D1e2Ht
	 RjrbydpT3G4oQ==
Subject: Re: [PATCH net-next v2 07/10] selftests: forwarding: tc_flower: test
 the enc_key_id mask
From: netdev-bot+sashiko@kernel.org
To: acassen@corp.free.fr
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 jhs@mojatatu.com, jiri@resnulli.us, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, michael.chan@broadcom.com, pavan.chebbi@broadcom.com,
 bharat@chelsio.com, donald.hunter@gmail.com, corbet@lwn.net,
 skhan@linuxfoundation.org, rdunlap@infradead.org, dsahern@kernel.org,
 idosch@nvidia.com, shuah@kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, oss-drivers@corigine.com
Date: Fri, 20 Nov 2026 03:30:40 +0000
Message-ID: <179514544037.3136.16339086532983375306@kernel.org>
In-Reply-To: <20261117092915.255194-8-acassen@corp.free.fr>
References: <20261117092915.255194-8-acassen@corp.free.fr>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] match_enc_key_id_mask_test() in
  tools/testing/selftests/net/forwarding/tc_flower.sh only checks…
- [Low] In tools/testing/selftests/net/forwarding/tc_flower.sh,
  match_enc_key_id_mask_test() depends on a tc (iproute2) change that…

--

selftests: forwarding: tc_flower: test the enc_key_id mask

This adds match_enc_key_id_mask_test() to tc_flower.sh. It creates two
gretap tunnels with keys 300 and 600 and adds a flower filter matching
enc_key_id 256/0xf00 on an external gretap device. It then checks that
key 300 matches and that key 600 falls through to a second filter. The
test returns early without a result when tcflags is skip_sw or when tc
does not know the enc_key_id mask.

> diff --git a/tools/testing/selftests/net/forwarding/tc_flower.sh b/tools/testing/selftests/net/forwarding/tc_flower.sh
> index b58909a931129..693361c4b8f7e 100755
> --- a/tools/testing/selftests/net/forwarding/tc_flower.sh
> +++ b/tools/testing/selftests/net/forwarding/tc_flower.sh

[ ... ]

> @@ -280,6 +281,59 @@ match_vlan_test()
>  	log_test "VLAN match ($tcflags)"
>  }
>  
> +match_enc_key_id_mask_test()
> +{
> +	RET=0
> +
> +	# A tunnel device has no offload to take a skip_sw filter
> +	if [[ $tcflags == "skip_sw" ]]; then
> +		return 0
> +	fi
> +
> +	if ! tc filter add dev $h2 ingress flower help 2>&1 | \
> +		grep -q MASKED-KEY-ID; then
> +		echo "SKIP: iproute2 too old; tc is missing the enc_key_id mask"
> +		return 0
> +	fi

[Severity: Low]
Which iproute2 change adds the MASKED-KEY-ID token to the flower help
output?

The kernel tree does not contain MASKED-KEY-ID. It also does not contain
the "enc_key_id 256/0xf00" dump format checked further down. Released tc
parses enc_key_id as a plain be32 and rejects 256/0xf00. The commit
message does not name or link the tc patch that these strings come from.

With any tc that lacks this exact token, the test echoes the SKIP line
and returns 0 without a TEST: line. The new TCA_FLOWER_KEY_ENC_KEY_ID_MASK
handling in fl_set_key() and fl_dump_key() is then never exercised.

If the final tc patch uses a different help placeholder, the test would
skip forever. If tc prints the key in another format, the dump check
would fail.

Could the commit reference the tc change it depends on? Then the probe
string and the dump format could be checked against it.

> +
> +	tunnel_create gt1 gretap 192.0.2.1 192.0.2.2 dev $h1 key 300
> +	tunnel_create gt2 gretap 192.0.2.1 192.0.2.2 dev $h1 key 600
> +	ip link set dev gt1 master v$h1
> +	ip link set dev gt2 master v$h1
> +	ip link add gt-ex type gretap external # To collect tunnel info
> +	ip link set dev gt-ex up
> +	ip link set dev gt-ex master v$h2
> +	tc qdisc add dev gt-ex clsact
> +
> +	tc filter add dev gt-ex ingress protocol ip pref 1 handle 101 flower \
> +		$tcflags enc_key_id 256/0xf00 action drop
> +	tc filter add dev gt-ex ingress protocol ip pref 2 handle 102 flower \
> +		$tcflags enc_key_id 600 action drop
> +
> +	tc filter show dev gt-ex ingress pref 1 | grep -q "enc_key_id 256/0xf00"
> +	check_err $? "Did not dump the mask"

[Severity: Medium]
What happens here when a tc that knows the mask runs on a kernel without
TCA_FLOWER_KEY_ENC_KEY_ID_MASK?

tc answers the flower help probe above by itself and never asks the
kernel. So the probe only detects userspace support.

TCA_FLOWER_KEY_ENC_KEY_ID_MASK is added just before __TCA_FLOWER_MAX, so
older kernels have a smaller TCA_FLOWER_MAX. fl_change() parses the
options liberally:

net/sched/cls_flower.c:fl_change() {
    ...
	err = nla_parse_nested_deprecated(tb, TCA_FLOWER_MAX,
					  tca_opts, fl_policy, NULL);
    ...
}

In that mode, __nla_validate_parse() skips attributes above maxtype:

lib/nlattr.c:__nla_validate_parse() {
    ...
		if (type == 0 || type > maxtype) {
			if (validate & NL_VALIDATE_MAXTYPE) {
				...
				return -EINVAL;
			}
			continue;
		}
    ...
}

So an older kernel would install the enc_key_id 256/0xf00 filter as an
exact match on key 256. The "Did not dump the mask" and "Did not match a
key inside the mask" checks would both fail, and tc_flower.sh would exit
with ksft_fail.

Documentation/dev-tools/kselftest.rst says mainline kselftests should
skip gracefully on older stable kernels. The test already reads the dump
back. Could a missing mask in the dump be handled the same way as the tc
probe, instead of being reported as a failure?

> +
> +	$MZ gt1 -c 1 -p 64 -a "$(mac_get gt1)" -b $h2mac -t ip -q
> +
> +	tc_check_packets "dev gt-ex ingress" 101 1
> +	check_err $? "Did not match a key inside the mask"

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261117092915.255194-1-acassen%40corp.free.fr
