Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793052392;
	b=Va+YljZYQQR6hluUMgjIzp9oYgDJhJornSWf6cS0MWIpBIZJiyR8NaubqAljiaFXvVtR
	 K3ETlDrN02021vF5zrJzgSYzGd5keuBjKbW2zUYsigUSO8vdCmv3lNAJOlcbZms19A9Qw
	 0jfF7aLUIIrIaRaM/itanQ509R2volU28IOhYyfJxwW21rHvFV7SwqfC0k3aYcI/bhF8h
	 e8z2TdntpUYhwsnyIiVExCzWoV+R3EcPTSiA7Rw9CIAEACPjvZ94oIl0ySf/4yvg79ejz
	 P9hrQDUN3GVHYdUTSP4P9OmQAumjY58SLW7qw+5nIzYyeZLfxIi1o9/Rf1TR3ZtG+HQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793052392;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=wAWEYmXq/B3CptQjEKEGd9irezeKlziTRgHOySV2wcs=;
	b=hX6mW8aMxIOJtThXpJO7tcsUB5BUcrWor7gB14cckUcTrcvvfzjVBtqNpJoErXAItjcd
	 Mpe/nqV8SrVV22hdR36k1gBGR6vlmgtAOy7p+xjOz+SP10X/hymPu0IaAw98mhDjEWUoP
	 JBsG8RPmhPRIslJTx3x4Hs7FA+wHCRdhPMTbvQcd62qgf7TPzKprN6NnkXWgJrBUGuN82
	 PIXZLeM6w1Hy9juYqddxm5+Y6302SFj63bQJyrDMJ9Wd8bvZHZ0rnE0I2Qvn8rUYZJjRL
	 dkOp5mKVX86akqjiCbBKxNWeIV+HwEWwlSj5ijYGTg6+QcMyD8b5/gLouXBoJ5tjLBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nYjRZQ7n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04BD606A31F
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 22:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nYjRZQ7n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AFE21F01825;
	Mon, 26 Oct 2026 22:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793052391;
	bh=wAWEYmXq/B3CptQjEKEGd9irezeKlziTRgHOySV2wcs=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=nYjRZQ7nLUoo2vo6+vXEQMz2EB/C71csG2SiKycK9UzuBmdBpADfMzBx8W3fgpJWe
	 Cv4UT+UM9Xg321hy6DmL7VEo1MHR/UFbL1s2woYmJXE6uuPYdJ+WziQabtbpv3efE1
	 Mx06N0FESYBbjNrYMtYcH1lTpMD7gwxjsz79yOVvF3WErhiZeonIMY5xIC42TlyOGf
	 6vcCSw+Un2EP9X0k1A/aXhgjwOvDPb3M9V8ZO3lFmicliLSHCsbKpH6jKejYulDmIK
	 8v6rBFBohzBAC1WucYWiPSUTmWgx7iJCoShXS0i6+VKg+k6HkQERYCTQlPvVi9/Dzd
	 sCXi+wB2vn53A==
Message-ID: <sashiko-outbox-185780@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 2/2] selftests/rdma: Add netkit-based automated test
 script for RXE
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhu Yanjun" <yanjun.zhu@linux.dev>, linux-rdma@vger.kernel.org
In-Reply-To: <20261026215236.60054-3-yanjun.zhu@linux.dev>
References: <20261026215236.60054-1-yanjun.zhu@linux.dev>
 <20261026215236.60054-3-yanjun.zhu@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 22:06:30 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Medium] selftests/rdma: stdout redirected to /dev/null and rxe_netkit_du=
mp unverified
- [Medium] selftests/rdma: rping server and rxe0 leaked in cleanup() of rxe=
_pkg_netkit.sh
- [Medium] selftests/rdma: unchecked /sys/kernel/debug/tracing/trace access=
 under set -e
- [Medium] selftests/rdma: cleanup() trap on INT/TERM does not exit and dis=
ables set -e
--

commit 113f4f28482f12566dde8a87cffb811f524f479c
Author: Zhu Yanjun <yanjun.zhu@linux.dev>

selftests/rdma: Add netkit-based automated test script for RXE

This commit adds the rxe_pkg_netkit.sh selftest script to automate function=
al
and tracing tests for the rxe driver over netkit interfaces using an isolat=
ed
network namespace and rping.

> diff --git a/tools/testing/selftests/rdma/rxe_pkg_netkit.sh b/tools/testi=
ng/selftests/rdma/rxe_pkg_netkit.sh
> new file mode 100755
> index 0000000000000..181e2d85eed76
> --- /dev/null
> +++ b/tools/testing/selftests/rdma/rxe_pkg_netkit.sh
> @@ -0,0 +1,81 @@
> +#!/bin/sh
> +# SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
> +# Copyright (c) 2026 Zhu Yanjun <yanjun.zhu@linux.dev>

[ ... ]

> +exec > /dev/null
> +
> +set -e
> +
> +CUR_WD=3D"$(dirname "$0")"
> +[ "$CUR_WD" =3D "." ] && CUR_WD=3D"$(pwd)"
> +
> +cleanup() {
> +    set +e
> +    [ -n "$DUMP_PID" ] && kill -9 "$DUMP_PID" 2>/dev/null
> +    unset DUMP_PID
> +
> +    rdma link del rxe1 2>/dev/null
> +    ip link del nk0 2>/dev/null
> +    ip netns delete ns0 2>/dev/null
> +}
> +
> +trap cleanup EXIT INT TERM

[Severity: Medium]
When rxe_pkg_netkit.sh receives an interrupt or termination signal via the
INT or TERM trap, cleanup() runs set +e, tears down the test devices and ns0
namespace, and then returns without exiting the shell.

In standard sh, returning from an INT or TERM trap handler resumes execution
at the command following the interrupted one. Will this cause the remainder
of the script to continue running with set -e disabled against already
deleted devices and namespaces, before running cleanup() a second time on
EXIT?

> +
> +# Clear tracing buffer
> +echo > /sys/kernel/debug/tracing/trace

[Severity: Medium]
What happens if /sys/kernel/debug/tracing/trace is not available on the test
system, for instance when tracing is not enabled in the kernel, debugfs is
not mounted, or tracefs is mounted standalone at /sys/kernel/tracing?

Because set -e is active here and there is no prerequisite check for
/sys/kernel/debug/tracing/trace, this redirection will abort the test with a
failure exit code of 1 instead of skipping with exit code 4. Additionally,
truncating /sys/kernel/debug/tracing/trace clears the host's global trace
buffer rather than using an isolated trace instance. Should the script check
that the trace file is accessible (and skip if not) before writing to it?

> +
> +# Create network namespace and netkit peer links
> +ip netns add ns0
> +ip link add nk0 type netkit mode l2 peer name nk1
> +ip link set nk0 up
> +ip link set nk1 up
> +
> +# Configure namespace interface
> +ip link set nk1 netns ns0
> +ip netns exec ns0 ip addr add 10.0.0.1/24 dev nk1
> +ip netns exec ns0 ip link set nk1 up
> +
> +# Configure host interface
> +ip addr add 10.0.0.2/24 dev nk0
> +
> +# Start dump utility in background
> +"$CUR_WD/rxe_netkit_dump" &
> +DUMP_PID=3D$!
> +
> +# Add RXE links over netkit devices
> +ip netns exec ns0 rdma link add rxe0 type rxe netdev nk1
> +rdma link add rxe1 type rxe netdev nk0
> +
> +# Start rping server in namespace
> +ip netns exec ns0 rping -s -a 10.0.0.1 -C 3 &
> +
> +# Add wait time
> +sleep 1
> +
> +# Run rping client on host
> +rping -c -a 10.0.0.1 -C 3
> +
> +# Tear down RDMA links and netkit devices
> +ip netns exec ns0 rdma link del rxe0

[Severity: Medium]
Does cleanup() leak the background rping -s server process and the rxe0 link
inside ns0 if rping -c fails or the script exits early?

When ip netns exec ns0 rping -s -a 10.0.0.1 -C 3 & is started in the
background, its process id is not saved, and cleanup() neither kills that
server process nor runs ip netns exec ns0 rdma link del rxe0:

cleanup() {
    set +e
    [ -n "$DUMP_PID" ] && kill -9 "$DUMP_PID" 2>/dev/null
    unset DUMP_PID

    rdma link del rxe1 2>/dev/null
    ip link del nk0 2>/dev/null
    ip netns delete ns0 2>/dev/null
}

Because ip netns delete ns0 only unmounts the namespace bind mount without
terminating processes running inside it, an early exit leaves the rping -s
process running in the background holding rxe0, the ns0 namespace, and
inherited file descriptors open (which can also cause the kselftest runner =
to
hang waiting for file descriptors to close). Even on the normal path,
ip netns exec ns0 rdma link del rxe0 runs immediately after rping -c finish=
es
without waiting for the background rping -s server to finish tearing down i=
ts
resources and exit.

> +rdma link del rxe1
> +ip link del nk0
> +ip netns delete ns0
> +
> +# Display kernel trace output
> +cat /sys/kernel/debug/tracing/trace

[Severity: Medium]
Earlier in the script, stdout is redirected for the entire process and its
children:

exec > /dev/null

Because of this redirection, both the output of "$CUR_WD/rxe_netkit_dump" &
and the final cat /sys/kernel/debug/tracing/trace at the end of the script
are discarded to /dev/null and never inspected.

Furthermore, "$CUR_WD/rxe_netkit_dump" & is launched asynchronously without
checking whether the binary exists, waiting for it to finish loading and
attaching its program to nk0 before traffic starts, or checking its exit
status and captured packet output. Can this cause the test to silently pass
even when rxe_netkit_dump fails to start, attach, or capture any packets?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026215236.6005=
4-1-yanjun.zhu@linux.dev?part=3D2
