Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794712710;
	b=SG3Mwj2GoERnO9UWrdAKlxBYMIQ9nbpgmEI5583gC8Op5ru/2TyTsYqeVKZTgUJN3bcR
	 LcePwUbblFEbxtiZtsrdmc/o74AS+90Roh/Z/fRyqLwKwTw3lLS8B5LQTUNoWRldTXz5i
	 kxSZTLTHO7vDcCsTiC9Rh6v+YNCdePw+1GbF+D8Y0Wn574o2iTNiElvMxHEBenIezV6XM
	 AcDmFT8B/INmzdRxiSKgGEHZaPHLNH7luKIs/Mj++n83N/NfPZdgn6ckee8NhvXEQh6aM
	 qSD3bS/Le4sZNbQJCBB1nino4v4We5AncBmBydj+G8x8Xm+Lo1gYlCw5DmHQzSp5bUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794712710;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Xqkmq+KJ2/HtU3nnCQ54j5ML6laUMMrM5zulVXs75RE=;
	b=m3aOTNMuIpjdOxTR9Ibdeo28m3dbvKtnYvNVLP06IftrbCMMVid3AB5xChKKjZL3kMx+
	 bpPxIekqHufADT6G+tEKREW5s5LYk3gyJz/uvN5T1n1PBVfYt++T7eAHTCXdYsBznZ2Ng
	 xHZXxLy6sqrcJT2hPLAqsdPTF2+RFg9oK1rMlk7ufybOCkXR993eCabVSQkvz+E4D1qfi
	 qhzTEDYS27s+PabR38TcwHMbx5KzTN5amj5AeW+qjK4e+uzLRJjsFG2x6hZWW+GbyM8xg
	 hdtgTTnhr3vy9+M3SOtTVYgP2nd9y3+7H5RzhRdw6EG3Ygb1ey6a3HmrAe+YoQDevfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=olyVM2U2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012CB606A891;
	Sun, 15 Nov 2026 03:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=olyVM2U2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB2A1F000D0;
	Sun, 15 Nov 2026 03:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794712709;
	bh=Xqkmq+KJ2/HtU3nnCQ54j5ML6laUMMrM5zulVXs75RE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=olyVM2U2Aghqs20/HIhJGzxuOPZytZp20BXK6kDJZG7fEqVSYDHQfu9aHJgTG0O3S
	 tjTfvrSoLJW1mGGIRFh7fLTGgkUnB/u4EUzkL1RuPSaXzzt6cOPRF8jseKIfQ3sMv9
	 JzQ+3e7tVwVW4ToyOU+pWm9q1vF7uya1N0OIlLqlnYQeNXIa1uO2UNvTcIwZ0+Szmo
	 H3cJdRxlG8MHbSfZqFn6OBLryQX2l6kqMfItgEtybaVIvNEvUZv6hJ58G9B/kuBVaZ
	 MwWjTgAKVLl6TCtRlHRz1DxmjD0n63YI2y27hpyipZT90m7wT0VHA+0LSyvt/m/mOb
	 3jBWkkhpVdXtQ==
Subject: Re: [PATCH net-next v1 13/15] selftests: tc-testing: run dependsOn
 probes outside the test namespace
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
Date: Sun, 15 Nov 2026 03:18:28 +0000
Message-ID: <179471270808.2199510.6514314455565065109@kernel.org>
In-Reply-To: <20261111005533.6436-14-toddfreed@meta.com>
References: <20261111005533.6436-14-toddfreed@meta.com>
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

- [Low] The patch fixes a real regression but has no Fixes: tag.
- [Low] run_one_test() now passes a new stage string, 'probe', to every
  plugin's adjust_command(stage, command) hook.

--

selftests: tc-testing: run dependsOn probes outside the test namespace

This changes run_one_test() in tdc.py so the dependsOn probe is passed to
exec_cmd() with a new 'probe' stage instead of 'execute'. With that stage,
nsPlugin does not put "ip netns exec" in front of the probe, so the probe
runs in the base namespace and the probe-gated tests are no longer always
skipped.

> diff --git a/tools/testing/selftests/tc-testing/tdc.py b/tools/testing/selftests/tc-testing/tdc.py
> index 511d66c36a2a0..541caf984519f 100755
> --- a/tools/testing/selftests/tc-testing/tdc.py
> +++ b/tools/testing/selftests/tc-testing/tdc.py
> @@ -399,7 +399,7 @@ def run_one_test(pm, args, index, tidx):
>      if 'dependsOn' in tidx:
>          if (args.verbose > 0):
>              print('probe command for test skip')
> -        (p, procout) = exec_cmd(tidx, args, pm, 'execute', tidx['dependsOn'])
> +        (p, procout) = exec_cmd(tidx, args, pm, 'probe', tidx['dependsOn'])

[Severity: Low]

Should this patch have a Fixes: tag?

The probe block came from commit 7f3f86402609 ("selftests: tc-testing: add
"depends_on" property to skip tests"). At that time nsPlugin used one
shared netns that was created ahead of time, so the probe worked.

Commit 98cfbe4234a4 ("selftests/tc-testing: localize test resources")
moved tests to per-test tcut-<random> namespaces. It also wrote the
'execute' stage call shown above. In run_one_test(), the probe still runs
before the per-test suffix is added:

    NAMES['NS'] = '{}-{}'.format(NAMES['NS'], tidx['random'])

It also runs before pm.call_pre_case() creates the namespace. As a result,
nsPlugin's adjust_command() wraps the probe in a netns exec for the bare
"tcut" name, and no namespace with that name is ever created.

Because of this, the mirred dependsOn probes added later in dcfaf1f758ee
("selftests/tc-testing: require an up to date iproute2 for blockcast
tests") could never pass.

Would this tag fit?

Fixes: 98cfbe4234a4 ("selftests/tc-testing: localize test resources")

[Severity: Low]

This passes a new stage string, 'probe', to the adjust_command() hook of
every plugin. Should the in-tree docs list it?

The stage list in tools/testing/selftests/tc-testing/README reads:

  The stages are identified by the following strings:

    - pre  (pre-suite)
    - setup
    - command
    - verify
    - teardown
    - post (post-suite)

creating-plugins/AddingPlugins.txt also leaves 'probe' out of both its
phase list and its "The stages are represented by the following strings"
list. The commented stage-dispatch template in TdcPlugin.adjust_command()
has no 'probe' branch either.

The dependsOn description in creating-testcases/AddingTestCases.txt only
says:

  dependsOn:    Same as 'skip', but the value is executed as a command. The test
                is skipped when the command returns non-zero.

Probes now run in the base namespace, outside the test netns. A future
dependsOn command that uses per-test devices such as $DEV0, $DEV1 or
$DUMMY would fail, and its test would just be skipped. Could this be noted
in the dependsOn description?

The fix also depends on plugins passing unknown stages through unchanged.
nsPlugin and valgrindPlugin both do that today.

The existing lists were already out of date ('command' rather than
'execute'). The missing 'probe' entry and the base-namespace behaviour of
dependsOn are new with this patch.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261111005533.6436-1-toddfreed%40meta.com
