Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CCB4DD6C6
	for <linux-rdma@vger.kernel.org>; Mon,  5 Oct 2026 17:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791220609; cv=none; b=XQCHaZwbPWPqx1Jyp58Siblvg6YSazJyvarmpcsUt31eVz52+S+ckFhVmQocjc1+ItSWI8fCrpBl4Z645uEbDQa5MdHl0dtn1MyoTacz9qseHv7j6Z2TWyeAtAHS43nsotus1Qf8sBIl3ioUN3Mh+ElMiyZ7d8xZEtyOPgOBYec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791220609; c=relaxed/simple;
	bh=CXISNVJcu+vhMQ4Nlt5LYwgpB/5853+njdwft9Du/KY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oOgC8+uT83JWPBg/fBkdncwl30rBUnVkvt5p9GA/JfaqIPnUOErPrdRcYzdOBYYcvgY863rAE6KnIideNiBfRL6c8AoMWnYUm1crtgVXCnKHQSR8CefeemQFRiL7vqm/xiYMYuedW52UQhCbhKRSkVAlF3LFvm6jDwWCmkMh/rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=grzijp6Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="grzijp6Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D12A1F000FF;
	Mon,  5 Oct 2026 17:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791220607;
	bh=PA+q9gSqnQP8IloUn5sPfvbjj0lwYcfo5X/uV9A0EyA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=grzijp6QGmJ0ayUFG2f2E4zO56M8hs9J6oXPJLSsaz+0c6urDjap6QERfS6CbH/x9
	 cdah9PYBS3g5/LQVa1sD7FmIxWeTyDZR9Nj3oLNQAAaEx6xUvqf519mxZYDf1dmYaE
	 e64RmwasVxTKawX9OOH0mJAowGex6Q5i16My16HjgOnWQp6SwY/jVK+60zzZNaV+Bc
	 8cbNy/gbl19K6w5nvlNV6KCTYkdtWLSzWPA5WRHOUO6JlpCo+n+MSepf26UZI2xMcF
	 wzK2AHnDtYwQgTasPUvFig1nzNJundjCkLemtu/n55whj8wFTzpifvQavYGNnur5hO
	 ov3ucriNXPMKQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH nf-next v3 3/3] selftests: netfilter: nft_flowtable.sh:
 check the priority a flow carries
Reply-To: sashiko-reviews@lists.linux.dev
To: "Julius Bairaktaris" <julius@bairaktaris.de>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261004171636.3545085-4-julius@bairaktaris.de>
References: <20261004171636.3545085-1-julius@bairaktaris.de>
 <20261004171636.3545085-4-julius@bairaktaris.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 05 Oct 2026 17:16:46 +0000
Message-Id: <20261005171647.3D12A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] selftests: netfilter: flaky priority test due to race in counter=
 reset
--

commit fb5120bafad5d9a740fa81fe7c9587aaad2d26eb
Author: Julius Bairaktaris <julius@bairaktaris.de>

selftests: netfilter: nft_flowtable.sh: check the priority a flow carries

Count the forwarded TCP packets that leave with priority 0:3 and those
that leave with none, first without a priority and then with "meta
priority set 0:3" ahead of "flow add". With the priority set, every
packet must carry it, including those the flowtable forwards. Runs for
IPv4 and IPv6.

> diff --git a/tools/testing/selftests/net/netfilter/nft_flowtable.sh b/too=
ls/testing/selftests/net/netfilter/nft_flowtable.sh
> index 449c518bd947d..73c7b1ec2208b 100755
> --- a/tools/testing/selftests/net/netfilter/nft_flowtable.sh
> +++ b/tools/testing/selftests/net/netfilter/nft_flowtable.sh

[ ... ]

> @@ -458,6 +458,106 @@ fi
>  	check_dscp "dscp_fwd" "$pmtu"
>  }
> =20
> +check_priority()
> +{

[ ... ]

> +test_tcp_forwarding_set_priority()
> +{
> +	local pmtu=3D"$3"
> +	local proto=3D"$4"
> +	local dstip=3D"$5"
> +	local dstport=3D"$6"
> +	local lret=3D0
> +
> +ip netns exec "$nsr1" nft -f - <<EOF
> +table netdev priocheck {
> +   counter prio0 { }
> +   counter prio3 { }
> +
> +   chain egress0 {
> +      type filter hook egress device "veth0" priority 0; policy accept
> +      meta l4proto tcp meta priority 0:3 counter name "prio3"
> +      meta l4proto tcp meta priority none counter name "prio0"
> +   }
> +
> +   chain egress1 {
> +      type filter hook egress device "veth1" priority 0; policy accept
> +      meta l4proto tcp meta priority 0:3 counter name "prio3"
> +      meta l4proto tcp meta priority none counter name "prio0"
> +   }
> +}
> +EOF
> +	if [ $? -ne 0 ]; then
> +		echo "SKIP: Could not load netdev:egress for veth0 and veth1"
> +		return 0
> +	fi
> +
> +	if ! test_tcp_forwarding_ip "$1" "$2" "$pmtu" "$proto" "$dstip" "$dstpo=
rt"; then
> +		lret=3D1
> +	fi
> +	check_priority "prio_none" "$pmtu"

[Severity: Medium]
Could this introduce test flakiness due to a race condition?

The test_tcp_forwarding_ip() function runs a socat TCP transfer and returns
as soon as the socat processes exit. However, final TCP packets (like FIN or
ACK) may still be in flight in the network namespaces.

When check_priority "prio_none" reads and resets the netfilter counters
immediately after the transfer completes, any delayed packet from this first
unprioritized run that arrives after the reset will increment the prio0
counter.

> +
> +	# The flow stores the priority set before it is added, so the packets
> +	# the flowtable forwards leave with it too, in both directions.
> +ip netns exec "$nsr1" nft -f - <<EOF
> +table inet prioset {
> +   chain forward {
> +      type filter hook forward priority -1; policy accept
> +      meta priority set 0:3
> +   }
> +}
> +EOF
> +	if ! test_tcp_forwarding_ip "$1" "$2" "$pmtu" "$proto" "$dstip" "$dstpo=
rt"; then
> +		lret=3D1
> +	fi
> +	check_priority "prio_fwd" "$pmtu"

[Severity: Medium]
If a delayed packet from the first run incremented prio0 after the reset,
will it cause this check to fail spuriously?

The prio_fwd check expects prio0 to remain exactly 0. If delayed packets
from the previous run are still trickling through, this might lead to
random test failures in kselftests.

> +
> +	ip netns exec "$nsr1" nft delete table inet prioset
> +	ip netns exec "$nsr1" nft delete table netdev priocheck
> +
> +	return $lret
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261004171636.3545=
085-1-julius@bairaktaris.de?part=3D3
