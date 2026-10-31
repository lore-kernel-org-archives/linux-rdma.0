Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793468753;
	b=gHCjNsMX3IfHpvffX6ljidoRET7IW/k4GVI+A+/pGsef9PVblhT9+2jckYbld9YVT/Ou
	 3azWeE7afHwG6FFQ0x2EKBr4fGiDAA8OxzL30W25W6dW3UPnsG4sZ2ltelDb5DZopR4bA
	 07ZUGlfydVa0L9Gv37vyP3OiHQ8+aEkE/JIxhssG+FE2ssPu8ytyeqJEgkVl3sEdc59rl
	 5OQhqKtDDLYMN02W7A60+qrpxgB6DUW8mXc7SaWzmltdNvIYrYspZUxkTwrv+mAM5zDzl
	 5daCTE/yhkXWtEwIqVFk7KHiQOeSIOQL6CIlx1fVpQRaJwMu6BgBVME8XZcDKyyY6lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793468753;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=kT/843Zg+7u5cIvRiyB3EuVfiOtgOtg0s0z4uM/+paQ=;
	b=YKzJSKX+5b/2xpum5d9IUrbTSYA48b2jCIvw2Mw88eUJ4A25c7JTksBc0nI0s+EuGrcR
	 Dzq6EBs0wJvzL3MPQHdYvpjh+6bjnOkwkya2G7WPV3UOI9Rl5bWPNladRrCY8emn/55E4
	 rjY7DBd/uqXGennzb/K5fQKkjRrqgNtVj96Hohb7gnAlUkZ2WYN6iKV+a+/LmKQ5h8r2b
	 2DaQ5P369gakZAs99zdjxJKAYTvNpiwmgaZoKpH5r+Jn8LeUHhbCcEYIOhOvkmBpFPexq
	 qmOQyNHtZOaXAdddUbJBeb9n1hIS5XuKNW5hBXT0pPXvfIcQM+NFAlSbs+23QregN8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GstQuMMV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51706606A327
	for <linux-rdma@vger.kernel.org>; Sat, 31 Oct 2026 17:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GstQuMMV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF88F1F000C1;
	Sat, 31 Oct 2026 17:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793468753;
	bh=kT/843Zg+7u5cIvRiyB3EuVfiOtgOtg0s0z4uM/+paQ=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=GstQuMMVqsYShe7Mzmz/DUdskIbWJfEU3M071iEnKNh/9eDE7VESrt2rdbHGsxB2U
	 cE3FTPglEQ4xz0bY0ppODhssuouGW4VgEBytmKxLpDvgF7s6mhmK9thOuU3myRQfRj
	 lcGd2o0QF20vSZyhRwJQhM5Z+3rkp6YejQoWbRXd5HOn7ge8Q2ohU+aUeoG4Iw9/1s
	 YkbkXfCsn3m2i4BB+7NTETaJc5+iX3MtRrXHYeL+z5YZuf0V4g9ETIukOVkGlapTA6
	 /d0bGSQKhc6xGNLP+39pRip25eaY1+BcfaUi5L1489xQyBFsQMplJicl1FhVuThZ8k
	 kEh2jTiTz51rw==
Message-ID: <sashiko-outbox-192068@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 2/2] selftests/rdma: Add netkit-based automated test
 script for RXE
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhu Yanjun" <yanjun.zhu@linux.dev>, linux-rdma@vger.kernel.org
In-Reply-To: <20261031173017.20691-3-yanjun.zhu@linux.dev>
References: <20261031173017.20691-1-yanjun.zhu@linux.dev>
 <20261031173017.20691-3-yanjun.zhu@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 31 Oct 2026 17:45:52 +0000
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
- [Medium] selftests/rdma: unchecked /sys/kernel/debug/tracing/trace access=
 under set -e
- [Medium] selftests/rdma: double cleanup() and masked signal exit in rxe_p=
kg_netkit.sh
- [Medium] selftests/rdma: rxe_pkg_netkit.sh tears down links before stoppi=
ng processes
--

commit f5c35de37b8753656d0f89ba368ca5c8470cec1f
Author: Zhu Yanjun <yanjun.zhu@linux.dev>

selftests/rdma: Add netkit-based automated test script for RXE

This commit adds the rxe_pkg_netkit.sh selftest script to automate function=
al
and tracing tests for Soft-RoCE (RXE) over netkit interfaces inside an
isolated network namespace.

> diff --git a/tools/testing/selftests/rdma/rxe_pkg_netkit.sh b/tools/testi=
ng/selftests/rdma/rxe_pkg_netkit.sh
> new file mode 100755
> index 0000000000000..937144cb91a6c
> --- /dev/null
> +++ b/tools/testing/selftests/rdma/rxe_pkg_netkit.sh
> @@ -0,0 +1,91 @@

[ ... ]

> +exec > /dev/null
> +
> +set -e
> +
> +CUR_WD=3D"$(dirname "$0")"
> +[ "$CUR_WD" =3D "." ] && CUR_WD=3D"$(pwd)"
> +
> +cleanup() {
> +    local exit_code=3D$?
> +
> +    set +e
> +    [ -n "$RPING_PID" ] && kill -9 "$RPING_PID" 2>/dev/null
> +    unset RPING_PID
> +
> +    [ -n "$DUMP_PID" ] && kill -9 "$DUMP_PID" 2>/dev/null
> +    unset DUMP_PID
> +
> +    ip netns exec ns0 rdma link del rxe0 2>/dev/null
> +
> +    rdma link del rxe1 2>/dev/null
> +    ip link del nk0 2>/dev/null
> +    ip netns delete ns0 2>/dev/null
> +
> +    exit "$exit_code"
> +}
> +
> +trap cleanup EXIT INT TERM

[Severity: Medium]
As reported by Sashiko on v4 [1], when tools/testing/selftests/rdma/rxe_pkg=
_netkit.sh
receives SIGINT or SIGTERM (for example, on a kselftest timeout or user
interruption while waiting in sleep 1), cleanup() captures the status of the
previous completed command in exit_code=3D$?, which is 0 if that command
succeeded.

Because cleanup() then calls exit "$exit_code" without resetting the EXIT
trap via trap - EXIT, POSIX sh invokes the EXIT trap handler upon exit,
running cleanup() a second time and allowing an interrupted or timed-out te=
st
to exit with status 0. In addition, the resource deletion commands at the e=
nd
of the script duplicate the teardown already performed by cleanup() on norm=
al
EXIT.

Could cleanup() clear the EXIT trap before exiting and ensure signal-induced
termination exits with a non-zero status?

> +
> +# Clear tracing buffer
> +echo > /sys/kernel/debug/tracing/trace

[Severity: Medium]
As reported by Sashiko on v4 [2], tools/testing/selftests/rdma/rxe_pkg_netk=
it.sh
unconditionally writes to and reads from /sys/kernel/debug/tracing/trace
while set -e is active, and tools/testing/selftests/rdma/config does not
request CONFIG_TRACING or CONFIG_FTRACE.

If CONFIG_TRACING is disabled, debugfs is not mounted, or tracefs is mounted
standalone at /sys/kernel/tracing, this redirection fails under set -e and
aborts the test with exit status 1 instead of skipping with exit status 4 as
expected by kselftest when a kernel feature or mount is unavailable. Writing
to /sys/kernel/debug/tracing/trace also clears the host-wide global trace
buffer.

Should the script check that the trace file is available (or skip with exit
code 4 if unavailable) before accessing it?

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
> +RPING_PID=3D$!
> +
> +# Add wait time
> +sleep 1
> +
> +# Run rping client on host
> +rping -c -a 10.0.0.1 -C 3
> +
> +# Tear down RDMA links and netkit devices
> +ip netns exec ns0 rdma link del rxe0
> +rdma link del rxe1
> +ip link del nk0
> +ip netns delete ns0

[Severity: Medium]
As reported by Sashiko on v4 [3], right after rping -c returns,
tools/testing/selftests/rdma/rxe_pkg_netkit.sh deletes rxe0, rxe1, nk0, and
ns0 under set -e while the background rping -s server (RPING_PID) and
rxe_netkit_dump (DUMP_PID) processes may still be running and holding RDMA,
BPF netkit link, and network namespace resources.

When cleanup() subsequently runs, it sends SIGKILL (kill -9) to RPING_PID a=
nd
DUMP_PID without waiting for them to exit. Sending SIGKILL to DUMP_PID
bypasses sig_handler() in main() of tools/testing/selftests/rdma/rxe_pkg_us=
er_dump.c,
preventing rxe_netkit_dump from cleanly draining ring buffer events and
calling ring_buffer__free() and rxe_pkg_kernel_dump__destroy().

Could the script wait for RPING_PID to finish and stop DUMP_PID with SIGINT
or SIGTERM (followed by wait) before deleting the RDMA links, netkit
devices, and namespace?

> +
> +# Display kernel trace output
> +cat /sys/kernel/debug/tracing/trace

[Severity: Medium]
As reported by Sashiko on v4 [4], tools/testing/selftests/rdma/rxe_pkg_netk=
it.sh
redirects stdout to /dev/null via exec > /dev/null at the top of the script.
Because all child processes inherit this file descriptor, all packet dump
output from rxe_netkit_dump and the output of cat /sys/kernel/debug/tracing=
/trace
here are discarded to /dev/null without verifying that any packets or trace
entries were captured.

In addition, "$CUR_WD/rxe_netkit_dump" & is launched in the background
without checking that the binary exists and without waiting for
rxe_pkg_kernel_dump__open_and_load() and bpf_program__attach_netkit() to
complete before starting RDMA traffic, and its exit status is never checked
via wait.

If rxe_netkit_dump is missing, fails BPF loading or netkit attachment, or
captures zero packets, won't the test still report success?

[1] https://lore.kernel.org/r/20261026215236.60054-3-yanjun.zhu@linux.dev
[2] https://lore.kernel.org/r/20261026215236.60054-3-yanjun.zhu@linux.dev
[3] https://lore.kernel.org/r/20261026215236.60054-3-yanjun.zhu@linux.dev
[4] https://lore.kernel.org/r/20261026215236.60054-3-yanjun.zhu@linux.dev

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261031173017.2069=
1-1-yanjun.zhu@linux.dev?part=3D2
