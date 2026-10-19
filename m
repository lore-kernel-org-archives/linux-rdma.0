Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792446813;
	b=tfYeXiA7P31sSDBXxyrMxWeRTgHL3BgxJ8A02iATm3CStEAz2MOPuu9OfqHDJiB4FeYx
	 9nD9aBHpR8DogEXgzeJbqcQv0zmpq7I0DKhbfrjIFHi0mriZUM+pLEIVCxKgeElwhtwCY
	 LjwIXcuWE59/MAjh4bbHQnJTvaL/rHVYcP4MREMHvdGUm9qD7juE5+g1Cvu84kzQoE2Su
	 UpfmwLHZVuWBxt6TU9/KuddgPY669kWatEAJZ2t50IZ+c6Z8i65Y/rhxB09uoWc3eYzwK
	 pnTyiVNzAf4rCvh4c/jfL9Oi5Y9KU8HfkSNX8KyWrDBLvo1If5UuJwP8hWGktUUXHkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792446813;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=cuhtgYTi2MpQCUsQZNAKgqeECLnuVfPtl6lJ0DG6/kA=;
	b=qL0k8acN532fveDuWeaGgRLY6E1B9bwQfGTmrDKCoBcuhXNphogi8rVgO9FOYdFphUTH
	 eRDWaQMXAyRqw8vbPK/Un+nytHxeyGTOSv6EMnV3zbIssrtqzP+2rjDp2W206I08S8Xre
	 R8yXKGeg2dfkoKAJnQgoLhoQ8CKegFXfw19gFUIvw+62biSWVUkqjW4E5oyCeMYT+lrgh
	 tH6oukE048y1pvw+z5711bBEt6RIIysMyohEMmM+cZSwRqH/ljN2ewLrRpxbVXQBdLs1X
	 MgClWbB3s+TOO38N5FjO0Sp/jZRzsrU1XhzvfmT+uB5cW3Q0T1fzvUXBmiOBEokyiRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JTPZ5n29;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076D5606A31C
	for <linux-rdma@vger.kernel.org>; Mon, 19 Oct 2026 21:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JTPZ5n29
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E9B1F000C4;
	Mon, 19 Oct 2026 21:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792446812;
	bh=cuhtgYTi2MpQCUsQZNAKgqeECLnuVfPtl6lJ0DG6/kA=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=JTPZ5n294OU2mhPTJp0j3++795y/xmlkF1UwfruBsgWlhOa+M7GRE10CX2X7m15k6
	 TQ47W9XfkBAYueK8a9cuOKWSzpEP1KFFjBRY/BmKm3lZSTzJT2mm8HiKjNeZv0N+2O
	 jVOYF3Te8DJqOclu4xjZADzy0sbVgveATI/elwCx148NagthiOV3xo42ExgdCUWfCi
	 6oSGDUsjBtwHbVbRpKAaa2yGyhDcp8VccV6f9BESAstPYDo4K016rTFdMimrjSpBd3
	 VUvAUS4wK+4yvq2cMiVFBhvZRwKdq2LaBKEPzgNx7kSIiWuEUKkzu/Jken5gWMHBa+
	 ih1CMZIlaAoJg==
Message-ID: <sashiko-outbox-178279@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/2] selftests/rdma: Introduce eBPF kernel and user
 dump utilities for RXE
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhu Yanjun" <yanjun.zhu@linux.dev>, linux-rdma@vger.kernel.org
In-Reply-To: <20261019213821.44842-2-yanjun.zhu@linux.dev>
References: <20261019213821.44842-1-yanjun.zhu@linux.dev>
 <20261019213821.44842-2-yanjun.zhu@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 21:53:32 +0000
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
- [Medium] selftests/rdma: uninit ringbuf read and OOB payload dump in prin=
t_bpf_output()
- [Medium] selftests/rdma: missing packed attribute on struct rxe_atmeth
- [Medium] selftests/rdma: main() in rxe_pkg_user_dump.c masks errors by re=
turning 0
- [Low] selftests/rdma: broken include paths and system bpf deps in Makefile
--

commit cad47e7d3ec5a1fbd0772ac7d820b7588ad1671d
Author: Zhu Yanjun <yanjun.zhu@linux.dev>

selftests/rdma: Introduce eBPF kernel and user dump utilities for RXE

This commit adds eBPF-based kernel and user-space packet dump utilities
(rxe_pkg_kernel_dump.c and rxe_pkg_user_dump.c) to tools/testing/selftests/=
rdma/
to capture and parse Soft-RoCE (RXE) traffic over netkit devices.

> diff --git a/tools/testing/selftests/rdma/Makefile b/tools/testing/selfte=
sts/rdma/Makefile
> index a91c14c45006e..ba225e580787d 100644
> --- a/tools/testing/selftests/rdma/Makefile
> +++ b/tools/testing/selftests/rdma/Makefile
> @@ -4,6 +4,28 @@ TEST_PROGS :=3D rxe_rping_between_netns.sh \
>  		rxe_socket_with_netns.sh \
>  		rxe_test_NETDEV_UNREGISTER.sh \
>  		rxe_sent_rcvd_bytes.sh \
> -		rxe_netns_names.sh
> +		rxe_netns_names.sh \
> +		rxe_pkg_netkit.sh
> =20
> +TEST_GEN_PROGS_EXTENDED :=3D rxe_netkit_dump
>  include ../lib.mk
> +
> +CLANG	?=3D clang
> +LLC	?=3D llc
> +BPFTOOL	?=3D bpftool
> +ARCH ?=3D $(shell uname -m | sed 's/x86_64/x86/' | sed 's/aarch64/arm64/=
' | sed 's/ppc64le/powerpc/')
> +
> +INCLUDES	:=3D -I../../../../usr/include -I../../../../include/uapi -I../=
bpf -I$(OUTPUT)
> +CFLAGS		+=3D -g -Wall $(INCLUDES)
> +LDFLAGS		+=3D -lbpf -lelf -lz
> +
> +$(OUTPUT)/rxe_netkit_dump: rxe_pkg_user_dump.c $(OUTPUT)/rxe_pkg_kernel.=
skel.h
> +	$(CC) $(CFLAGS) $< $(LDFLAGS) -o $@
> +
> +$(OUTPUT)/rxe_pkg_kernel_dump.o: rxe_pkg_kernel_dump.c
> +	$(CLANG) -g -O2 -target bpf -D__TARGET_ARCH_$(ARCH) $(INCLUDES) -c $< -=
o $@
> +
> +$(OUTPUT)/rxe_pkg_kernel.skel.h: $(OUTPUT)/rxe_pkg_kernel_dump.o
> +	$(BPFTOOL) gen skeleton $< > $@

[Severity: Low]
Will these build rules work for out-of-tree builds or on systems without a
recent system-wide libbpf and bpftool installed?

There appear to be a few issues with the build configuration here:

1. INCLUDES hardcodes -I../../../../usr/include and -I../../../../include/u=
api
   instead of using $(KHDR_INCLUDES) from ../lib.mk. In out-of-tree builds
   (make O=3D...), exported headers are placed under $(O)/usr/include rather
   than ../../../../usr/include. Falling back to raw unexported kernel head=
ers
   in ../../../../include/uapi lacks generated asm headers, triggers the
   "Attempt to use kernel headers from user space" warning in
   include/uapi/linux/types.h, and uses raw _UAPI_* header guards that
   conflict with glibc headers such as net/ethernet.h. In addition, invoking
   $(CLANG) -target bpf without host multiarch system include paths (such as
   get_sys_includes in tools/testing/selftests/net/bpf.mk) can fail to loca=
te
   architecture headers like sys/cdefs.h, gnu/stubs.h, and asm/types.h.

2. The Makefile links against a system-installed -lbpf and invokes a system
   bpftool instead of building the in-tree tools/lib/bpf and
   tools/bpf/bpftool (as done in tools/testing/selftests/net/bpf.mk and
   tools/testing/selftests/hid/Makefile). Note that -I../bpf does not provi=
de
   bpf/bpf_helpers.h or bpf/libbpf.h, and rxe_pkg_user_dump.c requires
   recent libbpf support for bpf_program__attach_netkit() and
   SEC("netkit/primary").

3. The rule for $(OUTPUT)/rxe_pkg_kernel.skel.h redirects stdout directly to
   $@ without .DELETE_ON_ERROR or temporary file cleanup on failure, so a
   missing or failing bpftool leaves behind an empty header file that
   subsequent make invocations treat as up to date.

> +
> +EXTRA_CLEAN :=3D $(OUTPUT)/rxe_pkg_kernel_dump.o $(OUTPUT)/rxe_pkg_kerne=
l.skel.h
> diff --git a/tools/testing/selftests/rdma/rxe_pkg_kernel_dump.c b/tools/t=
esting/selftests/rdma/rxe_pkg_kernel_dump.c
> new file mode 100644
> index 0000000000000..7227fc4a6f57e
> --- /dev/null
> +++ b/tools/testing/selftests/rdma/rxe_pkg_kernel_dump.c

[ ... ]

> +SEC("netkit/primary")
> +int handle_netkit_ingress(struct __sk_buff *skb)
> +{

[ ... ]

> +			__u32 len =3D skb->len;
> +
> +			/* It is a rping test, the size of packets should be
> +			 * less than MAX_PKT_LEN
> +			 */
> +			if (len =3D=3D 0 || len > MAX_PKT_LEN) {
> +				bpf_printk("len is not in 0..MAX_PKT_LEN\n");
> +				return BPF_OK;
> +			}
> +
> +			/* The len is fixed to MAX_PKT_LEN */
> +			void *reserve =3D bpf_ringbuf_reserve(&rb, MAX_PKT_LEN, 0);
> +
> +			if (!reserve) {
> +				bpf_printk("bpf_ringbuf_reserve fails\n");
> +				return BPF_OK;
> +			}
> +
> +			if (bpf_skb_load_bytes(skb, 0, reserve, len) < 0) {
> +				bpf_ringbuf_discard(reserve, 0);
> +				bpf_printk("bpf_skb_load_bytes fails\n");
> +				return BPF_OK;
> +			}
> +
> +			bpf_ringbuf_submit(reserve, 0);

[Severity: Medium]
In handle_netkit_ingress(), bpf_ringbuf_reserve() always reserves MAX_PKT_L=
EN
(512) bytes, while bpf_skb_load_bytes() only writes len (skb->len) bytes in=
to
reserve without zeroing the trailing MAX_PKT_LEN - len bytes or passing the
actual captured packet length to user space.

When handle_event() in rxe_pkg_user_dump.c receives this record, data_sz is
always 512 rather than skb->len, so print_bpf_output() cannot tell how many
bytes were actually initialized by bpf_skb_load_bytes() (see the comment on
print_bpf_output() below).

> +		}
> +	}
> +
> +	/* BPF_OK:	Pass
> +	 * BPF_DROP:	Drop skb
> +	 */
> +	return BPF_OK;
> +}
> +
> +char _license[] SEC("license") =3D "GPL";
> diff --git a/tools/testing/selftests/rdma/rxe_pkg_user_dump.c b/tools/tes=
ting/selftests/rdma/rxe_pkg_user_dump.c
> new file mode 100644
> index 0000000000000..b98d77b1dcf2c
> --- /dev/null
> +++ b/tools/testing/selftests/rdma/rxe_pkg_user_dump.c

[ ... ]

> +/***********************************************************************=
*******
> + * Atomic Extended Transport Header
> + ***********************************************************************=
*******/
> +struct rxe_atmeth {
> +	__be64			va;
> +	__be32			rkey;
> +	__be64			swap_add;
> +	__be64			comp;
> +};

[Severity: Medium]
Should struct rxe_atmeth be marked with __attribute__((packed))?

In drivers/infiniband/sw/rxe/rxe_hdr.h, struct rxe_atmeth is defined with
__packed so that va (offset 0), rkey (offset 8), swap_add (offset 12), and
comp (offset 20) match the 28-byte RoCEv2 wire layout. Even print_atmeth()
below prints "} __packed;\n".

Without the packed attribute here, the compiler inserts 4 bytes of alignment
padding between rkey and swap_add, increasing RXE_ATMETH_BYTES from 28 to 32
bytes, shifting swap_add and comp by 4 bytes in print_atmeth(), and
miscalculating the header lengths and RXE_PAYLOAD offsets for
IB_OPCODE_RC_COMPARE_SWAP, IB_OPCODE_RC_FETCH_ADD, IB_OPCODE_RD_COMPARE_SWA=
P,
and IB_OPCODE_RD_FETCH_ADD.

[ ... ]

> +static void print_bpf_output(void *data, __u32 size)
> +{

[ ... ]

> +	for (int i =3D RXE_BTH + 1; i < NUM_HDR_TYPES; i++) {
> +		int offset =3D rxe_opcode[bth->opcode].offset[i];
> +
> +		if (offset && (size >=3D sizeof(struct iphdr) + sizeof(struct udphdr) =
+ offset)) {
> +			char *cur_p =3D (char *)bth + offset;
> +
> +			switch (i) {

[ ... ]

> +			case	RXE_PAYLOAD:
> +				printf("RXE_PAYLOAD\n");
> +				int len =3D ntohs(udp_hdr->len) - rxe_opcode[bth->opcode].length;
> +
> +				for (int j =3D 0; j < len; j++) {
> +					if (isprint(cur_p[j]))
> +						printf("%c", cur_p[j]);
> +					else
> +						printf("%02x", cur_p[j]);
> +				}
> +				printf("\n");
> +				break;
> +			default:
> +				break;
> +			}
> +		}
> +	}
> +
> +	printf("\n");
> +}
> +
> +static int handle_event(void *ctx, void *data, unsigned long data_sz)
> +{
> +	print_bpf_output(data+sizeof(struct ethhdr),
> +			 data_sz-sizeof(struct ethhdr));
> +	return 0;
> +}

[Severity: Medium]
Can print_bpf_output() read uninitialized ring buffer memory or read out of
bounds past the end of data[] when dumping headers and RXE_PAYLOAD?

Looking at handle_event() -> print_bpf_output():

1. Because handle_netkit_ingress() reserves a fixed 512-byte ring buffer
   entry without passing skb->len, size is always 498 (512 - sizeof(struct
   ethhdr)) rather than the captured packet length. Furthermore, the loop
   condition (size >=3D sizeof(struct iphdr) + sizeof(struct udphdr) + offs=
et)
   only checks that the start offset is within size, not that the full
   extended header (offset + sizeof(header)) fits within the captured packe=
t.

2. Under case RXE_PAYLOAD, len is computed as:

       int len =3D ntohs(udp_hdr->len) - rxe_opcode[bth->opcode].length;

   udp_hdr->len includes sizeof(struct udphdr) (8 bytes), the RoCE transport
   headers, the payload, BTH padding (0..3 bytes), and the 4-byte RoCEv2
   ICRC. Because sizeof(struct udphdr), padding, and the 4-byte ICRC are not
   subtracted, len is at least 12 bytes larger than the actual payload (and
   8 bytes larger than the entire UDP datagram). In addition,
   rxe_opcode[bth->opcode].offset[RXE_PAYLOAD] is populated even for
   header-only opcodes such as IB_OPCODE_RC_ACKNOWLEDGE and
   IB_OPCODE_RC_RDMA_READ_REQUEST, so RXE_PAYLOAD is entered unconditionall=
y.

3. Because len is never clamped to the remaining bytes in data[], cur_p[j]
   reads at least 8 bytes of uninitialized ring buffer memory past the end =
of
   every packet shorter than 512 bytes, and reads out of bounds past the end
   of the 512-byte ring buffer record when a packet is 505..512 bytes long
   (or if udp_hdr->len is larger than the buffer).

4. cur_p is a signed char *, so passing cur_p[j] directly to isprint() and
   printf("%02x", cur_p[j]) without casting to unsigned char invokes
   undefined behavior in isprint() for bytes >=3D 0x80 and sign-extends the=
m to
   8 hex digits.

> +
> +int main(void)
> +{
> +	struct rxe_pkg_kernel_dump *skel;
> +	int err =3D 1;
> +	struct ring_buffer *ringbuf =3D NULL;
> +	struct rlimit rlim =3D { .rlim_cur =3D RLIM_INFINITY, .rlim_max =3D RLI=
M_INFINITY };
> +
> +	if (setrlimit(RLIMIT_MEMLOCK, &rlim)) {
> +		perror("setrlimit failed");
> +		return 1;
> +	}
> +
> +	skel =3D rxe_pkg_kernel_dump__open_and_load();
> +	if (!skel) {
> +		fprintf(stderr, "Failed to open and load BPF skeleton\n");
> +		return 1;
> +	}
> +
> +	int ifindex =3D if_nametoindex("nk0");
> +
> +	if (ifindex =3D=3D 0) {
> +		perror("if_nametoindex nk0 failed");
> +		goto cleanup;
> +	}
> +
> +	skel->links.handle_netkit_ingress =3D bpf_program__attach_netkit(
> +		skel->progs.handle_netkit_ingress, ifindex, NULL);
> +
> +	if (!skel->links.handle_netkit_ingress) {
> +		fprintf(stderr, "Failed to attach to netkit nk0\n");
> +		goto cleanup;
> +	}
> +
> +	ringbuf =3D ring_buffer__new(bpf_map__fd(skel->maps.rb),
> +				   handle_event, NULL, NULL);
> +	if (!ringbuf) {
> +		fprintf(stderr, "Failed to create ring buffer\n");
> +		goto cleanup;
> +	}
> +
> +	err =3D 0;
> +
> +	while (1) {
> +		err =3D ring_buffer__poll(ringbuf, 100 /* timeout */);
> +		if (err < 0 && err !=3D -EINTR) {
> +			fprintf(stderr, "poll error\n");
> +			break;
> +		}
> +	}
> +
> +cleanup:
> +	ring_buffer__free(ringbuf);
> +	rxe_pkg_kernel_dump__destroy(skel);
> +	return 0;
> +}

[Severity: Medium]
Should main() return a non-zero exit status on error, and handle termination
signals cleanly?

If if_nametoindex("nk0"), bpf_program__attach_netkit(), or ring_buffer__new=
()
fails, execution jumps to cleanup with err =3D=3D 1; similarly, if
ring_buffer__poll() fails with an error other than -EINTR, the loop breaks =
to
cleanup with err < 0. However, the cleanup path ignores err and
unconditionally returns 0, masking failures from the calling test script.

Also, because the while (1) loop has no signal handler for SIGINT/SIGTERM a=
nd
print_bpf_output() never flushes stdout, running rxe_netkit_dump in the
background with stdout redirected to a file or pipe and killing it from a
test script will lose block-buffered stdout output and skip the cleanup
label.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019213821.4484=
2-1-yanjun.zhu@linux.dev?part=3D1
