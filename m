Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792615588;
	b=3b+q/+C+44eL4OrmQ4VMe6xuXgZ+AWqtNi63MfFU0S+U44pp3paO3sjJrMuKuWKw8rwX
	 V9nsfCifI3oReLGvYRRNKvkbLiR7XPUOtHTh0xer/nEDNKhy8ou19nnQM3xy9zbeQRMQk
	 yt1hnGcJbeZCqEE3kAz6W3bx3bU3XaB6kXdQ9/n47r0PIqPrtgcT31RwO3kZ7thW9aLA2
	 biJIWjuHyfjAK29cxZa8795fJ5bViyPYmcuabIC9YWxx27dFB5YG46ee5BN8mvcVWUvZW
	 OWNXY3n2bF3DtDEnEVjwJuQhWVPxPsKQajUxTx66euAEWK/wQrP6bQnC0pdatTgOCsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792615588;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=8SnZFxaRELav04IGE2T3EEZb8zml4amoByH6T8y6nIM=;
	b=jYA2SK0umM9Ce6bncanQ+b8HUBrUqJWRLJMZkqkgz2JRZKjnkYnCWKm+QKxPTIsGwVGd
	 sfZpaJHlUDPgQK/RsxhdBwkEOuyc9TDEWqsaMqexoNGcu4w8UEdpXbb0NAHQZwHJ/Z5/B
	 b5Ra0NCLgNzKwo4Dgz5oBxHg2aBs6C2BBEMPFoQZ2xuvuKFLCUsLoDVddX+AVrmnhP4nd
	 kyCXH42GBK4vdBP3+xAJk2xdxUkMdAJF/cX+iq+m1xZrBdD7S5MpGmLUeIhSp9x5QA570
	 awClH2+wdhavImdM7JJLbK+PhN3UC0m9wLKb9vDo9pO0POuLEpKUrMoxVtpXU4s3xWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="DN22zoq/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D26606A320
	for <linux-rdma@vger.kernel.org>; Wed, 21 Oct 2026 20:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DN22zoq/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197CF1F000C2;
	Wed, 21 Oct 2026 20:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792615587;
	bh=8SnZFxaRELav04IGE2T3EEZb8zml4amoByH6T8y6nIM=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=DN22zoq/+fvH7uL+qlaJlwLLkDEilp5Ph5McWywmCrx+vgwqg6xTH2rznXPdhbCV3
	 J0hWSOKuqPGdYllgR0E5FWuBq1GjWPCdwlJImsntBDi5mS0dBzOz6nL+KQGEXanUoY
	 86rZi1n61xZ7Oz5reR85rDmDNE9Ml6zFzvRoNJOqZRgU0j6SAqR3YWmk+0oJMMsHvO
	 hwUwWoyueaAkprO3fJA6jVfr5dr0rwIkLE3nweufeos7dp8n7t5+L5lGn6ElntIGNS
	 W55e/VZIrG/vbYSdvpXdY6nR1Mu76qrXppINpPYpvUUdNdwhI5gQwBmF7Qn1nhCunh
	 /VyZv/ZaUh0Iw==
Message-ID: <sashiko-outbox-180648@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/2] selftests/rdma: Add netkit-based automated test
 script for RXE
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhu Yanjun" <yanjun.zhu@linux.dev>, linux-rdma@vger.kernel.org
In-Reply-To: <20261021203115.54560-3-yanjun.zhu@linux.dev>
References: <20261021203115.54560-1-yanjun.zhu@linux.dev>
 <20261021203115.54560-3-yanjun.zhu@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 20:46:26 +0000
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
- [Medium] selftests/rdma: rxe_pkg_netkit.sh discards output and ignores du=
mp errors
- [Medium] selftests/rdma: unguarded tracefs access under set -e in rxe_pkg=
_netkit.sh
- [Medium] selftests/rdma: broken INT/TERM trap and dump teardown in cleanu=
p()
- [Medium] selftests/rdma: leaked background rping server process in cleanu=
p()
- [Medium] selftests/rdma: out-of-bounds and uninitialized read in print_bp=
f_output()
- [Medium] selftests/rdma: signed char passed to isprint() and printf() in =
print_bpf_output()
--

commit 550e551c2277aaac647ca619a6a0455e8de798af
Author: Zhu Yanjun <yanjun.zhu@linux.dev>

selftests/rdma: Add netkit-based automated test script for RXE

This commit adds an automated selftest script (rxe_pkg_netkit.sh) for the
Soft-RoCE (rxe) driver over netkit interfaces. It configures an isolated
network namespace with a netkit link pair, attaches rxe devices, and runs an
rping client/server test alongside packet dump and ftrace collection.

> diff --git a/tools/testing/selftests/rdma/rxe_pkg_netkit.sh b/tools/testi=
ng/selftests/rdma/rxe_pkg_netkit.sh
> new file mode 100755
> index 0000000000000..181e2d85eed76
> --- /dev/null
> +++ b/tools/testing/selftests/rdma/rxe_pkg_netkit.sh
> @@ -0,0 +1,81 @@

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
What happens in tools/testing/selftests/rdma/rxe_pkg_netkit.sh when the
script receives an interrupt or termination signal (such as on a kselftest
runner timeout)?

When cleanup() runs for an interrupt or termination trap, it executes
set +e in the shell's global environment, tears down rxe1, nk0, and ns0,
and returns without calling exit. In POSIX /bin/sh, returning from an
interrupt or termination trap resumes execution at the command following
the interrupted one. Because set +e remains in effect globally, all
subsequent commands (rping -c, rdma link del, ip link del, ip netns delete)
fail silently against the already-removed devices and namespace, and if the
final cat /sys/kernel/debug/tracing/trace succeeds, the script exits with
status 0 (a false pass) before running cleanup() a second time on exit.

Also, on the normal execution path:

    # Tear down RDMA links and netkit devices
    ip netns exec ns0 rdma link del rxe0
    rdma link del rxe1
    ip link del nk0
    ip netns delete ns0

the script deletes nk0 while rxe_netkit_dump is still running and attached
to nk0, duplicating the teardown in cleanup(), and then cleanup() kills
rxe_netkit_dump with kill -9 without waiting for it. Using kill -9 prevents
rxe_netkit_dump from catching the signal in sig_handler() and running its
cleanup path (ring_buffer__free() and rxe_pkg_kernel_dump__destroy()) or
flushing its standard output buffers.

Should cleanup() send a normal termination signal, wait for the child
process, and rely on the exit trap for teardown while having interrupt and
termination traps exit with a non-zero status?

> +
> +# Clear tracing buffer
> +echo > /sys/kernel/debug/tracing/trace

[Severity: Medium]
Can this access to /sys/kernel/debug/tracing/trace in
tools/testing/selftests/rdma/rxe_pkg_netkit.sh cause a hard test failure on
systems where debugfs or tracefs is not mounted at /sys/kernel/debug/tracing
or where kernel tracing is disabled in the kernel configuration?

Earlier in the script, missing prerequisites (root privileges, ip, rdma,
rping, netkit, and rdma_rxe) cause the test to skip with exit code 4.
However, after set -e is enabled, writing to and reading from
/sys/kernel/debug/tracing/trace will abort the script with exit status 1 if
that path is unavailable. Should the script check whether
/sys/kernel/debug/tracing/trace is available and writable before running, or
skip the test with exit code 4 when tracefs is not present?

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
When rxe_pkg_netkit.sh launches rxe_netkit_dump here and runs rping over
the netkit and rxe links, can handle_event() -> print_bpf_output() in
tools/testing/selftests/rdma/rxe_pkg_user_dump.c read uninitialized ring
buffer memory and read out of bounds past the pkg_event buffer?

In tools/testing/selftests/rdma/rxe_pkg_kernel_dump.c,
handle_netkit_ingress() reserves a pkg_event entry in the ring buffer
without zeroing e->data and copies only len bytes:

    e =3D bpf_ringbuf_reserve(&rb, sizeof(*e), 0);
    ...
    e->len =3D len;

    if (bpf_skb_load_bytes(skb, 0, e->data, len) < 0) {

Then in tools/testing/selftests/rdma/rxe_pkg_user_dump.c, handle_event()
passes e->len - sizeof(struct ethhdr) directly to print_bpf_output() without
checking that e->len is at least sizeof(struct ethhdr) or at most
MAX_PKT_LEN:

    static int handle_event(void *ctx, void *data, unsigned long data_sz)
    {
        const struct pkg_event *e =3D data;

        if (data_sz < sizeof(*e))
            return -1;

        print_bpf_output(e->data + sizeof(struct ethhdr),
                    e->len - sizeof(struct ethhdr));

        return 0;
    }

Inside print_bpf_output(), the header loop checks only that the start offset
of each header is within size, without verifying that the header structure
itself fits within the remaining captured bytes:

    for (int i =3D RXE_BTH + 1; i < NUM_HDR_TYPES; i++) {
        int offset =3D rxe_opcode[bth->opcode].offset[i];

        if (offset && (size >=3D sizeof(struct iphdr) + sizeof(struct udphd=
r) + offset)) {
            char *cur_p =3D (char *)bth + offset;

And when handling the payload in print_bpf_output(), len is computed by
subtracting rxe_opcode[bth->opcode].length from ntohs(udp_hdr->len) without
subtracting sizeof(struct udphdr) (8 bytes) and without clamping len to the
captured buffer size:

            case RXE_PAYLOAD:
                printf("RXE_PAYLOAD\n");
                int len =3D ntohs(udp_hdr->len) - rxe_opcode[bth->opcode].l=
ength;

                for (int j =3D 0; j < len; j++) {
                    if (isprint(cur_p[j]))
                        printf("%c", cur_p[j]);
                    else
                        printf("%02x", cur_p[j]);
                }

Because udp_hdr->len includes the 8-byte UDP header while cur_p starts at
(char *)bth + offset (after the UDP header and RoCE headers), len is always
8 bytes larger than the remaining packet bytes. On every packet with a
payload, cur_p[j] reads 8 bytes past the end of the captured packet into
uninitialized ring buffer memory (or past e->data[MAX_PKT_LEN] if the
packet length is near MAX_PKT_LEN).

[Severity: Medium]
Also in tools/testing/selftests/rdma/rxe_pkg_user_dump.c, can passing
cur_p[j] to isprint() and printf() in print_bpf_output() trigger undefined
behavior and sign-extension in the hex output?

In print_bpf_output(), cur_p is declared as a plain char pointer:

    char *cur_p =3D (char *)bth + offset;
    ...
    for (int j =3D 0; j < len; j++) {
        if (isprint(cur_p[j]))
            printf("%c", cur_p[j]);
        else
            printf("%02x", cur_p[j]);
    }

Because userspace tools under tools/testing/selftests/rdma/ are compiled
without -funsigned-char, char is signed on architectures like x86_64. Any
payload or trailing CRC byte with the high bit set (>=3D 0x80) is negative
when accessed through cur_p[j], which causes negative indexing in isprint()
and sign-extends to a 32-bit negative integer in printf("%02x", cur_p[j]),
printing 8 hex characters (such as ffffff80) instead of 2. Should cur_p[j]
be cast to unsigned char before calling isprint() and printf()?

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
Does tools/testing/selftests/rdma/rxe_pkg_netkit.sh leak the background
rping server process if rping -c fails or if the script exits early?

When rping -s is started in the background inside ns0, its process ID is
not saved, and cleanup() neither kills it nor deletes rxe0 inside ns0:

    cleanup() {
        set +e
        [ -n "$DUMP_PID" ] && kill -9 "$DUMP_PID" 2>/dev/null
        unset DUMP_PID

        rdma link del rxe1 2>/dev/null
        ip link del nk0 2>/dev/null
        ip netns delete ns0 2>/dev/null
    }

If rping -c fails to connect, the background rping -s process remains
blocked waiting for a connection, pinning the ns0 network namespace and
rxe0 device in the kernel even after ip netns delete ns0 unlinks the
namespace mount, and keeping inherited file descriptors open (which can
cause the kselftest runner pipeline to hang until timeout). Even when
rping -c succeeds, ip netns exec ns0 rdma link del rxe0 runs immediately
without waiting for the background rping -s process to finish disconnecting.

Should the script record the rping server PID, wait for it after rping -c
completes, and ensure cleanup() terminates the server and deletes rxe0?

> +rdma link del rxe1
> +ip link del nk0
> +ip netns delete ns0
> +
> +# Display kernel trace output
> +cat /sys/kernel/debug/tracing/trace

[Severity: Medium]
Does tools/testing/selftests/rdma/rxe_pkg_netkit.sh verify the packet dump
or tracing output, or does redirecting standard output to /dev/null cause
dump failures to go unnoticed?

Near the top of rxe_pkg_netkit.sh, standard output is redirected for the
entire script and all child processes:

    exec > /dev/null

As a result, both the RoCEv2 packet dump printed by rxe_netkit_dump and the
cat /sys/kernel/debug/tracing/trace output at the end of the script are
discarded to /dev/null without checking that any packets or trace entries
were captured. In addition, when rxe_netkit_dump is started in the
background:

    # Start dump utility in background
    "$CUR_WD/rxe_netkit_dump" &
    DUMP_PID=3D$!

the script never checks whether rxe_netkit_dump existed, succeeded in
loading and attaching its BPF program to nk0 before rping starts, or exited
with an error. Even if rxe_netkit_dump fails immediately or captures zero
packets, the script still exits with 0. Should the script verify that
rxe_netkit_dump attaches and captures the expected RoCEv2 packets and trace
output?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021203115.5456=
0-1-yanjun.zhu@linux.dev?part=3D2
