Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CB747F3C1
	for <linux-rdma@vger.kernel.org>; Mon, 19 Oct 2026 04:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792384554; cv=none; b=HGar/uCNYi8gLxy5zoc+sa7ii37VFzWnkc6/tgLDSmHeErgiMuN2igLW/rtl3+/NckBve+lXDB+71Q8rQN1FYCfJ3H7yi+eKXbfAsAdAtr/how5A3mqgPby/hkWbm5lSHniWSGVMgwFnt7ftp3ofSIZPIXPL7Hs32VfDqpqJSBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792384554; c=relaxed/simple;
	bh=lvu5ZjHrP/szEhDcCXmETt9Vo3Q5yyKdFftFu3BGnHI=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=r+1fvvfd0WO08EGYy7ZeDpoggjTV/qo6+u3cb8xeniXpjkXFaNcGbtsCVelD66vJAxX23p9b2dWTavlXi1+GVhN/hdowCZ/3MrXTInwyGNWVP/F1bPL0W0vC/2LNJtNi+nGxDvimOlESzGnVgpAGZzZNREW9UXjx5aSvCN+lB5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JCIoFxAK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JCIoFxAK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B26D91F000C4;
	Mon, 19 Oct 2026 04:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792384546;
	bh=yc8ZGBIkjC9CPG1S1DXZZVE1ZCitd6GvePsqYUvtBXM=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=JCIoFxAK4+qfn6WNUZt7ra8QqQZz+qqjq+xvhx/LkRtcPTlt5RifaotKIyLTYPqUc
	 HeXJETRkrF2cPqDJpSXj55qvbjI5afUx1p1i5nTjFf89HUATYcVTAXDZ6lruRxbqYo
	 ubzK/vo96t5ZigLYL+jDmDn4+l5tJkzDj11Exw89Ki+FsRAzILXZGLw8keRufDXHpK
	 zApq1CC/Bczo5vkrkkW2Uc9G2nq2lU+IUu+PQxW4mvrP9UjFJmV+U8taBp6aD4zlBb
	 DmHkyK30pHK2eBc+8yl8E53MCvkZJtnmfeo/JxfinRQHb7dzfju0ntF8ntQKqQ38Yv
	 Du4i9HK4mPO0g==
Message-ID: <sashiko-outbox-176639@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] selftests/rdma: Introduce eBPF kernel and user dump
 utilities for RXE
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhu Yanjun" <yanjun.zhu@linux.dev>, linux-rdma@vger.kernel.org
In-Reply-To: <20261019041912.29488-2-yanjun.zhu@linux.dev>
References: <20261019041912.29488-1-yanjun.zhu@linux.dev>
 <20261019041912.29488-2-yanjun.zhu@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 04:35:46 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:
- [Medium] selftests/rdma: packet length modulo mask in handle_netkit_ingre=
ss()
- [Medium] selftests/rdma: out-of-bounds read and NULL deref in print_bpf_o=
utput()
- [Medium] selftests/rdma: unpacked rxe_atmeth and 32-bit ntohl() on 64-bit=
 fields
- [Medium] selftests/rdma: wrong SEC(tcx/ingress) for bpf_program__attach_n=
etkit()
- [Medium] selftests/rdma: unchecked ring_buffer__new() and error handling =
in main()
- [Low] selftests/rdma: missing -I$(OUTPUT) for skel header in out-of-tree =
build
--

commit 204669a3455849a1a36762bf8c4136de9ad033c1
Author: Zhu Yanjun <yanjun.zhu@linux.dev>

selftests/rdma: Introduce eBPF kernel and user dump utilities for RXE

This commit adds eBPF kernel and user-space packet dump utilities to capture
and parse Soft-RoCE (RXE) traffic over netkit devices in the RDMA selftests.

> diff --git a/tools/testing/selftests/rdma/Makefile b/tools/testing/selfte=
sts/rdma/Makefile
> index a91c14c45006e..6e099cabf90b2 100644
> --- a/tools/testing/selftests/rdma/Makefile
> +++ b/tools/testing/selftests/rdma/Makefile
> @@ -4,6 +4,27 @@ TEST_PROGS :=3D rxe_rping_between_netns.sh \
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
> +
> +INCLUDES	:=3D -I../../../../usr/include -I../../../../include/uapi -I../=
bpf
> +CFLAGS		+=3D -g -Wall $(INCLUDES)
> +LDFLAGS		+=3D -lbpf -lelf -lz
> +
> +$(OUTPUT)/rxe_netkit_dump: rxe_pkg_user_dump.c $(OUTPUT)/rxe_pkg_kernel.=
skel.h
> +	$(CC) $(CFLAGS) $< $(LDFLAGS) -o $@
> +
> +$(OUTPUT)/rxe_pkg_kernel_dump.o: rxe_pkg_kernel_dump.c
> +	$(CLANG) -g -O2 -target bpf -D__TARGET_ARCH_x86 $(INCLUDES) -c $< -o $@
> +
> +$(OUTPUT)/rxe_pkg_kernel.skel.h: $(OUTPUT)/rxe_pkg_kernel_dump.o
> +	$(BPFTOOL) gen skeleton $< > $@

[Severity: Low]
Will out-of-tree selftest builds (with O=3D... or OUTPUT=3D...) fail to loc=
ate
rxe_pkg_kernel.skel.h when compiling rxe_pkg_user_dump.c?

The rule generates $(OUTPUT)/rxe_pkg_kernel.skel.h, and rxe_pkg_user_dump.c
includes it with #include "rxe_pkg_kernel.skel.h", but INCLUDES does not
contain -I$(OUTPUT).

Also, should the $(OUTPUT)/rxe_pkg_kernel_dump.o rule derive the target
architecture instead of hardcoding -D__TARGET_ARCH_x86?

[ ... ]

> diff --git a/tools/testing/selftests/rdma/rxe_pkg_kernel_dump.c b/tools/t=
esting/selftests/rdma/rxe_pkg_kernel_dump.c
> new file mode 100644
> index 0000000000000..54dfc8028e904
> --- /dev/null
> +++ b/tools/testing/selftests/rdma/rxe_pkg_kernel_dump.c
> @@ -0,0 +1,67 @@
> +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
> +/*
> + * Copyright (c) 2026 Zhu Yanjun <yanjun.zhu@linux.dev>
> + */
> +
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +#include <linux/if_ether.h>
> +#include <linux/ip.h>
> +#include <arpa/inet.h>
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_RINGBUF);
> +	__uint(max_entries, 256 * 1024);/* Shared by all CPUs */
> +} rb SEC(".maps");
> +
> +SEC("tcx/ingress")
> +int handle_netkit_ingress(struct __sk_buff *skb)

[Severity: Medium]
Should handle_netkit_ingress() use SEC("netkit/primary") or SEC("netkit/pee=
r")
instead of SEC("tcx/ingress")?

In main() in rxe_pkg_user_dump.c, the program is attached with
bpf_program__attach_netkit(), which uses bpf_program__expected_attach_type(=
).
Because SEC("tcx/ingress") sets the expected attach type to BPF_TCX_INGRESS,
the kernel link_create path dispatches to tcx_link_attach() rather than
netkit_link_attach().

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
> +	if (eth->h_proto =3D=3D htons(ETH_P_IP)) {
> +		struct iphdr *iph =3D data + sizeof(*eth);
> +
> +		if ((void *)iph + sizeof(*iph) <=3D data_end) {
> +			bpf_printk("Got IP packet from netkit ingress, %d\n", skb->len);
> +
> +			__u32 len =3D skb->len & 0x1FF;
> +
> +			if (len =3D=3D 0) {
> +				bpf_printk("len is 0\n");
> +				return BPF_OK;
> +			}
> +
> +			void *reserve =3D bpf_ringbuf_reserve(&rb, 512, 0);
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
> +		}
> +	}

[Severity: Medium]
Does masking skb->len with 0x1FF in handle_netkit_ingress() truncate larger
packets and leave part of the ring buffer record uninitialized?

Using skb->len & 0x1FF computes skb->len modulo 512 rather than clamping the
length to 512. Any packet whose length is a multiple of 512 bytes results in
len =3D=3D 0 and is skipped, while packets larger than 512 bytes (such as a
520-byte or 1082-byte RDMA frame) only copy the remainder (8 or 58 bytes).

In addition, bpf_ringbuf_reserve(&rb, 512, 0) always reserves and submits a
512-byte record to userspace, but bpf_skb_load_bytes() only writes len byte=
s,
leaving the trailing 512 - len bytes of reserve uninitialized.

[ ... ]

> diff --git a/tools/testing/selftests/rdma/rxe_pkg_user_dump.c b/tools/tes=
ting/selftests/rdma/rxe_pkg_user_dump.c
> new file mode 100644
> index 0000000000000..39747ae1e06a3
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
> +} __packed;

[Severity: Medium]
Is __packed defined in this userspace program?

Because __packed is a kernel macro not provided by the included userspace
headers, this definition declares a global variable named __packed of type
struct rxe_atmeth rather than applying __attribute__((packed)). On 64-bit
architectures, 4 bytes of padding are inserted after rkey, shifting swap_add
and comp by 4 bytes and changing RXE_ATMETH_BYTES from 28 to 32.

[ ... ]

> +static inline void print_reth(struct rxe_reth *reth)
> +{
> +	printf("struct rxe_reth {\n");
> +	printf("\t__be64		va;\n");
> +	printf("\t__be32		rkey;\n");
> +	printf("\t__be32		len;\n");
> +	printf("};\n");
> +}
> +
> +#define AETH_MSN_MASK		(0x00ffffff)
> +
> +static inline u32 aeth_msn(struct rxe_aeth *aeth)
> +{
> +	return AETH_MSN_MASK & ntohl(aeth->smsn);
> +}
> +
> +static inline void print_aeth(struct rxe_aeth *aeth)
> +{
> +	printf("struct rxe_aeth {\n");
> +	printf("\t___be32		smsn; 0x%x\n", aeth_msn(aeth));
> +	printf("};\n");
> +}
> +
> +static inline u64 atmeth_va(struct rxe_atmeth *atmeth)
> +{
> +	return ntohl(atmeth->va);
> +}
> +
> +static inline u32 atmeth_rkey(struct rxe_atmeth *atmeth)
> +{
> +	return ntohl(atmeth->rkey);
> +}
> +
> +static inline u64 atmeth_swap_add(struct rxe_atmeth *atmeth)
> +{
> +	return ntohl(atmeth->swap_add);
> +}
> +
> +static inline u64 atmeth_comp(struct rxe_atmeth *atmeth)
> +{
> +	return ntohl(atmeth->comp);
> +}
> +
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
> +	return ntohl(atmack->orig);
> +}

[Severity: Medium]
Don't atmeth_va(), atmeth_swap_add(), atmeth_comp(), and atmack_orig()
truncate 64-bit fields by passing __be64 values to 32-bit ntohl() instead of
be64toh() or __be64_to_cpu()?

[ ... ]

> +static inline __be32 immdt_imm(struct rxe_immdt *immdt)
> +{
> +	return immdt->imm;
> +}
> +
> +static inline void print_immdt(struct rxe_immdt *immdt)
> +{
> +	printf("struct rxe_immdt {\n");
> +	printf("\t__be32		imm; 0x%x\n", immdt_imm(immdt));
> +	printf("};\n");
> +}

[Severity: Medium]
Should immdt_imm() also convert immdt->imm with ntohl() to match the other
header helpers?

[ ... ]

> +static void print_bpf_output(void *data, __u32 size)
> +{
> +	struct iphdr *iph =3D (struct iphdr *)data;
> +	struct udphdr *udp_hdr;
> +	struct rxe_bth *bth;
> +
> +	print_ipaddr(iph);
> +	udp_hdr =3D (struct udphdr *)(data + sizeof(struct iphdr));
> +
> +	printf("udp hdr:\n");
> +	print_udphdr(udp_hdr);
> +	bth =3D (struct rxe_bth *)(data + sizeof(struct iphdr) + sizeof(struct =
udphdr));
> +
> +	printf("%s\n", rxe_opcode[bth->opcode].name);
> +	print_bth(bth);
> +
> +	for (int i =3D RXE_BTH + 1; i < NUM_HDR_TYPES; i++) {
> +		int offset =3D rxe_opcode[bth->opcode].offset[i];
> +
> +		if (offset) {
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

[Severity: Medium]
Can print_bpf_output() dereference a NULL opcode name or read past the end =
of
the ring buffer sample?

First, neither handle_netkit_ingress() nor print_bpf_output() verifies that
iph->protocol =3D=3D IPPROTO_UDP, that the UDP destination port is 4791 (Ro=
CEv2),
or that size covers the headers. Because only 58 of the 256 entries in
rxe_opcode[] are populated, non-RoCEv2 IPv4 packets (such as TCP or ICMP
during rping setup) or unpopulated opcodes have rxe_opcode[bth->opcode].name
=3D=3D NULL, which crashes when passed to printf("%s\n", ...).

Second, in the RXE_PAYLOAD case:

	int len =3D ntohs(udp_hdr->len) - rxe_opcode[bth->opcode].length;

this calculation does not subtract sizeof(struct udphdr), BTH padding, or t=
he
4-byte ICRC, and does not clamp len against size. When ntohs(udp_hdr->len)
exceeds the 512-byte ring buffer record, the loop reads cur_p[j] past the e=
nd
of the buffer.

Third, cur_p is a signed char pointer on x86_64, so bytes >=3D 0x80 pass
negative values to isprint() and sign-extend in printf("%02x", cur_p[j]).
Also, print_reth() above prints the field names of struct rxe_reth without
printing the values of va, rkey, and len.

> +
> +static int handle_event(void *ctx, void *data, unsigned long data_sz)
> +{
> +	print_bpf_output(data+sizeof(struct ethhdr),
> +			 data_sz-sizeof(struct ethhdr));
> +	return 0;
> +}
> +
> +int main(void)
> +{
> +	struct rxe_pkg_kernel_dump *skel;
> +	int err;
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
> +	int ifindex =3D if_nametoindex("nk1");
> +
> +	if (ifindex =3D=3D 0) {
> +		perror("if_nametoindex nk1 failed");
> +		return 1;
> +	}
> +
> +	skel->links.handle_netkit_ingress =3D bpf_program__attach_netkit(
> +		skel->progs.handle_netkit_ingress, ifindex, NULL);
> +
> +	if (!skel->links.handle_netkit_ingress) {
> +		fprintf(stderr, "Failed to attach to netkit nk1\n");
> +		goto cleanup;
> +	}
> +
> +	err =3D rxe_pkg_kernel_dump__attach(skel);
> +	if (err) {
> +		fprintf(stderr, "Failed to attach BPF skeleton\n");
> +		goto cleanup;
> +	}
> +
> +	ringbuf =3D ring_buffer__new(bpf_map__fd(skel->maps.rb),
> +				   handle_event, NULL, NULL);
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
What happens in main() if ring_buffer__new() returns NULL?

ringbuf is passed directly to ring_buffer__poll(ringbuf, 100) without a NULL
check, which dereferences rb->epoll_fd and crashes.

Also, if if_nametoindex("nk1") fails, main() returns 1 without calling
rxe_pkg_kernel_dump__destroy(skel), whereas the later error paths that jump=
 to
cleanup return 0 instead of a non-zero exit code. Finally, since
handle_netkit_ingress is already attached via bpf_program__attach_netkit(),=
 is
the subsequent call to rxe_pkg_kernel_dump__attach(skel) needed?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019041912.2948=
8-1-yanjun.zhu@linux.dev?part=3D1
