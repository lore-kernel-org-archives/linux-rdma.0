Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793468834;
	b=XaR+uSATbKDwOAiRBgiXfUvWy4TUF1NUgtIWTyVIG+gtMjNsEH/9txMJfJ6LcR6CkPJ+
	 auzlY4wJCYZlDNa3RPnwI5waioCU6BMh+ktxQql2xMgCCCPAGvN3ZN2s9+PW5AtZ+IuqV
	 PLDmVQNiupZstq8wvC//aVzGN6lQLhIolCSbrTje+zS0NGuOhyNbgPcOpy4rtQCITbDnn
	 0vThtXX7NWiO72CLIq0L1tUZeXdT1V54xqtRGOKy0sbd7aMJYAZNJhiNQSy0hgghXZlcY
	 p0+NJhlqCBodaNAIoVLE8qa1vcIuR774AR1ZyDlLlY0GAO4ix+DEJOIBToH46OZlTyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793468834;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=EHj9YNvjSD7HBJiyKseOvS62cncpOPtMdlsEHyYXePE=;
	b=ItfmTzDnZppTFhjMRRStenX/o9ULNqx6/sIHeKSY0wDF1PsLUSCL9LiWUGqoGNbaS/SN
	 u/kDEUME2Vw2jD5RWdRURMzsqziiCKXOm/fcsLKo3UTynyfqmK0PG2qUs6mZeIxxV37dW
	 Ke9u3HlVZid858oP1Jt4W6PPdn6i+GMxGZjeEhnaFyY4EvIpDl0yzLQEpMR7Lptk3yg1/
	 kq2RopQea3wBMwUhYzRO6BOF4iKAx4H3EXGYSfNnPDHOmIEz9XCyW2TClgNtoNolisR+A
	 J1t4UJ6xySy4Z9L4RFEuu7iqgn3X5hsmiLor6hgigLSQHO9YHKjOPYYFwgmejO3NH8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gPvBPsu8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B4A606A31C
	for <linux-rdma@vger.kernel.org>; Sat, 31 Oct 2026 17:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gPvBPsu8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4E31F000C1;
	Sat, 31 Oct 2026 17:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793468833;
	bh=EHj9YNvjSD7HBJiyKseOvS62cncpOPtMdlsEHyYXePE=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=gPvBPsu86Y05jJWB+HrHklKJQVsPQxCBfqiZvWQDcrLc5nXbSL7lu69QbcN1KEFgS
	 NFMHJIxSuSqMs1AN6jnNg8yp00mNZYqtxEbZ403JVvugqVWX2zbQ70Z1XklwJdPzO8
	 5wTYMRJdxdfvo9bz0Yg/q4ttRvbSZmdgkx6IMSjinxnhyKXxiKUCgvLZdOPQegaTlF
	 29J7CInVZo3ScJHLwFU/5Rgn4AdOpNRaVaaPonJEpqEMETLo2joMgwjnV4CTEtx+mY
	 2HBoTCioHzI21T/dadiYIr3Ec0dPbzAtprjJPkghXUZX96RfTU98+e1EApG2qQ7K9T
	 XPmKQA3KyTA5g==
Message-ID: <sashiko-outbox-192070@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 1/2] selftests/rdma: Introduce eBPF kernel and user
 dump utilities for RXE
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhu Yanjun" <yanjun.zhu@linux.dev>, linux-rdma@vger.kernel.org
In-Reply-To: <20261031173017.20691-2-yanjun.zhu@linux.dev>
References: <20261031173017.20691-1-yanjun.zhu@linux.dev>
 <20261031173017.20691-2-yanjun.zhu@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 31 Oct 2026 17:47:13 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 7 potential issue(=
s) to consider:
- [Medium] selftests/rdma: broken BPF/UAPI include paths, arpa/inet.h, and =
skel rule
- [Medium] selftests/rdma: incompatible callback signature in handle_event(=
) on 32-bit
- [Medium] selftests/rdma: print_bpf_output() includes ICRC and pad bytes i=
n payload
- [Medium] selftests/rdma: fixed IPv4 header size and header loop order in =
print_bpf_output()
- [Medium] selftests/rdma: missing -mcpu=3Dv3 in Makefile breaks BPF verifi=
cation
- [Low] selftests/rdma: u64 printf format mismatch and __be32 return in imm=
dt_imm()
- [Low] selftests/rdma: duplicated RXE tables/wrappers and hardcoded nk0 in=
 dump tool
--

commit f654ac52160578ed80b6042ffb2064d0f8f8a7d7
Author: Zhu Yanjun <yanjun.zhu@linux.dev>

selftests/rdma: Introduce eBPF kernel and user dump utilities for RXE

This commit adds eBPF-based kernel and user-space packet dump utilities
for Soft-RoCE (RXE) traffic over netkit devices in the RDMA selftests.

> diff --git a/tools/testing/selftests/rdma/Makefile b/tools/testing/selfte=
sts/rdma/Makefile
> index a91c14c45006e..f7783c20f40db 100644
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
> +$(OUTPUT)/rxe_pkg_kernel_dump.o: rxe_pkg_kernel_dump.c rxe_pkg_common.h
> +	$(CLANG) -g -O2 -target bpf -D__TARGET_ARCH_$(ARCH) $(INCLUDES) -c $< -=
o $@
> +
> +$(OUTPUT)/rxe_pkg_kernel.skel.h: $(OUTPUT)/rxe_pkg_kernel_dump.o
> +	$(BPFTOOL) gen skeleton $< > $@
> +
> +EXTRA_CLEAN :=3D $(OUTPUT)/rxe_pkg_kernel_dump.o $(OUTPUT)/rxe_pkg_kerne=
l.skel.h $(OUTPUT)/rxe_pkg_kernel.skel.h.tmp

[Severity: Medium]
Could these Makefile rules and include flags cause build failures across
out-of-tree, multiarch, and -Werror environments, or leave a corrupted
skeleton header behind if bpftool fails?

In tools/testing/selftests/rdma/Makefile, INCLUDES hardcodes
-I../../../../usr/include and -I../../../../include/uapi instead of using
$(KHDR_INCLUDES) provided by ../lib.mk. Hardcoding ../../../../usr/include
breaks out-of-tree builds (O=3D or KBUILD_OUTPUT=3D), and passing the raw
unexported -I../../../../include/uapi path to userspace compilation triggers
the #warning in include/uapi/linux/types.h when __EXPORTED_HEADERS__ is not
defined (failing under USERCFLAGS=3D-Werror) and fails to resolve generated
<asm/types.h> and <asm/byteorder.h> headers when in-tree headers have not
been exported.

In addition, the recipe for $(OUTPUT)/rxe_pkg_kernel.skel.h redirects stdout
directly to $@:

  $(BPFTOOL) gen skeleton $< > $@

If bpftool is missing or returns an error, the shell still creates an empty
$(OUTPUT)/rxe_pkg_kernel.skel.h file. Because that empty file satisfies
make's timestamp check on subsequent runs, compiling rxe_pkg_user_dump.c
then fails with undeclared skeleton symbols (even though EXTRA_CLEAN lists
$(OUTPUT)/rxe_pkg_kernel.skel.h.tmp, the rule does not write to $@.tmp and
mv it into place).

> diff --git a/tools/testing/selftests/rdma/rxe_pkg_kernel_dump.c b/tools/t=
esting/selftests/rdma/rxe_pkg_kernel_dump.c
> new file mode 100644
> index 0000000000000..2030529f94af7
> --- /dev/null
> +++ b/tools/testing/selftests/rdma/rxe_pkg_kernel_dump.c
> @@ -0,0 +1,78 @@
> +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
> +/*
> + * Copyright (c) 2026 Zhu Yanjun <yanjun.zhu@linux.dev>
> + */
> +
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_endian.h>
> +#include <linux/if_ether.h>
> +#include <linux/ip.h>
> +#include <arpa/inet.h>

[Severity: Medium]
Is <arpa/inet.h> needed in tools/testing/selftests/rdma/rxe_pkg_kernel_dump=
.c?

Because handle_netkit_ingress() uses bpf_htons() from <bpf/bpf_endian.h>,
<arpa/inet.h> is unused. Including a userspace libc header in a translation
unit compiled with clang -target bpf drops host architecture macros (such as
__x86_64__) and multiarch include paths (/usr/include/<arch>-linux-gnu),
which causes glibc headers (<features.h>, <sys/cdefs.h>, <gnu/stubs.h>) to
fail to locate <sys/cdefs.h> on multiarch distributions or fall back to
<gnu/stubs-32.h> and fail on 64-bit hosts without 32-bit glibc development
headers installed.

[ ... ]

> +SEC("netkit/primary")
> +int handle_netkit_ingress(struct __sk_buff *skb)
> +{
> +	/* Get the header pointer of skb */
> +	void *data_end =3D (void *)(long)skb->data_end;
> +	void *data =3D (void *)(long)skb->data;
> +
> +	struct ethhdr *eth =3D data;
> +
> +	/* Verify the data */
> +	if (data + sizeof(*eth) > data_end)
> +		return BPF_OK;
> +
> +	/* Check if it is IP skb */
> +	if (eth->h_proto =3D=3D bpf_htons(ETH_P_IP)) {
> +		struct iphdr *iph =3D data + sizeof(*eth);
> +
> +		if ((void *)iph + sizeof(*iph) <=3D data_end) {
> +			bpf_printk("Got IP packet from netkit ingress, %d\n", skb->len);
> +
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
> +			struct pkg_event *e;
> +
> +			/* The len is fixed to MAX_PKT_LEN */
> +			e =3D bpf_ringbuf_reserve(&rb, sizeof(*e), 0);
> +
> +			if (!e) {
> +				bpf_printk("bpf_ringbuf_reserve fails\n");
> +				return BPF_OK;
> +			}
> +
> +			e->len =3D len;
> +
> +			if (bpf_skb_load_bytes(skb, 0, e->data, len) < 0) {

[Severity: Medium]
Will handle_netkit_ingress() be rejected by the BPF verifier when compiled
without -mcpu=3Dv3?

In tools/testing/selftests/rdma/Makefile, $(OUTPUT)/rxe_pkg_kernel_dump.o is
built with:

  $(CLANG) -g -O2 -target bpf -D__TARGET_ARCH_$(ARCH) $(INCLUDES) -c $< -o =
$@

Without -mcpu=3Dv3, clang defaults to the BPF v1 ISA, which lacks 32-bit ALU
and JMP32 instructions. At -O2, clang lowers the 32-bit check
(if (len =3D=3D 0 || len > MAX_PKT_LEN)) into a 64-bit addition followed by=
 a
64-bit shift pair to zero-extend the lower 32 bits before the conditional
jump:

  r1 =3D r6
  r1 +=3D -1
  r1 <<=3D 32
  r1 >>=3D 32
  if r1 > 511 goto ...

In the kernel BPF verifier, adjust_reg_min_max_vals() preserves dst_reg->id
with BPF_ADD_CONST64 across BPF_ADD and BPF_SUB, but clears dst_reg->id via
clear_scalar_id() on BPF_LSH (r1 <<=3D 32). Because r1->id is 0 at the
conditional branch, check_cond_jmp_op() cannot propagate the [1, 512] bounds
back to r6 (len), leaving len with its initial umin=3D0 and umax=3DU32_MAX
bounds. When bpf_skb_load_bytes(skb, 0, e->data, len) is verified,
check_mem_size_reg() sees reg_umin(size_reg) =3D=3D 0 with zero_size_allowe=
d =3D=3D
false (and reg_umax exceeding sizeof(e->data)) and rejects loading the
program with -EACCES.

Should the clang invocation in Makefile pass -mcpu=3Dv3 (matching the other=
 BPF
selftests)?

> diff --git a/tools/testing/selftests/rdma/rxe_pkg_user_dump.c b/tools/tes=
ting/selftests/rdma/rxe_pkg_user_dump.c
> new file mode 100644
> index 0000000000000..4d3fede105f73
> --- /dev/null
> +++ b/tools/testing/selftests/rdma/rxe_pkg_user_dump.c

[ ... ]

> +static inline void print_reth(const struct rxe_reth *reth)
> +{
> +	printf("struct rxe_reth {\n");
> +	printf("\t__be64	va;	0x%llx\n", reth_va(reth));
> +	printf("\t__be32	rkey;	0x%x\n", reth_rkey(reth));
> +	printf("\t__be32	len;	0x%x\n", reth_len(reth));
> +
> +	printf("};\n");
> +}

[ ... ]

> +static inline void print_atmeth(struct rxe_atmeth *atmeth)
> +{
> +	printf("struct rxe_atmeth {\n");
> +	printf("\t__be64		va;       0x%llx\n", atmeth_va(atmeth));
> +	printf("\t__be32		rkey;     0x%x\n", atmeth_rkey(atmeth));
> +	printf("\t__be64		swap_add; 0x%llx\n", atmeth_swap_add(atmeth));
> +	printf("\t__be64		comp;     0x%llx\n", atmeth_comp(atmeth));
> +	printf("} __packed;\n");
> +}
> +
> +static inline u64 atmack_orig(struct rxe_atmack *atmack)
> +{
> +	return be64toh(atmack->orig);
> +}
> +
> +static inline void print_atmack(struct rxe_atmack *atmack)
> +{
> +	printf("struct rxe_atmack {\n");
> +	printf("\t__be64		orig; 0x%llx\n", atmack_orig(atmack));
> +	printf("};\n");
> +}

[ ... ]

> +static inline __be32 immdt_imm(struct rxe_immdt *immdt)
> +{
> +	return ntohl(immdt->imm);
> +}

[Severity: Low]
Will printing u64 (__u64) values with %llx in print_reth(), print_atmeth(),
and print_atmack() produce -Wformat warnings on 64-bit architectures such as
ppc64le where __u64 in userspace is unsigned long rather than unsigned long
long? Also, should immdt_imm() return u32 instead of __be32 since it conver=
ts
immdt->imm to host byte order with ntohl()?

[ ... ]

> +static void print_bpf_output(const void *data, __u32 size)
> +{
> +	/* Validate size covers IP and UDP headers */
> +	if (size < sizeof(struct iphdr) + sizeof(struct udphdr))
> +		return;
> +
> +	const struct iphdr *iph =3D (const struct iphdr *)data;
> +
> +	if (iph->protocol !=3D IPPROTO_UDP)
> +		return;
> +
> +	const struct udphdr *udp_hdr =3D (const struct udphdr *)(data + sizeof(=
struct iphdr));
> +
> +	if (ntohs(udp_hdr->dest) !=3D ROCEV2_PORT)
> +		return;
> +
> +	print_ipaddr(iph);
> +	printf("udp hdr:\n");
> +	print_udphdr(udp_hdr);
> +
> +	size_t base_hdr_size =3D sizeof(struct iphdr) + sizeof(struct udphdr)
> +				+ sizeof(struct rxe_bth);
> +
> +	if (size < base_hdr_size)
> +		return;
> +
> +	const struct rxe_bth *bth =3D (struct rxe_bth *)(data + sizeof(struct i=
phdr)
> +				+ sizeof(struct udphdr));
> +
> +	/* Validate opcode bounds and ensure name exists to prevent NULL derefe=
rence */
> +	if (bth->opcode >=3D 256 || !rxe_opcode[bth->opcode].name) {
> +		printf("Unknown or unpopulated opcode: 0x%x\n", bth->opcode);
> +		return;
> +	}
> +
> +	printf("%s\n", rxe_opcode[bth->opcode].name);
> +	print_bth(bth);
> +
> +	for (int i =3D RXE_BTH + 1; i < NUM_HDR_TYPES; i++) {
> +		int offset =3D rxe_opcode[bth->opcode].offset[i];
> +
> +		if (offset && (size >=3D sizeof(struct iphdr) + sizeof(struct udphdr) =
+ offset)) {
> +			const unsigned char *cur_p =3D (const unsigned char *)bth + offset;
> +			size_t remaining_size =3D size - ((const void *)cur_p - data);
> +
> +			if (i < ARRAY_SIZE(rxe_hdr_sizes) && rxe_hdr_sizes[i] > 0) {
> +				if (remaining_size < rxe_hdr_sizes[i])
> +					break;
> +			}

[Severity: Medium]
Does print_bpf_output() misparse packets when IPv4 options are present or
when headers appear in a different order than enum rxe_hdr_type?

First, print_bpf_output() computes the UDP and BTH offsets using
sizeof(struct iphdr) instead of validating iph->ihl >=3D 5 and advancing by
iph->ihl * 4.

Second, the loop iterates i from RXE_BTH + 1 to NUM_HDR_TYPES in enum
rxe_hdr_type order (where RXE_RETH =3D 3 precedes RXE_RDETH =3D 8 and
RXE_DETH =3D 9) rather than packet offset order. For RD opcodes such as
IB_OPCODE_RD_RDMA_WRITE_FIRST, RDETH and DETH are placed before RETH in the
packet, so breaking out of the loop when remaining_size < rxe_hdr_sizes[i]
skips headers with larger enum values that actually lie earlier in the
packet.

Third, bth->opcode is a __u8, so the bth->opcode >=3D 256 check is always
false.

[ ... ]

> +			case	RXE_PAYLOAD:
> +				printf("RXE_PAYLOAD\n");
> +				int expected_len =3D (int)ntohs(udp_hdr->len)
> +							- (int)sizeof(struct udphdr)
> +							- rxe_opcode[bth->opcode].length;
> +				int len =3D (expected_len < (int)remaining_size) ?
> +						expected_len : (int)remaining_size;
> +
> +				if (len < 0)
> +					len =3D 0;
> +
> +				for (int j =3D 0; j < len; j++) {
> +					if (isprint(cur_p[j]))
> +						printf("%c", cur_p[j]);
> +					else
> +						printf("%02x", cur_p[j]);
> +				}
> +				printf("\n");
> +				break;

[Severity: Medium]
Does the RXE_PAYLOAD calculation include the trailing BTH pad bytes and the
4-byte RoCEv2 ICRC as part of the payload?

Every RoCEv2 packet ends with 0..3 BTH pad bytes ((bth->flags & 0x30) >> 4)
and a 4-byte Invariant CRC (RXE_ICRC_SIZE, see payload_size() in
drivers/infiniband/sw/rxe/rxe_hdr.h). In addition, rxe_opcode[] sets a
non-zero .offset[RXE_PAYLOAD] even for opcodes that carry no payload, such
as IB_OPCODE_RC_ACKNOWLEDGE and IB_OPCODE_RC_RDMA_READ_REQUEST. Because
expected_len and remaining_size do not subtract RXE_ICRC_SIZE (4) and the B=
TH
padding length, print_bpf_output() prints 4 bytes of ICRC as RXE_PAYLOAD on
payload-less packets and appends padding and ICRC bytes to actual payloads.

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
> +	const struct pkg_event *e =3D data;
> +
> +	if (data_sz < sizeof(*e))
> +		return -1;
> +
> +	if (e->len < sizeof(struct ethhdr) || e->len > sizeof(e->data))
> +		return -1;
> +
> +	print_bpf_output(e->data + sizeof(struct ethhdr),
> +				e->len - sizeof(struct ethhdr));
> +
> +	return 0;
> +}

[ ... ]

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

[Severity: Medium]
Will passing handle_event() to ring_buffer__new() fail to build on 32-bit
architectures?

In tools/lib/bpf/libbpf.h, ring_buffer_sample_fn is defined as:

  typedef int (*ring_buffer_sample_fn)(void *ctx, void *data, size_t size);

However, handle_event() declares its third parameter as unsigned long
data_sz. On 32-bit architectures where size_t is unsigned int, passing
handle_event to ring_buffer__new() fails compilation with
-Wincompatible-pointer-types.

[Severity: Low]
This isn't a bug, but rxe_pkg_user_dump.c duplicates over 1,000 lines of
RXE header definitions, IB_OPCODE_* enums, rxe_opcode[] table entries, and
trivial wrapper functions (__bth_opcode()/bth_opcode(), etc.) from
drivers/infiniband/sw/rxe/, and rxe_opcode[] has already drifted from the
kernel table (omitting newer opcodes such as IB_OPCODE_RC_FLUSH and
IB_OPCODE_RC_ATOMIC_WRITE). In addition, main() hardcodes the interface name
"nk0" in if_nametoindex("nk0"). Could the interface name be passed via
command-line arguments (defaulting to "nk0"), and can the duplicated
definitions and wrappers in rxe_pkg_user_dump.c be trimmed or shared?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261031173017.2069=
1-1-yanjun.zhu@linux.dev?part=3D1
