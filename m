Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795469671;
	b=yf31Ps2K52iaajtA1pv8X8uaBULuh0Ye0gEju6tkEkqoAhqxilG3DR+LAUZNhEQCvpK/
	 1YrC0Hlk5YhdVXvdB5Nspbp0quc2uxK28foCLR7Q3t37GavAF/dgUvE/g+PU7nMvPxJ+F
	 J4WsUuuWmvEI3efmohT9mOYvL8I/Qx95DXqwhU6oAMQTNMHB9AryGf60wB5Jl04w4QNxk
	 36SjM0S5u1p6LF2xJkZhr5Be47lKfDns7iuvy3L5g5EOb68hkDIQEcJJpAN/nHTobiJn5
	 nCLxsk3iToh7+GjZ6bWudtJ44E1upCTykl/Kw3wtthVgZZCoHP68KEydbz60kqEkx3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795469671;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=TgTDGjA1vu3ITyK8LqQZ+WlN+jZzmZ3C1YMQuZCn/d0=;
	b=TGJfKTlqci0gOreibBKVsZOWZsfQ3l0kW7jGjiIB8dCSzSdnDyr3g6J9M3/k03K8wfqg
	 QsdanZyQAGGAdMFEbqghThxID0LtNlR8UNuM1tHZBMpHE+Kj3ZFem96bAXOfJe4nLgjKc
	 GTUBGTMK0NK/+eXM6K0sFP0oJj5UgRiIy65NEj9tJ/5SWJ/YUe661D/nCe2tfU1uVJ1ww
	 KDj0dcYfEaHH5B4T1306E3kbKfTDMLMTgwqQPsErl77VwGz6v2Ug/0OrH0C3nHcYbh4N7
	 cpPkONBSRJjW+huT9HEC0tPhIpkW9PiCs534tlv+EkVUWgdSahhF8Zoi2FZa9zOcu4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IcBcxhyR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC67606A31E;
	Mon, 23 Nov 2026 21:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IcBcxhyR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804EF1F000E6;
	Mon, 23 Nov 2026 21:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795469670;
	bh=TgTDGjA1vu3ITyK8LqQZ+WlN+jZzmZ3C1YMQuZCn/d0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=IcBcxhyR4VbK4Mb/Hyod8Au7YBRbwMbtsbD5iGsFSC50bQRSr/3deRu5Z7l4yA/I5
	 WzVabW9Ks5TjCKzGRUpYe4JtOA9eM7mPj+O1gHxH8Kua97TRWtdKf7sWumVNcN47lZ
	 PoFkaUAE86qaOK7FMZWruwTuG+MjyeNc7qYfGEuy9JM2r+fSuIQqev3olX49mlvE6Y
	 J3W5lymUhvbbJp1RCiEO4/0ofLxbvRHT3MvpaWQuAGvudlgtmHp5NufWMcCVBkYqOP
	 7USw/YBJdr7UCJTT6bsnv0tL82fbO/XShF5ixB0P/IuM10k1LzOBzXY6hB69Tr0WPh
	 u6LKXOzzJxE0w==
Subject: Re: [PATCH net-next v3 07/11] selftests: forwarding: tc_flower: test
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
Date: Mon, 23 Nov 2026 21:34:28 +0000
Message-ID: <179546966804.3135.7021273084185929997@kernel.org>
In-Reply-To: <20261122213200.3207385-8-acassen@corp.free.fr>
References: <20261122213200.3207385-8-acassen@corp.free.fr>
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

- [Medium] In match_enc_key_id_mask_test() (tc_flower.sh lines 295-305),
  the capability probe adds a filter on $h2 with stderr discarded and…
- [Low] In match_enc_key_id_mask_test()
  (tools/testing/selftests/net/forwarding/tc_flower.sh, lines 290-293),…

--

selftests: forwarding: tc_flower: test the enc_key_id mask

This adds match_enc_key_id_mask_test() to tc_flower.sh. The test sends
frames over two gretap devices with keys 300 and 600. It checks that a
flower filter with enc_key_id 256/0xf00 on an external gretap device
matches only the key inside the mask, and that a probe filter on $h2
decides whether the test runs at all.

> diff --git a/tools/testing/selftests/net/forwarding/tc_flower.sh b/tools/testing/selftests/net/forwarding/tc_flower.sh
> index b58909a931129..0f725ec174687 100755
> --- a/tools/testing/selftests/net/forwarding/tc_flower.sh
> +++ b/tools/testing/selftests/net/forwarding/tc_flower.sh

[ ... ]

> @@ -280,6 +281,64 @@ match_vlan_test()
>  	log_test "VLAN match ($tcflags)"
>  }
>  
> +match_enc_key_id_mask_test()
> +{
> +	local ret
> +
> +	RET=0
> +
> +	# A tunnel device has no offload to take a skip_sw filter
> +	if [[ $tcflags == "skip_sw" ]]; then
> +		return 0
> +	fi

[Severity: Low]
Is this comment accurate as a general statement? The commit message makes
the same claim:

  "A tunnel device takes no skip_sw filter."

Several drivers offload flower rules on gretap devices through indirect
blocks. In drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c:

mlx5e_get_tc_tun() {
    ...
	else if (netif_is_gretap(tunnel_dev) ||
		 netif_is_ip6gretap(tunnel_dev))
		return &gre_tunnel;
    ...
}

mlx5e_rep_check_indr_block_supported() then accepts such devices via
mlx5e_tc_tun_device_to_offload(). The nfp driver
(nfp_fl_is_netdev_to_offload()) and ice also handle gretap devices.

The limit seems to come from this test's topology: an external gt-ex
device, no enc_src_ip/enc_dst_ip match, and frames generated in software.
It doesn't seem to apply to tunnel devices in general.

Could the comment and the commit message say that instead? This path also
returns without log_test or log_test_skip, so nothing in the skip_sw pass
shows that the hardware enc_key_id mask paths had no coverage.

> +
> +	# An old tc refuses the mask and an old kernel drops it
> +	tc filter add dev $h2 ingress protocol ip pref 1 handle 101 flower \
> +		$tcflags enc_key_id 256/0xf00 action drop 2> /dev/null
> +	tc filter show dev $h2 ingress pref 1 | grep -q "enc_key_id 256/0xf00"
> +	ret=$?
> +	tc filter del dev $h2 ingress protocol ip pref 1 handle 101 flower \
> +		2> /dev/null
> +	if [[ $ret -ne 0 ]]; then
> +		echo "SKIP: tc or the kernel lacks the enc_key_id mask"
> +		return 0
> +	fi

[Severity: Medium]
Can this probe hide a regression in the kernel's enc_key_id mask handling?

The kernel side is already in this tree. TCA_FLOWER_KEY_ENC_KEY_ID_MASK is
in the flower policy, and fl_set_key() parses it:

net/sched/cls_flower.c:fl_set_key() {
    ...
	fl_set_key_val(tb, &key->enc_key_id.keyid, TCA_FLOWER_KEY_ENC_KEY_ID,
		       &mask->enc_key_id.keyid, TCA_FLOWER_KEY_ENC_KEY_ID_MASK,
		       sizeof(key->enc_key_id.keyid));
    ...
}

fl_dump_key() dumps it through fl_dump_key_val().

If either path breaks, the grep fails and the function returns 0 before
log_test. RET and EXIT_STATUS stay unchanged, so the script still reports
PASS instead of FAIL. The result of the filter add is also not checked, and
its stderr is discarded.

The commit message is right that log_test_skip would turn the whole
script's exit status into a skip. But a silent return makes an in-tree
kernel regression look the same as an old tc.

By comparison, check_tc_erspan_support() in forwarding/lib.sh only checks
whether tc accepts the syntax:

	tc filter add dev $dev ingress pref 1 handle 1 flower \
		erspan_opts 1:0:0:0 &> /dev/null

It does not use the kernel's dump output to decide whether to skip.

The probe also depends on the exact text "enc_key_id 256/0xf00". That
output format comes from an iproute2 change that the commit message
doesn't reference. Released tc prints enc_key_id as a bare value. If the
final iproute2 output formats the key or the mask differently, wouldn't
the main test never run anywhere, with no failure reported?

Would it work better to probe only whether tc accepts the syntax? A mask
missing from the dump, or a failed match, on the current kernel could then
go through check_err and log_test.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261122213200.3207385-1-acassen%40corp.free.fr
