Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90E2479881
	for <linux-rdma@vger.kernel.org>; Mon, 19 Oct 2026 04:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792384356; cv=none; b=Gx2AWR2scdR/QcbtY68ekHb1kr7hmWD2Ftg2t92L0wbnPq235kS7ELQ3x6KAVTZbMQ9AxZWyj9ZoC6ML6l4m+pEmRGS+x4VbS0OuYiIOS6K+N6SnqY+JcFmruzLeNoW9FhBfnaODC/ya89GUU+CTaU2uv65KP0GgYEBmflm9wtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792384356; c=relaxed/simple;
	bh=C8sS8qmc7jWt2Ic4kpFGv9iiFk3C/anSxMBhzwj9ypM=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=KcwxnFp0S4qsY6ssvM5fOohT76g4jAV8A7KYtTjQTHYQdBCMWndZHjM+jaEtqRVmQK9cEq11IZpYz/FAYOPP5j1BY0/yh+FEVnyzLumkhlRcp4vTT/8xFvwn0UOkyE2VzPzqrrZmSd0srSUCV4YGnz+ZPTo1XCMVXkdbIHM90gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jrN7riIa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jrN7riIa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 376B61F000C4;
	Mon, 19 Oct 2026 04:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792384348;
	bh=oSjR9paYiRLKyjDCWs75UxPqgrVg3luFB0ua7l27yMY=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=jrN7riIa5S5VY2OQiYgF8/+UQgN9zQNeWlrD9M2KEaqXkmRTXD+BVxeJbTA5pO1b/
	 BEEClePBRD1eX8s8MNLMYCB4xIHKK9nmpWrSIVlstN63xuvt5s6ZP6e8s1mEFsyce9
	 wiXlaVevunOg9AwUNyly29Pivbhab4o/9aHh82Cgco9VnfJGy49u+WUPmktye7l4gv
	 Qwgk7IoPmQTUvNeTx9OAFHXs4dSjdeMGWzpd4oYVnkIyuSf0szqw487qvmNXiZIdlh
	 jkRYXsihJ/sIxX4RQP0eHwKVJbqlC0N9bVDzwVzj077G3VnXPdbk16cmLG41ZlE0xg
	 pKmCqOEw7pZHw==
Message-ID: <sashiko-outbox-176633@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] selftests/rdma: Add netkit-based automated test
 script for RXE
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhu Yanjun" <yanjun.zhu@linux.dev>, linux-rdma@vger.kernel.org
In-Reply-To: <20261019041912.29488-3-yanjun.zhu@linux.dev>
References: <20261019041912.29488-1-yanjun.zhu@linux.dev>
 <20261019041912.29488-3-yanjun.zhu@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 04:32:27 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:
- [Medium] selftests/rdma: cleanup() in rxe_pkg_netkit.sh deletes built tes=
t binary
- [Medium] selftests/rdma: incomplete resource teardown in cleanup() on err=
or exit
- [Medium] selftests/rdma: rxe_pkg_netkit.sh discards all stdout and trace =
output
- [Medium] selftests/rdma: missing prerequisite and KSFT_SKIP checks in rxe=
_pkg_netkit.sh
- [Medium] selftests/rdma: out-of-bounds and uninitialized reads in rxe_net=
kit_dump
- [Medium] selftests/rdma: missing ring_buffer__new() check and cleanup in =
main()
--

commit e9728fe036ee321c65ecc0a2cfb9996d436c85d4
Author: Zhu Yanjun <yanjun.zhu@linux.dev>

selftests/rdma: Add netkit-based automated test script for RXE

This commit adds a shell script to automate functional and tracing tests
for the Soft-RoCE (RXE) driver over netkit network interfaces using rping
and rxe_netkit_dump.

> diff --git a/tools/testing/selftests/rdma/rxe_pkg_netkit.sh b/tools/testi=
ng/selftests/rdma/rxe_pkg_netkit.sh
> new file mode 100755
> index 0000000000000..6b544d9f49ae8
> --- /dev/null
> +++ b/tools/testing/selftests/rdma/rxe_pkg_netkit.sh
> @@ -0,0 +1,63 @@
> +#!/bin/sh
> +# SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
> +# Copyright (c) 2026 Zhu Yanjun <yanjun.zhu@linux.dev>
> +
> +exec > /dev/null
> +
> +set -e

[Severity: Medium]
What happens if this test is run in an environment without root privileges,
mounted tracefs (/sys/kernel/debug/tracing/trace), kernel support or loaded
modules for netkit and rdma_rxe, or userspace utilities (ip, rdma, rping)?

Because set -e is enabled without checking prerequisites or sourcing
ktap_helpers.sh, any missing feature or command causes the script to abort
with exit status 1 instead of skipping with KSFT_SKIP (4).

> +
> +CUR_WD=3D"$(dirname "$0")"
> +[ "$CUR_WD" =3D "." ] && CUR_WD=3D"$(pwd)"
> +
> +cleanup() {
> +    set +e
> +    [ -n "$DUMP_PID" ] && kill -9 "$DUMP_PID" 2>/dev/null
> +    unset DUMP_PID
> +    ip netns delete ns0 2>/dev/null
> +    rm -f "$CUR_WD/rxe_netkit_dump" "$CUR_WD/rxe_pkg_kernel_dump.o" "$CU=
R_WD/rxe_pkg_kernel.skel.h"
> +}

[Severity: Medium]
Should cleanup() be deleting rxe_netkit_dump, rxe_pkg_kernel_dump.o, and
rxe_pkg_kernel.skel.h?

Because cleanup() is registered via trap cleanup EXIT, running
rxe_pkg_netkit.sh once deletes the compiled rxe_netkit_dump binary and build
artifacts from the working or installed kselftest directory. Since the scri=
pt
does not build rxe_netkit_dump itself and invokes it in the background:

    "$CUR_WD/rxe_netkit_dump" &

any subsequent run of the test will fail to execute rxe_netkit_dump unless =
the
test suite is rebuilt, and the parent shell will not catch the missing bina=
ry
under set -e because the background subshell launch itself returns 0.

> +
> +trap cleanup EXIT
> +
> +# Clear tracing buffer
> +echo > /sys/kernel/debug/tracing/trace
> +
> +# Create network namespace and netkit peer links
> +ip netns add ns0
> +ip link add nk0 type netkit mode l2 peer name nk1
> +ip link set nk0 up
> +ip link set nk1 up
> +
> +# Configure namespace interface
> +ip link set nk0 netns ns0
> +ip netns exec ns0 ip addr add 10.0.0.1/24 dev nk0
> +ip netns exec ns0 ip link set nk0 up
> +
> +# Configure host interface
> +ip addr add 10.0.0.2/24 dev nk1
> +
> +# Start dump utility in background
> +"$CUR_WD/rxe_netkit_dump" &
> +DUMP_PID=3D$!

[Severity: Medium]
Does launching rxe_netkit_dump and running rping over nk1 expose unchecked
allocations and out-of-bounds reads in the helper utility?

First, in tools/testing/selftests/rdma/rxe_pkg_user_dump.c:main(), if
if_nametoindex("nk1") returns 0 after rxe_pkg_kernel_dump__open_and_load(),
main() returns 1 directly without jumping to cleanup to call
rxe_pkg_kernel_dump__destroy(skel):

    skel =3D rxe_pkg_kernel_dump__open_and_load();
    ...
    ifindex =3D if_nametoindex("nk1");
    if (ifindex =3D=3D 0) {
        perror("if_nametoindex nk1 failed");
        return 1;
    }

Later in main(), ring_buffer__new() is passed directly to ring_buffer__poll=
()
without a NULL check:

    ringbuf =3D ring_buffer__new(bpf_map__fd(skel->maps.rb),
                   handle_event, NULL, NULL);

    while (1) {
        err =3D ring_buffer__poll(ringbuf, 100 /* timeout */);

If ring_buffer__new() returns NULL, ring_buffer__poll() in
tools/lib/bpf/ringbuf.c immediately dereferences rb->epoll_fd.

Second, in tools/testing/selftests/rdma/rxe_pkg_kernel_dump.c,
handle_netkit_ingress() captures every ETH_P_IP packet into a 512-byte ring=
buf
record using:

    __u32 len =3D skb->len & 0x1FF;
    ...
    void *reserve =3D bpf_ringbuf_reserve(&rb, 512, 0);

Using & 0x1FF wraps packet lengths >=3D 512 modulo 512 instead of clamping =
to
512, and leaves trailing bytes in the 512-byte ringbuf slot uninitialized.

When rping runs here, it first establishes an RDMA CM connection over TCP/I=
Pv4
before sending RoCEv2 UDP traffic. In
tools/testing/selftests/rdma/rxe_pkg_user_dump.c:print_bpf_output(), the
size parameter is ignored, iph->protocol and the UDP port are not checked,
rxe_opcode[bth->opcode].name is passed to printf() even when it is NULL on
non-RoCEv2 packets or uninitialized ringbuf bytes, and the RXE_PAYLOAD loop:

    int len =3D ntohs(udp_hdr->len) - rxe_opcode[bth->opcode].length;

    for (int j =3D 0; j < len; j++) {

reads cur_p[j] without bounding against the captured buffer size. Also in
rxe_pkg_user_dump.c, atmeth_va(), atmeth_swap_add(), atmeth_comp(), and
atmack_orig() apply 32-bit ntohl() to 64-bit __be64 fields.

> +
> +# Add RXE links over netkit devices
> +ip netns exec ns0 rdma link add rxe0 type rxe netdev nk0
> +rdma link add rxe1 type rxe netdev nk1
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
> +rdma link del rxe1
> +ip link del nk1
> +ip netns delete ns0

[Severity: Medium]
Can an error prior to this teardown block leak the background rping server,
the ns0 network namespace, the rxe0 and rxe1 RDMA links, and the nk0 and nk1
netkit interfaces?

The rping server is started in the background without saving its PID, and t=
he
teardown of rxe0, rxe1, and nk1 only happens on the normal completion path
above. If an earlier command such as the client rping -c fails under set -e,
execution jumps to cleanup(), which only kills DUMP_PID and runs
ip netns delete ns0.

Because ip netns delete ns0 only unlinks the namespace mount without killing
processes inside it, the live rping -s process keeps ns0, nk0, rxe0, and the
host peers nk1 and rxe1 pinned in the kernel, causing subsequent test runs =
to
fail.

> +
> +# Display kernel trace output
> +cat /sys/kernel/debug/tracing/trace

[Severity: Medium]
Is all output from cat /sys/kernel/debug/tracing/trace and rxe_netkit_dump
intentionally discarded here?

Because exec > /dev/null is at the top of the script, all standard output f=
or
the script and its child processes goes to /dev/null. In addition,
rxe_netkit_dump is launched asynchronously in the background without waiting
for the BPF program to load and attach to nk1 before rping starts, and noth=
ing
verifies that either the BPF packet dump or the kernel trace buffer captured
any events.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019041912.2948=
8-1-yanjun.zhu@linux.dev?part=3D2
