Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794712711;
	b=hgS+IDOlJXL5Hix7t9EoF09ACEKUpv3GbSxk5lRnyBt2jdfXHRIjJGwbGhBojMHqEWGD
	 3ITyf5Fr6RMWP3PD2Z/usNMQS3m2BLPNUByrJawVgJID4R1GTADThukM0bT/SCIgA5C5h
	 DoSle/i6vfxeVEns3XYgGS9/YFa/kAPXNkHcqoXMMer+7CgtXpTQjZiM3Yawxmh7t+R4Q
	 6jkDxlEJt7L3xeBL4fDQz/L/YN4hy9dse0OHwloXR7KNu0VSnpkidn4SSq5fbFjd2le7H
	 YAdog5xnTEhVV3+BgUxpPM9oQZcOYG7ihU0u5GmnEs0JIoXmYjTaSFxQ2gaUzudrM5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794712711;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=NaBBC8TVav3SriqgseLu10PdzgsqTGxGU+07qISdAEI=;
	b=wHK915eVcfpR3p+nzQ9q9T1yPNVpG7FS+rk4N5T2nCgwk75hlzcqVevbijDsJewwlgqX
	 0PI4YD7RKEhpmBIBXKgyyxG437NJWX7of4Vl+/VNt7WDrjpXjFZcqxAj91OOKbywKzUQJ
	 6Ao8xSR7ZufFCEh6hJSfQATvGd8lixwvlO93TekU8/qS/LQARfoyepE+F6cA0KoSdKHJH
	 jSGE54vmQCmDE23KGxx0u2A9QBFZRDXg3vA2wjZqKq7a0Hf1qhZ8myqdhy80KhgvSpWAw
	 F+Qpx4hbQpb5GuCrOz0AUlW63sv58GzM8kV64ER+vvXzhbfMlnHPj5nONbcbZu3SBEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dLQBFP2F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8BF606A897;
	Sun, 15 Nov 2026 03:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dLQBFP2F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B481F000C5;
	Sun, 15 Nov 2026 03:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794712711;
	bh=NaBBC8TVav3SriqgseLu10PdzgsqTGxGU+07qISdAEI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=dLQBFP2Fjo571CIuWkJQKywIpqWUt5KJwH9SHqGkuC4Up3dRv1/PCH5Ir635cYSoL
	 TkF+D+OB/gATihebRlEIw3wo5+vSU+jKTNx6wU/d+ZBIbFrr8T9nMRbqb/ZqzLaQIM
	 wc8FWcKrfH4CqsyExAqHjrhpK4sf/jX1/kUqdXdj5zQArqaTAojLVL0Rnae5MB4yxq
	 ncQORahGse0YnSpFo+2kjgHe5jTFgweL+CT5lYCqex0nBG0FfzLEd28nqRf3ZUOc28
	 oKkJQkFB7WrLoC8MdC815IRRnvEILv2eB+Lv2ZKDhG1O/5d5Phh/aLpNeDo8l6S9k7
	 99xJHOTG95qtg==
Subject: Re: [PATCH net-next v1 14/15] selftests: tc-testing: add tests for
 the psp action
From: netdev-bot+sashiko@kernel.org
To: toddfreed@meta.com
Cc: netdev@vger.kernel.org, davem@davemloft.net, andrew+netdev@lunn.ch,
 bjorn@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
 daniel.zahka@gmail.com, donald.hunter@gmail.com, edumazet@kernel.org,
 kuba@kernel.org, jhs@mojatatu.com, jiri@resnulli.us, john.fastabend@gmail.com,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org,
 martin.lau@linux.dev, pabeni@redhat.com, saeedm@nvidia.com, horms@kernel.org,
 tariqt@nvidia.com, weiwan@google.com, willemdebruijn.kernel@gmail.com
Date: Sun, 15 Nov 2026 03:18:29 +0000
Message-ID: <179471270988.2199510.16269189548996714226@kernel.org>
In-Reply-To: <20261111005533.6436-15-toddfreed@meta.com>
References: <20261111005533.6436-15-toddfreed@meta.com>
X-sashiko-severity: Low
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

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] Tests 2d50 ("Add psp action without encap or decap"), cab5 ("Add
  psp encap action without assoc, with index") and 0c17 ("Reject psp…
- [Low] Tests a744 ("Add flower psp_spi filter with psp decap") and 4e1f
  ("Add flower psp_spi, psp_ver and psp_dev filter with psp decap") in…

--

selftests: tc-testing: add tests for the psp action

This adds tdc tests for the psp tc action. They add, replace, delete and
flush decap actions, and check that invalid encap/decap configurations are
rejected. It also adds flower filter tests for psp_spi, psp_ver and
psp_dev, and enables CONFIG_INET_PSP and CONFIG_NET_ACT_PSP in the
tc-testing config.

> diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/psp.json b/tools/testing/selftests/tc-testing/tc-tests/actions/psp.json
> new file mode 100644
> index 0000000000000..990e8bd1ce9a0
> --- /dev/null
> +++ b/tools/testing/selftests/tc-testing/tc-tests/actions/psp.json
> @@ -0,0 +1,459 @@

[ ... ]

> +    {
> +        "id": "2d50",
> +        "name": "Add psp action without encap or decap",

[ ... ]

> +        "cmdUnderTest": "$TC actions add action psp index 12",
> +        "expExitCode": "255",
> +        "verifyCmd": "$TC actions list action psp",
> +        "matchPattern": "action order [0-9]+: psp",
> +        "matchCount": "0",

[Severity: Low]
Does this test reach the kernel check it is named after?

The test passes if the command exits with 255 and no psp action is listed
afterwards. tc actions add also exits with 255 when tc's own parser refuses
the arguments, before any netlink request is sent. In iproute2,
tc_action_modify() returns -1 for a parse_action() failure and for an
rtnl_talk() failure alike.

If the psp parser in tc requires encap or decap, this test would pass
without ever reaching this check:

net/sched/act_psp.c:tcf_psp_init() {
    ...
	if (NL_REQ_ATTR_CHECK(extack, nla, tb, TCA_PSP_ACTION)) {
		NL_SET_ERR_MSG(extack, "Missing PSP action, encap or decap");
    ...
}

The same question applies to two other tests:

- cab5 ("Add psp encap action without assoc, with index") and the
  "Missing PSP association ID" check in the encap case.
- 0c17 ("Reject psp decap action with an assoc") and the "decap takes no
  PSP association" check in the decap case.

In each case the test would still pass if the kernel branch were removed.

The flower tests b58d and 2f96 avoid this by expecting exit code 2.
tc filter add returns 2 only on an rtnl_talk() error and returns 1 on a
parse failure. The action tests have no such check.

Would it make sense to match the extack text instead? For example, a
verifyCmd could rerun the command with stderr captured and grep for the
kernel message.

[ ... ]

> +    {
> +        "id": "a744",
> +        "name": "Add flower psp_spi filter with psp decap",

[ ... ]

> +        "dependsOn": "$TC filter add flower help 2>&1 | grep -q psp_spi",

[ ... ]

> +        "cmdUnderTest": "$TC filter add dev $DEV1 ingress protocol ip pref 1 flower psp_spi 0x1234 action psp decap",
> +        "expExitCode": "0",

[Severity: Low]
Should this dependsOn also check for the psp action?

The command uses "action psp decap", but the probe only checks that flower
knows psp_spi. The action tests earlier in this file probe for the action
like this:

    $TC actions add action psp help 2>&1 | grep -q decap

run_one_test() in tdc.py uses only the probe's return code to decide
whether to skip a test. Suppose tc has the flower psp_* keys but not the
psp action. This test would then run instead of being skipped. tc would
fall back to its noact parser, reject the action, and the test would be
reported as a failure.

The commit message says:

    The tests need a tc with the psp action and the flower psp_* keys; they
    skip without it (dependsOn).

Test 4e1f ("Add flower psp_spi, psp_ver and psp_dev filter with psp decap")
has the same issue.

Could both probes be chained with && for these two tests?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261111005533.6436-1-toddfreed%40meta.com
