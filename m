Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794424332;
	b=v1QFS8Mi9M85rXWCTW1blGHwluVzUYA1XBv9Y4BeBY9aNgUAD26fiGttK+RgMFLue1JP
	 X0GOqBOgEKNPHdQgj8TE8GRbMXyl6LmneOKPFZC2qwto1MvwBm18RM8TNYDi/gxVIs6xx
	 oPz8TvN3wPq7ipJipNPJKonoc0XZFgAecDOGjgPrSW4AVuXILECa5V8/HxrmLDf/k95DW
	 nHiv+bqyHsVhiay7iRSZrAurj/r2faLpqJdroni+oiUqRi6aWhtRdPHzq2Nh+a2YddblM
	 jgGb+LPIKccirksPYh6CNPK2EUlWRrlbFKp6ehuGWw3vAAN/DoVaEDDiz8lrX/VkmFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794424332;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=JzLMSwghD2PO6Xb9dFzksMNtTAGLMaDroH8J4cxYrno=;
	b=5XPyLXe04eShmJnD/TwfnxIOc6dsUyk1AQLzfJtFNSdr7+UjQvQeSPrzxb7ViYc6YHk8
	 TUUG4mH+WcrOc6VtgaRiC+mRzT6rXQuqL4lq/xiQ7DiPEKvhtlxaZ+3dQ/C9kHilMVtz1
	 w7rYoHlsK9VQp02oSGamnceOV2baD155BAgIIukc0BO+llNY7IZ6KcmzzC5iuv/0hMBQQ
	 80Onk2rGC4/mELrMmWJ43xGyVOQdh5ouo94sMmry+0YxoqbyIM4W7YRuYxbBhJ4qopI7D
	 5QITRgeX/Zt8D6RCx9mJf96SBDrWBGurV7t+7XzDvO+0EdZ5vbOXU9yQdQ0qngdpQgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XByef+ej;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942DA606A89E;
	Wed, 11 Nov 2026 19:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XByef+ej
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 754D21F00A05;
	Wed, 11 Nov 2026 19:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794424331;
	bh=JzLMSwghD2PO6Xb9dFzksMNtTAGLMaDroH8J4cxYrno=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=XByef+ejZRyzUxQ92DESKOvJm6sqvLAET0v1veFV25qfPJ5WdYJQkiMrVgJUk3xjl
	 9QiRxoLRrnHRLZCD/Mz3sIX3TmKtUmk2229Ox+qg4kTlGgBxu5diIfO/ZfJlvRtWFQ
	 RsvB3z5hfCfKQreWPttK67Yh9NFXr2p+Oxxju9bSiAghWpGYbm+TrArCy00/hh7Ej1
	 PhD4PbbuHnQdcIP+vxJ3b7vzR3BECdis3iF0wNoNlq48ialpARH7W7GIsYUnX8Cg+v
	 uqgVIIUJt+gotnnADcl/gEW+hj5YRxj83BJ9LOa4CCmRkAVMo6yQHTEX+3Aq60tczi
	 lRsJ10MCQDXVQ==
Subject: Re: [PATCH net-next 07/10] selftests: forwarding: tc_flower: test the
 enc_key_id mask
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
Date: Wed, 11 Nov 2026 19:12:10 +0000
Message-ID: <179442433006.2199510.18178415453434864193@kernel.org>
In-Reply-To: <20261109131039.959438-8-acassen@corp.free.fr>
References: <20261109131039.959438-8-acassen@corp.free.fr>
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] When tcflags=skip_sw, match_enc_key_id_mask_test()
  (tools/testing/selftests/net/forwarding/tc_flower.sh) never tests…

--

selftests: forwarding: tc_flower: test the enc_key_id mask

This adds match_enc_key_id_mask_test() to tc_flower.sh. The test puts a
flower filter with enc_key_id 256/0xf00 on a gretap external device. It
checks three things: the mask shows up in the dump, a key inside the mask
matches, and a key outside the mask only hits a second exact-match filter.
Under skip_sw, if adding the masked filter fails, the test only logs it.

> diff --git a/tools/testing/selftests/net/forwarding/tc_flower.sh b/tools/testing/selftests/net/forwarding/tc_flower.sh
> index b58909a931129..9d9f109ab8954 100755
> --- a/tools/testing/selftests/net/forwarding/tc_flower.sh
> +++ b/tools/testing/selftests/net/forwarding/tc_flower.sh

[ ... ]

> +match_enc_key_id_mask_test()
> +{

[ ... ]

> +	ip link add gt-ex type gretap external # To collect tunnel info
> +	ip link set dev gt-ex up
> +	ip link set dev gt-ex master v$h2
> +	tc qdisc add dev gt-ex clsact
> +
> +	# A device may refuse a partial mask but software must take it
> +	tc filter add dev gt-ex ingress protocol ip pref 1 handle 101 flower \
> +		$tcflags enc_key_id 256/0xf00 action drop
> +	if [[ $? -ne 0 && $tcflags == "skip_sw" ]]; then
> +		log_info "Device refuses the enc_key_id mask"

[Severity: Medium]
Can the skip_sw pass ever reach enc_key_id_mask_check(), or does it always
end up in this branch?

gt-ex is a gretap external device, and ip_gre has no ndo_setup_tc. When
clsact is added on it, tcf_block_offload_bind() calls
tcf_block_offload_cmd(). That function sets up the indirect block and then
always returns an error:

net/sched/cls_api.c:tcf_block_offload_cmd() {
    ...
	flow_indr_dev_setup_offload(dev, sch, TC_SETUP_BLOCK, block, &bo,
				    tc_block_indr_cleanup);
	tcf_block_setup(block, &bo);

	return -EOPNOTSUPP;
}

As a result, tcf_block_offload_bind() does block->nooffloaddevcnt++ for
the gt-ex block.

After that, fl_hw_replace_filter() calls tc_setup_cb_add() with
err_stop set to skip_sw. tc_setup_cb_add() then rejects the filter before
any driver callback is called:

net/sched/cls_api.c:tc_setup_cb_add() {
    ...
	if (block->nooffloaddevcnt && err_stop) {
		ok_count = -EOPNOTSUPP;
		goto err_unlock;
	}
    ...
}

So every skip_sw flower filter on gt-ex would fail, whatever the mask is.
An exact enc_key_id 256 would fail the same way.

On any setup where tc_offload_check passes, the skip_sw pass would print
"Device refuses the enc_key_id mask". It would then skip filter 102 and
enc_key_id_mask_check(), and report no result.

The comment above, the log_info() text and the commit message all say
the mask is the reason:

  When tc does not know the mask or a device refuses it under skip_sw, the
  test only logs this.

Is that accurate, given that no skip_sw filter can be installed on gt-ex
at all?

This also means the skip_sw half never tests the hardware mask
programming that this series adds to cxgb4, mlx5 and nfp. A regression
there would look like the same info line.

Even without the block-level check, nfp_flower_calculate_key_layers()
looks like it would reject this filter for another reason: it matches only
enc_key_id, with no ENC_CONTROL or enc_dst_ip match. Again, that has
nothing to do with the mask.

Should the skip_sw case be dropped, or moved to a block that can actually
be offloaded?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261109131039.959438-1-acassen%40corp.free.fr
