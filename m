Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792615587;
	b=vI0x2FGWPm4VBSzET706QKU7hcjIuaHiSpS5j+C3g+sZEAYfU6dpy01tOrDyjm/UBkPW
	 2r7pf/zZxz4ivYG626Zji4KGjyNbSosVX8Y+ZQd086Bn4d/5oUQa4bAmjnE+CtE7Y37Rj
	 vusfZ0b21NPB+fZnzee0SSCX9npi5zWWLz4iZwyVVr0BbVk9MsEJEanDdD5PcdPfWa/VX
	 4zSvbGaZHtfl5MZEHjXzvMO+gLJ1STua/GH5VSP8idKJIDtFxFrs/LJ7E2VetiTDj92eW
	 8FgJTIcNABahim+5KkzVtWNoSs+VfRRejxKvD0QnrkWffPnBDw1dsozoTubB6zJ4tmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792615587;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=dL7Ws1ungLIkMuhv/6HrMNHXP7Ic50rEB397RITbKY0=;
	b=P4Sb379BDJzv54F43JTcU707U3P9EdGrowSrS0a3/7pmvrusHtl6ND+80Mi1raJEnEkK
	 9nIn22lwGC2zT8o1hu3ok9paW2HFHzNTFluGSKIqevPkwT8/boprnJ60p77iTwlDSiud6
	 XkQhtLlldlAUjiHck4PJxr0Jg7/e7B9GVw4wSGvFFDKOnkLCXdYwnX3bx5YQPzOqxnqVJ
	 X89IeGza8UjctY0qkrCzfACDKvdJj3GtloN/8/MIv9t/y0fN/DEyFkUHwWLKM0kjCKe5S
	 1hPP60s8LQSav6VrTH4Y0a4ur9AUKwadtOek2MbKnkKS0/mR98f9YPLC5SfE1uWkzvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YeAU2+lI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE13606A31D
	for <linux-rdma@vger.kernel.org>; Wed, 21 Oct 2026 20:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YeAU2+lI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D461F000C1;
	Wed, 21 Oct 2026 20:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792615586;
	bh=dL7Ws1ungLIkMuhv/6HrMNHXP7Ic50rEB397RITbKY0=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=YeAU2+lIcBQwCFUB5zFyFtQZfMHE8IjS2GuT9jXgCHc7pZeSWhgrttlYClxnioj4T
	 I8dU//1D1fwiZbMEmNJqXIMae7AoQjr+Gu6nH2bLvCAu2gXUlXKpUK7MduqSO8rAmh
	 ugk5TKgKuUJI9ccGghR0Mvjc2gGUFb+7E3TWp5hICHo3CP0b67RHj4akL55Lhn0iOV
	 eTSYiNF/Tag4grlQhPtoKnmav72dyWSws9bRSl0nEoWwGHQvr75Moeaazqh6K/XGLW
	 9CMtfey7Aw5xSnTKTGtoU2g1iW/Sq/Cu3z+TwJ2zCqwCns6fPCYSnDq9dZj3/fxJHK
	 0zwKtpOi0QJHQ==
Message-ID: <sashiko-outbox-180647@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/2] selftests/rdma: Introduce eBPF kernel and user
 dump utilities for RXE
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhu Yanjun" <yanjun.zhu@linux.dev>, linux-rdma@vger.kernel.org
In-Reply-To: <20261021203115.54560-2-yanjun.zhu@linux.dev>
References: <20261021203115.54560-1-yanjun.zhu@linux.dev>
 <20261021203115.54560-2-yanjun.zhu@linux.dev>
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

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Medium] selftests/rdma: out-of-bounds read in print_bpf_output() packet =
parsing
- [Medium] selftests/rdma: invalid userspace header and build flags for BPF=
 dump object
- [Medium] selftests/rdma: missing signal handling and stdout flush in main=
()
- [Low] selftests/rdma: conflicting __u64 typedef in rxe_pkg_user_dump.c
--

commit 812649f812ece426007a23045167b73c8aff9b63
Author: Zhu Yanjun <yanjun.zhu@linux.dev>

selftests/rdma: Introduce eBPF kernel and user dump utilities for RXE

This commit adds an eBPF program and a user-space ring-buffer consumer util=
ity
to capture and dump Soft-RoCE (rxe) packets over netkit devices in the rdma
selftests.

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
> +
> +EXTRA_CLEAN :=3D $(OUTPUT)/rxe_pkg_kernel_dump.o $(OUTPUT)/rxe_pkg_kerne=
l.skel.h

[ ... ]

> diff --git a/tools/testing/selftests/rdma/rxe_pkg_common.h b/tools/testin=
g/selftests/rdma/rxe_pkg_common.h
> new file mode 100644
> index 0000000000000..0dca4147d5f9a
> --- /dev/null
> +++ b/tools/testing/selftests/rdma/rxe_pkg_common.h
> @@ -0,0 +1,17 @@
> +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
> +/*
> + * Copyright (c) 2026 Zhu Yanjun <yanjun.zhu@linux.dev>
> + */
> +
> +// rxe_pkg_common.h
> +#ifndef RXE_PKG_COMMON_H
> +#define RXE_PKG_COMMON_H
> +
> +#define MAX_PKT_LEN 512
> +
> +struct pkg_event {
> +	__u32 len;
> +	__u8 data[MAX_PKT_LEN];
> +};
> +
> +#endif
> diff --git a/tools/testing/selftests/rdma/rxe_pkg_kernel_dump.c b/tools/t=
esting/selftests/rdma/rxe_pkg_kernel_dump.c
> new file mode 100644
> index 0000000000000..f465b52e7366c
> --- /dev/null
> +++ b/tools/testing/selftests/rdma/rxe_pkg_kernel_dump.c
> @@ -0,0 +1,77 @@
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
> +#include "rxe_pkg_common.h"
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_RINGBUF);
> +	__uint(max_entries, 256 * 1024);/* Shared by all CPUs */
> +} rb SEC(".maps");
> +
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
> +	if (eth->h_proto =3D=3D htons(ETH_P_IP)) {

[Severity: Medium]
Will compiling rxe_pkg_kernel_dump.c with -target bpf and including the
userspace <arpa/inet.h> header break the build or fail verification on
standard multiarch and 64-bit distributions?

When compiling with -target bpf in tools/testing/selftests/rdma/Makefile,
clang does not define host architecture macros such as __x86_64__. Including
glibc's <arpa/inet.h> pulls in <features.h> and <gnu/stubs.h>, which falls
back to <gnu/stubs-32.h> and fails on 64-bit hosts without 32-bit multilib
headers, or fails to find multiarch headers such as <sys/cdefs.h> and
<asm/types.h> without clang system include paths. In addition, calling
htons() instead of bpf_htons() from <bpf/bpf_endian.h> leaves an unresolved
external symbol call in handle_netkit_ingress() that libbpf and the bpf
verifier reject when loading the skeleton.

Also in tools/testing/selftests/rdma/Makefile, the build rules pass raw
unexported kernel headers via -I../../../../include/uapi, link against the
host -lbpf instead of building the in-tree tools/lib/bpf (which provides
bpf_program__attach_netkit()), omit rxe_pkg_common.h from the prerequisites,
and redirect bpftool output directly to $@ without cleaning up a partial
rxe_pkg_kernel.skel.h on failure. Should rxe_pkg_kernel_dump.c use
<bpf/bpf_endian.h> and bpf_htons(), and should the makefile build against
the in-tree libbpf and exported uapi headers?

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
> +				bpf_ringbuf_discard(e, 0);
> +				bpf_printk("bpf_skb_load_bytes fails\n");
> +				return BPF_OK;
> +			}
> +
> +			bpf_ringbuf_submit(e, 0);
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
> index 0000000000000..0fe6d00c198e3
> --- /dev/null
> +++ b/tools/testing/selftests/rdma/rxe_pkg_user_dump.c
> @@ -0,0 +1,1342 @@
> +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
> +/*
> + * Copyright (c) 2026 Zhu Yanjun <yanjun.zhu@linux.dev>
> + */
> +
> +#include <stdio.h>
> +#include <sys/resource.h>
> +#include <net/if.h>
> +#include "rxe_pkg_kernel.skel.h"
> +
> +#include <linux/ip.h>
> +#include <linux/udp.h>
> +#include <ctype.h>
> +
> +#include <net/ethernet.h>
> +#include <arpa/inet.h>
> +
> +#include "rxe_pkg_common.h"
> +
> +typedef unsigned char __u8;
> +typedef unsigned short __u16;
> +typedef unsigned int __u32;
> +typedef unsigned long long __u64;

[Severity: Low]
Does redefining __u64 in tools/testing/selftests/rdma/rxe_pkg_user_dump.c
cause a conflicting type error on ppc64le?

Because <linux/ip.h> and <linux/udp.h> are included above, <linux/types.h>
is already pulled in. On 64-bit powerpc (ppc64le, which the makefile
explicitly supports) as well as mips64 and alpha, the userspace uapi headers
use <asm-generic/int-l64.h> and define __u64 as unsigned long, conflicting
with this unsigned long long typedef. Could these duplicate __u8 through
__u64 typedefs be dropped in favor of <linux/types.h>?

[ ... ]

> +static void print_bpf_output(const void *data, __u32 size)
> +{
> +	/* Validate size covers IP and UDP headers */
> +	if (size < sizeof(struct iphdr) + sizeof(struct udphdr))
> +		return;
> +
> +	struct iphdr *iph =3D (struct iphdr *)data;
> +
> +	if (iph->protocol !=3D IPPROTO_UDP)
> +		return;
> +
> +	struct udphdr *udp_hdr =3D (struct udphdr *)(data + sizeof(struct iphdr=
));
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
> +	struct rxe_bth *bth =3D (struct rxe_bth *)(data + sizeof(struct iphdr)
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
> +			char *cur_p =3D (char *)bth + offset;
> +
> +			switch (i) {
> +			case	RXE_RETH:
> +				printf("RXE_RETH\n");
> +				struct rxe_reth *reth =3D (struct rxe_reth *)cur_p;
> +
> +				print_reth(reth);
> +				break;

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
> +	const struct pkg_event *e =3D data;
> +
> +	if (data_sz < sizeof(*e))
> +		return -1;
> +
> +	print_bpf_output(e->data + sizeof(struct ethhdr),
> +				e->len - sizeof(struct ethhdr));
> +
> +	return 0;
> +}

[Severity: Medium]
Can handle_event() -> print_bpf_output() read uninitialized ring-buffer
memory and overflow past e->data[]?

In handle_netkit_ingress(), bpf_ringbuf_reserve() allocates a struct
pkg_event without zeroing e->data, and bpf_skb_load_bytes() only writes the
first e->len bytes. Then in handle_event(), e->len is not checked against
sizeof(struct ethhdr) or the capacity of e->data before subtracting
sizeof(struct ethhdr) and calling print_bpf_output().

Inside print_bpf_output(), there are several bounds issues:

1. The header loop check:

	if (offset && (size >=3D sizeof(struct iphdr) + sizeof(struct udphdr) + of=
fset))

only verifies that the start pointer cur_p =3D (char *)bth + offset is with=
in
size, without checking that the full extended header struct at cur_p (such =
as
struct rxe_reth or struct rxe_atmeth) fits within size.

2. In the payload case:

	int len =3D ntohs(udp_hdr->len) - rxe_opcode[bth->opcode].length;

ntohs(udp_hdr->len) includes the 8-byte struct udphdr as well as the 4-byte
rocev2 icrc (and any bth pad count), and len is never clamped to the
remaining captured bytes in size. Because sizeof(struct udphdr) is not
subtracted, cur_p + len always extends at least 8 bytes past data + size,
reading uninitialized ring-buffer memory on every packet and reading
out-of-bounds past struct pkg_event whenever e->len is between 505 and 512
(or up to 64 kilobytes past e->data if udp_hdr->len is larger than the
captured size).

3. In rxe_opcode[], header-only opcodes such as acknowledge and rdma read
request define a non-zero payload offset, so the 4-byte trailing icrc
satisfies size >=3D sizeof(struct iphdr) + sizeof(struct udphdr) + offset a=
nd
causes print_bpf_output() to print the icrc plus 8 uninitialized or
out-of-bounds bytes as payload.

4. Because cur_p is a signed char *, passing cur_p[j] with bit 7 set is
undefined behavior in isprint() and sign-extends to a negative int in
printf("%02x", cur_p[j]). Should cur_p be unsigned char * (or cast to
unsigned char)?

> +
> +int main(void)
> +{

[ ... ]

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
> +	return err;
> +}

[Severity: Medium]
What happens when rxe_netkit_dump is run in the background with stdout
redirected to a file or pipe and is then stopped by a signal?

In main(), the while (1) loop around ring_buffer__poll() has no signal
handler for termination signals and only breaks when err < 0 && err !=3D -E=
INTR,
making the cleanup label unreachable on normal termination. In addition,
print_bpf_output() writes via printf() without flushing stdout (or setting
line buffering via setvbuf()), so when stdout is redirected to a non-tty fi=
le
or pipe, stdio block-buffers the output and discards captured packet dumps
when the process is killed. Could main() install a signal handler to break
out of the poll loop and flush stdout after dumping each packet?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021203115.5456=
0-1-yanjun.zhu@linux.dev?part=3D1
