Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792446782;
	b=oPS8cCEGFO1FP7ozrbxjrgd8uGcZHsd4fRxLnwkqQfRxvIotKu4IgraHIvZ41s902KAO
	 H7Z160JUjItulg6sVnjUlFIpW+roIuQa0r6wyCCuJpkJZlKJ3brV60UZZvL8MUsqfb9fh
	 sa8nqDzdzJdJlbJ/T5wnnMyFJtWP56qev8UiQFnBBo+RuMt9JBQXTdaqsLt9kmIJcfpAZ
	 fjIvddc1gYMZx0joec4D0z3AmfUXqhDmurvtQRmN49nHiQqV64mNL7PEp4wR0N47JtSdz
	 Zyn11oSFCIzNbzlpphYWkR/VsELdVgPPgeTrwK5ji7wbaQdPeCaUnGoBIOWjRZY/+BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792446782;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=/hscP1s+bs6jWMIrA6PaqgzQHEvI5nzZ8ZnaQAFfi5U=;
	b=XaKYmxXizMVUmijOt7pOWYtlNy8LD4y2ICuoFushy+Kd0MbYLsbFiWnyNB3WBW7A46kO
	 uEuueQ95GbpP6LFCgWMLo9UK9PNfu7H5VXq+mPjbHdG1iNCcorVoy2+52ocpxS5AgzHCE
	 ypf9Kl1ojPIWOdECPt8+niUP53V8bxXlTl5yb2jYp2yhyNVMdmbzWbqpwffQSfsVSvBet
	 ueCdEhZWyumA0pAAo2OhRnwdQYBfWQuv9Dp0jJFiwt4JC9rA7aPibkWqtrv58wenOZLZq
	 NcyDZpP//J2dn/ykQWPVMBgybby8w0zb02+TGRibsdQ+fBkssBsoy0N6eWN6I560EMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NO523Oci;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC01606A31B
	for <linux-rdma@vger.kernel.org>; Mon, 19 Oct 2026 21:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NO523Oci
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9DE61F000C4;
	Mon, 19 Oct 2026 21:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792446782;
	bh=/hscP1s+bs6jWMIrA6PaqgzQHEvI5nzZ8ZnaQAFfi5U=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=NO523OcisQ0zDD/r6OEGUo2aYubp9v+9cfvgzSwZ2P6m2JSlk9izO5vX1jSEPJQsJ
	 VJnnCdqodtFBsv/jo9AI+ohXArpu8ij5HJsuKpnOmjubViH8CHUUq7yfEOFrCVUtH0
	 sFr9COUKKFuTALeqnjDNHvLtgXGO+UKax1SAU77+WU0gnwXRvNvKk6XzX7Ucv34FLJ
	 wHoO/0WMlkAcBSE6M0gN0DZH7z+YCS5Z7kcF+60aX0WRNCpAguQTvplZPd6TJiKy/c
	 HZu5vn2zTTfrZNpgWmD/CSGKtaU9+POqBkanZ9xTUyXGoUDPTj6xxrgjjmQoOsqJ7k
	 tkdr1GIHPVaTw==
Message-ID: <sashiko-outbox-178278@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] selftests/rdma: Add netkit-based automated test
 script for RXE
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhu Yanjun" <yanjun.zhu@linux.dev>, linux-rdma@vger.kernel.org
In-Reply-To: <20261019213821.44842-3-yanjun.zhu@linux.dev>
References: <20261019213821.44842-1-yanjun.zhu@linux.dev>
 <20261019213821.44842-3-yanjun.zhu@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 21:53:01 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:
- [Medium] selftests/rdma: cleanup() in rxe_pkg_netkit.sh deletes compiled =
test binary
- [Medium] selftests/rdma: rxe_pkg_netkit.sh leaks background rping server =
and rxe0 link
- [Medium] selftests/rdma: rxe_pkg_netkit.sh fails if debugfs trace path is=
 unavailable
- [Medium] selftests/rdma: rxe_pkg_netkit.sh ignores rxe_netkit_dump failur=
e and output
- [Medium] selftests/rdma: cleanup() trap on INT/TERM resumes execution wit=
h set +e
- [Medium] selftests/rdma: overread in print_bpf_output() when dumping RXE_=
PAYLOAD
--

commit 6a324ce884c90ec9814616bc95190ffe879b8905
Author: Zhu Yanjun <yanjun.zhu@linux.dev>

selftests/rdma: Add netkit-based automated test script for RXE

This commit adds a shell script to automate functional and tracing tests
for the Soft-RoCE (RXE) driver over netkit network interfaces using rping
and rxe_netkit_dump.

> diff --git a/tools/testing/selftests/rdma/rxe_pkg_netkit.sh b/tools/testi=
ng/selftests/rdma/rxe_pkg_netkit.sh
> new file mode 100755
> index 0000000000000..a876bd9d57efb
> --- /dev/null
> +++ b/tools/testing/selftests/rdma/rxe_pkg_netkit.sh
> @@ -0,0 +1,83 @@
[ ... ]
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
> +
> +    rm -f "$CUR_WD/rxe_netkit_dump" "$CUR_WD/rxe_pkg_kernel_dump.o" "$CU=
R_WD/rxe_pkg_kernel.skel.h"

[Severity: Medium]
Should cleanup() really remove rxe_netkit_dump, rxe_pkg_kernel_dump.o, and
rxe_pkg_kernel.skel.h here?

tools/testing/selftests/rdma/Makefile builds these files during compilation
and cleans them via TEST_GEN_PROGS_EXTENDED and EXTRA_CLEAN. Because
cleanup() is registered via trap on EXIT, running rxe_pkg_netkit.sh once
deletes the compiled rxe_netkit_dump binary from the test or installed
kselftest directory, causing all subsequent runs of the script to fail when
invoking "$CUR_WD/rxe_netkit_dump".

> +}
> +
> +trap cleanup EXIT INT TERM

[Severity: Medium]
When SIGINT or SIGTERM is delivered to rxe_pkg_netkit.sh (for example, on a
kselftest timeout), cleanup() runs set +e, tears down the test interfaces,
and returns without exiting the shell.

Won't the script then resume execution on the torn-down interfaces with
error checking disabled, run cleanup() a second time on EXIT, and
potentially exit with status 0 after being interrupted by a signal?

> +
> +# Clear tracing buffer
> +echo > /sys/kernel/debug/tracing/trace

[Severity: Medium]
What happens on systems where tracefs is mounted standalone at
/sys/kernel/tracing without debugfs at /sys/kernel/debug/tracing, or when
kernel tracing is not enabled in the config?

With set -e active, writing to /sys/kernel/debug/tracing/trace will abort
the script with a failure exit code rather than falling back to
/sys/kernel/tracing/trace or skipping with exit 4.

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

[Severity: Medium]
When rxe_pkg_netkit.sh starts rxe_netkit_dump and generates RoCEv2 rping
traffic, can print_bpf_output() in rxe_pkg_user_dump.c read past the end of
the captured packet into uninitialized ring buffer memory, or out-of-bounds
past the ring buffer record?

In tools/testing/selftests/rdma/rxe_pkg_kernel_dump.c:
handle_netkit_ingress() reserves a fixed MAX_PKT_LEN (512) bytes in the BPF
ring buffer, but only copies len (skb->len) bytes:

    void *reserve =3D bpf_ringbuf_reserve(&rb, MAX_PKT_LEN, 0);
    ...
    if (bpf_skb_load_bytes(skb, 0, reserve, len) < 0) {

Then in tools/testing/selftests/rdma/rxe_pkg_user_dump.c, handle_event()
passes data_sz - sizeof(struct ethhdr) (which is always 512 - 14 =3D 498) to
print_bpf_output(), and the RXE_PAYLOAD handler computes:

    case RXE_PAYLOAD:
        printf("RXE_PAYLOAD\n");
        int len =3D ntohs(udp_hdr->len) - rxe_opcode[bth->opcode].length;

        for (int j =3D 0; j < len; j++) {
            if (isprint(cur_p[j]))
                printf("%c", cur_p[j]);
            else
                printf("%02x", cur_p[j]);
        }

Because cur_p starts at (char *)bth + offset (after the UDP and RDMA
headers), and len does not subtract sizeof(struct udphdr) (8 bytes) or
check against the captured packet size, doesn't this loop read 8 bytes past
skb->len into uninitialized ring buffer memory on every RoCEv2 packet, and
read past the 512-byte ring buffer record when skb->len > 504?

> +
> +# Add RXE links over netkit devices
> +ip netns exec ns0 rdma link add rxe0 type rxe netdev nk1
> +rdma link add rxe1 type rxe netdev nk0
> +
> +# Start rping server in namespace
> +ip netns exec ns0 rping -s -a 10.0.0.1 -C 3 &

[Severity: Medium]
Does cleanup() leak the background rping server process and the rxe0 RDMA
link if the rping client fails or the script is interrupted?

Unlike DUMP_PID, the PID of this background rping -s process is not saved,
and cleanup() neither kills it nor runs:

    ip netns exec ns0 rdma link del rxe0 2>/dev/null

If rping -c fails under set -e, ip netns delete ns0 in cleanup() only
unlinks the netns mount point while the orphaned rping -s process stays
alive holding ns0, nk1, rxe0, and the inherited stdout/stderr pipe file
descriptors open (which can also cause the kselftest runner to hang waiting
for pipe EOF).

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
> +
> +# Display kernel trace output
> +cat /sys/kernel/debug/tracing/trace

[Severity: Medium]
Will this test pass even if rxe_netkit_dump fails to start, fails to attach
its BPF program to nk0, or captures no packets?

Launching "$CUR_WD/rxe_netkit_dump" & in the background succeeds even if
the binary is missing or exits immediately (and main() in
rxe_pkg_user_dump.c returns 0 on its goto cleanup error paths). In
addition, cleanup() terminates DUMP_PID with kill -9, which prevents
rxe_netkit_dump from flushing block-buffered stdout when running under
non-interactive kselftest pipes or cleaning up its BPF resources, and the
final cat /sys/kernel/debug/tracing/trace does not check that any expected
trace events or packets were recorded.

Would it be better to verify that DUMP_PID is alive and ready before
running rping, signal it with SIGINT or SIGTERM instead of SIGKILL, and
check that the expected trace output was actually captured?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019213821.4484=
2-1-yanjun.zhu@linux.dev?part=3D2
